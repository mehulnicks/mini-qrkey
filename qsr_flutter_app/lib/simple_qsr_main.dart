import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:convert';
import 'dart:math';

// Language Support
enum AppLanguage { english, hindi }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english);

  void setLanguage(AppLanguage language) {
    state = language;
  }
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>(
  (ref) => LanguageNotifier(),
);

class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'QSR Restaurant App',
      'home': 'Home',
      'menu': 'Menu',
      'orders': 'Orders',
      'reports': 'Reports',
      'settings': 'Settings',
      'search': 'Search',
      'add_to_order': 'Add to Order',
      'current_order': 'Current Order',
      'place_order': 'Place Order',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'total': 'Total',
      'quantity': 'Quantity',
      'item_added': 'Item added to order',
      'order_placed': 'Order placed successfully!',
      'dine_in': 'Dine In',
      'takeaway': 'Takeaway',
      'delivery': 'Delivery',
      'order_type': 'Order Type',
      'customer_name_required': 'Customer name is required',
      'customer_name': 'Customer Name',
      'customer_phone': 'Customer Phone',
      'customer_address': 'Customer Address',
      'enable_dine_in': 'Enable Dine-In',
      'dine_in_feature_subtitle': 'Enable dine-in ordering',
      'store_settings': 'Store Settings',
      'store_name': 'Store Name',
      'store_address': 'Store Address', 
      'store_phone': 'Store Phone',
      'language': 'Language',
      'english': 'English',
      'hindi': 'हिंदी',
    },
    'hi': {
      'app_title': 'QSR रेस्टोरेंट ऐप',
      'home': 'होम',
      'menu': 'मेन्यू',
      'orders': 'ऑर्डर',
      'reports': 'रिपोर्ट',
      'settings': 'सेटिंग्स',
      'search': 'खोजें',
      'add_to_order': 'ऑर्डर में जोड़ें',
      'current_order': 'वर्तमान ऑर्डर',
      'place_order': 'ऑर्डर करें',
      'cancel': 'रद्द करें',
      'confirm': 'पुष्टि करें',
      'total': 'कुल',
      'quantity': 'मात्रा',
      'item_added': 'आइटम ऑर्डर में जोड़ा गया',
      'order_placed': 'ऑर्डर सफलतापूर्वक दिया गया!',
      'dine_in': 'रेस्टोरेंट में खाना',
      'takeaway': 'पैकिंग',
      'delivery': 'डिलीवरी',
      'order_type': 'ऑर्डर का प्रकार',
      'customer_name_required': 'ग्राहक का नाम आवश्यक है',
      'customer_name': 'ग्राहक का नाम',
      'customer_phone': 'ग्राहक का फोन',
      'customer_address': 'ग्राहक का पता',
      'enable_dine_in': 'डाइन-इन सक्षम करें',
      'dine_in_feature_subtitle': 'डाइन-इन ऑर्डरिंग सक्षम करें',
      'store_settings': 'स्टोर सेटिंग्स',
      'store_name': 'स्टोर का नाम',
      'store_address': 'स्टोर का पता',
      'store_phone': 'स्टोर का फोन',
      'language': 'भाषा',
      'english': 'English',
      'hindi': 'हिंदी',
    },
  };

  String get(String key) {
    final langCode = language == AppLanguage.hindi ? 'hi' : 'en';
    return _localizedValues[langCode]?[key] ?? key;
  }
}

// Models
class MenuItemPricing {
  final double dineInPrice;
  final double takeawayPrice;
  final double deliveryPrice;

  MenuItemPricing({
    required this.dineInPrice,
    required this.takeawayPrice,
    required this.deliveryPrice,
  });

  double getPriceForOrderType(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        return dineInPrice;
      case OrderType.takeaway:
        return takeawayPrice;
      case OrderType.delivery:
        return deliveryPrice;
    }
  }
}

class MenuItem {
  final String id;
  final String name;
  final MenuItemPricing pricing;
  final String category;
  final String? description;
  final bool isAvailable;
  final List<OrderType> availableForOrderTypes;

  MenuItem({
    required this.id,
    required this.name,
    required this.pricing,
    required this.category,
    this.description,
    this.isAvailable = true,
    this.availableForOrderTypes = const [OrderType.dineIn, OrderType.takeaway, OrderType.delivery],
  });

  bool isAvailableForOrderType(OrderType orderType) {
    return isAvailable && availableForOrderTypes.contains(orderType);
  }

  double getPriceForOrderType(OrderType orderType) {
    return pricing.getPriceForOrderType(orderType);
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  double get total => price * quantity;

  OrderItem copyWith({
    int? quantity,
    String? specialInstructions,
  }) => OrderItem(
    menuItemId: menuItemId,
    name: name,
    price: price,
    quantity: quantity ?? this.quantity,
    specialInstructions: specialInstructions ?? this.specialInstructions,
  );
}

enum OrderStatus { pending, preparing, ready, completed, cancelled }
enum OrderType { dineIn, takeaway, delivery }

class Order {
  final String id;
  final String orderNumber;
  final DateTime createdAt;
  final List<OrderItem> items;
  final OrderStatus status;
  final OrderType orderType;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final double subtotal;
  final double tax;
  final double total;

  Order({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.items,
    required this.status,
    required this.orderType,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    required this.subtotal,
    required this.tax,
    required this.total,
  });
}

// Settings Model
class AppSettings {
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final double taxRate;
  final bool dineInEnabled;

  AppSettings({
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
    required this.taxRate,
    required this.dineInEnabled,
  });

  AppSettings copyWith({
    String? storeName,
    String? storeAddress,
    String? storePhone,
    double? taxRate,
    bool? dineInEnabled,
  }) => AppSettings(
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress ?? this.storeAddress,
    storePhone: storePhone ?? this.storePhone,
    taxRate: taxRate ?? this.taxRate,
    dineInEnabled: dineInEnabled ?? this.dineInEnabled,
  );
}

// Providers
final menuProvider = StateNotifierProvider<MenuNotifier, List<MenuItem>>((ref) {
  return MenuNotifier();
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

final currentOrderProvider = StateNotifierProvider<CurrentOrderNotifier, List<OrderItem>>((ref) {
  return CurrentOrderNotifier();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

// State Notifiers
class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super([]) {
    _loadDefaultMenu();
  }

  void _loadDefaultMenu() {
    state = [
      MenuItem(
        id: '1', 
        name: 'Samosa', 
        pricing: MenuItemPricing(dineInPrice: 25.0, takeawayPrice: 20.0, deliveryPrice: 30.0), 
        category: 'Snacks', 
        description: 'Crispy fried pastry with spiced filling'
      ),
      MenuItem(
        id: '2', 
        name: 'Vada Pav', 
        pricing: MenuItemPricing(dineInPrice: 35.0, takeawayPrice: 30.0, deliveryPrice: 40.0), 
        category: 'Snacks', 
        description: 'Mumbai street food with spiced potato fritter'
      ),
      MenuItem(
        id: '3', 
        name: 'Masala Chai', 
        pricing: MenuItemPricing(dineInPrice: 15.0, takeawayPrice: 12.0, deliveryPrice: 18.0), 
        category: 'Beverages', 
        description: 'Traditional Indian spiced tea'
      ),
      MenuItem(
        id: '4', 
        name: 'Butter Chicken', 
        pricing: MenuItemPricing(dineInPrice: 280.0, takeawayPrice: 260.0, deliveryPrice: 300.0), 
        category: 'Main Course', 
        description: 'Creamy tomato-based chicken curry'
      ),
    ];
  }
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  void addOrder(Order order) {
    state = [order, ...state];
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          Order(
            id: order.id,
            orderNumber: order.orderNumber,
            createdAt: order.createdAt,
            items: order.items,
            status: status,
            orderType: order.orderType,
            customerName: order.customerName,
            customerPhone: order.customerPhone,
            customerAddress: order.customerAddress,
            subtotal: order.subtotal,
            tax: order.tax,
            total: order.total,
          )
        else order,
    ];
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]);

  OrderType currentOrderType = OrderType.takeaway;

  void addItem(OrderItem item) {
    final existingIndex = state.indexWhere((orderItem) => orderItem.menuItemId == item.menuItemId);
    
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(quantity: existingItem.quantity + item.quantity);
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void updateItem(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    state = [
      for (final item in state)
        if (item.menuItemId == menuItemId)
          item.copyWith(quantity: quantity)
        else item,
    ];
  }

  void removeItem(String menuItemId) {
    state = state.where((item) => item.menuItemId != menuItemId).toList();
  }

  void clearOrder() {
    state = [];
  }

  void setOrderType(OrderType orderType) {
    currentOrderType = orderType;
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  double get total => state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings(
    storeName: 'QSR Restaurant',
    storeAddress: '',
    storePhone: '',
    taxRate: 18.0,
    dineInEnabled: false,
  ));

  void updateSettings(AppSettings settings) {
    state = settings;
  }

  void toggleDineInEnabled() {
    final updatedSettings = state.copyWith(dineInEnabled: !state.dineInEnabled);
    updateSettings(updatedSettings);
  }
}

// Utility Functions
String formatCurrency(double amount) {
  return '₹${amount.toStringAsFixed(2)}';
}

String formatOrderNumber(String orderNumber) {
  return '#$orderNumber';
}

String getStatusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.preparing:
      return 'Preparing';
    case OrderStatus.ready:
      return 'Ready';
    case OrderStatus.completed:
      return 'Completed';
    case OrderStatus.cancelled:
      return 'Cancelled';
  }
}

String generateOrderId() {
  final random = Random();
  return (random.nextInt(900000) + 100000).toString();
}

String generateOrderNumber() {
  return DateTime.now().millisecondsSinceEpoch.toString().substring(8);
}

// Main App
class QSRApp extends ConsumerWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);

    return MaterialApp(
      title: localizations.get('app_title'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9933),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9933),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: HomeScreen(localizations: localizations),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Screen
class HomeScreen extends ConsumerStatefulWidget {
  final AppLocalizations localizations;

  const HomeScreen({super.key, required this.localizations});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      MenuScreen(localizations: widget.localizations),
      OrdersScreen(localizations: widget.localizations),
      ReportsScreen(localizations: widget.localizations),
      SettingsScreen(localizations: widget.localizations),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9933),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: widget.localizations.get('menu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long),
            label: widget.localizations.get('orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: widget.localizations.get('reports'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: widget.localizations.get('settings'),
          ),
        ],
      ),
    );
  }
}

// Menu Screen
class MenuScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const MenuScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('menu')),
        actions: [
          if (currentOrder.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _showCurrentOrder(context, ref),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${currentOrderNotifier.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Order Type Selection (if dine-in enabled)
          if (settings.dineInEnabled)
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.get('order_type'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<OrderType>(
                              segments: [
                                ButtonSegment(
                                  value: OrderType.dineIn,
                                  label: Text(localizations.get('dine_in')),
                                ),
                                ButtonSegment(
                                  value: OrderType.takeaway,
                                  label: Text(localizations.get('takeaway')),
                                ),
                                ButtonSegment(
                                  value: OrderType.delivery,
                                  label: Text(localizations.get('delivery')),
                                ),
                              ],
                              selected: {currentOrderNotifier.currentOrderType},
                              onSelectionChanged: (Set<OrderType> newSelection) {
                                currentOrderNotifier.setOrderType(newSelection.first);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];
                final price = item.getPriceForOrderType(currentOrderNotifier.currentOrderType);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                formatCurrency(price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF9933),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: item.isAvailableForOrderType(currentOrderNotifier.currentOrderType)
                              ? () => _addToOrder(context, ref, item, price)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9933),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(localizations.get('add_to_order')),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToOrder(BuildContext context, WidgetRef ref, MenuItem item, double price) {
    final orderItem = OrderItem(
      menuItemId: item.id,
      name: item.name,
      price: price,
      quantity: 1,
    );
    
    ref.read(currentOrderProvider.notifier).addItem(orderItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.get('item_added')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showCurrentOrder(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CurrentOrderSheet(localizations: localizations),
    );
  }
}

// Current Order Sheet
class CurrentOrderSheet extends ConsumerWidget {
  final AppLocalizations localizations;

  const CurrentOrderSheet({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    if (currentOrder.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No items in order',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final subtotal = currentOrderNotifier.total;
    final tax = subtotal * (settings.taxRate / 100);
    final total = subtotal + tax;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.get('current_order'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: currentOrder.length,
              itemBuilder: (context, index) {
                final item = currentOrder[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${formatCurrency(item.price)} x ${item.quantity}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (item.quantity > 1) {
                                  currentOrderNotifier.updateItem(
                                    item.menuItemId,
                                    item.quantity - 1,
                                  );
                                } else {
                                  currentOrderNotifier.removeItem(item.menuItemId);
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () {
                                currentOrderNotifier.updateItem(
                                  item.menuItemId,
                                  item.quantity + 1,
                                );
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        Text(
                          formatCurrency(item.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
              Text(formatCurrency(subtotal)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax (${settings.taxRate.toStringAsFixed(1)}%):', style: TextStyle(color: Colors.grey[600])),
              Text(formatCurrency(tax)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localizations.get('total')}:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatCurrency(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9933),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPlaceOrderDialog(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                localizations.get('place_order'),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceOrderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PlaceOrderDialog(localizations: localizations),
    );
  }
}

// Place Order Dialog
class PlaceOrderDialog extends ConsumerStatefulWidget {
  final AppLocalizations localizations;

  const PlaceOrderDialog({super.key, required this.localizations});

  @override
  ConsumerState<PlaceOrderDialog> createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends ConsumerState<PlaceOrderDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    final subtotal = currentOrderNotifier.total;
    final tax = subtotal * (settings.taxRate / 100);
    final total = subtotal + tax;

    return AlertDialog(
      title: Text(widget.localizations.get('place_order')),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: widget.localizations.get('customer_name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: widget.localizations.get('customer_phone'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            if (currentOrderNotifier.currentOrderType == OrderType.delivery) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: widget.localizations.get('customer_address'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
                      Text(formatCurrency(subtotal)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax:', style: TextStyle(color: Colors.grey[600])),
                      Text(formatCurrency(tax)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(total),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9933),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.localizations.get('cancel')),
        ),
        ElevatedButton(
          onPressed: () => _placeOrder(context, ref, subtotal, tax, total),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
          ),
          child: Text(widget.localizations.get('confirm')),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context, WidgetRef ref, double subtotal, double tax, double total) {
    final currentOrder = ref.read(currentOrderProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);
    
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.localizations.get('customer_name_required')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final order = Order(
      id: generateOrderId(),
      orderNumber: generateOrderNumber(),
      createdAt: DateTime.now(),
      items: currentOrder,
      status: OrderStatus.pending,
      orderType: currentOrderNotifier.currentOrderType,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      customerAddress: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      subtotal: subtotal,
      tax: tax,
      total: total,
    );

    ref.read(ordersProvider.notifier).addOrder(order);
    currentOrderNotifier.clearOrder();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.localizations.get('order_placed')),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

// Orders Screen
class OrdersScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const OrdersScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('orders')),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No orders yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatOrderNumber(order.orderNumber),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                getStatusText(order.status),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.customerName ?? 'Walk-in Customer',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${localizations.get(order.orderType.name)} • ${DateFormat('HH:mm').format(order.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.name}'),
                              Text(formatCurrency(item.total)),
                            ],
                          ),
                        )),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(order.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF9933),
                              ),
                            ),
                          ],
                        ),
                        if (order.status == OrderStatus.pending) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(ordersProvider.notifier).updateOrderStatus(
                                      order.id,
                                      OrderStatus.preparing,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Start Preparing'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(ordersProvider.notifier).updateOrderStatus(
                                      order.id,
                                      OrderStatus.cancelled,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (order.status == OrderStatus.preparing) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(ordersProvider.notifier).updateOrderStatus(
                                  order.id,
                                  OrderStatus.ready,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9933),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Mark Ready'),
                            ),
                          ),
                        ],
                        if (order.status == OrderStatus.ready) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(ordersProvider.notifier).updateOrderStatus(
                                  order.id,
                                  OrderStatus.completed,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Complete Order'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return const Color(0xFFFF9933);
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Reports Screen
class ReportsScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const ReportsScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final today = DateTime.now();
    final todayOrders = orders.where((order) {
      return order.createdAt.year == today.year &&
             order.createdAt.month == today.month &&
             order.createdAt.day == today.day;
    }).toList();

    final totalRevenue = todayOrders.fold(0.0, (sum, order) => sum + order.total);
    final completedOrders = todayOrders.where((order) => order.status == OrderStatus.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('reports')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Summary',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            size: 32,
                            color: Color(0xFFFF9933),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${todayOrders.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Total Orders'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 32,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completedOrders',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Completed'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 32,
                      color: Color(0xFFFF9933),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatCurrency(totalRevenue),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Revenue'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const SettingsScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.get('store_settings'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('${localizations.get('store_name')}: ${settings.storeName}'),
                  const SizedBox(height: 8),
                  Text('${localizations.get('store_address')}: ${settings.storeAddress.isEmpty ? 'Not set' : settings.storeAddress}'),
                  const SizedBox(height: 8),
                  Text('${localizations.get('store_phone')}: ${settings.storePhone.isEmpty ? 'Not set' : settings.storePhone}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.get('enable_dine_in'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            localizations.get('dine_in_feature_subtitle'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: settings.dineInEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).toggleDineInEnabled();
                        },
                        activeColor: const Color(0xFFFF9933),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.get('language'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<AppLanguage>(
                          segments: [
                            ButtonSegment(
                              value: AppLanguage.english,
                              label: Text(localizations.get('english')),
                            ),
                            ButtonSegment(
                              value: AppLanguage.hindi,
                              label: Text(localizations.get('hindi')),
                            ),
                          ],
                          selected: {language},
                          onSelectionChanged: (Set<AppLanguage> newSelection) {
                            ref.read(languageProvider.notifier).setLanguage(newSelection.first);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

final languageProvider = StateNotifierProvider<LanguageNotifier, AppLanguage>(
  (ref) => LanguageNotifier(),
);

class AppLocalizations {
  final AppLanguage language;
  AppLocalizations(this.language);

  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'QSR Restaurant App',
      'home': 'Home',
      'menu': 'Menu',
      'orders': 'Orders',
      'reports': 'Reports',
      'settings': 'Settings',
      'search': 'Search',
      'add_to_order': 'Add to Order',
      'current_order': 'Current Order',
      'place_order': 'Place Order',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'total': 'Total',
      'quantity': 'Quantity',
      'item_added': 'Item added to order',
      'order_placed': 'Order placed successfully!',
      'dine_in': 'Dine In',
      'takeaway': 'Takeaway',
      'delivery': 'Delivery',
      'order_type': 'Order Type',
      'customer_name_required': 'Customer name is required',
      'customer_name': 'Customer Name',
      'customer_phone': 'Customer Phone',
      'customer_address': 'Customer Address',
      'enable_dine_in': 'Enable Dine-In',
      'dine_in_feature_subtitle': 'Enable dine-in ordering',
      'store_settings': 'Store Settings',
      'store_name': 'Store Name',
      'store_address': 'Store Address', 
      'store_phone': 'Store Phone',
      'language': 'Language',
      'english': 'English',
      'hindi': 'हिंदी',
    },
    'hi': {
      'app_title': 'QSR रेस्टोरेंट ऐप',
      'home': 'होम',
      'menu': 'मेन्यू',
      'orders': 'ऑर्डर',
      'reports': 'रिपोर्ट',
      'settings': 'सेटिंग्स',
      'search': 'खोजें',
      'add_to_order': 'ऑर्डर में जोड़ें',
      'current_order': 'वर्तमान ऑर्डर',
      'place_order': 'ऑर्डर करें',
      'cancel': 'रद्द करें',
      'confirm': 'पुष्टि करें',
      'total': 'कुल',
      'quantity': 'मात्रा',
      'item_added': 'आइटम ऑर्डर में जोड़ा गया',
      'order_placed': 'ऑर्डर सफलतापूर्वक दिया गया!',
      'dine_in': 'रेस्टोरेंट में खाना',
      'takeaway': 'पैकिंग',
      'delivery': 'डिलीवरी',
      'order_type': 'ऑर्डर का प्रकार',
      'customer_name_required': 'ग्राहक का नाम आवश्यक है',
      'customer_name': 'ग्राहक का नाम',
      'customer_phone': 'ग्राहक का फोन',
      'customer_address': 'ग्राहक का पता',
      'enable_dine_in': 'डाइन-इन सक्षम करें',
      'dine_in_feature_subtitle': 'डाइन-इन ऑर्डरिंग सक्षम करें',
      'store_settings': 'स्टोर सेटिंग्स',
      'store_name': 'स्टोर का नाम',
      'store_address': 'स्टोर का पता',
      'store_phone': 'स्टोर का फोन',
      'language': 'भाषा',
      'english': 'English',
      'hindi': 'हिंदी',
    },
  };

  String get(String key) {
    final langCode = language == AppLanguage.hindi ? 'hi' : 'en';
    return _localizedValues[langCode]?[key] ?? key;
  }
}

// Models
class MenuItemPricing {
  final double dineInPrice;
  final double takeawayPrice;
  final double deliveryPrice;

  MenuItemPricing({
    required this.dineInPrice,
    required this.takeawayPrice,
    required this.deliveryPrice,
  });

  double getPriceForOrderType(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        return dineInPrice;
      case OrderType.takeaway:
        return takeawayPrice;
      case OrderType.delivery:
        return deliveryPrice;
    }
  }
}

class MenuItem {
  final String id;
  final String name;
  final MenuItemPricing pricing;
  final String category;
  final String? description;
  final bool isAvailable;
  final List<OrderType> availableForOrderTypes;

  MenuItem({
    required this.id,
    required this.name,
    required this.pricing,
    required this.category,
    this.description,
    this.isAvailable = true,
    this.availableForOrderTypes = const [OrderType.dineIn, OrderType.takeaway, OrderType.delivery],
  });

  bool isAvailableForOrderType(OrderType orderType) {
    return isAvailable && availableForOrderTypes.contains(orderType);
  }

  double getPriceForOrderType(OrderType orderType) {
    return pricing.getPriceForOrderType(orderType);
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String? specialInstructions;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.specialInstructions,
  });

  double get total => price * quantity;

  Map<String, dynamic> toJson() => {
    'menuItemId': menuItemId,
    'name': name,
    'price': price,
    'quantity': quantity,
    'specialInstructions': specialInstructions,
  };

  factory OrderItem.fromJson(Map<String, dynamic> json) => OrderItem(
    menuItemId: json['menuItemId'],
    name: json['name'],
    price: json['price'].toDouble(),
    quantity: json['quantity'],
    specialInstructions: json['specialInstructions'],
  );

  OrderItem copyWith({
    int? quantity,
    String? specialInstructions,
  }) => OrderItem(
    menuItemId: menuItemId,
    name: name,
    price: price,
    quantity: quantity ?? this.quantity,
    specialInstructions: specialInstructions ?? this.specialInstructions,
  );
}

enum OrderStatus { pending, preparing, ready, completed, cancelled }
enum OrderType { dineIn, takeaway, delivery }

class Order {
  final String id;
  final String orderNumber;
  final DateTime createdAt;
  final List<OrderItem> items;
  final OrderStatus status;
  final OrderType orderType;
  final String? customerName;
  final String? customerPhone;
  final String? customerAddress;
  final double subtotal;
  final double tax;
  final double total;

  Order({
    required this.id,
    required this.orderNumber,
    required this.createdAt,
    required this.items,
    required this.status,
    required this.orderType,
    this.customerName,
    this.customerPhone,
    this.customerAddress,
    required this.subtotal,
    required this.tax,
    required this.total,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderNumber': orderNumber,
    'createdAt': createdAt.toIso8601String(),
    'items': items.map((item) => item.toJson()).toList(),
    'status': status.name,
    'orderType': orderType.name,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'customerAddress': customerAddress,
    'subtotal': subtotal,
    'tax': tax,
    'total': total,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    orderNumber: json['orderNumber'],
    createdAt: DateTime.parse(json['createdAt']),
    items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
    status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
    orderType: OrderType.values.firstWhere((e) => e.name == json['orderType']),
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    customerAddress: json['customerAddress'],
    subtotal: json['subtotal'].toDouble(),
    tax: json['tax'].toDouble(),
    total: json['total'].toDouble(),
  );
}

// Settings Model
class AppSettings {
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final double taxRate;
  final bool dineInEnabled;

  AppSettings({
    required this.storeName,
    required this.storeAddress,
    required this.storePhone,
    required this.taxRate,
    required this.dineInEnabled,
  });

  Map<String, dynamic> toJson() => {
    'storeName': storeName,
    'storeAddress': storeAddress,
    'storePhone': storePhone,
    'taxRate': taxRate,
    'dineInEnabled': dineInEnabled,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    storeName: json['storeName'] ?? 'QSR Restaurant',
    storeAddress: json['storeAddress'] ?? '',
    storePhone: json['storePhone'] ?? '',
    taxRate: (json['taxRate'] ?? 18.0).toDouble(),
    dineInEnabled: json['dineInEnabled'] ?? false,
  );

  AppSettings copyWith({
    String? storeName,
    String? storeAddress,
    String? storePhone,
    double? taxRate,
    bool? dineInEnabled,
  }) => AppSettings(
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress ?? this.storeAddress,
    storePhone: storePhone ?? this.storePhone,
    taxRate: taxRate ?? this.taxRate,
    dineInEnabled: dineInEnabled ?? this.dineInEnabled,
  );
}

// Providers
final menuProvider = StateNotifierProvider<MenuNotifier, List<MenuItem>>((ref) {
  return MenuNotifier();
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

final currentOrderProvider = StateNotifierProvider<CurrentOrderNotifier, List<OrderItem>>((ref) {
  return CurrentOrderNotifier();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

// State Notifiers
class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super([]) {
    _loadDefaultMenu();
  }

  void _loadDefaultMenu() {
    state = [
      MenuItem(
        id: '1', 
        name: 'Samosa', 
        pricing: MenuItemPricing(dineInPrice: 25.0, takeawayPrice: 20.0, deliveryPrice: 30.0), 
        category: 'Snacks', 
        description: 'Crispy fried pastry with spiced filling'
      ),
      MenuItem(
        id: '2', 
        name: 'Vada Pav', 
        pricing: MenuItemPricing(dineInPrice: 35.0, takeawayPrice: 30.0, deliveryPrice: 40.0), 
        category: 'Snacks', 
        description: 'Mumbai street food with spiced potato fritter'
      ),
      MenuItem(
        id: '3', 
        name: 'Masala Chai', 
        pricing: MenuItemPricing(dineInPrice: 15.0, takeawayPrice: 12.0, deliveryPrice: 18.0), 
        category: 'Beverages', 
        description: 'Traditional Indian spiced tea'
      ),
      MenuItem(
        id: '4', 
        name: 'Butter Chicken', 
        pricing: MenuItemPricing(dineInPrice: 280.0, takeawayPrice: 260.0, deliveryPrice: 300.0), 
        category: 'Main Course', 
        description: 'Creamy tomato-based chicken curry'
      ),
    ];
  }

  void addMenuItem(MenuItem item) {
    state = [...state, item];
  }

  void updateMenuItem(MenuItem updatedItem) {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
  }

  void removeMenuItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  void addOrder(Order order) {
    state = [order, ...state];
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = [
      for (final order in state)
        if (order.id == orderId)
          Order(
            id: order.id,
            orderNumber: order.orderNumber,
            createdAt: order.createdAt,
            items: order.items,
            status: status,
            orderType: order.orderType,
            customerName: order.customerName,
            customerPhone: order.customerPhone,
            customerAddress: order.customerAddress,
            subtotal: order.subtotal,
            tax: order.tax,
            total: order.total,
          )
        else order,
    ];
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]);

  OrderType currentOrderType = OrderType.takeaway;

  void addItem(OrderItem item) {
    final existingIndex = state.indexWhere((orderItem) => orderItem.menuItemId == item.menuItemId);
    
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(quantity: existingItem.quantity + item.quantity);
      state = [
        ...state.sublist(0, existingIndex),
        updatedItem,
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [...state, item];
    }
  }

  void updateItem(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }

    state = [
      for (final item in state)
        if (item.menuItemId == menuItemId)
          item.copyWith(quantity: quantity)
        else item,
    ];
  }

  void removeItem(String menuItemId) {
    state = state.where((item) => item.menuItemId != menuItemId).toList();
  }

  void clearOrder() {
    state = [];
  }

  void setOrderType(OrderType orderType) {
    currentOrderType = orderType;
  }

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  double get total => state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings(
    storeName: 'QSR Restaurant',
    storeAddress: '',
    storePhone: '',
    taxRate: 18.0,
    dineInEnabled: false,
  )) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('app_settings');
    
    if (settingsJson != null) {
      final settingsMap = jsonDecode(settingsJson);
      state = AppSettings.fromJson(settingsMap);
    }
  }

  Future<void> updateSettings(AppSettings settings) async {
    state = settings;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('app_settings', jsonEncode(settings.toJson()));
  }

  Future<void> toggleDineInEnabled() async {
    final updatedSettings = state.copyWith(dineInEnabled: !state.dineInEnabled);
    await updateSettings(updatedSettings);
  }
}

// Utility Functions
String formatCurrency(double amount) {
  return '₹${amount.toStringAsFixed(2)}';
}

String formatOrderNumber(String orderNumber) {
  return '#$orderNumber';
}

String getStatusText(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return 'Pending';
    case OrderStatus.preparing:
      return 'Preparing';
    case OrderStatus.ready:
      return 'Ready';
    case OrderStatus.completed:
      return 'Completed';
    case OrderStatus.cancelled:
      return 'Cancelled';
  }
}

// Main App
class QSRApp extends ConsumerWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);

    return MaterialApp(
      title: localizations.get('app_title'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9933),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9933),
          foregroundColor: Colors.white,
          elevation: 2,
        ),
      ),
      home: HomeScreen(localizations: localizations),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Home Screen
class HomeScreen extends ConsumerStatefulWidget {
  final AppLocalizations localizations;

  const HomeScreen({super.key, required this.localizations});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final screens = [
      MenuScreen(localizations: widget.localizations),
      OrdersScreen(localizations: widget.localizations),
      ReportsScreen(localizations: widget.localizations),
      SettingsScreen(localizations: widget.localizations),
    ];

    return Scaffold(
      body: screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9933),
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: widget.localizations.get('menu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long),
            label: widget.localizations.get('orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.analytics),
            label: widget.localizations.get('reports'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: widget.localizations.get('settings'),
          ),
        ],
      ),
    );
  }
}

// Menu Screen
class MenuScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const MenuScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menu = ref.watch(menuProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('menu')),
        actions: [
          if (currentOrder.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _showCurrentOrder(context, ref),
                ),
                Positioned(
                  right: 6,
                  top: 6,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 16,
                      minHeight: 16,
                    ),
                    child: Text(
                      '${currentOrderNotifier.totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Order Type Selection (if dine-in enabled)
          if (settings.dineInEnabled)
            Container(
              margin: const EdgeInsets.all(16),
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        localizations.get('order_type'),
                        style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: SegmentedButton<OrderType>(
                              segments: [
                                ButtonSegment(
                                  value: OrderType.dineIn,
                                  label: Text(localizations.get('dine_in')),
                                ),
                                ButtonSegment(
                                  value: OrderType.takeaway,
                                  label: Text(localizations.get('takeaway')),
                                ),
                                ButtonSegment(
                                  value: OrderType.delivery,
                                  label: Text(localizations.get('delivery')),
                                ),
                              ],
                              selected: {currentOrderNotifier.currentOrderType},
                              onSelectionChanged: (Set<OrderType> newSelection) {
                                currentOrderNotifier.setOrderType(newSelection.first);
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: menu.length,
              itemBuilder: (context, index) {
                final item = menu[index];
                final price = item.getPriceForOrderType(currentOrderNotifier.currentOrderType);
                
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (item.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 14,
                                  ),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Text(
                                formatCurrency(price),
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFFFF9933),
                                ),
                              ),
                            ],
                          ),
                        ),
                        ElevatedButton(
                          onPressed: item.isAvailableForOrderType(currentOrderNotifier.currentOrderType)
                              ? () => _addToOrder(context, ref, item, price)
                              : null,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9933),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: Text(localizations.get('add_to_order')),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _addToOrder(BuildContext context, WidgetRef ref, MenuItem item, double price) {
    final orderItem = OrderItem(
      menuItemId: item.id,
      name: item.name,
      price: price,
      quantity: 1,
    );
    
    ref.read(currentOrderProvider.notifier).addItem(orderItem);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(localizations.get('item_added')),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  void _showCurrentOrder(BuildContext context, WidgetRef ref) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => CurrentOrderSheet(localizations: localizations),
    );
  }
}

// Current Order Sheet
class CurrentOrderSheet extends ConsumerWidget {
  final AppLocalizations localizations;

  const CurrentOrderSheet({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    if (currentOrder.isEmpty) {
      return Container(
        height: 200,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: Text(
            'No items in order',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 16,
            ),
          ),
        ),
      );
    }

    final subtotal = currentOrderNotifier.total;
    final tax = subtotal * (settings.taxRate / 100);
    final total = subtotal + tax;

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            localizations.get('current_order'),
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: currentOrder.length,
              itemBuilder: (context, index) {
                final item = currentOrder[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              Text(
                                '${formatCurrency(item.price)} x ${item.quantity}',
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                if (item.quantity > 1) {
                                  currentOrderNotifier.updateItem(
                                    item.menuItemId,
                                    item.quantity - 1,
                                  );
                                } else {
                                  currentOrderNotifier.removeItem(item.menuItemId);
                                }
                              },
                              icon: const Icon(Icons.remove_circle_outline),
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              onPressed: () {
                                currentOrderNotifier.updateItem(
                                  item.menuItemId,
                                  item.quantity + 1,
                                );
                              },
                              icon: const Icon(Icons.add_circle_outline),
                            ),
                          ],
                        ),
                        Text(
                          formatCurrency(item.total),
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const Divider(),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
              Text(formatCurrency(subtotal)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tax (${settings.taxRate.toStringAsFixed(1)}%):', style: TextStyle(color: Colors.grey[600])),
              Text(formatCurrency(tax)),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${localizations.get('total')}:',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                formatCurrency(total),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFFF9933),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _showPlaceOrderDialog(context, ref);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                localizations.get('place_order'),
                style: const TextStyle(fontSize: 16),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showPlaceOrderDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => PlaceOrderDialog(localizations: localizations),
    );
  }
}

// Place Order Dialog
class PlaceOrderDialog extends ConsumerStatefulWidget {
  final AppLocalizations localizations;

  const PlaceOrderDialog({super.key, required this.localizations});

  @override
  ConsumerState<PlaceOrderDialog> createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends ConsumerState<PlaceOrderDialog> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);

    final subtotal = currentOrderNotifier.total;
    final tax = subtotal * (settings.taxRate / 100);
    final total = subtotal + tax;

    return AlertDialog(
      title: Text(widget.localizations.get('place_order')),
      content: SizedBox(
        width: double.maxFinite,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: widget.localizations.get('customer_name'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: widget.localizations.get('customer_phone'),
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.phone,
            ),
            if (currentOrderNotifier.currentOrderType == OrderType.delivery) ...[
              const SizedBox(height: 16),
              TextField(
                controller: _addressController,
                decoration: InputDecoration(
                  labelText: widget.localizations.get('customer_address'),
                  border: const OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Subtotal:', style: TextStyle(color: Colors.grey[600])),
                      Text(formatCurrency(subtotal)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Tax:', style: TextStyle(color: Colors.grey[600])),
                      Text(formatCurrency(tax)),
                    ],
                  ),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total:',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        formatCurrency(total),
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFFF9933),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(widget.localizations.get('cancel')),
        ),
        ElevatedButton(
          onPressed: () => _placeOrder(context, ref, subtotal, tax, total),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
          ),
          child: Text(widget.localizations.get('confirm')),
        ),
      ],
    );
  }

  void _placeOrder(BuildContext context, WidgetRef ref, double subtotal, double tax, double total) {
    final currentOrder = ref.read(currentOrderProvider);
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);
    
    if (_nameController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.localizations.get('customer_name_required')),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final order = Order(
      id: const Uuid().v4(),
      orderNumber: DateTime.now().millisecondsSinceEpoch.toString().substring(8),
      createdAt: DateTime.now(),
      items: currentOrder,
      status: OrderStatus.pending,
      orderType: currentOrderNotifier.currentOrderType,
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim().isEmpty ? null : _phoneController.text.trim(),
      customerAddress: _addressController.text.trim().isEmpty ? null : _addressController.text.trim(),
      subtotal: subtotal,
      tax: tax,
      total: total,
    );

    ref.read(ordersProvider.notifier).addOrder(order);
    currentOrderNotifier.clearOrder();

    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.localizations.get('order_placed')),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }
}

// Orders Screen
class OrdersScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const OrdersScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('orders')),
      ),
      body: orders.isEmpty
          ? Center(
              child: Text(
                'No orders yet',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 16,
                ),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  elevation: 2,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              formatOrderNumber(order.orderNumber),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                              decoration: BoxDecoration(
                                color: _getStatusColor(order.status),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Text(
                                getStatusText(order.status),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.customerName ?? 'Walk-in Customer',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          '${localizations.get(order.orderType.name)} • ${DateFormat('HH:mm').format(order.createdAt)}',
                          style: TextStyle(
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 12),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('${item.quantity}x ${item.name}'),
                              Text(formatCurrency(item.total)),
                            ],
                          ),
                        )),
                        const Divider(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total:',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              formatCurrency(order.total),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFFF9933),
                              ),
                            ),
                          ],
                        ),
                        if (order.status == OrderStatus.pending) ...[
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(ordersProvider.notifier).updateOrderStatus(
                                      order.id,
                                      OrderStatus.preparing,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.orange,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Start Preparing'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: () {
                                    ref.read(ordersProvider.notifier).updateOrderStatus(
                                      order.id,
                                      OrderStatus.cancelled,
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Cancel'),
                                ),
                              ),
                            ],
                          ),
                        ],
                        if (order.status == OrderStatus.preparing) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(ordersProvider.notifier).updateOrderStatus(
                                  order.id,
                                  OrderStatus.ready,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9933),
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Mark Ready'),
                            ),
                          ),
                        ],
                        if (order.status == OrderStatus.ready) ...[
                          const SizedBox(height: 12),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                ref.read(ordersProvider.notifier).updateOrderStatus(
                                  order.id,
                                  OrderStatus.completed,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Complete Order'),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.orange;
      case OrderStatus.ready:
        return const Color(0xFFFF9933);
      case OrderStatus.completed:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }
}

// Reports Screen
class ReportsScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const ReportsScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final today = DateTime.now();
    final todayOrders = orders.where((order) {
      return order.createdAt.year == today.year &&
             order.createdAt.month == today.month &&
             order.createdAt.day == today.day;
    }).toList();

    final totalRevenue = todayOrders.fold(0.0, (sum, order) => sum + order.total);
    final completedOrders = todayOrders.where((order) => order.status == OrderStatus.completed).length;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('reports')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Today\'s Summary',
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.receipt_long,
                            size: 32,
                            color: Color(0xFFFF9933),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${todayOrders.length}',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Total Orders'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    elevation: 2,
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 32,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '$completedOrders',
                            style: const TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Text('Completed'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    const Icon(
                      Icons.currency_rupee,
                      size: 32,
                      color: Color(0xFFFF9933),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          formatCurrency(totalRevenue),
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const Text('Total Revenue'),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  final AppLocalizations localizations;

  const SettingsScreen({super.key, required this.localizations});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.get('store_settings'),
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text('${localizations.get('store_name')}: ${settings.storeName}'),
                  const SizedBox(height: 8),
                  Text('${localizations.get('store_address')}: ${settings.storeAddress.isEmpty ? 'Not set' : settings.storeAddress}'),
                  const SizedBox(height: 8),
                  Text('${localizations.get('store_phone')}: ${settings.storePhone.isEmpty ? 'Not set' : settings.storePhone}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            localizations.get('enable_dine_in'),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            localizations.get('dine_in_feature_subtitle'),
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                      Switch(
                        value: settings.dineInEnabled,
                        onChanged: (value) {
                          ref.read(settingsProvider.notifier).toggleDineInEnabled();
                        },
                        activeColor: const Color(0xFFFF9933),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            elevation: 2,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    localizations.get('language'),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: SegmentedButton<AppLanguage>(
                          segments: [
                            ButtonSegment(
                              value: AppLanguage.english,
                              label: Text(localizations.get('english')),
                            ),
                            ButtonSegment(
                              value: AppLanguage.hindi,
                              label: Text(localizations.get('hindi')),
                            ),
                          ],
                          selected: {language},
                          onSelectionChanged: (Set<AppLanguage> newSelection) {
                            ref.read(languageProvider.notifier).setLanguage(newSelection.first);
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}
