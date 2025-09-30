import 'package:flutter/material.dart';
import '../models/enhanced_takeaway_models.dart';

class ScheduleOrderWidget extends StatefulWidget {
  final ScheduleDetails? initialSchedule;
  final TakeawayConfig config;
  final Function(ScheduleDetails) onScheduleChanged;
  final bool enabled;

  const ScheduleOrderWidget({
    super.key,
    this.initialSchedule,
    required this.config,
    required this.onScheduleChanged,
    this.enabled = true,
  });

  @override
  State<ScheduleOrderWidget> createState() => _ScheduleOrderWidgetState();
}

class _ScheduleOrderWidgetState extends State<ScheduleOrderWidget> {
  DateTime? selectedDate;
  TimeSlot? selectedTimeSlot;
  TextEditingController instructionsController = TextEditingController();
  bool isFlexibleTime = false;
  List<TimeSlot> availableSlots = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialSchedule != null) {
      selectedDate = widget.initialSchedule!.scheduledDate;
      selectedTimeSlot = widget.initialSchedule!.timeSlot;
      instructionsController.text = widget.initialSchedule!.specialInstructions;
      isFlexibleTime = widget.initialSchedule!.isFlexibleTime;
    }
    _generateTimeSlots();
  }

  @override
  void dispose() {
    instructionsController.dispose();
    super.dispose();
  }

  void _generateTimeSlots() {
    if (selectedDate == null) return;

    // Generate time slots for the selected date
    availableSlots.clear();
    final now = DateTime.now();
    final startOfDay = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 9, 0);
    final endOfDay = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, 22, 0);

    for (int hour = 9; hour <= 21; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final slotStart = DateTime(selectedDate!.year, selectedDate!.month, selectedDate!.day, hour, minute);
        final slotEnd = slotStart.add(const Duration(minutes: 30));

        if (slotEnd.isAfter(endOfDay)) break;

        // Check if slot is available (after minimum lead time)
        final isAvailable = slotStart.isAfter(now.add(widget.config.minimumLeadTime));

        availableSlots.add(TimeSlot(
          id: '${selectedDate!.toIso8601String()}_${hour}_$minute',
          startTime: slotStart,
          endTime: slotEnd,
          isAvailable: isAvailable,
          maxOrders: widget.config.maxOrdersPerTimeSlot,
          currentOrders: 0, // Would be fetched from database in real implementation
        ));
      }
    }

    setState(() {});
  }

  void _updateSchedule() {
    final schedule = ScheduleDetails(
      scheduledDate: selectedDate,
      timeSlot: isFlexibleTime ? null : selectedTimeSlot,
      specialInstructions: instructionsController.text,
      minimumLeadTime: widget.config.minimumLeadTime,
      isFlexibleTime: isFlexibleTime,
    );
    widget.onScheduleChanged(schedule);
  }

  Future<void> _selectDate() async {
    final now = DateTime.now();
    final firstDate = now.add(widget.config.minimumLeadTime);
    final lastDate = now.add(widget.config.maximumAdvanceTime);

    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? firstDate,
      firstDate: firstDate,
      lastDate: lastDate,
      helpText: 'Select Pickup Date',
      cancelText: 'Cancel',
      confirmText: 'Select',
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: Colors.blue[600],
            ),
          ),
          child: child!,
        );
      },
    );

    if (pickedDate != null) {
      setState(() {
        selectedDate = pickedDate;
        selectedTimeSlot = null; // Reset time slot when date changes
      });
      _generateTimeSlots();
      _updateSchedule();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.blue[100],
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.schedule, color: Colors.blue[700]),
                const SizedBox(width: 8),
                Text(
                  'Schedule Your Order',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[700],
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
                // Date Selection
                _buildDateSelector(),
                const SizedBox(height: 16),

                // Time Selection
                if (selectedDate != null) ...[
                  _buildTimeFlexibilityToggle(),
                  const SizedBox(height: 16),
                  if (!isFlexibleTime) _buildTimeSlotSelector(),
                  const SizedBox(height: 16),
                ],

                // Special Instructions
                _buildInstructionsField(),

                // Summary
                if (selectedDate != null) ...[
                  const SizedBox(height: 16),
                  _buildScheduleSummary(),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Date',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: widget.enabled ? _selectDate : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_today,
                  color: selectedDate != null ? Colors.blue[600] : Colors.grey[400],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    selectedDate != null
                        ? '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}'
                        : 'Select pickup date',
                    style: TextStyle(
                      fontSize: 16,
                      color: selectedDate != null ? Colors.grey[800] : Colors.grey[500],
                      fontWeight: selectedDate != null ? FontWeight.w500 : FontWeight.normal,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        if (selectedDate != null) ...[
          const SizedBox(height: 8),
          Text(
            'Minimum lead time: ${widget.config.minimumLeadTime.inHours} hours',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildTimeFlexibilityToggle() {
    if (!widget.config.allowFlexibleTiming) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Pickup Time',
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
              child: CheckboxListTile(
                title: const Text('Flexible pickup time'),
                subtitle: const Text('We\'ll prepare your order during business hours'),
                value: isFlexibleTime,
                onChanged: widget.enabled ? (value) {
                  setState(() {
                    isFlexibleTime = value ?? false;
                    if (isFlexibleTime) {
                      selectedTimeSlot = null;
                    }
                  });
                  _updateSchedule();
                } : null,
                activeColor: Colors.blue[600],
                contentPadding: EdgeInsets.zero,
                dense: true,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimeSlotSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Select Time Slot',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Colors.grey[700],
              ),
            ),
            const Spacer(),
            Text(
              '${availableSlots.where((slot) => slot.hasCapacity).length} slots available',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          height: 120,
          child: availableSlots.isEmpty
              ? Center(
                  child: Text(
                    'No time slots available for this date',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                )
              : GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    childAspectRatio: 2.5,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: availableSlots.length,
                  itemBuilder: (context, index) {
                    final slot = availableSlots[index];
                    final isSelected = selectedTimeSlot?.id == slot.id;
                    final canSelect = slot.hasCapacity && widget.enabled;

                    return InkWell(
                      onTap: canSelect ? () {
                        setState(() {
                          selectedTimeSlot = slot;
                        });
                        _updateSchedule();
                      } : null,
                      borderRadius: BorderRadius.circular(8),
                      child: Container(
                        decoration: BoxDecoration(
                          color: !slot.hasCapacity
                              ? Colors.grey[200]
                              : isSelected
                                  ? Colors.blue[600]
                                  : Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: !slot.hasCapacity
                                ? Colors.grey[300]!
                                : isSelected
                                    ? Colors.blue[600]!
                                    : Colors.grey[300]!,
                          ),
                        ),
                        child: Center(
                          child: Text(
                            slot.displayTime,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: !slot.hasCapacity
                                  ? Colors.grey[500]
                                  : isSelected
                                      ? Colors.white
                                      : Colors.grey[800],
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildInstructionsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Special Instructions (Optional)',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: instructionsController,
          enabled: widget.enabled,
          maxLines: 3,
          decoration: InputDecoration(
            hintText: 'Any special requests or notes for your order...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue[600]!),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) => _updateSchedule(),
        ),
      ],
    );
  }

  Widget _buildScheduleSummary() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.blue[100],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.summarize, color: Colors.blue[700], size: 20),
              const SizedBox(width: 8),
              Text(
                'Schedule Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[700],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _buildSummaryRow(
            'Pickup Date',
            '${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}',
            Icons.calendar_today,
          ),
          if (!isFlexibleTime && selectedTimeSlot != null)
            _buildSummaryRow(
              'Pickup Time',
              selectedTimeSlot!.displayTime,
              Icons.access_time,
            ),
          if (isFlexibleTime)
            _buildSummaryRow(
              'Pickup Time',
              'Flexible timing',
              Icons.schedule,
            ),
          if (instructionsController.text.isNotEmpty)
            _buildSummaryRow(
              'Instructions',
              instructionsController.text,
              Icons.note,
            ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 16, color: Colors.blue[600]),
          const SizedBox(width: 8),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.blue[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: 14,
                color: Colors.blue[600],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// Quick Schedule Display Widget
class QuickScheduleDisplay extends StatelessWidget {
  final ScheduleDetails? schedule;
  final VoidCallback? onEdit;

  const QuickScheduleDisplay({
    super.key,
    this.schedule,
    this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    if (schedule?.scheduledDate == null) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue[200]!),
      ),
      child: Row(
        children: [
          Icon(Icons.schedule, color: Colors.blue[600], size: 20),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  schedule!.displaySchedule,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.blue[700],
                  ),
                ),
                if (schedule!.specialInstructions.isNotEmpty)
                  Text(
                    schedule!.specialInstructions,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.blue[600],
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
          if (onEdit != null)
            IconButton(
              icon: Icon(Icons.edit, color: Colors.blue[600], size: 18),
              onPressed: onEdit,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
        ],
      ),
    );
  }
}
