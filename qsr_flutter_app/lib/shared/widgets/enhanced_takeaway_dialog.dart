import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/core_models.dart';
import '../widgets/scheduling_widgets.dart';
import '../widgets/payment_widgets.dart';

// Enhanced Takeaway Order Dialog with dual ordering options
class EnhancedTakeawayOrderDialog extends ConsumerStatefulWidget {
  final List<OrderItem> orderItems;
  final double totalAmount;
  final OrderScheduleConfig scheduleConfig;
  final List<PaymentMethodConfig> paymentMethods;
  final Function(Order) onOrderPlaced;

  const EnhancedTakeawayOrderDialog({
    super.key,
    required this.orderItems,
    required this.totalAmount,
    required this.scheduleConfig,
    required this.paymentMethods,
    required this.onOrderPlaced,
  });

  @override
  ConsumerState<EnhancedTakeawayOrderDialog> createState() => _EnhancedTakeawayOrderDialogState();
}

class _EnhancedTakeawayOrderDialogState extends ConsumerState<EnhancedTakeawayOrderDialog> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  
  // Order configuration
  OrderProcessingType _processingType = OrderProcessingType.immediate;
  DateTime? _scheduledDateTime;
  String _specialInstructions = '';
  
  // Customer information
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  
  // Payment configuration
  bool _allowPartialPayment = false;
  double? _partialAmount;
  List<PartialPayment> _payments = [];

  @override
  void dispose() {
    _pageController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.95,
        height: MediaQuery.of(context).size.height * 0.85,
        child: Column(
          children: [
            // Header with progress
            _buildHeader(),
            
            // Page content
            Expanded(
              child: PageView(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() {
                    _currentPage = index;
                  });
                },
                children: [
                  _buildOrderTypePage(),
                  _buildSchedulingPage(),
                  _buildCustomerInfoPage(),
                  _buildPaymentPage(),
                  _buildConfirmationPage(),
                ],
              ),
            ),
            
            // Navigation buttons
            _buildNavigationButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final steps = [
      'Order Type',
      'Schedule',
      'Customer Info',
      'Payment',
      'Confirm'
    ];
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFF9933),
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(Icons.takeout_dining, color: Colors.white, size: 24),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Takeaway Order',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 12),
          
          // Progress indicator
          Row(
            children: steps.asMap().entries.map((entry) {
              final index = entry.key;
              final step = entry.value;
              final isActive = index == _currentPage;
              final isCompleted = index < _currentPage;
              
              return Expanded(
                child: Column(
                  children: [
                    Container(
                      height: 4,
                      decoration: BoxDecoration(
                        color: isCompleted || isActive
                            ? Colors.white
                            : Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      step,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildOrderTypePage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'How would you like to place this order?',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose between immediate processing or schedule for later pickup',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          OrderTypeSelector(
            scheduleConfig: widget.scheduleConfig,
            selectedType: _processingType,
            onTypeChanged: (type) {
              setState(() {
                _processingType = type;
              });
            },
          ),
          
          const SizedBox(height: 24),
          
          // Order summary
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildSchedulingPage() {
    if (_processingType == OrderProcessingType.immediate) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.flash_on,
              size: 64,
              color: Colors.grey.shade400,
            ),
            const SizedBox(height: 16),
            Text(
              'Order Now Selected',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Your order will be processed immediately',
              style: TextStyle(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Schedule Your Order',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Select when you\'d like to pickup your order',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          SchedulePickerWidget(
            config: widget.scheduleConfig,
            selectedDateTime: _scheduledDateTime,
            onDateTimeSelected: (dateTime) {
              setState(() {
                _scheduledDateTime = dateTime;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          SpecialInstructionsWidget(
            initialValue: _specialInstructions,
            onChanged: (instructions) {
              _specialInstructions = instructions;
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerInfoPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Information',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please provide your contact details',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  TextField(
                    controller: _customerNameController,
                    decoration: InputDecoration(
                      labelText: 'Customer Name *',
                      prefixIcon: const Icon(Icons.person, color: Color(0xFFFF9933)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF9933)),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _customerPhoneController,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: 'Phone Number',
                      prefixIcon: const Icon(Icons.phone, color: Color(0xFFFF9933)),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: Color(0xFFFF9933)),
                      ),
                      helperText: _processingType == OrderProcessingType.scheduled
                          ? 'Required for pickup notifications'
                          : 'Optional for order tracking',
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          if (_processingType == OrderProcessingType.scheduled && _scheduledDateTime != null) ...[
            const SizedBox(height: 16),
            Card(
              color: Colors.blue.shade50,
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  children: [
                    Icon(Icons.info, color: Colors.blue.shade600),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'We\'ll send you a notification when your order is ready for pickup',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.blue.shade700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentPage() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Options',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Choose how you want to pay for your order',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          PaymentOptionSelector(
            totalAmount: widget.totalAmount,
            initialAllowPartial: _allowPartialPayment,
            initialPartialAmount: _partialAmount,
            onSelectionChanged: (allowPartial, partialAmount) {
              setState(() {
                _allowPartialPayment = allowPartial;
                _partialAmount = partialAmount;
                if (!allowPartial) {
                  _payments.clear();
                }
              });
            },
          ),
          
          if (_allowPartialPayment && _partialAmount != null && _partialAmount! > 0) ...[
            const SizedBox(height: 16),
            MultiMethodPaymentWidget(
              totalAmount: _partialAmount!,
              availablePaymentMethods: widget.paymentMethods,
              initialPayments: _payments,
              onPaymentsChanged: (payments) {
                setState(() {
                  _payments = payments;
                });
              },
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildConfirmationPage() {
    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();
    
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Confirmation',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Please review your order details',
            style: TextStyle(
              color: Colors.grey.shade600,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          
          // Order type confirmation
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        _processingType == OrderProcessingType.immediate
                            ? Icons.flash_on
                            : Icons.schedule,
                        color: const Color(0xFFFF9933),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        _processingType == OrderProcessingType.immediate
                            ? 'Order Now'
                            : 'Scheduled Order',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  if (_processingType == OrderProcessingType.scheduled && _scheduledDateTime != null)
                    Text(
                      'Pickup: ${_formatDateTime(_scheduledDateTime!)}',
                      style: const TextStyle(fontSize: 14),
                    )
                  else
                    const Text(
                      'Ready for immediate pickup',
                      style: TextStyle(fontSize: 14),
                    ),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Customer info confirmation
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Customer Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Name: ${customerName.isNotEmpty ? customerName : 'Not provided'}'),
                  if (customerPhone.isNotEmpty)
                    Text('Phone: $customerPhone'),
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Payment confirmation
          Card(
            elevation: 2,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Payment Details',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total Amount:'),
                      Text(
                        '₹${widget.totalAmount.toStringAsFixed(2)}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  if (_allowPartialPayment && _partialAmount != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Paying Now:'),
                        Text(
                          '₹${_partialAmount!.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('At Pickup:'),
                        Text(
                          '₹${(widget.totalAmount - _partialAmount!).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    const SizedBox(height: 4),
                    const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('Payment:'),
                        Text(
                          'Full payment at pickup',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Order items summary
          _buildOrderSummary(),
          
          if (_specialInstructions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Special Instructions',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(_specialInstructions),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Order Summary',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 12),
            ...widget.orderItems.map((item) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      '${item.quantity}x ${item.menuItem.name}',
                      style: const TextStyle(fontSize: 14),
                    ),
                  ),
                  Text(
                    '₹${item.total.toStringAsFixed(2)}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )).toList(),
            const Divider(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Total',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
                Text(
                  '₹${widget.totalAmount.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Color(0xFFFF9933),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButtons() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (_currentPage > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousPage,
                child: const Text('Back'),
              ),
            ),
          if (_currentPage > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: _canProceed() ? (_currentPage < 4 ? _nextPage : _placeOrder) : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(_currentPage < 4 ? 'Next' : 'Place Order'),
            ),
          ),
        ],
      ),
    );
  }

  bool _canProceed() {
    switch (_currentPage) {
      case 0: // Order type selection
        return true;
      case 1: // Scheduling
        return _processingType == OrderProcessingType.immediate || _scheduledDateTime != null;
      case 2: // Customer info
        return _customerNameController.text.trim().isNotEmpty;
      case 3: // Payment
        if (!_allowPartialPayment) return true;
        if (_partialAmount == null || _partialAmount! <= 0) return false;
        final totalPaid = _payments.fold(0.0, (sum, p) => sum + p.amount);
        return totalPaid >= _partialAmount!;
      case 4: // Confirmation
        return true;
      default:
        return false;
    }
  }

  void _nextPage() {
    if (_currentPage < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _placeOrder() {
    final customerName = _customerNameController.text.trim();
    final customerPhone = _customerPhoneController.text.trim();
    
    // Create customer info
    final customer = CustomerInfo(
      name: customerName.isNotEmpty ? customerName : null,
      phone: customerPhone.isNotEmpty ? customerPhone : null,
    );

    // Create base order
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    var order = Order(
      id: orderId,
      items: widget.orderItems,
      createdAt: DateTime.now(),
      type: OrderType.takeaway,
      status: _processingType == OrderProcessingType.scheduled
          ? OrderStatus.scheduled
          : OrderStatus.pending,
      customer: customer,
      processingType: _processingType,
    );

    // Add scheduling if needed
    if (_processingType == OrderProcessingType.scheduled && _scheduledDateTime != null) {
      order = order.scheduleOrder(
        _scheduledDateTime!,
        specialInstructions: _specialInstructions.isNotEmpty ? _specialInstructions : null,
        customerPhone: customerPhone.isNotEmpty ? customerPhone : null,
      );
    }

    // Add payment plan if needed
    if (_allowPartialPayment && _partialAmount != null && _partialAmount! > 0) {
      order = order.setupPaymentPlan(
        allowPartialPayment: true,
        dueAt: _scheduledDateTime,
        initialPayment: _payments.fold<double>(0.0, (sum, p) => sum + p.amount),
      );
      
      // Add individual payments
      for (final payment in _payments) {
        order = order.addPartialPayment(payment);
      }
    }

    widget.onOrderPlaced(order);
    Navigator.pop(context);
  }

  String _formatDateTime(DateTime dateTime) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    final date = '${weekdays[dateTime.weekday - 1]}, ${months[dateTime.month - 1]} ${dateTime.day}';
    final time = TimeOfDay.fromDateTime(dateTime);
    final hour = time.hour == 0 ? 12 : time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    
    return '$date at $hour:$minute $period';
  }
}
