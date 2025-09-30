import 'package:flutter/material.dart';
import '../../shared/models/enhanced_takeaway_models.dart';
import '../../shared/widgets/order_type_selector.dart';
import '../../shared/widgets/schedule_order_widget.dart';
import '../../shared/widgets/flexible_payment_widget.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/services/enhanced_takeaway_service.dart';

class EnhancedTakeawayScreen extends StatefulWidget {
  final List<Map<String, dynamic>> cartItems;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;

  const EnhancedTakeawayScreen({
    super.key,
    required this.cartItems,
    required this.subtotal,
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
  });

  @override
  State<EnhancedTakeawayScreen> createState() => _EnhancedTakeawayScreenState();
}

class _EnhancedTakeawayScreenState extends State<EnhancedTakeawayScreen> {
  final PageController _pageController = PageController();
  int currentStep = 0;
  
  // Order data
  TakeawayOrderType selectedOrderType = TakeawayOrderType.orderNow;
  ScheduleDetails? scheduleDetails;
  PaymentDetails? paymentDetails;
  
  // Customer details
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController notesController = TextEditingController();
  
  // Configuration
  late TakeawayConfig config;
  
  @override
  void initState() {
    super.initState();
    _initializeConfig();
    _initializePayment();
  }

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    notesController.dispose();
    super.dispose();
  }

  void _initializeConfig() {
    // Initialize with default configuration
    config = TakeawayConfig(
      minimumLeadTime: const Duration(hours: 2),
      maximumAdvanceTime: const Duration(days: 7),
      allowFlexibleTiming: true,
      minimumPartialPaymentPercentage: 20.0,
      acceptedPaymentMethods: [
        PaymentMethod.cash,
        PaymentMethod.card,
        PaymentMethod.upi,
        PaymentMethod.digital,
      ],
      requireCustomerDetails: true,
      maxOrdersPerTimeSlot: 10,
    );
  }

  void _initializePayment() {
    final totalAmount = widget.subtotal + widget.taxAmount - widget.discountAmount;
    paymentDetails = PaymentDetails(
      id: '',
      totalAmount: totalAmount,
      paidAmount: totalAmount,
      paymentType: PaymentType.fullPayment,
      primaryMethod: PaymentMethod.cash,
      methods: [PaymentMethod.cash],
      methodBreakdown: {PaymentMethod.cash.name: totalAmount},
    );
  }

  double get totalAmount => widget.subtotal + widget.taxAmount - widget.discountAmount;

  bool get canProceedToNext {
    switch (currentStep) {
      case 0: // Order type selection
        return true;
      case 1: // Schedule details (if needed)
        return selectedOrderType == TakeawayOrderType.orderNow ||
               (scheduleDetails?.isValidSchedule == true);
      case 2: // Customer details
        return nameController.text.trim().isNotEmpty &&
               phoneController.text.trim().isNotEmpty;
      case 3: // Payment
        return paymentDetails != null;
      default:
        return false;
    }
  }

  void _nextStep() {
    if (canProceedToNext && currentStep < 3) {
      setState(() {
        currentStep++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousStep() {
    if (currentStep > 0) {
      setState(() {
        currentStep--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> _submitOrder() async {
    if (!canProceedToNext) return;

    try {
      final order = EnhancedTakeawayOrder(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        customerName: nameController.text.trim(),
        customerPhone: phoneController.text.trim(),
        customerEmail: emailController.text.trim(),
        items: widget.cartItems,
        orderType: selectedOrderType,
        status: selectedOrderType == TakeawayOrderType.scheduleOrder 
            ? TakeawayOrderStatus.scheduled 
            : TakeawayOrderStatus.placed,
        paymentDetails: paymentDetails!,
        scheduleDetails: scheduleDetails,
        orderDate: DateTime.now(),
        notes: notesController.text.trim(),
        taxAmount: widget.taxAmount,
        discountAmount: widget.discountAmount,
      );

      // Show loading
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => const Center(
          child: CircularProgressIndicator(),
        ),
      );

      // Simulate order processing
      await Future.delayed(const Duration(seconds: 2));

      // Close loading
      Navigator.of(context).pop();

      // Show success and navigate to order confirmation
      _showOrderConfirmation(order);

    } catch (e) {
      // Handle error
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to place order: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _showOrderConfirmation(EnhancedTakeawayOrder order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => OrderConfirmationDialog(order: order),
    ).then((_) {
      // Navigate back to main screen
      Navigator.of(context).popUntil((route) => route.isFirst);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enhanced Takeaway Order'),
        backgroundColor: Colors.blue[600],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildOrderTypeStep(),
                _buildScheduleStep(),
                _buildCustomerDetailsStep(),
                _buildPaymentStep(),
              ],
            ),
          ),
          
          // Navigation Buttons
          _buildNavigationButtons(),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          for (int i = 0; i < 4; i++) ...[
            _buildStepIndicator(
              stepNumber: i + 1,
              title: _getStepTitle(i),
              isActive: i == currentStep,
              isCompleted: i < currentStep,
            ),
            if (i < 3) _buildStepConnector(isCompleted: i < currentStep),
          ],
        ],
      ),
    );
  }

  Widget _buildStepIndicator({
    required int stepNumber,
    required String title,
    required bool isActive,
    required bool isCompleted,
  }) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: isCompleted 
                  ? Colors.green 
                  : isActive 
                      ? Colors.blue[600] 
                      : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 18)
                  : Text(
                      stepNumber.toString(),
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? Colors.blue[600] : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildStepConnector({required bool isCompleted}) {
    return Container(
      height: 2,
      width: 20,
      color: isCompleted ? Colors.green : Colors.grey[300],
      margin: const EdgeInsets.only(bottom: 20),
    );
  }

  String _getStepTitle(int step) {
    switch (step) {
      case 0: return 'Order Type';
      case 1: return 'Schedule';
      case 2: return 'Details';
      case 3: return 'Payment';
      default: return '';
    }
  }

  Widget _buildOrderTypeStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TakeawayOrderHeader(
            orderType: selectedOrderType,
            scheduleDetails: scheduleDetails,
            itemCount: widget.cartItems.length,
            totalAmount: totalAmount,
          ),
          
          OrderTypeSelector(
            selectedType: selectedOrderType,
            onTypeChanged: (type) {
              setState(() {
                selectedOrderType = type;
                if (type == TakeawayOrderType.orderNow) {
                  scheduleDetails = null;
                }
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          // Order summary
          _buildOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildScheduleStep() {
    if (selectedOrderType == TakeawayOrderType.orderNow) {
      return const Center(
        child: Text('No scheduling needed for immediate orders'),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          ScheduleOrderWidget(
            initialSchedule: scheduleDetails,
            config: config,
            onScheduleChanged: (schedule) {
              setState(() {
                scheduleDetails = schedule;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerDetailsStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Customer Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: nameController,
            label: 'Full Name *',
            icon: Icons.person,
            required: true,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: phoneController,
            label: 'Phone Number *',
            icon: Icons.phone,
            keyboardType: TextInputType.phone,
            required: true,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: emailController,
            label: 'Email (Optional)',
            icon: Icons.email,
            keyboardType: TextInputType.emailAddress,
          ),
          const SizedBox(height: 16),
          
          _buildTextField(
            controller: notesController,
            label: 'Additional Notes (Optional)',
            icon: Icons.note,
            maxLines: 3,
          ),
        ],
      ),
    );
  }

  Widget _buildPaymentStep() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FlexiblePaymentWidget(
            totalAmount: totalAmount,
            initialPayment: paymentDetails,
            config: config,
            onPaymentChanged: (payment) {
              setState(() {
                paymentDetails = payment;
              });
            },
          ),
          
          const SizedBox(height: 16),
          
          _buildFinalOrderSummary(),
        ],
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType? keyboardType,
    int maxLines = 1,
    bool required = false,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey[50],
      ),
    );
  }

  Widget _buildOrderSummary() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 12),
          ...widget.cartItems.map((item) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    '${item['name']} x ${item['quantity']}',
                    style: TextStyle(color: Colors.grey[700]),
                  ),
                ),
                Text(
                  '₹${((item['price'] ?? 0) * (item['quantity'] ?? 1)).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          )).toList(),
          const Divider(),
          _buildSummaryRow('Subtotal', widget.subtotal),
          if (widget.taxAmount > 0)
            _buildSummaryRow('Tax', widget.taxAmount),
          if (widget.discountAmount > 0)
            _buildSummaryRow('Discount', -widget.discountAmount),
          const Divider(),
          _buildSummaryRow('Total', totalAmount, isTotal: true),
        ],
      ),
    );
  }

  Widget _buildFinalOrderSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.receipt, color: Colors.blue[700]),
              const SizedBox(width: 8),
              Text(
                'Final Order Summary',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          
          _buildFinalSummaryRow('Order Type', selectedOrderType == TakeawayOrderType.orderNow ? 'Order Now' : 'Scheduled Order'),
          if (scheduleDetails?.isScheduled == true)
            _buildFinalSummaryRow('Pickup', scheduleDetails!.displaySchedule),
          _buildFinalSummaryRow('Customer', nameController.text.trim()),
          _buildFinalSummaryRow('Phone', phoneController.text.trim()),
          _buildFinalSummaryRow('Payment', paymentDetails!.paymentType == PaymentType.fullPayment ? 'Full Payment' : 'Partial Payment'),
          if (paymentDetails!.paymentType == PaymentType.partialPayment)
            _buildFinalSummaryRow('Advance Amount', '₹${paymentDetails!.paidAmount.toStringAsFixed(2)}'),
          _buildFinalSummaryRow('Total Amount', '₹${totalAmount.toStringAsFixed(2)}', isHighlighted: true),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, double amount, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: Colors.grey[700],
            ),
          ),
          Text(
            '₹${amount.toStringAsFixed(2)}',
            style: TextStyle(
              fontWeight: isTotal ? FontWeight.bold : FontWeight.w600,
              fontSize: isTotal ? 16 : 14,
              color: isTotal ? Colors.green[700] : Colors.grey[800],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFinalSummaryRow(String label, String value, {bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: isHighlighted ? FontWeight.bold : FontWeight.normal,
                color: isHighlighted ? Colors.blue[700] : Colors.blue[600],
              ),
            ),
          ),
        ],
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
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          if (currentStep > 0)
            Expanded(
              child: OutlinedButton(
                onPressed: _previousStep,
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text('Previous'),
              ),
            ),
          if (currentStep > 0) const SizedBox(width: 16),
          Expanded(
            child: ElevatedButton(
              onPressed: canProceedToNext 
                  ? (currentStep < 3 ? _nextStep : _submitOrder)
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[600],
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                currentStep < 3 ? 'Next' : 'Place Order',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Order Confirmation Dialog
class OrderConfirmationDialog extends StatelessWidget {
  final EnhancedTakeawayOrder order;

  const OrderConfirmationDialog({
    super.key,
    required this.order,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: Colors.green[100],
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons.check_circle,
                color: Colors.green[600],
                size: 32,
              ),
            ),
            const SizedBox(height: 16),
            
            Text(
              'Order Placed Successfully!',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            
            Text(
              'Order ID: #${order.id}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildInfoRow('Order Type', order.statusDisplay),
                  if (order.scheduleDetails?.isScheduled == true)
                    _buildInfoRow('Pickup Time', order.scheduleDetails!.displaySchedule),
                  _buildInfoRow('Customer', order.customerName),
                  _buildInfoRow('Phone', order.customerPhone),
                  _buildInfoRow('Total Amount', '₹${order.totalAmount.toStringAsFixed(2)}'),
                  if (order.paymentDetails.paymentType == PaymentType.partialPayment)
                    _buildInfoRow('Remaining', '₹${order.paymentDetails.remainingAmount.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 24),
            
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Done',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
