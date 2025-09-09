import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

// Language Support
enum AppLanguage { english, hindi }

class LanguageNotifier extends StateNotifier<AppLanguage> {
  LanguageNotifier() : super(AppLanguage.english) {
    _loadLanguage();
  }

  Future<void> _loadLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString('language');
    
    if (langCode == 'hi') {
      state = AppLanguage.hindi;
    } else {
      state = AppLanguage.english;
    }
  }

  Future<void> setLanguage(AppLanguage language) async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = language == AppLanguage.hindi ? 'hi' : 'en';
    await prefs.setString('language', langCode);
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
      // App Title
      'app_title': 'QSR Restaurant App',
      
      // Navigation
      'home': 'Home',
      'menu': 'Menu',
      'orders': 'Orders',
      'kot': 'KOT',
      'settings': 'Settings',
      
      // Common
      'add': 'Add',
      'edit': 'Edit',
      'delete': 'Delete',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'ok': 'OK',
      'close': 'Close',
      'search': 'Search',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'tax': 'Tax',
      'discount': 'Discount',
      'quantity': 'Quantity',
      'price': 'Price',
      'category': 'Category',
      'description': 'Description',
      'notes': 'Notes',
      'name': 'Name',
      'phone': 'Phone',
      'email': 'Email',
      'address': 'Address',
      
      // Order Management
      'place_order': 'Place Order',
      'current_order': 'Current Order',
      'order_details': 'Order Details',
      'order_summary': 'Order Summary',
      'order_placed': 'Order Placed Successfully',
      'order_updated': 'Order Updated Successfully',
      'order_cancelled': 'Order Cancelled',
      'customer_info': 'Customer Information',
      'customer_name': 'Customer Name',
      'customer_phone': 'Customer Phone',
      'customer_email': 'Customer Email',
      'special_instructions': 'Special Instructions',
      'add_to_order': 'Add to Order',
      'remove_from_order': 'Remove from Order',
      'edit_order': 'Edit Order',
      'cancel_order': 'Cancel Order',
      'mark_ready': 'Mark Ready',
      'mark_complete': 'Mark Complete',
      'mark_served': 'Mark Served',
      
      // Order Status
      'status': 'Status',
      'pending': 'Pending',
      'preparing': 'Preparing',
      'ready': 'Ready',
      'served': 'Served',
      'cancelled': 'Cancelled',
      
      // KOT
      'kitchen_order_ticket': 'Kitchen Order Ticket',
      'print_kot': 'Print KOT',
      'kot_printed': 'KOT Printed',
      'auto_print_kot': 'Auto Print KOT',
      'enable_kot': 'Enable KOT',
      
      // Settings
      'store_settings': 'Store Settings',
      'store_name': 'Store Name',
      'store_address': 'Store Address',
      'store_phone': 'Store Phone',
      'tax_rate': 'Tax Rate (%)',
      'language': 'Language',
      'select_language': 'Select Language',
      'english': 'English',
      'hindi': 'हिंदी',
      'general_settings': 'General Settings',
      'manage_menu': 'Manage Menu',
      'printer_settings': 'Printer Settings',
      'reports_data': 'Reports & Data',
      'sales_report': 'Sales Report',
      'backup_data': 'Backup Data',
      'about': 'About',
      'printer_management_msg': 'Bluetooth printer management will be implemented here.',
      'kot_feature_subtitle': 'Enable Kitchen Order Ticket functionality',
      'auto_kot_subtitle': 'Automatically generate KOT when order is placed',
      'backup_restore_msg': 'Backup and restore functionality will be implemented here.',
      'today': 'Today',
      'features': 'Features',
      'mobile_first_design': 'Mobile-first design',
      'offline_support': 'Offline support',
      'bluetooth_printing': 'Bluetooth thermal printing',
      'currency_formatting': 'Indian currency formatting',
      'multi_language': 'Multi-language support',
      
      // Menu Management
      'menu_management': 'Menu Management',
      'add_menu_item': 'Add Menu Item',
      'edit_menu_item': 'Edit Menu Item',
      'delete_menu_item': 'Delete Menu Item',
      'item_name': 'Item Name',
      'item_price': 'Item Price',
      'item_category': 'Item Category',
      'item_description': 'Item Description',
      'available': 'Available',
      'unavailable': 'Unavailable',
      'confirm_delete': 'Are you sure you want to delete this item?',
      
      // Reports
      'daily_report': 'Daily Report',
      'total_orders': 'Total Orders',
      'total_revenue': 'Total Revenue',
      'average_order': 'Average Order Value',
      
      // Validation Messages
      'field_required': 'This field is required',
      'invalid_email': 'Please enter a valid email',
      'invalid_phone': 'Please enter a valid phone number',
      'invalid_price': 'Please enter a valid price',
      'order_empty': 'Please add items to your order',
      
      // Table Management
      'section': 'Section',
      'table': 'Table',
      'seat': 'Seat',
      'select_section': 'Select Section',
      'select_table': 'Select Table',
      'select_seat': 'Select Seat',
      'table_management': 'Table Management',
      'manage_tables': 'Manage Tables',
      'add_section': 'Add Section',
      'edit_section': 'Edit Section',
      'section_name': 'Section Name',
      'table_number': 'Table Number',
      'seat_count': 'Seat Count',
      'table_status': 'Table Status',
      'occupied': 'Occupied',
      'available': 'Available',
      'reserved': 'Reserved',
      'cleaning': 'Cleaning',
      'out_of_order': 'Out of Order',
      'dine_in': 'Dine In',
      'takeaway': 'Takeaway',
      'delivery': 'Delivery',
      'order_type': 'Order Type',
      'customer_name_required': 'Customer name is required',
    },
    'hi': {
      // App Title
      'app_title': 'QSR रेस्टोरेंट ऐप',
      
      // Navigation
      'home': 'होम',
      'menu': 'मेन्यू',
      'orders': 'ऑर्डर',
      'kot': 'के.ओ.टी',
      'settings': 'सेटिंग्स',
      
      // Common
      'add': 'जोड़ें',
      'edit': 'संपादित करें',
      'delete': 'हटाएं',
      'save': 'सहेजें',
      'cancel': 'रद्द करें',
      'confirm': 'पुष्टि करें',
      'yes': 'हाँ',
      'no': 'नहीं',
      'ok': 'ठीक है',
      'close': 'बंद करें',
      'search': 'खोजें',
      'total': 'कुल',
      'subtotal': 'उप-योग',
      'tax': 'कर',
      'discount': 'छूट',
      'quantity': 'मात्रा',
      'price': 'मूल्य',
      'category': 'श्रेणी',
      'description': 'विवरण',
      'notes': 'नोट्स',
      'name': 'नाम',
      'phone': 'फोन',
      'email': 'ईमेल',
      'address': 'पता',
      
      // Order Management
      'place_order': 'ऑर्डर दें',
      'current_order': 'वर्तमान ऑर्डर',
      'order_details': 'ऑर्डर विवरण',
      'order_summary': 'ऑर्डर सारांश',
      'order_placed': 'ऑर्डर सफलतापूर्वक दिया गया',
      'order_updated': 'ऑर्डर सफलतापूर्वक अपडेट किया गया',
      'order_cancelled': 'ऑर्डर रद्द किया गया',
      'customer_info': 'ग्राहक जानकारी',
      'customer_name': 'ग्राहक का नाम',
      'customer_phone': 'ग्राहक का फोन',
      'customer_email': 'ग्राहक का ईमेल',
      'special_instructions': 'विशेष निर्देश',
      'add_to_order': 'ऑर्डर में जोड़ें',
      'remove_from_order': 'ऑर्डर से हटाएं',
      'edit_order': 'ऑर्डर संपादित करें',
      'cancel_order': 'ऑर्डर रद्द करें',
      'mark_ready': 'तैयार का निशान लगाएं',
      'mark_complete': 'पूर्ण का निशान लगाएं',
      'mark_served': 'परोसा गया का निशान लगाएं',
      
      // Order Status
      'status': 'स्थिति',
      'pending': 'लंबित',
      'preparing': 'तैयार किया जा रहा है',
      'ready': 'तैयार',
      'served': 'परोसा गया',
      'cancelled': 'रद्द',
      
      // KOT
      'kitchen_order_ticket': 'रसोई ऑर्डर टिकट',
      'print_kot': 'के.ओ.टी प्रिंट करें',
      'kot_printed': 'के.ओ.टी प्रिंट किया गया',
      'auto_print_kot': 'ऑटो प्रिंट के.ओ.टी',
      'enable_kot': 'के.ओ.टी सक्षम करें',
      
      // Settings
      'store_settings': 'स्टोर सेटिंग्स',
      'store_name': 'स्टोर का नाम',
      'store_address': 'स्टोर का पता',
      'store_phone': 'स्टोर का फोन',
      'tax_rate': 'कर दर (%)',
      'language': 'भाषा',
      'select_language': 'भाषा चुनें',
      'english': 'English',
      'hindi': 'हिंदी',
      'general_settings': 'सामान्य सेटिंग्स',
      'manage_menu': 'मेन्यू प्रबंधन',
      'printer_settings': 'प्रिंटर सेटिंग्स',
      'reports_data': 'रिपोर्ट और डेटा',
      'sales_report': 'बिक्री रिपोर्ट',
      'backup_data': 'बैकअप डेटा',
      'about': 'के बारे में',
      'printer_management_msg': 'ब्लूटूथ प्रिंटर प्रबंधन यहाँ लागू किया जाएगा।',
      'kot_feature_subtitle': 'रसोई ऑर्डर टिकट कार्यक्षमता सक्षम करें',
      'auto_kot_subtitle': 'ऑर्डर देने पर स्वचालित रूप से के.ओ.टी जेनरेट करें',
      'backup_restore_msg': 'बैकअप और रिस्टोर कार्यक्षमता यहाँ लागू की जाएगी।',
      'today': 'आज',
      'features': 'सुविधाएं',
      'mobile_first_design': 'मोबाइल-फर्स्ट डिज़ाइन',
      'offline_support': 'ऑफ़लाइन समर्थन',
      'bluetooth_printing': 'ब्लूटूथ थर्मल प्रिंटिंग',
      'currency_formatting': 'भारतीय मुद्रा फॉर्मेटिंग',
      'multi_language': 'बहु-भाषा समर्थन',
      
      // Menu Management
      'menu_management': 'मेन्यू प्रबंधन',
      'add_menu_item': 'मेन्यू आइटम जोड़ें',
      'edit_menu_item': 'मेन्यू आइटम संपादित करें',
      'delete_menu_item': 'मेन्यू आइटम हटाएं',
      'item_name': 'आइटम का नाम',
      'item_price': 'आइटम की कीमत',
      'item_category': 'आइटम की श्रेणी',
      'item_description': 'आइटम का विवरण',
      'available': 'उपलब्ध',
      'unavailable': 'अनुपलब्ध',
      'confirm_delete': 'क्या आप वाकई इस आइटम को हटाना चाहते हैं?',
      
      // Reports
      'daily_report': 'दैनिक रिपोर्ट',
      'total_orders': 'कुल ऑर्डर',
      'total_revenue': 'कुल आय',
      'average_order': 'औसत ऑर्डर मूल्य',
      
      // Validation Messages
      'field_required': 'यह फ़ील्ड आवश्यक है',
      'invalid_email': 'कृपया एक वैध ईमेल दर्ज करें',
      'invalid_phone': 'कृपया एक वैध फोन नंबर दर्ज करें',
      'invalid_price': 'कृपया एक वैध मूल्य दर्ज करें',
      'order_empty': 'कृपया अपने ऑर्डर में आइटम जोड़ें',
      
      // Table Management
      'section': 'सेक्शन',
      'table': 'टेबल',
      'seat': 'सीट',
      'select_section': 'सेक्शन चुनें',
      'select_table': 'टेबल चुनें',
      'select_seat': 'सीट चुनें',
      'table_management': 'टेबल प्रबंधन',
      'manage_tables': 'टेबल प्रबंधित करें',
      'add_section': 'सेक्शन जोड़ें',
      'edit_section': 'सेक्शन संपादित करें',
      'section_name': 'सेक्शन का नाम',
      'table_number': 'टेबल नंबर',
      'seat_count': 'सीट की संख्या',
      'table_status': 'टेबल की स्थिति',
      'occupied': 'कब्जे में',
      'available': 'उपलब्ध',
      'reserved': 'आरक्षित',
      'cleaning': 'सफाई',
      'out_of_order': 'खराब',
      'dine_in': 'रेस्टोरेंट में खाना',
      'takeaway': 'पैकिंग',
      'delivery': 'डिलीवरी',
      'order_type': 'ऑर्डर का प्रकार',
      'customer_name_required': 'ग्राहक का नाम आवश्यक है',
    },
  };

  String get(String key) {
    final langCode = language == AppLanguage.hindi ? 'hi' : 'en';
    return _localizedValues[langCode]?[key] ?? key;
  }
}

// Models
class MenuItem {
  final String id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.price,
    required this.category,
    this.isAvailable = true,
    this.description,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'category': category,
    'isAvailable': isAvailable,
    'description': description,
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    price: json['price'].toDouble(),
    category: json['category'],
    isAvailable: json['isAvailable'] ?? true,
    description: json['description'],
  );

  MenuItem copyWith({
    String? name,
    double? price,
    String? category,
    bool? isAvailable,
    String? description,
  }) => MenuItem(
    id: id,
    name: name ?? this.name,
    price: price ?? this.price,
    category: category ?? this.category,
    isAvailable: isAvailable ?? this.isAvailable,
    description: description ?? this.description,
  );
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

enum TableStatus { available, occupied, reserved, cleaning, outOfOrder }

class TableSection {
  final String id;
  final String name;
  final List<RestaurantTable> tables;

  TableSection({
    required this.id,
    required this.name,
    required this.tables,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'tables': tables.map((table) => table.toJson()).toList(),
  };

  factory TableSection.fromJson(Map<String, dynamic> json) => TableSection(
    id: json['id'],
    name: json['name'],
    tables: (json['tables'] as List).map((table) => RestaurantTable.fromJson(table)).toList(),
  );
}

class RestaurantTable {
  final String id;
  final String number;
  final int seatCount;
  final TableStatus status;
  final String? currentOrderId;

  RestaurantTable({
    required this.id,
    required this.number,
    required this.seatCount,
    this.status = TableStatus.available,
    this.currentOrderId,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'number': number,
    'seatCount': seatCount,
    'status': status.name,
    'currentOrderId': currentOrderId,
  };

  factory RestaurantTable.fromJson(Map<String, dynamic> json) => RestaurantTable(
    id: json['id'],
    number: json['number'],
    seatCount: json['seatCount'],
    status: TableStatus.values.firstWhere((e) => e.name == json['status']),
    currentOrderId: json['currentOrderId'],
  );

  RestaurantTable copyWith({
    TableStatus? status,
    String? currentOrderId,
  }) => RestaurantTable(
    id: id,
    number: number,
    seatCount: seatCount,
    status: status ?? this.status,
    currentOrderId: currentOrderId ?? this.currentOrderId,
  );
}

class Order {
  final String id;
  final String orderNumber;
  final List<OrderItem> items;
  final DateTime timestamp;
  final double total;
  final String customerName;
  final String? customerPhone;
  final OrderStatus status;
  final OrderType orderType;
  final String? sectionId;
  final String? tableId;
  final int? seatNumber;
  final String? notes;

  Order({
    required this.id,
    required this.orderNumber,
    required this.items,
    required this.timestamp,
    required this.total,
    required this.customerName,
    this.customerPhone,
    this.status = OrderStatus.pending,
    this.orderType = OrderType.dineIn,
    this.sectionId,
    this.tableId,
    this.seatNumber,
    this.notes,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'orderNumber': orderNumber,
    'items': items.map((item) => item.toJson()).toList(),
    'timestamp': timestamp.toIso8601String(),
    'total': total,
    'customerName': customerName,
    'customerPhone': customerPhone,
    'status': status.name,
    'orderType': orderType.name,
    'sectionId': sectionId,
    'tableId': tableId,
    'seatNumber': seatNumber,
    'notes': notes,
  };

  factory Order.fromJson(Map<String, dynamic> json) => Order(
    id: json['id'],
    orderNumber: json['orderNumber'],
    items: (json['items'] as List).map((item) => OrderItem.fromJson(item)).toList(),
    timestamp: DateTime.parse(json['timestamp']),
    total: json['total'].toDouble(),
    customerName: json['customerName'],
    customerPhone: json['customerPhone'],
    status: OrderStatus.values.firstWhere((e) => e.name == json['status']),
    orderType: OrderType.values.firstWhere((e) => e.name == (json['orderType'] ?? 'dineIn')),
    sectionId: json['sectionId'],
    tableId: json['tableId'],
    seatNumber: json['seatNumber'],
    notes: json['notes'],
  );

  Order copyWith({
    String? id,
    String? orderNumber,
    List<OrderItem>? items,
    DateTime? timestamp,
    double? total,
    String? customerName,
    String? customerPhone,
    OrderStatus? status,
    String? notes,
  }) {
    return Order(
      id: id ?? this.id,
      orderNumber: orderNumber ?? this.orderNumber,
      items: items ?? this.items,
      timestamp: timestamp ?? this.timestamp,
      total: total ?? this.total,
      customerName: customerName ?? this.customerName,
      customerPhone: customerPhone ?? this.customerPhone,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }
}

// App Settings Model
class AppSettings {
  final bool kotEnabled;
  final String storeName;
  final String storeAddress;
  final bool autoKotOnOrder;

  AppSettings({
    this.kotEnabled = true,
    this.storeName = 'QSR Restaurant',
    this.storeAddress = 'Main Street, City',
    this.autoKotOnOrder = true,
  });

  Map<String, dynamic> toJson() => {
    'kotEnabled': kotEnabled,
    'storeName': storeName,
    'storeAddress': storeAddress,
    'autoKotOnOrder': autoKotOnOrder,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    kotEnabled: json['kotEnabled'] ?? true,
    storeName: json['storeName'] ?? 'QSR Restaurant',
    storeAddress: json['storeAddress'] ?? 'Main Street, City',
    autoKotOnOrder: json['autoKotOnOrder'] ?? true,
  );

  AppSettings copyWith({
    bool? kotEnabled,
    String? storeName,
    String? storeAddress,
    bool? autoKotOnOrder,
  }) => AppSettings(
    kotEnabled: kotEnabled ?? this.kotEnabled,
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress ?? this.storeAddress,
    autoKotOnOrder: autoKotOnOrder ?? this.autoKotOnOrder,
  );
}

// Providers
final menuProvider = StateNotifierProvider<MenuNotifier, List<MenuItem>>((ref) {
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

final tablesProvider = StateNotifierProvider<TablesNotifier, List<TableSection>>((ref) {
  return TablesNotifier();
});

final connectedPrinterProvider = StateProvider<String?>((ref) => null);

// State Notifiers
class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super([]) {
    _loadMenu();
  }

  Future<void> _loadMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final menuJson = prefs.getString('menu');
    
    if (menuJson != null) {
      final List<dynamic> menuList = jsonDecode(menuJson);
      state = menuList.map((item) => MenuItem.fromJson(item)).toList();
    } else {
      // Load default menu for Indian QSR
      state = _getDefaultMenu();
      await _saveMenu();
    }
  }

  List<MenuItem> _getDefaultMenu() {
    return [
      // Snacks
      MenuItem(id: '1', name: 'Samosa', price: 20.0, category: 'Snacks', description: 'Crispy triangular pastry with spiced filling'),
      MenuItem(id: '2', name: 'Vada Pav', price: 25.0, category: 'Snacks', description: 'Mumbai street food with spiced potato fritter'),
      MenuItem(id: '3', name: 'Aloo Tikki', price: 30.0, category: 'Snacks', description: 'Golden fried potato patties with chutneys'),
      MenuItem(id: '4', name: 'Dhokla', price: 35.0, category: 'Snacks', description: 'Steamed savory cake from Gujarat'),
      
      // Beverages
      MenuItem(id: '5', name: 'Masala Chai', price: 15.0, category: 'Beverages', description: 'Traditional Indian spiced tea'),
      MenuItem(id: '6', name: 'Filter Coffee', price: 20.0, category: 'Beverages', description: 'South Indian style filter coffee'),
      MenuItem(id: '7', name: 'Sweet Lassi', price: 40.0, category: 'Beverages', description: 'Yogurt-based refreshing drink'),
      MenuItem(id: '8', name: 'Fresh Lime Water', price: 25.0, category: 'Beverages', description: 'Refreshing lime drink with mint'),
      
      // Main Course
      MenuItem(id: '9', name: 'Chole Bhature', price: 80.0, category: 'Main Course', description: 'Spiced chickpeas with fried bread'),
      MenuItem(id: '10', name: 'Rajma Rice', price: 90.0, category: 'Main Course', description: 'Red kidney beans curry with basmati rice'),
      MenuItem(id: '11', name: 'Dal Tadka', price: 60.0, category: 'Main Course', description: 'Tempered yellow lentils'),
      MenuItem(id: '12', name: 'Paneer Butter Masala', price: 120.0, category: 'Main Course', description: 'Cottage cheese in rich tomato gravy'),
      
      // Sweets
      MenuItem(id: '13', name: 'Gulab Jamun', price: 40.0, category: 'Sweets', description: 'Soft milk dumplings in sugar syrup'),
      MenuItem(id: '14', name: 'Jalebi', price: 50.0, category: 'Sweets', description: 'Crispy spiral sweet soaked in syrup'),
      MenuItem(id: '15', name: 'Rasgulla', price: 45.0, category: 'Sweets', description: 'Spongy cheese balls in light syrup'),
      
      // Breads
      MenuItem(id: '16', name: 'Butter Roti', price: 15.0, category: 'Breads', description: 'Soft whole wheat flatbread with butter'),
      MenuItem(id: '17', name: 'Garlic Naan', price: 25.0, category: 'Breads', description: 'Leavened bread with garlic and herbs'),
      MenuItem(id: '18', name: 'Aloo Paratha', price: 30.0, category: 'Breads', description: 'Stuffed flatbread with spiced potatoes'),
      MenuItem(id: '19', name: 'Butter Kulcha', price: 35.0, category: 'Breads', description: 'Soft leavened bread with butter'),
      MenuItem(id: '20', name: 'Puri', price: 20.0, category: 'Breads', description: 'Deep-fried puffed bread'),
    ];
  }

  Future<void> _saveMenu() async {
    final prefs = await SharedPreferences.getInstance();
    final menuJson = jsonEncode(state.map((item) => item.toJson()).toList());
    await prefs.setString('menu', menuJson);
  }

  Future<void> addItem(MenuItem item) async {
    state = [...state, item];
    await _saveMenu();
  }

  Future<void> updateItem(MenuItem updatedItem) async {
    state = [
      for (final item in state)
        if (item.id == updatedItem.id) updatedItem else item,
    ];
    await _saveMenu();
  }

  Future<void> removeItem(String id) async {
    state = state.where((item) => item.id != id).toList();
    await _saveMenu();
  }

  List<String> get categories {
    return state.map((item) => item.category).toSet().toList()..sort();
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]);

  void addItem(MenuItem menuItem, {int quantity = 1, String? specialInstructions}) {
    final existingIndex = state.indexWhere((item) => item.menuItemId == menuItem.id);
    
    if (existingIndex != -1) {
      final existingItem = state[existingIndex];
      final updatedItem = existingItem.copyWith(
        quantity: existingItem.quantity + quantity,
        specialInstructions: specialInstructions ?? existingItem.specialInstructions,
      );
      state = [
        ...state.take(existingIndex),
        updatedItem,
        ...state.skip(existingIndex + 1),
      ];
    } else {
      final newItem = OrderItem(
        menuItemId: menuItem.id,
        name: menuItem.name,
        price: menuItem.price,
        quantity: quantity,
        specialInstructions: specialInstructions,
      );
      state = [...state, newItem];
    }
  }

  void updateItemQuantity(String menuItemId, int quantity) {
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

  double get total {
    return state.fold(0.0, (sum, item) => sum + item.total);
  }

  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = prefs.getString('orders');
    
    if (ordersJson != null) {
      final List<dynamic> ordersList = jsonDecode(ordersJson);
      state = ordersList.map((order) => Order.fromJson(order)).toList();
    }
  }

  Future<void> _saveOrders() async {
    final prefs = await SharedPreferences.getInstance();
    final ordersJson = jsonEncode(state.map((order) => order.toJson()).toList());
    await prefs.setString('orders', ordersJson);
  }

  Future<String> placeOrder(
    List<OrderItem> items,
    String customerName, {
    String? customerPhone,
    String? notes,
    OrderType orderType = OrderType.dineIn,
    String? sectionId,
    String? tableId,
    int? seatNumber,
  }) async {
    final orderNumber = 'ORD${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}';
    final total = items.fold(0.0, (sum, item) => sum + item.total);
    
    final order = Order(
      id: const Uuid().v4(),
      orderNumber: orderNumber,
      items: items,
      timestamp: DateTime.now(),
      total: total,
      customerName: customerName,
      customerPhone: customerPhone,
      orderType: orderType,
      sectionId: sectionId,
      tableId: tableId,
      seatNumber: seatNumber,
      notes: notes,
    );

    state = [order, ...state];
    await _saveOrders();
    return orderNumber;
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    state = [
      for (final order in state)
        if (order.id == orderId)
          Order(
            id: order.id,
            orderNumber: order.orderNumber,
            items: order.items,
            timestamp: order.timestamp,
            total: order.total,
            customerName: order.customerName,
            customerPhone: order.customerPhone,
            status: status,
            notes: order.notes,
          )
        else order,
    ];
    await _saveOrders();
  }

  Future<void> updateOrder(String orderId, List<OrderItem> items, String customerName, {String? customerPhone, String? notes}) async {
    final total = items.fold(0.0, (sum, item) => sum + item.total);
    
    state = [
      for (final order in state)
        if (order.id == orderId && order.status != OrderStatus.completed)
          Order(
            id: order.id,
            orderNumber: order.orderNumber,
            items: items,
            timestamp: order.timestamp,
            total: total,
            customerName: customerName,
            customerPhone: customerPhone,
            status: order.status,
            notes: notes,
          )
        else order,
    ];
    await _saveOrders();
  }

  Future<void> markOrderReady(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.ready);
  }

  Future<void> markOrderCompleted(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.completed);
  }

  Future<void> cancelOrder(String orderId) async {
    await updateOrderStatus(orderId, OrderStatus.cancelled);
  }

  bool canUpdateOrder(String orderId) {
    final order = state.firstWhere(
      (order) => order.id == orderId,
      orElse: () => throw StateError('Order not found'),
    );
    return order.status != OrderStatus.completed && order.status != OrderStatus.cancelled;
  }
}

// Settings Notifier
class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = prefs.getString('settings');
    
    if (settingsJson != null) {
      final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      state = AppSettings.fromJson(settingsMap);
    }
  }

  Future<void> _saveSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final settingsJson = jsonEncode(state.toJson());
    await prefs.setString('settings', settingsJson);
  }

  Future<void> updateSettings(AppSettings newSettings) async {
    state = newSettings;
    await _saveSettings();
  }

  Future<void> toggleKotEnabled() async {
    state = state.copyWith(kotEnabled: !state.kotEnabled);
    await _saveSettings();
  }

  Future<void> toggleAutoKotOnOrder() async {
    state = state.copyWith(autoKotOnOrder: !state.autoKotOnOrder);
    await _saveSettings();
  }
}

class TablesNotifier extends StateNotifier<List<TableSection>> {
  TablesNotifier() : super([]) {
    _loadTables();
  }

  Future<void> _loadTables() async {
    final prefs = await SharedPreferences.getInstance();
    final tablesJson = prefs.getString('table_sections');
    
    if (tablesJson != null) {
      final List<dynamic> tablesList = jsonDecode(tablesJson);
      state = tablesList.map((section) => TableSection.fromJson(section)).toList();
    } else {
      state = _getDefaultTables();
      await _saveTables();
    }
  }

  List<TableSection> _getDefaultTables() {
    return [
      TableSection(
        id: '1',
        name: 'Main Dining',
        tables: [
          RestaurantTable(id: '1', number: '1', seatCount: 4),
          RestaurantTable(id: '2', number: '2', seatCount: 4),
          RestaurantTable(id: '3', number: '3', seatCount: 6),
          RestaurantTable(id: '4', number: '4', seatCount: 2),
        ],
      ),
      TableSection(
        id: '2',
        name: 'Outdoor',
        tables: [
          RestaurantTable(id: '5', number: '5', seatCount: 4),
          RestaurantTable(id: '6', number: '6', seatCount: 6),
        ],
      ),
      TableSection(
        id: '3',
        name: 'Private Dining',
        tables: [
          RestaurantTable(id: '7', number: '7', seatCount: 8),
          RestaurantTable(id: '8', number: '8', seatCount: 10),
        ],
      ),
    ];
  }

  Future<void> _saveTables() async {
    final prefs = await SharedPreferences.getInstance();
    final tablesJson = jsonEncode(state.map((section) => section.toJson()).toList());
    await prefs.setString('table_sections', tablesJson);
  }

  Future<void> updateTableStatus(String tableId, TableStatus status, {String? orderId}) async {
    state = [
      for (final section in state)
        TableSection(
          id: section.id,
          name: section.name,
          tables: [
            for (final table in section.tables)
              if (table.id == tableId)
                table.copyWith(status: status, currentOrderId: orderId)
              else table,
          ],
        ),
    ];
    await _saveTables();
  }

  Future<void> addSection(String name) async {
    final newSection = TableSection(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      tables: [],
    );
    state = [...state, newSection];
    await _saveTables();
  }

  Future<void> addTable(String sectionId, String number, int seatCount) async {
    final newTable = RestaurantTable(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      number: number,
      seatCount: seatCount,
    );
    
    state = [
      for (final section in state)
        if (section.id == sectionId)
          TableSection(
            id: section.id,
            name: section.name,
            tables: [...section.tables, newTable],
          )
        else section,
    ];
    await _saveTables();
  }

  RestaurantTable? getTable(String tableId) {
    for (final section in state) {
      for (final table in section.tables) {
        if (table.id == tableId) return table;
      }
    }
    return null;
  }

  TableSection? getSection(String sectionId) {
    return state.where((section) => section.id == sectionId).firstOrNull;
  }

  List<RestaurantTable> getAvailableTables() {
    final availableTables = <RestaurantTable>[];
    for (final section in state) {
      availableTables.addAll(
        section.tables.where((table) => table.status == TableStatus.available),
      );
    }
    return availableTables;
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
      return 'New Order';
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

Color getStatusColor(OrderStatus status) {
  switch (status) {
    case OrderStatus.pending:
      return Colors.orange;
    case OrderStatus.preparing:
      return Colors.blue;
    case OrderStatus.ready:
      return Colors.green;
    case OrderStatus.completed:
      return Colors.grey;
    case OrderStatus.cancelled:
      return Colors.red;
  }
}

// Main App
void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

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
          seedColor: const Color(0xFFFF9933), // QR Orange
          brightness: Brightness.light,
          primary: const Color(0xFFFF9933),
          secondary: const Color(0xFF212121), // QR Black
          surface: Colors.white,
          background: const Color(0xFFFAFAFA),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
        
        // Enhanced Typography
        textTheme: const TextTheme(
          displayLarge: TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: Color(0xFF212121),
            letterSpacing: -0.5,
          ),
          displayMedium: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
            letterSpacing: -0.25,
          ),
          headlineLarge: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: 0,
          ),
          headlineMedium: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: 0.15,
          ),
          titleLarge: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF212121),
            letterSpacing: 0.15,
          ),
          titleMedium: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
            letterSpacing: 0.1,
          ),
          bodyLarge: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            color: Color(0xFF424242),
            letterSpacing: 0.5,
          ),
          bodyMedium: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Color(0xFF424242),
            letterSpacing: 0.25,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Color(0xFF212121),
            letterSpacing: 0.1,
          ),
        ),
        
        // Enhanced AppBar
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 4,
          shadowColor: Color(0x1A000000),
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          foregroundColor: Color(0xFF212121),
          titleTextStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Color(0xFF212121),
            letterSpacing: 0.15,
          ),
          iconTheme: IconThemeData(
            color: Color(0xFF212121),
            size: 24,
          ),
        ),
        
        // Enhanced Cards with Premium Shadows
        cardTheme: CardThemeData(
          elevation: 8,
          shadowColor: const Color(0x1F000000),
          surfaceTintColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: BorderSide(
              color: Colors.grey.shade100,
              width: 1,
            ),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          clipBehavior: Clip.antiAlias,
        ),
        
        // Enhanced Buttons with Better Shadows
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            elevation: 6,
            shadowColor: const Color(0x3DFF9933),
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ).copyWith(
            overlayColor: MaterialStateProperty.resolveWith<Color?>(
              (Set<MaterialState> states) {
                if (states.contains(MaterialState.hovered)) {
                  return Colors.white.withOpacity(0.1);
                }
                if (states.contains(MaterialState.pressed)) {
                  return Colors.white.withOpacity(0.2);
                }
                return null;
              },
            ),
          ),
        ),
        
        // Enhanced Text Buttons
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFFFF9933),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            textStyle: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.5,
            ),
          ),
        ),
        
        // Enhanced Input Fields
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.grey.shade300, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2.5),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Colors.red, width: 1.5),
          ),
          filled: true,
          fillColor: const Color(0xFFFAFAFA),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: Colors.grey.shade600,
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
          hintStyle: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 16,
            fontWeight: FontWeight.w400,
          ),
        ),
        
        // Enhanced Chips
        chipTheme: ChipThemeData(
          backgroundColor: Colors.grey.shade100,
          selectedColor: const Color(0xFFFF9933).withOpacity(0.15),
          labelStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.25,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: BorderSide(
              color: Colors.grey.shade200,
              width: 1,
            ),
          ),
          elevation: 2,
          shadowColor: const Color(0x1A000000),
        ),
        
        // Enhanced Bottom Navigation
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          elevation: 8,
          backgroundColor: Colors.white,
          selectedItemColor: Color(0xFFFF9933),
          unselectedItemColor: Color(0xFF757575),
          selectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
          unselectedLabelStyle: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            letterSpacing: 0.5,
          ),
          type: BottomNavigationBarType.fixed,
        ),
        
        // Enhanced Dividers
        dividerTheme: DividerThemeData(
          color: Colors.grey.shade200,
          thickness: 1,
          space: 1,
        ),
      ),
      home: const MainScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

// Main Screen with Bottom Navigation
class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const MenuScreen(),
    const OrdersScreen(),
    const TableManagementScreen(),
    const KOTScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.restaurant_menu),
            label: localizations.get('menu'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.receipt_long),
            label: localizations.get('orders'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.table_restaurant),
            label: localizations.get('tables'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.print),
            label: localizations.get('kot'),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: localizations.get('settings'),
          ),
        ],
      ),
    );
  }
}

// Menu Screen
class MenuScreen extends ConsumerStatefulWidget {
  const MenuScreen({super.key});

  @override
  ConsumerState<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends ConsumerState<MenuScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final categories = ['All', ...ref.read(menuProvider.notifier).categories];

    final filteredMenu = menu.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch && item.isAvailable;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('menu')),
        actions: [
          if (currentOrder.isNotEmpty)
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.shopping_cart),
                  onPressed: () => _showCurrentOrder(context),
                ),
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      '${ref.read(currentOrderProvider.notifier).totalItems}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Container(
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search menu items...',
                prefixIcon: Icon(Icons.search, color: Colors.orange),
                border: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              onChanged: (value) => setState(() => _searchQuery = value),
            ),
          ),
          
          // Category Filter
          SizedBox(
            height: 50,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: categories.length,
              itemBuilder: (context, index) {
                final category = categories[index];
                final isSelected = category == _selectedCategory;
                
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    selected: isSelected,
                    label: Text(category),
                    onSelected: (selected) {
                      setState(() => _selectedCategory = category);
                    },
                  ),
                );
              },
            ),
          ),
          
          // Menu Items
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: filteredMenu.length,
              itemBuilder: (context, index) {
                final item = filteredMenu[index];
                final orderItem = currentOrder.where((oi) => oi.menuItemId == item.id).firstOrNull;
                
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: LinearGradient(
                      colors: [Colors.white, const Color(0xFFFFFBF5)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0x1F000000),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                        spreadRadius: 0,
                      ),
                      BoxShadow(
                        color: const Color(0x0A000000),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                        spreadRadius: 0,
                      ),
                    ],
                    border: Border.all(
                      color: Colors.grey.shade100,
                      width: 1,
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Row(
                      children: [
                        // Premium Item Icon with Gradient
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                const Color(0xFFFF9933),
                                const Color(0xFFFFB366),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x3DFF9933),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.restaurant,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                        const SizedBox(width: 16),
                        
                        // Item Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF212121),
                                  letterSpacing: 0.15,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                formatCurrency(item.price),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF2E7D32),
                                  letterSpacing: 0.15,
                                ),
                              ),
                              if (item.description != null) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey[600],
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        // Add/Update Controls with Enhanced Design
                        orderItem != null
                            ? Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF9933).withOpacity(0.1),
                                      const Color(0xFFFF9933).withOpacity(0.05),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: const Color(0xFFFF9933).withOpacity(0.3),
                                    width: 1.5,
                                  ),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          ref.read(currentOrderProvider.notifier)
                                              .updateItemQuantity(item.id, orderItem.quantity - 1);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.remove,
                                            color: Color(0xFFFF9933),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          colors: [
                                            const Color(0xFFFF9933),
                                            const Color(0xFFFFB366),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0x3DFF9933),
                                            blurRadius: 4,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        '${orderItem.quantity}',
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    Material(
                                      color: Colors.transparent,
                                      child: InkWell(
                                        borderRadius: BorderRadius.circular(12),
                                        onTap: () {
                                          ref.read(currentOrderProvider.notifier)
                                              .updateItemQuantity(item.id, orderItem.quantity + 1);
                                        },
                                        child: Container(
                                          padding: const EdgeInsets.all(8),
                                          child: const Icon(
                                            Icons.add,
                                            color: Color(0xFFFF9933),
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF9933),
                                      const Color(0xFFFFB366),
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0x3DFF9933),
                                      blurRadius: 8,
                                      offset: const Offset(0, 3),
                                      spreadRadius: 0,
                                    ),
                                  ],
                                ),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(16),
                                    onTap: () {
                                      ref.read(currentOrderProvider.notifier).addItem(item);
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: const [
                                          Icon(
                                            Icons.add_shopping_cart,
                                            color: Colors.white,
                                            size: 18,
                                          ),
                                          SizedBox(width: 8),
                                          Text(
                                            'Add',
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.w600,
                                              fontSize: 14,
                                              letterSpacing: 0.5,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
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
      floatingActionButton: currentOrder.isNotEmpty
          ? FloatingActionButton.extended(
              onPressed: () => _showPlaceOrderDialog(context),
              icon: const Icon(Icons.shopping_cart_checkout),
              label: Text('Place Order (${currentOrder.length} items)'),
              backgroundColor: Colors.orange,
              foregroundColor: Colors.white,
            )
          : null,
    );
  }

  void _showCurrentOrder(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) => const CurrentOrderSheet(),
    );
  }

  void _showPlaceOrderDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => const PlaceOrderDialog(),
    );
  }
}

// Current Order Sheet
class CurrentOrderSheet extends ConsumerStatefulWidget {
  const CurrentOrderSheet({super.key});

  @override
  ConsumerState<CurrentOrderSheet> createState() => _CurrentOrderSheetState();
}

class _CurrentOrderSheetState extends ConsumerState<CurrentOrderSheet> {
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final total = ref.read(currentOrderProvider.notifier).total;

    return Container(
      height: MediaQuery.of(context).size.height * 0.8,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Current Order',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
              ),
            ],
          ),
          const Divider(),
          
          // Order Items
          Expanded(
            child: ListView.builder(
              itemCount: currentOrder.length,
              itemBuilder: (context, index) {
                final item = currentOrder[index];
                return ListTile(
                  title: Text(item.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove),
                        onPressed: () {
                          ref.read(currentOrderProvider.notifier)
                              .updateItemQuantity(item.menuItemId, item.quantity - 1);
                        },
                      ),
                      Text('${item.quantity}'),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          ref.read(currentOrderProvider.notifier)
                              .updateItemQuantity(item.menuItemId, item.quantity + 1);
                        },
                      ),
                      SizedBox(
                        width: 60,
                        child: Text(
                          formatCurrency(item.total),
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          
          const Divider(),
          
          // Customer Info
          TextField(
            controller: _customerNameController,
            decoration: const InputDecoration(
              labelText: 'Customer Name *',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _phoneController,
            decoration: const InputDecoration(
              labelText: 'Phone Number',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.phone,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _notesController,
            decoration: const InputDecoration(
              labelText: 'Special Instructions',
              border: OutlineInputBorder(),
            ),
            maxLines: 2,
          ),
          const SizedBox(height: 16),
          
          // Total and Place Order
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total: ${formatCurrency(total)}',
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              ElevatedButton(
                onPressed: currentOrder.isNotEmpty && _customerNameController.text.isNotEmpty
                    ? () => _placeOrder()
                    : null,
                child: const Text('Place Order'),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Future<void> _placeOrder() async {
    final currentOrder = ref.read(currentOrderProvider);
    
    if (currentOrder.isEmpty || _customerNameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please add items and customer name\nकृपया आइटम और ग्राहक का नाम जोड़ें'),
        ),
      );
      return;
    }

    final orderNumber = await ref.read(ordersProvider.notifier).placeOrder(
      currentOrder,
      _customerNameController.text,
      customerPhone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    ref.read(currentOrderProvider.notifier).clearOrder();
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order placed: $orderNumber'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Place Order Dialog
class PlaceOrderDialog extends ConsumerStatefulWidget {
  const PlaceOrderDialog({super.key});

  @override
  ConsumerState<PlaceOrderDialog> createState() => _PlaceOrderDialogState();
}

class _PlaceOrderDialogState extends ConsumerState<PlaceOrderDialog> {
  final _customerNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _notesController = TextEditingController();
  
  OrderType _selectedOrderType = OrderType.dineIn;
  String? _selectedSectionId;
  String? _selectedTableId;
  int? _selectedSeatNumber;

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
