import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../clean_qsr_main.dart' as app_models; // Import for data models

class FirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user ID
  static String? get currentUserId => _auth.currentUser?.uid;

  // Collection references
  static CollectionReference get _usersCollection => _firestore.collection('users');
  static CollectionReference get _businessesCollection => _firestore.collection('businesses');
  static CollectionReference get _ordersCollection => _firestore.collection('orders');
  static CollectionReference get _menuItemsCollection => _firestore.collection('menu_items');
  static CollectionReference get _customersCollection => _firestore.collection('customers');

  // User Business reference
  static DocumentReference? get currentUserBusinessRef {
    if (currentUserId == null) return null;
    return _businessesCollection.doc(currentUserId);
  }

  // ==================== USER MANAGEMENT ====================

  // Create user profile
  static Future<void> createUserProfile({
    required String userId,
    required String email,
    required String displayName,
    String? photoURL,
    Map<String, dynamic>? additionalData,
  }) async {
    try {
      await _usersCollection.doc(userId).set({
        'uid': userId,
        'email': email,
        'displayName': displayName,
        'photoURL': photoURL,
        'createdAt': FieldValue.serverTimestamp(),
        'lastLoginAt': FieldValue.serverTimestamp(),
        'isActive': true,
        ...?additionalData,
      });
    } catch (e) {
      throw 'Failed to create user profile: $e';
    }
  }

  // Get user profile
  static Future<Map<String, dynamic>?> getUserProfile(String userId) async {
    try {
      DocumentSnapshot doc = await _usersCollection.doc(userId).get();
      return doc.exists ? doc.data() as Map<String, dynamic>? : null;
    } catch (e) {
      throw 'Failed to get user profile: $e';
    }
  }

  // Update user profile
  static Future<void> updateUserProfile(String userId, Map<String, dynamic> data) async {
    try {
      await _usersCollection.doc(userId).update({
        ...data,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update user profile: $e';
    }
  }

  // Update last login
  static Future<void> updateLastLogin(String userId) async {
    try {
      await _usersCollection.doc(userId).update({
        'lastLoginAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      // Silently fail - not critical
    }
  }

  // ==================== BUSINESS MANAGEMENT ====================

  // Create/Update business settings
  static Future<void> saveBusinessSettings(AppSettings settings) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await currentUserBusinessRef!.set({
        'ownerId': currentUserId,
        'businessName': settings.businessName,
        'address': settings.address,
        'phone': settings.phone,
        'email': settings.email,
        'currency': settings.currency,
        'sgstRate': settings.sgstRate,
        'cgstRate': settings.cgstRate,
        'kotEnabled': settings.kotEnabled,
        'defaultLanguage': settings.defaultLanguage,
        'deliveryEnabled': settings.deliveryEnabled,
        'packagingEnabled': settings.packagingEnabled,
        'serviceEnabled': settings.serviceEnabled,
        'defaultDeliveryCharge': settings.defaultDeliveryCharge,
        'defaultPackagingCharge': settings.defaultPackagingCharge,
        'defaultServiceCharge': settings.defaultServiceCharge,
        'updatedAt': FieldValue.serverTimestamp(),
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to save business settings: $e';
    }
  }

  // Get business settings
  static Future<AppSettings> getBusinessSettings() async {
    if (currentUserId == null) return AppSettings();

    try {
      DocumentSnapshot doc = await currentUserBusinessRef!.get();
      if (!doc.exists) return AppSettings();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AppSettings(
        businessName: data['businessName'] ?? 'My Restaurant',
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        currency: data['currency'] ?? '₹',
        sgstRate: (data['sgstRate'] ?? 0.09).toDouble(),
        cgstRate: (data['cgstRate'] ?? 0.09).toDouble(),
        kotEnabled: data['kotEnabled'] ?? false,
        defaultLanguage: data['defaultLanguage'] ?? 'en',
        deliveryEnabled: data['deliveryEnabled'] ?? true,
        packagingEnabled: data['packagingEnabled'] ?? true,
        serviceEnabled: data['serviceEnabled'] ?? true,
        defaultDeliveryCharge: (data['defaultDeliveryCharge'] ?? 50.0).toDouble(),
        defaultPackagingCharge: (data['defaultPackagingCharge'] ?? 10.0).toDouble(),
        defaultServiceCharge: (data['defaultServiceCharge'] ?? 20.0).toDouble(),
      );
    } catch (e) {
      throw 'Failed to get business settings: $e';
    }
  }

  // Stream business settings
  static Stream<AppSettings> streamBusinessSettings() {
    if (currentUserId == null) return Stream.value(AppSettings());

    return currentUserBusinessRef!.snapshots().map((doc) {
      if (!doc.exists) return AppSettings();

      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      return AppSettings(
        businessName: data['businessName'] ?? 'My Restaurant',
        address: data['address'] ?? '',
        phone: data['phone'] ?? '',
        email: data['email'] ?? '',
        currency: data['currency'] ?? '₹',
        sgstRate: (data['sgstRate'] ?? 0.09).toDouble(),
        cgstRate: (data['cgstRate'] ?? 0.09).toDouble(),
        kotEnabled: data['kotEnabled'] ?? false,
        defaultLanguage: data['defaultLanguage'] ?? 'en',
        deliveryEnabled: data['deliveryEnabled'] ?? true,
        packagingEnabled: data['packagingEnabled'] ?? true,
        serviceEnabled: data['serviceEnabled'] ?? true,
        defaultDeliveryCharge: (data['defaultDeliveryCharge'] ?? 50.0).toDouble(),
        defaultPackagingCharge: (data['defaultPackagingCharge'] ?? 10.0).toDouble(),
        defaultServiceCharge: (data['defaultServiceCharge'] ?? 20.0).toDouble(),
      );
    });
  }

  // ==================== MENU ITEMS MANAGEMENT ====================

  // Save menu items
  static Future<void> saveMenuItems(List<MenuItem> menuItems) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      WriteBatch batch = _firestore.batch();
      
      for (MenuItem item in menuItems) {
        DocumentReference docRef = _menuItemsCollection
            .doc(currentUserId)
            .collection('items')
            .doc(item.id);
        
        batch.set(docRef, {
          ...item.toJson(),
          'businessId': currentUserId,
          'updatedAt': FieldValue.serverTimestamp(),
        });
      }
      
      await batch.commit();
    } catch (e) {
      throw 'Failed to save menu items: $e';
    }
  }

  // Get menu items
  static Future<List<MenuItem>> getMenuItems() async {
    if (currentUserId == null) return [];

    try {
      QuerySnapshot snapshot = await _menuItemsCollection
          .doc(currentUserId)
          .collection('items')
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MenuItem.fromJson(data);
      }).toList();
    } catch (e) {
      throw 'Failed to get menu items: $e';
    }
  }

  // Stream menu items
  static Stream<List<MenuItem>> streamMenuItems() {
    if (currentUserId == null) return Stream.value([]);

    return _menuItemsCollection
        .doc(currentUserId)
        .collection('items')
        .snapshots()
        .map((snapshot) {
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return MenuItem.fromJson(data);
      }).toList();
    });
  }

  // Add single menu item
  static Future<void> addMenuItem(MenuItem item) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _menuItemsCollection
          .doc(currentUserId)
          .collection('items')
          .doc(item.id)
          .set({
        ...item.toJson(),
        'businessId': currentUserId,
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to add menu item: $e';
    }
  }

  // Update menu item
  static Future<void> updateMenuItem(MenuItem item) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _menuItemsCollection
          .doc(currentUserId)
          .collection('items')
          .doc(item.id)
          .update({
        ...item.toJson(),
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update menu item: $e';
    }
  }

  // Delete menu item
  static Future<void> deleteMenuItem(String itemId) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _menuItemsCollection
          .doc(currentUserId)
          .collection('items')
          .doc(itemId)
          .delete();
    } catch (e) {
      throw 'Failed to delete menu item: $e';
    }
  }

  // ==================== ORDERS MANAGEMENT ====================

  // Save order
  static Future<void> saveOrder(app_models.Order order) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _ordersCollection
          .doc(currentUserId)
          .collection('orders')
          .doc(order.id)
          .set({
        'id': order.id,
        'businessId': currentUserId,
        'items': order.items.map((item) => _orderItemToMap(item)).toList(),
        'createdAt': Timestamp.fromDate(order.createdAt),
        'type': order.type.name,
        'status': order.status.name,
        'notes': order.notes,
        'customer': order.customer != null ? _customerInfoToMap(order.customer!) : null,
        'charges': _orderChargesToMap(order.charges),
        'payments': order.payments.map((payment) => _paymentToMap(payment)).toList(),
        'paymentStatus': order.paymentStatus.name,
        'kotPrinted': order.kotPrinted,
        'orderDiscount': order.orderDiscount != null ? _orderDiscountToMap(order.orderDiscount!) : null,
        'grandTotal': order.grandTotal,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to save order: $e';
    }
  }

  // Get orders
  static Future<List<Order>> getOrders({
    int? limit,
    DateTime? startDate,
    DateTime? endDate,
    OrderStatus? status,
  }) async {
    if (currentUserId == null) return [];

    try {
      Query query = _ordersCollection
          .doc(currentUserId)
          .collection('orders')
          .orderBy('createdAt', descending: true);

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }
      if (status != null) {
        query = query.where('status', isEqualTo: status.name);
      }
      if (limit != null) {
        query = query.limit(limit);
      }

      QuerySnapshot snapshot = await query.get();
      return snapshot.docs.map((doc) => _orderFromMap(doc.data() as Map<String, dynamic>)).toList();
    } catch (e) {
      throw 'Failed to get orders: $e';
    }
  }

  // Stream orders
  static Stream<List<Order>> streamOrders({
    int? limit,
    OrderStatus? status,
  }) {
    if (currentUserId == null) return Stream.value([]);

    Query query = _ordersCollection
        .doc(currentUserId)
        .collection('orders')
        .orderBy('createdAt', descending: true);

    if (status != null) {
      query = query.where('status', isEqualTo: status.name);
    }
    if (limit != null) {
      query = query.limit(limit);
    }

    return query.snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => _orderFromMap(doc.data() as Map<String, dynamic>)).toList();
    });
  }

  // Update order status
  static Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _ordersCollection
          .doc(currentUserId)
          .collection('orders')
          .doc(orderId)
          .update({
        'status': status.name,
        'updatedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      throw 'Failed to update order status: $e';
    }
  }

  // ==================== CUSTOMERS MANAGEMENT ====================

  // Save customer data
  static Future<void> saveCustomerData(String phone, CustomerData customerData) async {
    if (currentUserId == null) throw 'User not authenticated';

    try {
      await _customersCollection
          .doc(currentUserId)
          .collection('customers')
          .doc(phone)
          .set({
        'businessId': currentUserId,
        'name': customerData.name,
        'phone': customerData.phone,
        'email': customerData.email,
        'address': customerData.address,
        'firstOrderDate': Timestamp.fromDate(customerData.firstOrderDate),
        'lastOrderDate': Timestamp.fromDate(customerData.lastOrderDate),
        'totalOrders': customerData.totalOrders,
        'totalSpent': customerData.totalSpent,
        'mostUsedOrderType': customerData.mostUsedOrderType.name,
        'orderIds': customerData.orderIds,
        'updatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      throw 'Failed to save customer data: $e';
    }
  }

  // Get customer data
  static Future<Map<String, CustomerData>> getCustomerData() async {
    if (currentUserId == null) return {};

    try {
      QuerySnapshot snapshot = await _customersCollection
          .doc(currentUserId)
          .collection('customers')
          .get();

      Map<String, CustomerData> customerData = {};
      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        customerData[doc.id] = _customerDataFromMap(data);
      }
      return customerData;
    } catch (e) {
      throw 'Failed to get customer data: $e';
    }
  }

  // ==================== ANALYTICS & REPORTS ====================

  // Get sales analytics
  static Future<Map<String, dynamic>> getSalesAnalytics({
    DateTime? startDate,
    DateTime? endDate,
  }) async {
    if (currentUserId == null) return {};

    try {
      Query query = _ordersCollection
          .doc(currentUserId)
          .collection('orders')
          .where('status', whereIn: [OrderStatus.completed.name]);

      if (startDate != null) {
        query = query.where('createdAt', isGreaterThanOrEqualTo: Timestamp.fromDate(startDate));
      }
      if (endDate != null) {
        query = query.where('createdAt', isLessThanOrEqualTo: Timestamp.fromDate(endDate));
      }

      QuerySnapshot snapshot = await query.get();
      
      double totalRevenue = 0;
      int totalOrders = snapshot.docs.length;
      Map<String, int> orderTypeCount = {};
      Map<String, double> orderTypeRevenue = {};

      for (QueryDocumentSnapshot doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        double grandTotal = (data['grandTotal'] ?? 0).toDouble();
        String orderType = data['type'] ?? 'unknown';
        
        totalRevenue += grandTotal;
        orderTypeCount[orderType] = (orderTypeCount[orderType] ?? 0) + 1;
        orderTypeRevenue[orderType] = (orderTypeRevenue[orderType] ?? 0) + grandTotal;
      }

      return {
        'totalRevenue': totalRevenue,
        'totalOrders': totalOrders,
        'averageOrderValue': totalOrders > 0 ? totalRevenue / totalOrders : 0,
        'orderTypeCount': orderTypeCount,
        'orderTypeRevenue': orderTypeRevenue,
      };
    } catch (e) {
      throw 'Failed to get sales analytics: $e';
    }
  }

  // ==================== HELPER METHODS ====================

  static Map<String, dynamic> _orderItemToMap(OrderItem item) {
    return {
      'menuItem': item.menuItem.toJson(),
      'quantity': item.quantity,
      'orderType': item.orderType.name,
      'selectedAddons': item.selectedAddons.map((addon) => {
        'id': addon.id,
        'name': addon.name,
        'price': addon.price,
        'isRequired': addon.isRequired,
      }).toList(),
      'specialInstructions': item.specialInstructions,
      'discount': item.discount != null ? {
        'type': item.discount!.type.name,
        'value': item.discount!.value,
        'reason': item.discount!.reason,
      } : null,
    };
  }

  static OrderItem _orderItemFromMap(Map<String, dynamic> data) {
    return OrderItem(
      menuItem: MenuItem.fromJson(data['menuItem']),
      quantity: data['quantity'],
      orderType: OrderType.values.firstWhere((e) => e.name == data['orderType']),
      selectedAddons: (data['selectedAddons'] as List? ?? []).map((addon) => Addon(
        id: addon['id'],
        name: addon['name'],
        price: (addon['price'] ?? 0).toDouble(),
        isRequired: addon['isRequired'] ?? false,
      )).toList(),
      specialInstructions: data['specialInstructions'],
      discount: data['discount'] != null ? ItemDiscount(
        type: DiscountType.values.firstWhere((e) => e.name == data['discount']['type']),
        value: (data['discount']['value'] ?? 0).toDouble(),
        reason: data['discount']['reason'],
      ) : null,
    );
  }

  static Map<String, dynamic> _customerInfoToMap(CustomerInfo customer) {
    return {
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
    };
  }

  static CustomerInfo _customerInfoFromMap(Map<String, dynamic> data) {
    return CustomerInfo(
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
    );
  }

  static Map<String, dynamic> _orderChargesToMap(OrderCharges charges) {
    return {
      'deliveryCharge': charges.deliveryCharge,
      'packagingCharge': charges.packagingCharge,
      'serviceCharge': charges.serviceCharge,
    };
  }

  static OrderCharges _orderChargesFromMap(Map<String, dynamic> data) {
    return OrderCharges(
      deliveryCharge: (data['deliveryCharge'] ?? 0).toDouble(),
      packagingCharge: (data['packagingCharge'] ?? 0).toDouble(),
      serviceCharge: (data['serviceCharge'] ?? 0).toDouble(),
    );
  }

  static Map<String, dynamic> _paymentToMap(Payment payment) {
    return {
      'method': payment.method.name,
      'amount': payment.amount,
      'timestamp': Timestamp.fromDate(payment.timestamp),
      'transactionId': payment.transactionId,
    };
  }

  static Payment _paymentFromMap(Map<String, dynamic> data) {
    return Payment(
      method: PaymentMethod.values.firstWhere((e) => e.name == data['method']),
      amount: (data['amount'] ?? 0).toDouble(),
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      transactionId: data['transactionId'],
    );
  }

  static Map<String, dynamic> _orderDiscountToMap(OrderDiscount discount) {
    return {
      'type': discount.type.name,
      'value': discount.value,
      'reason': discount.reason,
      'applyToSubtotal': discount.applyToSubtotal,
    };
  }

  static OrderDiscount _orderDiscountFromMap(Map<String, dynamic> data) {
    return OrderDiscount(
      type: DiscountType.values.firstWhere((e) => e.name == data['type']),
      value: (data['value'] ?? 0).toDouble(),
      reason: data['reason'],
      applyToSubtotal: data['applyToSubtotal'] ?? true,
    );
  }

  static app_models.Order _orderFromMap(Map<String, dynamic> data) {
    return app_models.Order(
      id: data['id'],
      items: (data['items'] as List).map((item) => _orderItemFromMap(item)).toList(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      type: OrderType.values.firstWhere((e) => e.name == data['type']),
      status: OrderStatus.values.firstWhere((e) => e.name == data['status']),
      notes: data['notes'],
      customer: data['customer'] != null ? _customerInfoFromMap(data['customer']) : null,
      charges: _orderChargesFromMap(data['charges'] ?? {}),
      payments: (data['payments'] as List? ?? []).map((payment) => _paymentFromMap(payment)).toList(),
      paymentStatus: PaymentStatus.values.firstWhere((e) => e.name == data['paymentStatus']),
      kotPrinted: data['kotPrinted'] ?? false,
      orderDiscount: data['orderDiscount'] != null ? _orderDiscountFromMap(data['orderDiscount']) : null,
    );
  }

  static CustomerData _customerDataFromMap(Map<String, dynamic> data) {
    return CustomerData(
      name: data['name'],
      phone: data['phone'],
      email: data['email'],
      address: data['address'],
      firstOrderDate: (data['firstOrderDate'] as Timestamp).toDate(),
      lastOrderDate: (data['lastOrderDate'] as Timestamp).toDate(),
      totalOrders: data['totalOrders'],
      totalSpent: (data['totalSpent'] ?? 0).toDouble(),
      mostUsedOrderType: OrderType.values.firstWhere((e) => e.name == data['mostUsedOrderType']),
      orderIds: List<String>.from(data['orderIds'] ?? []),
    );
  }
}
