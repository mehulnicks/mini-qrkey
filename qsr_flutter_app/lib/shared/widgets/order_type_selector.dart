import 'package:flutter/material.dart';
import '../models/enhanced_takeaway_models.dart';

class OrderTypeSelector extends StatefulWidget {
  final TakeawayOrderType selectedType;
  final Function(TakeawayOrderType) onTypeChanged;
  final bool enabled;

  const OrderTypeSelector({
    super.key,
    required this.selectedType,
    required this.onTypeChanged,
    this.enabled = true,
  });

  @override
  State<OrderTypeSelector> createState() => _OrderTypeSelectorState();
}

class _OrderTypeSelectorState extends State<OrderTypeSelector>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(
      begin: 1.0,
      end: 0.95,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    ));
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _handleTypeSelection(TakeawayOrderType type) {
    if (!widget.enabled) return;
    
    _animationController.forward().then((_) {
      _animationController.reverse();
    });
    
    widget.onTypeChanged(type);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.grey[50],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Icon(
                  Icons.schedule,
                  color: Colors.orange[600],
                  size: 24,
                ),
                const SizedBox(width: 8),
                Text(
                  'Select Order Type',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey[800],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                Expanded(
                  child: _buildOrderTypeCard(
                    type: TakeawayOrderType.orderNow,
                    title: 'Order Now',
                    subtitle: 'Immediate processing',
                    icon: Icons.flash_on,
                    color: Colors.green,
                    isSelected: widget.selectedType == TakeawayOrderType.orderNow,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildOrderTypeCard(
                    type: TakeawayOrderType.scheduleOrder,
                    title: 'Schedule Order',
                    subtitle: 'Pick date & time',
                    icon: Icons.calendar_today,
                    color: Colors.blue,
                    isSelected: widget.selectedType == TakeawayOrderType.scheduleOrder,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _buildOrderTypeCard({
    required TakeawayOrderType type,
    required String title,
    required String subtitle,
    required IconData icon,
    required Color color,
    required bool isSelected,
  }) {
    return AnimatedBuilder(
      animation: _scaleAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: isSelected ? _scaleAnimation.value : 1.0,
          child: GestureDetector(
            onTap: () => _handleTypeSelection(type),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isSelected ? color.withOpacity(0.1) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: isSelected ? color : Colors.grey[300]!,
                  width: isSelected ? 2 : 1,
                ),
                boxShadow: isSelected
                    ? [
                        BoxShadow(
                          color: color.withOpacity(0.2),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.1),
                          blurRadius: 4,
                          offset: const Offset(0, 1),
                        ),
                      ],
              ),
              child: Column(
                children: [
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: isSelected ? color : Colors.grey[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      icon,
                      color: isSelected ? Colors.white : Colors.grey[600],
                      size: 28,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected ? color : Colors.grey[800],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 12,
                      color: isSelected ? color.withOpacity(0.8) : Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (isSelected) ...[
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: color,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Text(
                        'Selected',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

// Enhanced Takeaway Header with order type info
class TakeawayOrderHeader extends StatelessWidget {
  final TakeawayOrderType orderType;
  final ScheduleDetails? scheduleDetails;
  final int itemCount;
  final double totalAmount;

  const TakeawayOrderHeader({
    super.key,
    required this.orderType,
    this.scheduleDetails,
    required this.itemCount,
    required this.totalAmount,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: orderType == TakeawayOrderType.orderNow
              ? [Colors.green[400]!, Colors.green[600]!]
              : [Colors.blue[400]!, Colors.blue[600]!],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: (orderType == TakeawayOrderType.orderNow
                    ? Colors.green
                    : Colors.blue)
                .withOpacity(0.3),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                orderType == TakeawayOrderType.orderNow
                    ? Icons.flash_on
                    : Icons.schedule,
                color: Colors.white,
                size: 24,
              ),
              const SizedBox(width: 8),
              Text(
                orderType == TakeawayOrderType.orderNow
                    ? 'Order Now'
                    : 'Scheduled Order',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$itemCount items',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          if (scheduleDetails?.isScheduled == true) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Colors.white,
                        size: 16,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        scheduleDetails!.displaySchedule,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  if (scheduleDetails!.specialInstructions.isNotEmpty) ...[
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(
                          Icons.note,
                          color: Colors.white,
                          size: 16,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            scheduleDetails!.specialInstructions,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Total Amount',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
              Text(
                '₹${totalAmount.toStringAsFixed(2)}',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Quick Order Type Switch
class QuickOrderTypeSwitch extends StatelessWidget {
  final TakeawayOrderType currentType;
  final Function(TakeawayOrderType) onTypeChanged;
  final bool enabled;

  const QuickOrderTypeSwitch({
    super.key,
    required this.currentType,
    required this.onTypeChanged,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          const Icon(Icons.schedule, size: 20, color: Colors.grey),
          const SizedBox(width: 8),
          const Text(
            'Order Type:',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.grey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: SegmentedButton<TakeawayOrderType>(
              segments: const [
                ButtonSegment<TakeawayOrderType>(
                  value: TakeawayOrderType.orderNow,
                  label: Text('Now'),
                  icon: Icon(Icons.flash_on, size: 16),
                ),
                ButtonSegment<TakeawayOrderType>(
                  value: TakeawayOrderType.scheduleOrder,
                  label: Text('Schedule'),
                  icon: Icon(Icons.calendar_today, size: 16),
                ),
              ],
              selected: {currentType},
              onSelectionChanged: enabled
                  ? (Set<TakeawayOrderType> selection) {
                      onTypeChanged(selection.first);
                    }
                  : null,
              style: ButtonStyle(
                visualDensity: VisualDensity.compact,
                textStyle: WidgetStateProperty.all(
                  const TextStyle(fontSize: 12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
