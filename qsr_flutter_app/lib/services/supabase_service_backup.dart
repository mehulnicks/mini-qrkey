import 'package:supabase_flutter/supabase_flutter.dart';
import '../shared/models/supabase_models.dart';
import '../shared/models/core_models.dart' as core;
import '../config/supabase_config.dart';
import '../shared/models/core_models.dart';

/// Main Supabase service that handles all database operations
class SupabaseService {
  static SupabaseClient get _client => SupabaseConfig.client;

  // ==================== USER PROFILE OPERATIONS ====================
  
  /// Create or update user profile
  static Future<Map<String, dynamic>?> createUserProfile({
    required String businessName,
    String? ownerName,
    String? phone,
    String? address,
    double taxRate = 0.0,
    String currency = '₹',
  }) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

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
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to create user profile: $e');
    }
  }

  /// Get user profile
  static Future<Map<String, dynamic>?> getUserProfile() async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) return null;

      final response = await _client
          .from('user_profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      return response;
    } catch (e) {
      throw Exception('Failed to get user profile: $e');
    }
  }

  /// Update user profile
  static Future<Map<String, dynamic>?> updateUserProfile(Map<String, dynamic> updates) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('user_profiles')
          .update(updates)
          .eq('id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to update user profile: $e');
    }
  }

  // ==================== MENU ITEMS OPERATIONS ====================

  /// Get all menu items for the current user
  // Menu Items
  static Future<List<SupabaseMenuItem>> getMenuItems() async {
    try {
      final userId = getCurrentUserId();
      final response = await SupabaseConfig.client
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
      
      final response = await SupabaseConfig.client
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
      final response = await SupabaseConfig.client
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

  /// Create a new menu item
  static Future<Map<String, dynamic>?> createMenuItem(MenuItem menuItem) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

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
          })
          .select()
          .single();

      // Add addons if any
      if (menuItem.addons != null && menuItem.addons!.isNotEmpty) {
        final addonsData = menuItem.addons!.map((addon) => {
          'menu_item_id': response['id'],
          'name': addon.name,
          'price': addon.price,
          'is_required': addon.isRequired,
        }).toList();

        await _client
            .from('menu_item_addons')
            .insert(addonsData);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to create menu item: $e');
    }
  }

  /// Update an existing menu item
  static Future<Map<String, dynamic>?> updateMenuItem(String menuItemId, MenuItem menuItem) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

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
          })
          .eq('id', menuItemId)
          .eq('user_id', userId)
          .select()
          .single();

      // Update addons (delete existing and create new ones)
      await _client
          .from('menu_item_addons')
          .delete()
          .eq('menu_item_id', menuItemId);

      if (menuItem.addons != null && menuItem.addons!.isNotEmpty) {
        final addonsData = menuItem.addons!.map((addon) => {
          'menu_item_id': menuItemId,
          'name': addon.name,
          'price': addon.price,
          'is_required': addon.isRequired,
        }).toList();

        await _client
            .from('menu_item_addons')
            .insert(addonsData);
      }

      return response;
    } catch (e) {
      throw Exception('Failed to update menu item: $e');
    }
  }

  /// Delete a menu item
  static Future<void> deleteMenuItem(String menuItemId) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('menu_items')
          .delete()
          .eq('id', menuItemId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to delete menu item: $e');
    }
  }

  /// Toggle menu item availability
  static Future<void> toggleMenuItemAvailability(String menuItemId, bool isAvailable) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      await _client
          .from('menu_items')
          .update({'is_available': isAvailable})
          .eq('id', menuItemId)
          .eq('user_id', userId);
    } catch (e) {
      throw Exception('Failed to toggle menu item availability: $e');
    }
  }

  // ==================== CUSTOMERS OPERATIONS ====================

  /// Get all customers for the current user
  static Future<List<Map<String, dynamic>>> getCustomers() async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('customers')
          .select()
          .eq('user_id', userId)
          .order('name');

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to get customers: $e');
    }
  }

  /// Create a new customer
  static Future<Map<String, dynamic>?> createCustomer({
    required String name,
    String? phone,
    String? email,
    String? address,
    String? notes,
  }) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('customers')
          .insert({
            'user_id': userId,
            'name': name,
            'phone': phone,
            'email': email,
            'address': address,
            'notes': notes,
          })
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to create customer: $e');
    }
  }

  /// Update customer
  static Future<Map<String, dynamic>?> updateCustomer(String customerId, Map<String, dynamic> updates) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('customers')
          .update(updates)
          .eq('id', customerId)
          .eq('user_id', userId)
          .select()
          .single();

      return response;
    } catch (e) {
      throw Exception('Failed to update customer: $e');
    }
  }

  /// Search customers by name or phone
  static Future<List<Map<String, dynamic>>> searchCustomers(String query) async {
    try {
      final userId = SupabaseConfig.currentUserId;
      if (userId == null) throw Exception('User not authenticated');

      final response = await _client
          .from('customers')
          .select()
          .eq('user_id', userId)
          .or('name.ilike.%$query%,phone.ilike.%$query%')
          .order('name')
          .limit(10);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      throw Exception('Failed to search customers: $e');
    }
  }

  // ==================== AUTHENTICATION HELPERS ====================

  /// Sign in with email and password
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

  /// Sign up with email and password
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

  /// Sign out
  static Future<void> signOut() async {
    try {
      await _client.auth.signOut();
    } catch (e) {
      throw Exception('Sign out failed: $e');
    }
  }

  /// Reset password
  static Future<void> resetPassword(String email) async {
    try {
      await _client.auth.resetPasswordForEmail(email);
    } catch (e) {
      throw Exception('Password reset failed: $e');
    }
  }

  // ==================== REAL-TIME SUBSCRIPTIONS ====================

  /// Subscribe to menu items changes
  static RealtimeChannel subscribeToMenuItems(Function(List<Map<String, dynamic>>) onData) {
    final userId = SupabaseConfig.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

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
            // Refresh menu items data
            getMenuItems().then(onData);
          },
        )
        .subscribe();
  }

  /// Subscribe to orders changes
  static RealtimeChannel subscribeToOrders(Function(List<Map<String, dynamic>>) onData) {
    final userId = SupabaseConfig.currentUserId;
    if (userId == null) throw Exception('User not authenticated');

    return _client
        .channel('orders_$userId')
        .onPostgresChanges(
          event: PostgresChangeEvent.all,
          schema: 'public',
          table: 'orders',
          filter: PostgresChangeFilter(
            type: PostgresChangeFilterType.eq,
            column: 'user_id',
            value: userId,
          ),
          callback: (payload) {
            // Refresh orders data
            // This will be implemented in OrdersService
          },
        )
        .subscribe();
  }
}
