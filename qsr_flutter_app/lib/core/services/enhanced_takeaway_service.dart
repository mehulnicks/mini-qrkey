import 'dart:convert';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../core/config/supabase_config.dart';
import '../../shared/models/enhanced_takeaway_models.dart';

class EnhancedTakeawayService {
  SupabaseClient get _client => SupabaseConfig.client;

  // Order Management
  Future<String> createOrder(EnhancedTakeawayOrder order) async {
    try {
      // First create the main order
      final orderData = {
        'id': order.id,
        'customer_name': order.customerName,
        'customer_phone': order.customerPhone,
        'customer_email': order.customerEmail,
        'order_type': order.orderType.toString().split('.').last,
        'status': order.status.toString().split('.').last,
        'order_date': order.orderDate.toIso8601String(),
        'estimated_pickup_time': order.estimatedPickupTime?.toIso8601String(),
        'actual_pickup_time': order.actualPickupTime?.toIso8601String(),
        'notes': order.notes,
        'subtotal': order.subtotal,
        'tax_amount': order.taxAmount,
        'discount_amount': order.discountAmount,
        'total_amount': order.totalAmount,
        'requires_kitchen_notification': order.requiresKitchenNotification,
        'payment_details': jsonEncode(order.paymentDetails.toJson()),
        'schedule_details': order.scheduleDetails != null 
            ? jsonEncode(order.scheduleDetails!.toJson()) 
            : null,
        'created_at': DateTime.now().toIso8601String(),
        'updated_at': DateTime.now().toIso8601String(),
      };

      final response = await _client
          .from('takeaway_orders')
          .insert(orderData)
          .select()
          .single();

      final orderId = response['id'] as String;

      // Create order items
      for (final item in order.items) {
        await _client.from('takeaway_order_items').insert({
          'order_id': orderId,
          'item_name': item['name'],
          'item_price': item['price'],
          'quantity': item['quantity'],
          'subtotal': (item['price'] ?? 0.0) * (item['quantity'] ?? 1),
          'special_instructions': item['instructions'] ?? '',
          'created_at': DateTime.now().toIso8601String(),
        });
      }

      // If scheduled order, create schedule entry
      if (order.scheduleDetails?.isScheduled == true) {
        await _createScheduleEntry(orderId, order.scheduleDetails!);
      }

      // Create payment tracking entry
      await _createPaymentEntry(orderId, order.paymentDetails);

      return orderId;
    } catch (e) {
      throw Exception('Failed to create order: $e');
    }
  }

  Future<void> _createScheduleEntry(String orderId, ScheduleDetails schedule) async {
    await _client.from('order_schedules').insert({
      'order_id': orderId,
      'scheduled_date': schedule.scheduledDate?.toIso8601String(),
      'time_slot_id': schedule.timeSlot?.id,
      'special_instructions': schedule.specialInstructions,
      'minimum_lead_time_hours': schedule.minimumLeadTime.inHours,
      'is_flexible_time': schedule.isFlexibleTime,
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  Future<void> _createPaymentEntry(String orderId, PaymentDetails payment) async {
    await _client.from('order_payments').insert({
      'order_id': orderId,
      'total_amount': payment.totalAmount,
      'paid_amount': payment.paidAmount,
      'remaining_amount': payment.remainingAmount,
      'payment_type': payment.paymentType.toString().split('.').last,
      'primary_method': payment.primaryMethod.toString().split('.').last,
      'methods': jsonEncode(payment.methods.map((m) => m.toString().split('.').last).toList()),
      'status': payment.status.toString().split('.').last,
      'payment_date': payment.paymentDate?.toIso8601String(),
      'full_payment_date': payment.fullPaymentDate?.toIso8601String(),
      'method_breakdown': jsonEncode(payment.methodBreakdown),
      'created_at': DateTime.now().toIso8601String(),
    });
  }

  // Get orders with filters
  Future<List<EnhancedTakeawayOrder>> getOrders({
    TakeawayOrderStatus? status,
    TakeawayOrderType? orderType,
    DateTime? fromDate,
    DateTime? toDate,
    int limit = 50,
  }) async {
    try {
      // Build filter values
      String? statusFilter;
      String? orderTypeFilter;
      String? fromDateFilter;
      String? toDateFilter;

      if (status != null) {
        statusFilter = status.toString().split('.').last;
      }

      if (orderType != null) {
        orderTypeFilter = orderType.toString().split('.').last;
      }

      if (fromDate != null) {
        fromDateFilter = fromDate.toIso8601String();
      }

      if (toDate != null) {
        toDateFilter = toDate.toIso8601String();
      }

      var query = _client
          .from('takeaway_orders')
          .select('*');

      // Apply filters
      if (statusFilter != null) {
        query = query.eq('status', statusFilter);
      }

      if (orderTypeFilter != null) {
        query = query.eq('order_type', orderTypeFilter);
      }

      if (fromDateFilter != null) {
        query = query.gte('order_date', fromDateFilter);
      }

      if (toDateFilter != null) {
        query = query.lte('order_date', toDateFilter);
      }

      final response = await query
          .order('created_at', ascending: false)
          .limit(limit);
      
      List<EnhancedTakeawayOrder> orders = [];
      for (final orderData in response) {
        // Get order items
        final itemsResponse = await _client
            .from('takeaway_order_items')
            .select('*')
            .eq('order_id', orderData['id']);

        final items = itemsResponse.map<Map<String, dynamic>>((item) => {
          'name': item['item_name'],
          'price': item['item_price'],
          'quantity': item['quantity'],
          'instructions': item['special_instructions'] ?? '',
        }).toList();

        orders.add(_parseOrderFromDatabase(orderData, items));
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to get orders: $e');
    }
  }

  // Get single order by ID
  Future<EnhancedTakeawayOrder?> getOrderById(String orderId) async {
    try {
      final orderResponse = await _client
          .from('takeaway_orders')
          .select('*')
          .eq('id', orderId)
          .single();

      final itemsResponse = await _client
          .from('takeaway_order_items')
          .select('*')
          .eq('order_id', orderId);

      final items = itemsResponse.map<Map<String, dynamic>>((item) => {
        'name': item['item_name'],
        'price': item['item_price'],
        'quantity': item['quantity'],
        'instructions': item['special_instructions'] ?? '',
      }).toList();

      return _parseOrderFromDatabase(orderResponse, items);
    } catch (e) {
      return null;
    }
  }

  // Update order status
  Future<void> updateOrderStatus(String orderId, TakeawayOrderStatus status) async {
    try {
      await _client
          .from('takeaway_orders')
          .update({
            'status': status.toString().split('.').last,
            'updated_at': DateTime.now().toIso8601String(),
            if (status == TakeawayOrderStatus.completed)
              'actual_pickup_time': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);

      // Notify listeners about status change
      await _notifyStatusChange(orderId, status);
    } catch (e) {
      throw Exception('Failed to update order status: $e');
    }
  }

  // Update payment status
  Future<void> updatePaymentStatus(String orderId, PaymentDetails payment) async {
    try {
      await _client
          .from('order_payments')
          .update({
            'paid_amount': payment.paidAmount,
            'remaining_amount': payment.remainingAmount,
            'status': payment.status.toString().split('.').last,
            'full_payment_date': payment.isFullyPaid 
                ? DateTime.now().toIso8601String() 
                : null,
            'method_breakdown': jsonEncode(payment.methodBreakdown),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('order_id', orderId);

      // Update order payment details
      await _client
          .from('takeaway_orders')
          .update({
            'payment_details': jsonEncode(payment.toJson()),
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);
    } catch (e) {
      throw Exception('Failed to update payment status: $e');
    }
  }

  // Time Slot Management
  Future<List<TimeSlot>> getAvailableTimeSlots(DateTime date) async {
    try {
      final response = await _client
          .from('time_slots')
          .select('*')
          .eq('date', date.toIso8601String().split('T')[0])
          .eq('is_available', true)
          .order('start_time');

      return response.map<TimeSlot>((slot) => TimeSlot.fromJson(slot)).toList();
    } catch (e) {
      // Generate default time slots if none exist
      return _generateDefaultTimeSlots(date);
    }
  }

  Future<void> bookTimeSlot(String slotId, String orderId) async {
    try {
      // Update current orders count
      await _client.rpc('increment_slot_bookings', params: {
        'slot_id': slotId,
        'order_id': orderId,
      });
    } catch (e) {
      throw Exception('Failed to book time slot: $e');
    }
  }

  // Statistics and Analytics
  Future<Map<String, dynamic>> getTakeawayStats({
    DateTime? fromDate,
    DateTime? toDate,
  }) async {
    try {
      fromDate ??= DateTime.now().subtract(const Duration(days: 30));
      toDate ??= DateTime.now();

      final response = await _client.rpc('get_takeaway_stats', params: {
        'from_date': fromDate.toIso8601String(),
        'to_date': toDate.toIso8601String(),
      });

      return response;
    } catch (e) {
      return {
        'total_orders': 0,
        'total_revenue': 0.0,
        'average_order_value': 0.0,
        'scheduled_orders_count': 0,
        'immediate_orders_count': 0,
        'partial_payments_count': 0,
        'pending_payments': 0.0,
      };
    }
  }

  // Real-time subscriptions
  Stream<List<EnhancedTakeawayOrder>> subscribeToOrders({
    TakeawayOrderStatus? status,
  }) {
    try {
      var stream = _client
          .from('takeaway_orders')
          .stream(primaryKey: ['id']);

      if (status != null) {
        final statusStr = status.toString().split('.').last;
        return _client
            .from('takeaway_orders')
            .stream(primaryKey: ['id'])
            .eq('status', statusStr)
            .map((data) => data
                .map((orderData) => _parseOrderFromDatabase(orderData, []))
                .toList());
      }

      return stream.map((data) => data
          .map((orderData) => _parseOrderFromDatabase(orderData, []))
          .toList());
    } catch (e) {
      // Fallback to empty stream if real-time fails
      return Stream.value([]);
    }
  }

  Stream<EnhancedTakeawayOrder?> subscribeToOrder(String orderId) {
    try {
      return _client
          .from('takeaway_orders')
          .stream(primaryKey: ['id'])
          .eq('id', orderId)
          .map((data) => data.isNotEmpty 
              ? _parseOrderFromDatabase(data.first, []) 
              : null);
    } catch (e) {
      return Stream.value(null);
    }
  }

  // Helper methods
  EnhancedTakeawayOrder _parseOrderFromDatabase(
    Map<String, dynamic> orderData,
    List<Map<String, dynamic>> items,
  ) {
    final paymentDetails = orderData['payment_details'] != null
        ? PaymentDetails.fromJson(jsonDecode(orderData['payment_details']))
        : PaymentDetails(
            id: '',
            totalAmount: (orderData['total_amount'] ?? 0.0).toDouble(),
            paidAmount: (orderData['total_amount'] ?? 0.0).toDouble(),
            paymentType: PaymentType.fullPayment,
            primaryMethod: PaymentMethod.cash,
          );

    final scheduleDetails = orderData['schedule_details'] != null
        ? ScheduleDetails.fromJson(jsonDecode(orderData['schedule_details']))
        : null;

    return EnhancedTakeawayOrder(
      id: orderData['id'],
      customerName: orderData['customer_name'] ?? '',
      customerPhone: orderData['customer_phone'] ?? '',
      customerEmail: orderData['customer_email'] ?? '',
      items: items,
      orderType: TakeawayOrderType.values.firstWhere(
        (e) => e.toString() == 'TakeawayOrderType.${orderData['order_type']}',
        orElse: () => TakeawayOrderType.orderNow,
      ),
      status: TakeawayOrderStatus.values.firstWhere(
        (e) => e.toString() == 'TakeawayOrderStatus.${orderData['status']}',
        orElse: () => TakeawayOrderStatus.placed,
      ),
      paymentDetails: paymentDetails,
      scheduleDetails: scheduleDetails,
      orderDate: DateTime.parse(orderData['order_date']),
      estimatedPickupTime: orderData['estimated_pickup_time'] != null
          ? DateTime.parse(orderData['estimated_pickup_time'])
          : null,
      actualPickupTime: orderData['actual_pickup_time'] != null
          ? DateTime.parse(orderData['actual_pickup_time'])
          : null,
      notes: orderData['notes'] ?? '',
      taxAmount: (orderData['tax_amount'] ?? 0.0).toDouble(),
      discountAmount: (orderData['discount_amount'] ?? 0.0).toDouble(),
      requiresKitchenNotification: orderData['requires_kitchen_notification'] ?? true,
    );
  }

  List<TimeSlot> _generateDefaultTimeSlots(DateTime date) {
    final slots = <TimeSlot>[];
    final now = DateTime.now();
    
    for (int hour = 9; hour <= 21; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final slotStart = DateTime(date.year, date.month, date.day, hour, minute);
        final slotEnd = slotStart.add(const Duration(minutes: 30));
        
        // Skip past time slots
        if (slotStart.isBefore(now.add(const Duration(hours: 2)))) continue;
        
        slots.add(TimeSlot(
          id: '${date.toIso8601String().split('T')[0]}_${hour}_$minute',
          startTime: slotStart,
          endTime: slotEnd,
          isAvailable: true,
          maxOrders: 10,
          currentOrders: 0,
        ));
      }
    }
    
    return slots;
  }

  Future<void> _notifyStatusChange(String orderId, TakeawayOrderStatus status) async {
    // Implement push notifications or real-time updates here
    // This could integrate with FCM, websockets, or other notification systems
  }

  // Cancel order
  Future<void> cancelOrder(String orderId, String reason) async {
    try {
      await _client
          .from('takeaway_orders')
          .update({
            'status': TakeawayOrderStatus.cancelled.toString().split('.').last,
            'notes': 'Cancelled: $reason',
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', orderId);

      // Handle refund logic here if needed
      await _handleOrderCancellation(orderId, reason);
    } catch (e) {
      throw Exception('Failed to cancel order: $e');
    }
  }

  Future<void> _handleOrderCancellation(String orderId, String reason) async {
    // Implement cancellation logic (refunds, notifications, etc.)
    // This could involve payment gateway integration for refunds
  }

  // Search orders
  Future<List<EnhancedTakeawayOrder>> searchOrders(String query) async {
    try {
      final response = await _client
          .from('takeaway_orders')
          .select('*')
          .or('customer_name.ilike.%$query%,customer_phone.ilike.%$query%,id.ilike.%$query%')
          .order('created_at', ascending: false)
          .limit(20);

      List<EnhancedTakeawayOrder> orders = [];
      for (final orderData in response) {
        final itemsResponse = await _client
            .from('takeaway_order_items')
            .select('*')
            .eq('order_id', orderData['id']);

        final items = itemsResponse.map<Map<String, dynamic>>((item) => {
          'name': item['item_name'],
          'price': item['item_price'],
          'quantity': item['quantity'],
          'instructions': item['special_instructions'] ?? '',
        }).toList();

        orders.add(_parseOrderFromDatabase(orderData, items));
      }

      return orders;
    } catch (e) {
      throw Exception('Failed to search orders: $e');
    }
  }
}
