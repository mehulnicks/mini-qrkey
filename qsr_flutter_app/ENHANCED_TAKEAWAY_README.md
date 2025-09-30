# Enhanced Takeaway System Documentation

## Overview

The Enhanced Takeaway System provides dual ordering options with flexible payment capabilities for QSR (Quick Service Restaurant) operations. It supports both immediate and scheduled orders with comprehensive payment tracking and real-time order management.

## 🚀 Features

### Dual Ordering Options
- **Order Now**: Immediate processing with standard takeaway flow
- **Schedule Order**: Future date/time selection with advance booking
- Minimum lead time validation (configurable)
- Time slot management with capacity control

### Flexible Payment System
- **Full Payment**: Complete amount at order placement
- **Partial Payment**: Advance payment with remaining balance due at pickup
- **Multi-method Support**: Cash, Card, UPI, Digital Wallet, Split payments
- Automatic remaining amount calculation
- Real-time payment status tracking

### Order Processing Flow
- **Immediate Orders**: Place → Prepare → Ready → Complete
- **Scheduled Orders**: Place → Hold → (Auto) Prepare → Ready → Complete
- Real-time status updates
- Kitchen notification system
- Customer communication integration

### Database Integration
- Supabase backend with real-time capabilities
- Complete order history and analytics
- Payment tracking and reconciliation
- Time slot booking management
- Row Level Security (RLS) enabled

## 📋 System Requirements

### Dependencies
```yaml
dependencies:
  flutter_riverpod: ^2.4.9
  supabase_flutter: ^2.0.0
  flutter: 
    sdk: flutter
```

### Database Setup
1. Deploy `enhanced_takeaway_schema.sql` to your Supabase project
2. Configure credentials in `lib/core/config/supabase_config.dart`
3. Ensure proper permissions are set

## 🏗️ Architecture

### File Structure
```
lib/
├── core/
│   ├── config/
│   │   └── supabase_config.dart          # Supabase configuration
│   ├── services/
│   │   └── enhanced_takeaway_service.dart # Backend service layer
│   └── providers/
│       └── enhanced_takeaway_providers.dart # Riverpod state management
├── shared/
│   ├── models/
│   │   └── enhanced_takeaway_models.dart  # Data models
│   └── widgets/
│       ├── order_type_selector.dart      # Order type UI components
│       ├── schedule_order_widget.dart    # Scheduling interface
│       └── flexible_payment_widget.dart  # Payment system UI
├── features/
│   ├── orders/
│   │   └── enhanced_takeaway_screen.dart # Main order processing screen
│   └── takeaway/
│       └── takeaway_launcher_screen.dart # Entry point screen
└── enhanced_takeaway_test_app.dart       # Comprehensive test application
```

### Database Schema
```sql
-- Main Tables
takeaway_orders          # Core order information
takeaway_order_items     # Order line items
order_schedules          # Scheduling details
order_payments           # Payment tracking
time_slots              # Available time slots
time_slot_bookings      # Slot reservations
takeaway_config         # System configuration
```

## 🔧 Configuration

### TakeawayConfig Parameters
```dart
TakeawayConfig(
  minimumLeadTime: Duration(hours: 2),         // Minimum advance notice
  maximumAdvanceTime: Duration(days: 7),       // Maximum booking window
  allowFlexibleTiming: true,                   // Allow flexible pickup times
  minimumPartialPaymentPercentage: 20.0,       // Minimum advance payment
  acceptedPaymentMethods: [                    // Supported payment methods
    PaymentMethod.cash,
    PaymentMethod.card,
    PaymentMethod.upi,
    PaymentMethod.digital,
  ],
  requireCustomerDetails: true,                // Mandatory customer info
  maxOrdersPerTimeSlot: 10,                   // Capacity per time slot
)
```

## 💻 Usage Examples

### 1. Starting a New Order
```dart
// Initialize order with cart items
final orderNotifier = ref.read(currentTakeawayOrderProvider.notifier);
orderNotifier.startNewOrder(
  items: cartItems,
  totalAmount: totalAmount,
  taxAmount: taxAmount,
  discountAmount: discountAmount,
);
```

### 2. Creating a Scheduled Order
```dart
// Set order type to scheduled
orderNotifier.updateOrderType(TakeawayOrderType.scheduleOrder);

// Configure schedule details
final schedule = ScheduleDetails(
  scheduledDate: DateTime.now().add(Duration(days: 1)),
  timeSlot: selectedTimeSlot,
  specialInstructions: 'Please call when ready',
  minimumLeadTime: Duration(hours: 2),
  isFlexibleTime: false,
);
orderNotifier.updateScheduleDetails(schedule);
```

### 3. Setting Up Partial Payment
```dart
// Configure partial payment
final payment = PaymentDetails(
  id: '',
  totalAmount: 500.0,
  paidAmount: 100.0,              // 20% advance
  paymentType: PaymentType.partialPayment,
  primaryMethod: PaymentMethod.upi,
  methods: [PaymentMethod.upi],
  methodBreakdown: {PaymentMethod.upi: 100.0},
);
orderNotifier.updatePaymentDetails(payment);
```

### 4. Submitting an Order
```dart
// Submit order to database
final submissionNotifier = ref.read(orderSubmissionProvider.notifier);
final orderId = await submissionNotifier.submitOrder(currentOrder);

if (orderId != null) {
  // Order created successfully
  print('Order created with ID: $orderId');
} else {
  // Handle error
  print('Failed to create order');
}
```

### 5. Real-time Order Monitoring
```dart
// Subscribe to order updates
final ordersStream = ref.watch(realTimeOrdersProvider(null));

ordersStream.when(
  data: (orders) => ListView.builder(
    itemCount: orders.length,
    itemBuilder: (context, index) => OrderCard(order: orders[index]),
  ),
  loading: () => CircularProgressIndicator(),
  error: (error, stack) => Text('Error: $error'),
);
```

## 🎯 Testing

### Running Tests
```bash
# Run the comprehensive test application
flutter run -t lib/enhanced_takeaway_main.dart
```

### Test Categories
1. **Order Type Tests**: Validate immediate vs scheduled ordering
2. **Payment Tests**: Test full and partial payment flows
3. **Database Tests**: Verify CRUD operations
4. **Time Slot Tests**: Check availability and booking
5. **Integration Tests**: End-to-end workflow validation

### Sample Test Data
```dart
// Sample cart items for testing
final testCartItems = [
  {
    'name': 'Margherita Pizza',
    'price': 299.0,
    'quantity': 2,
    'instructions': 'Extra cheese',
  },
  {
    'name': 'Chicken Burger',
    'price': 199.0,
    'quantity': 1,
    'instructions': 'No onions',
  },
];
```

## 🔄 Order Status Flow

### Immediate Orders
```
placed → confirmed → preparing → ready → completed
```

### Scheduled Orders
```
scheduled → (auto at scheduled time) → confirmed → preparing → ready → completed
```

### Status Descriptions
- **placed**: Order received and queued
- **confirmed**: Order acknowledged by kitchen
- **preparing**: Actively being prepared
- **ready**: Ready for customer pickup
- **completed**: Order fulfilled and closed
- **cancelled**: Order cancelled (with refund if applicable)
- **scheduled**: Future order waiting for scheduled time

## 💳 Payment Status Flow

### Full Payment
```
pending → completed
```

### Partial Payment
```
pending → partial → completed
```

### Payment Descriptions
- **pending**: No payment received
- **partial**: Advance payment received, balance pending
- **completed**: Full payment received
- **refunded**: Payment refunded due to cancellation

## 📊 Analytics & Reporting

### Available Statistics
```dart
final stats = await service.getTakeawayStats(
  fromDate: DateTime.now().subtract(Duration(days: 30)),
  toDate: DateTime.now(),
);

// Returns:
// - total_orders: Number of orders
// - total_revenue: Total sales amount
// - average_order_value: Average order size
// - scheduled_orders_count: Scheduled orders
// - immediate_orders_count: Immediate orders
// - partial_payments_count: Partial payment orders
// - pending_payments: Outstanding balance
```

### Real-time Dashboard
The system provides real-time dashboards showing:
- Today's order count and revenue
- Pending orders requiring attention
- Scheduled orders for the day
- Payment status overview
- Kitchen workflow status

## 🚨 Error Handling

### Common Issues and Solutions

1. **Database Connection Failed**
   - Check Supabase credentials
   - Verify network connectivity
   - Ensure schema is deployed

2. **Order Submission Failed**
   - Validate all required fields
   - Check payment details
   - Verify customer information

3. **Time Slot Unavailable**
   - Check slot capacity
   - Verify minimum lead time
   - Refresh available slots

4. **Payment Processing Error**
   - Validate payment amounts
   - Check method support
   - Verify calculation logic

## 🔒 Security Features

### Row Level Security (RLS)
- All tables have RLS enabled
- Staff authentication required
- Role-based access control
- Audit trail maintenance

### Data Validation
- Input sanitization
- Type checking
- Business rule validation
- SQL injection prevention

## 🚀 Deployment

### Production Checklist
1. ✅ Deploy database schema
2. ✅ Configure production Supabase credentials
3. ✅ Set up proper RLS policies
4. ✅ Configure payment gateways
5. ✅ Test all order flows
6. ✅ Set up monitoring and alerts
7. ✅ Train staff on system usage

### Performance Optimization
- Database indexing for fast queries
- Real-time subscription management
- Efficient state management with Riverpod
- Lazy loading for large order lists
- Connection pooling for database operations

## 📈 Future Enhancements

### Planned Features
- [ ] SMS/Email notifications
- [ ] Integration with POS systems
- [ ] Loyalty program support
- [ ] Advanced analytics dashboard
- [ ] Multi-location support
- [ ] Inventory integration
- [ ] Customer rating system
- [ ] Automated pricing rules

### Technical Improvements
- [ ] Offline capability
- [ ] Progressive Web App (PWA) support
- [ ] Voice ordering integration
- [ ] AI-powered demand prediction
- [ ] Advanced reporting tools

## 📞 Support

For technical support or questions:
1. Check the test application for comprehensive examples
2. Review the database schema documentation
3. Validate configuration settings
4. Test with sample data first

## 📄 License

This enhanced takeaway system is part of the QSR Flutter application and follows the same licensing terms.

---

**Note**: This system is designed to be production-ready with comprehensive error handling, real-time capabilities, and scalable architecture. Always test thoroughly in a development environment before deploying to production.
