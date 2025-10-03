// Supabase Models - Unified with Core Models
import 'core_models.dart' as core;

/// User profile for Supabase backend
class UserProfile {
  final String id;
  final String businessName;
  final String? ownerName;
  final String? phone;
  final String? address;
  final double taxRate;
  final String currency;
  final String subscriptionPlan;
  final String subscriptionStatus;
  final DateTime? subscriptionExpiresAt;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserProfile({
    required this.id,
    required this.businessName,
    this.ownerName,
    this.phone,
    this.address,
    this.taxRate = 0.0,
    this.currency = '₹',
    this.subscriptionPlan = 'free',
    this.subscriptionStatus = 'active',
    this.subscriptionExpiresAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id: json['id'],
      businessName: json['business_name'],
      ownerName: json['owner_name'],
      phone: json['phone'],
      address: json['address'],
      taxRate: (json['tax_rate'] ?? 0.0).toDouble(),
      currency: json['currency'] ?? '₹',
      subscriptionPlan: json['subscription_plan'] ?? 'free',
      subscriptionStatus: json['subscription_status'] ?? 'active',
      subscriptionExpiresAt: json['subscription_expires_at'] != null
          ? DateTime.parse(json['subscription_expires_at'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'business_name': businessName,
      'owner_name': ownerName,
      'phone': phone,
      'address': address,
      'tax_rate': taxRate,
      'currency': currency,
      'subscription_plan': subscriptionPlan,
      'subscription_status': subscriptionStatus,
      'subscription_expires_at': subscriptionExpiresAt?.toIso8601String(),
    };
  }
}

/// Extended MenuItem for Supabase that includes additional cloud fields
class SupabaseMenuItem extends core.MenuItem {
  final String? imageUrl;
  final double costPrice;
  final int stockQuantity;
  final String? currency;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupabaseMenuItem({
    required String id,
    required String name,
    required double dineInPrice,
    double? takeawayPrice,
    required String category,
    bool isAvailable = true,
    List<core.Addon>? addons,
    bool allowCustomization = false,
    double? deliveryPrice,
    String? description,
    this.imageUrl,
    this.costPrice = 0.0,
    this.stockQuantity = 0,
    this.currency = '₹',
    required this.createdAt,
    required this.updatedAt,
  }) : super(
          id: id,
          name: name,
          dineInPrice: dineInPrice,
          takeawayPrice: takeawayPrice,
          category: category,
          isAvailable: isAvailable,
          addons: addons,
          allowCustomization: allowCustomization,
          deliveryPrice: deliveryPrice,
          description: description,
        );

  factory SupabaseMenuItem.fromJson(Map<String, dynamic> json) {
    List<core.Addon>? addonsList;
    if (json['menu_item_addons'] != null) {
      addonsList = (json['menu_item_addons'] as List)
          .map((addon) => core.Addon.fromJson(addon))
          .toList();
    }

    return SupabaseMenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      category: json['category'],
      dineInPrice: (json['dine_in_price'] ?? 0.0).toDouble(),
      takeawayPrice: (json['takeaway_price'] ?? json['dine_in_price'] ?? 0.0).toDouble(),
      deliveryPrice: json['delivery_price']?.toDouble(),
      costPrice: (json['cost_price'] ?? 0.0).toDouble(),
      stockQuantity: json['stock_quantity'] ?? 0,
      isAvailable: json['is_available'] ?? true,
      allowCustomization: json['allow_customization'] ?? false,
      imageUrl: json['image_url'],
      currency: json['currency'] ?? '₹',
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final baseJson = super.toJson();
    return {
      ...baseJson,
      'cost_price': costPrice,
      'stock_quantity': stockQuantity,
      'image_url': imageUrl,
      'currency': currency,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  SupabaseMenuItem copyWith({
    String? id,
    String? name,
    String? description,
    String? category,
    double? dineInPrice,
    double? takeawayPrice,
    double? deliveryPrice,
    double? costPrice,
    int? stockQuantity,
    bool? isAvailable,
    bool? allowCustomization,
    String? imageUrl,
    List<core.Addon>? addons,
    String? currency,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return SupabaseMenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      category: category ?? this.category,
      dineInPrice: dineInPrice ?? this.dineInPrice,
      takeawayPrice: takeawayPrice ?? this.takeawayPrice,
      deliveryPrice: deliveryPrice ?? this.deliveryPrice,
      costPrice: costPrice ?? this.costPrice,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      isAvailable: isAvailable ?? this.isAvailable,
      allowCustomization: allowCustomization ?? this.allowCustomization,
      imageUrl: imageUrl ?? this.imageUrl,
      addons: addons ?? this.addons,
      currency: currency ?? this.currency,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}

/// Extended OrderItem for Supabase with additional properties
class SupabaseOrderItem extends core.OrderItem {
  final String supabaseId;
  final double price;
  final double totalPrice;
  final List<core.Addon>? customizations; // Reuse Addon for customizations

  SupabaseOrderItem({
    required this.supabaseId,
    required core.MenuItem menuItem,
    required int quantity,
    required core.OrderType orderType,
    List<core.Addon> selectedAddons = const [],
    String? specialInstructions,
    core.ItemDiscount? discount,
    required this.price,
    required this.totalPrice,
    this.customizations,
  }) : super(
          menuItem: menuItem,
          quantity: quantity,
          orderType: orderType,
          selectedAddons: selectedAddons,
          specialInstructions: specialInstructions,
          discount: discount,
        );

  factory SupabaseOrderItem.fromJson(Map<String, dynamic> json) {
    List<core.Addon>? addons;
    if (json['order_item_addons'] != null) {
      addons = (json['order_item_addons'] as List)
          .map((addon) => core.Addon(
                id: addon['id'] ?? '',
                name: addon['addon_name'],
                price: (addon['addon_price'] ?? 0.0).toDouble(),
              ))
          .toList();
    }

    // Create a core MenuItem from the data
    final menuItem = core.MenuItem(
      id: json['menu_item_id'] ?? '',
      name: json['menu_item_name'] ?? '',
      dineInPrice: (json['unit_price'] ?? 0.0).toDouble(),
      category: json['category'] ?? '',
      description: json['description'],
    );

    return SupabaseOrderItem(
      supabaseId: json['id'],
      menuItem: menuItem,
      quantity: json['quantity'],
      orderType: core.OrderType.dineIn, // Default, should be derived from context
      price: (json['unit_price'] ?? 0.0).toDouble(),
      totalPrice: (json['line_total'] ?? 0.0).toDouble(),
      specialInstructions: json['special_instructions'],
      selectedAddons: addons ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': supabaseId,
      'menu_item_id': menuItem.id,
      'menu_item_name': menuItem.name,
      'quantity': quantity,
      'unit_price': price,
      'line_total': totalPrice,
      'special_instructions': specialInstructions,
    };
  }
}

/// Customer model for Supabase
class SupabaseCustomer {
  final String id;
  final String name;
  final String? phone;
  final String? email;
  final String? address;
  final String? notes;
  final int totalOrders;
  final double totalSpent;
  final DateTime? lastOrderDate;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupabaseCustomer({
    required this.id,
    required this.name,
    this.phone,
    this.email,
    this.address,
    this.notes,
    this.totalOrders = 0,
    this.totalSpent = 0.0,
    this.lastOrderDate,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupabaseCustomer.fromJson(Map<String, dynamic> json) {
    return SupabaseCustomer(
      id: json['id'],
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      notes: json['notes'],
      totalOrders: json['total_orders'] ?? 0,
      totalSpent: (json['total_spent'] ?? 0.0).toDouble(),
      lastOrderDate: json['last_order_date'] != null
          ? DateTime.parse(json['last_order_date'])
          : null,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
      'notes': notes,
      'total_orders': totalOrders,
      'total_spent': totalSpent,
      'last_order_date': lastOrderDate?.toIso8601String(),
    };
  }

  // Convert to core CustomerInfo
  core.CustomerInfo toCoreCustomerInfo() {
    return core.CustomerInfo(
      name: name,
      phone: phone,
      email: email,
      address: address,
    );
  }
}

/// Order model for Supabase
class SupabaseOrder {
  final String id;
  final String orderNumber;
  final core.OrderType orderType;
  final core.OrderStatus status;
  final core.PaymentStatus paymentStatus;
  final SupabaseCustomer? customer;
  final String? tableNumber;
  final String? sectionId;
  final int? seatNumber;
  final List<SupabaseOrderItem> items;
  final double subtotal;
  final double taxAmount;
  final double discountAmount;
  final double total;
  final String? paymentMethod;
  final String? notes;
  final bool kotPrinted;
  final DateTime createdAt;
  final DateTime updatedAt;

  SupabaseOrder({
    required this.id,
    required this.orderNumber,
    required this.orderType,
    required this.status,
    required this.paymentStatus,
    this.customer,
    this.tableNumber,
    this.sectionId,
    this.seatNumber,
    required this.items,
    required this.subtotal,
    required this.taxAmount,
    this.discountAmount = 0.0,
    required this.total,
    this.paymentMethod,
    this.notes,
    this.kotPrinted = false,
    required this.createdAt,
    required this.updatedAt,
  });

  factory SupabaseOrder.fromJson(Map<String, dynamic> json) {
    List<SupabaseOrderItem> orderItems = [];
    if (json['order_items'] != null) {
      orderItems = (json['order_items'] as List)
          .map((item) => SupabaseOrderItem.fromJson(item))
          .toList();
    }

    SupabaseCustomer? customer;
    if (json['customers'] != null) {
      customer = SupabaseCustomer.fromJson(json['customers']);
    }

    return SupabaseOrder(
      id: json['id'],
      orderNumber: json['order_number'],
      orderType: _parseOrderType(json['order_type']),
      status: _parseOrderStatus(json['status']),
      paymentStatus: _parsePaymentStatus(json['payment_status'] ?? 'pending'),
      customer: customer,
      tableNumber: json['table_number'],
      sectionId: json['section_id'],
      seatNumber: json['seat_number'],
      items: orderItems,
      subtotal: (json['subtotal'] ?? 0.0).toDouble(),
      taxAmount: (json['tax_amount'] ?? 0.0).toDouble(),
      discountAmount: (json['discount_amount'] ?? 0.0).toDouble(),
      total: (json['total'] ?? 0.0).toDouble(),
      paymentMethod: json['payment_method'],
      notes: json['notes'],
      kotPrinted: json['kot_printed'] ?? false,
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  static core.OrderType _parseOrderType(String? value) {
    switch (value) {
      case 'dine_in':
        return core.OrderType.dineIn;
      case 'takeaway':
        return core.OrderType.takeaway;
      case 'delivery':
        return core.OrderType.delivery;
      default:
        return core.OrderType.dineIn;
    }
  }

  static core.OrderStatus _parseOrderStatus(String? value) {
    switch (value) {
      case 'pending':
        return core.OrderStatus.pending;
      case 'confirmed':
        return core.OrderStatus.confirmed;
      case 'preparing':
        return core.OrderStatus.preparing;
      case 'ready':
        return core.OrderStatus.ready;
      case 'completed':
        return core.OrderStatus.completed;
      case 'cancelled':
        return core.OrderStatus.cancelled;
      default:
        return core.OrderStatus.pending;
    }
  }

  static core.PaymentStatus _parsePaymentStatus(String? value) {
    switch (value) {
      case 'pending':
        return core.PaymentStatus.pending;
      case 'paid':
      case 'completed':
        return core.PaymentStatus.completed;
      case 'partial':
        return core.PaymentStatus.partial;
      case 'refunded':
        return core.PaymentStatus.refunded;
      default:
        return core.PaymentStatus.pending;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'order_number': orderNumber,
      'order_type': orderType.name,
      'status': status.name,
      'payment_status': paymentStatus.name,
      'customer_id': customer?.id,
      'table_number': tableNumber,
      'section_id': sectionId,
      'seat_number': seatNumber,
      'subtotal': subtotal,
      'tax_amount': taxAmount,
      'discount_amount': discountAmount,
      'total': total,
      'payment_method': paymentMethod,
      'notes': notes,
      'kot_printed': kotPrinted,
    };
  }
}
