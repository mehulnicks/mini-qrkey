import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../services/firestore_service.dart';
import '../services/firebase_auth_service.dart';
import '../clean_qsr_main.dart' as app_models;

class DataMigrationService {
  static bool _migrationCompleted = false;
  
  /// Migrate all local data to Firestore when user first logs in
  static Future<void> migrateLocalDataToFirestore(String userId) async {
    if (_migrationCompleted) return;
    
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Migrate menu items
      await _migrateMenuItems(prefs, userId);
      
      // Migrate orders
      await _migrateOrders(prefs, userId);
      
      // Migrate customers
      await _migrateCustomers(prefs, userId);
      
      // Migrate business settings
      await _migrateBusinessSettings(prefs, userId);
      
      // Mark migration as completed
      await prefs.setBool('firestore_migration_completed', true);
      _migrationCompleted = true;
      
      print('✅ Data migration to Firestore completed successfully');
    } catch (e) {
      print('❌ Error during data migration: $e');
      throw e;
    }
  }
  
  /// Migrate menu items from SharedPreferences to Firestore
  static Future<void> _migrateMenuItems(SharedPreferences prefs, String userId) async {
    final menuItemsJson = prefs.getString('menu_items');
    if (menuItemsJson != null) {
      try {
        final List<dynamic> menuItemsList = json.decode(menuItemsJson);
        
        for (var itemData in menuItemsList) {
          final menuItem = app_models.MenuItem.fromJson(itemData as Map<String, dynamic>);
          
          await FirestoreService.addMenuItem(
            businessId: 'default_business', // You can update this logic
            item: {
              'id': menuItem.id,
              'name': menuItem.name,
              'dineInPrice': menuItem.dineInPrice,
              'takeawayPrice': menuItem.takeawayPrice,
              'deliveryPrice': menuItem.deliveryPrice,
              'category': menuItem.category,
              'description': menuItem.description,
              'isAvailable': menuItem.isAvailable,
              'allowCustomization': menuItem.allowCustomization,
              'addons': menuItem.addons?.map((addon) => {
                'id': addon.id,
                'name': addon.name,
                'price': addon.price,
                'isRequired': addon.isRequired,
              }).toList(),
              'createdAt': DateTime.now(),
              'updatedAt': DateTime.now(),
            },
          );
        }
        
        print('✅ Migrated ${menuItemsList.length} menu items');
      } catch (e) {
        print('❌ Error migrating menu items: $e');
      }
    }
  }
  
  /// Migrate orders from SharedPreferences to Firestore
  static Future<void> _migrateOrders(SharedPreferences prefs, String userId) async {
    final ordersJson = prefs.getString('orders');
    if (ordersJson != null) {
      try {
        final List<dynamic> ordersList = json.decode(ordersJson);
        
        for (var orderData in ordersList) {
          final order = app_models.Order.fromJson(orderData as Map<String, dynamic>);
          
          await FirestoreService.createOrder(
            businessId: 'default_business',
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
                'timestamp': payment.timestamp,
                'transactionId': payment.transactionId,
              }).toList(),
              'notes': order.notes,
              'specialInstructions': order.specialInstructions,
              'createdAt': order.createdAt,
              'updatedAt': order.updatedAt,
            },
          );
        }
        
        print('✅ Migrated ${ordersList.length} orders');
      } catch (e) {
        print('❌ Error migrating orders: $e');
      }
    }
  }
  
  /// Migrate customers from SharedPreferences to Firestore
  static Future<void> _migrateCustomers(SharedPreferences prefs, String userId) async {
    final customersJson = prefs.getString('customers');
    if (customersJson != null) {
      try {
        final Map<String, dynamic> customersMap = json.decode(customersJson);
        
        for (var entry in customersMap.entries) {
          final customerData = entry.value as Map<String, dynamic>;
          
          await FirestoreService.createCustomer(
            businessId: 'default_business',
            customerData: {
              'phone': entry.key,
              'name': customerData['name'],
              'email': customerData['email'],
              'address': customerData['address'],
              'totalOrders': customerData['totalOrders'] ?? 0,
              'totalSpent': customerData['totalSpent'] ?? 0.0,
              'lastOrderDate': customerData['lastOrderDate'] != null 
                  ? DateTime.parse(customerData['lastOrderDate'])
                  : null,
              'createdAt': DateTime.now(),
              'updatedAt': DateTime.now(),
            },
          );
        }
        
        print('✅ Migrated ${customersMap.length} customers');
      } catch (e) {
        print('❌ Error migrating customers: $e');
      }
    }
  }
  
  /// Migrate business settings from SharedPreferences to Firestore
  static Future<void> _migrateBusinessSettings(SharedPreferences prefs, String userId) async {
    try {
      // Create default business if it doesn't exist
      await FirestoreService.createBusiness(
        businessData: {
          'name': prefs.getString('business_name') ?? 'My QSR Business',
          'owners': [userId],
          'settings': {
            'currency': prefs.getString('currency') ?? 'INR',
            'taxRate': prefs.getDouble('tax_rate') ?? 0.0,
            'serviceChargeRate': prefs.getDouble('service_charge_rate') ?? 0.0,
            'deliveryCharge': prefs.getDouble('delivery_charge') ?? 0.0,
            'packagingCharge': prefs.getDouble('packaging_charge') ?? 0.0,
            'language': prefs.getString('language') ?? 'en',
            'theme': prefs.getString('theme') ?? 'light',
            'enableKOT': prefs.getBool('enable_kot') ?? true,
            'enableWhatsApp': prefs.getBool('enable_whatsapp') ?? true,
            'printerSettings': {
              'kotPrinterName': prefs.getString('kot_printer_name'),
              'billPrinterName': prefs.getString('bill_printer_name'),
              'paperSize': prefs.getString('paper_size') ?? '58mm',
            },
          },
          'createdAt': DateTime.now(),
          'updatedAt': DateTime.now(),
        },
      );
      
      print('✅ Migrated business settings');
    } catch (e) {
      print('❌ Error migrating business settings: $e');
    }
  }
  
  /// Sync data from Firestore to local storage for offline access
  static Future<void> syncFirestoreToLocal(String userId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      
      // Sync menu items
      final menuItems = await FirestoreService.getMenuItems('default_business');
      if (menuItems.isNotEmpty) {
        final menuItemsJson = json.encode(menuItems.map((item) => item.data()).toList());
        await prefs.setString('menu_items', menuItemsJson);
      }
      
      // Sync recent orders
      final orders = await FirestoreService.getOrders('default_business');
      if (orders.isNotEmpty) {
        final ordersJson = json.encode(orders.map((order) => order.data()).toList());
        await prefs.setString('orders', ordersJson);
      }
      
      // Sync customers
      final customers = await FirestoreService.getCustomers('default_business');
      if (customers.isNotEmpty) {
        final customersMap = <String, dynamic>{};
        for (var customer in customers) {
          final data = customer.data();
          customersMap[data['phone']] = data;
        }
        await prefs.setString('customers', json.encode(customersMap));
      }
      
      print('✅ Synced Firestore data to local storage');
    } catch (e) {
      print('❌ Error syncing Firestore to local: $e');
    }
  }
  
  /// Check if migration has been completed
  static Future<bool> isMigrationCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('firestore_migration_completed') ?? false;
  }
  
  /// Reset migration status (for testing purposes)
  static Future<void> resetMigrationStatus() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('firestore_migration_completed');
    _migrationCompleted = false;
  }
}

// Provider for data migration service
final dataMigrationProvider = Provider<DataMigrationService>((ref) {
  return DataMigrationService();
});

// Provider to track migration status
final migrationStatusProvider = FutureProvider<bool>((ref) async {
  return await DataMigrationService.isMigrationCompleted();
});

// Enhanced auth wrapper that handles data migration
class AuthWrapperWithMigration extends ConsumerWidget {
  final Widget child;
  
  const AuthWrapperWithMigration({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);
    
    return authState.when(
      loading: () => const SplashScreen(),
      error: (error, stack) => ErrorScreen(error: error.toString()),
      data: (user) {
        if (user == null) {
          return const LoginScreen();
        }
        
        // User is authenticated, check if migration is needed
        return FutureBuilder<bool>(
          future: DataMigrationService.isMigrationCompleted(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const MigrationSplashScreen();
            }
            
            if (snapshot.hasError) {
              return ErrorScreen(error: 'Migration check failed: ${snapshot.error}');
            }
            
            final migrationCompleted = snapshot.data ?? false;
            
            if (!migrationCompleted) {
              // Start migration
              return FutureBuilder(
                future: DataMigrationService.migrateLocalDataToFirestore(user.uid),
                builder: (context, migrationSnapshot) {
                  if (migrationSnapshot.connectionState == ConnectionState.waiting) {
                    return const MigrationInProgressScreen();
                  }
                  
                  if (migrationSnapshot.hasError) {
                    return ErrorScreen(error: 'Migration failed: ${migrationSnapshot.error}');
                  }
                  
                  // Migration completed, show main app
                  return child;
                },
              );
            }
            
            // Migration already completed, show main app
            return child;
          },
        );
      },
    );
  }
}

class MigrationSplashScreen extends StatelessWidget {
  const MigrationSplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_upload,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'QSR Management',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Checking data migration status...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}

class MigrationInProgressScreen extends StatelessWidget {
  const MigrationInProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFF9933),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.cloud_sync,
              size: 100,
              color: Colors.white,
            ),
            const SizedBox(height: 24),
            const Text(
              'Setting up your cloud account',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Migrating your data to the cloud...\nThis may take a few moments.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
              ),
            ),
            const SizedBox(height: 48),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
            ),
            const SizedBox(height: 24),
            const Text(
              '🔄 Syncing menu items\n☁️ Uploading orders\n👥 Migrating customers\n⚙️ Configuring settings',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
