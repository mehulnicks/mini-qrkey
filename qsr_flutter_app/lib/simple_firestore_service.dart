import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:convert';

class SimpleFirestoreService {
  static final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  static final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user's document reference
  static DocumentReference? get _userDoc {
    final user = _auth.currentUser;
    if (user == null) return null;
    return _firestore.collection('users').doc(user.uid);
  }

  // Save user profile
  static Future<void> saveUserProfile({
    required String email,
    required String displayName,
  }) async {
    final user = _auth.currentUser;
    if (user == null) return;

    await _firestore.collection('users').doc(user.uid).set({
      'email': email,
      'displayName': displayName,
      'createdAt': FieldValue.serverTimestamp(),
      'lastLoginAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Save menu item to Firestore
  static Future<void> saveMenuItem(Map<String, dynamic> menuItem) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('menu_items').add({
      ...menuItem,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get menu items from Firestore
  static Future<List<Map<String, dynamic>>> getMenuItems() async {
    final userDoc = _userDoc;
    if (userDoc == null) return [];

    final snapshot = await userDoc.collection('menu_items').get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Save order to Firestore
  static Future<void> saveOrder(Map<String, dynamic> order) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('orders').add({
      ...order,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get orders from Firestore
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final userDoc = _userDoc;
    if (userDoc == null) return [];

    final snapshot = await userDoc.collection('orders')
        .orderBy('createdAt', descending: true)
        .get();
    
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Save customer to Firestore
  static Future<void> saveCustomer(Map<String, dynamic> customer) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.collection('customers').add({
      ...customer,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Get customers from Firestore
  static Future<List<Map<String, dynamic>>> getCustomers() async {
    final userDoc = _userDoc;
    if (userDoc == null) return [];

    final snapshot = await userDoc.collection('customers').get();
    return snapshot.docs.map((doc) => {
      'id': doc.id,
      ...doc.data(),
    }).toList();
  }

  // Save business settings
  static Future<void> saveBusinessSettings(Map<String, dynamic> settings) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    await userDoc.set({
      'businessSettings': settings,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Get business settings
  static Future<Map<String, dynamic>?> getBusinessSettings() async {
    final userDoc = _userDoc;
    if (userDoc == null) return null;

    final doc = await userDoc.get();
    if (!doc.exists) return null;

    final data = doc.data() as Map<String, dynamic>?;
    return data?['businessSettings'] as Map<String, dynamic>?;
  }

  // Sync all data to Firestore (for migration)
  static Future<void> syncAllDataToFirestore({
    List<Map<String, dynamic>>? menuItems,
    List<Map<String, dynamic>>? orders,
    List<Map<String, dynamic>>? customers,
    Map<String, dynamic>? businessSettings,
  }) async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    // Save menu items
    if (menuItems != null) {
      for (final item in menuItems) {
        await saveMenuItem(item);
      }
    }

    // Save orders
    if (orders != null) {
      for (final order in orders) {
        await saveOrder(order);
      }
    }

    // Save customers
    if (customers != null) {
      for (final customer in customers) {
        await saveCustomer(customer);
      }
    }

    // Save business settings
    if (businessSettings != null) {
      await saveBusinessSettings(businessSettings);
    }
  }

  // Delete user data (for account deletion)
  static Future<void> deleteUserData() async {
    final userDoc = _userDoc;
    if (userDoc == null) return;

    // Delete subcollections
    await _deleteCollection(userDoc.collection('menu_items'));
    await _deleteCollection(userDoc.collection('orders'));
    await _deleteCollection(userDoc.collection('customers'));

    // Delete user document
    await userDoc.delete();
  }

  static Future<void> _deleteCollection(CollectionReference collection) async {
    final snapshot = await collection.get();
    for (final doc in snapshot.docs) {
      await doc.reference.delete();
    }
  }

  // Stream for real-time updates
  static Stream<List<Map<String, dynamic>>> streamMenuItems() {
    final userDoc = _userDoc;
    if (userDoc == null) return Stream.value([]);

    return userDoc.collection('menu_items').snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => {
        'id': doc.id,
        ...doc.data(),
      }).toList(),
    );
  }

  static Stream<List<Map<String, dynamic>>> streamOrders() {
    final userDoc = _userDoc;
    if (userDoc == null) return Stream.value([]);

    return userDoc.collection('orders')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs.map((doc) => {
            'id': doc.id,
            ...doc.data(),
          }).toList(),
        );
  }
}
