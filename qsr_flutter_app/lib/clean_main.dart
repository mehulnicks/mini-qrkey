import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

// App Root with Indian Theme
class QSRApp extends StatelessWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'भारतीय QSR ऐप',
      locale: const Locale('en', 'IN'),
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9933), // Saffron color from Indian flag
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFF9933),
          foregroundColor: Colors.white,
        ),
        useMaterial3: true,
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main Navigation Screen
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const OrdersScreen(),
    const MenuScreen(),
    const ReportsScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: const Color(0xFFFF9933),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: 'ऑर्डर्स',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.restaurant_menu),
            label: 'मेन्यू',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'रिपोर्ट्स',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'सेटिंग्स',
          ),
        ],
      ),
    );
  }
}

// Data Models
class MenuItem {
  final String id;
  final String name;
  final String description;
  final double price;
  final double costPrice;
  final String category;
  final bool isAvailable;
  final int stockQuantity;

  MenuItem({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.costPrice,
    required this.category,
    this.isAvailable = true,
    this.stockQuantity = 0,
  });

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      price: json['price'].toDouble(),
      costPrice: json['costPrice'].toDouble(),
      category: json['category'],
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'costPrice': costPrice,
      'category': category,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
    };
  }

  MenuItem copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    double? costPrice,
    String? category,
    bool? isAvailable,
    int? stockQuantity,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      costPrice: costPrice ?? this.costPrice,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
    );
  }
}

class OrderItem {
  final String menuItemId;
  final String name;
  final double price;
  final int quantity;
  final String notes;

  OrderItem({
    required this.menuItemId,
    required this.name,
    required this.price,
    required this.quantity,
    this.notes = '',
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItemId: json['menuItemId'],
      name: json['name'],
      price: json['price'].toDouble(),
      quantity: json['quantity'],
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItemId': menuItemId,
      'name': name,
      'price': price,
      'quantity': quantity,
      'notes': notes,
    };
  }

  double get total => price * quantity;
}

enum OrderStatus { pending, preparing, ready, delivered, cancelled }

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime createdAt;
  final OrderStatus status;
  final double subtotal;
  final double tax;
  final double total;
  final String customerName;
  final String customerPhone;
  final String notes;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.status,
    required this.subtotal,
    required this.tax,
    required this.total,
    this.customerName = '',
    this.customerPhone = '',
    this.notes = '',
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      status: OrderStatus.values[json['status']],
      subtotal: json['subtotal'].toDouble(),
      tax: json['tax'].toDouble(),
      total: json['total'].toDouble(),
      customerName: json['customerName'] ?? '',
      customerPhone: json['customerPhone'] ?? '',
      notes: json['notes'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'status': status.index,
      'subtotal': subtotal,
      'tax': tax,
      'total': total,
      'customerName': customerName,
      'customerPhone': customerPhone,
      'notes': notes,
    };
  }
}

class AppSettings {
  final String currency;
  final double taxRate;
  final String phoneFormat;
  final String language;

  AppSettings({
    this.currency = '₹',
    this.taxRate = 0.18, // 18% GST for India
    this.phoneFormat = '+91',
    this.language = 'hi',
  });

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      currency: json['currency'] ?? '₹',
      taxRate: json['taxRate']?.toDouble() ?? 0.18,
      phoneFormat: json['phoneFormat'] ?? '+91',
      language: json['language'] ?? 'hi',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currency': currency,
      'taxRate': taxRate,
      'phoneFormat': phoneFormat,
      'language': language,
    };
  }
}

// Storage Service
class StorageService {
  static const String menuKey = 'menu_items';
  static const String ordersKey = 'orders';
  static const String settingsKey = 'app_settings';

  static Future<List<MenuItem>> loadMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(menuKey);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((item) => MenuItem.fromJson(item)).toList();
    }
    return _getDefaultMenuItems();
  }

  static Future<void> saveMenuItems(List<MenuItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(menuKey, data);
  }

  static Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(ordersKey);
    if (data != null) {
      final List<dynamic> jsonList = json.decode(data);
      return jsonList.map((order) => Order.fromJson(order)).toList();
    }
    return [];
  }

  static Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(orders.map((order) => order.toJson()).toList());
    await prefs.setString(ordersKey, data);
  }

  static Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(settingsKey);
    if (data != null) {
      return AppSettings.fromJson(json.decode(data));
    }
    return AppSettings();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final data = json.encode(settings.toJson());
    await prefs.setString(settingsKey, data);
  }

  // Default Indian menu items
  static List<MenuItem> _getDefaultMenuItems() {
    return [
      MenuItem(
        id: '1',
        name: 'Butter Chicken',
        description: 'Creamy tomato-based curry with tender chicken pieces',
        price: 280.0,
        costPrice: 150.0,
        category: 'Main',
        stockQuantity: 25,
      ),
      MenuItem(
        id: '2',
        name: 'Chicken Biryani',
        description: 'Aromatic basmati rice with spiced chicken',
        price: 320.0,
        costPrice: 180.0,
        category: 'Main',
        stockQuantity: 20,
      ),
      MenuItem(
        id: '3',
        name: 'Paneer Tikka',
        description: 'Grilled cottage cheese with Indian spices',
        price: 240.0,
        costPrice: 120.0,
        category: 'Main',
        stockQuantity: 30,
      ),
      MenuItem(
        id: '4',
        name: 'Dal Makhani',
        description: 'Rich black lentils cooked in butter and cream',
        price: 180.0,
        costPrice: 80.0,
        category: 'Main',
        stockQuantity: 40,
      ),
      MenuItem(
        id: '5',
        name: 'Masala Chai',
        description: 'Traditional Indian spiced tea',
        price: 25.0,
        costPrice: 8.0,
        category: 'Drinks',
        stockQuantity: 100,
      ),
      MenuItem(
        id: '6',
        name: 'Sweet Lassi',
        description: 'Refreshing yogurt-based drink',
        price: 60.0,
        costPrice: 25.0,
        category: 'Drinks',
        stockQuantity: 50,
      ),
      MenuItem(
        id: '7',
        name: 'Garlic Naan',
        description: 'Soft bread with garlic and herbs',
        price: 45.0,
        costPrice: 15.0,
        category: 'Sides',
        stockQuantity: 60,
      ),
      MenuItem(
        id: '8',
        name: 'Samosa',
        description: 'Crispy pastry with spiced potato filling',
        price: 20.0,
        costPrice: 8.0,
        category: 'Sides',
        stockQuantity: 80,
      ),
      MenuItem(
        id: '9',
        name: 'Gulab Jamun',
        description: 'Sweet milk dumplings in sugar syrup',
        price: 80.0,
        costPrice: 30.0,
        category: 'Desserts',
        stockQuantity: 35,
      ),
    ];
  }
}

// State Management
final menuNotifierProvider = StateNotifierProvider<MenuNotifier, List<MenuItem>>((ref) {
  return MenuNotifier();
});

final currentOrderProvider = StateNotifierProvider<CurrentOrderNotifier, List<OrderItem>>((ref) {
  return CurrentOrderNotifier();
});

final ordersNotifierProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

final settingsNotifierProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super([]) {
    _loadItems();
  }

  Future<void> _loadItems() async {
    state = await StorageService.loadMenuItems();
  }

  void addItem(MenuItem item) {
    state = [...state, item];
    StorageService.saveMenuItems(state);
  }

  void updateItem(MenuItem updatedItem) {
    state = state.map((item) => item.id == updatedItem.id ? updatedItem : item).toList();
    StorageService.saveMenuItems(state);
  }

  void removeItem(String id) {
    state = state.where((item) => item.id != id).toList();
    StorageService.saveMenuItems(state);
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]);

  void addItem(OrderItem item) {
    final existingIndex = state.indexWhere((existing) => existing.menuItemId == item.menuItemId);
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      final updatedItem = OrderItem(
        menuItemId: item.menuItemId,
        name: item.name,
        price: item.price,
        quantity: existingItem.quantity + item.quantity,
        notes: item.notes.isNotEmpty ? item.notes : existingItem.notes,
      );
      state = [...state.sublist(0, existingIndex), updatedItem, ...state.sublist(existingIndex + 1)];
    } else {
      state = [...state, item];
    }
  }

  void updateQuantity(String menuItemId, int quantity) {
    if (quantity <= 0) {
      removeItem(menuItemId);
      return;
    }
    state = state.map((item) {
      if (item.menuItemId == menuItemId) {
        return OrderItem(
          menuItemId: item.menuItemId,
          name: item.name,
          price: item.price,
          quantity: quantity,
          notes: item.notes,
        );
      }
      return item;
    }).toList();
  }

  void removeItem(String menuItemId) {
    state = state.where((item) => item.menuItemId != menuItemId).toList();
  }

  void clearOrder() {
    state = [];
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    state = await StorageService.loadOrders();
  }

  void addOrder(Order order) {
    state = [order, ...state];
    StorageService.saveOrders(state);
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = state.map((order) {
      if (order.id == orderId) {
        return Order(
          id: order.id,
          items: order.items,
          createdAt: order.createdAt,
          status: status,
          subtotal: order.subtotal,
          tax: order.tax,
          total: order.total,
          customerName: order.customerName,
          customerPhone: order.customerPhone,
          notes: order.notes,
        );
      }
      return order;
    }).toList();
    StorageService.saveOrders(state);
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await StorageService.loadSettings();
  }

  void updateSettings(AppSettings settings) {
    state = settings;
    StorageService.saveSettings(settings);
  }
}

// Orders Screen
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('नया ऑर्डर'),
        actions: [
          if (currentOrder.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear_all),
              onPressed: () => ref.read(currentOrderProvider.notifier).clearOrder(),
            ),
        ],
      ),
      body: Column(
        children: [
          // Order Summary
          if (currentOrder.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Current Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 8),
                  ...currentOrder.map((item) => Padding(
                    padding: const EdgeInsets.symmetric(vertical: 2),
                    child: Row(
                      children: [
                        Expanded(child: Text('${item.name} x${item.quantity}')),
                        Text('${settings.currency}${item.total.toStringAsFixed(2)}'),
                        IconButton(
                          icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                          onPressed: () => ref.read(currentOrderProvider.notifier).removeItem(item.menuItemId),
                        ),
                      ],
                    ),
                  )),
                  const Divider(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Subtotal:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text('${settings.currency}${ref.read(currentOrderProvider.notifier).subtotal.toStringAsFixed(2)}',
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('GST (18%):'),
                      Text('${settings.currency}${(ref.read(currentOrderProvider.notifier).subtotal * settings.taxRate).toStringAsFixed(2)}'),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      Text('${settings.currency}${(ref.read(currentOrderProvider.notifier).subtotal * (1 + settings.taxRate)).toStringAsFixed(2)}',
                           style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => _processOrder(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                  ),
                  child: const Text('Place Order'),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
          // Menu Items
          Expanded(
            child: _buildMenuList(),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList() {
    final menuItems = ref.watch(menuNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);

    if (menuItems.isEmpty) {
      return const Center(child: Text('No menu items available'));
    }

    return ListView.builder(
      itemCount: menuItems.length,
      itemBuilder: (context, index) {
        final item = menuItems[index];
        return Card(
          margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          child: ListTile(
            title: Text(item.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.description.isNotEmpty) Text(item.description),
                Text('${settings.currency}${item.price.toStringAsFixed(2)}',
                     style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
              ],
            ),
            trailing: item.isAvailable
                ? ElevatedButton(
                    onPressed: () => _addToOrder(item),
                    child: const Text('Add'),
                  )
                : const Text('Out of Stock', style: TextStyle(color: Colors.red)),
          ),
        );
      },
    );
  }

  void _addToOrder(MenuItem item) {
    final orderItem = OrderItem(
      menuItemId: item.id,
      name: item.name,
      price: item.price,
      quantity: 1,
    );
    ref.read(currentOrderProvider.notifier).addItem(orderItem);
  }

  void _processOrder() {
    final currentOrder = ref.read(currentOrderProvider);
    final settings = ref.read(settingsNotifierProvider);
    
    if (currentOrder.isEmpty) return;

    final subtotal = ref.read(currentOrderProvider.notifier).subtotal;
    final tax = subtotal * settings.taxRate;
    final total = subtotal + tax;

    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      items: currentOrder,
      createdAt: DateTime.now(),
      status: OrderStatus.pending,
      subtotal: subtotal,
      tax: tax,
      total: total,
    );

    ref.read(ordersNotifierProvider.notifier).addOrder(order);
    ref.read(currentOrderProvider.notifier).clearOrder();

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Order placed successfully!')),
    );
  }
}

// Menu Screen
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('मेन्यू प्रबंधन'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context, ref),
          ),
        ],
      ),
      body: menuItems.isEmpty
          ? const Center(child: Text('No menu items. Add some items to get started!'))
          : ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return _buildMenuItemCard(context, ref, item);
              },
            ),
    );
  }

  Widget _buildMenuItemCard(BuildContext context, WidgetRef ref, MenuItem item) {
    final settings = ref.watch(settingsNotifierProvider);
    
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ExpansionTile(
        title: Text(item.name, style: TextStyle(
          fontWeight: FontWeight.bold,
          decoration: item.isAvailable ? null : TextDecoration.lineThrough,
        )),
        subtitle: Text('${settings.currency}${item.price.toStringAsFixed(2)}'),
        trailing: Switch(
          value: item.isAvailable,
          onChanged: (value) => _toggleAvailability(ref, item, value),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (item.description.isNotEmpty) ...[
                  const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(item.description),
                  const SizedBox(height: 8),
                ],
                Row(
                  children: [
                    Expanded(child: Text('Category: ${item.category}')),
                    Expanded(child: Text('Stock: ${item.stockQuantity}')),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _showEditItemDialog(context, ref, item),
                        child: const Text('Edit'),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _confirmDelete(context, ref, item),
                        style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                        child: const Text('Delete'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    _showItemDialog(context, ref, null);
  }

  void _showEditItemDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    _showItemDialog(context, ref, item);
  }

  void _showItemDialog(BuildContext context, WidgetRef ref, MenuItem? item) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final costPriceController = TextEditingController(text: item?.costPrice.toString() ?? '');
    final stockController = TextEditingController(text: item?.stockQuantity.toString() ?? '');
    String selectedCategory = item?.category ?? 'Main';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(labelText: 'Description'),
                maxLines: 2,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: costPriceController,
                decoration: const InputDecoration(labelText: 'Cost Price'),
                keyboardType: TextInputType.number,
              ),
              TextField(
                controller: stockController,
                decoration: const InputDecoration(labelText: 'Stock Quantity'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<String>(
                value: selectedCategory,
                decoration: const InputDecoration(labelText: 'Category'),
                items: ['Main', 'Sides', 'Drinks', 'Desserts']
                    .map((category) => DropdownMenuItem(
                          value: category,
                          child: Text(category),
                        ))
                    .toList(),
                onChanged: (value) => selectedCategory = value!,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty && priceController.text.isNotEmpty) {
                final newItem = MenuItem(
                  id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  description: descriptionController.text,
                  price: double.tryParse(priceController.text) ?? 0,
                  costPrice: double.tryParse(costPriceController.text) ?? 0,
                  category: selectedCategory,
                  stockQuantity: int.tryParse(stockController.text) ?? 0,
                  isAvailable: item?.isAvailable ?? true,
                );

                if (item == null) {
                  ref.read(menuNotifierProvider.notifier).addItem(newItem);
                } else {
                  ref.read(menuNotifierProvider.notifier).updateItem(newItem);
                }

                Navigator.of(context).pop();
              }
            },
            child: Text(item == null ? 'Add' : 'Update'),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability(WidgetRef ref, MenuItem item, bool value) {
    final updatedItem = item.copyWith(isAvailable: value);
    ref.read(menuNotifierProvider.notifier).updateItem(updatedItem);
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(menuNotifierProvider.notifier).removeItem(item.id);
              Navigator.of(context).pop();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Reports Screen
class ReportsScreen extends ConsumerWidget {
  const ReportsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersNotifierProvider);
    final settings = ref.watch(settingsNotifierProvider);

    // Calculate analytics
    final totalRevenue = orders.fold(0.0, (sum, order) => sum + order.total);
    final totalOrders = orders.length;
    final averageOrderValue = totalOrders > 0 ? totalRevenue / totalOrders : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('रिपोर्ट्स'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Summary Cards
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Total Revenue',
                    '${settings.currency}${totalRevenue.toStringAsFixed(2)}',
                    Icons.monetization_on,
                    Colors.green,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'Total Orders',
                    totalOrders.toString(),
                    Icons.receipt_long,
                    Colors.blue,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildSummaryCard(
                    'Avg Order Value',
                    '${settings.currency}${averageOrderValue.toStringAsFixed(2)}',
                    Icons.trending_up,
                    Colors.orange,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: _buildSummaryCard(
                    'GST Collected',
                    '${settings.currency}${orders.fold(0.0, (sum, order) => sum + order.tax).toStringAsFixed(2)}',
                    Icons.account_balance,
                    Colors.purple,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Recent Orders
            const Text('Recent Orders', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: orders.isEmpty
                  ? const Center(child: Text('No orders yet'))
                  : ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return Card(
                          child: ListTile(
                            title: Text('Order #${order.id.substring(order.id.length - 6)}'),
                            subtitle: Text('${order.items.length} items • ${_formatDateTime(order.createdAt)}'),
                            trailing: Column(
                              mainAxisSize: MainAxisSize.min,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text('${settings.currency}${order.total.toStringAsFixed(2)}',
                                     style: const TextStyle(fontWeight: FontWeight.bold)),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: _getStatusColor(order.status),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    order.status.name.toUpperCase(),
                                    style: const TextStyle(color: Colors.white, fontSize: 10),
                                  ),
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
      ),
    );
  }

  Widget _buildSummaryCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(title, style: const TextStyle(fontSize: 12)),
            const SizedBox(height: 4),
            Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          ],
        ),
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.preparing:
        return Colors.blue;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.delivered:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsNotifierProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('सेटिंग्स'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('भारतीय QSR App', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Text('Currency: ${settings.currency}'),
                  Text('Tax Rate: ${(settings.taxRate * 100).toStringAsFixed(1)}% GST'),
                  Text('Phone Format: ${settings.phoneFormat}'),
                  Text('Language: ${settings.language == 'hi' ? 'Hindi' : 'English'}'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Quick Actions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _exportData(ref),
                      child: const Text('Export Data'),
                    ),
                  ),
                  const SizedBox(height: 8),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _clearData(context, ref),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                      child: const Text('Clear All Data'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _exportData(WidgetRef ref) {
    // Implementation for data export
    // This could export to CSV, JSON, etc.
  }

  void _clearData(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear All Data'),
        content: const Text('This will delete all orders, menu items, and settings. This action cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              // Clear all data
              final prefs = await SharedPreferences.getInstance();
              await prefs.clear();
              
              // Reset state
              ref.invalidate(menuNotifierProvider);
              ref.invalidate(ordersNotifierProvider);
              ref.invalidate(settingsNotifierProvider);
              
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('All data cleared successfully')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Clear Data'),
          ),
        ],
      ),
    );
  }
}
