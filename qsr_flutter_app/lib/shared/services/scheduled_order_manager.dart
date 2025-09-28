import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/core_models.dart';

// Scheduled Order Queue Manager
class ScheduledOrderManager {
  static final ScheduledOrderManager _instance = ScheduledOrderManager._internal();
  factory ScheduledOrderManager() => _instance;
  ScheduledOrderManager._internal();

  Timer? _processingTimer;
  final List<Order> _scheduledOrders = [];
  final StreamController<List<Order>> _scheduledOrdersController = StreamController<List<Order>>.broadcast();
  final StreamController<Order> _orderActivatedController = StreamController<Order>.broadcast();

  Stream<List<Order>> get scheduledOrdersStream => _scheduledOrdersController.stream;
  Stream<Order> get orderActivatedStream => _orderActivatedController.stream;

  void initialize() {
    // Start background processing timer (check every minute)
    _processingTimer = Timer.periodic(const Duration(minutes: 1), (timer) {
      _processScheduledOrders();
    });
  }

  void dispose() {
    _processingTimer?.cancel();
    _scheduledOrdersController.close();
    _orderActivatedController.close();
  }

  void addScheduledOrder(Order order) {
    if (order.isScheduled && order.scheduledOrderInfo != null) {
      _scheduledOrders.add(order);
      _scheduledOrdersController.add(List.from(_scheduledOrders));
    }
  }

  void removeScheduledOrder(String orderId) {
    _scheduledOrders.removeWhere((order) => order.id == orderId);
    _scheduledOrdersController.add(List.from(_scheduledOrders));
  }

  void updateScheduledOrder(Order updatedOrder) {
    final index = _scheduledOrders.indexWhere((order) => order.id == updatedOrder.id);
    if (index >= 0) {
      _scheduledOrders[index] = updatedOrder;
      _scheduledOrdersController.add(List.from(_scheduledOrders));
    }
  }

  List<Order> get pendingScheduledOrders {
    return _scheduledOrders
        .where((order) => order.scheduleStatus == ScheduleStatus.pending)
        .toList();
  }

  List<Order> get activeScheduledOrders {
    return _scheduledOrders
        .where((order) => order.scheduleStatus == ScheduleStatus.active)
        .toList();
  }

  List<Order> get overdueScheduledOrders {
    return _scheduledOrders
        .where((order) => order.isScheduleOverdue)
        .toList();
  }

  void _processScheduledOrders() {
    final now = DateTime.now();
    final ordersToActivate = <Order>[];

    for (int i = 0; i < _scheduledOrders.length; i++) {
      final order = _scheduledOrders[i];
      
      if (order.shouldActivateSchedule) {
        // Activate order (5 minutes before scheduled time)
        final activatedOrder = order.activateScheduledOrder();
        _scheduledOrders[i] = activatedOrder;
        ordersToActivate.add(activatedOrder);
      } else if (order.isScheduleOverdue && 
                order.scheduleStatus != ScheduleStatus.expired) {
        // Mark as expired if overdue
        final expiredOrder = order.copyWith(
          scheduledOrderInfo: order.scheduledOrderInfo?.copyWith(
            status: ScheduleStatus.expired,
          ),
        );
        _scheduledOrders[i] = expiredOrder;
      }
    }

    if (ordersToActivate.isNotEmpty) {
      _scheduledOrdersController.add(List.from(_scheduledOrders));
      
      // Notify about activated orders
      for (final order in ordersToActivate) {
        _orderActivatedController.add(order);
      }
    }
  }

  // Get orders scheduled for a specific date
  List<Order> getOrdersForDate(DateTime date) {
    final targetDate = DateTime(date.year, date.month, date.day);
    
    return _scheduledOrders.where((order) {
      if (order.scheduledDateTime == null) return false;
      
      final orderDate = DateTime(
        order.scheduledDateTime!.year,
        order.scheduledDateTime!.month,
        order.scheduledDateTime!.day,
      );
      
      return orderDate == targetDate;
    }).toList();
  }

  // Get orders scheduled for a specific time slot
  List<Order> getOrdersForTimeSlot(DateTime date, TimeSlot timeSlot) {
    return getOrdersForDate(date).where((order) {
      if (order.scheduledDateTime == null) return false;
      
      final orderTime = TimeOfDay.fromDateTime(order.scheduledDateTime!);
      return orderTime.hour >= timeSlot.startTime.hour &&
             orderTime.hour < timeSlot.endTime.hour;
    }).toList();
  }

  // Check if a time slot has capacity
  bool hasCapacity(DateTime date, TimeSlot timeSlot) {
    final ordersInSlot = getOrdersForTimeSlot(date, timeSlot);
    return ordersInSlot.length < timeSlot.maxOrders;
  }

  // Get available time slots for a date
  List<TimeSlot> getAvailableTimeSlots(DateTime date, List<TimeSlot> allTimeSlots) {
    return allTimeSlots.where((slot) => 
        slot.isActive && hasCapacity(date, slot)
    ).toList();
  }
}

// Provider for scheduled order manager
final scheduledOrderManagerProvider = Provider<ScheduledOrderManager>((ref) {
  final manager = ScheduledOrderManager();
  manager.initialize();
  
  ref.onDispose(() {
    manager.dispose();
  });
  
  return manager;
});

// Provider for scheduled orders stream
final scheduledOrdersStreamProvider = StreamProvider<List<Order>>((ref) {
  final manager = ref.watch(scheduledOrderManagerProvider);
  return manager.scheduledOrdersStream;
});

// Provider for order activation stream
final orderActivationStreamProvider = StreamProvider<Order>((ref) {
  final manager = ref.watch(scheduledOrderManagerProvider);
  return manager.orderActivatedStream;
});

// Scheduled Order Dashboard Widget
class ScheduledOrderDashboard extends ConsumerWidget {
  const ScheduledOrderDashboard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final scheduledOrdersAsync = ref.watch(scheduledOrdersStreamProvider);
    final manager = ref.watch(scheduledOrderManagerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scheduled Orders'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
      ),
      body: scheduledOrdersAsync.when(
        data: (orders) => _buildDashboard(context, orders, manager),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => Center(
          child: Text('Error: $error'),
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, List<Order> orders, ScheduledOrderManager manager) {
    final pendingOrders = orders.where((o) => o.scheduleStatus == ScheduleStatus.pending).toList();
    final activeOrders = orders.where((o) => o.scheduleStatus == ScheduleStatus.active).toList();
    final overdueOrders = orders.where((o) => o.isScheduleOverdue).toList();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Pending',
                  pendingOrders.length,
                  Icons.schedule,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Active',
                  activeOrders.length,
                  Icons.play_arrow,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Overdue',
                  overdueOrders.length,
                  Icons.warning,
                  Colors.red,
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Today's Schedule
          _buildTodaySchedule(context, manager),

          const SizedBox(height: 24),

          // Order Lists
          if (activeOrders.isNotEmpty) ...[
            _buildOrderSection('Active Orders', activeOrders, Colors.green),
            const SizedBox(height: 16),
          ],

          if (pendingOrders.isNotEmpty) ...[
            _buildOrderSection('Pending Orders', pendingOrders, Colors.blue),
            const SizedBox(height: 16),
          ],

          if (overdueOrders.isNotEmpty) ...[
            _buildOrderSection('Overdue Orders', overdueOrders, Colors.red),
          ],
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, int count, IconData icon, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              count.toString(),
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            Text(
              title,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(BuildContext context, ScheduledOrderManager manager) {
    final today = DateTime.now();
    final todayOrders = manager.getOrdersForDate(today);

    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Schedule',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            
            if (todayOrders.isEmpty)
              const Center(
                child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No orders scheduled for today',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              )
            else
              ...todayOrders.map((order) => _buildScheduleItem(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildScheduleItem(Order order) {
    final scheduledTime = order.scheduledDateTime!;
    final timeOfDay = TimeOfDay.fromDateTime(scheduledTime);
    final timeString = '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    
    Color statusColor;
    IconData statusIcon;
    
    switch (order.scheduleStatus!) {
      case ScheduleStatus.pending:
        statusColor = Colors.blue;
        statusIcon = Icons.schedule;
        break;
      case ScheduleStatus.active:
        statusColor = Colors.green;
        statusIcon = Icons.play_arrow;
        break;
      case ScheduleStatus.processing:
        statusColor = Colors.orange;
        statusIcon = Icons.restaurant;
        break;
      case ScheduleStatus.completed:
        statusColor = Colors.grey;
        statusIcon = Icons.check_circle;
        break;
      case ScheduleStatus.cancelled:
        statusColor = Colors.red;
        statusIcon = Icons.cancel;
        break;
      case ScheduleStatus.expired:
        statusColor = Colors.red;
        statusIcon = Icons.warning;
        break;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border(left: BorderSide(color: statusColor, width: 4)),
        color: statusColor.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Text(
            timeString,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customer?.name ?? 'Unknown Customer',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '${order.items.length} items - ₹${order.getGrandTotal(AppSettings()).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Icon(statusIcon, color: statusColor),
        ],
      ),
    );
  }

  Widget _buildOrderSection(String title, List<Order> orders, Color color) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.list, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: color,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...orders.map((order) => _buildOrderListItem(order)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildOrderListItem(Order order) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  order.customer?.name ?? 'Unknown Customer',
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                if (order.scheduledDateTime != null)
                  Text(
                    'Scheduled: ${_formatDateTime(order.scheduledDateTime!)}',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                Text(
                  '${order.items.length} items - ₹${order.getGrandTotal(AppSettings()).toStringAsFixed(2)}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          if (order.hasPaymentPlan && !order.isPaymentComplete)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.orange.shade100,
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Partial Payment',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.orange.shade700,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final difference = dateTime.difference(now);
    
    if (difference.inDays == 0) {
      final timeOfDay = TimeOfDay.fromDateTime(dateTime);
      return '${timeOfDay.hour.toString().padLeft(2, '0')}:${timeOfDay.minute.toString().padLeft(2, '0')}';
    } else if (difference.inDays == 1) {
      return 'Tomorrow';
    } else {
      return '${dateTime.day}/${dateTime.month}';
    }
  }
}
