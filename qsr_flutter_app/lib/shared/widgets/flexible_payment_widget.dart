import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../models/enhanced_takeaway_models.dart';

class FlexiblePaymentWidget extends StatefulWidget {
  final double totalAmount;
  final PaymentDetails? initialPayment;
  final TakeawayConfig config;
  final Function(PaymentDetails) onPaymentChanged;
  final bool enabled;

  const FlexiblePaymentWidget({
    super.key,
    required this.totalAmount,
    this.initialPayment,
    required this.config,
    required this.onPaymentChanged,
    this.enabled = true,
  });

  @override
  State<FlexiblePaymentWidget> createState() => _FlexiblePaymentWidgetState();
}

class _FlexiblePaymentWidgetState extends State<FlexiblePaymentWidget> {
  PaymentType selectedPaymentType = PaymentType.fullPayment;
  PaymentMethod primaryMethod = PaymentMethod.cash;
  List<PaymentMethod> selectedMethods = [PaymentMethod.cash];
  Map<String, double> methodAmounts = {};
  TextEditingController partialAmountController = TextEditingController();
  double partialAmount = 0.0;

  @override
  void initState() {
    super.initState();
    if (widget.initialPayment != null) {
      selectedPaymentType = widget.initialPayment!.paymentType;
      primaryMethod = widget.initialPayment!.primaryMethod;
      selectedMethods = widget.initialPayment!.methods.isNotEmpty 
          ? widget.initialPayment!.methods 
          : [widget.initialPayment!.primaryMethod];
      methodAmounts = Map.from(widget.initialPayment!.methodBreakdown);
      partialAmount = widget.initialPayment!.paidAmount;
      partialAmountController.text = partialAmount > 0 ? partialAmount.toStringAsFixed(2) : '';
    } else {
      _initializeDefaults();
    }
  }

  @override
  void dispose() {
    partialAmountController.dispose();
    super.dispose();
  }

  void _initializeDefaults() {
    primaryMethod = widget.config.acceptedPaymentMethods.first;
    selectedMethods = [primaryMethod];
    methodAmounts = {primaryMethod.name: widget.totalAmount};
    _updatePayment();
  }

  void _updatePayment() {
    final paidAmount = selectedPaymentType == PaymentType.fullPayment 
        ? widget.totalAmount 
        : partialAmount;

    final payment = PaymentDetails(
      id: widget.initialPayment?.id ?? '',
      totalAmount: widget.totalAmount,
      paidAmount: paidAmount,
      paymentType: selectedPaymentType,
      primaryMethod: primaryMethod,
      methods: selectedMethods,
      status: paidAmount >= widget.totalAmount 
          ? PaymentStatus.completed 
          : paidAmount > 0 
              ? PaymentStatus.partial 
              : PaymentStatus.pending,
      methodBreakdown: methodAmounts,
    );

    widget.onPaymentChanged(payment);
  }

  void _distributeAmountEvenly() {
    if (selectedMethods.isEmpty) return;

    final totalToPay = selectedPaymentType == PaymentType.fullPayment 
        ? widget.totalAmount 
        : partialAmount;
    
    final amountPerMethod = totalToPay / selectedMethods.length;
    
    setState(() {
      methodAmounts.clear();
      for (var method in selectedMethods) {
        methodAmounts[method.name] = amountPerMethod;
      }
    });
    
    _updatePayment();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.green[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.payment, color: Colors.green[700]),
                const SizedBox(width: 8),
                Text(
                  'Payment Options',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[700],
                  ),
                ),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Amount Summary
                _buildAmountSummary(),
                const SizedBox(height: 16),

                // Payment Type Selection
                _buildPaymentTypeSelector(),
                const SizedBox(height: 16),

                // Partial Payment Amount Input
                if (selectedPaymentType == PaymentType.partialPayment) ...[
                  _buildPartialAmountInput(),
                  const SizedBox(height: 16),
                ],

                // Payment Method Selection
                _buildPaymentMethodSelector(),
                const SizedBox(height: 16),

                // Multi-method breakdown
                if (selectedMethods.length > 1) ...[
                  _buildMethodBreakdown(),
                  const SizedBox(height: 16),
                ],

                // Payment Summary
                _buildPaymentSummary(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAmountSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[300]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Order Amount',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey[800],
                ),
              ),
              Text(
                '₹${widget.totalAmount.toStringAsFixed(2)}',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.green[700],
                ),
              ),
            ],
          ),
          if (selectedPaymentType == PaymentType.partialPayment && partialAmount > 0) ...[
            const SizedBox(height: 8),
            const Divider(),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Paying Now',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[700],
                  ),
                ),
                Text(
                  '₹${partialAmount.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.green[600],
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Remaining Balance',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.orange[700],
                  ),
                ),
                Text(
                  '₹${(widget.totalAmount - partialAmount).toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange[600],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPaymentTypeSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildPaymentTypeCard(
                type: PaymentType.fullPayment,
                title: 'Full Payment',
                subtitle: 'Pay complete amount now',
                icon: Icons.payment,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _buildPaymentTypeCard(
                type: PaymentType.partialPayment,
                title: 'Partial Payment',
                subtitle: 'Pay advance, rest later',
                icon: Icons.payments,
                color: Colors.orange,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentTypeCard({
    required PaymentType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    final isSelected = selectedPaymentType == type;
    
    return GestureDetector(
      onTap: widget.enabled ? () {
        setState(() {
          selectedPaymentType = type;
          if (type == PaymentType.fullPayment) {
            partialAmount = widget.totalAmount;
            partialAmountController.text = widget.totalAmount.toStringAsFixed(2);
            _distributeAmountEvenly();
          } else {
            // Set minimum partial payment
            final minAmount = widget.totalAmount * (widget.config.minimumPartialPaymentPercentage / 100);
            partialAmount = minAmount;
            partialAmountController.text = minAmount.toStringAsFixed(2);
          }
        });
        _updatePayment();
      } : null,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? color : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? color : Colors.grey[600],
              size: 24,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: isSelected ? color : Colors.grey[800],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 11,
                color: isSelected ? color.withOpacity(0.8) : Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPartialAmountInput() {
    final minAmount = widget.totalAmount * (widget.config.minimumPartialPaymentPercentage / 100);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Advance Payment Amount',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            Text(
              'Min: ₹${minAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: partialAmountController,
          enabled: widget.enabled,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'^\d+\.?\d{0,2}')),
          ],
          decoration: InputDecoration(
            hintText: 'Enter advance amount',
            prefixText: '₹ ',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          onChanged: (value) {
            final amount = double.tryParse(value) ?? 0.0;
            if (amount >= minAmount && amount <= widget.totalAmount) {
              setState(() {
                partialAmount = amount;
              });
              _distributeAmountEvenly();
            }
          },
        ),
        const SizedBox(height: 8),
        LinearProgressIndicator(
          value: partialAmount / widget.totalAmount,
          backgroundColor: Colors.grey[300],
          valueColor: AlwaysStoppedAnimation<Color>(Colors.orange[600]!),
        ),
        const SizedBox(height: 4),
        Text(
          '${(partialAmount / widget.totalAmount * 100).toStringAsFixed(1)}% of total amount',
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Payment Methods',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),
            const Spacer(),
            if (selectedMethods.length > 1)
              TextButton(
                onPressed: _distributeAmountEvenly,
                child: const Text('Distribute Evenly'),
              ),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: widget.config.acceptedPaymentMethods.map((method) {
            final isSelected = selectedMethods.contains(method);
            final isPrimary = primaryMethod == method;
            
            return FilterChip(
              label: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(_getMethodIcon(method), size: 16),
                  const SizedBox(width: 4),
                  Text(_getMethodName(method)),
                  if (isPrimary) ...[
                    const SizedBox(width: 4),
                    const Icon(Icons.star, size: 12),
                  ],
                ],
              ),
              selected: isSelected,
              onSelected: widget.enabled ? (selected) {
                setState(() {
                  if (selected) {
                    if (!selectedMethods.contains(method)) {
                      selectedMethods.add(method);
                    }
                    if (selectedMethods.length == 1) {
                      primaryMethod = method;
                    }
                  } else {
                    selectedMethods.remove(method);
                    methodAmounts.remove(method);
                    if (primaryMethod == method && selectedMethods.isNotEmpty) {
                      primaryMethod = selectedMethods.first;
                    }
                  }
                  
                  if (selectedMethods.isEmpty) {
                    selectedMethods.add(widget.config.acceptedPaymentMethods.first);
                    primaryMethod = selectedMethods.first;
                  }
                });
                _distributeAmountEvenly();
              } : null,
              selectedColor: Colors.green[100],
              checkmarkColor: Colors.green[700],
            );
          }).toList(),
        ),
        if (selectedMethods.length > 1) ...[
          const SizedBox(height: 8),
          Text(
            'Tap star to set primary method',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildMethodBreakdown() {
    final totalToPay = selectedPaymentType == PaymentType.fullPayment 
        ? widget.totalAmount 
        : partialAmount;
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Breakdown',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Column(
            children: selectedMethods.map((method) {
              final amount = methodAmounts[method] ?? 0.0;
              
              return Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(_getMethodIcon(method), size: 16),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(_getMethodName(method)),
                    ),
                    SizedBox(
                      width: 100,
                      child: TextField(
                        decoration: const InputDecoration(
                          prefixText: '₹ ',
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        controller: TextEditingController(text: amount.toStringAsFixed(2)),
                        onChanged: (value) {
                          final newAmount = double.tryParse(value) ?? 0.0;
                          setState(() {
                            methodAmounts[method.name] = newAmount;
                          });
                          _updatePayment();
                        },
                      ),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Total Allocated:',
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
            ),
            Text(
              '₹${methodAmounts.values.fold(0.0, (sum, amount) => sum + amount).toStringAsFixed(2)}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: methodAmounts.values.fold(0.0, (sum, amount) => sum + amount) == totalToPay
                    ? Colors.green[700]
                    : Colors.red[700],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaymentSummary() {
    final paidAmount = selectedPaymentType == PaymentType.fullPayment 
        ? widget.totalAmount 
        : partialAmount;
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.green[300]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Summary',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.green[700],
            ),
          ),
          const SizedBox(height: 12),
          _buildSummaryRow('Payment Type', selectedPaymentType == PaymentType.fullPayment ? 'Full Payment' : 'Partial Payment'),
          _buildSummaryRow('Primary Method', _getMethodName(primaryMethod)),
          if (selectedMethods.length > 1)
            _buildSummaryRow('Additional Methods', selectedMethods.where((m) => m != primaryMethod).map(_getMethodName).join(', ')),
          _buildSummaryRow('Amount Paying Now', '₹${paidAmount.toStringAsFixed(2)}'),
          if (selectedPaymentType == PaymentType.partialPayment)
            _buildSummaryRow('Remaining Balance', '₹${(widget.totalAmount - paidAmount).toStringAsFixed(2)}'),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              '$label:',
              style: TextStyle(
                fontSize: 14,
                color: Colors.green[600],
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.green[700],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getMethodIcon(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return Icons.money;
      case PaymentMethod.card:
        return Icons.credit_card;
      case PaymentMethod.upi:
        return Icons.qr_code;
      case PaymentMethod.digital:
        return Icons.phone_android;
      case PaymentMethod.split:
        return Icons.splitscreen;
    }
  }

  String _getMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.digital:
        return 'Digital Wallet';
      case PaymentMethod.split:
        return 'Split Payment';
    }
  }
}

// Quick Payment Display Widget
class QuickPaymentDisplay extends StatelessWidget {
  final PaymentDetails payment;
  final VoidCallback? onEdit;

  const QuickPaymentDisplay({
    super.key,
    required this.payment,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: payment.isFullyPaid ? Colors.green[50] : Colors.orange[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: payment.isFullyPaid ? Colors.green[200]! : Colors.orange[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            payment.isFullyPaid ? Icons.check_circle : Icons.schedule,
            color: payment.isFullyPaid ? Colors.green[600] : Colors.orange[600],
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.paymentType == PaymentType.fullPayment 
                      ? 'Full Payment - ${_getMethodName(payment.primaryMethod)}'
                      : 'Partial Payment - ₹${payment.paidAmount.toStringAsFixed(2)} paid',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: payment.isFullyPaid ? Colors.green[700] : Colors.orange[700],
                  ),
                ),
                if (!payment.isFullyPaid)
                  Text(
                    'Remaining: ₹${payment.remainingAmount.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.orange[600],
                    ),
                  ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: Icon(
                Icons.edit,
                color: payment.isFullyPaid ? Colors.green[600] : Colors.orange[600],
                size: 18,
              ),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }

  String _getMethodName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.digital:
        return 'Digital Wallet';
      case PaymentMethod.split:
        return 'Split Payment';
    }
  }
}
