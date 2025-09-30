import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../services/supabase_service.dart';

// Auth state provider
final authStateProvider = StreamProvider<AuthState>((ref) {
  return SupabaseService.authStateChanges;
});

// Current user provider
final currentUserProvider = Provider<User?>((ref) {
  final authState = ref.watch(authStateProvider);
  return authState.when(
    data: (state) => state.session?.user,
    loading: () => null,
    error: (_, __) => null,
  );
});

// Orders provider
final ordersProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await SupabaseService.getOrders();
});

// Menu items provider
final menuItemsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return await SupabaseService.getMenuItems();
});

// Auth service provider
class AuthNotifier extends StateNotifier<AsyncValue<User?>> {
  AuthNotifier() : super(const AsyncValue.loading()) {
    _init();
  }
  
  void _init() {
    final user = SupabaseService.currentUser;
    state = AsyncValue.data(user);
  }
  
  Future<void> signInWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await SupabaseService.signInWithEmail(email, password);
      state = AsyncValue.data(response.user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signUpWithEmail(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final response = await SupabaseService.signUpWithEmail(email, password);
      state = AsyncValue.data(response.user);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
  
  Future<void> signOut() async {
    try {
      await SupabaseService.signOut();
      state = const AsyncValue.data(null);
    } catch (e) {
      state = AsyncValue.error(e, StackTrace.current);
    }
  }
}

final authNotifierProvider = StateNotifierProvider<AuthNotifier, AsyncValue<User?>>((ref) {
  return AuthNotifier();
});

// Orders notifier for CRUD operations
class OrdersNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  OrdersNotifier() : super([]) {
    loadOrders();
  }
  
  Future<void> loadOrders() async {
    try {
      final orders = await SupabaseService.getOrders();
      state = orders;
    } catch (e) {
      // Handle error
      print('Error loading orders: $e');
    }
  }
  
  Future<void> createOrder(Map<String, dynamic> orderData) async {
    try {
      final newOrder = await SupabaseService.createOrder(orderData);
      state = [newOrder, ...state];
    } catch (e) {
      print('Error creating order: $e');
    }
  }
  
  Future<void> updateOrder(String orderId, Map<String, dynamic> updates) async {
    try {
      final updatedOrder = await SupabaseService.updateOrder(orderId, updates);
      state = state.map((order) {
        if (order['id'] == orderId) {
          return updatedOrder;
        }
        return order;
      }).toList();
    } catch (e) {
      print('Error updating order: $e');
    }
  }
  
  Future<void> deleteOrder(String orderId) async {
    try {
      await SupabaseService.deleteOrder(orderId);
      state = state.where((order) => order['id'] != orderId).toList();
    } catch (e) {
      print('Error deleting order: $e');
    }
  }
}

final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, List<Map<String, dynamic>>>((ref) {
  return OrdersNotifier();
});

// Menu items notifier for CRUD operations
class MenuItemsNotifier extends StateNotifier<List<Map<String, dynamic>>> {
  MenuItemsNotifier() : super([]) {
    loadMenuItems();
  }
  
  Future<void> loadMenuItems() async {
    try {
      final items = await SupabaseService.getMenuItems();
      state = items;
    } catch (e) {
      print('Error loading menu items: $e');
    }
  }
  
  Future<void> createMenuItem(Map<String, dynamic> itemData) async {
    try {
      final newItem = await SupabaseService.createMenuItem(itemData);
      state = [...state, newItem];
    } catch (e) {
      print('Error creating menu item: $e');
    }
  }
  
  Future<void> updateMenuItem(String itemId, Map<String, dynamic> updates) async {
    try {
      final updatedItem = await SupabaseService.updateMenuItem(itemId, updates);
      state = state.map((item) {
        if (item['id'] == itemId) {
          return updatedItem;
        }
        return item;
      }).toList();
    } catch (e) {
      print('Error updating menu item: $e');
    }
  }
  
  Future<void> deleteMenuItem(String itemId) async {
    try {
      await SupabaseService.deleteMenuItem(itemId);
      state = state.where((item) => item['id'] != itemId).toList();
    } catch (e) {
      print('Error deleting menu item: $e');
    }
  }
}

final menuItemsNotifierProvider = StateNotifierProvider<MenuItemsNotifier, List<Map<String, dynamic>>>((ref) {
  return MenuItemsNotifier();
});
