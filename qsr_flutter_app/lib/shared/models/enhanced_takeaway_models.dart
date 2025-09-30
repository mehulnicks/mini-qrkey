// Enhanced Takeaway Models
// Supports dual ordering (immediate vs scheduled) with flexible payment options

enum TakeawayOrderType {
  orderNow,
  scheduleOrder,
}

enum TakeawayOrderStatus {
  placed,
  confirmed,
  preparing,
  ready,
  completed,
  cancelled,
  scheduled, // For future orders waiting to be processed
}

enum PaymentType {
  fullPayment,
  partialPayment,
}

enum PaymentMethod {
  cash,
  card,
  upi,
  digital,
  split, // Multiple payment methods
}

enum PaymentStatus {
  pending,
  partial,
  completed,
  refunded,
}

class TimeSlot {
  final String id;
  final DateTime startTime;
  final DateTime endTime;
  final bool isAvailable;
  final int maxOrders;
  final int currentOrders;

  TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    required this.isAvailable,
    required this.maxOrders,
    this.currentOrders = 0,
  });

  bool get hasCapacity => currentOrders < maxOrders && isAvailable;
  
  String get displayTime => 
      '${startTime.hour.toString().padLeft(2, '0')}:${startTime.minute.toString().padLeft(2, '0')} - '
      '${endTime.hour.toString().padLeft(2, '0')}:${endTime.minute.toString().padLeft(2, '0')}';

  factory TimeSlot.fromJson(Map<String, dynamic> json) {
    return TimeSlot(
      id: json['id'] ?? '',
      startTime: DateTime.parse(json['start_time']),
      endTime: DateTime.parse(json['end_time']),
      isAvailable: json['is_available'] ?? true,
      maxOrders: json['max_orders'] ?? 10,
      currentOrders: json['current_orders'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
      'is_available': isAvailable,
      'max_orders': maxOrders,
      'current_orders': currentOrders,
    };
  }
}

class PaymentDetails {
  final String id;
  final double totalAmount;
  final double paidAmount;
  final double remainingAmount;
  final PaymentType paymentType;
  final PaymentMethod primaryMethod;
  final List<PaymentMethod> methods;
  final PaymentStatus status;
  final DateTime? paymentDate;
  final DateTime? fullPaymentDate;
  final Map<String, double> methodBreakdown; // Method -> Amount

  PaymentDetails({
    required this.id,
    required this.totalAmount,
    required this.paidAmount,
    required this.paymentType,
    required this.primaryMethod,
    this.methods = const [],
    this.status = PaymentStatus.pending,
    this.paymentDate,
    this.fullPaymentDate,
    this.methodBreakdown = const {},
  }) : remainingAmount = totalAmount - paidAmount;

  bool get isFullyPaid => remainingAmount <= 0;
  bool get isPartiallyPaid => paidAmount > 0 && remainingAmount > 0;
  double get paidPercentage => totalAmount > 0 ? (paidAmount / totalAmount) * 100 : 0;

  PaymentDetails copyWith({
    String? id,
    double? totalAmount,
    double? paidAmount,
    PaymentType? paymentType,
    PaymentMethod? primaryMethod,
    List<PaymentMethod>? methods,
    PaymentStatus? status,
    DateTime? paymentDate,
    DateTime? fullPaymentDate,
    Map<String, double>? methodBreakdown,
  }) {
    return PaymentDetails(
      id: id ?? this.id,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      paymentType: paymentType ?? this.paymentType,
      primaryMethod: primaryMethod ?? this.primaryMethod,
      methods: methods ?? this.methods,
      status: status ?? this.status,
      paymentDate: paymentDate ?? this.paymentDate,
      fullPaymentDate: fullPaymentDate ?? this.fullPaymentDate,
      methodBreakdown: methodBreakdown ?? this.methodBreakdown,
    );
  }

  factory PaymentDetails.fromJson(Map<String, dynamic> json) {
    return PaymentDetails(
      id: json['id'] ?? '',
      totalAmount: (json['total_amount'] ?? 0).toDouble(),
      paidAmount: (json['paid_amount'] ?? 0).toDouble(),
      paymentType: PaymentType.values.firstWhere(
        (e) => e.toString() == 'PaymentType.${json['payment_type']}',
        orElse: () => PaymentType.fullPayment,
      ),
      primaryMethod: PaymentMethod.values.firstWhere(
        (e) => e.toString() == 'PaymentMethod.${json['primary_method']}',
        orElse: () => PaymentMethod.cash,
      ),
      methods: (json['methods'] as List<dynamic>?)
          ?.map((m) => PaymentMethod.values.firstWhere(
                (e) => e.toString() == 'PaymentMethod.$m',
                orElse: () => PaymentMethod.cash,
              ))
          .toList() ?? [],
      status: PaymentStatus.values.firstWhere(
        (e) => e.toString() == 'PaymentStatus.${json['status']}',
        orElse: () => PaymentStatus.pending,
      ),
      paymentDate: json['payment_date'] != null 
          ? DateTime.parse(json['payment_date']) 
          : null,
      fullPaymentDate: json['full_payment_date'] != null 
          ? DateTime.parse(json['full_payment_date']) 
          : null,
      methodBreakdown: Map<String, double>.from(json['method_breakdown'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'total_amount': totalAmount,
      'paid_amount': paidAmount,
      'remaining_amount': remainingAmount,
      'payment_type': paymentType.toString().split('.').last,
      'primary_method': primaryMethod.toString().split('.').last,
      'methods': methods.map((m) => m.toString().split('.').last).toList(),
      'status': status.toString().split('.').last,
      'payment_date': paymentDate?.toIso8601String(),
      'full_payment_date': fullPaymentDate?.toIso8601String(),
      'method_breakdown': methodBreakdown,
    };
  }
}

class ScheduleDetails {
  final DateTime? scheduledDate;
  final TimeSlot? timeSlot;
  final String specialInstructions;
  final Duration minimumLeadTime;
  final bool isFlexibleTime;

  ScheduleDetails({
    this.scheduledDate,
    this.timeSlot,
    this.specialInstructions = '',
    this.minimumLeadTime = const Duration(hours: 2),
    this.isFlexibleTime = false,
  });

  bool get isScheduled => scheduledDate != null;
  bool get isValidSchedule => scheduledDate != null && 
      scheduledDate!.isAfter(DateTime.now().add(minimumLeadTime));

  String get displaySchedule {
    if (!isScheduled) return 'Order Now';
    return 'Scheduled for ${scheduledDate!.day}/${scheduledDate!.month}/${scheduledDate!.year} at ${timeSlot?.displayTime ?? "Flexible Time"}';
  }

  factory ScheduleDetails.fromJson(Map<String, dynamic> json) {
    return ScheduleDetails(
      scheduledDate: json['scheduled_date'] != null 
          ? DateTime.parse(json['scheduled_date']) 
          : null,
      timeSlot: json['time_slot'] != null 
          ? TimeSlot.fromJson(json['time_slot']) 
          : null,
      specialInstructions: json['special_instructions'] ?? '',
      minimumLeadTime: Duration(
        hours: json['minimum_lead_time_hours'] ?? 2,
      ),
      isFlexibleTime: json['is_flexible_time'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'scheduled_date': scheduledDate?.toIso8601String(),
      'time_slot': timeSlot?.toJson(),
      'special_instructions': specialInstructions,
      'minimum_lead_time_hours': minimumLeadTime.inHours,
      'is_flexible_time': isFlexibleTime,
    };
  }
}

class EnhancedTakeawayOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String customerEmail;
  final List<Map<String, dynamic>> items;
  final TakeawayOrderType orderType;
  final TakeawayOrderStatus status;
  final PaymentDetails paymentDetails;
  final ScheduleDetails? scheduleDetails;
  final DateTime orderDate;
  final DateTime? estimatedPickupTime;
  final DateTime? actualPickupTime;
  final String notes;
  final double taxAmount;
  final double discountAmount;
  final bool requiresKitchenNotification;

  EnhancedTakeawayOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    this.customerEmail = '',
    required this.items,
    required this.orderType,
    this.status = TakeawayOrderStatus.placed,
    required this.paymentDetails,
    this.scheduleDetails,
    required this.orderDate,
    this.estimatedPickupTime,
    this.actualPickupTime,
    this.notes = '',
    this.taxAmount = 0.0,
    this.discountAmount = 0.0,
    this.requiresKitchenNotification = true,
  });

  double get subtotal => items.fold(0.0, (sum, item) => 
      sum + ((item['price'] ?? 0.0) * (item['quantity'] ?? 1)));
  
  double get totalAmount => subtotal + taxAmount - discountAmount;
  
  bool get isScheduledOrder => orderType == TakeawayOrderType.scheduleOrder;
  bool get isImmediateOrder => orderType == TakeawayOrderType.orderNow;
  bool get isReadyForProcessing => isImmediateOrder || 
      (isScheduledOrder && scheduleDetails?.isValidSchedule == true &&
       DateTime.now().isAfter(scheduleDetails!.scheduledDate!.subtract(Duration(minutes: 30))));

  String get statusDisplay {
    switch (status) {
      case TakeawayOrderStatus.placed:
        return isScheduledOrder ? 'Scheduled' : 'Order Placed';
      case TakeawayOrderStatus.confirmed:
        return 'Confirmed';
      case TakeawayOrderStatus.preparing:
        return 'Preparing';
      case TakeawayOrderStatus.ready:
        return 'Ready for Pickup';
      case TakeawayOrderStatus.completed:
        return 'Completed';
      case TakeawayOrderStatus.cancelled:
        return 'Cancelled';
      case TakeawayOrderStatus.scheduled:
        return 'Scheduled for ${scheduleDetails?.displaySchedule ?? "Later"}';
    }
  }

  EnhancedTakeawayOrder copyWith({
    String? id,
    String? customerName,
    String? customerPhone,
    String? customerEmail,
    List<Map<String, dynamic>>? items,
    TakeawayOrderType? orderType,
    TakeawayOrderStatus? status,
    PaymentDetails? paymentDetails,
    ScheduleDetails? scheduleDetails,
    DateTime? orderDate,
    DateTime? estimatedPickupTime,
    DateTime? actualPickupTime,
    String? notes,
    double? taxAmount,
    double? discountAmount,
    bool? requiresKitchenNotification,
  }) {
    return EnhancedTakeawayOrder(
      id: id ?? this.id,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      customerEmail: customerEmail ?? this.customerEmail,
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      status: status ?? this.status,
      paymentDetails: paymentDetails ?? this.paymentDetails,
      scheduleDetails: scheduleDetails ?? this.scheduleDetails,
      orderDate: orderDate ?? this.orderDate,
      estimatedPickupTime: estimatedPickupTime ?? this.estimatedPickupTime,
      actualPickupTime: actualPickupTime ?? this.actualPickupTime,
      notes: notes ?? this.notes,
      taxAmount: taxAmount ?? this.taxAmount,
      discountAmount: discountAmount ?? this.discountAmount,
      requiresKitchenNotification: requiresKitchenNotification ?? this.requiresKitchenNotification,
    );
  }

  factory EnhancedTakeawayOrder.fromJson(Map<String, dynamic> json) {
    return EnhancedTakeawayOrder(
      id: json['id'] ?? '',
      customerName: json['customer_name'] ?? '',
      customerPhone: json['customer_phone'] ?? '',
      customerEmail: json['customer_email'] ?? '',
      items: List<Map<String, dynamic>>.from(json['items'] ?? []),
      orderType: TakeawayOrderType.values.firstWhere(
        (e) => e.toString() == 'TakeawayOrderType.${json['order_type']}',
        orElse: () => TakeawayOrderType.orderNow,
      ),
      status: TakeawayOrderStatus.values.firstWhere(
        (e) => e.toString() == 'TakeawayOrderStatus.${json['status']}',
        orElse: () => TakeawayOrderStatus.placed,
      ),
      paymentDetails: PaymentDetails.fromJson(json['payment_details'] ?? {}),
      scheduleDetails: json['schedule_details'] != null 
          ? ScheduleDetails.fromJson(json['schedule_details']) 
          : null,
      orderDate: DateTime.parse(json['order_date']),
      estimatedPickupTime: json['estimated_pickup_time'] != null 
          ? DateTime.parse(json['estimated_pickup_time']) 
          : null,
      actualPickupTime: json['actual_pickup_time'] != null 
          ? DateTime.parse(json['actual_pickup_time']) 
          : null,
      notes: json['notes'] ?? '',
      taxAmount: (json['tax_amount'] ?? 0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0).toDouble(),
      requiresKitchenNotification: json['requires_kitchen_notification'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'customer_email': customerEmail,
      'items': items,
      'order_type': orderType.toString().split('.').last,
      'status': status.toString().split('.').last,
      'payment_details': paymentDetails.toJson(),
      'schedule_details': scheduleDetails?.toJson(),
      'order_date': orderDate.toIso8601String(),
      'estimated_pickup_time': estimatedPickupTime?.toIso8601String(),
      'actual_pickup_time': actualPickupTime?.toIso8601String(),
      'notes': notes,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total_amount': totalAmount,
      'requires_kitchen_notification': requiresKitchenNotification,
    };
  }
}

// Configuration for takeaway ordering
class TakeawayConfig {
  final Duration minimumLeadTime;
  final Duration maximumAdvanceTime;
  final List<TimeSlot> availableTimeSlots;
  final bool allowFlexibleTiming;
  final double minimumPartialPaymentPercentage;
  final List<PaymentMethod> acceptedPaymentMethods;
  final bool requireCustomerDetails;
  final int maxOrdersPerTimeSlot;

  TakeawayConfig({
    this.minimumLeadTime = const Duration(hours: 2),
    this.maximumAdvanceTime = const Duration(days: 7),
    this.availableTimeSlots = const [],
    this.allowFlexibleTiming = true,
    this.minimumPartialPaymentPercentage = 20.0,
    this.acceptedPaymentMethods = const [
      PaymentMethod.cash,
      PaymentMethod.card,
      PaymentMethod.upi,
    ],
    this.requireCustomerDetails = true,
    this.maxOrdersPerTimeSlot = 10,
  });

  factory TakeawayConfig.fromJson(Map<String, dynamic> json) {
    return TakeawayConfig(
      minimumLeadTime: Duration(hours: json['minimum_lead_time_hours'] ?? 2),
      maximumAdvanceTime: Duration(days: json['maximum_advance_time_days'] ?? 7),
      availableTimeSlots: (json['available_time_slots'] as List<dynamic>?)
          ?.map((slot) => TimeSlot.fromJson(slot))
          .toList() ?? [],
      allowFlexibleTiming: json['allow_flexible_timing'] ?? true,
      minimumPartialPaymentPercentage: 
          (json['minimum_partial_payment_percentage'] ?? 20.0).toDouble(),
      acceptedPaymentMethods: (json['accepted_payment_methods'] as List<dynamic>?)
          ?.map((method) => PaymentMethod.values.firstWhere(
                (e) => e.toString() == 'PaymentMethod.$method',
                orElse: () => PaymentMethod.cash,
              ))
          .toList() ?? [PaymentMethod.cash],
      requireCustomerDetails: json['require_customer_details'] ?? true,
      maxOrdersPerTimeSlot: json['max_orders_per_time_slot'] ?? 10,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimum_lead_time_hours': minimumLeadTime.inHours,
      'maximum_advance_time_days': maximumAdvanceTime.inDays,
      'available_time_slots': availableTimeSlots.map((slot) => slot.toJson()).toList(),
      'allow_flexible_timing': allowFlexibleTiming,
      'minimum_partial_payment_percentage': minimumPartialPaymentPercentage,
      'accepted_payment_methods': acceptedPaymentMethods
          .map((method) => method.toString().split('.').last)
          .toList(),
      'require_customer_details': requireCustomerDetails,
      'max_orders_per_time_slot': maxOrdersPerTimeSlot,
    };
  }
}
