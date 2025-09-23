import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/firestore_service.dart';
import '../providers/auth_wrapper.dart';
import '../clean_qsr_main.dart' as app_models;

// Firebase-aware menu items provider
final firebaseMenuItemsProvider = StreamProvider.family<List<app_models.MenuItem>, String>((ref, businessId) {
  return FirestoreService.getMenuItemsStream(businessId).map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return app_models.MenuItem(
        id: data['id'] ?? doc.id,
        name: data['name'] ?? '',
        dineInPrice: (data['dineInPrice'] ?? 0).toDouble(),
        takeawayPrice: (data['takeawayPrice'] ?? data['dineInPrice'] ?? 0).toDouble(),
        deliveryPrice: data['deliveryPrice']?.toDouble(),
        category: data['category'] ?? 'Other',
        description: data['description'],
        isAvailable: data['isAvailable'] ?? true,
        allowCustomization: data['allowCustomization'] ?? false,
        addons: data['addons'] != null 
            ? (data['addons'] as List).map((addon) => app_models.Addon(
                id: addon['id'] ?? '',
                name: addon['name'] ?? '',
                price: (addon['price'] ?? 0).toDouble(),
                isRequired: addon['isRequired'] ?? false,
              )).toList()
            : null,
      );
    }).toList();
  });
});

// Firebase-aware orders provider
final firebaseOrdersProvider = StreamProvider.family<List<app_models.Order>, String>((ref, businessId) {
  return FirestoreService.getOrdersStream(businessId).map((snapshot) {
    return snapshot.docs.map((doc) {
      final data = doc.data();
      return app_models.Order(
        id: data['id'] ?? doc.id,
        orderNumber: data['orderNumber'] ?? '',
        customerName: data['customerInfo']?['name'] ?? '',
        customerPhone: data['customerInfo']?['phone'] ?? '',
        customerEmail: data['customerInfo']?['email'] ?? '',
        customerAddress: data['customerInfo']?['address'] ?? '',
        items: (data['items'] as List? ?? []).map((item) => OrderItem(
          menuItem: MenuItem(
            id: item['menuItemId'] ?? '',
            name: item['menuItemName'] ?? '',
            dineInPrice: (item['price'] ?? 0).toDouble(),
            category: '',
          ),
          quantity: item['quantity'] ?? 1,
          price: (item['price'] ?? 0).toDouble(),
          totalPrice: (item['totalPrice'] ?? 0).toDouble(),
          customizations: item['customizations'] != null
              ? (item['customizations'] as List).map((c) => Customization(
                  type: c['type'] ?? '',
                  value: c['value'] ?? '',
                  price: (c['price'] ?? 0).toDouble(),
                )).toList()
              : null,
          selectedAddons: item['selectedAddons'] != null
              ? (item['selectedAddons'] as List).map((addon) => Addon(
                  id: addon['id'] ?? '',
                  name: addon['name'] ?? '',
                  price: (addon['price'] ?? 0).toDouble(),
                )).toList()
              : null,
        )).toList(),
        orderType: _parseOrderType(data['orderType']),
        status: _parseOrderStatus(data['status']),
        tableNumber: data['tableNumber'],
        subtotal: (data['subtotal'] ?? 0).toDouble(),
        taxAmount: (data['taxAmount'] ?? 0).toDouble(),
        deliveryCharge: (data['deliveryCharge'] ?? 0).toDouble(),
        packagingCharge: (data['packagingCharge'] ?? 0).toDouble(),
        serviceCharge: (data['serviceCharge'] ?? 0).toDouble(),
        discountAmount: (data['discountAmount'] ?? 0).toDouble(),
        totalAmount: (data['totalAmount'] ?? 0).toDouble(),
        payments: (data['payments'] as List? ?? []).map((payment) => Payment(
          method: _parsePaymentMethod(payment['method']),
          amount: (payment['amount'] ?? 0).toDouble(),
          timestamp: (payment['timestamp'] as Timestamp?)?.toDate() ?? DateTime.now(),
          transactionId: payment['transactionId'],
        )).toList(),
        notes: data['notes'] ?? '',
        specialInstructions: data['specialInstructions'] ?? '',
        createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        updatedAt: (data['updatedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
      );
    }).toList();
  });
});

// Firebase-aware customers provider
final firebaseCustomersProvider = StreamProvider.family<Map<String, Customer>, String>((ref, businessId) {
  return FirestoreService.getCustomersStream(businessId).map((snapshot) {
    final customers = <String, Customer>{};
    for (var doc in snapshot.docs) {
      final data = doc.data();
      final customer = Customer(
        name: data['name'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        address: data['address'] ?? '',
        totalOrders: data['totalOrders'] ?? 0,
        totalSpent: (data['totalSpent'] ?? 0).toDouble(),
        lastOrderDate: (data['lastOrderDate'] as Timestamp?)?.toDate(),
      );
      customers[data['phone']] = customer;
    }
    return customers;
  });
});

// Helper functions to parse enums
OrderType _parseOrderType(String? type) {
  switch (type) {
    case 'dineIn': return OrderType.dineIn;
    case 'takeaway': return OrderType.takeaway;
    case 'delivery': return OrderType.delivery;
    default: return OrderType.dineIn;
  }
}

OrderStatus _parseOrderStatus(String? status) {
  switch (status) {
    case 'pending': return OrderStatus.pending;
    case 'confirmed': return OrderStatus.confirmed;
    case 'preparing': return OrderStatus.preparing;
    case 'ready': return OrderStatus.ready;
    case 'completed': return OrderStatus.completed;
    case 'cancelled': return OrderStatus.cancelled;
    default: return OrderStatus.pending;
  }
}

PaymentMethod _parsePaymentMethod(String? method) {
  switch (method) {
    case 'cash': return PaymentMethod.cash;
    case 'card': return PaymentMethod.card;
    case 'upi': return PaymentMethod.upi;
    case 'online': return PaymentMethod.online;
    default: return PaymentMethod.cash;
  }
}

// Firebase-aware business settings provider
final firebaseBusinessSettingsProvider = StreamProvider.family<Map<String, dynamic>, String>((ref, businessId) {
  return FirestoreService.getBusinessStream(businessId).map((doc) {
    if (doc.exists) {
      final data = doc.data()!;
      return data['settings'] as Map<String, dynamic>? ?? {};
    }
    return <String, dynamic>{};
  });
});

// Current business ID provider (default for now, can be enhanced for multi-business)
final currentBusinessIdProvider = Provider<String>((ref) {
  return 'default_business';
});

// Combined provider that merges Firebase data with local fallback
class FirebaseDataNotifier extends StateNotifier<AsyncValue<Map<String, dynamic>>> {
  FirebaseDataNotifier(this._ref) : super(const AsyncValue.loading()) {
    _initialize();
  }

  final Ref _ref;

  void _initialize() async {
    try {
      final user = _ref.read(currentUserProvider);
      if (user != null) {
        final businessId = _ref.read(currentBusinessIdProvider);
        
        // Listen to all data streams
        _ref.listen(firebaseMenuItemsProvider(businessId), (previous, next) {
          next.when(
            data: (menuItems) => _updateMenuItems(menuItems),
            loading: () {},
            error: (error, stack) => print('Menu items error: $error'),
          );
        });

        _ref.listen(firebaseOrdersProvider(businessId), (previous, next) {
          next.when(
            data: (orders) => _updateOrders(orders),
            loading: () {},
            error: (error, stack) => print('Orders error: $error'),
          );
        });

        _ref.listen(firebaseCustomersProvider(businessId), (previous, next) {
          next.when(
            data: (customers) => _updateCustomers(customers),
            loading: () {},
            error: (error, stack) => print('Customers error: $error'),
          );
        });

        state = AsyncValue.data({
          'initialized': true,
          'businessId': businessId,
        });
      }
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }

  void _updateMenuItems(List<MenuItem> menuItems) {
    // Update local providers or state as needed
    print('📋 Updated ${menuItems.length} menu items from Firebase');
  }

  void _updateOrders(List<Order> orders) {
    // Update local providers or state as needed
    print('📋 Updated ${orders.length} orders from Firebase');
  }

  void _updateCustomers(Map<String, Customer> customers) {
    // Update local providers or state as needed
    print('👥 Updated ${customers.length} customers from Firebase');
  }
}

final firebaseDataProvider = StateNotifierProvider<FirebaseDataNotifier, AsyncValue<Map<String, dynamic>>>(
  (ref) => FirebaseDataNotifier(ref),
);

// Order management with Firebase
class FirebaseOrderManager {
  static Future<String> createOrder({
    required String businessId,
    required Order order,
  }) async {
    try {
      final orderId = await FirestoreService.createOrder(
        businessId: businessId,
        orderData: {
          'id': order.id,
          'orderNumber': order.orderNumber,
          'customerInfo': {
            'name': order.customerName,
            'phone': order.customerPhone,
            'email': order.customerEmail,
            'address': order.customerAddress,
          },
          'items': order.items.map((item) => {
            'menuItemId': item.menuItem.id,
            'menuItemName': item.menuItem.name,
            'quantity': item.quantity,
            'price': item.price,
            'totalPrice': item.totalPrice,
            'customizations': item.customizations?.map((c) => {
              'type': c.type,
              'value': c.value,
              'price': c.price,
            }).toList(),
            'selectedAddons': item.selectedAddons?.map((addon) => {
              'id': addon.id,
              'name': addon.name,
              'price': addon.price,
            }).toList(),
          }).toList(),
          'orderType': order.orderType.toString().split('.').last,
          'status': order.status.toString().split('.').last,
          'tableNumber': order.tableNumber,
          'subtotal': order.subtotal,
          'taxAmount': order.taxAmount,
          'deliveryCharge': order.deliveryCharge,
          'packagingCharge': order.packagingCharge,
          'serviceCharge': order.serviceCharge,
          'discountAmount': order.discountAmount,
          'totalAmount': order.totalAmount,
          'payments': order.payments.map((payment) => {
            'method': payment.method.toString().split('.').last,
            'amount': payment.amount,
            'timestamp': Timestamp.fromDate(payment.timestamp),
            'transactionId': payment.transactionId,
          }).toList(),
          'notes': order.notes,
          'specialInstructions': order.specialInstructions,
          'createdAt': Timestamp.fromDate(order.createdAt),
          'updatedAt': Timestamp.fromDate(order.updatedAt),
        },
      );

      // Update customer data
      if (order.customerPhone.isNotEmpty) {
        await FirestoreService.updateCustomerStats(
          businessId: businessId,
          phone: order.customerPhone,
          orderAmount: order.totalAmount,
        );
      }

      return orderId;
    } catch (e) {
      print('❌ Error creating order in Firebase: $e');
      rethrow;
    }
  }

  static Future<void> updateOrderStatus({
    required String businessId,
    required String orderId,
    required OrderStatus status,
  }) async {
    await FirestoreService.updateOrderStatus(
      businessId: businessId,
      orderId: orderId,
      status: status.toString().split('.').last,
    );
  }

  static Future<void> addPayment({
    required String businessId,
    required String orderId,
    required Payment payment,
  }) async {
    await FirestoreService.addPaymentToOrder(
      businessId: businessId,
      orderId: orderId,
      payment: {
        'method': payment.method.toString().split('.').last,
        'amount': payment.amount,
        'timestamp': Timestamp.fromDate(payment.timestamp),
        'transactionId': payment.transactionId,
      },
    );
  }
}

// Menu management with Firebase
class FirebaseMenuManager {
  static Future<String> addMenuItem({
    required String businessId,
    required MenuItem item,
  }) async {
    return await FirestoreService.addMenuItem(
      businessId: businessId,
      item: {
        'id': item.id,
        'name': item.name,
        'dineInPrice': item.dineInPrice,
        'takeawayPrice': item.takeawayPrice,
        'deliveryPrice': item.deliveryPrice,
        'category': item.category,
        'description': item.description,
        'isAvailable': item.isAvailable,
        'allowCustomization': item.allowCustomization,
        'addons': item.addons?.map((addon) => {
          'id': addon.id,
          'name': addon.name,
          'price': addon.price,
          'isRequired': addon.isRequired,
        }).toList(),
        'createdAt': Timestamp.now(),
        'updatedAt': Timestamp.now(),
      },
    );
  }

  static Future<void> updateMenuItem({
    required String businessId,
    required String itemId,
    required Map<String, dynamic> updates,
  }) async {
    updates['updatedAt'] = Timestamp.now();
    await FirestoreService.updateMenuItem(
      businessId: businessId,
      itemId: itemId,
      updates: updates,
    );
  }

  static Future<void> deleteMenuItem({
    required String businessId,
    required String itemId,
  }) async {
    await FirestoreService.deleteMenuItem(
      businessId: businessId,
      itemId: itemId,
    );
  }
}
