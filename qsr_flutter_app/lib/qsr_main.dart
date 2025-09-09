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
      'enable_dine_in': 'Enable Dine-In',
      'dine_in_feature_subtitle': 'Enable dine-in ordering',
      
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
      'enable_dine_in': 'डाइन-इन सक्षम करें',
      'dine_in_feature_subtitle': 'टेबल चयन और डाइन-इन ऑर्डरिंग सक्षम करें',
      'table_selection': 'टेबल चयन',
      
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

  Map<String, dynamic> toJson() => {
    'dineInPrice': dineInPrice,
    'takeawayPrice': takeawayPrice,
    'deliveryPrice': deliveryPrice,
  };

  factory MenuItemPricing.fromJson(Map<String, dynamic> json) => MenuItemPricing(
    dineInPrice: json['dineInPrice']?.toDouble() ?? 0.0,
    takeawayPrice: json['takeawayPrice']?.toDouble() ?? 0.0,
    deliveryPrice: json['deliveryPrice']?.toDouble() ?? 0.0,
  );
}

class MenuItem {
  final String id;
  final String name;
  final MenuItemPricing pricing;
  final String category;
  final bool isAvailable;
  final String? description;
  final Set<OrderType> availableForOrderTypes;

  MenuItem({
    required this.id,
    required this.name,
    required this.pricing,
    required this.category,
    this.isAvailable = true,
    this.description,
    this.availableForOrderTypes = const {OrderType.dineIn, OrderType.takeaway, OrderType.delivery},
  });

  // Legacy price getter (defaults to dine-in price)
  double get price => pricing.dineInPrice;

  double getPriceForOrderType(OrderType orderType) {
    return pricing.getPriceForOrderType(orderType);
  }

  bool isAvailableForOrderType(OrderType orderType) {
    return isAvailable && availableForOrderTypes.contains(orderType);
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'pricing': pricing.toJson(),
    'category': category,
    'isAvailable': isAvailable,
    'description': description,
    'availableForOrderTypes': availableForOrderTypes.map((e) => e.name).toList(),
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) {
    // Handle legacy format where price was a single value
    MenuItemPricing pricing;
    if (json['pricing'] != null) {
      pricing = MenuItemPricing.fromJson(json['pricing']);
    } else {
      final legacyPrice = json['price']?.toDouble() ?? 0.0;
      pricing = MenuItemPricing(
        dineInPrice: legacyPrice,
        takeawayPrice: legacyPrice,
        deliveryPrice: legacyPrice + (legacyPrice * 0.1), // 10% extra for delivery
      );
    }

    return MenuItem(
      id: json['id'],
      name: json['name'],
      pricing: pricing,
      category: json['category'],
      isAvailable: json['isAvailable'] ?? true,
      description: json['description'],
      availableForOrderTypes: json['availableForOrderTypes'] != null
          ? (json['availableForOrderTypes'] as List)
              .map((e) => OrderType.values.firstWhere((type) => type.name == e))
              .toSet()
          : {OrderType.dineIn, OrderType.takeaway, OrderType.delivery},
    );
  }

  MenuItem copyWith({
    String? name,
    MenuItemPricing? pricing,
    String? category,
    bool? isAvailable,
    String? description,
    Set<OrderType>? availableForOrderTypes,
  }) => MenuItem(
    id: id,
    name: name ?? this.name,
    pricing: pricing ?? this.pricing,
    category: category ?? this.category,
    isAvailable: isAvailable ?? this.isAvailable,
    description: description ?? this.description,
    availableForOrderTypes: availableForOrderTypes ?? this.availableForOrderTypes,
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
  final bool dineInEnabled;

  AppSettings({
    this.kotEnabled = true,
    this.storeName = 'QSR Restaurant',
    this.storeAddress = 'Main Street, City',
    this.autoKotOnOrder = true,
    this.dineInEnabled = false, // Default disabled
  });

  Map<String, dynamic> toJson() => {
    'kotEnabled': kotEnabled,
    'storeName': storeName,
    'storeAddress': storeAddress,
    'autoKotOnOrder': autoKotOnOrder,
    'dineInEnabled': dineInEnabled,
  };

  factory AppSettings.fromJson(Map<String, dynamic> json) => AppSettings(
    kotEnabled: json['kotEnabled'] ?? true,
    storeName: json['storeName'] ?? 'QSR Restaurant',
    storeAddress: json['storeAddress'] ?? 'Main Street, City',
    autoKotOnOrder: json['autoKotOnOrder'] ?? true,
    dineInEnabled: json['dineInEnabled'] ?? false,
  );

  AppSettings copyWith({
    bool? kotEnabled,
    String? storeName,
    String? storeAddress,
    bool? autoKotOnOrder,
    bool? dineInEnabled,
  }) => AppSettings(
    kotEnabled: kotEnabled ?? this.kotEnabled,
    storeName: storeName ?? this.storeName,
    storeAddress: storeAddress ?? this.storeAddress,
    autoKotOnOrder: autoKotOnOrder ?? this.autoKotOnOrder,
    dineInEnabled: dineInEnabled ?? this.dineInEnabled,
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
      MenuItem(
        id: '1', 
        name: 'Samosa', 
        pricing: MenuItemPricing(dineInPrice: 20.0, takeawayPrice: 18.0, deliveryPrice: 25.0), 
        category: 'Snacks', 
        description: 'Crispy triangular pastry with spiced filling'
      ),
      MenuItem(
        id: '2', 
        name: 'Vada Pav', 
        pricing: MenuItemPricing(dineInPrice: 25.0, takeawayPrice: 23.0, deliveryPrice: 30.0), 
        category: 'Snacks', 
        description: 'Mumbai street food with spiced potato fritter'
      ),
      MenuItem(
        id: '3', 
        name: 'Aloo Tikki', 
        pricing: MenuItemPricing(dineInPrice: 30.0, takeawayPrice: 28.0, deliveryPrice: 35.0), 
        category: 'Snacks', 
        description: 'Golden fried potato patties with chutneys'
      ),
      MenuItem(
        id: '4', 
        name: 'Dhokla', 
        pricing: MenuItemPricing(dineInPrice: 35.0, takeawayPrice: 33.0, deliveryPrice: 40.0), 
        category: 'Snacks', 
        description: 'Steamed savory cake from Gujarat'
      ),
      
      // Beverages
      MenuItem(
        id: '5', 
        name: 'Masala Chai', 
        pricing: MenuItemPricing(dineInPrice: 15.0, takeawayPrice: 12.0, deliveryPrice: 18.0), 
        category: 'Beverages', 
        description: 'Traditional Indian spiced tea'
      ),
      MenuItem(
        id: '6', 
        name: 'Filter Coffee', 
        pricing: MenuItemPricing(dineInPrice: 20.0, takeawayPrice: 18.0, deliveryPrice: 25.0), 
        category: 'Beverages', 
        description: 'South Indian style filter coffee'
      ),
      MenuItem(
        id: '7', 
        name: 'Sweet Lassi', 
        pricing: MenuItemPricing(dineInPrice: 40.0, takeawayPrice: 38.0, deliveryPrice: 45.0), 
        category: 'Beverages', 
        description: 'Yogurt-based refreshing drink'
      ),
      MenuItem(
        id: '8', 
        name: 'Fresh Lime Water', 
        pricing: MenuItemPricing(dineInPrice: 25.0, takeawayPrice: 23.0, deliveryPrice: 30.0), 
        category: 'Beverages', 
        description: 'Refreshing lime drink with mint'
      ),
      
      // Main Course
      MenuItem(
        id: '9', 
        name: 'Chole Bhature', 
        pricing: MenuItemPricing(dineInPrice: 80.0, takeawayPrice: 75.0, deliveryPrice: 90.0), 
        category: 'Main Course', 
        description: 'Spiced chickpeas with fried bread'
      ),
      MenuItem(
        id: '10', 
        name: 'Rajma Rice', 
        pricing: MenuItemPricing(dineInPrice: 90.0, takeawayPrice: 85.0, deliveryPrice: 100.0), 
        category: 'Main Course', 
        description: 'Red kidney beans curry with basmati rice'
      ),
      MenuItem(
        id: '11', 
        name: 'Dal Tadka', 
        pricing: MenuItemPricing(dineInPrice: 60.0, takeawayPrice: 55.0, deliveryPrice: 70.0), 
        category: 'Main Course', 
        description: 'Tempered yellow lentils'
      ),
      MenuItem(
        id: '12', 
        name: 'Paneer Butter Masala', 
        pricing: MenuItemPricing(dineInPrice: 120.0, takeawayPrice: 115.0, deliveryPrice: 135.0), 
        category: 'Main Course', 
        description: 'Cottage cheese in rich tomato gravy'
      ),
      
      // Sweets
      MenuItem(
        id: '13', 
        name: 'Gulab Jamun', 
        pricing: MenuItemPricing(dineInPrice: 40.0, takeawayPrice: 38.0, deliveryPrice: 45.0), 
        category: 'Sweets', 
        description: 'Soft milk dumplings in sugar syrup'
      ),
      MenuItem(
        id: '14', 
        name: 'Jalebi', 
        pricing: MenuItemPricing(dineInPrice: 50.0, takeawayPrice: 48.0, deliveryPrice: 55.0), 
        category: 'Sweets', 
        description: 'Crispy spiral sweet soaked in syrup'
      ),
      MenuItem(
        id: '15', 
        name: 'Rasgulla', 
        pricing: MenuItemPricing(dineInPrice: 45.0, takeawayPrice: 43.0, deliveryPrice: 50.0), 
        category: 'Sweets', 
        description: 'Spongy cheese balls in light syrup'
      ),
      
      // Breads
      MenuItem(
        id: '16', 
        name: 'Butter Roti', 
        pricing: MenuItemPricing(dineInPrice: 15.0, takeawayPrice: 13.0, deliveryPrice: 18.0), 
        category: 'Breads', 
        description: 'Soft whole wheat flatbread with butter'
      ),
      MenuItem(
        id: '17', 
        name: 'Garlic Naan', 
        pricing: MenuItemPricing(dineInPrice: 25.0, takeawayPrice: 23.0, deliveryPrice: 30.0), 
        category: 'Breads', 
        description: 'Leavened bread with garlic and herbs'
      ),
      MenuItem(
        id: '18', 
        name: 'Aloo Paratha', 
        pricing: MenuItemPricing(dineInPrice: 30.0, takeawayPrice: 28.0, deliveryPrice: 35.0), 
        category: 'Breads', 
        description: 'Stuffed flatbread with spiced potatoes'
      ),
      MenuItem(
        id: '19', 
        name: 'Butter Kulcha', 
        pricing: MenuItemPricing(dineInPrice: 35.0, takeawayPrice: 33.0, deliveryPrice: 40.0), 
        category: 'Breads', 
        description: 'Soft leavened bread with butter'
      ),
      MenuItem(
        id: '20', 
        name: 'Puri', 
        pricing: MenuItemPricing(dineInPrice: 20.0, takeawayPrice: 18.0, deliveryPrice: 25.0), 
        category: 'Breads', 
        description: 'Deep-fried puffed bread'
      ),
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
  
  OrderType _currentOrderType = OrderType.dineIn;
  
  OrderType get currentOrderType => _currentOrderType;
  
  void setOrderType(OrderType orderType) {
    _currentOrderType = orderType;
    // Clear current order when order type changes as prices may be different
    state = [];
  }

  void addItem(MenuItem menuItem, {int quantity = 1, String? specialInstructions}) {
    final priceForOrderType = menuItem.getPriceForOrderType(_currentOrderType);
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
        price: priceForOrderType,
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

  int get totalItems => state.fold(0, (sum, item) => sum + item.quantity);
  
  double get total => state.fold(0.0, (sum, item) => sum + (item.price * item.quantity));
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

  void addOrder(Order order) {
    state = [order, ...state];
    _saveOrders();
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

  Future<void> toggleDineInEnabled() async {
    state = state.copyWith(dineInEnabled: !state.dineInEnabled);
    await _saveSettings();
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
    final currentOrderNotifier = ref.read(currentOrderProvider.notifier);
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final categories = ['All', ...ref.read(menuProvider.notifier).categories];

    // Determine available order types based on settings
    final availableOrderTypes = <OrderType>[
      if (settings.dineInEnabled) OrderType.dineIn,
      OrderType.takeaway,
      OrderType.delivery,
    ];

    // Ensure current order type is available, default to takeaway if not
    if (!availableOrderTypes.contains(currentOrderNotifier.currentOrderType)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        currentOrderNotifier.setOrderType(OrderType.takeaway);
      });
    }

    final filteredMenu = menu.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      final availableForOrderType = item.isAvailableForOrderType(currentOrderNotifier.currentOrderType);
      return matchesCategory && matchesSearch && availableForOrderType;
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
                      '${currentOrderNotifier.totalItems}',
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
          // Order Type Selector (only show if dine-in is enabled or multiple options available)
          if (availableOrderTypes.length > 1)
            Container(
              margin: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    '${localizations.get('order_type')}: ',
                    style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  Expanded(
                    child: Row(
                      children: availableOrderTypes.map((orderType) {
                        final isSelected = currentOrderNotifier.currentOrderType == orderType;
                        String label;
                        switch (orderType) {
                          case OrderType.dineIn:
                            label = localizations.get('dine_in');
                            break;
                          case OrderType.takeaway:
                            label = localizations.get('takeaway');
                            break;
                          case OrderType.delivery:
                            label = localizations.get('delivery');
                            break;
                        }
                        
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            selected: isSelected,
                            label: Text(label),
                            onSelected: (selected) {
                              if (selected) {
                                ref.read(currentOrderProvider.notifier).setOrderType(orderType);
                              }
                            },
                            selectedColor: Colors.orange.withOpacity(0.2),
                            backgroundColor: Colors.grey.shade100,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          
          // Search Bar
          Container(
            margin: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                                formatCurrency(item.getPriceForOrderType(currentOrderNotifier.currentOrderType)),
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

// Takeaway Place Order Dialog for takeaway-only restaurants
class TakeawayPlaceOrderDialog extends ConsumerStatefulWidget {
  const TakeawayPlaceOrderDialog({super.key});

  @override
  ConsumerState<TakeawayPlaceOrderDialog> createState() => _TakeawayPlaceOrderDialogState();
}

class _TakeawayPlaceOrderDialogState extends ConsumerState<TakeawayPlaceOrderDialog> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);

    if (currentOrder.isEmpty) {
      return AlertDialog(
        title: Text(localizations.get('empty_cart')),
        content: const Text('Please add items to your cart before placing an order.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    final totalAmount = currentOrder.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Row(
                children: [
                  const Icon(Icons.takeout_dining, color: Colors.white, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Takeaway Order',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ...currentOrder.asMap().entries.map((entry) {
                            final item = entry.value;
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: entry.key < currentOrder.length - 1
                                    ? Border(bottom: BorderSide(color: Colors.grey[300]!))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formatCurrency(item.price * item.quantity),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF9933),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  formatCurrency(totalAmount),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9933),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Customer Information
                    const Text(
                      'Customer Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name (Optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _customerPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        labelText: 'Special Instructions',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Place Order Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.takeout_dining),
                  label: Text('Place Takeaway Order - ${formatCurrency(totalAmount)}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _placeOrder(context, totalAmount),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, double totalAmount) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: _generateOrderNumber(),
      items: ref.read(currentOrderProvider),
      total: totalAmount,
      timestamp: DateTime.now(),
      customerName: _customerNameController.text.trim().isEmpty 
          ? 'Takeaway Customer' 
          : _customerNameController.text.trim(),
      customerPhone: _customerPhoneController.text.trim().isEmpty 
          ? null 
          : _customerPhoneController.text.trim(),
      status: OrderStatus.pending,
      orderType: OrderType.takeaway,
      notes: _instructionsController.text.trim().isEmpty 
          ? null 
          : _instructionsController.text.trim(),
    );

    // Add order to orders list
    ref.read(ordersProvider.notifier).addOrder(order);

    // Clear current order
    ref.read(currentOrderProvider.notifier).clearOrder();

    Navigator.pop(context); // Close dialog
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QSRApp()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Takeaway order #${order.orderNumber} placed successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Orders',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()),
            );
          },
        ),
      ),
    );
  }

  String _generateOrderNumber() {
    final now = DateTime.now();
    return 'TO${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _instructionsController.dispose();
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
  
  OrderType? _selectedOrderType;
  String? _selectedSectionId;
  String? _selectedTableId;
  int? _selectedSeatNumber;

  @override
  void initState() {
    super.initState();
    // Initialize with current order type from the global state
    _selectedOrderType = ref.read(currentOrderProvider.notifier).currentOrderType;
  }

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final total = ref.read(currentOrderProvider.notifier).total;
    final tableSections = ref.watch(tablesProvider);

    return AlertDialog(
      title: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(Icons.restaurant, color: Colors.white, size: 28),
            const SizedBox(width: 12),
            Text(
              localizations.get('place_order'),
              style: const TextStyle(
                fontSize: 22, 
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      titlePadding: EdgeInsets.zero,
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.9,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              
              // Order Type Selection
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.orange.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.delivery_dining, color: Color(0xFFFF9933)),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.get('order_type'),
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Order Type Radio Buttons
                      ...OrderType.values.map((orderType) {
                        String label;
                        IconData icon;
                        Color color;
                        switch (orderType) {
                          case OrderType.dineIn:
                            label = localizations.get('dine_in');
                            icon = Icons.table_restaurant;
                            color = Colors.green;
                            break;
                          case OrderType.takeaway:
                            label = localizations.get('takeaway');
                            icon = Icons.shopping_bag;
                            color = Colors.blue;
                            break;
                          case OrderType.delivery:
                            label = localizations.get('delivery');
                            icon = Icons.delivery_dining;
                            color = Colors.purple;
                            break;
                        }
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _selectedOrderType == orderType 
                                ? color 
                                : Colors.grey.shade300,
                              width: 2,
                            ),
                            color: _selectedOrderType == orderType 
                              ? color.withOpacity(0.1) 
                              : Colors.white,
                          ),
                          child: RadioListTile<OrderType>(
                            value: orderType,
                            groupValue: _selectedOrderType,
                            onChanged: (value) {
                              setState(() {
                                _selectedOrderType = value!;
                                // Reset table selection when order type changes
                                _selectedSectionId = null;
                                _selectedTableId = null;
                                _selectedSeatNumber = null;
                              });
                            },
                            title: Row(
                              children: [
                                Icon(icon, color: color, size: 24),
                                const SizedBox(width: 12),
                                Text(
                                  label,
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16,
                                    color: _selectedOrderType == orderType 
                                      ? color 
                                      : Colors.grey.shade700,
                                  ),
                                ),
                              ],
                            ),
                            activeColor: color,
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                ),
              ),
              
              // Table Selection (only for dine-in)
              if ((_selectedOrderType ?? OrderType.takeaway) == OrderType.dineIn) ...[
                const SizedBox(height: 20),
                Card(
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Colors.green.shade50, Colors.white],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.green.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: const Icon(Icons.table_restaurant, color: Colors.green),
                            ),
                            const SizedBox(width: 12),
                            Text(
                              localizations.get('table_management'),
                              style: const TextStyle(
                                fontSize: 18, 
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF333333),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        // Section Selection
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: Colors.green.shade300),
                            color: Colors.white,
                          ),
                          child: DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: localizations.get('select_section'),
                              prefixIcon: const Icon(Icons.business, color: Colors.green),
                              border: InputBorder.none,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            ),
                            value: _selectedSectionId,
                            items: tableSections
                                .where((section) => section.orderType == OrderType.dineIn)
                                .map((section) => DropdownMenuItem(
                                  value: section.id,
                                  child: Text(section.name),
                                )).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedSectionId = value;
                                _selectedTableId = null;
                                _selectedSeatNumber = null;
                              });
                            },
                          ),
                        ),
                        
                        if (_selectedSectionId != null) ...[
                          const SizedBox(height: 16),
                          
                          // Table Selection
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300),
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                labelText: localizations.get('select_table'),
                                prefixIcon: const Icon(Icons.table_restaurant, color: Colors.green),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              value: _selectedTableId,
                              items: tableSections
                                  .firstWhere((section) => section.id == _selectedSectionId)
                                  .tables
                                  .where((table) => table.status == TableStatus.available)
                                  .map((table) => DropdownMenuItem(
                                    value: table.id,
                                    child: Row(
                                      children: [
                                        Icon(Icons.table_restaurant, 
                                          color: Colors.green.shade700, size: 20),
                                        const SizedBox(width: 8),
                                        Text('${localizations.get('table')} ${table.number}'),
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: Colors.green.shade100,
                                            borderRadius: BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '${table.seatCount} ${localizations.get('seat')}s',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.green.shade700,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTableId = value;
                                  _selectedSeatNumber = null;
                                });
                              },
                            ),
                          ),
                        ],
                        
                        if (_selectedTableId != null) ...[
                          const SizedBox(height: 16),
                          
                          // Seat Selection
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: Colors.green.shade300),
                              color: Colors.white,
                            ),
                            child: DropdownButtonFormField<int>(
                              decoration: InputDecoration(
                                labelText: localizations.get('select_seat'),
                                prefixIcon: const Icon(Icons.chair, color: Colors.green),
                                border: InputBorder.none,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                              ),
                              value: _selectedSeatNumber,
                              items: List.generate(
                                tableSections
                                    .firstWhere((section) => section.id == _selectedSectionId)
                                    .tables
                                    .firstWhere((table) => table.id == _selectedTableId)
                                    .seatCount,
                                (index) => DropdownMenuItem(
                                  value: index + 1,
                                  child: Row(
                                    children: [
                                      Icon(Icons.chair, color: Colors.green.shade700, size: 20),
                                      const SizedBox(width: 8),
                                      Text('${localizations.get('seat')} ${index + 1}'),
                                    ],
                                  ),
                                ),
                              ).toList(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedSeatNumber = value;
                                });
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
              
              const SizedBox(height: 20),
              
              // Order Summary
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.blue.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.receipt_long, color: Colors.blue),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.get('order_summary'),
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      ...currentOrder.map((item) => Container(
                        margin: const EdgeInsets.only(bottom: 8),
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: Colors.grey.shade200),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade100,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Center(
                                child: Text(
                                  '${item.quantity}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9933),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item.name,
                                style: const TextStyle(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Text(
                              formatCurrency(item.price * item.quantity),
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      )),
                      
                      const Divider(thickness: 2),
                      
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              localizations.get('total'),
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              formatCurrency(total),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 20),
              
              // Customer Information
              Card(
                elevation: 6,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.purple.shade50, Colors.white],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.purple.shade100,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.person, color: Colors.purple),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            localizations.get('customer_info'),
                            style: const TextStyle(
                              fontSize: 18, 
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF333333),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _customerNameController,
                        decoration: InputDecoration(
                          labelText: localizations.get('customer_name'),
                          prefixIcon: const Icon(Icons.person_outline, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.purple.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.purple, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _phoneController,
                        decoration: InputDecoration(
                          labelText: localizations.get('phone'),
                          prefixIcon: const Icon(Icons.phone_outlined, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.purple.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.purple, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        keyboardType: TextInputType.phone,
                      ),
                      const SizedBox(height: 16),
                      
                      TextField(
                        controller: _notesController,
                        decoration: InputDecoration(
                          labelText: localizations.get('special_instructions'),
                          prefixIcon: const Icon(Icons.note_outlined, color: Colors.purple),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.purple.shade300),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Colors.purple, width: 2),
                          ),
                          filled: true,
                          fillColor: Colors.white,
                        ),
                        maxLines: 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () => _placeOrder(),
          child: const Text('Place Order'),
        ),
      ],
    );
  }

  Future<void> _placeOrder() async {
    final currentOrder = ref.read(currentOrderProvider);
    final settings = ref.read(settingsProvider);
    
    if (currentOrder.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No items in cart'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate table selection for dine-in orders
    if ((_selectedOrderType ?? OrderType.takeaway) == OrderType.dineIn && _selectedTableId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a table for dine-in orders'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    // Use "Walk-in Customer" as default if no name provided
    final customerName = _customerNameController.text.isNotEmpty 
        ? _customerNameController.text 
        : 'Walk-in Customer';

    final orderNumber = await ref.read(ordersProvider.notifier).placeOrder(
      currentOrder,
      customerName,
      customerPhone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
      orderType: _selectedOrderType ?? OrderType.takeaway,
      sectionId: _selectedSectionId,
      tableId: _selectedTableId,
      seatNumber: _selectedSeatNumber,
    );

    // Auto-trigger KOT if enabled in settings
    if (settings.kotEnabled && settings.autoKotOnOrder) {
      final orders = ref.read(ordersProvider);
      final placedOrder = orders.firstWhere((order) => order.orderNumber == orderNumber);
      await _autoTriggerKOT(placedOrder);
    }

    ref.read(currentOrderProvider.notifier).clearOrder();
    
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order placed successfully: #$orderNumber${settings.kotEnabled && settings.autoKotOnOrder ? ' (KOT sent)' : ''}'),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _autoTriggerKOT(Order order) async {
    // Auto-generate and "print" KOT
    final kotContent = _generateKOTContent(order);
    
    // In a real app, this would automatically send to printer
    // For now, we'll just log it or show a brief indication
    debugPrint('KOT Auto-Generated for Order ${order.orderNumber}:\n$kotContent');
  }

  String _generateKOTContent(Order order) {
    final buffer = StringBuffer();
    
    buffer.writeln('=============================');
    buffer.writeln('    KITCHEN ORDER TICKET');
    buffer.writeln('=============================');
    buffer.writeln('Order #: ${order.orderNumber}');
    buffer.writeln('Date: ${DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)}');
    buffer.writeln('Customer: ${order.customerName}');
    if (order.customerPhone != null) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    buffer.writeln('-----------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.name}');
      if (item.specialInstructions != null) {
        buffer.writeln('   Note: ${item.specialInstructions}');
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

  @override
  void dispose() {
    _customerNameController.dispose();
    _phoneController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}

// Orders Screen
class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final pendingOrders = orders.where((order) => 
        order.status == OrderStatus.pending || order.status == OrderStatus.preparing).toList();
    final completedOrders = orders.where((order) => 
        order.status == OrderStatus.ready || order.status == OrderStatus.completed).toList();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(localizations.get('orders')),
          bottom: const TabBar(
            tabs: [
              Tab(text: 'Active'),
              Tab(text: 'Completed'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrdersList(context, ref, pendingOrders, showStatusUpdate: true),
            _buildOrdersList(context, ref, completedOrders, showStatusUpdate: false),
          ],
        ),
      ),
    );
  }

  Widget _buildOrdersList(BuildContext context, WidgetRef ref, List<Order> orders, {required bool showStatusUpdate}) {
    if (orders.isEmpty) {
      return const Center(
        child: Text(
          'No orders found',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return Card(
          margin: const EdgeInsets.only(bottom: 16),
          child: ExpansionTile(
            leading: CircleAvatar(
              backgroundColor: getStatusColor(order.status),
              child: Text(
                order.orderNumber.substring(3, 5),
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ),
            title: Text(formatOrderNumber(order.orderNumber)),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(order.customerName),
                Text(getStatusText(order.status)),
                Text(DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)),
              ],
            ),
            trailing: Text(
              formatCurrency(order.total),
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...order.items.map((item) => Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text('${item.quantity}x ${item.name}'),
                          ),
                          Text(formatCurrency(item.total)),
                        ],
                      ),
                    )),
                    if (order.notes?.isNotEmpty == true) ...[
                      const Divider(),
                      Text('Notes: ${order.notes}'),
                    ],
                    if (showStatusUpdate) ...[
                      const Divider(),
                      const Text(
                        'Order Status',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          if (order.status == OrderStatus.pending)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.play_arrow),
                              label: const Text('Start Preparing'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier)
                                    .updateOrderStatus(order.id, OrderStatus.preparing);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} started'),
                                    backgroundColor: Colors.blue,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          if (order.status == OrderStatus.preparing)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Mark Ready'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier).markOrderReady(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} is ready!'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          if (order.status == OrderStatus.ready)
                            ElevatedButton.icon(
                              icon: const Icon(Icons.done_all),
                              label: const Text('Complete'),
                              onPressed: () {
                                ref.read(ordersProvider.notifier).markOrderCompleted(order.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Order ${order.orderNumber} completed!'),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton.icon(
                            icon: const Icon(Icons.edit),
                            label: const Text('Edit'),
                            onPressed: ref.read(ordersProvider.notifier).canUpdateOrder(order.id)
                                ? () => _showEditOrderDialog(context, ref, order)
                                : null,
                          ),
                          OutlinedButton.icon(
                            icon: const Icon(Icons.cancel),
                            label: const Text('Cancel'),
                            onPressed: () => _showCancelOrderDialog(context, ref, order),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showEditOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    if (!ref.read(ordersProvider.notifier).canUpdateOrder(order.id)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('This order cannot be edited as it is already completed'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => EditOrderDialog(order: order),
    );
  }

  void _showCancelOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel order ${order.orderNumber}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(ordersProvider.notifier)
                  .updateOrderStatus(order.id, OrderStatus.cancelled);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order ${order.orderNumber} cancelled'),
                  backgroundColor: Colors.orange,
                ),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }
}

// Edit Order Dialog
class EditOrderDialog extends ConsumerStatefulWidget {
  final Order order;

  const EditOrderDialog({super.key, required this.order});

  @override
  ConsumerState<EditOrderDialog> createState() => _EditOrderDialogState();
}

class _EditOrderDialogState extends ConsumerState<EditOrderDialog> {
  late TextEditingController _customerNameController;
  late TextEditingController _phoneController;
  late TextEditingController _notesController;
  late List<OrderItem> _editableItems;

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.order.customerName);
    _phoneController = TextEditingController(text: widget.order.customerPhone ?? '');
    _notesController = TextEditingController(text: widget.order.notes ?? '');
    _editableItems = List.from(widget.order.items);
  }

  @override
  Widget build(BuildContext context) {
    final total = _editableItems.fold(0.0, (sum, item) => sum + item.total);

    return AlertDialog(
      title: Text('Edit Order ${widget.order.orderNumber}'),
      content: SingleChildScrollView(
        child: SizedBox(
          width: MediaQuery.of(context).size.width * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Items
              const Text(
                'Order Items',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    ..._editableItems.asMap().entries.map((entry) {
                      final index = entry.key;
                      final item = entry.value;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text('${item.name} - ${formatCurrency(item.price)}'),
                            ),
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: item.quantity > 1
                                  ? () => _updateItemQuantity(index, item.quantity - 1)
                                  : null,
                            ),
                            Text('${item.quantity}'),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: () => _updateItemQuantity(index, item.quantity + 1),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => _removeItem(index),
                            ),
                          ],
                        ),
                      );
                    }),
                    const Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Total:',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          formatCurrency(total),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              
              // Add New Item Button
              ElevatedButton.icon(
                onPressed: () => _showAddItemDialog(),
                icon: const Icon(Icons.add),
                label: const Text('Add Item'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
              const SizedBox(height: 16),
              
              // Customer Information
              TextField(
                controller: _customerNameController,
                decoration: const InputDecoration(
                  labelText: 'Customer Name',
                  prefixIcon: Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _phoneController,
                decoration: const InputDecoration(
                  labelText: 'Phone Number',
                  prefixIcon: Icon(Icons.phone),
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              
              TextField(
                controller: _notesController,
                decoration: const InputDecoration(
                  labelText: 'Special Instructions',
                  prefixIcon: Icon(Icons.note),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton.icon(
          icon: const Icon(Icons.save),
          label: const Text('Update Order'),
          onPressed: _editableItems.isNotEmpty ? () => _updateOrder() : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _updateItemQuantity(int index, int newQuantity) {
    setState(() {
      _editableItems[index] = _editableItems[index].copyWith(quantity: newQuantity);
    });
  }

  void _removeItem(int index) {
    setState(() {
      _editableItems.removeAt(index);
    });
  }

  void _showAddItemDialog() {
    final menuItems = ref.read(menuProvider);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item to Order'),
        content: SizedBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: MediaQuery.of(context).size.height * 0.6,
          child: ListView.builder(
            itemCount: menuItems.length,
            itemBuilder: (context, index) {
              final item = menuItems[index];
              if (!item.isAvailable) return Container();
              
              return Card(
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (item.description?.isNotEmpty == true)
                        Text(item.description!),
                      Text('${formatCurrency(item.price)} • ${item.category}'),
                    ],
                  ),
                  trailing: ElevatedButton(
                    onPressed: () {
                      _addItemToOrder(item);
                      Navigator.pop(context);
                    },
                    child: const Text('Add'),
                  ),
                ),
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _addItemToOrder(MenuItem item) {
    setState(() {
      // Check if item already exists
      final existingIndex = _editableItems.indexWhere(
        (orderItem) => orderItem.name == item.name,
      );
      
      if (existingIndex != -1) {
        // Increase quantity if item exists
        _editableItems[existingIndex] = _editableItems[existingIndex].copyWith(
          quantity: _editableItems[existingIndex].quantity + 1,
        );
      } else {
        // Add new item
        _editableItems.add(OrderItem(
          menuItemId: item.id,
          name: item.name,
          price: item.price,
          quantity: 1,
        ));
      }
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${item.name} added to order'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 1),
      ),
    );
  }

  Future<void> _updateOrder() async {
    if (_editableItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order must have at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final customerName = _customerNameController.text.isNotEmpty 
        ? _customerNameController.text 
        : 'Walk-in Customer';

    await ref.read(ordersProvider.notifier).updateOrder(
      widget.order.id,
      _editableItems,
      customerName,
      customerPhone: _phoneController.text.isNotEmpty ? _phoneController.text : null,
      notes: _notesController.text.isNotEmpty ? _notesController.text : null,
    );

    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Text('Order ${widget.order.orderNumber} updated successfully'),
          ],
        ),
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

// KOT Screen (Kitchen Order Ticket)
class KOTScreen extends ConsumerWidget {
  const KOTScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final activeOrders = orders.where((order) => 
        order.status == OrderStatus.pending || order.status == OrderStatus.preparing).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('kitchen_order_ticket')),
        actions: [
          IconButton(
            icon: const Icon(Icons.bluetooth),
            onPressed: () => _showPrinterSettings(context, ref),
          ),
        ],
      ),
      body: activeOrders.isEmpty
          ? const Center(
              child: Text(
                'No active orders',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: activeOrders.length,
              itemBuilder: (context, index) {
                final order = activeOrders[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
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
                              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.print),
                              label: const Text('Print KOT'),
                              onPressed: () => _printKOT(context, ref, order),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text('Customer: ${order.customerName}'),
                        Text('Time: ${DateFormat('HH:mm dd/MM').format(order.timestamp)}'),
                        if (order.customerPhone != null)
                          Text('Phone: ${order.customerPhone}'),
                        const Divider(),
                        ...order.items.map((item) => Padding(
                          padding: const EdgeInsets.only(bottom: 4),
                          child: Row(
                            children: [
                              Container(
                                width: 30,
                                height: 30,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primary,
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                child: Center(
                                  child: Text(
                                    '${item.quantity}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.name,
                                      style: const TextStyle(fontWeight: FontWeight.w500),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )),
                        if (order.notes?.isNotEmpty == true) ...[
                          const Divider(),
                          Text(
                            'Special Instructions: ${order.notes}',
                            style: const TextStyle(
                              fontStyle: FontStyle.italic,
                              color: Colors.red,
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

  void _showPrinterSettings(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Printer Settings'),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Connect to Bluetooth Printer'),
            SizedBox(height: 16),
            Text('Available Printers:'),
            // TODO: Implement Bluetooth printer discovery
            ListTile(
              leading: Icon(Icons.bluetooth),
              title: Text('No printers found'),
              subtitle: Text('Searching...'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _printKOT(BuildContext context, WidgetRef ref, Order order) {
    // TODO: Implement actual printing to thermal printer
    final kotContent = _generateKOTContent(order);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('KOT Preview'),
        content: SingleChildScrollView(
          child: Text(
            kotContent,
            style: const TextStyle(fontFamily: 'monospace'),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('KOT sent to printer'),
                ),
              );
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _generateKOTContent(Order order) {
    final buffer = StringBuffer();
    buffer.writeln('================================');
    buffer.writeln('       KITCHEN ORDER TICKET');
    buffer.writeln('================================');
    buffer.writeln('Order: ${order.orderNumber}');
    buffer.writeln('Time: ${DateFormat('dd/MM/yyyy HH:mm').format(order.timestamp)}');
    buffer.writeln('Customer: ${order.customerName}');
    if (order.customerPhone != null) {
      buffer.writeln('Phone: ${order.customerPhone}');
    }
    buffer.writeln('--------------------------------');
    
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.name}');
      if (item.specialInstructions?.isNotEmpty == true) {
        buffer.writeln('   * ${item.specialInstructions}');
      }
      buffer.writeln('');
    }
    
    if (order.notes?.isNotEmpty == true) {
      buffer.writeln('--------------------------------');
      buffer.writeln('Special Instructions:');
      buffer.writeln(order.notes);
    }
    
    buffer.writeln('================================');
    return buffer.toString();
  }
}

// Table Management Screen
class TableManagementScreen extends ConsumerWidget {
  const TableManagementScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tables = ref.watch(tablesProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    
    // Group sections by order type
    final dineInSections = tables.where((s) => s.orderType == OrderType.dineIn).toList();
    final takeawaySections = tables.where((s) => s.orderType == OrderType.takeaway).toList();
    final deliverySections = tables.where((s) => s.orderType == OrderType.delivery).toList();
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('table_management')),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddSectionDialog(context, ref, localizations),
          ),
        ],
      ),
      body: tables.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_restaurant, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No tables configured',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => _showAddSectionDialog(context, ref, localizations),
                    icon: const Icon(Icons.add),
                    label: Text(localizations.get('add_section')),
                  ),
                ],
              ),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dine-In Sections
                  if (dineInSections.isNotEmpty) ...[
                    _buildOrderTypeHeader(localizations.get('dine_in'), OrderType.dineIn, context, ref, localizations),
                    ...dineInSections.map((section) => _buildSectionCard(section, context, ref, localizations)),
                    const SizedBox(height: 24),
                  ],
                  
                  // Takeaway Sections
                  if (takeawaySections.isNotEmpty) ...[
                    _buildOrderTypeHeader(localizations.get('takeaway'), OrderType.takeaway, context, ref, localizations),
                    ...takeawaySections.map((section) => _buildSectionCard(section, context, ref, localizations)),
                    const SizedBox(height: 24),
                  ],
                  
                  // Delivery Sections
                  if (deliverySections.isNotEmpty) ...[
                    _buildOrderTypeHeader(localizations.get('delivery'), OrderType.delivery, context, ref, localizations),
                    ...deliverySections.map((section) => _buildSectionCard(section, context, ref, localizations)),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildOrderTypeHeader(String title, OrderType orderType, BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    Color getOrderTypeColor(OrderType type) {
      switch (type) {
        case OrderType.dineIn:
          return Colors.blue;
        case OrderType.takeaway:
          return Colors.green;
        case OrderType.delivery:
          return Colors.orange;
      }
    }
    
    final color = getOrderTypeColor(orderType);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color.withOpacity(0.1), color.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(
            orderType == OrderType.dineIn ? Icons.restaurant :
            orderType == OrderType.takeaway ? Icons.takeout_dining :
            Icons.delivery_dining,
            color: color,
            size: 24,
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const Spacer(),
          TextButton.icon(
            onPressed: () => _showAddSectionDialog(context, ref, localizations, orderType),
            icon: Icon(Icons.add, color: color),
            label: Text(
              localizations.get('add_section'),
              style: TextStyle(color: color),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionCard(TableSection section, BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    Color getOrderTypeColor(OrderType type) {
      switch (type) {
        case OrderType.dineIn:
          return Colors.blue;
        case OrderType.takeaway:
          return Colors.green;
        case OrderType.delivery:
          return Colors.orange;
      }
    }
    
    final color = getOrderTypeColor(section.orderType);
    
    return Card(
      elevation: 4,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [Colors.white, color.withOpacity(0.02)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: ExpansionTile(
          leading: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              section.orderType == OrderType.dineIn ? Icons.restaurant :
              section.orderType == OrderType.takeaway ? Icons.takeout_dining :
              Icons.delivery_dining,
              color: color,
              size: 20,
            ),
          ),
          title: Text(
            section.name,
            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
          ),
          subtitle: Text('${section.tables.length} tables'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: Icon(Icons.add_circle_outline, color: color),
                onPressed: () => _showAddTableDialog(context, ref, section.id, localizations),
              ),
              PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit Section'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete Section'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDeleteSection(context, ref, section.id, localizations);
                  }
                },
              ),
            ],
          ),
          children: section.tables.map((table) {
            final isOccupied = table.status == TableStatus.occupied;
            return ListTile(
              leading: CircleAvatar(
                backgroundColor: isOccupied 
                    ? Colors.red.shade400 
                    : Colors.green.shade400,
                child: Text(
                  table.number.toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text('Table ${table.number}'),
              subtitle: Text(
                isOccupied ? 'Occupied' : 'Available',
                style: TextStyle(
                  color: isOccupied ? Colors.red : Colors.green,
                ),
              ),
              trailing: PopupMenuButton(
                itemBuilder: (context) => [
                  PopupMenuItem(
                    value: 'edit',
                    child: Row(
                      children: [
                        Icon(Icons.edit, color: Colors.blue),
                        SizedBox(width: 8),
                        Text('Edit'),
                      ],
                    ),
                  ),
                  PopupMenuItem(
                    value: 'delete',
                    child: Row(
                      children: [
                        Icon(Icons.delete, color: Colors.red),
                        SizedBox(width: 8),
                        Text('Delete'),
                      ],
                    ),
                  ),
                ],
                onSelected: (value) {
                  if (value == 'delete') {
                    _confirmDeleteTable(context, ref, section.id, table.id, localizations);
                  }
                },
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  void _showAddSectionDialog(BuildContext context, WidgetRef ref, AppLocalizations localizations, [OrderType? defaultOrderType]) {
    final nameController = TextEditingController();
    OrderType selectedOrderType = defaultOrderType ?? OrderType.dineIn;
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(localizations.get('add_section')),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: localizations.get('section_name'),
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 16),
              DropdownButtonFormField<OrderType>(
                value: selectedOrderType,
                decoration: InputDecoration(
                  labelText: localizations.get('order_type'),
                  border: OutlineInputBorder(),
                ),
                items: OrderType.values.map((type) {
                  String typeName;
                  switch (type) {
                    case OrderType.dineIn:
                      typeName = localizations.get('dine_in');
                      break;
                    case OrderType.takeaway:
                      typeName = localizations.get('takeaway');
                      break;
                    case OrderType.delivery:
                      typeName = localizations.get('delivery');
                      break;
                  }
                  return DropdownMenuItem(
                    value: type,
                    child: Text(typeName),
                  );
                }).toList(),
                onChanged: (value) {
                  if (value != null) {
                    setState(() {
                      selectedOrderType = value;
                    });
                  }
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(localizations.get('cancel')),
            ),
            ElevatedButton(
              onPressed: () {
                if (nameController.text.isNotEmpty) {
                  ref.read(tablesProvider.notifier).addSection(
                    nameController.text,
                    selectedOrderType,
                  );
                  Navigator.pop(context);
                }
              },
              child: Text(localizations.get('add')),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddTableDialog(BuildContext context, WidgetRef ref, String sectionId, AppLocalizations localizations) {
    final numberController = TextEditingController();
    final seatCountController = TextEditingController(text: '4');
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('add_table')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: numberController,
              decoration: InputDecoration(
                labelText: localizations.get('table_number'),
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: seatCountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: localizations.get('seat_count'),
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('cancel')),
          ),
          ElevatedButton(
            onPressed: () {
              final number = numberController.text;
              final seatCount = int.tryParse(seatCountController.text) ?? 4;
              if (number.isNotEmpty) {
                ref.read(tablesProvider.notifier).addTable(sectionId, number, seatCount);
                Navigator.pop(context);
              }
            },
            child: Text(localizations.get('add')),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteSection(BuildContext context, WidgetRef ref, String sectionId, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('confirm_delete')),
        content: Text(localizations.get('delete_section_warning')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(tablesProvider.notifier).removeSection(sectionId);
              Navigator.pop(context);
            },
            child: Text(localizations.get('delete')),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteTable(BuildContext context, WidgetRef ref, String sectionId, String tableId, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('confirm_delete')),
        content: Text(localizations.get('delete_table_warning')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('cancel')),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () {
              ref.read(tablesProvider.notifier).removeTable(tableId);
              Navigator.pop(context);
            },
            child: Text(localizations.get('delete')),
          ),
        ],
      ),
    );
  }

  Color _getTableStatusColor(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Colors.green;
      case TableStatus.occupied:
        return Colors.red;
      case TableStatus.reserved:
        return Colors.orange;
      case TableStatus.cleaning:
        return Colors.grey;
      case TableStatus.outOfOrder:
        return Colors.grey;
    }
  }

  IconData _getTableStatusIcon(TableStatus status) {
    switch (status) {
      case TableStatus.available:
        return Icons.check_circle;
      case TableStatus.occupied:
        return Icons.person;
      case TableStatus.reserved:
        return Icons.schedule;
      case TableStatus.cleaning:
        return Icons.cleaning_services;
      case TableStatus.outOfOrder:
        return Icons.build;
    }
  }

  void _showTableDetails(BuildContext context, WidgetRef ref, RestaurantTable table) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(table.number),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Seats: ${table.seatCount}'),
            Text('Status: ${table.status.name}'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Order Details Screen
class OrderDetailsScreen extends ConsumerWidget {
  final String orderId;
  
  const OrderDetailsScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Details'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text('Order Details for: $orderId'),
      ),
    );
  }
}

// Table Selection Screen
class TableSelectionScreen extends ConsumerStatefulWidget {
  const TableSelectionScreen({super.key});

  @override
  ConsumerState<TableSelectionScreen> createState() => _TableSelectionScreenState();
}

class _TableSelectionScreenState extends ConsumerState<TableSelectionScreen> {
  String? _selectedSectionId;
  String? _selectedTableId;

  @override
  Widget build(BuildContext context) {
    final tableSections = ref.watch(tablesProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);

    // Filter sections for dine-in only
    final dineInSections = tableSections.where((section) => section.orderType == OrderType.dineIn).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('table_selection')),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: dineInSections.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.table_restaurant, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No dine-in tables configured',
                    style: const TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Go Back'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dineInSections.length,
              itemBuilder: (context, sectionIndex) {
                final section = dineInSections[sectionIndex];
                final availableTables = section.tables.where((table) => table.status == TableStatus.available).toList();
                
                return Card(
                  elevation: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ExpansionTile(
                    title: Text(
                      section.name,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                    ),
                    subtitle: Text('${availableTables.length} available tables'),
                    leading: Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.orange.withOpacity(0.3),
                            blurRadius: 8,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: const Icon(Icons.table_restaurant, color: Colors.white),
                    ),
                    children: [
                      if (availableTables.isEmpty)
                        const Padding(
                          padding: EdgeInsets.all(16),
                          child: Text(
                            'No available tables in this section',
                            style: TextStyle(color: Colors.grey),
                            textAlign: TextAlign.center,
                          ),
                        )
                      else
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 3,
                              childAspectRatio: 1.2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 12,
                            ),
                            itemCount: availableTables.length,
                            itemBuilder: (context, tableIndex) {
                              final table = availableTables[tableIndex];
                              final isSelected = _selectedSectionId == section.id && _selectedTableId == table.id;
                              
                              return Card(
                                elevation: isSelected ? 8 : 2,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                color: isSelected ? const Color(0xFFFF9933) : Colors.green,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(8),
                                  onTap: () {
                                    setState(() {
                                      _selectedSectionId = section.id;
                                      _selectedTableId = table.id;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(8),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          isSelected ? Icons.check_circle : Icons.table_restaurant,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          table.number,
                                          style: const TextStyle(
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white,
                                            fontSize: 12,
                                          ),
                                          textAlign: TextAlign.center,
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${table.seatCount} seats',
                                          style: const TextStyle(
                                            color: Colors.white70,
                                            fontSize: 10,
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
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: _selectedTableId != null
          ? Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 4,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: SafeArea(
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu),
                  label: const Text('Proceed to Menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    // Store selected table info and navigate to menu
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MenuWithTableScreen(
                          sectionId: _selectedSectionId!,
                          tableId: _selectedTableId!,
                        ),
                      ),
                    );
                  },
                ),
              ),
            )
          : null,
    );
  }
}

// Menu Screen with Pre-selected Table for Dine-in
class MenuWithTableScreen extends ConsumerStatefulWidget {
  final String sectionId;
  final String tableId;

  const MenuWithTableScreen({
    super.key,
    required this.sectionId,
    required this.tableId,
  });

  @override
  ConsumerState<MenuWithTableScreen> createState() => _MenuWithTableScreenState();
}

class _MenuWithTableScreenState extends ConsumerState<MenuWithTableScreen> {
  String _selectedCategory = 'All';
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    final tableSections = ref.watch(tablesProvider);

    // Get selected table info for display
    final selectedSection = tableSections.firstWhere((section) => section.id == widget.sectionId);
    final selectedTable = selectedSection.tables.firstWhere((table) => table.id == widget.tableId);

    // Filter menu items
    List<MenuItem> filteredMenu = menu.where((item) {
      final matchesCategory = _selectedCategory == 'All' || item.category == _selectedCategory;
      final matchesSearch = _searchQuery.isEmpty || 
          item.name.toLowerCase().contains(_searchQuery.toLowerCase());
      return matchesCategory && matchesSearch;
    }).toList();

    // Get unique categories
    final categories = ['All', ...menu.map((item) => item.category).toSet().toList()];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(localizations.get('menu')),
            Text(
              '${selectedSection.name} - ${selectedTable.number}',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
            ),
          ],
        ),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        actions: [
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_cart),
                onPressed: () => _showCart(context),
              ),
              if (currentOrder.isNotEmpty)
                Positioned(
                  right: 8,
                  top: 8,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 14,
                      minHeight: 14,
                    ),
                    child: Text(
                      '${currentOrder.fold(0, (sum, item) => sum + item.quantity)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 8,
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
          // Search Bar
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: localizations.get('search_menu'),
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[100],
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          
          // Category Filter
          Container(
            height: 60,
            padding: const EdgeInsets.symmetric(vertical: 8),
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
                    label: Text(category),
                    selected: isSelected,
                    onSelected: (selected) {
                      setState(() {
                        _selectedCategory = category;
                      });
                    },
                    backgroundColor: Colors.grey[200],
                    selectedColor: const Color(0xFFFF9933),
                    labelStyle: TextStyle(
                      color: isSelected ? Colors.white : Colors.black87,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                );
              },
            ),
          ),
          
          // Menu Items
          Expanded(
            child: filteredMenu.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.search_off, size: 64, color: Colors.grey),
                        const SizedBox(height: 16),
                        Text(
                          'No items found',
                          style: const TextStyle(fontSize: 18, color: Colors.grey),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: filteredMenu.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenu[index];
                      final dineInPrice = item.pricing.dineInPrice;
                      
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.only(bottom: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          title: Text(
                            item.name,
                            style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (item.description?.isNotEmpty == true) ...[
                                const SizedBox(height: 4),
                                Text(
                                  item.description!,
                                  style: TextStyle(color: Colors.grey[600]),
                                ),
                              ],
                              const SizedBox(height: 8),
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFF9933).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      item.category,
                                      style: const TextStyle(
                                        color: Color(0xFFFF9933),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                  const Spacer(),
                                  Text(
                                    formatCurrency(dineInPrice),
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF9933),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          trailing: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.add, color: Colors.white),
                              onPressed: () {
                                ref.read(currentOrderProvider.notifier).addItem(item);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('${item.name} added to cart'),
                                    duration: const Duration(seconds: 1),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),
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
              onPressed: () => _showCart(context),
              backgroundColor: const Color(0xFFFF9933),
              icon: const Icon(Icons.shopping_cart, color: Colors.white),
              label: Text(
                '${currentOrder.fold(0, (sum, item) => sum + item.quantity)} items',
                style: const TextStyle(color: Colors.white),
              ),
            )
          : null,
    );
  }

  void _showCart(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => DineInPlaceOrderDialog(
        sectionId: widget.sectionId,
        tableId: widget.tableId,
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

// Dine-in Place Order Dialog with Pre-selected Table
class DineInPlaceOrderDialog extends ConsumerStatefulWidget {
  final String sectionId;
  final String tableId;

  const DineInPlaceOrderDialog({
    super.key,
    required this.sectionId,
    required this.tableId,
  });

  @override
  ConsumerState<DineInPlaceOrderDialog> createState() => _DineInPlaceOrderDialogState();
}

class _DineInPlaceOrderDialogState extends ConsumerState<DineInPlaceOrderDialog> {
  final _customerNameController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _instructionsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final currentOrder = ref.watch(currentOrderProvider);
    final tableSections = ref.watch(tablesProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);

    if (currentOrder.isEmpty) {
      return AlertDialog(
        title: Text(localizations.get('empty_cart')),
        content: const Text('Please add items to your cart before placing an order.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      );
    }

    // Get table info
    final selectedSection = tableSections.firstWhere((section) => section.id == widget.sectionId);
    final selectedTable = selectedSection.tables.firstWhere((table) => table.id == widget.tableId);

    final totalAmount = currentOrder.fold(0.0, (sum, item) => sum + (item.price * item.quantity));

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFF9933), Color(0xFFFF7700)],
                ),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      const Icon(Icons.table_restaurant, color: Colors.white, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          'Dine-in Order',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '${selectedSection.name} - ${selectedTable.number}',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w500),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Order Summary
                    const Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Column(
                        children: [
                          ...currentOrder.asMap().entries.map((entry) {
                            final item = entry.value;
                            return Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                border: entry.key < currentOrder.length - 1
                                    ? Border(bottom: BorderSide(color: Colors.grey[300]!))
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          item.name,
                                          style: const TextStyle(fontWeight: FontWeight.w500),
                                        ),
                                        Text(
                                          'Qty: ${item.quantity}',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Text(
                                    formatCurrency(item.price * item.quantity),
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFFFF9933),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.grey[50],
                              borderRadius: const BorderRadius.only(
                                bottomLeft: Radius.circular(8),
                                bottomRight: Radius.circular(8),
                              ),
                            ),
                            child: Row(
                              children: [
                                const Text(
                                  'Total',
                                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                const Spacer(),
                                Text(
                                  formatCurrency(totalAmount),
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFFF9933),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Customer Information
                    const Text(
                      'Customer Information',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _customerNameController,
                      decoration: InputDecoration(
                        labelText: 'Customer Name (Optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.person),
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _customerPhoneController,
                      decoration: InputDecoration(
                        labelText: 'Phone Number (Optional)',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.phone),
                      ),
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 12),
                    
                    TextField(
                      controller: _instructionsController,
                      decoration: InputDecoration(
                        labelText: 'Special Instructions',
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        prefixIcon: const Icon(Icons.note),
                      ),
                      maxLines: 3,
                    ),
                  ],
                ),
              ),
            ),

            // Place Order Button
            Container(
              padding: const EdgeInsets.all(20),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.restaurant_menu),
                  label: Text('Place Order - ${formatCurrency(totalAmount)}'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFF9933),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () => _placeOrder(context, totalAmount),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _placeOrder(BuildContext context, double totalAmount) {
    final order = Order(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      orderNumber: _generateOrderNumber(),
      items: ref.read(currentOrderProvider),
      total: totalAmount,
      timestamp: DateTime.now(),
      customerName: _customerNameController.text.trim().isEmpty 
          ? 'Walk-in Customer' 
          : _customerNameController.text.trim(),
      customerPhone: _customerPhoneController.text.trim().isEmpty 
          ? null 
          : _customerPhoneController.text.trim(),
      status: OrderStatus.pending,
      orderType: OrderType.dineIn,
      sectionId: widget.sectionId,
      tableId: widget.tableId,
      notes: _instructionsController.text.trim().isEmpty 
          ? null 
          : _instructionsController.text.trim(),
    );

    // Add order to orders list
    ref.read(ordersProvider.notifier).addOrder(order);

    // Update table status to occupied
    ref.read(tablesProvider.notifier).updateTableStatusBySectionAndTable(
      widget.sectionId,
      widget.tableId,
      TableStatus.occupied,
    );

    // Clear current order
    ref.read(currentOrderProvider.notifier).clearOrder();

    Navigator.pop(context); // Close dialog
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => QSRApp()),
      (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #${order.orderNumber} placed successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View Orders',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const OrdersScreen()),
            );
          },
        ),
      ),
    );
  }

  String _generateOrderNumber() {
    final now = DateTime.now();
    return 'ORD${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}';
  }

  @override
  void dispose() {
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);
    final language = ref.watch(languageProvider);
    final localizations = AppLocalizations(language);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.get('settings')),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Language Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.language),
                  title: Text(
                    localizations.get('language'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.translate),
                  title: Text(localizations.get('select_language')),
                  trailing: DropdownButton<AppLanguage>(
                    value: language,
                    underline: Container(),
                    items: [
                      DropdownMenuItem(
                        value: AppLanguage.english,
                        child: Text(localizations.get('english')),
                      ),
                      DropdownMenuItem(
                        value: AppLanguage.hindi,
                        child: Text(localizations.get('hindi')),
                      ),
                    ],
                    onChanged: (AppLanguage? newLanguage) {
                      if (newLanguage != null) {
                        ref.read(languageProvider.notifier).setLanguage(newLanguage);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // KOT Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.receipt_long),
                  title: Text(
                    'KOT Settings',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                SwitchListTile(
                  title: Text(localizations.get('enable_kot')),
                  subtitle: Text(localizations.get('kot_feature_subtitle')),
                  value: settings.kotEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleKotEnabled();
                  },
                ),
                if (settings.kotEnabled)
                  SwitchListTile(
                    title: Text(localizations.get('auto_print_kot')),
                    subtitle: Text(localizations.get('auto_kot_subtitle')),
                    value: settings.autoKotOnOrder,
                    onChanged: (value) {
                      ref.read(settingsProvider.notifier).toggleAutoKotOnOrder();
                    },
                  ),
                SwitchListTile(
                  title: Text(localizations.get('enable_dine_in')),
                  subtitle: Text(localizations.get('dine_in_feature_subtitle')),
                  value: settings.dineInEnabled,
                  onChanged: (value) {
                    ref.read(settingsProvider.notifier).toggleDineInEnabled();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // General Settings Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: Text(
                    localizations.get('general_settings'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.restaurant_menu),
                  title: Text(localizations.get('manage_menu')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showMenuManagement(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.bluetooth),
                  title: Text(localizations.get('printer_settings')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showPrinterSettings(context, ref, localizations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // Reports & Data Section
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.analytics),
                  title: Text(
                    localizations.get('reports_data'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.assessment),
                  title: Text(localizations.get('sales_report')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showSalesReport(context, ref, localizations),
                ),
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: Text(localizations.get('backup_data')),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _showBackupOptions(context, ref, localizations),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          
          // About Section
          Card(
            child: ListTile(
              leading: const Icon(Icons.info),
              title: Text(localizations.get('about')),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () => _showAbout(context, localizations),
            ),
          ),
        ],
      ),
    );
  }

  void _showMenuManagement(BuildContext context, WidgetRef ref) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const MenuManagementScreen()),
    );
  }

  void _showPrinterSettings(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('printer_settings')),
        content: Text(localizations.get('printer_management_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showSalesReport(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    final orders = ref.read(ordersProvider);
    final completedOrders = orders.where((o) => o.status == OrderStatus.completed).toList();
    final totalSales = completedOrders.fold(0.0, (sum, order) => sum + order.total);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('sales_report')),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('${localizations.get('total_orders')}: ${completedOrders.length}'),
            Text('${localizations.get('total_revenue')}: ${formatCurrency(totalSales)}'),
            const SizedBox(height: 16),
            Text('Today: ${DateFormat('dd/MM/yyyy').format(DateTime.now())}'),
            // TODO: Add more detailed analytics
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('close')),
          ),
        ],
      ),
    );
  }

  void _showBackupOptions(BuildContext context, WidgetRef ref, AppLocalizations localizations) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(localizations.get('backup_data')),
        content: Text(localizations.get('backup_restore_msg')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(localizations.get('ok')),
          ),
        ],
      ),
    );
  }

  void _showAbout(BuildContext context, AppLocalizations localizations) {
    showAboutDialog(
      context: context,
      applicationName: localizations.get('app_title'),
      applicationVersion: '1.0.0',
      applicationLegalese: 'Quick Service Restaurant Management App\nDesigned for Indian Restaurants',
      children: [
        Text('\n${localizations.get('features')}:'),
        Text('• ${localizations.get('mobile_first_design')}'),
        Text('• ${localizations.get('offline_support')}'),
        Text('• ${localizations.get('bluetooth_printing')}'),
        Text('• ${localizations.get('currency_formatting')}'),
        Text('• ${localizations.get('multi_language')}'),
      ],
    );
  }
}

// Menu Management Screen
class MenuManagementScreen extends ConsumerStatefulWidget {
  const MenuManagementScreen({super.key});

  @override
  ConsumerState<MenuManagementScreen> createState() => _MenuManagementScreenState();
}

class _MenuManagementScreenState extends ConsumerState<MenuManagementScreen> {
  @override
  Widget build(BuildContext context) {
    final menu = ref.watch(menuProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: menu.length,
        itemBuilder: (context, index) {
          final item = menu[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            child: ListTile(
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${item.category} • ${formatCurrency(item.price)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: item.isAvailable,
                    onChanged: (value) {
                      ref.read(menuProvider.notifier).updateItem(
                        item.copyWith(isAvailable: value),
                      );
                    },
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: 'edit',
                        child: Text('Edit\nसंपादित करें'),
                      ),
                      const PopupMenuItem(
                        value: 'delete',
                        child: Text('Delete\nहटाएं'),
                      ),
                    ],
                    onSelected: (value) {
                      if (value == 'edit') {
                        _showEditItemDialog(context, ref, item);
                      } else if (value == 'delete') {
                        _confirmDelete(context, ref, item);
                      }
                    },
                  ),
                ],
              ),
            ),
          );
        },
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
    final priceController = TextEditingController(text: item?.price.toString() ?? '');
    final categoryController = TextEditingController(text: item?.category ?? '');
    final descriptionController = TextEditingController(text: item?.description ?? '');

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
                decoration: const InputDecoration(
                  labelText: 'Item Name *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(
                  labelText: 'Price (₹) *',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category *',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: descriptionController,
                decoration: const InputDecoration(
                  labelText: 'Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 2,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty &&
                  categoryController.text.isNotEmpty) {
                final newItem = MenuItem(
                  id: item?.id ?? const Uuid().v4(),
                  name: nameController.text,
                  pricing: MenuItemPricing(
                    dineInPrice: double.parse(priceController.text),
                    takeawayPrice: double.parse(priceController.text) * 0.9, // 10% discount for takeaway
                    deliveryPrice: double.parse(priceController.text) * 1.1, // 10% markup for delivery
                  ),
                  category: categoryController.text,
                  description: descriptionController.text.isNotEmpty ? descriptionController.text : null,
                );

                if (item == null) {
                  ref.read(menuProvider.notifier).addItem(newItem);
                } else {
                  ref.read(menuProvider.notifier).updateItem(newItem);
                }

                Navigator.pop(context);
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, MenuItem item) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Item'),
        content: Text('Are you sure you want to delete "${item.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(menuProvider.notifier).removeItem(item.id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}
