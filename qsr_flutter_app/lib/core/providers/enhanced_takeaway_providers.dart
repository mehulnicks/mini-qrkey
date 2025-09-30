import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/enhanced_takeaway_service.dart';
import '../../shared/models/enhanced_takeaway_models.dart';

// Service provider
final enhancedTakeawayServiceProvider = Provider<EnhancedTakeawayService>((ref) {
  return EnhancedTakeawayService();
});

// Configuration provider
final takeawayConfigProvider = StateProvider<TakeawayConfig>((ref) {
  return TakeawayConfig(
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
});

// Current order state provider
final currentTakeawayOrderProvider = StateNotifierProvider<CurrentTakeawayOrderNotifier, EnhancedTakeawayOrder?>((ref) {
  return CurrentTakeawayOrderNotifier();
});

class CurrentTakeawayOrderNotifier extends StateNotifier<EnhancedTakeawayOrder?> {
  CurrentTakeawayOrderNotifier() : super(null);

  void startNewOrder({
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    double taxAmount = 0.0,
    double discountAmount = 0.0,
  }) {
    final payment = PaymentDetails(
      id: '',
      totalAmount: totalAmount,
      paidAmount: totalAmount,
      paymentType: PaymentType.fullPayment,
      primaryMethod: PaymentMethod.cash,
      methods: [PaymentMethod.cash],
      methodBreakdown: {'cash': totalAmount},
    );

    state = EnhancedTakeawayOrder(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      customerName: '',
      customerPhone: '',
      items: items,
      orderType: TakeawayOrderType.orderNow,
      paymentDetails: payment,
      orderDate: DateTime.now(),
      taxAmount: taxAmount,
      discountAmount: discountAmount,
    );
  }

  void updateOrderType(TakeawayOrderType type) {
    if (state != null) {
      state = state!.copyWith(
        orderType: type,
        scheduleDetails: type == TakeawayOrderType.orderNow ? null : state!.scheduleDetails,
      );
    }
  }

  void updateScheduleDetails(ScheduleDetails? schedule) {
    if (state != null) {
      state = state!.copyWith(scheduleDetails: schedule);
    }
  }

  void updatePaymentDetails(PaymentDetails payment) {
    if (state != null) {
      state = state!.copyWith(paymentDetails: payment);
    }
  }

  void updateCustomerDetails({
    String? name,
    String? phone,
    String? email,
    String? notes,
  }) {
    if (state != null) {
      state = state!.copyWith(
        customerName: name ?? state!.customerName,
        customerPhone: phone ?? state!.customerPhone,
        customerEmail: email ?? state!.customerEmail,
        notes: notes ?? state!.notes,
      );
    }
  }

  void clearOrder() {
    state = null;
  }
}

// Orders list provider
final takeawayOrdersProvider = StateNotifierProvider<TakeawayOrdersNotifier, AsyncValue<List<EnhancedTakeawayOrder>>>((ref) {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return TakeawayOrdersNotifier(service);
});

class TakeawayOrdersNotifier extends StateNotifier<AsyncValue<List<EnhancedTakeawayOrder>>> {
  final EnhancedTakeawayService _service;

  TakeawayOrdersNotifier(this._service) : super(const AsyncValue.loading()) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      state = const AsyncValue.loading();
      final orders = await _service.getOrders(limit: 50);
      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> refreshOrders() async {
    await _loadOrders();
  }

  Future<void> loadOrdersByStatus(TakeawayOrderStatus status) async {
    try {
      state = const AsyncValue.loading();
      final orders = await _service.getOrders(status: status, limit: 50);
      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadOrdersByType(TakeawayOrderType type) async {
    try {
      state = const AsyncValue.loading();
      final orders = await _service.getOrders(orderType: type, limit: 50);
      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> loadOrdersByDateRange(DateTime from, DateTime to) async {
    try {
      state = const AsyncValue.loading();
      final orders = await _service.getOrders(fromDate: from, toDate: to, limit: 100);
      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  Future<void> updateOrderStatus(String orderId, TakeawayOrderStatus status) async {
    try {
      await _service.updateOrderStatus(orderId, status);
      await _loadOrders(); // Refresh the list
    } catch (error) {
      // Handle error - could show a snackbar or toast
      rethrow;
    }
  }

  Future<void> updatePaymentStatus(String orderId, PaymentDetails payment) async {
    try {
      await _service.updatePaymentStatus(orderId, payment);
      await _loadOrders(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }

  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _service.cancelOrder(orderId, reason);
      await _loadOrders(); // Refresh the list
    } catch (error) {
      rethrow;
    }
  }
}

// Individual order provider
final takeawayOrderProvider = FutureProvider.family<EnhancedTakeawayOrder?, String>((ref, orderId) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return await service.getOrderById(orderId);
});

// Time slots provider
final timeSlotProvider = FutureProvider.family<List<TimeSlot>, DateTime>((ref, date) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return await service.getAvailableTimeSlots(date);
});

// Statistics provider
final takeawayStatsProvider = FutureProvider.family<Map<String, dynamic>, DateRange>((ref, dateRange) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return await service.getTakeawayStats(
    fromDate: dateRange.from,
    toDate: dateRange.to,
  );
});

class DateRange {
  final DateTime from;
  final DateTime to;

  DateRange({required this.from, required this.to});
}

// Search provider
final orderSearchProvider = StateNotifierProvider<OrderSearchNotifier, AsyncValue<List<EnhancedTakeawayOrder>>>((ref) {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return OrderSearchNotifier(service);
});

class OrderSearchNotifier extends StateNotifier<AsyncValue<List<EnhancedTakeawayOrder>>> {
  final EnhancedTakeawayService _service;

  OrderSearchNotifier(this._service) : super(const AsyncValue.data([]));

  Future<void> searchOrders(String query) async {
    if (query.trim().isEmpty) {
      state = const AsyncValue.data([]);
      return;
    }

    try {
      state = const AsyncValue.loading();
      final orders = await _service.searchOrders(query);
      state = AsyncValue.data(orders);
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
    }
  }

  void clearSearch() {
    state = const AsyncValue.data([]);
  }
}

// Filter state provider
final orderFilterProvider = StateNotifierProvider<OrderFilterNotifier, OrderFilter>((ref) {
  return OrderFilterNotifier();
});

class OrderFilter {
  final TakeawayOrderStatus? status;
  final TakeawayOrderType? orderType;
  final PaymentStatus? paymentStatus;
  final DateTime? fromDate;
  final DateTime? toDate;

  OrderFilter({
    this.status,
    this.orderType,
    this.paymentStatus,
    this.fromDate,
    this.toDate,
  });

  OrderFilter copyWith({
    TakeawayOrderStatus? status,
    TakeawayOrderType? orderType,
    PaymentStatus? paymentStatus,
    DateTime? fromDate,
    DateTime? toDate,
  }) {
    return OrderFilter(
      status: status ?? this.status,
      orderType: orderType ?? this.orderType,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      fromDate: fromDate ?? this.fromDate,
      toDate: toDate ?? this.toDate,
    );
  }

  bool get hasFilters => 
      status != null || 
      orderType != null || 
      paymentStatus != null || 
      fromDate != null || 
      toDate != null;
}

class OrderFilterNotifier extends StateNotifier<OrderFilter> {
  OrderFilterNotifier() : super(OrderFilter());

  void updateStatus(TakeawayOrderStatus? status) {
    state = state.copyWith(status: status);
  }

  void updateOrderType(TakeawayOrderType? orderType) {
    state = state.copyWith(orderType: orderType);
  }

  void updatePaymentStatus(PaymentStatus? paymentStatus) {
    state = state.copyWith(paymentStatus: paymentStatus);
  }

  void updateDateRange(DateTime? fromDate, DateTime? toDate) {
    state = state.copyWith(fromDate: fromDate, toDate: toDate);
  }

  void clearFilters() {
    state = OrderFilter();
  }
}

// Real-time orders stream provider
final realTimeOrdersProvider = StreamProvider.family<List<EnhancedTakeawayOrder>, TakeawayOrderStatus?>((ref, status) {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return service.subscribeToOrders(status: status);
});

// Real-time single order stream provider
final realTimeOrderProvider = StreamProvider.family<EnhancedTakeawayOrder?, String>((ref, orderId) {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return service.subscribeToOrder(orderId);
});

// Order submission provider
final orderSubmissionProvider = StateNotifierProvider<OrderSubmissionNotifier, AsyncValue<String?>>((ref) {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return OrderSubmissionNotifier(service);
});

class OrderSubmissionNotifier extends StateNotifier<AsyncValue<String?>> {
  final EnhancedTakeawayService _service;

  OrderSubmissionNotifier(this._service) : super(const AsyncValue.data(null));

  Future<String?> submitOrder(EnhancedTakeawayOrder order) async {
    try {
      state = const AsyncValue.loading();
      final orderId = await _service.createOrder(order);
      state = AsyncValue.data(orderId);
      return orderId;
    } catch (error, stackTrace) {
      state = AsyncValue.error(error, stackTrace);
      return null;
    }
  }

  void reset() {
    state = const AsyncValue.data(null);
  }
}

// Quick stats provider for dashboard
final quickStatsProvider = FutureProvider<Map<String, dynamic>>((ref) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  final today = DateTime.now();
  final startOfDay = DateTime(today.year, today.month, today.day);
  final endOfDay = startOfDay.add(const Duration(days: 1));
  
  return await service.getTakeawayStats(
    fromDate: startOfDay,
    toDate: endOfDay,
  );
});

// Recent orders provider
final recentOrdersProvider = FutureProvider<List<EnhancedTakeawayOrder>>((ref) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return await service.getOrders(limit: 10);
});

// Pending orders provider
final pendingOrdersProvider = FutureProvider<List<EnhancedTakeawayOrder>>((ref) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  final orders = await service.getOrders(limit: 50);
  return orders.where((order) => 
      order.status == TakeawayOrderStatus.placed ||
      order.status == TakeawayOrderStatus.confirmed ||
      order.status == TakeawayOrderStatus.preparing ||
      order.status == TakeawayOrderStatus.ready
  ).toList();
});

// Scheduled orders provider
final scheduledOrdersProvider = FutureProvider<List<EnhancedTakeawayOrder>>((ref) async {
  final service = ref.watch(enhancedTakeawayServiceProvider);
  return await service.getOrders(
    status: TakeawayOrderStatus.scheduled,
    limit: 50,
  );
});
