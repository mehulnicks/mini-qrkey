import 'package:flutter/material.dart';

// Core Enums
enum OrderType { dineIn, takeaway, delivery }
enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled, scheduled, onHold }
enum PaymentStatus { pending, partial, completed, refunded }
enum PaymentMethod { cash, card, upi, online }
enum DiscountType { percentage, fixed }

// Enhanced Order Processing Enums
enum OrderProcessingType { immediate, scheduled }
enum ScheduleStatus { pending, active, processing, completed, cancelled, expired }

// Enhanced Payment System
enum PaymentMethodType {
  cash,
  card,
  upi,
  netBanking,
  wallet,
  giftCard,
  custom,
}

// Printer Management System
enum PrinterConnectionType {
  network,
  usb,
  bluetooth;

  String get displayName {
    switch (this) {
      case PrinterConnectionType.network:
        return 'Network';
      case PrinterConnectionType.usb:
        return 'USB';
      case PrinterConnectionType.bluetooth:
        return 'Bluetooth';
    }
  }
}

enum PrinterStatus {
  connected,
  disconnected,
  connecting,
  printing,
  error,
  offline;

  String get displayName {
    switch (this) {
      case PrinterStatus.connected:
        return 'Connected';
      case PrinterStatus.disconnected:
        return 'Disconnected';
      case PrinterStatus.connecting:
        return 'Connecting';
      case PrinterStatus.printing:
        return 'Printing';
      case PrinterStatus.error:
        return 'Error';
      case PrinterStatus.offline:
        return 'Offline';
    }
  }

  Color get color {
    switch (this) {
      case PrinterStatus.connected:
        return Colors.green;
      case PrinterStatus.disconnected:
        return Colors.grey;
      case PrinterStatus.connecting:
        return Colors.blue;
      case PrinterStatus.printing:
        return Colors.orange;
      case PrinterStatus.error:
        return Colors.red;
      case PrinterStatus.offline:
        return Colors.grey;
    }
  }
}

// Order Scheduling Models
class OrderScheduleConfig {
  final int minimumLeadTimeMinutes;
  final int maximumAdvanceDays;
  final List<TimeSlot> availableTimeSlots;
  final List<int> workingDays; // 1=Monday, 7=Sunday
  final bool enableScheduling;
  
  const OrderScheduleConfig({
    this.minimumLeadTimeMinutes = 30,
    this.maximumAdvanceDays = 7,
    this.availableTimeSlots = const [],
    this.workingDays = const [1, 2, 3, 4, 5, 6, 7], // All days by default
    this.enableScheduling = true,
  });

  OrderScheduleConfig copyWith({
    int? minimumLeadTimeMinutes,
    int? maximumAdvanceDays,
    List<TimeSlot>? availableTimeSlots,
    List<int>? workingDays,
    bool? enableScheduling,
  }) {
    return OrderScheduleConfig(
      minimumLeadTimeMinutes: minimumLeadTimeMinutes ?? this.minimumLeadTimeMinutes,
      maximumAdvanceDays: maximumAdvanceDays ?? this.maximumAdvanceDays,
      availableTimeSlots: availableTimeSlots ?? this.availableTimeSlots,
      workingDays: workingDays ?? this.workingDays,
      enableScheduling: enableScheduling ?? this.enableScheduling,
    );
  }

  Map<String, dynamic> toJson() => {
    'minimumLeadTimeMinutes': minimumLeadTimeMinutes,
    'maximumAdvanceDays': maximumAdvanceDays,
    'availableTimeSlots': availableTimeSlots.map((slot) => slot.toJson()).toList(),
    'workingDays': workingDays,
    'enableScheduling': enableScheduling,
  };

  factory OrderScheduleConfig.fromJson(Map<String, dynamic> json) => OrderScheduleConfig(
    minimumLeadTimeMinutes: json['minimumLeadTimeMinutes'] ?? 30,
    maximumAdvanceDays: json['maximumAdvanceDays'] ?? 7,
    availableTimeSlots: (json['availableTimeSlots'] as List?)
        ?.map((slot) => TimeSlot.fromJson(slot))
        .toList() ?? [],
    workingDays: List<int>.from(json['workingDays'] ?? [1, 2, 3, 4, 5, 6, 7]),
    enableScheduling: json['enableScheduling'] ?? true,
  );
}

class TimeSlot {
  final String id;
  final TimeOfDay startTime;
  final TimeOfDay endTime;
  final int maxOrders;
  final bool isActive;
  final String? description;

  const TimeSlot({
    required this.id,
    required this.startTime,
    required this.endTime,
    this.maxOrders = 10,
    this.isActive = true,
    this.description,
  });

  TimeSlot copyWith({
    String? id,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? maxOrders,
    bool? isActive,
    String? description,
  }) {
    return TimeSlot(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxOrders: maxOrders ?? this.maxOrders,
      isActive: isActive ?? this.isActive,
      description: description ?? this.description,
    );
  }

  String get displayTime => '${_formatTime(startTime)} - ${_formatTime(endTime)}';

  String _formatTime(TimeOfDay time) {
    final hour = time.hour == 0 ? 12 : time.hour > 12 ? time.hour - 12 : time.hour;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$minute $period';
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'startTime': {'hour': startTime.hour, 'minute': startTime.minute},
    'endTime': {'hour': endTime.hour, 'minute': endTime.minute},
    'maxOrders': maxOrders,
    'isActive': isActive,
    'description': description,
  };

  factory TimeSlot.fromJson(Map<String, dynamic> json) => TimeSlot(
    id: json['id'],
    startTime: TimeOfDay(
      hour: json['startTime']['hour'],
      minute: json['startTime']['minute'],
    ),
    endTime: TimeOfDay(
      hour: json['endTime']['hour'],
      minute: json['endTime']['minute'],
    ),
    maxOrders: json['maxOrders'] ?? 10,
    isActive: json['isActive'] ?? true,
    description: json['description'],
  );
}

class ScheduledOrder {
  final String orderId;
  final DateTime scheduledDateTime;
  final ScheduleStatus status;
  final String? specialInstructions;
  final DateTime createdAt;
  final DateTime? activatedAt;
  final DateTime? completedAt;
  final String? customerNotificationPhone;
  final bool notificationSent;

  const ScheduledOrder({
    required this.orderId,
    required this.scheduledDateTime,
    this.status = ScheduleStatus.pending,
    this.specialInstructions,
    required this.createdAt,
    this.activatedAt,
    this.completedAt,
    this.customerNotificationPhone,
    this.notificationSent = false,
  });

  ScheduledOrder copyWith({
    String? orderId,
    DateTime? scheduledDateTime,
    ScheduleStatus? status,
    String? specialInstructions,
    DateTime? createdAt,
    DateTime? activatedAt,
    DateTime? completedAt,
    String? customerNotificationPhone,
    bool? notificationSent,
  }) {
    return ScheduledOrder(
      orderId: orderId ?? this.orderId,
      scheduledDateTime: scheduledDateTime ?? this.scheduledDateTime,
      status: status ?? this.status,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      createdAt: createdAt ?? this.createdAt,
      activatedAt: activatedAt ?? this.activatedAt,
      completedAt: completedAt ?? this.completedAt,
      customerNotificationPhone: customerNotificationPhone ?? this.customerNotificationPhone,
      notificationSent: notificationSent ?? this.notificationSent,
    );
  }

  // Check if order should be activated (5 minutes before scheduled time)
  bool get shouldActivate {
    final now = DateTime.now();
    final activationTime = scheduledDateTime.subtract(const Duration(minutes: 5));
    return now.isAfter(activationTime) && status == ScheduleStatus.pending;
  }

  // Check if order is overdue
  bool get isOverdue {
    final now = DateTime.now();
    return now.isAfter(scheduledDateTime.add(const Duration(minutes: 30))) && 
           status != ScheduleStatus.completed && 
           status != ScheduleStatus.cancelled;
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'scheduledDateTime': scheduledDateTime.toIso8601String(),
    'status': status.name,
    'specialInstructions': specialInstructions,
    'createdAt': createdAt.toIso8601String(),
    'activatedAt': activatedAt?.toIso8601String(),
    'completedAt': completedAt?.toIso8601String(),
    'customerNotificationPhone': customerNotificationPhone,
    'notificationSent': notificationSent,
  };

  factory ScheduledOrder.fromJson(Map<String, dynamic> json) => ScheduledOrder(
    orderId: json['orderId'],
    scheduledDateTime: DateTime.parse(json['scheduledDateTime']),
    status: ScheduleStatus.values.firstWhere((e) => e.name == json['status']),
    specialInstructions: json['specialInstructions'],
    createdAt: DateTime.parse(json['createdAt']),
    activatedAt: json['activatedAt'] != null ? DateTime.parse(json['activatedAt']) : null,
    completedAt: json['completedAt'] != null ? DateTime.parse(json['completedAt']) : null,
    customerNotificationPhone: json['customerNotificationPhone'],
    notificationSent: json['notificationSent'] ?? false,
  );
}

// Enhanced Payment Tracking Models
class PartialPayment {
  final String id;
  final double amount;
  final PaymentMethodType method;
  final String methodName;
  final DateTime paidAt;
  final String? transactionId;
  final String? notes;

  const PartialPayment({
    required this.id,
    required this.amount,
    required this.method,
    required this.methodName,
    required this.paidAt,
    this.transactionId,
    this.notes,
  });

  PartialPayment copyWith({
    String? id,
    double? amount,
    PaymentMethodType? method,
    String? methodName,
    DateTime? paidAt,
    String? transactionId,
    String? notes,
  }) {
    return PartialPayment(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      method: method ?? this.method,
      methodName: methodName ?? this.methodName,
      paidAt: paidAt ?? this.paidAt,
      transactionId: transactionId ?? this.transactionId,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'amount': amount,
    'method': method.name,
    'methodName': methodName,
    'paidAt': paidAt.toIso8601String(),
    'transactionId': transactionId,
    'notes': notes,
  };

  factory PartialPayment.fromJson(Map<String, dynamic> json) => PartialPayment(
    id: json['id'],
    amount: json['amount'].toDouble(),
    method: PaymentMethodType.values.firstWhere((e) => e.name == json['method']),
    methodName: json['methodName'],
    paidAt: DateTime.parse(json['paidAt']),
    transactionId: json['transactionId'],
    notes: json['notes'],
  );
}

class PaymentPlan {
  final String orderId;
  final double totalAmount;
  final double paidAmount;
  final List<PartialPayment> payments;
  final PaymentStatus status;
  final DateTime createdAt;
  final DateTime? dueAt;
  final bool allowPartialPayment;

  const PaymentPlan({
    required this.orderId,
    required this.totalAmount,
    this.paidAmount = 0.0,
    this.payments = const [],
    this.status = PaymentStatus.pending,
    required this.createdAt,
    this.dueAt,
    this.allowPartialPayment = true,
  });

  PaymentPlan copyWith({
    String? orderId,
    double? totalAmount,
    double? paidAmount,
    List<PartialPayment>? payments,
    PaymentStatus? status,
    DateTime? createdAt,
    DateTime? dueAt,
    bool? allowPartialPayment,
  }) {
    return PaymentPlan(
      orderId: orderId ?? this.orderId,
      totalAmount: totalAmount ?? this.totalAmount,
      paidAmount: paidAmount ?? this.paidAmount,
      payments: payments ?? this.payments,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      dueAt: dueAt ?? this.dueAt,
      allowPartialPayment: allowPartialPayment ?? this.allowPartialPayment,
    );
  }

  // Calculated properties
  double get remainingAmount => totalAmount - paidAmount;
  double get actualPaidAmount => payments.fold(0.0, (sum, payment) => sum + payment.amount);
  bool get isFullyPaid => actualPaidAmount >= totalAmount;
  bool get isOverdue => dueAt != null && DateTime.now().isAfter(dueAt!) && !isFullyPaid;
  double get paymentProgress => totalAmount > 0 ? actualPaidAmount / totalAmount : 0.0;

  // Add payment
  PaymentPlan addPayment(PartialPayment payment) {
    final updatedPayments = [...payments, payment];
    final updatedPaidAmount = updatedPayments.fold(0.0, (sum, p) => sum + p.amount);
    final updatedStatus = updatedPaidAmount >= totalAmount ? PaymentStatus.completed : PaymentStatus.partial;

    return copyWith(
      payments: updatedPayments,
      paidAmount: updatedPaidAmount,
      status: updatedStatus,
    );
  }

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'totalAmount': totalAmount,
    'paidAmount': paidAmount,
    'payments': payments.map((p) => p.toJson()).toList(),
    'status': status.name,
    'createdAt': createdAt.toIso8601String(),
    'dueAt': dueAt?.toIso8601String(),
    'allowPartialPayment': allowPartialPayment,
  };

  factory PaymentPlan.fromJson(Map<String, dynamic> json) => PaymentPlan(
    orderId: json['orderId'],
    totalAmount: json['totalAmount'].toDouble(),
    paidAmount: json['paidAmount']?.toDouble() ?? 0.0,
    payments: (json['payments'] as List?)?.map((p) => PartialPayment.fromJson(p)).toList() ?? [],
    status: PaymentStatus.values.firstWhere((e) => e.name == json['status']),
    createdAt: DateTime.parse(json['createdAt']),
    dueAt: json['dueAt'] != null ? DateTime.parse(json['dueAt']) : null,
    allowPartialPayment: json['allowPartialPayment'] ?? true,
  );
}

// Addon Model
class Addon {
  final String id;
  final String name;
  final double price;
  final bool isRequired;
  
  Addon({
    required this.id,
    required this.name,
    required this.price,
    this.isRequired = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'isRequired': isRequired,
  };

  factory Addon.fromJson(Map<String, dynamic> json) => Addon(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    isRequired: json['isRequired'] ?? false,
  );
}

// Menu Item Model
class MenuItem {
  final String id;
  final String name;
  final double dineInPrice;
  final double takeawayPrice;
  final String category;
  final bool isAvailable;
  final List<Addon>? addons;
  final bool allowCustomization;
  final double? deliveryPrice;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.dineInPrice,
    double? takeawayPrice,
    required this.category,
    this.isAvailable = true,
    this.addons,
    this.allowCustomization = false,
    this.deliveryPrice,
    this.description,
  }) : takeawayPrice = takeawayPrice ?? dineInPrice;

  // Get price based on order type
  double getPriceForOrderType(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        return dineInPrice;
      case OrderType.takeaway:
        return takeawayPrice;
      case OrderType.delivery:
        return deliveryPrice ?? takeawayPrice;
    }
  }

  MenuItem copyWith({
    String? id,
    String? name,
    double? dineInPrice,
    double? takeawayPrice,
    String? category,
    bool? isAvailable,
    List<Addon>? addons,
    bool? allowCustomization,
    double? deliveryPrice,
    String? description,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      dineInPrice: dineInPrice ?? this.dineInPrice,
      takeawayPrice: takeawayPrice ?? this.takeawayPrice,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      addons: addons ?? this.addons,
      allowCustomization: allowCustomization ?? this.allowCustomization,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      description: description ?? this.description,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dineInPrice': dineInPrice,
    'takeawayPrice': takeawayPrice,
    'category': category,
    'isAvailable': isAvailable,
    'allowCustomization': allowCustomization,
    'deliveryPrice': deliveryPrice,
    'description': description,
    'addons': addons?.map((a) => a.toJson()).toList(),
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    dineInPrice: json['dineInPrice']?.toDouble() ?? json['price']?.toDouble() ?? 0.0,
    takeawayPrice: json['takeawayPrice']?.toDouble() ?? json['price']?.toDouble() ?? 0.0,
    category: json['category'],
    isAvailable: json['isAvailable'] ?? true,
    allowCustomization: json['allowCustomization'] ?? false,
    deliveryPrice: json['deliveryPrice']?.toDouble(),
    description: json['description'],
    addons: (json['addons'] as List?)?.map((a) => Addon.fromJson(a)).toList(),
  );
}

// Discount Models
class ItemDiscount {
  final DiscountType type;
  final double value;
  final String? reason;
  
  ItemDiscount({
    required this.type,
    required this.value,
    this.reason,
  });
  
  double calculateDiscount(double amount) {
    switch (type) {
      case DiscountType.percentage:
        return amount * (value / 100);
      case DiscountType.fixed:
        return value > amount ? amount : value;
    }
  }
  
  ItemDiscount copyWith({
    DiscountType? type,
    double? value,
    String? reason,
  }) {
    return ItemDiscount(
      type: type ?? this.type,
      value: value ?? this.value,
      reason: reason ?? this.reason,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'value': value,
    'reason': reason,
  };

  factory ItemDiscount.fromJson(Map<String, dynamic> json) => ItemDiscount(
    type: DiscountType.values.firstWhere((e) => e.name == json['type']),
    value: json['value'].toDouble(),
    reason: json['reason'],
  );
}

class OrderDiscount {
  final DiscountType type;
  final double value;
  final String? reason;
  final bool applyToSubtotal; // Apply to subtotal or grand total
  
  OrderDiscount({
    required this.type,
    required this.value,
    this.reason,
    this.applyToSubtotal = true,
  });
  
  double calculateDiscount(double amount) {
    switch (type) {
      case DiscountType.percentage:
        return amount * (value / 100);
      case DiscountType.fixed:
        return value > amount ? amount : value;
    }
  }
  
  OrderDiscount copyWith({
    DiscountType? type,
    double? value,
    String? reason,
    bool? applyToSubtotal,
  }) {
    return OrderDiscount(
      type: type ?? this.type,
      value: value ?? this.value,
      reason: reason ?? this.reason,
      applyToSubtotal: applyToSubtotal ?? this.applyToSubtotal,
    );
  }

  Map<String, dynamic> toJson() => {
    'type': type.name,
    'value': value,
    'reason': reason,
    'applyToSubtotal': applyToSubtotal,
  };

  factory OrderDiscount.fromJson(Map<String, dynamic> json) => OrderDiscount(
    type: DiscountType.values.firstWhere((e) => e.name == json['type']),
    value: json['value'].toDouble(),
    reason: json['reason'],
    applyToSubtotal: json['applyToSubtotal'] ?? true,
  );
}

// Order Item Model
class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final OrderType orderType;
  final List<Addon> selectedAddons;
  final String? specialInstructions;
  final ItemDiscount? discount;
  
  OrderItem({
    required this.menuItem, 
    required this.quantity,
    required this.orderType,
    this.selectedAddons = const [],
    this.specialInstructions,
    this.discount,
  });
  
  double get basePrice => menuItem.getPriceForOrderType(orderType);
  double get addonsPrice => selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
  double get unitPrice => basePrice + addonsPrice;
  double get subtotal => unitPrice * quantity;
  
  // Discount calculations
  double get discountAmount => discount?.calculateDiscount(subtotal) ?? 0.0;
  double get total => subtotal - discountAmount;
  
  // Check if item has discount
  bool get hasDiscount => discount != null && discountAmount > 0;
  
  OrderItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    OrderType? orderType,
    List<Addon>? selectedAddons,
    String? specialInstructions,
    ItemDiscount? discount,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      orderType: orderType ?? this.orderType,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      discount: discount ?? this.discount,
    );
  }
  
  // Remove discount
  OrderItem removeDiscount() {
    return copyWith(discount: null);
  }

  Map<String, dynamic> toJson() => {
    'menuItem': menuItem.toJson(),
    'quantity': quantity,
    'orderType': orderType.name,
    'selectedAddons': selectedAddons.map((a) => a.toJson()).toList(),
    'specialInstructions': specialInstructions,
    'discount': discount?.toJson(),
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    menuItem: MenuItem.fromJson(json['menuItem']),
    quantity: json['quantity'],
    orderType: OrderType.values.firstWhere((e) => e.name == json['orderType']),
    selectedAddons: (json['selectedAddons'] as List?)?.map((a) => Addon.fromJson(a)).toList() ?? [],
    specialInstructions: json['specialInstructions'],
    discount: json['discount'] != null ? ItemDiscount.fromJson(json['discount']) : null,
  );
}

// Customer Info Model
class CustomerInfo {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  
  CustomerInfo({
    this.name,
    this.phone,
    this.email,
    this.address,
  });

  CustomerInfo copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
  }) {
    return CustomerInfo(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'address': address,
  };

  factory CustomerInfo.fromJson(Map<String, dynamic> json) => CustomerInfo(
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
  );
}

// Order Charges Model
class OrderCharges {
  final double deliveryCharge;
  final double packagingCharge;
  final double serviceCharge;
  
  OrderCharges({
    this.deliveryCharge = 0.0,
    this.packagingCharge = 0.0,
    this.serviceCharge = 0.0,
  });

  double get total => deliveryCharge + packagingCharge + serviceCharge;

  OrderCharges copyWith({
    double? deliveryCharge,
    double? packagingCharge,
    double? serviceCharge,
  }) {
    return OrderCharges(
      deliveryCharge: deliveryCharge ?? this.deliveryCharge,
      packagingCharge: packagingCharge ?? this.packagingCharge,
      serviceCharge: serviceCharge ?? this.serviceCharge,
    );
  }

  Map<String, dynamic> toJson() => {
    'deliveryCharge': deliveryCharge,
    'packagingCharge': packagingCharge,
    'serviceCharge': serviceCharge,
  };

  factory OrderCharges.fromJson(Map<String, dynamic> json) => OrderCharges(
    deliveryCharge: json['deliveryCharge']?.toDouble() ?? 0.0,
    packagingCharge: json['packagingCharge']?.toDouble() ?? 0.0,
    serviceCharge: json['serviceCharge']?.toDouble() ?? 0.0,
  );
}

// Payment Entry Model
class PaymentEntry {
  final String methodId;
  final String methodName;
  final PaymentMethodType method;
  final double amount;
  final DateTime timestamp;
  final String? orderId;
  final String? transactionId;

  PaymentEntry({
    required this.methodId,
    required this.methodName,
    required this.method,
    required this.amount,
    required this.timestamp,
    this.orderId,
    this.transactionId,
  });

  PaymentEntry copyWith({
    String? methodId,
    String? methodName,
    PaymentMethodType? method,
    double? amount,
    DateTime? timestamp,
    String? orderId,
    String? transactionId,
  }) {
    return PaymentEntry(
      methodId: methodId ?? this.methodId,
      methodName: methodName ?? this.methodName,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  factory PaymentEntry.fromJson(Map<String, dynamic> json) => PaymentEntry(
    methodId: json['methodId'],
    methodName: json['methodName'],
    method: PaymentMethodType.values.firstWhere((e) => e.name == json['method']),
    amount: json['amount'].toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
    orderId: json['orderId'],
    transactionId: json['transactionId'],
  );

  Map<String, dynamic> toJson() => {
    'methodId': methodId,
    'methodName': methodName,
    'method': method.name,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'orderId': orderId,
    'transactionId': transactionId,
  };
}

// Order Payment Model
class OrderPayment {
  final String orderId;
  final List<PaymentEntry> payments;
  final double totalAmount;
  final DateTime paidAt;
  final bool isFullyPaid;

  OrderPayment({
    required this.orderId,
    required this.payments,
    required this.totalAmount,
    required this.paidAt,
  }) : isFullyPaid = payments.fold(0.0, (sum, p) => sum + p.amount) >= totalAmount;

  double get paidAmount => payments.fold(0.0, (sum, p) => sum + p.amount);
  double get remainingAmount => totalAmount - paidAmount;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
    orderId: json['orderId'],
    payments: (json['payments'] as List).map((p) => PaymentEntry.fromJson(p)).toList(),
    totalAmount: json['totalAmount'].toDouble(),
    paidAt: DateTime.parse(json['paidAt']),
  );

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'payments': payments.map((p) => p.toJson()).toList(),
    'totalAmount': totalAmount,
    'paidAt': paidAt.toIso8601String(),
  };
}

// Payment Method Config Model
class PaymentMethodConfig {
  final String id;
  final String name;
  final PaymentMethodType type;
  final String? icon;
  final bool isEnabled;
  final Map<String, dynamic>? config;

  const PaymentMethodConfig({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.isEnabled = true,
    this.config,
  });

  PaymentMethodConfig copyWith({
    String? id,
    String? name,
    PaymentMethodType? type,
    String? icon,
    bool? isEnabled,
    Map<String, dynamic>? config,
  }) {
    return PaymentMethodConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
      config: config ?? this.config,
    );
  }

  factory PaymentMethodConfig.fromJson(Map<String, dynamic> json) {
    return PaymentMethodConfig(
      id: json['id'],
      name: json['name'],
      type: PaymentMethodType.values.firstWhere((e) => e.name == json['type']),
      icon: json['icon'],
      isEnabled: json['isEnabled'] ?? true,
      config: json['config'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'icon': icon,
    'isEnabled': isEnabled,
    'config': config,
  };

  static List<PaymentMethodConfig> get defaultMethods => [
    PaymentMethodConfig(id: 'cash', name: 'Cash', type: PaymentMethodType.cash, icon: '💵'),
    PaymentMethodConfig(id: 'card', name: 'Card', type: PaymentMethodType.card, icon: '💳'),
    PaymentMethodConfig(id: 'upi', name: 'UPI', type: PaymentMethodType.upi, icon: '📱'),
    PaymentMethodConfig(id: 'gpay', name: 'Google Pay', type: PaymentMethodType.upi, icon: '📱'),
    PaymentMethodConfig(id: 'paytm', name: 'Paytm', type: PaymentMethodType.wallet, icon: '💰'),
    PaymentMethodConfig(id: 'phonepe', name: 'PhonePe', type: PaymentMethodType.upi, icon: '📲'),
    PaymentMethodConfig(id: 'netbanking', name: 'Net Banking', type: PaymentMethodType.netBanking, icon: '🏦'),
  ];
}

// Printer Device Model
class PrinterDevice {
  final String id;
  final String name;
  final String address; // IP address for network, device path for USB, MAC for Bluetooth
  final int? port; // Port number for network printers
  final PrinterConnectionType connectionType;
  final PrinterStatus status;
  final bool isDefault;
  final DateTime lastConnected;
  final Map<String, dynamic> settings; // Paper size, print quality, etc.

  const PrinterDevice({
    required this.id,
    required this.name,
    required this.address,
    this.port,
    required this.connectionType,
    this.status = PrinterStatus.disconnected,
    this.isDefault = false,
    required this.lastConnected,
    this.settings = const {},
  });

  PrinterDevice copyWith({
    String? id,
    String? name,
    String? address,
    int? port,
    PrinterConnectionType? connectionType,
    PrinterStatus? status,
    bool? isDefault,
    DateTime? lastConnected,
    Map<String, dynamic>? settings,
  }) {
    return PrinterDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      connectionType: connectionType ?? this.connectionType,
      status: status ?? this.status,
      isDefault: isDefault ?? this.isDefault,
      lastConnected: lastConnected ?? this.lastConnected,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'connectionType': connectionType.index,
      'status': status.index,
      'isDefault': isDefault,
      'lastConnected': lastConnected.millisecondsSinceEpoch,
      'settings': settings,
    };
  }

  factory PrinterDevice.fromJson(Map<String, dynamic> json) {
    return PrinterDevice(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      port: json['port'],
      connectionType: PrinterConnectionType.values[json['connectionType']],
      status: PrinterStatus.values[json['status'] ?? 0],
      isDefault: json['isDefault'] ?? false,
      lastConnected: DateTime.fromMillisecondsSinceEpoch(json['lastConnected']),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }
}

// Payment Legacy Model (for backward compatibility)
class Payment {
  final PaymentMethod method;
  final double amount;
  final DateTime timestamp;
  final String? transactionId;

  Payment({
    required this.method,
    required this.amount,
    required this.timestamp,
    this.transactionId,
  });

  Map<String, dynamic> toJson() => {
    'method': method.name,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'transactionId': transactionId,
  };

  factory Payment.fromJson(Map<String, dynamic> json) => Payment(
    method: PaymentMethod.values.firstWhere((e) => e.name == json['method']),
    amount: json['amount'].toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
    transactionId: json['transactionId'],
  );
}

// App Settings Model
class AppSettings {
  final String currency;
  final double sgstRate;
  final double cgstRate;
  final String businessName;
  final String address;
  final String phone;
  final String email;
  final bool kotEnabled;
  final String defaultLanguage;
  final bool deliveryEnabled;
  final bool packagingEnabled;
  final bool serviceEnabled;
  final double defaultDeliveryCharge;
  final double defaultPackagingCharge;
  final double defaultServiceCharge;
  
  AppSettings({
    this.currency = '₹',
    this.sgstRate = 0.09,
    this.cgstRate = 0.09,
    this.businessName = 'My Restaurant',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.kotEnabled = false,
    this.defaultLanguage = 'en',
    this.deliveryEnabled = true,
    this.packagingEnabled = true,
    this.serviceEnabled = true,
    this.defaultDeliveryCharge = 50.0,
    this.defaultPackagingCharge = 10.0,
    this.defaultServiceCharge = 20.0,
  });
  
  AppSettings copyWith({
    String? currency,
    double? sgstRate,
    double? cgstRate,
    String? businessName,
    String? address,
    String? phone,
    String? email,
    bool? kotEnabled,
    String? defaultLanguage,
    bool? deliveryEnabled,
    bool? packagingEnabled,
    bool? serviceEnabled,
    double? defaultDeliveryCharge,
    double? defaultPackagingCharge,
    double? defaultServiceCharge,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      sgstRate: sgstRate ?? this.sgstRate,
      cgstRate: cgstRate ?? this.cgstRate,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      kotEnabled: kotEnabled ?? this.kotEnabled,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      deliveryEnabled: deliveryEnabled ?? this.deliveryEnabled,
      packagingEnabled: packagingEnabled ?? this.packagingEnabled,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      defaultDeliveryCharge: defaultDeliveryCharge ?? this.defaultDeliveryCharge,
      defaultPackagingCharge: defaultPackagingCharge ?? this.defaultPackagingCharge,
      defaultServiceCharge: defaultServiceCharge ?? this.defaultServiceCharge,
    );
  }
  
  // Helper method to get total tax rate (SGST + CGST)
  double get totalTaxRate => sgstRate + cgstRate;

  Map<String, dynamic> toJson() => {
    'currency': currency,
    'sgstRate': sgstRate,
    'cgstRate': cgstRate,
    'businessName': businessName,
    'address': address,
    'phone': phone,
    'email': email,
    'kotEnabled': kotEnabled,
    'defaultLanguage': defaultLanguage,
    'deliveryEnabled': deliveryEnabled,
    'packagingEnabled': packagingEnabled,
    'serviceEnabled': serviceEnabled,
    'defaultDeliveryCharge': defaultDeliveryCharge,
    'defaultPackagingCharge': defaultPackagingCharge,
    'defaultServiceCharge': defaultServiceCharge,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    currency: json['currency'] ?? '₹',
    sgstRate: json['sgstRate']?.toDouble() ?? 0.09,
    cgstRate: json['cgstRate']?.toDouble() ?? 0.09,
    businessName: json['businessName'] ?? 'My Restaurant',
    address: json['address'] ?? '',
    phone: json['phone'] ?? '',
    email: json['email'] ?? '',
    kotEnabled: json['kotEnabled'] ?? false,
    defaultLanguage: json['defaultLanguage'] ?? 'en',
    deliveryEnabled: json['deliveryEnabled'] ?? true,
    packagingEnabled: json['packagingEnabled'] ?? true,
    serviceEnabled: json['serviceEnabled'] ?? true,
    defaultDeliveryCharge: json['defaultDeliveryCharge']?.toDouble() ?? 50.0,
    defaultPackagingCharge: json['defaultPackagingCharge']?.toDouble() ?? 10.0,
    defaultServiceCharge: json['defaultServiceCharge']?.toDouble() ?? 20.0,
  );
}

// Enhanced Order Model with Scheduling and Payment Plans
class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime createdAt;
  final OrderType type;
  final OrderStatus status;
  final String? notes;
  final CustomerInfo? customer;
  final OrderCharges charges;
  final List<Payment> payments;
  final PaymentStatus paymentStatus;
  final bool kotPrinted;
  final OrderDiscount? orderDiscount;
  
  // Enhanced scheduling features
  final OrderProcessingType processingType;
  final ScheduledOrder? scheduledOrderInfo;
  final PaymentPlan? paymentPlan;
  
  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.type,
    this.status = OrderStatus.pending,
    this.notes,
    this.customer,
    OrderCharges? charges,
    this.payments = const [],
    this.paymentStatus = PaymentStatus.pending,
    this.kotPrinted = false,
    this.orderDiscount,
    this.processingType = OrderProcessingType.immediate,
    this.scheduledOrderInfo,
    this.paymentPlan,
  }) : charges = charges ?? OrderCharges();
  
  // Item-level totals
  double get itemsSubtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get itemsDiscountAmount => items.fold(0.0, (sum, item) => sum + item.discountAmount);
  double get itemsTotal => items.fold(0.0, (sum, item) => sum + item.total);
  
  // Order-level calculations
  double get subtotal => itemsTotal; // After item discounts
  double get totalCharges => charges.total;
  double get taxableAmount => subtotal + totalCharges;
  
  // Order discount calculations
  double get orderDiscountAmount {
    if (orderDiscount == null) return 0.0;
    
    if (orderDiscount!.applyToSubtotal) {
      return orderDiscount!.calculateDiscount(subtotal);
    } else {
      // Apply to taxable amount (subtotal + charges)
      return orderDiscount!.calculateDiscount(taxableAmount);
    }
  }
  
  double get discountedAmount => orderDiscount?.applyToSubtotal == true
      ? subtotal - orderDiscountAmount
      : taxableAmount - orderDiscountAmount;
      
  double getTaxAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      // Tax on discounted subtotal + charges
      return (discountedAmount + totalCharges) * settings.totalTaxRate;
    } else {
      // Tax on discounted taxable amount
      return discountedAmount * settings.totalTaxRate;
    }
  }
  
  double getSgstAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      return (discountedAmount + totalCharges) * settings.sgstRate;
    } else {
      return discountedAmount * settings.sgstRate;
    }
  }
  
  double getCgstAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      return (discountedAmount + totalCharges) * settings.cgstRate;
    } else {
      return discountedAmount * settings.cgstRate;
    }
  }
  
  double getGrandTotal(AppSettings settings) {
    final taxAmount = getTaxAmount(settings);
    if (orderDiscount?.applyToSubtotal == true) {
      return discountedAmount + totalCharges + taxAmount;
    } else {
      return discountedAmount + taxAmount;
    }
  }
  
  // Method aliases for consistency
  double calculateSGST(AppSettings settings) => getSgstAmount(settings);
  double calculateCGST(AppSettings settings) => getCgstAmount(settings);
  double calculateTotalTax(AppSettings settings) => getTaxAmount(settings);
  
  // Backwards compatibility getter for grandTotal (using default tax rates)
  double get grandTotal => getGrandTotal(AppSettings(
    sgstRate: 0.09, // 9% SGST
    cgstRate: 0.09, // 9% CGST
  ));
  
  // Backwards compatibility getter for taxAmount
  double get taxAmount => getTaxAmount(AppSettings(
    sgstRate: 0.09, // 9% SGST
    cgstRate: 0.09, // 9% CGST
  ));
  
  // Total discount amount (items + order)
  double get totalDiscountAmount => itemsDiscountAmount + orderDiscountAmount;
  
  // Check if order has any discounts
  bool get hasDiscounts => totalDiscountAmount > 0;
  bool get hasOrderDiscount => orderDiscount != null && orderDiscountAmount > 0;
  bool get hasItemDiscounts => itemsDiscountAmount > 0;
  
  double get paidAmount => payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get balanceAmount => grandTotal - paidAmount; // Backwards compatibility - uses default tax rates
  double getBalanceAmount(AppSettings settings) => getGrandTotal(settings) - paidAmount;
  
  // Enhanced scheduling and payment methods
  bool get isScheduled => processingType == OrderProcessingType.scheduled;
  bool get hasPaymentPlan => paymentPlan != null;
  bool get allowsPartialPayment => paymentPlan?.allowPartialPayment ?? false;
  double get totalPaidAmount => paymentPlan?.actualPaidAmount ?? paidAmount;
  double get remainingPaymentAmount => paymentPlan?.remainingAmount ?? balanceAmount;
  bool get isPaymentComplete => paymentPlan?.isFullyPaid ?? (paidAmount >= grandTotal);
  
  // Scheduled order convenience methods
  DateTime? get scheduledDateTime => scheduledOrderInfo?.scheduledDateTime;
  ScheduleStatus? get scheduleStatus => scheduledOrderInfo?.status;
  bool get shouldActivateSchedule => scheduledOrderInfo?.shouldActivate ?? false;
  bool get isScheduleOverdue => scheduledOrderInfo?.isOverdue ?? false;
  
  // Payment plan convenience methods
  double get paymentProgress => paymentPlan?.paymentProgress ?? (paidAmount / grandTotal);
  bool get isPaymentOverdue => paymentPlan?.isOverdue ?? false;
  List<PartialPayment> get partialPayments => paymentPlan?.payments ?? [];
  
  // Create scheduled order
  Order scheduleOrder(DateTime scheduledDateTime, {String? specialInstructions, String? customerPhone}) {
    final scheduledInfo = ScheduledOrder(
      orderId: id,
      scheduledDateTime: scheduledDateTime,
      status: ScheduleStatus.pending,
      specialInstructions: specialInstructions,
      createdAt: DateTime.now(),
      customerNotificationPhone: customerPhone,
    );
    
    return copyWith(
      processingType: OrderProcessingType.scheduled,
      scheduledOrderInfo: scheduledInfo,
      status: OrderStatus.scheduled,
    );
  }
  
  // Setup payment plan
  Order setupPaymentPlan({
    bool allowPartialPayment = true,
    DateTime? dueAt,
    double? initialPayment,
  }) {
    final totalAmount = getGrandTotal(AppSettings(sgstRate: 0.09, cgstRate: 0.09)); // Use default for backwards compatibility
    
    final plan = PaymentPlan(
      orderId: id,
      totalAmount: totalAmount,
      createdAt: DateTime.now(),
      dueAt: dueAt,
      allowPartialPayment: allowPartialPayment,
    );
    
    // Add initial payment if provided
    final updatedPlan = initialPayment != null && initialPayment > 0
        ? plan.addPayment(PartialPayment(
            id: DateTime.now().millisecondsSinceEpoch.toString(),
            amount: initialPayment,
            method: PaymentMethodType.cash, // Default, should be specified
            methodName: 'Initial Payment',
            paidAt: DateTime.now(),
          ))
        : plan;
    
    return copyWith(
      paymentPlan: updatedPlan,
      paymentStatus: updatedPlan.status,
    );
  }
  
  // Add partial payment
  Order addPartialPayment(PartialPayment payment) {
    if (paymentPlan == null) {
      // Create payment plan if it doesn't exist
      final order = setupPaymentPlan();
      return order.addPartialPayment(payment);
    }
    
    final updatedPlan = paymentPlan!.addPayment(payment);
    return copyWith(
      paymentPlan: updatedPlan,
      paymentStatus: updatedPlan.status,
    );
  }
  
  // Activate scheduled order
  Order activateScheduledOrder() {
    if (!isScheduled || scheduledOrderInfo == null) return this;
    
    final updatedScheduleInfo = scheduledOrderInfo!.copyWith(
      status: ScheduleStatus.active,
      activatedAt: DateTime.now(),
    );
    
    return copyWith(
      scheduledOrderInfo: updatedScheduleInfo,
      status: OrderStatus.confirmed,
    );
  }
  
  Order copyWith({
    String? id,
    List<OrderItem>? items,
    DateTime? createdAt,
    OrderType? type,
    OrderStatus? status,
    String? notes,
    CustomerInfo? customer,
    OrderCharges? charges,
    List<Payment>? payments,
    PaymentStatus? paymentStatus,
    bool? kotPrinted,
    OrderDiscount? orderDiscount,
    OrderProcessingType? processingType,
    ScheduledOrder? scheduledOrderInfo,
    PaymentPlan? paymentPlan,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      customer: customer ?? this.customer,
      charges: charges ?? this.charges,
      payments: payments ?? this.payments,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      kotPrinted: kotPrinted ?? this.kotPrinted,
      orderDiscount: orderDiscount ?? this.orderDiscount,
      processingType: processingType ?? this.processingType,
      scheduledOrderInfo: scheduledOrderInfo ?? this.scheduledOrderInfo,
      paymentPlan: paymentPlan ?? this.paymentPlan,
    );
  }
  
  // Remove order discount
  Order removeOrderDiscount() {
    return copyWith(orderDiscount: null);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'items': items.map((i) => i.toJson()).toList(),
    'createdAt': createdAt.toIso8601String(),
    'type': type.name,
    'status': status.name,
    'notes': notes,
    'customer': customer?.toJson(),
    'charges': charges.toJson(),
    'payments': payments.map((p) => p.toJson()).toList(),
    'paymentStatus': paymentStatus.name,
    'kotPrinted': kotPrinted,
    'orderDiscount': orderDiscount?.toJson(),
    'processingType': processingType.name,
    'scheduledOrderInfo': scheduledOrderInfo?.toJson(),
    'paymentPlan': paymentPlan?.toJson(),
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    items: (json['items'] as List).map((i) => OrderItem.fromJson(i)).toList(),
    createdAt: DateTime.parse(json['createdAt']),
    type: OrderType.values.firstWhere((e) => e.name == json['type']),
    status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
    notes: json['notes'],
    customer: json['customer'] != null ? CustomerInfo.fromJson(json['customer']) : null,
    charges: OrderCharges.fromJson(json['charges'] ?? {}),
    payments: (json['payments'] as List?)?.map((p) => Payment.fromJson(p)).toList() ?? [],
    paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == json['paymentStatus']),
    kotPrinted: json['kotPrinted'] ?? false,
    orderDiscount: json['orderDiscount'] != null ? OrderDiscount.fromJson(json['orderDiscount']) : null,
    processingType: json['processingType'] != null 
        ? OrderProcessingType.values.firstWhere((e) => e.name == json['processingType'])
        : OrderProcessingType.immediate,
    scheduledOrderInfo: json['scheduledOrderInfo'] != null 
        ? ScheduledOrder.fromJson(json['scheduledOrderInfo']) 
        : null,
    paymentPlan: json['paymentPlan'] != null 
        ? PaymentPlan.fromJson(json['paymentPlan']) 
        : null,
  );
}

// Customer Analytics Data Model
class CustomerData {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime firstOrderDate;
  final DateTime lastOrderDate;
  final int totalOrders;
  final double totalSpent;
  final OrderType mostUsedOrderType;
  final List<String> orderIds; // Track order history
  
  CustomerData({
    this.name,
    this.phone,
    this.email,
    this.address,
    required this.firstOrderDate,
    required this.lastOrderDate,
    required this.totalOrders,
    required this.totalSpent,
    required this.mostUsedOrderType,
    required this.orderIds,
  });
  
  // Create from first order
  factory CustomerData.fromOrder(Order order) {
    return CustomerData(
      name: order.customer?.name,
      phone: order.customer?.phone,
      email: order.customer?.email,
      address: order.customer?.address,
      firstOrderDate: order.createdAt,
      lastOrderDate: order.createdAt,
      totalOrders: 1,
      totalSpent: order.getGrandTotal(AppSettings(sgstRate: 0.09, cgstRate: 0.09)), // Use default for backwards compatibility
      mostUsedOrderType: order.type,
      orderIds: [order.id],
    );
  }
  
  // Update with new order
  CustomerData updateWithOrder(Order order) {
    final updatedOrderIds = [...orderIds, order.id];
    
    // Calculate most used order type
    final orderTypeCounts = <OrderType, int>{};
    // Count existing orders (simplified - we'll use the current most used + this new one)
    orderTypeCounts[mostUsedOrderType] = totalOrders;
    orderTypeCounts[order.type] = (orderTypeCounts[order.type] ?? 0) + 1;
    
    final newMostUsed = orderTypeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return CustomerData(
      name: order.customer?.name ?? name,
      phone: order.customer?.phone ?? phone,
      email: order.customer?.email ?? email,
      address: order.customer?.address ?? address,
      firstOrderDate: firstOrderDate,
      lastOrderDate: order.createdAt,
      totalOrders: totalOrders + 1,
      totalSpent: totalSpent + order.getGrandTotal(AppSettings(sgstRate: 0.09, cgstRate: 0.09)), // Use default for backwards compatibility
      mostUsedOrderType: newMostUsed,
      orderIds: updatedOrderIds,
    );
  }

  CustomerData copyWith({
    String? name,
    String? phone,
    String? email,
    String? address,
    DateTime? firstOrderDate,
    DateTime? lastOrderDate,
    int? totalOrders,
    double? totalSpent,
    OrderType? mostUsedOrderType,
    List<String>? orderIds,
  }) {
    return CustomerData(
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      address: address ?? this.address,
      firstOrderDate: firstOrderDate ?? this.firstOrderDate,
      lastOrderDate: lastOrderDate ?? this.lastOrderDate,
      totalOrders: totalOrders ?? this.totalOrders,
      totalSpent: totalSpent ?? this.totalSpent,
      mostUsedOrderType: mostUsedOrderType ?? this.mostUsedOrderType,
      orderIds: orderIds ?? this.orderIds,
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'phone': phone,
    'email': email,
    'address': address,
    'firstOrderDate': firstOrderDate.toIso8601String(),
    'lastOrderDate': lastOrderDate.toIso8601String(),
    'totalOrders': totalOrders,
    'totalSpent': totalSpent,
    'mostUsedOrderType': mostUsedOrderType.name,
    'orderIds': orderIds,
  };

  factory CustomerData.fromJson(Map<String, dynamic> json) => CustomerData(
    name: json['name'],
    phone: json['phone'],
    email: json['email'],
    address: json['address'],
    firstOrderDate: DateTime.parse(json['firstOrderDate']),
    lastOrderDate: DateTime.parse(json['lastOrderDate']),
    totalOrders: json['totalOrders'],
    totalSpent: json['totalSpent'].toDouble(),
    mostUsedOrderType: OrderType.values.firstWhere((e) => e.name == json['mostUsedOrderType']),
    orderIds: List<String>.from(json['orderIds'] ?? []),
  );
}
