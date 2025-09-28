import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/core_models.dart';

// Payment Option Selector - Full vs Partial Payment
class PaymentOptionSelector extends ConsumerStatefulWidget {
  final double totalAmount;
  final Function(bool allowPartial, double? partialAmount) onSelectionChanged;
  final bool initialAllowPartial;
  final double? initialPartialAmount;

  const PaymentOptionSelector({
    super.key,
    required this.totalAmount,
    required this.onSelectionChanged,
    this.initialAllowPartial = false,
    this.initialPartialAmount,
  });

  @override
  ConsumerState<PaymentOptionSelector> createState() => _PaymentOptionSelectorState();
}

class _PaymentOptionSelectorState extends ConsumerState<PaymentOptionSelector> {
  bool allowPartialPayment = false;
  double partialAmount = 0.0;
  late TextEditingController _partialAmountController;

  @override
  void initState() {
    super.initState();
    allowPartialPayment = widget.initialAllowPartial;
    partialAmount = widget.initialPartialAmount ?? (widget.totalAmount * 0.5);
    _partialAmountController = TextEditingController(
      text: allowPartialPayment ? partialAmount.toStringAsFixed(2) : '',
    );
  }

  @override
  void dispose() {
    _partialAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Options',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Choose how you want to pay for this order',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 16),

            // Full Payment Option
            InkWell(
              onTap: () => _selectPaymentType(false),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: !allowPartialPayment
                        ? const Color(0xFFFF9933)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: !allowPartialPayment
                      ? const Color(0xFFFF9933).withOpacity(0.1)
                      : Colors.white,
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.payment,
                      color: !allowPartialPayment
                          ? const Color(0xFFFF9933)
                          : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Full Payment',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: !allowPartialPayment
                                  ? const Color(0xFFFF9933)
                                  : Colors.black87,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Pay complete amount now',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Text(
                      '₹${widget.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: !allowPartialPayment
                            ? const Color(0xFFFF9933)
                            : Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Partial Payment Option
            InkWell(
              onTap: () => _selectPaymentType(true),
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: allowPartialPayment
                        ? const Color(0xFFFF9933)
                        : Colors.grey.shade300,
                    width: 2,
                  ),
                  color: allowPartialPayment
                      ? const Color(0xFFFF9933).withOpacity(0.1)
                      : Colors.white,
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: allowPartialPayment
                              ? const Color(0xFFFF9933)
                              : Colors.grey.shade600,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Partial Payment',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 16,
                                  color: allowPartialPayment
                                      ? const Color(0xFFFF9933)
                                      : Colors.black87,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                'Pay advance, remaining at pickup',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Icon(
                          allowPartialPayment
                              ? Icons.keyboard_arrow_down
                              : Icons.keyboard_arrow_right,
                          color: Colors.grey.shade600,
                        ),
                      ],
                    ),
                    
                    // Partial amount input (shown when selected)
                    if (allowPartialPayment) ...[
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextField(
                              controller: _partialAmountController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: 'Advance Amount',
                                prefixText: '₹ ',
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: Color(0xFFFF9933)),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 8,
                                ),
                              ),
                              onChanged: _onPartialAmountChanged,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            flex: 3,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  'Remaining: ₹${(widget.totalAmount - partialAmount).toStringAsFixed(2)}',
                                  style: const TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Due at pickup',
                                  style: TextStyle(
                                    fontSize: 10,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Quick amount buttons
                      Row(
                        children: [
                          _buildQuickAmountButton('25%', widget.totalAmount * 0.25),
                          const SizedBox(width: 8),
                          _buildQuickAmountButton('50%', widget.totalAmount * 0.50),
                          const SizedBox(width: 8),
                          _buildQuickAmountButton('75%', widget.totalAmount * 0.75),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Payment summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        allowPartialPayment ? 'Pay Now' : 'Total Payment',
                        style: const TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                      Text(
                        '₹${(allowPartialPayment ? partialAmount : widget.totalAmount).toStringAsFixed(2)}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9933),
                        ),
                      ),
                    ],
                  ),
                  if (allowPartialPayment)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'At Pickup',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${(widget.totalAmount - partialAmount).toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(String label, double amount) {
    return Expanded(
      child: OutlinedButton(
        onPressed: () {
          setState(() {
            partialAmount = amount;
            _partialAmountController.text = amount.toStringAsFixed(2);
          });
          widget.onSelectionChanged(allowPartialPayment, partialAmount);
        },
        style: OutlinedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 4),
          side: BorderSide(color: Colors.grey.shade300),
        ),
        child: Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ),
    );
  }

  void _selectPaymentType(bool partial) {
    setState(() {
      allowPartialPayment = partial;
      if (!partial) {
        partialAmount = widget.totalAmount;
        _partialAmountController.clear();
      } else {
        partialAmount = widget.totalAmount * 0.5;
        _partialAmountController.text = partialAmount.toStringAsFixed(2);
      }
    });
    widget.onSelectionChanged(allowPartialPayment, allowPartialPayment ? partialAmount : null);
  }

  void _onPartialAmountChanged(String value) {
    final amount = double.tryParse(value) ?? 0.0;
    if (amount >= 0 && amount <= widget.totalAmount) {
      setState(() {
        partialAmount = amount;
      });
      widget.onSelectionChanged(allowPartialPayment, partialAmount);
    }
  }
}

// Multi-Method Payment Interface
class MultiMethodPaymentWidget extends ConsumerStatefulWidget {
  final double totalAmount;
  final List<PaymentMethodConfig> availablePaymentMethods;
  final Function(List<PartialPayment>) onPaymentsChanged;
  final List<PartialPayment> initialPayments;

  const MultiMethodPaymentWidget({
    super.key,
    required this.totalAmount,
    required this.availablePaymentMethods,
    required this.onPaymentsChanged,
    this.initialPayments = const [],
  });

  @override
  ConsumerState<MultiMethodPaymentWidget> createState() => _MultiMethodPaymentWidgetState();
}

class _MultiMethodPaymentWidgetState extends ConsumerState<MultiMethodPaymentWidget> {
  List<PartialPayment> payments = [];
  
  @override
  void initState() {
    super.initState();
    payments = List.from(widget.initialPayments);
  }

  @override
  Widget build(BuildContext context) {
    final totalPaid = payments.fold(0.0, (sum, payment) => sum + payment.amount);
    final remainingAmount = widget.totalAmount - totalPaid;
    final isFullyPaid = totalPaid >= widget.totalAmount;

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Payment Methods',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Payment Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isFullyPaid ? Colors.green.shade50 : Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: isFullyPaid ? Colors.green.shade200 : Colors.orange.shade200,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    isFullyPaid ? Icons.check_circle : Icons.account_balance_wallet,
                    color: isFullyPaid ? Colors.green.shade600 : Colors.orange.shade600,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isFullyPaid ? 'Payment Complete' : 'Payment Progress',
                          style: TextStyle(
                            fontSize: 12,
                            color: isFullyPaid ? Colors.green.shade700 : Colors.orange.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              '₹${totalPaid.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              ' / ₹${widget.totalAmount.toStringAsFixed(2)}',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  if (!isFullyPaid)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        const Text(
                          'Remaining',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          '₹${remainingAmount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Existing Payments List
            if (payments.isNotEmpty) ...[
              Text(
                'Payments Made',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              ...payments.asMap().entries.map((entry) {
                final index = entry.key;
                final payment = entry.value;
                return _buildPaymentItem(payment, index);
              }).toList(),
              const SizedBox(height: 16),
            ],

            // Add Payment Button
            if (!isFullyPaid)
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddPaymentDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Payment Method'),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    side: const BorderSide(color: Color(0xFFFF9933)),
                    foregroundColor: const Color(0xFFFF9933),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentItem(PartialPayment payment, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.green.shade100,
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _getPaymentMethodIcon(payment.method),
              style: const TextStyle(fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  payment.methodName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatDateTime(payment.paidAt),
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
                if (payment.transactionId != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    'ID: ${payment.transactionId}',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey.shade500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${payment.amount.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Colors.green,
                ),
              ),
              IconButton(
                onPressed: () => _removePayment(index),
                icon: const Icon(Icons.delete_outline),
                iconSize: 18,
                color: Colors.red,
                constraints: const BoxConstraints(
                  minWidth: 32,
                  minHeight: 32,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _showAddPaymentDialog() {
    showDialog(
      context: context,
      builder: (context) => AddPaymentDialog(
        availablePaymentMethods: widget.availablePaymentMethods,
        maxAmount: widget.totalAmount - payments.fold(0.0, (sum, p) => sum + p.amount),
        onPaymentAdded: (payment) {
          setState(() {
            payments.add(payment);
          });
          widget.onPaymentsChanged(payments);
        },
      ),
    );
  }

  void _removePayment(int index) {
    setState(() {
      payments.removeAt(index);
    });
    widget.onPaymentsChanged(payments);
  }

  String _getPaymentMethodIcon(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.cash:
        return '💵';
      case PaymentMethodType.card:
        return '💳';
      case PaymentMethodType.upi:
        return '📱';
      case PaymentMethodType.netBanking:
        return '🏦';
      case PaymentMethodType.wallet:
        return '💰';
      case PaymentMethodType.giftCard:
        return '🎁';
      case PaymentMethodType.custom:
        return '💸';
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Add Payment Dialog
class AddPaymentDialog extends StatefulWidget {
  final List<PaymentMethodConfig> availablePaymentMethods;
  final double maxAmount;
  final Function(PartialPayment) onPaymentAdded;

  const AddPaymentDialog({
    super.key,
    required this.availablePaymentMethods,
    required this.maxAmount,
    required this.onPaymentAdded,
  });

  @override
  State<AddPaymentDialog> createState() => _AddPaymentDialogState();
}

class _AddPaymentDialogState extends State<AddPaymentDialog> {
  PaymentMethodConfig? selectedMethod;
  double amount = 0.0;
  String transactionId = '';
  
  late TextEditingController _amountController;
  late TextEditingController _transactionController;

  @override
  void initState() {
    super.initState();
    _amountController = TextEditingController();
    _transactionController = TextEditingController();
    
    if (widget.availablePaymentMethods.isNotEmpty) {
      selectedMethod = widget.availablePaymentMethods.first;
    }
  }

  @override
  void dispose() {
    _amountController.dispose();
    _transactionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Add Payment'),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment Method Selection
            DropdownButtonFormField<PaymentMethodConfig>(
              value: selectedMethod,
              decoration: const InputDecoration(
                labelText: 'Payment Method',
                border: OutlineInputBorder(),
              ),
              items: widget.availablePaymentMethods.map((method) {
                return DropdownMenuItem(
                  value: method,
                  child: Row(
                    children: [
                      Text(method.icon ?? '💳', style: const TextStyle(fontSize: 18)),
                      const SizedBox(width: 8),
                      Text(method.name),
                    ],
                  ),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  selectedMethod = value;
                });
              },
            ),
            
            const SizedBox(height: 16),
            
            // Amount Input
            TextField(
              controller: _amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Amount',
                prefixText: '₹ ',
                border: const OutlineInputBorder(),
                helperText: 'Max: ₹${widget.maxAmount.toStringAsFixed(2)}',
              ),
              onChanged: (value) {
                amount = double.tryParse(value) ?? 0.0;
              },
            ),
            
            const SizedBox(height: 16),
            
            // Transaction ID (optional for non-cash)
            if (selectedMethod?.type != PaymentMethodType.cash)
              TextField(
                controller: _transactionController,
                decoration: const InputDecoration(
                  labelText: 'Transaction ID (optional)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) {
                  transactionId = value;
                },
              ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _canAddPayment() ? _addPayment : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
          ),
          child: const Text('Add Payment'),
        ),
      ],
    );
  }

  bool _canAddPayment() {
    return selectedMethod != null && 
           amount > 0 && 
           amount <= widget.maxAmount;
  }

  void _addPayment() {
    if (!_canAddPayment()) return;

    final payment = PartialPayment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      amount: amount,
      method: selectedMethod!.type,
      methodName: selectedMethod!.name,
      paidAt: DateTime.now(),
      transactionId: transactionId.isEmpty ? null : transactionId,
    );

    widget.onPaymentAdded(payment);
    Navigator.pop(context);
  }
}

// Remaining Balance Display Widget
class RemainingBalanceWidget extends StatelessWidget {
  final PaymentPlan paymentPlan;
  final DateTime? dueDate;

  const RemainingBalanceWidget({
    super.key,
    required this.paymentPlan,
    this.dueDate,
  });

  @override
  Widget build(BuildContext context) {
    final remainingAmount = paymentPlan.remainingAmount;
    final isOverdue = paymentPlan.isOverdue;
    
    if (remainingAmount <= 0) {
      return Card(
        color: Colors.green.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Expanded(
                child: Text(
                  'Payment Complete',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Card(
      color: isOverdue ? Colors.red.shade50 : Colors.orange.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  isOverdue ? Icons.warning : Icons.schedule,
                  color: isOverdue ? Colors.red.shade600 : Colors.orange.shade600,
                ),
                const SizedBox(width: 8),
                Text(
                  isOverdue ? 'Payment Overdue' : 'Remaining Balance',
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: isOverdue ? Colors.red.shade700 : Colors.orange.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              '₹${remainingAmount.toStringAsFixed(2)}',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: isOverdue ? Colors.red.shade600 : Colors.orange.shade600,
              ),
            ),
            if (dueDate != null) ...[
              const SizedBox(height: 4),
              Text(
                'Due: ${_formatDate(dueDate!)}',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: paymentPlan.paymentProgress,
              backgroundColor: Colors.grey.shade300,
              valueColor: AlwaysStoppedAnimation<Color>(
                isOverdue ? Colors.red.shade400 : Colors.orange.shade400,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '${(paymentPlan.paymentProgress * 100).toInt()}% paid',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
