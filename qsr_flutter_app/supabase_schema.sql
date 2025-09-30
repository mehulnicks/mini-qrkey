-- QSR Flutter App Database Schema for Supabase
-- Run these commands in your Supabase SQL editor

-- Create orders table
CREATE TABLE IF NOT EXISTS orders (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_number VARCHAR(50) UNIQUE NOT NULL,
    customer_name VARCHAR(255),
    customer_phone VARCHAR(20),
    order_type VARCHAR(20) CHECK (order_type IN ('dine_in', 'takeaway', 'delivery')) DEFAULT 'dine_in',
    table_number INTEGER,
    status VARCHAR(20) CHECK (status IN ('pending', 'preparing', 'ready', 'completed', 'cancelled')) DEFAULT 'pending',
    items JSONB NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL DEFAULT 0,
    tax_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    discount_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10,2) NOT NULL DEFAULT 0,
    payment_method VARCHAR(50),
    payment_status VARCHAR(20) CHECK (payment_status IN ('pending', 'paid', 'failed', 'refunded')) DEFAULT 'pending',
    notes TEXT,
    scheduled_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

-- Create menu_items table
CREATE TABLE IF NOT EXISTS menu_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    category VARCHAR(100) NOT NULL,
    price DECIMAL(10,2) NOT NULL,
    image_url TEXT,
    is_available BOOLEAN DEFAULT true,
    preparation_time INTEGER DEFAULT 0, -- in minutes
    ingredients JSONB,
    allergens TEXT[],
    nutritional_info JSONB,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_by UUID REFERENCES auth.users(id),
    updated_by UUID REFERENCES auth.users(id)
);

-- Create categories table
CREATE TABLE IF NOT EXISTS categories (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    display_order INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create tables table (for restaurant tables)
CREATE TABLE IF NOT EXISTS restaurant_tables (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    table_number INTEGER UNIQUE NOT NULL,
    capacity INTEGER NOT NULL DEFAULT 4,
    location VARCHAR(100),
    status VARCHAR(20) CHECK (status IN ('available', 'occupied', 'reserved', 'maintenance')) DEFAULT 'available',
    qr_code TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create order_items table (for detailed order items)
CREATE TABLE IF NOT EXISTS order_items (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    order_id UUID REFERENCES orders(id) ON DELETE CASCADE,
    menu_item_id UUID REFERENCES menu_items(id),
    quantity INTEGER NOT NULL DEFAULT 1,
    unit_price DECIMAL(10,2) NOT NULL,
    total_price DECIMAL(10,2) NOT NULL,
    customizations JSONB,
    special_instructions TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create customers table
CREATE TABLE IF NOT EXISTS customers (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) UNIQUE,
    phone VARCHAR(20) UNIQUE,
    address JSONB,
    preferences JSONB,
    total_orders INTEGER DEFAULT 0,
    total_spent DECIMAL(10,2) DEFAULT 0,
    loyalty_points INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create staff table
CREATE TABLE IF NOT EXISTS staff (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) UNIQUE,
    employee_id VARCHAR(50) UNIQUE NOT NULL,
    name VARCHAR(255) NOT NULL,
    role VARCHAR(50) CHECK (role IN ('admin', 'manager', 'waiter', 'chef', 'cashier')) NOT NULL,
    permissions JSONB,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create indexes for better performance
CREATE INDEX idx_orders_status ON orders(status);
CREATE INDEX idx_orders_created_at ON orders(created_at);
CREATE INDEX idx_orders_order_number ON orders(order_number);
CREATE INDEX idx_menu_items_category ON menu_items(category);
CREATE INDEX idx_menu_items_is_available ON menu_items(is_available);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
CREATE INDEX idx_customers_phone ON customers(phone);
CREATE INDEX idx_customers_email ON customers(email);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_orders_updated_at BEFORE UPDATE ON orders
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_menu_items_updated_at BEFORE UPDATE ON menu_items
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_categories_updated_at BEFORE UPDATE ON categories
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_restaurant_tables_updated_at BEFORE UPDATE ON restaurant_tables
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_customers_updated_at BEFORE UPDATE ON customers
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_staff_updated_at BEFORE UPDATE ON staff
    FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert default categories
INSERT INTO categories (name, description, display_order) VALUES
('Appetizers', 'Start your meal with our delicious appetizers', 1),
('Main Courses', 'Hearty main dishes', 2),
('Beverages', 'Hot and cold drinks', 3),
('Desserts', 'Sweet treats to end your meal', 4)
ON CONFLICT (name) DO NOTHING;

-- Insert sample menu items
INSERT INTO menu_items (name, description, category, price, is_available) VALUES
('Chicken Tikka', 'Grilled chicken marinated in spices', 'Main Courses', 15.99, true),
('Vegetable Samosa', 'Crispy pastry filled with spiced vegetables', 'Appetizers', 6.99, true),
('Mango Lassi', 'Refreshing yogurt drink with mango', 'Beverages', 4.99, true),
('Gulab Jamun', 'Sweet milk dumplings in syrup', 'Desserts', 5.99, true)
ON CONFLICT DO NOTHING;

-- Insert sample restaurant tables
INSERT INTO restaurant_tables (table_number, capacity, location, status) VALUES
(1, 4, 'Window Section', 'available'),
(2, 2, 'Corner', 'available'),
(3, 6, 'Center Hall', 'available'),
(4, 4, 'Near Kitchen', 'available'),
(5, 8, 'Private Room', 'available')
ON CONFLICT (table_number) DO NOTHING;

-- Row Level Security Policies

-- Enable RLS on all tables
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE menu_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE categories ENABLE ROW LEVEL SECURITY;
ALTER TABLE restaurant_tables ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE customers ENABLE ROW LEVEL SECURITY;
ALTER TABLE staff ENABLE ROW LEVEL SECURITY;

-- Policies for orders table
CREATE POLICY "Users can view all orders" ON orders FOR SELECT USING (true);
CREATE POLICY "Users can insert orders" ON orders FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update orders" ON orders FOR UPDATE USING (true);

-- Policies for menu_items table
CREATE POLICY "Anyone can view available menu items" ON menu_items FOR SELECT USING (is_available = true);
CREATE POLICY "Authenticated users can manage menu items" ON menu_items FOR ALL USING (auth.role() = 'authenticated');

-- Policies for categories table
CREATE POLICY "Anyone can view active categories" ON categories FOR SELECT USING (is_active = true);
CREATE POLICY "Authenticated users can manage categories" ON categories FOR ALL USING (auth.role() = 'authenticated');

-- Policies for restaurant_tables table
CREATE POLICY "Users can view all tables" ON restaurant_tables FOR SELECT USING (true);
CREATE POLICY "Authenticated users can manage tables" ON restaurant_tables FOR ALL USING (auth.role() = 'authenticated');

-- Policies for order_items table
CREATE POLICY "Users can view all order items" ON order_items FOR SELECT USING (true);
CREATE POLICY "Users can insert order items" ON order_items FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update order items" ON order_items FOR UPDATE USING (true);

-- Policies for customers table
CREATE POLICY "Users can view customers" ON customers FOR SELECT USING (true);
CREATE POLICY "Users can insert customers" ON customers FOR INSERT WITH CHECK (true);
CREATE POLICY "Users can update customers" ON customers FOR UPDATE USING (true);

-- Policies for staff table
CREATE POLICY "Staff can view staff records" ON staff FOR SELECT USING (auth.role() = 'authenticated');
CREATE POLICY "Admins can manage staff" ON staff FOR ALL USING (
  EXISTS (
    SELECT 1 FROM staff 
    WHERE user_id = auth.uid() AND role IN ('admin', 'manager')
  )
);

-- Create a function to get order statistics
CREATE OR REPLACE FUNCTION get_order_stats(start_date DATE DEFAULT CURRENT_DATE, end_date DATE DEFAULT CURRENT_DATE)
RETURNS TABLE (
  total_orders BIGINT,
  total_revenue DECIMAL,
  avg_order_value DECIMAL,
  pending_orders BIGINT,
  completed_orders BIGINT
) AS $$
BEGIN
  RETURN QUERY
  SELECT 
    COUNT(*) as total_orders,
    COALESCE(SUM(total_amount), 0) as total_revenue,
    COALESCE(AVG(total_amount), 0) as avg_order_value,
    COUNT(*) FILTER (WHERE status = 'pending') as pending_orders,
    COUNT(*) FILTER (WHERE status = 'completed') as completed_orders
  FROM orders 
  WHERE DATE(created_at) BETWEEN start_date AND end_date;
END;
$$ LANGUAGE plpgsql;

-- Create a function to update customer stats
CREATE OR REPLACE FUNCTION update_customer_stats()
RETURNS TRIGGER AS $$
BEGIN
  IF TG_OP = 'INSERT' OR (TG_OP = 'UPDATE' AND OLD.status != NEW.status AND NEW.status = 'completed') THEN
    UPDATE customers 
    SET 
      total_orders = (
        SELECT COUNT(*) FROM orders 
        WHERE customer_phone = NEW.customer_phone AND status = 'completed'
      ),
      total_spent = (
        SELECT COALESCE(SUM(total_amount), 0) FROM orders 
        WHERE customer_phone = NEW.customer_phone AND status = 'completed'
      ),
      loyalty_points = loyalty_points + FLOOR(NEW.total_amount)::INTEGER
    WHERE phone = NEW.customer_phone;
    
    -- Insert customer if not exists
    INSERT INTO customers (name, phone, total_orders, total_spent, loyalty_points)
    VALUES (NEW.customer_name, NEW.customer_phone, 1, NEW.total_amount, FLOOR(NEW.total_amount)::INTEGER)
    ON CONFLICT (phone) DO NOTHING;
  END IF;
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create trigger for customer stats
CREATE TRIGGER update_customer_stats_trigger
  AFTER INSERT OR UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_customer_stats();
