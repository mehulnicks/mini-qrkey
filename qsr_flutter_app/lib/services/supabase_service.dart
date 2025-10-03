import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/supabase_models.dart';
import '../shared/models/core_models.dart' as core;
import '../config/supabase_config.dart';

/// Clean Supabase service with unified models
class SupabaseService {
  static SupabaseClient get _client => SupabaseConfig.client;

  static String getCurrentUserId() {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('User not authenticated');
    return userId;
  }

  // ==================== AUTHENTICATION ====================

  static Future<AuthResponse> signInWithEmail(String email, String password) async {
    try {
      return await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw Exception('Sign in failed: $e');
    }
  }

  static Future<AuthResponse> signUpWithEmail(String email, String password, {
    required String businessName,
    String? ownerName,
  }) async {
    try {
      return await _client.auth.signUp(
        email: email,
        password: password,
        data: {
          'business_name': businessName,
          'full_name': ownerName,
        },
      );
    } catch (e) {
      throw Exception('Sign up failed: $e');
    }
  }

  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  static User? get currentUser => _client.auth.currentUser;
  static bool get isAuthenticated => currentUser != null;

  // ==================== USER PROFILE ====================

  static Future<UserProfile?> getUserProfile() async {
    try {
      final userId = getCurrentUserId();
      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response != null ? UserProfile.fromJson(response) : null;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  static Future<UserProfile> createUserProfile({
    required String businessName,
    String? ownerName,
    String? phone,
    String? address,
    double taxRate = 0.0,
    String currency = '₹',
  }) async {
    try {
      final userId = getCurrentUserId();
      final now = DateTime.now();

      final response = await _client
          .from('user_profiles')
          .upsert({
            'id': userId,
            'business_name': businessName,
            'owner_name': ownerName,
            'phone': phone,
            'address': address,
            'tax_rate': taxRate,
            'currency': currency,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      return UserProfile.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  // ==================== MENU ITEMS ====================

  static Future<List<SupabaseMenuItem>> getMenuItems() async {
    try {
      final userId = getCurrentUserId();
      final response = await _client
          .from('menu_items')
          .select('*')
          .eq('user_id', userId)
          .order('name');

      return (response as List)
          .map((item) => SupabaseMenuItem.fromJson(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch menu items: $e');
    }
  }

  static Future<SupabaseMenuItem> createMenuItem(core.MenuItem menuItem) async {
    try {
      final userId = getCurrentUserId();
      final now = DateTime.now();
      
      final response = await _client
          .from('menu_items')
          .insert({
            'user_id': userId,
            'name': menuItem.name,
            'description': menuItem.description,
            'category': menuItem.category,
            'dine_in_price': menuItem.dineInPrice,
            'takeaway_price': menuItem.takeawayPrice,
            'delivery_price': menuItem.deliveryPrice,
            'is_available': menuItem.isAvailable,
            'allow_customization': menuItem.allowCustomization,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      return SupabaseMenuItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create menu item: $e');
    }
  }

  static Future<SupabaseMenuItem> updateMenuItem(String id, core.MenuItem menuItem) async {
    try {
      final response = await _client
          .from('menu_items')
          .update({
            'name': menuItem.name,
            'description': menuItem.description,
            'category': menuItem.category,
            'dine_in_price': menuItem.dineInPrice,
            'takeaway_price': menuItem.takeawayPrice,
            'delivery_price': menuItem.deliveryPrice,
            'is_available': menuItem.isAvailable,
            'allow_customization': menuItem.allowCustomization,
            'updated_at': DateTime.now().toIso8601String(),
          })
          .eq('id', id)
          .select()
          .single();

      return SupabaseMenuItem.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  static Future<void> deleteMenuItem(String id) async {
    try {
      final userId = getCurrentUserId();
      await _client
          .from('menu_items')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  // ==================== CUSTOMERS ====================

  static Future<List<SupabaseCustomer>> getCustomers() async {
    try {
      final userId = getCurrentUserId();
      final response = await _client
          .from('customers')
          .select('*')
          .eq('user_id', userId)
          .order('name');

      return (response as List)
          .map((customer) => SupabaseCustomer.fromJson(customer))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch customers: $e');
    }
  }

  static Future<SupabaseCustomer> createCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) async {
    try {
      final userId = getCurrentUserId();
      final now = DateTime.now();
      
      final response = await _client
          .from('customers')
          .insert({
            'user_id': userId,
            'name': name,
            'phone': phone,
            'email': email,
            'address': address,
            'notes': notes,
            'created_at': now.toIso8601String(),
            'updated_at': now.toIso8601String(),
          })
          .select()
          .single();

      return SupabaseCustomer.fromJson(response);
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  static Future<SupabaseCustomer> updateCustomer(String id, Map<String, dynamic> updates) async {
    try {
      final userId = getCurrentUserId();
      updates['updated_at'] = DateTime.now().toIso8601String();
      
      final response = await _client
          .from('customers')
          .update(updates)
          .eq('id', id)
          .eq('user_id', userId)
          .select()
          .single();

      return SupabaseCustomer.fromJson(response);
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  // ==================== REAL-TIME SUBSCRIPTIONS ====================

  static RealtimeChannel subscribeToMenuItems(Function(List<SupabaseMenuItem>) onData) {
    final userId = getCurrentUserId();

    return _client
        .channel('menu_items_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'menu_items',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            getMenuItems().then(onData);
          },
        )
        .subscribe();
  }

  static RealtimeChannel subscribeToCustomers(Function(List<SupabaseCustomer>) onData) {
    final userId = getCurrentUserId();

    return _client
        .channel('customers_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'customers',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            getCustomers().then(onData);
          },
        )
        .subscribe();
  }
}
