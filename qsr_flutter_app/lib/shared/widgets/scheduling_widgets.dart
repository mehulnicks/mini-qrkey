import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/core_models.dart';

// Order Type Selection Widget - "Order Now" vs "Schedule Order"
class OrderTypeSelector extends ConsumerStatefulWidget {
  final OrderScheduleConfig scheduleConfig;
  final Function(OrderProcessingType) onTypeChanged;
  final OrderProcessingType selectedType;

  const OrderTypeSelector({
    super.key,
    required this.scheduleConfig,
    required this.onTypeChanged,
    this.selectedType = OrderProcessingType.immediate,
  });

  @override
  ConsumerState<OrderTypeSelector> createState() => _OrderTypeSelectorState();
}

class _OrderTypeSelectorState extends ConsumerState<OrderTypeSelector> {
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
              'Order Type',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () => widget.onTypeChanged(OrderProcessingType.immediate),
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.selectedType == OrderProcessingType.immediate
                              ? const Color(0xFFFF9933)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        color: widget.selectedType == OrderProcessingType.immediate
                            ? const Color(0xFFFF9933).withOpacity(0.1)
                            : Colors.white,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.flash_on,
                            size: 32,
                            color: widget.selectedType == OrderProcessingType.immediate
                                ? const Color(0xFFFF9933)
                                : Colors.grey.shade600,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Order Now',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: widget.selectedType == OrderProcessingType.immediate
                                  ? const Color(0xFFFF9933)
                                  : Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Immediate\nprocessing',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: widget.scheduleConfig.enableScheduling
                        ? () => widget.onTypeChanged(OrderProcessingType.scheduled)
                        : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: widget.selectedType == OrderProcessingType.scheduled
                              ? const Color(0xFFFF9933)
                              : Colors.grey.shade300,
                          width: 2,
                        ),
                        color: widget.selectedType == OrderProcessingType.scheduled
                            ? const Color(0xFFFF9933).withOpacity(0.1)
                            : widget.scheduleConfig.enableScheduling
                                ? Colors.white
                                : Colors.grey.shade100,
                      ),
                      child: Column(
                        children: [
                          Icon(
                            Icons.schedule,
                            size: 32,
                            color: widget.selectedType == OrderProcessingType.scheduled
                                ? const Color(0xFFFF9933)
                                : widget.scheduleConfig.enableScheduling
                                    ? Colors.grey.shade600
                                    : Colors.grey.shade400,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Schedule Order',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              color: widget.selectedType == OrderProcessingType.scheduled
                                  ? const Color(0xFFFF9933)
                                  : widget.scheduleConfig.enableScheduling
                                      ? Colors.grey.shade700
                                      : Colors.grey.shade400,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            widget.scheduleConfig.enableScheduling
                                ? 'Future pickup\ntime'
                                : 'Not available',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Date and Time Selection Widget
class SchedulePickerWidget extends ConsumerStatefulWidget {
  final OrderScheduleConfig config;
  final Function(DateTime) onDateTimeSelected;
  final DateTime? selectedDateTime;

  const SchedulePickerWidget({
    super.key,
    required this.config,
    required this.onDateTimeSelected,
    this.selectedDateTime,
  });

  @override
  ConsumerState<SchedulePickerWidget> createState() => _SchedulePickerWidgetState();
}

class _SchedulePickerWidgetState extends ConsumerState<SchedulePickerWidget> {
  DateTime? selectedDate;
  TimeSlot? selectedTimeSlot;

  @override
  void initState() {
    super.initState();
    if (widget.selectedDateTime != null) {
      selectedDate = DateTime(
        widget.selectedDateTime!.year,
        widget.selectedDateTime!.month,
        widget.selectedDateTime!.day,
      );
      // Try to find matching time slot
      final time = TimeOfDay.fromDateTime(widget.selectedDateTime!);
      selectedTimeSlot = widget.config.availableTimeSlots.firstWhere(
        (slot) => slot.startTime.hour <= time.hour && slot.endTime.hour > time.hour,
        orElse: () => widget.config.availableTimeSlots.first,
      );
    }
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
              'Schedule Details',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            
            // Date Selection
            InkWell(
              onTap: _showDatePicker,
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Color(0xFFFF9933)),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Pickup Date',
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            selectedDate != null
                                ? _formatDate(selectedDate!)
                                : 'Select date',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.arrow_forward_ios, size: 16),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Time Slot Selection
            if (selectedDate != null && widget.config.availableTimeSlots.isNotEmpty) ...[
              Text(
                'Available Time Slots',
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 8),
              GridView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 3,
                  crossAxisSpacing: 8,
                  mainAxisSpacing: 8,
                ),
                itemCount: widget.config.availableTimeSlots.length,
                itemBuilder: (context, index) {
                  final slot = widget.config.availableTimeSlots[index];
                  final isSelected = selectedTimeSlot?.id == slot.id;
                  
                  return InkWell(
                    onTap: slot.isActive ? () => _selectTimeSlot(slot) : null,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: isSelected
                              ? const Color(0xFFFF9933)
                              : Colors.grey.shade300,
                        ),
                        color: isSelected
                            ? const Color(0xFFFF9933).withOpacity(0.1)
                            : slot.isActive
                                ? Colors.white
                                : Colors.grey.shade100,
                      ),
                      child: Center(
                        child: Text(
                          slot.displayTime,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: isSelected
                                ? const Color(0xFFFF9933)
                                : slot.isActive
                                    ? Colors.black87
                                    : Colors.grey.shade500,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ],
            
            // Selected date/time summary
            if (selectedDate != null && selectedTimeSlot != null) ...[
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade200),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade600, size: 20),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Scheduled for:',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                          Text(
                            '${_formatDate(selectedDate!)} at ${selectedTimeSlot!.displayTime}',
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _showDatePicker() async {
    final now = DateTime.now();
    final minimumDate = now.add(Duration(minutes: widget.config.minimumLeadTimeMinutes));
    final maximumDate = now.add(Duration(days: widget.config.maximumAdvanceDays));

    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? minimumDate,
      firstDate: minimumDate,
      lastDate: maximumDate,
      selectableDayPredicate: (date) {
        // Check if day is in working days (1=Monday, 7=Sunday)
        final weekday = date.weekday;
        return widget.config.workingDays.contains(weekday);
      },
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedTimeSlot = null; // Reset time slot when date changes
      });
    }
  }

  void _selectTimeSlot(TimeSlot slot) {
    setState(() {
      selectedTimeSlot = slot;
    });

    if (selectedDate != null) {
      final scheduledDateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        slot.startTime.hour,
        slot.startTime.minute,
      );
      widget.onDateTimeSelected(scheduledDateTime);
    }
  }

  String _formatDate(DateTime date) {
    final weekdays = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 
                   'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    
    return '${weekdays[date.weekday - 1]}, ${months[date.month - 1]} ${date.day}';
  }
}

// Special Instructions Widget
class SpecialInstructionsWidget extends StatefulWidget {
  final Function(String) onChanged;
  final String? initialValue;

  const SpecialInstructionsWidget({
    super.key,
    required this.onChanged,
    this.initialValue,
  });

  @override
  State<SpecialInstructionsWidget> createState() => _SpecialInstructionsWidgetState();
}

class _SpecialInstructionsWidgetState extends State<SpecialInstructionsWidget> {
  late TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialValue);
  }

  @override
  void dispose() {
    _controller.dispose();
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
              'Special Instructions',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Any special requests or notes for your order',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _controller,
              maxLines: 3,
              maxLength: 200,
              decoration: InputDecoration(
                hintText: 'e.g., Extra spicy, no onions, call when ready...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFFFF9933)),
                ),
              ),
              onChanged: widget.onChanged,
            ),
          ],
        ),
      ),
    );
  }
}

// Order Confirmation Widget for Scheduled Orders
class ScheduledOrderConfirmationWidget extends StatelessWidget {
  final DateTime scheduledDateTime;
  final double totalAmount;
  final String customerName;
  final String? customerPhone;
  final String? specialInstructions;
  final List<OrderItem> items;

  const ScheduledOrderConfirmationWidget({
    super.key,
    required this.scheduledDateTime,
    required this.totalAmount,
    required this.customerName,
    this.customerPhone,
    this.specialInstructions,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green.shade600, size: 24),
                const SizedBox(width: 8),
                Text(
                  'Order Scheduled!',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Pickup Details
            _buildInfoRow(
              icon: Icons.schedule,
              title: 'Pickup Time',
              value: _formatDateTime(scheduledDateTime),
            ),
            _buildInfoRow(
              icon: Icons.person,
              title: 'Customer',
              value: customerName,
            ),
            if (customerPhone != null)
              _buildInfoRow(
                icon: Icons.phone,
                title: 'Phone',
                value: customerPhone!,
              ),
            _buildInfoRow(
              icon: Icons.receipt,
              title: 'Total Amount',
              value: '₹${totalAmount.toStringAsFixed(2)}',
            ),
            
            if (specialInstructions != null && specialInstructions!.isNotEmpty) ...[
              const SizedBox(height: 8),
              _buildInfoRow(
                icon: Icons.note,
                title: 'Special Instructions',
                value: specialInstructions!,
              ),
            ],
            
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 8),
            
            // Order Summary
            Text(
              'Order Summary',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            ...items.map((item) => Padding(
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
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.grey.shade600),
          const SizedBox(width: 8),
          SizedBox(
            width: 80,
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
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
