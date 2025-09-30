import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/supabase_config.dart';
import 'dart:async';
import 'dart:typed_data';

class SupabaseService {
  static SupabaseClient get _client => SupabaseConfig.client;
  
  // Authentication methods
  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    return await _client.auth.signInWithPassword(
      email: email,
      password: password,
    );
  }
  
  static Future<AuthResponse> signUpWithEmail(String email, String password) async {
    return await _client.auth.signUp(
      email: email,
      password: password,
    );
  }
  
  static Future<void> signOut() async {
    await _client.auth.signOut();
  }
  
  static User? get currentUser => _client.auth.currentUser;
  
  static Stream<AuthState> get authStateChanges => _client.auth.onAuthStateChange;
  
  // Database operations for Orders
  static Future<List<Map<String, dynamic>>> getOrders() async {
    final response = await _client
        .from('orders')
        .select()
        .order('created_at', ascending: false);
    return response;
  }
  
  static Future<Map<String, dynamic>> createOrder(Map<String, dynamic> orderData) async {
    final response = await _client
        .from('orders')
        .insert(orderData)
        .select()
        .single();
    return response;
  }
  
  static Future<Map<String, dynamic>> updateOrder(String orderId, Map<String, dynamic> updates) async {
    final response = await _client
        .from('orders')
        .update(updates)
        .eq('id', orderId)
        .select()
        .single();
    return response;
  }
  
  static Future<void> deleteOrder(String orderId) async {
    await _client
        .from('orders')
        .delete()
        .eq('id', orderId);
  }
  
  // Database operations for Menu Items
  static Future<List<Map<String, dynamic>>> getMenuItems() async {
    final response = await _client
        .from('menu_items')
        .select()
        .order('name');
    return response;
  }
  
  static Future<Map<String, dynamic>> createMenuItem(Map<String, dynamic> itemData) async {
    final response = await _client
        .from('menu_items')
        .insert(itemData)
        .select()
        .single();
    return response;
  }
  
  static Future<Map<String, dynamic>> updateMenuItem(String itemId, Map<String, dynamic> updates) async {
    final response = await _client
        .from('menu_items')
        .update(updates)
        .eq('id', itemId)
        .select()
        .single();
    return response;
  }
  
  static Future<void> deleteMenuItem(String itemId) async {
    await _client
        .from('menu_items')
        .delete()
        .eq('id', itemId);
  }
  
  // Real-time subscriptions
  static StreamSubscription subscribeToOrders(Function(List<Map<String, dynamic>>) callback) {
    return _client
        .from('orders')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
          callback(data);
        });
  }
  
  static StreamSubscription subscribeToMenuItems(Function(List<Map<String, dynamic>>) callback) {
    return _client
        .from('menu_items')
        .stream(primaryKey: ['id'])
        .listen((List<Map<String, dynamic>> data) {
          callback(data);
        });
  }
  
  // File storage operations
  static Future<String> uploadFile(String bucket, String path, Uint8List fileBytes) async {
    await _client.storage
        .from(bucket)
        .uploadBinary(path, fileBytes);
    
    return _client.storage
        .from(bucket)
        .getPublicUrl(path);
  }
  
  static Future<void> deleteFile(String bucket, String path) async {
    await _client.storage
        .from(bucket)
        .remove([path]);
  }
}
