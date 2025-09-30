-- Enhanced Takeaway System Database Schema
-- This extends the existing Supabase schema with takeaway-specific tables

-- Takeaway Orders Table
CREATE TABLE IF NOT EXISTS takeaway_orders (
    id TEXT PRIMARY KEY,
    customer_name TEXT NOT NULL,
    customer_phone TEXT NOT NULL,
    customer_email TEXT,
    order_type TEXT NOT NULL CHECK (order_type IN ('orderNow', 'scheduleOrder')),
    status TEXT NOT NULL DEFAULT 'placed' CHECK (status IN ('placed', 'confirmed', 'preparing', 'ready', 'completed', 'cancelled', 'scheduled')),
    order_date TIMESTAMPTZ NOT NULL DEFAULT NOW(),
    estimated_pickup_time TIMESTAMPTZ,
    actual_pickup_time TIMESTAMPTZ,
    notes TEXT,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    requires_kitchen_notification BOOLEAN DEFAULT true,
    payment_details JSONB,
    schedule_details JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Takeaway Order Items Table
CREATE TABLE IF NOT EXISTS takeaway_order_items (
    id BIGSERIAL PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES takeaway_orders(id) ON DELETE CASCADE,
    item_name TEXT NOT NULL,
    item_price DECIMAL(10,2) NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    subtotal DECIMAL(10,2) NOT NULL,
    special_instructions TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Order Schedules Table
CREATE TABLE IF NOT EXISTS order_schedules (
    id BIGSERIAL PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES takeaway_orders(id) ON DELETE CASCADE,
    scheduled_date TIMESTAMPTZ NOT NULL,
    time_slot_id TEXT,
    special_instructions TEXT,
    minimum_lead_time_hours INTEGER DEFAULT 2,
    is_flexible_time BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(order_id)
);

-- Order Payments Table
CREATE TABLE IF NOT EXISTS order_payments (
    id BIGSERIAL PRIMARY KEY,
    order_id TEXT NOT NULL REFERENCES takeaway_orders(id) ON DELETE CASCADE,
    total_amount DECIMAL(10,2) NOT NULL,
    paid_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    remaining_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_type TEXT NOT NULL CHECK (payment_type IN ('fullPayment', 'partialPayment')),
    primary_method TEXT NOT NULL CHECK (primary_method IN ('cash', 'card', 'upi', 'digital', 'split')),
    methods JSONB,
    status TEXT NOT NULL DEFAULT 'pending' CHECK (status IN ('pending', 'partial', 'completed', 'refunded')),
    payment_date TIMESTAMPTZ,
    full_payment_date TIMESTAMPTZ,
    method_breakdown JSONB,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(order_id)
);

-- Time Slots Table
CREATE TABLE IF NOT EXISTS time_slots (
    id TEXT PRIMARY KEY,
    date DATE NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    is_available BOOLEAN DEFAULT true,
    max_orders INTEGER DEFAULT 10,
    current_orders INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(date, start_time)
);

-- Time Slot Bookings Table
CREATE TABLE IF NOT EXISTS time_slot_bookings (
    id BIGSERIAL PRIMARY KEY,
    slot_id TEXT NOT NULL REFERENCES time_slots(id) ON DELETE CASCADE,
    order_id TEXT NOT NULL REFERENCES takeaway_orders(id) ON DELETE CASCADE,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(slot_id, order_id)
);

-- Takeaway Configuration Table
CREATE TABLE IF NOT EXISTS takeaway_config (
    id BIGSERIAL PRIMARY KEY,
    minimum_lead_time_hours INTEGER DEFAULT 2,
    maximum_advance_time_days INTEGER DEFAULT 7,
    allow_flexible_timing BOOLEAN DEFAULT true,
    minimum_partial_payment_percentage DECIMAL(5,2) DEFAULT 20.00,
    accepted_payment_methods JSONB DEFAULT '["cash", "card", "upi"]',
    require_customer_details BOOLEAN DEFAULT true,
    max_orders_per_time_slot INTEGER DEFAULT 10,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- Insert default configuration
INSERT INTO takeaway_config (
    minimum_lead_time_hours,
    maximum_advance_time_days,
    allow_flexible_timing,
    minimum_partial_payment_percentage,
    accepted_payment_methods,
    require_customer_details,
    max_orders_per_time_slot
) VALUES (
    2,
    7,
    true,
    20.00,
    '["cash", "card", "upi", "digital"]',
    true,
    10
) ON CONFLICT DO NOTHING;

-- Indexes for better performance
CREATE INDEX IF NOT EXISTS idx_takeaway_orders_status ON takeaway_orders(status);
CREATE INDEX IF NOT EXISTS idx_takeaway_orders_type ON takeaway_orders(order_type);
CREATE INDEX IF NOT EXISTS idx_takeaway_orders_date ON takeaway_orders(order_date);
CREATE INDEX IF NOT EXISTS idx_takeaway_orders_customer_phone ON takeaway_orders(customer_phone);
CREATE INDEX IF NOT EXISTS idx_takeaway_orders_customer_name ON takeaway_orders(customer_name);
CREATE INDEX IF NOT EXISTS idx_takeaway_order_items_order_id ON takeaway_order_items(order_id);
CREATE INDEX IF NOT EXISTS idx_order_schedules_scheduled_date ON order_schedules(scheduled_date);
CREATE INDEX IF NOT EXISTS idx_order_payments_status ON order_payments(status);
CREATE INDEX IF NOT EXISTS idx_time_slots_date ON time_slots(date);
CREATE INDEX IF NOT EXISTS idx_time_slots_available ON time_slots(is_available);

-- Function to update remaining amount automatically
CREATE OR REPLACE FUNCTION update_remaining_amount()
RETURNS TRIGGER AS $$
BEGIN
    NEW.remaining_amount = NEW.total_amount - NEW.paid_amount;
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger for order_payments
CREATE TRIGGER trigger_update_remaining_amount
    BEFORE UPDATE ON order_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_remaining_amount();

-- Function to increment time slot bookings
CREATE OR REPLACE FUNCTION increment_slot_bookings(slot_id TEXT, order_id TEXT)
RETURNS VOID AS $$
BEGIN
    -- Insert booking record
    INSERT INTO time_slot_bookings (slot_id, order_id) 
    VALUES (slot_id, order_id)
    ON CONFLICT (slot_id, order_id) DO NOTHING;
    
    -- Update current_orders count
    UPDATE time_slots 
    SET current_orders = current_orders + 1,
        updated_at = NOW()
    WHERE id = slot_id
    AND current_orders < max_orders;
END;
$$ LANGUAGE plpgsql;

-- Function to get takeaway statistics
CREATE OR REPLACE FUNCTION get_takeaway_stats(from_date TIMESTAMPTZ, to_date TIMESTAMPTZ)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_orders', COUNT(*),
        'total_revenue', COALESCE(SUM(total_amount), 0),
        'average_order_value', COALESCE(AVG(total_amount), 0),
        'scheduled_orders_count', COUNT(*) FILTER (WHERE order_type = 'scheduleOrder'),
        'immediate_orders_count', COUNT(*) FILTER (WHERE order_type = 'orderNow'),
        'completed_orders', COUNT(*) FILTER (WHERE status = 'completed'),
        'pending_orders', COUNT(*) FILTER (WHERE status IN ('placed', 'confirmed', 'preparing', 'ready')),
        'cancelled_orders', COUNT(*) FILTER (WHERE status = 'cancelled')
    ) INTO result
    FROM takeaway_orders
    WHERE order_date >= from_date AND order_date <= to_date;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to get payment statistics
CREATE OR REPLACE FUNCTION get_payment_stats(from_date TIMESTAMPTZ, to_date TIMESTAMPTZ)
RETURNS JSON AS $$
DECLARE
    result JSON;
BEGIN
    SELECT json_build_object(
        'total_payments', COUNT(*),
        'total_paid_amount', COALESCE(SUM(paid_amount), 0),
        'total_pending_amount', COALESCE(SUM(remaining_amount), 0),
        'full_payments_count', COUNT(*) FILTER (WHERE payment_type = 'fullPayment'),
        'partial_payments_count', COUNT(*) FILTER (WHERE payment_type = 'partialPayment'),
        'completed_payments', COUNT(*) FILTER (WHERE status = 'completed'),
        'pending_payments', COUNT(*) FILTER (WHERE status IN ('pending', 'partial'))
    ) INTO result
    FROM order_payments op
    JOIN takeaway_orders to_ord ON op.order_id = to_ord.id
    WHERE to_ord.order_date >= from_date AND to_ord.order_date <= to_date;
    
    RETURN result;
END;
$$ LANGUAGE plpgsql;

-- Function to auto-update order status based on schedule
CREATE OR REPLACE FUNCTION auto_update_scheduled_orders()
RETURNS VOID AS $$
BEGIN
    -- Update scheduled orders to preparing when it's time
    UPDATE takeaway_orders 
    SET status = 'confirmed',
        updated_at = NOW()
    WHERE status = 'scheduled' 
    AND id IN (
        SELECT to_ord.id 
        FROM takeaway_orders to_ord
        JOIN order_schedules os ON to_ord.id = os.order_id
        WHERE os.scheduled_date <= NOW() + INTERVAL '30 minutes'
    );
END;
$$ LANGUAGE plpgsql;

-- Trigger to automatically update takeaway_orders.updated_at
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER update_takeaway_orders_updated_at
    BEFORE UPDATE ON takeaway_orders
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_order_payments_updated_at
    BEFORE UPDATE ON order_payments
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_time_slots_updated_at
    BEFORE UPDATE ON time_slots
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- Row Level Security (RLS) Policies
ALTER TABLE takeaway_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE takeaway_order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_schedules ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_payments ENABLE ROW LEVEL SECURITY;
ALTER TABLE time_slots ENABLE ROW LEVEL SECURITY;
ALTER TABLE time_slot_bookings ENABLE ROW LEVEL SECURITY;
ALTER TABLE takeaway_config ENABLE ROW LEVEL SECURITY;

-- Policies for authenticated users (staff/admin)
CREATE POLICY "Staff can manage takeaway orders" ON takeaway_orders
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can manage order items" ON takeaway_order_items
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can manage schedules" ON order_schedules
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can manage payments" ON order_payments
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can manage time slots" ON time_slots
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can manage bookings" ON time_slot_bookings
    FOR ALL USING (auth.role() = 'authenticated');

CREATE POLICY "Staff can view config" ON takeaway_config
    FOR SELECT USING (auth.role() = 'authenticated');

-- Insert sample time slots for next 7 days
DO $$
DECLARE
    slot_date DATE;
    slot_hour INTEGER;
    slot_minute INTEGER;
    slot_start TIME;
    slot_end TIME;
    slot_id TEXT;
BEGIN
    FOR day_offset IN 0..6 LOOP
        slot_date := CURRENT_DATE + day_offset;
        
        FOR slot_hour IN 9..21 LOOP
            FOR slot_minute IN 0..30 BY 30 LOOP
                slot_start := (slot_hour || ':' || LPAD(slot_minute::TEXT, 2, '0'))::TIME;
                slot_end := (slot_start + INTERVAL '30 minutes')::TIME;
                slot_id := slot_date::TEXT || '_' || slot_hour || '_' || slot_minute;
                
                INSERT INTO time_slots (id, date, start_time, end_time, is_available, max_orders, current_orders)
                VALUES (slot_id, slot_date, slot_start, slot_end, true, 10, 0)
                ON CONFLICT (date, start_time) DO NOTHING;
            END LOOP;
        END LOOP;
    END LOOP;
END $$;

-- Create a view for order summary with payment status
CREATE OR REPLACE VIEW takeaway_orders_summary AS
SELECT 
    to_ord.*,
    op.payment_type,
    op.paid_amount,
    op.remaining_amount,
    op.status as payment_status,
    os.scheduled_date,
    os.is_flexible_time,
    CASE 
        WHEN to_ord.order_type = 'scheduleOrder' AND os.scheduled_date IS NOT NULL 
        THEN to_char(os.scheduled_date, 'DD/MM/YYYY HH24:MI')
        ELSE 'Immediate'
    END as pickup_display
FROM takeaway_orders to_ord
LEFT JOIN order_payments op ON to_ord.id = op.order_id
LEFT JOIN order_schedules os ON to_ord.id = os.order_id;

COMMENT ON TABLE takeaway_orders IS 'Enhanced takeaway orders with dual ordering options';
COMMENT ON TABLE takeaway_order_items IS 'Items in takeaway orders';
COMMENT ON TABLE order_schedules IS 'Scheduling details for future orders';
COMMENT ON TABLE order_payments IS 'Payment tracking with partial payment support';
COMMENT ON TABLE time_slots IS 'Available time slots for scheduled orders';
COMMENT ON TABLE time_slot_bookings IS 'Bookings for specific time slots';
COMMENT ON TABLE takeaway_config IS 'Configuration for takeaway system';
COMMENT ON VIEW takeaway_orders_summary IS 'Summary view with payment and schedule info';
