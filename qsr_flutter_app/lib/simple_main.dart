import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'dart:math';

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

class QSRApp extends StatelessWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'भारतीय QSR ऐप', // Indian QSR App in Hindi
      theme: ThemeData(
        // Using saffron/orange colors inspired by Indian flag
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFFFF9933), // Saffron color
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        // Indian-inspired typography
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontWeight: FontWeight.w600),
          titleLarge: TextStyle(fontWeight: FontWeight.w600),
        ),
        // Elevated button style with Indian colors
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
        ),
      ),
      // Hindi/English locale support
      locale: const Locale('en', 'IN'), // English (India)
      home: const MainScreen(),
    );
  }
}

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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.restaurant),
            label: 'ऑर्डर्स', // Orders in Hindi
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book),
            label: 'मेन्यू', // Menu in Hindi
          ),
          NavigationDestination(
            icon: Icon(Icons.analytics),
            label: 'रिपोर्ट्स', // Reports in Hindi
          ),
          NavigationDestination(
            icon: Icon(Icons.settings),
            label: 'सेटिंग्स', // Settings in Hindi
          ),
        ],
      ),
    );
  }
}

// Enhanced Models with more features
class MenuItem {
  final int id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;
  final int stockQuantity;
  final String description;
  final double costPrice;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.stockQuantity = 100,
    this.description = '',
    this.costPrice = 0.0,
  });

  MenuItem copyWith({
    int? id,
    String? name,
    double? price,
    String? category,
    bool? isAvailable,
    int? stockQuantity,
    String? description,
    double? costPrice,
  }) {
    return MenuItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      description: description ?? this.description,
      costPrice: costPrice ?? this.costPrice,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'category': category,
      'isAvailable': isAvailable,
      'stockQuantity': stockQuantity,
      'description': description,
      'costPrice': costPrice,
    };
  }

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    return MenuItem(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      category: json['category'],
      isAvailable: json['isAvailable'] ?? true,
      stockQuantity: json['stockQuantity'] ?? 100,
      description: json['description'] ?? '',
      costPrice: json['costPrice'] ?? 0.0,
    );
  }
}

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final String? specialInstructions;
  final List<String> modifiers;

  OrderItem({
    required this.menuItem,
    required this.quantity,
    this.specialInstructions,
    this.modifiers = const [],
  });

  double get totalPrice => menuItem.price * quantity;

  OrderItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    String? specialInstructions,
    List<String>? modifiers,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      modifiers: modifiers ?? this.modifiers,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'menuItem': menuItem.toJson(),
      'quantity': quantity,
      'specialInstructions': specialInstructions,
      'modifiers': modifiers,
    };
  }

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      specialInstructions: json['specialInstructions'],
      modifiers: List<String>.from(json['modifiers'] ?? []),
    );
  }
}

enum OrderStatus { pending, preparing, ready, served, cancelled }

class Customer {
  final String name;
  final String? phone;
  final String? email;
  final String? address;

  Customer({
    required this.name,
    this.phone,
    this.email,
    this.address,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'email': email,
      'address': address,
    };
  }

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
}

class Order {
  final int id;
  final List<OrderItem> items;
  final DateTime createdAt;
  final String type;
  final double total;
  final double tax;
  final double discount;
  final OrderStatus status;
  final Customer? customer;
  final String? notes;
  final int? tableNumber;
  final bool kotPrinted;

  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.type,
    required this.total,
    this.tax = 0.0,
    this.discount = 0.0,
    this.status = OrderStatus.pending,
    this.customer,
    this.notes,
    this.tableNumber,
    this.kotPrinted = false,
  });

  double get subtotal => items.fold(0.0, (sum, item) => sum + item.totalPrice);
  double get finalTotal => subtotal + tax - discount;

  Order copyWith({
    int? id,
    List<OrderItem>? items,
    DateTime? createdAt,
    String? type,
    double? total,
    double? tax,
    double? discount,
    OrderStatus? status,
    Customer? customer,
    String? notes,
    int? tableNumber,
    bool? kotPrinted,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      total: total ?? this.total,
      tax: tax ?? this.tax,
      discount: discount ?? this.discount,
      status: status ?? this.status,
      customer: customer ?? this.customer,
      notes: notes ?? this.notes,
      tableNumber: tableNumber ?? this.tableNumber,
      kotPrinted: kotPrinted ?? this.kotPrinted,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'items': items.map((item) => item.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
      'type': type,
      'total': total,
      'tax': tax,
      'discount': discount,
      'status': status.toString().split('.').last,
      'customer': customer?.toJson(),
      'notes': notes,
      'tableNumber': tableNumber,
      'kotPrinted': kotPrinted,
    };
  }

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
      createdAt: DateTime.parse(json['createdAt']),
      type: json['type'],
      total: json['total'],
      tax: json['tax'] ?? 0.0,
      discount: json['discount'] ?? 0.0,
      status: OrderStatus.values.firstWhere(
        (e) => e.toString().split('.').last == json['status'],
        orElse: () => OrderStatus.pending,
      ),
      customer: json['customer'] != null ? Customer.fromJson(json['customer']) : null,
      notes: json['notes'],
      tableNumber: json['tableNumber'],
      kotPrinted: json['kotPrinted'] ?? false,
    );
  }
}

// Enhanced Providers with persistence
class AppSettings {
  final String storeName;
  final String storeAddress;
  final String storePhone;
  final double taxRate;
  final bool kotEnabled;
  final String printerAddress;
  final String currency;

  AppSettings({
    this.storeName = 'स्वादिष्ट रेस्टोरेंट', // Delicious Restaurant in Hindi
    this.storeAddress = 'दिल्ली, भारत', // Delhi, India in Hindi
    this.storePhone = '+91-98765-43210', // Indian phone number format
    this.taxRate = 0.18, // 18% GST (Goods and Services Tax) in India
    this.kotEnabled = true,
    this.printerAddress = '',
    this.currency = '₹', // Indian Rupee symbol
  });

  AppSettings copyWith({
    String? storeName,
    String? storeAddress,
    String? storePhone,
    double? taxRate,
    bool? kotEnabled,
    String? printerAddress,
    String? currency,
  }) {
    return AppSettings(
      storeName: storeName ?? this.storeName,
      storeAddress: storeAddress ?? this.storeAddress,
      storePhone: storePhone ?? this.storePhone,
      taxRate: taxRate ?? this.taxRate,
      kotEnabled: kotEnabled ?? this.kotEnabled,
      printerAddress: printerAddress ?? this.printerAddress,
      currency: currency ?? this.currency,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'storeName': storeName,
      'storeAddress': storeAddress,
      'storePhone': storePhone,
      'taxRate': taxRate,
      'kotEnabled': kotEnabled,
      'printerAddress': printerAddress,
      'currency': currency,
    };
  }

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      storeName: json['storeName'] ?? 'Demo Restaurant',
      storeAddress: json['storeAddress'] ?? '123 Main Street',
      storePhone: json['storePhone'] ?? '+1-234-567-8900',
      taxRate: json['taxRate'] ?? 0.1,
      kotEnabled: json['kotEnabled'] ?? true,
      printerAddress: json['printerAddress'] ?? '',
      currency: json['currency'] ?? '\$',
    );
  }
}

// Data Persistence Service
class StorageService {
  static const String _menuKey = 'menu_items';
  static const String _ordersKey = 'orders';
  static const String _settingsKey = 'app_settings';
  static const String _currentOrderKey = 'current_order';

  static Future<List<MenuItem>> loadMenuItems() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_menuKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => MenuItem.fromJson(json)).toList();
    }
    return _getDefaultMenuItems();
  }

  static Future<void> saveMenuItems(List<MenuItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_menuKey, jsonString);
  }

  static Future<List<Order>> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_ordersKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => Order.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveOrders(List<Order> orders) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(orders.map((order) => order.toJson()).toList());
    await prefs.setString(_ordersKey, jsonString);
  }

  static Future<AppSettings> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_settingsKey);
    if (jsonString != null) {
      return AppSettings.fromJson(json.decode(jsonString));
    }
    return AppSettings();
  }

  static Future<void> saveSettings(AppSettings settings) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(settings.toJson());
    await prefs.setString(_settingsKey, jsonString);
  }

  static Future<List<OrderItem>> loadCurrentOrder() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_currentOrderKey);
    if (jsonString != null) {
      final List<dynamic> jsonList = json.decode(jsonString);
      return jsonList.map((json) => OrderItem.fromJson(json)).toList();
    }
    return [];
  }

  static Future<void> saveCurrentOrder(List<OrderItem> items) async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = json.encode(items.map((item) => item.toJson()).toList());
    await prefs.setString(_currentOrderKey, jsonString);
  }

  static List<MenuItem> _getDefaultMenuItems() {
    return [
      MenuItem(
        id: 1,
        name: 'बटर चिकन', // Butter Chicken in Hindi
        price: 280.0, // INR pricing
        category: 'मुख्य व्यंजन', // Main Dishes in Hindi
        description: 'क्रीमी टमाटर ग्रेवी में तंदूरी चिकन', // Tandoori chicken in creamy tomato gravy
        costPrice: 150.0,
        stockQuantity: 50,
      ),
      MenuItem(
        id: 2,
        name: 'चिकन बिरयानी', // Chicken Biryani in Hindi
        price: 320.0,
        category: 'मुख्य व्यंजन',
        description: 'सुगंधित बासमती चावल के साथ चिकन', // Chicken with aromatic basmati rice
        costPrice: 180.0,
        stockQuantity: 30,
      ),
      MenuItem(
        id: 3,
        name: 'पनीर टिक्का', // Paneer Tikka in Hindi
        price: 240.0,
        category: 'स्नैक्स', // Snacks in Hindi
        description: 'तंदूर में पका हुआ मसालेदार पनीर', // Spiced paneer cooked in tandoor
        costPrice: 120.0,
        stockQuantity: 40,
      ),
      MenuItem(
        id: 4,
        name: 'मसाला चाय', // Masala Tea in Hindi
        price: 25.0,
        category: 'पेय पदार्थ', // Drinks in Hindi
        description: 'पारंपरिक भारतीय मसाला चाय', // Traditional Indian spiced tea
        costPrice: 8.0,
        stockQuantity: 200,
      ),
      MenuItem(
        id: 5,
        name: 'दाल मखनी', // Dal Makhani in Hindi
        price: 180.0,
        category: 'मुख्य व्यंजन',
        description: 'मक्खन और क्रीम के साथ काली दाल', // Black lentils with butter and cream
        costPrice: 80.0,
        stockQuantity: 60,
      ),
      MenuItem(
        id: 6,
        name: 'नान रोटी', // Naan Bread in Hindi
        price: 45.0,
        category: 'स्नैक्स',
        description: 'तंदूर में पकी हुई मुलायम रोटी', // Soft bread baked in tandoor
        costPrice: 15.0,
        stockQuantity: 60,
      ),
      MenuItem(
        id: 7,
        name: 'लस्सी', // Lassi in Hindi
        price: 60.0,
        category: 'पेय पदार्थ',
        description: 'ठंडा दही का पेय', // Cold yogurt drink
        costPrice: 25.0,
        stockQuantity: 80,
      ),
      MenuItem(
        id: 8,
        name: 'राजमा चावल', // Rajma Chawal in Hindi
        price: 160.0,
        category: 'मुख्य व्यंजन',
        description: 'राजमा करी के साथ सफेद चावल', // Kidney bean curry with white rice
        costPrice: 75.0,
        stockQuantity: 45,
      ),
      MenuItem(
        id: 9,
        name: 'समोसा', // Samosa in Hindi
        price: 20.0,
        category: 'स्नैक्स',
        description: 'मसालेदार आलू भरावन के साथ', // With spiced potato filling
        costPrice: 8.0,
        stockQuantity: 100,
      ),
      MenuItem(
        id: 10,
        name: 'गुलाब जामुन', // Gulab Jamun in Hindi
        price: 80.0,
        category: 'मिठाई', // Sweets in Hindi
        description: 'मीठे सिरप में डूबे हुए', // Soaked in sweet syrup
        costPrice: 30.0,
        stockQuantity: 50,
      ),
      MenuItem(
        id: 8,
        name: 'Club Sandwich',
        price: 8.99,
        category: 'Main',
        description: 'Triple-decker sandwich with turkey and bacon',
        costPrice: 4.20,
        stockQuantity: 40,
      ),
    ];
  }
}

// Enhanced Providers
final menuItemsProvider = StateNotifierProvider<MenuNotifier, List<MenuItem>>((ref) {
  return MenuNotifier();
});

final currentOrderProvider = StateNotifierProvider<CurrentOrderNotifier, List<OrderItem>>((ref) {
  return CurrentOrderNotifier();
});

final ordersProvider = StateNotifierProvider<OrdersNotifier, List<Order>>((ref) {
  return OrdersNotifier();
});

final settingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  return SettingsNotifier();
});

class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super([]) {
    _loadMenuItems();
  }

  Future<void> _loadMenuItems() async {
    state = await StorageService.loadMenuItems();
  }

  Future<void> updateMenuItem(MenuItem item) async {
    state = [
      for (final existingItem in state)
        if (existingItem.id == item.id) item else existingItem,
    ];
    await StorageService.saveMenuItems(state);
  }

  Future<void> addMenuItem(MenuItem item) async {
    state = [...state, item];
    await StorageService.saveMenuItems(state);
  }

  Future<void> deleteMenuItem(int id) async {
    state = state.where((item) => item.id != id).toList();
    await StorageService.saveMenuItems(state);
  }

  Future<void> updateStock(int id, int newStock) async {
    final item = state.firstWhere((item) => item.id == id);
    await updateMenuItem(item.copyWith(stockQuantity: newStock));
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]) {
    _loadCurrentOrder();
  }

  Future<void> _loadCurrentOrder() async {
    state = await StorageService.loadCurrentOrder();
  }

  Future<void> addItem(MenuItem menuItem, {int quantity = 1, String? instructions}) async {
    final existingIndex = state.indexWhere((item) => item.menuItem.id == menuItem.id);
    
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      state = [
        ...state.sublist(0, existingIndex),
        existingItem.copyWith(quantity: existingItem.quantity + quantity),
        ...state.sublist(existingIndex + 1),
      ];
    } else {
      state = [
        ...state,
        OrderItem(
          menuItem: menuItem,
          quantity: quantity,
          specialInstructions: instructions,
        ),
      ];
    }
    await StorageService.saveCurrentOrder(state);
  }

  Future<void> updateItem(int index, OrderItem newItem) async {
    state = [
      ...state.sublist(0, index),
      newItem,
      ...state.sublist(index + 1),
    ];
    await StorageService.saveCurrentOrder(state);
  }

  Future<void> removeItem(int index) async {
    state = [
      ...state.sublist(0, index),
      ...state.sublist(index + 1),
    ];
    await StorageService.saveCurrentOrder(state);
  }

  Future<void> clearOrder() async {
    state = [];
    await StorageService.saveCurrentOrder(state);
  }

  double get total => state.fold(0.0, (sum, item) => sum + item.totalPrice);
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    state = await StorageService.loadOrders();
  }

  Future<int> addOrder(Order order) async {
    final newOrder = order.copyWith(id: _getNextId());
    state = [...state, newOrder];
    await StorageService.saveOrders(state);
    return newOrder.id;
  }

  Future<void> updateOrderStatus(int orderId, OrderStatus status) async {
    state = [
      for (final order in state)
        if (order.id == orderId) order.copyWith(status: status) else order,
    ];
    await StorageService.saveOrders(state);
  }

  Future<void> markKotPrinted(int orderId) async {
    state = [
      for (final order in state)
        if (order.id == orderId) order.copyWith(kotPrinted: true) else order,
    ];
    await StorageService.saveOrders(state);
  }

  int _getNextId() {
    if (state.isEmpty) return 1;
    return state.map((order) => order.id).reduce((a, b) => a > b ? a : b) + 1;
  }

  List<Order> getOrdersByDateRange(DateTime start, DateTime end) {
    return state.where((order) {
      return order.createdAt.isAfter(start.subtract(const Duration(days: 1))) &&
             order.createdAt.isBefore(end.add(const Duration(days: 1)));
    }).toList();
  }

  double getTotalSales({DateTime? start, DateTime? end}) {
    var orders = state;
    if (start != null && end != null) {
      orders = getOrdersByDateRange(start, end);
    }
    return orders.where((order) => order.status != OrderStatus.cancelled)
                 .fold(0.0, (sum, order) => sum + order.finalTotal);
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    state = await StorageService.loadSettings();
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    await StorageService.saveSettings(state);
  }
}

// Enhanced Orders Screen with complete features
class OrdersScreen extends ConsumerStatefulWidget {
  const OrdersScreen({super.key});

  @override
  ConsumerState<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends ConsumerState<OrdersScreen> {
  String orderType = 'डाइन इन'; // Dine In in Hindi
  int? tableNumber;
  Customer? customer;
  String? orderNotes;

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuItemsProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    
    double subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.totalPrice);
    double tax = subtotal * settings.taxRate;
    double total = subtotal + tax;

    return Scaffold(
      appBar: AppBar(
        title: const Text('नया ऑर्डर'), // New Order in Hindi
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () => _showCustomerDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          // Order Configuration Section
          Container(
            padding: const EdgeInsets.all(16.0),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              border: Border(bottom: BorderSide(color: Colors.grey[300]!)),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Text('Type: ', style: TextStyle(fontWeight: FontWeight.bold)),
                          DropdownButton<String>(
                            value: orderType,
                            items: ['Dine In', 'Takeaway', 'Delivery'].map((String type) {
                              return DropdownMenuItem<String>(
                                value: type,
                                child: Text(type),
                              );
                            }).toList(),
                            onChanged: (String? newValue) {
                              if (newValue != null) {
                                setState(() {
                                  orderType = newValue;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                    if (orderType == 'Dine In') ...[
                      const SizedBox(width: 20),
                      Expanded(
                        child: Row(
                          children: [
                            const Text('Table: ', style: TextStyle(fontWeight: FontWeight.bold)),
                            Expanded(
                              child: TextFormField(
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  hintText: 'Table #',
                                  isDense: true,
                                ),
                                onChanged: (value) {
                                  tableNumber = int.tryParse(value);
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
                if (customer != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.blue[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.person, size: 16, color: Colors.blue),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            '${customer!.name}${customer!.phone != null ? ' - ${customer!.phone}' : ''}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 16),
                          onPressed: () => setState(() => customer = null),
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),

          // Menu Items Grid
          Expanded(
            flex: 2,
            child: GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 0.8,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
              ),
              itemCount: menuItems.where((item) => item.isAvailable).length,
              itemBuilder: (context, index) {
                final availableItems = menuItems.where((item) => item.isAvailable).toList();
                final item = availableItems[index];
                return Card(
                  child: InkWell(
                    onTap: () => _addToOrder(item),
                    onLongPress: () => _showItemDetails(item),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            _getIconForCategory(item.category),
                            size: 32,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '${settings.currency}${item.price.toStringAsFixed(2)}',
                            style: TextStyle(color: Colors.grey[600], fontSize: 11),
                          ),
                          if (item.stockQuantity < 10)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                              decoration: BoxDecoration(
                                color: Colors.orange,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'Low: ${item.stockQuantity}',
                                style: const TextStyle(color: Colors.white, fontSize: 8),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          // Current Order Section
          Expanded(
            flex: 1,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                border: Border(top: BorderSide(color: Colors.grey[300]!)),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Current Order', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Subtotal: ${settings.currency}${subtotal.toStringAsFixed(2)}'),
                            Text('Tax: ${settings.currency}${tax.toStringAsFixed(2)}'),
                            Text(
                              'Total: ${settings.currency}${total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: currentOrder.isEmpty
                        ? const Center(child: Text('No items in order'))
                        : ListView.builder(
                            itemCount: currentOrder.length,
                            itemBuilder: (context, index) {
                              final orderItem = currentOrder[index];
                              return Card(
                                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                                child: ListTile(
                                  title: Text(orderItem.menuItem.name),
                                  subtitle: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text('${settings.currency}${orderItem.menuItem.price.toStringAsFixed(2)} each'),
                                      if (orderItem.specialInstructions != null)
                                        Text(
                                          'Note: ${orderItem.specialInstructions}',
                                          style: TextStyle(color: Colors.blue[700], fontSize: 12),
                                        ),
                                    ],
                                  ),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () => _decreaseQuantity(index),
                                        icon: const Icon(Icons.remove_circle_outline),
                                      ),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).primaryColor.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: Text(
                                          orderItem.quantity.toString(),
                                          style: const TextStyle(fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                      IconButton(
                                        onPressed: () => _increaseQuantity(index),
                                        icon: const Icon(Icons.add_circle_outline),
                                      ),
                                      Text(
                                        '${settings.currency}${orderItem.totalPrice.toStringAsFixed(2)}',
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  
                  // Action Buttons
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: currentOrder.isEmpty ? null : () => _addOrderNotes(),
                                icon: const Icon(Icons.note_add),
                                label: const Text('Add Notes'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: OutlinedButton.icon(
                                onPressed: currentOrder.isEmpty ? null : () => _clearOrder(),
                                icon: const Icon(Icons.clear_all),
                                label: const Text('Clear'),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: currentOrder.isEmpty ? null : () => _saveOrder(),
                                icon: const Icon(Icons.save),
                                label: const Text('Save Order'),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: currentOrder.isEmpty ? null : () => _saveAndPrintKOT(),
                                icon: const Icon(Icons.print),
                                label: const Text('Save & Print KOT'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Theme.of(context).colorScheme.secondary,
                                ),
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
          ),
        ],
      ),
    );
  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Main':
        return Icons.restaurant;
      case 'Sides':
        return Icons.food_bank;
      case 'Drinks':
        return Icons.local_drink;
      default:
        return Icons.fastfood;
    }
  }

  Future<void> _addToOrder(MenuItem item) async {
    if (item.stockQuantity <= 0) {
      _showSnackBar('${item.name} is out of stock!');
      return;
    }
    
    await ref.read(currentOrderProvider.notifier).addItem(item);
    
    // Update stock
    await ref.read(menuItemsProvider.notifier).updateStock(item.id, item.stockQuantity - 1);
  }

  Future<void> _increaseQuantity(int index) async {
    final currentOrder = ref.read(currentOrderProvider);
    final orderItem = currentOrder[index];
    
    if (orderItem.menuItem.stockQuantity <= 0) {
      _showSnackBar('${orderItem.menuItem.name} is out of stock!');
      return;
    }
    
    await ref.read(currentOrderProvider.notifier).updateItem(
      index,
      orderItem.copyWith(quantity: orderItem.quantity + 1),
    );
    
    // Update stock
    await ref.read(menuItemsProvider.notifier).updateStock(
      orderItem.menuItem.id,
      orderItem.menuItem.stockQuantity - 1,
    );
  }

  Future<void> _decreaseQuantity(int index) async {
    final currentOrder = ref.read(currentOrderProvider);
    final orderItem = currentOrder[index];
    
    if (orderItem.quantity > 1) {
      await ref.read(currentOrderProvider.notifier).updateItem(
        index,
        orderItem.copyWith(quantity: orderItem.quantity - 1),
      );
      
      // Restore stock
      await ref.read(menuItemsProvider.notifier).updateStock(
        orderItem.menuItem.id,
        orderItem.menuItem.stockQuantity + 1,
      );
    } else {
      await ref.read(currentOrderProvider.notifier).removeItem(index);
      
      // Restore full stock for this item
      await ref.read(menuItemsProvider.notifier).updateStock(
        orderItem.menuItem.id,
        orderItem.menuItem.stockQuantity + orderItem.quantity,
      );
    }
  }

  Future<void> _saveOrder() async {
    final currentOrder = ref.read(currentOrderProvider);
    final settings = ref.read(settingsProvider);
    
    if (currentOrder.isEmpty) return;

    final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.totalPrice);
    final tax = subtotal * settings.taxRate;
    
    final order = Order(
      id: 0, // Will be set by the notifier
      items: List.from(currentOrder),
      createdAt: DateTime.now(),
      type: orderType,
      total: subtotal + tax,
      tax: tax,
      customer: customer,
      tableNumber: tableNumber,
      notes: orderNotes,
    );

    final orderId = await ref.read(ordersProvider.notifier).addOrder(order);
    await ref.read(currentOrderProvider.notifier).clearOrder();
    
    setState(() {
      customer = null;
      tableNumber = null;
      orderNotes = null;
    });

    _showSnackBar('Order #$orderId saved successfully!');
  }

  Future<void> _saveAndPrintKOT() async {
    await _saveOrder();
    
    final orders = ref.read(ordersProvider);
    if (orders.isNotEmpty) {
      final latestOrder = orders.last;
      await _printKOT(latestOrder);
      await ref.read(ordersProvider.notifier).markKotPrinted(latestOrder.id);
    }
  }

  Future<void> _printKOT(Order order) async {
    final settings = ref.read(settingsProvider);
    
    // Generate KOT content
    final kotContent = _generateKOTContent(order, settings);
    
    // In a real app, this would send to a printer
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KOT Preview'),
        content: SingleChildScrollView(
          child: Container(
            width: 300,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              kotContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _showSnackBar('KOT sent to printer');
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _generateKOTContent(Order order, AppSettings settings) {
    final buffer = StringBuffer();
    
    buffer.writeln('=============================');
    buffer.writeln('    ${settings.storeName}');
    buffer.writeln('    KITCHEN ORDER TICKET');
    buffer.writeln('=============================');
    buffer.writeln('Order #: ${order.id}');
    buffer.writeln('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.createdAt)}');
    buffer.writeln('Type: ${order.type}');
    if (order.tableNumber != null) {
      buffer.writeln('Table: ${order.tableNumber}');
    }
    if (order.customer != null) {
      buffer.writeln('Customer: ${order.customer!.name}');
    }
    buffer.writeln('-----------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.menuItem.name}');
      if (item.specialInstructions != null) {
        buffer.writeln('   Note: ${item.specialInstructions}');
      }
      for (final modifier in item.modifiers) {
        buffer.writeln('   + $modifier');
      }
    }
    
    if (order.notes != null) {
      buffer.writeln('-----------------------------');
      buffer.writeln('ORDER NOTES: ${order.notes}');
    }
    
    buffer.writeln('=============================');
    buffer.writeln('Time: ${DateFormat('HH:mm:ss').format(DateTime.now())}');
    
    return buffer.toString();
  }

  Future<void> _clearOrder() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Clear Order'),
        content: const Text('Are you sure you want to clear the current order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Clear'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      // Restore stock for all items
      final currentOrder = ref.read(currentOrderProvider);
      for (final orderItem in currentOrder) {
        await ref.read(menuItemsProvider.notifier).updateStock(
          orderItem.menuItem.id,
          orderItem.menuItem.stockQuantity + orderItem.quantity,
        );
      }
      
      await ref.read(currentOrderProvider.notifier).clearOrder();
      setState(() {
        customer = null;
        tableNumber = null;
        orderNotes = null;
      });
    }
  }

  Future<void> _showCustomerDialog() async {
    String name = '';
    String phone = '';
    String email = '';
    String address = '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Customer Information'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextFormField(
              decoration: const InputDecoration(labelText: 'Name *'),
              onChanged: (value) => name = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Phone'),
              keyboardType: TextInputType.phone,
              onChanged: (value) => phone = value,
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              onChanged: (value) => email = value,
            ),
            if (orderType == 'Delivery')
              TextFormField(
                decoration: const InputDecoration(labelText: 'Address *'),
                maxLines: 2,
                onChanged: (value) => address = value,
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (name.isNotEmpty && (orderType != 'Delivery' || address.isNotEmpty)) {
                setState(() {
                  customer = Customer(
                    name: name,
                    phone: phone.isEmpty ? null : phone,
                    email: email.isEmpty ? null : email,
                    address: address.isEmpty ? null : address,
                  );
                });
                Navigator.of(context).pop();
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _addOrderNotes() async {
    String notes = orderNotes ?? '';

    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Order Notes'),
        content: TextFormField(
          initialValue: notes,
          decoration: const InputDecoration(
            labelText: 'Special instructions or notes',
            hintText: 'e.g., No onions, extra spicy, etc.',
          ),
          maxLines: 3,
          onChanged: (value) => notes = value,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                orderNotes = notes.isEmpty ? null : notes;
              });
              Navigator.of(context).pop();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _showItemDetails(MenuItem item) async {
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(item.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Category: ${item.category}'),
            Text('Price: \$${item.price.toStringAsFixed(2)}'),
            Text('Stock: ${item.stockQuantity}'),
            if (item.description.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text('Description:', style: const TextStyle(fontWeight: FontWeight.bold)),
              Text(item.description),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              _addToOrder(item);
            },
            child: const Text('Add to Order'),
          ),
        ],
      ),
    );
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }
}

// Enhanced Menu Screen with complete management features
class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuItemsProvider);
    final settings = ref.watch(settingsProvider);
    
    final categories = ['All', 'Main', 'Sides', 'Drinks'];
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: categories.map((category) => Tab(text: category)).toList(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => _showSearchDialog(),
          ),
        ],
      ),
      body: Column(
        children: [
          if (_searchQuery.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.all(8),
              color: Colors.blue[50],
              child: Row(
                children: [
                  const Icon(Icons.search, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(child: Text('Searching for: "$_searchQuery"')),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => setState(() => _searchQuery = ''),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: categories.map((category) {
                return _buildMenuList(menuItems, category, settings);
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuList(List<MenuItem> allItems, String category, AppSettings settings) {
    var items = allItems;
    
    // Filter by category
    if (category != 'All') {
      items = items.where((item) => item.category == category).toList();
    }
    
    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      items = items.where((item) => 
        item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
        item.description.toLowerCase().contains(_searchQuery.toLowerCase())
      ).toList();
    }

    if (items.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.restaurant_menu, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              _searchQuery.isNotEmpty ? 'No items found' : 'No items in this category',
              style: TextStyle(color: Colors.grey[600], fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(8),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return Card(
          margin: const EdgeInsets.symmetric(vertical: 4),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: item.isAvailable ? Colors.green : Colors.red,
              child: Icon(
                _getIconForCategory(item.category),
                color: Colors.white,
              ),
            ),
            title: Text(
              item.name,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                decoration: item.isAvailable ? null : TextDecoration.lineThrough,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${settings.currency}${item.price.toStringAsFixed(2)}'),
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: item.stockQuantity > 10 ? Colors.green : 
                               item.stockQuantity > 0 ? Colors.orange : Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Stock: ${item.stockQuantity}',
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        item.category,
                        style: const TextStyle(color: Colors.white, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Switch(
                  value: item.isAvailable,
                  onChanged: (value) => _toggleAvailability(item, value),
                ),
                PopupMenuButton(
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      value: 'edit',
                      child: ListTile(
                        leading: Icon(Icons.edit),
                        title: Text('Edit'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'stock',
                      child: ListTile(
                        leading: Icon(Icons.inventory),
                        title: Text('Update Stock'),
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'delete',
                      child: ListTile(
                        leading: Icon(Icons.delete, color: Colors.red),
                        title: Text('Delete'),
                      ),
                    ),
                  ],
                  onSelected: (value) {
                    switch (value) {
                      case 'edit':
                        _showEditItemDialog(item);
                        break;
                      case 'stock':
                        _showStockDialog(item);
                        break;
                      case 'delete':
                        _confirmDelete(item);
                        break;
                    }
                  },
                ),
              ],
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
                        Expanded(
                          child: Text('Cost Price: ${settings.currency}${item.costPrice.toStringAsFixed(2)}'),
                        ),
                        Expanded(
                          child: Text('Profit: ${settings.currency}${(item.price - item.costPrice).toStringAsFixed(2)}'),
                        ),
                        Expanded(
                          child: Text('Margin: ${((item.price - item.costPrice) / item.price * 100).toStringAsFixed(1)}%'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  }

  IconData _getIconForCategory(String category) {
    switch (category) {
      case 'Main':
        return Icons.restaurant;
      case 'Sides':
        return Icons.food_bank;
      case 'Drinks':
        return Icons.local_drink;
      default:
        return Icons.fastfood;
    }
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Search Menu'),
        content: TextField(
          autofocus: true,
          decoration: const InputDecoration(hintText: 'Enter item name...'),
          onChanged: (value) => setState(() => _searchQuery = value),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              setState(() => _searchQuery = '');
            },
            child: const Text('Clear'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Search'),
          ),
        ],
      ),
    );
  }

  void _showAddItemDialog() {
    _showItemDialog(null);
  }

  void _showEditItemDialog(MenuItem item) {
    _showItemDialog(item);
  }

  void _showItemDialog(MenuItem? item) {
    final nameController = TextEditingController(text: item?.name ?? '');
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final costController = TextEditingController(text: item?.costPrice.toString() ?? '');
    final descController = TextEditingController(text: item?.description ?? '');
    final stockController = TextEditingController(text: item?.stockQuantity.toString() ?? '10');
    String selectedCategory = item?.category ?? 'Main';
    bool isAvailable = item?.isAvailable ?? true;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(item == null ? 'Add Menu Item' : 'Edit Menu Item'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name'),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(labelText: 'Description'),
                  maxLines: 2,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  decoration: const InputDecoration(labelText: 'Category'),
                  items: ['Main', 'Sides', 'Drinks'].map((category) {
                    return DropdownMenuItem(value: category, child: Text(category));
                  }).toList(),
                  onChanged: (value) => setState(() => selectedCategory = value!),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: costController,
                  decoration: const InputDecoration(labelText: 'Cost Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(labelText: 'Selling Price'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: stockController,
                  decoration: const InputDecoration(labelText: 'Stock Quantity'),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                SwitchListTile(
                  title: const Text('Available'),
                  value: isAvailable,
                  onChanged: (value) => setState(() => isAvailable = value),
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
                if (nameController.text.isNotEmpty && 
                    priceController.text.isNotEmpty &&
                    costController.text.isNotEmpty) {
                  
                  final newItem = MenuItem(
                    id: item?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
                    name: nameController.text,
                    price: double.tryParse(priceController.text) ?? 0,
                    costPrice: double.tryParse(costController.text) ?? 0,
                    category: selectedCategory,
                    description: descController.text,
                    isAvailable: isAvailable,
                    stockQuantity: int.tryParse(stockController.text) ?? 10,
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
      ),
    );
  }

  void _showStockDialog(MenuItem item) {
    final stockController = TextEditingController(text: item.stockQuantity.toString());
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Update Stock - ${item.name}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Current Stock: ${item.stockQuantity}'),
            const SizedBox(height: 16),
            TextField(
              controller: stockController,
              decoration: const InputDecoration(labelText: 'New Stock Quantity'),
              keyboardType: TextInputType.number,
              autofocus: true,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newStock = int.tryParse(stockController.text) ?? 0;
              final updatedItem = MenuItem(
                id: item.id,
                name: item.name,
                price: item.price,
                costPrice: item.costPrice,
                category: item.category,
                description: item.description,
                isAvailable: item.isAvailable,
                stockQuantity: newStock,
              );
              
              ref.read(menuNotifierProvider.notifier).updateItem(updatedItem);
              Navigator.of(context).pop();
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _toggleAvailability(MenuItem item, bool value) {
    final updatedItem = MenuItem(
      id: item.id,
      name: item.name,
      price: item.price,
      costPrice: item.costPrice,
      category: item.category,
      description: item.description,
      isAvailable: value,
      stockQuantity: item.stockQuantity,
    );
    
    ref.read(menuNotifierProvider.notifier).updateItem(updatedItem);
  }

  void _confirmDelete(MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(menuNotifierProvider.notifier).removeItem(item.id);
              Navigator.of(context).pop();
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Enhanced Reports Screen
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> with TickerProviderStateMixin {
  late TabController _tabController;
  DateTimeRange? _selectedDateRange;
  String _selectedPeriod = 'Today';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _selectedDateRange = DateTimeRange(
      start: DateTime.now().subtract(const Duration(hours: 24)),
      end: DateTime.now(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final orders = ref.watch(ordersProvider);
    final settings = ref.watch(settingsProvider);
    
    final filteredOrders = _getFilteredOrders(orders);
    final analytics = _calculateAnalytics(filteredOrders, settings);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Reports & Analytics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Overview', icon: Icon(Icons.dashboard)),
            Tab(text: 'Sales', icon: Icon(Icons.trending_up)),
            Tab(text: 'Items', icon: Icon(Icons.inventory)),
            Tab(text: 'Export', icon: Icon(Icons.download)),
          ],
        ),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range),
            itemBuilder: (context) => [
              'Today',
              'Yesterday', 
              'This Week',
              'This Month',
              'Custom Range'
            ].map((period) => PopupMenuItem(
              value: period,
              child: Text(period),
            )).toList(),
            onSelected: (period) => _selectPeriod(period),
          ),
        ],
      ),
      body: Column(
        children: [
          // Date Range Display
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            color: Colors.blue[50],
            child: Row(
              children: [
                const Icon(Icons.calendar_today, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Period: $_selectedPeriod (${DateFormat('MMM dd').format(_selectedDateRange!.start)} - ${DateFormat('MMM dd').format(_selectedDateRange!.end)})',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                Text(
                  '${filteredOrders.length} orders',
                  style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildOverviewTab(analytics, settings),
                _buildSalesTab(filteredOrders, analytics, settings),
                _buildItemsTab(filteredOrders, settings),
                _buildExportTab(filteredOrders, analytics, settings),
              ],
            ),
          ),
        ],
      ),
    );
  }

  List<Order> _getFilteredOrders(List<Order> orders) {
    if (_selectedDateRange == null) return orders;
    
    return orders.where((order) {
      return order.createdAt.isAfter(_selectedDateRange!.start) &&
             order.createdAt.isBefore(_selectedDateRange!.end.add(const Duration(days: 1)));
    }).toList();
  }

  Map<String, dynamic> _calculateAnalytics(List<Order> orders, AppSettings settings) {
    final totalSales = orders.fold(0.0, (sum, order) => sum + order.total);
    final totalOrders = orders.length;
    final averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;
    
    final completedOrders = orders.where((o) => o.status == 'Completed').length;
    final pendingOrders = orders.where((o) => o.status == 'Pending').length;
    final cancelledOrders = orders.where((o) => o.status == 'Cancelled').length;

    // Item analytics
    final Map<String, int> itemSales = {};
    final Map<String, double> itemRevenue = {};
    
    for (final order in orders) {
      for (final item in order.items) {
        final name = item.menuItem.name;
        itemSales[name] = (itemSales[name] ?? 0) + item.quantity;
        itemRevenue[name] = (itemRevenue[name] ?? 0) + (item.menuItem.price * item.quantity);
      }
    }

    return {
      'totalSales': totalSales,
      'totalOrders': totalOrders,
      'averageOrderValue': averageOrderValue,
      'completedOrders': completedOrders,
      'pendingOrders': pendingOrders,
      'cancelledOrders': cancelledOrders,
      'itemSales': itemSales,
      'itemRevenue': itemRevenue,
    };
  }

  void _selectPeriod(String period) {
    setState(() {
      _selectedPeriod = period;
      final now = DateTime.now();
      
      switch (period) {
        case 'Today':
          _selectedDateRange = DateTimeRange(
            start: DateTime(now.year, now.month, now.day),
            end: now,
          );
          break;
        case 'Yesterday':
          final yesterday = now.subtract(const Duration(days: 1));
          _selectedDateRange = DateTimeRange(
            start: DateTime(yesterday.year, yesterday.month, yesterday.day),
            end: DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59),
          );
          break;
        case 'This Week':
          final weekStart = now.subtract(Duration(days: now.weekday - 1));
          _selectedDateRange = DateTimeRange(
            start: DateTime(weekStart.year, weekStart.month, weekStart.day),
            end: now,
          );
          break;
        case 'This Month':
          _selectedDateRange = DateTimeRange(
            start: DateTime(now.year, now.month, 1),
            end: now,
          );
          break;
        case 'Custom Range':
          _showDateRangePicker();
          break;
      }
    });
  }

  void _showDateRangePicker() async {
    final range = await showDateRangePicker(
      context: context,
      firstDate: DateTime.now().subtract(const Duration(days: 365)),
      lastDate: DateTime.now(),
      initialDateRange: _selectedDateRange,
    );
    
    if (range != null) {
      setState(() {
        _selectedDateRange = range;
      });
    }
  }

  Widget _buildOverviewTab(Map<String, dynamic> analytics, AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // KPI Cards
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Total Sales',
                  '${settings.currency}${analytics['totalSales'].toStringAsFixed(2)}',
                  Icons.monetization_on,
                  Colors.green,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKPICard(
                  'Total Orders',
                  analytics['totalOrders'].toString(),
                  Icons.receipt_long,
                  Colors.blue,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _buildKPICard(
                  'Avg Order Value',
                  '${settings.currency}${analytics['averageOrderValue'].toStringAsFixed(2)}',
                  Icons.calculate,
                  Colors.orange,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildKPICard(
                  'Completion Rate',
                  '${(analytics['completedOrders'] / (analytics['totalOrders'] > 0 ? analytics['totalOrders'] : 1) * 100).toStringAsFixed(1)}%',
                  Icons.check_circle,
                  Colors.purple,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Order Status Distribution
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Status Distribution', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.check_circle, color: Colors.green, size: 32),
                            Text('${analytics['completedOrders']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Completed'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.pending, color: Colors.orange, size: 32),
                            Text('${analytics['pendingOrders']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Pending'),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Column(
                          children: [
                            Icon(Icons.cancel, color: Colors.red, size: 32),
                            Text('${analytics['cancelledOrders']}', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                            Text('Cancelled'),
                          ],
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

  Widget _buildKPICard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildSalesTab(List<Order> orders, Map<String, dynamic> analytics, AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Sales Performance', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Revenue', style: TextStyle(color: Colors.grey[600])),
                      Text('${settings.currency}${analytics['totalSales'].toStringAsFixed(2)}', 
                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green)),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Orders', style: TextStyle(color: Colors.grey[600])),
                      Text('${analytics['totalOrders']}', 
                           style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue)),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          const Text('Recent Transactions', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          ...orders.take(10).map((order) => Card(
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: _getStatusColor(order.status),
                child: Text(order.id.substring(0, 2).toUpperCase()),
              ),
              title: Text('Order #${order.id}'),
              subtitle: Text('${order.type} • ${order.items.length} items • ${DateFormat('MMM dd, HH:mm').format(order.createdAt)}'),
              trailing: Text('${settings.currency}${order.total.toStringAsFixed(2)}', 
                             style: const TextStyle(fontWeight: FontWeight.bold)),
            ),
          )).toList(),
        ],
      ),
    );
  }

  Widget _buildItemsTab(List<Order> orders, AppSettings settings) {
    final Map<String, int> itemSales = {};
    final Map<String, double> itemRevenue = {};
    
    for (final order in orders) {
      for (final item in order.items) {
        final name = item.menuItem.name;
        itemSales[name] = (itemSales[name] ?? 0) + item.quantity;
        itemRevenue[name] = (itemRevenue[name] ?? 0) + (item.menuItem.price * item.quantity);
      }
    }

    final sortedItems = itemSales.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Top Selling Items', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          if (sortedItems.isEmpty)
            const Center(child: Text('No sales data available'))
          else
            ...sortedItems.take(20).map((entry) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text('${entry.value}', style: const TextStyle(fontSize: 12)),
                ),
                title: Text(entry.key),
                subtitle: Text('${entry.value} sold'),
                trailing: Text('${settings.currency}${itemRevenue[entry.key]?.toStringAsFixed(2) ?? '0.00'}',
                             style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
            )).toList(),
        ],
      ),
    );
  }

  Widget _buildExportTab(List<Order> orders, Map<String, dynamic> analytics, AppSettings settings) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Export Data', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.file_download, color: Colors.blue),
                  title: const Text('Export Sales Report'),
                  subtitle: Text('Export ${orders.length} orders to CSV'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _exportSalesReport(orders, analytics, settings),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.inventory, color: Colors.green),
                  title: const Text('Export Item Analysis'),
                  subtitle: const Text('Export item sales data to CSV'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _exportItemAnalysis(orders, settings),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.print, color: Colors.orange),
                  title: const Text('Print Summary Report'),
                  subtitle: const Text('Print current period summary'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _printSummaryReport(analytics, settings),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const Text('Report Summary', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Period: $_selectedPeriod'),
                  Text('Total Orders: ${analytics['totalOrders']}'),
                  Text('Total Revenue: ${settings.currency}${analytics['totalSales'].toStringAsFixed(2)}'),
                  Text('Average Order: ${settings.currency}${analytics['averageOrderValue'].toStringAsFixed(2)}'),
                  Text('Generated: ${DateFormat('MMM dd, yyyy HH:mm').format(DateTime.now())}'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'Completed':
        return Colors.green;
      case 'Pending':
        return Colors.orange;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _exportSalesReport(List<Order> orders, Map<String, dynamic> analytics, AppSettings settings) {
    // Mock export functionality
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Sales report exported successfully!')),
    );
  }

  void _exportItemAnalysis(List<Order> orders, AppSettings settings) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Item analysis exported successfully!')),
    );
  }

  void _printSummaryReport(Map<String, dynamic> analytics, AppSettings settings) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Summary report sent to printer!')),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: ListView(
        children: [
          const ListTile(
            leading: Icon(Icons.store),
            title: Text('Store Information'),
            subtitle: Text('Demo Restaurant'),
          ),
          const ListTile(
            leading: Icon(Icons.print),
            title: Text('Printer Settings'),
            subtitle: Text('Bluetooth Thermal Printer (Demo)'),
          ),
          ListTile(
            leading: const Icon(Icons.receipt),
            title: const Text('Enable KOT Printing'),
            trailing: Switch(
              value: true,
              onChanged: (value) {
                // Toggle KOT printing
              },
            ),
          ),
          const ListTile(
            leading: Icon(Icons.info),
            title: Text('App Version'),
            subtitle: Text('1.0.0'),
          ),
        ],
      ),
    );
  }
}
