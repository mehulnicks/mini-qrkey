import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:fl_chart/fl_chart.dart';
import 'kot_screen.dart';

// Multi-language Support
class AppLocalizations {
  final String languageCode;
  
  AppLocalizations(this.languageCode);
  
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'app_title': 'QSR Management',
      'new_order': 'New Order',
      'orders': 'Orders',
      'menu': 'Menu',
      'kot': 'KOT',
      'reports': 'Reports',
      'settings': 'Settings',
      'dine_in': 'Dine In',
      'takeaway': 'Takeaway',
      'delivery': 'Delivery',
      'customer_name': 'Customer Name',
      'customer_phone': 'Phone Number',
      'customer_email': 'Email',
      'customer_address': 'Address',
      'place_order': 'Place Order',
      'order_notes': 'Order Notes',
      'special_instructions': 'Special Instructions',
      'add_item': 'Add Item',
      'edit_item': 'Edit Item',
      'remove_item': 'Remove Item',
      'quantity': 'Quantity',
      'price': 'Price',
      'total': 'Total',
      'subtotal': 'Subtotal',
      'tax': 'Tax',
      'charges': 'Charges',
      'delivery_charge': 'Delivery Charge',
      'packaging_charge': 'Packaging Charge',
      'service_charge': 'Service Charge',
      'grand_total': 'Grand Total',
      'paid_amount': 'Paid Amount',
      'balance': 'Balance',
      'cash': 'Cash',
      'card': 'Card',
      'upi': 'UPI',
      'online': 'Online',
      'payment_method': 'Payment Method',
      'split_payment': 'Split Payment',
      'add_payment': 'Add Payment',
      'print_kot': 'Print KOT',
      'print_bill': 'Print Bill',
      'send_whatsapp': 'Send WhatsApp',
      'cancel_order': 'Cancel Order',
      'edit_order': 'Edit Order',
      'complete_order': 'Complete Order',
      'pending': 'Pending',
      'confirmed': 'Confirmed',
      'preparing': 'Preparing',
      'ready': 'Ready',
      'completed': 'Completed',
      'cancelled': 'Cancelled',
      'active_orders': 'Active Orders',
      'completed_orders': 'Completed Orders',
      'order_number': 'Order #',
      'kot_enabled': 'KOT Enabled',
      'multi_language': 'Multi Language',
      'default_language': 'Default Language',
      'business_name': 'Business Name',
      'business_address': 'Business Address',
      'business_phone': 'Business Phone',
      'business_email': 'Business Email',
      'tax_rate': 'Tax Rate (%)',
      'delivery_enabled': 'Delivery Enabled',
      'save': 'Save',
      'cancel': 'Cancel',
      'confirm': 'Confirm',
      'yes': 'Yes',
      'no': 'No',
      'optional': '(Optional)',
      'required': '(Required)',
      'search_menu': 'Search Menu:',
      'search_placeholder': 'Search by name or category...',
      'clear_search': 'Clear search',
      'items_found': 'items found',
      'view_order': 'View Order',
      'confirm_order': 'Confirm Order',
      'start_prep': 'Start Prep',
      'mark_ready': 'Mark Ready',
      'complete': 'Complete',
      'no_active_orders': 'No active orders',
      'no_completed_orders': 'No completed orders',
      'new_orders_appear': 'New orders will appear here',
      'completed_orders_appear': 'Completed orders will appear here',
      'view_details': 'View Details',
      'close': 'Close',
      'print_again': 'Print Again',
      'kot_preview': 'KOT Preview',
      'printed': 'PRINTED',
      'kot_sent_kitchen': 'KOT sent to kitchen printer',
      'no_menu_items': 'No menu items available',
      'no_items_found': 'No items found for',
      'item_added': 'added to order',
      'total_amount': 'Total',
      'orders': 'Orders',
      'items_count': 'Items',
      'more_items': 'more items',
      'total_amount_label': 'Total Amount',
      'customer': 'Customer',
      'settings': 'Settings',
      'business_information': 'Business Information',
      'address': 'Address',
      'phone': 'Phone',
      'email': 'Email',
      'not_set': 'Not set',
      'financial_settings': 'Financial Settings',
      'currency': 'Currency',
      'tax_rate': 'Tax Rate',
      'feature_settings': 'Feature Settings',
      'kot_printing': 'KOT Printing',
      'kot_printing_desc': 'Enable automatic KOT printing when orders are placed',
      'delivery_service': 'Delivery Service',
      'delivery_service_desc': 'Enable delivery orders with charges',
      'english': 'English',
      'hindi': 'Hindi',
      // KOT Enhanced
      'kot_summary': 'KOT Summary',
      'print_kot_summary': 'Print KOT Summary',
      'token': 'Token',
      'table': 'Table',
      'server': 'Server',
      'device': 'Device',
      'generated': 'Generated',
      'metrics': 'Metrics',
      'gross_sales': 'Gross Sales',
      'avg_order': 'Avg Order',
      'items_sold': 'Items Sold',
      'top_items': 'Top Items',
      'store': 'Store',
    },
    'hi': {
      'app_title': 'QSR प्रबंधन',
      'new_order': 'नया आर्डर',
      'orders': 'आर्डर',
      'menu': 'मेनू',
      'kot': 'KOT',
      'reports': 'रिपोर्ट',
      'settings': 'सेटिंग्स',
      'dine_in': 'डाइन इन',
      'takeaway': 'टेकअवे',
      'delivery': 'डिलीवरी',
      'customer_name': 'ग्राहक का नाम',
      'customer_phone': 'फोन नंबर',
      'customer_email': 'ईमेल',
      'customer_address': 'पता',
      'place_order': 'आर्डर दें',
      'order_notes': 'आर्डर नोट्स',
      'special_instructions': 'विशेष निर्देश',
      'add_item': 'आइटम जोड़ें',
      'edit_item': 'आइटम संपादित करें',
      'remove_item': 'आइटम हटाएं',
      'quantity': 'मात्रा',
      'price': 'कीमत',
      'total': 'कुल',
      'subtotal': 'उप-योग',
      'tax': 'कर',
      'charges': 'शुल्क',
      'delivery_charge': 'डिलीवरी शुल्क',
      'packaging_charge': 'पैकेजिंग शुल्क',
      'service_charge': 'सेवा शुल्क',
      'grand_total': 'कुल योग',
      'paid_amount': 'भुगतान राशि',
      'balance': 'शेष',
      'cash': 'नकद',
      'card': 'कार्ड',
      'upi': 'UPI',
      'online': 'ऑनलाइन',
      'payment_method': 'भुगतान विधि',
      'split_payment': 'भुगतान विभाजन',
      'add_payment': 'भुगतान जोड़ें',
      'print_kot': 'KOT प्रिंट करें',
      'print_bill': 'बिल प्रिंट करें',
      'send_whatsapp': 'व्हाट्सऐप भेजें',
      'cancel_order': 'आर्डर रद्द करें',
      'edit_order': 'आर्डर संपादित करें',
      'complete_order': 'आर्डर पूरा करें',
      'pending': 'लंबित',
      'confirmed': 'पुष्टि',
      'preparing': 'तैयार हो रहा',
      'ready': 'तैयार',
      'completed': 'पूर्ण',
      'cancelled': 'रद्द',
      'active_orders': 'सक्रिय आर्डर',
      'completed_orders': 'पूर्ण आर्डर',
      'order_number': 'आर्डर #',
      'kot_enabled': 'KOT सक्षम',
      'multi_language': 'बहुभाषी',
      'default_language': 'डिफ़ॉल्ट भाषा',
      'business_name': 'व्यापार नाम',
      'business_address': 'व्यापार पता',
      'business_phone': 'व्यापार फोन',
      'business_email': 'व्यापार ईमेल',
      'tax_rate': 'कर दर (%)',
      'delivery_enabled': 'डिलीवरी सक्षम',
      'save': 'सेव करें',
      'cancel': 'रद्द करें',
      'confirm': 'पुष्टि करें',
      'yes': 'हाँ',
      'no': 'नहीं',
      'optional': '(वैकल्पिक)',
      'required': '(आवश्यक)',
      'search_menu': 'मेनू खोजें:',
      'search_placeholder': 'नाम या श्रेणी से खोजें...',
      'clear_search': 'खोज साफ़ करें',
      'items_found': 'आइटम मिले',
      'view_order': 'आर्डर देखें',
      'confirm_order': 'आर्डर की पुष्टि करें',
      'start_prep': 'तैयारी शुरू करें',
      'mark_ready': 'तैयार का निशान',
      'complete': 'पूर्ण',
      'no_active_orders': 'कोई सक्रिय आर्डर नहीं',
      'no_completed_orders': 'कोई पूर्ण आर्डर नहीं',
      'new_orders_appear': 'नए आर्डर यहाँ दिखाई देंगे',
      'completed_orders_appear': 'पूर्ण आर्डर यहाँ दिखाई देंगे',
      'view_details': 'विवरण देखें',
      'close': 'बंद करें',
      'print_again': 'फिर से प्रिंट करें',
      'kot_preview': 'KOT पूर्वावलोकन',
      'printed': 'मुद्रित',
      'kot_sent_kitchen': 'KOT रसोई प्रिंटर को भेजा गया',
      'no_menu_items': 'कोई मेनू आइटम उपलब्ध नहीं',
      'no_items_found': 'के लिए कोई आइटम नहीं मिला',
      'item_added': 'ऑर्डर में जोड़ा गया',
      'total_amount': 'कुल',
      'orders': 'ऑर्डर',
      'items_count': 'आइटम',
      'more_items': 'और आइटम',
      'total_amount_label': 'कुल राशि',
      'customer': 'ग्राहक',
      'settings': 'सेटिंग्स',
      'business_information': 'व्यापार जानकारी',
      'address': 'पता',
      'phone': 'फोन',
      'email': 'ईमेल',
      'not_set': 'सेट नहीं किया गया',
      'financial_settings': 'वित्तीय सेटिंग्स',
      'currency': 'मुद्रा',
      'tax_rate': 'कर दर',
      'feature_settings': 'फीचर सेटिंग्स',
      'kot_printing': 'KOT प्रिंटिंग',
      'kot_printing_desc': 'ऑर्डर दिए जाने पर स्वचालित KOT प्रिंटिंग सक्षम करें',
      'delivery_service': 'डिलीवरी सेवा',
      'delivery_service_desc': 'शुल्क के साथ डिलीवरी ऑर्डर सक्षम करें',
      'english': 'अंग्रेजी',
      'hindi': 'हिंदी',
      // KOT Enhanced
      'kot_summary': 'KOT सारांश',
      'print_kot_summary': 'KOT सारांश प्रिंट करें',
      'token': 'टोकन',
      'table': 'टेबल',
      'server': 'सर्वर',
      'device': 'डिवाइस',
      'generated': 'जेनरेट किया गया',
      'metrics': 'मेट्रिक्स',
      'gross_sales': 'कुल बिक्री',
      'avg_order': 'औसत ऑर्डर',
      'items_sold': 'बेचे गए आइटम',
      'top_items': 'टॉप आइटम',
      'store': 'स्टोर',
    },
  };
  
  String get(String key) {
    return _localizedValues[languageCode]?[key] ?? key;
  }
}

// Helper function for Indian currency formatting
String formatIndianCurrency(String currency, double amount) {
  if (currency == '₹') {
    if (amount % 1 == 0) {
      return '₹${amount.toInt()}';
    } else {
      return '₹${amount.toStringAsFixed(2)}';
    }
  }
  return '$currency${amount.toStringAsFixed(2)}';
}

// Helper function for date time formatting
String formatDateTime(DateTime dateTime) {
  return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
}

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

class QSRApp extends StatelessWidget {
  const QSRApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'QSR Management App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF9933)),
        useMaterial3: true,
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 2,
        ),
        cardTheme: CardThemeData(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

// Data Models
class MenuItem {
  final String id;
  final String name;
  final double dineInPrice;
  final double takeawayPrice;
  final String category;
  final bool isAvailable;
  final List<Addon>? addons;
  final bool allowCustomization;
  final double? deliveryPrice;
  final String? description;

  MenuItem({
    required this.id,
    required this.name,
    required this.dineInPrice,
    double? takeawayPrice,
    required this.category,
    this.isAvailable = true,
    this.addons,
    this.allowCustomization = false,
    this.deliveryPrice,
    this.description,
  }) : takeawayPrice = takeawayPrice ?? dineInPrice;

  // Get price based on order type
  double getPriceForOrderType(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        return dineInPrice;
      case OrderType.takeaway:
        return takeawayPrice;
      case OrderType.delivery:
        return deliveryPrice ?? takeawayPrice;
    }
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'dineInPrice': dineInPrice,
    'takeawayPrice': takeawayPrice,
    'category': category,
    'isAvailable': isAvailable,
    'allowCustomization': allowCustomization,
    'deliveryPrice': deliveryPrice,
    'description': description,
  };

  factory MenuItem.fromJson(Map<String, dynamic> json) => MenuItem(
    id: json['id'],
    name: json['name'],
    dineInPrice: json['dineInPrice'] ?? json['price'] ?? 0.0,
    takeawayPrice: json['takeawayPrice'] ?? json['price'] ?? 0.0,
    category: json['category'],
    isAvailable: json['isAvailable'] ?? true,
    allowCustomization: json['allowCustomization'] ?? false,
    deliveryPrice: json['deliveryPrice']?.toDouble(),
    description: json['description'],
  );
}

class Addon {
  final String id;
  final String name;
  final double price;
  final bool isRequired;
  
  Addon({
    required this.id,
    required this.name,
    required this.price,
    this.isRequired = false,
  });
}

class OrderItem {
  final MenuItem menuItem;
  final int quantity;
  final OrderType orderType;
  final List<Addon> selectedAddons;
  final String? specialInstructions;
  
  OrderItem({
    required this.menuItem, 
    required this.quantity,
    required this.orderType,
    this.selectedAddons = const [],
    this.specialInstructions,
  });
  
  double get basePrice => menuItem.getPriceForOrderType(orderType);
  double get addonsPrice => selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
  double get unitPrice => basePrice + addonsPrice;
  double get subtotal => unitPrice * quantity;
  double get total => subtotal;
  
  OrderItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    OrderType? orderType,
    List<Addon>? selectedAddons,
    String? specialInstructions,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      orderType: orderType ?? this.orderType,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
    );
  }
}

enum OrderType { dineIn, takeaway, delivery }
enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled }
enum PaymentStatus { pending, partial, completed, refunded }
enum PaymentMethod { cash, card, upi, online }

class CustomerInfo {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  
  CustomerInfo({this.name, this.phone, this.email, this.address});
}

class Payment {
  final PaymentMethod method;
  final double amount;
  final DateTime timestamp;
  final String? transactionId;
  
  Payment({
    required this.method,
    required this.amount,
    required this.timestamp,
    this.transactionId,
  });
}

class OrderCharges {
  final double deliveryCharge;
  final double packagingCharge;
  final double serviceCharge;
  
  OrderCharges({
    this.deliveryCharge = 0.0,
    this.packagingCharge = 0.0,
    this.serviceCharge = 0.0,
  });
  
  double get total => deliveryCharge + packagingCharge + serviceCharge;
}

class Order {
  final String id;
  final List<OrderItem> items;
  final DateTime createdAt;
  final OrderType type;
  final OrderStatus status;
  final String? notes;
  final CustomerInfo? customer;
  final OrderCharges charges;
  final List<Payment> payments;
  final PaymentStatus paymentStatus;
  final bool kotPrinted;
  
  Order({
    required this.id,
    required this.items,
    required this.createdAt,
    required this.type,
    this.status = OrderStatus.pending,
    this.notes,
    this.customer,
    OrderCharges? charges,
    this.payments = const [],
    this.paymentStatus = PaymentStatus.pending,
    this.kotPrinted = false,
  }) : charges = charges ?? OrderCharges();
  
  double get subtotal => items.fold(0.0, (sum, item) => sum + item.total);
  double get totalCharges => charges.total;
  double get taxableAmount => subtotal + totalCharges;
  double get taxAmount => taxableAmount * 0.18; // 18% GST
  double get grandTotal => taxableAmount + taxAmount;
  double get paidAmount => payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get balanceAmount => grandTotal - paidAmount;
  
  Order copyWith({
    String? id,
    List<OrderItem>? items,
    DateTime? createdAt,
    OrderType? type,
    OrderStatus? status,
    String? notes,
    CustomerInfo? customer,
    OrderCharges? charges,
    List<Payment>? payments,
    PaymentStatus? paymentStatus,
    bool? kotPrinted,
    double? subtotal,
    double? taxAmount,
    double? grandTotal,
  }) {
    return Order(
      id: id ?? this.id,
      items: items ?? this.items,
      createdAt: createdAt ?? this.createdAt,
      type: type ?? this.type,
      status: status ?? this.status,
      notes: notes ?? this.notes,
      customer: customer ?? this.customer,
      charges: charges ?? this.charges,
      payments: payments ?? this.payments,
      paymentStatus: paymentStatus ?? this.paymentStatus,
      kotPrinted: kotPrinted ?? this.kotPrinted,
    );
  }
}

class AppSettings {
  final String currency;
  final double taxRate;
  final String businessName;
  final String address;
  final String phone;
  final String email;
  final bool kotEnabled;
  final String defaultLanguage;
  final bool deliveryEnabled;
  final double defaultDeliveryCharge;
  final double defaultPackagingCharge;
  
  AppSettings({
    this.currency = '₹',
    this.taxRate = 0.18,
    this.businessName = 'My Restaurant',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.kotEnabled = false,
    this.defaultLanguage = 'en',
    this.deliveryEnabled = true,
    this.defaultDeliveryCharge = 50.0,
    this.defaultPackagingCharge = 10.0,
  });
  
  AppSettings copyWith({
    String? currency,
    double? taxRate,
    String? businessName,
    String? address,
    String? phone,
    String? email,
    bool? kotEnabled,
    String? defaultLanguage,
    bool? deliveryEnabled,
    double? defaultDeliveryCharge,
    double? defaultPackagingCharge,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      taxRate: taxRate ?? this.taxRate,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      kotEnabled: kotEnabled ?? this.kotEnabled,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      deliveryEnabled: deliveryEnabled ?? this.deliveryEnabled,
      defaultDeliveryCharge: defaultDeliveryCharge ?? this.defaultDeliveryCharge,
      defaultPackagingCharge: defaultPackagingCharge ?? this.defaultPackagingCharge,
    );
  }
}

// State Providers
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

final orderTypeProvider = StateProvider<OrderType>((ref) => OrderType.dineIn);

// Language provider that syncs with settings
final currentLanguageProvider = Provider<String>((ref) {
  final settings = ref.watch(settingsProvider);
  return settings.defaultLanguage;
});

// Localization provider
final localizationProvider = Provider<AppLocalizations>((ref) {
  final language = ref.watch(currentLanguageProvider);
  return AppLocalizations(language);
});

// Helper function to get localized text
String l10n(WidgetRef ref, String key) {
  return ref.read(localizationProvider).get(key);
}

// State Notifiers
class MenuNotifier extends StateNotifier<List<MenuItem>> {
  MenuNotifier() : super(_defaultMenuItems);

  static final List<MenuItem> _defaultMenuItems = [
    MenuItem(id: '1', name: 'Margherita Pizza', dineInPrice: 299, takeawayPrice: 279, deliveryPrice: 319, category: 'Pizza'),
    MenuItem(id: '2', name: 'Chicken Burger', dineInPrice: 189, takeawayPrice: 169, deliveryPrice: 199, category: 'Burgers'),
    MenuItem(id: '3', name: 'Caesar Salad', dineInPrice: 149, takeawayPrice: 139, deliveryPrice: 159, category: 'Salads'),
    MenuItem(id: '4', name: 'Coca Cola', dineInPrice: 49, takeawayPrice: 45, deliveryPrice: 55, category: 'Beverages'),
    MenuItem(id: '5', name: 'French Fries', dineInPrice: 99, takeawayPrice: 89, deliveryPrice: 109, category: 'Sides'),
    MenuItem(id: '6', name: 'Paneer Tikka', dineInPrice: 249, takeawayPrice: 229, deliveryPrice: 269, category: 'Indian'),
    MenuItem(id: '7', name: 'Masala Dosa', dineInPrice: 129, takeawayPrice: 119, deliveryPrice: 139, category: 'South Indian'),
  ];

  void addMenuItem(MenuItem item) {
    state = [...state, item];
  }

  void updateMenuItem(MenuItem updatedItem) {
    state = state.map((item) => 
      item.id == updatedItem.id ? updatedItem : item
    ).toList();
  }

  void removeMenuItem(String id) {
    state = state.where((item) => item.id != id).toList();
  }
}

class CurrentOrderNotifier extends StateNotifier<List<OrderItem>> {
  CurrentOrderNotifier() : super([]);

  void addItem(MenuItem menuItem, OrderType orderType) {
    final existingIndex = state.indexWhere((item) => 
        item.menuItem.id == menuItem.id && item.orderType == orderType);
    
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      state = [
        ...state.take(existingIndex),
        OrderItem(menuItem: menuItem, quantity: existingItem.quantity + 1, orderType: orderType),
        ...state.skip(existingIndex + 1),
      ];
    } else {
      state = [...state, OrderItem(menuItem: menuItem, quantity: 1, orderType: orderType)];
    }
  }

  void updateQuantity(String menuItemId, int quantity, OrderType orderType) {
    if (quantity <= 0) {
      removeItem(menuItemId, orderType);
      return;
    }
    
    state = state.map((item) => 
      item.menuItem.id == menuItemId && item.orderType == orderType
        ? OrderItem(menuItem: item.menuItem, quantity: quantity, orderType: orderType)
        : item
    ).toList();
  }

  void removeItem(String menuItemId, OrderType orderType) {
    state = state.where((item) => 
        !(item.menuItem.id == menuItemId && item.orderType == orderType)).toList();
  }

  void clearOrder() {
    state = [];
  }

  void addItemFromOrder(OrderItem orderItem) {
    final existingIndex = state.indexWhere((item) => 
        item.menuItem.id == orderItem.menuItem.id && item.orderType == orderItem.orderType);
    
    if (existingIndex >= 0) {
      final existingItem = state[existingIndex];
      state = [
        ...state.take(existingIndex),
        OrderItem(menuItem: orderItem.menuItem, quantity: existingItem.quantity + 1, orderType: orderItem.orderType),
        ...state.skip(existingIndex + 1),
      ];
    } else {
      state = [...state, OrderItem(menuItem: orderItem.menuItem, quantity: 1, orderType: orderItem.orderType)];
    }
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  OrdersNotifier() : super([]);

  void addOrder(Order order) {
    state = [order, ...state];
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = state.map((order) => 
      order.id == orderId 
        ? order.copyWith(status: status)
        : order
    ).toList();
  }

  void updateOrder(Order updatedOrder) {
    state = state.map((order) => 
      order.id == updatedOrder.id ? updatedOrder : order
    ).toList();
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings());

  void updateCurrency(String currency) {
    state = AppSettings(
      currency: currency,
      taxRate: state.taxRate,
      businessName: state.businessName,
      address: state.address,
      phone: state.phone,
      email: state.email,
    );
  }

  void updateTaxRate(double taxRate) {
    state = AppSettings(
      currency: state.currency,
      taxRate: taxRate,
      businessName: state.businessName,
      address: state.address,
      phone: state.phone,
      email: state.email,
    );
  }

  void updateBusinessName(String businessName) {
    state = AppSettings(
      currency: state.currency,
      taxRate: state.taxRate,
      businessName: businessName,
      address: state.address,
      phone: state.phone,
      email: state.email,
    );
  }

  void updateAddress(String address) {
    state = AppSettings(
      currency: state.currency,
      taxRate: state.taxRate,
      businessName: state.businessName,
      address: address,
      phone: state.phone,
      email: state.email,
    );
  }

  void updatePhone(String phone) {
    state = AppSettings(
      currency: state.currency,
      taxRate: state.taxRate,
      businessName: state.businessName,
      address: state.address,
      phone: phone,
      email: state.email,
    );
  }

  void updateEmail(String email) {
    state = AppSettings(
      currency: state.currency,
      taxRate: state.taxRate,
      businessName: state.businessName,
      address: state.address,
      phone: state.phone,
      email: email,
    );
  }

  void updateSettings(AppSettings newSettings) {
    state = newSettings;
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
    const OrderPlacementScreen(), // Menu tab
    const OrderHistoryScreen(), // Orders tab
    const KOTScreen(), // KOT tab
    const SettingsScreen(), // Settings tab (will include Reports)
  ];

  @override
  Widget build(BuildContext context) {
    return Consumer(
      builder: (context, ref, child) {
        return Scaffold(
          body: _screens[_selectedIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            type: BottomNavigationBarType.fixed,
            selectedItemColor: const Color(0xFFFF9933),
            items: [
              BottomNavigationBarItem(
                icon: const Icon(Icons.restaurant_menu),
                label: l10n(ref, 'menu'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.receipt_long),
                label: l10n(ref, 'orders'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.kitchen),
                label: l10n(ref, 'kot'),
              ),
              BottomNavigationBarItem(
                icon: const Icon(Icons.settings),
                label: l10n(ref, 'settings'),
              ),
            ],
          ),
        );
      },
    );
  }
}

// Simple Order Placement Screen
class OrderPlacementScreen extends ConsumerStatefulWidget {
  const OrderPlacementScreen({super.key});

  @override
  ConsumerState<OrderPlacementScreen> createState() => _OrderPlacementScreenState();
}

class _OrderPlacementScreenState extends ConsumerState<OrderPlacementScreen> {
  final TextEditingController _notesController = TextEditingController();
  final TextEditingController _customerNameController = TextEditingController();
  final TextEditingController _customerPhoneController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  
  String _searchQuery = '';
  double _deliveryCharge = 0.0;
  double _packagingCharge = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize with default charges from settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      setState(() {
        _deliveryCharge = settings.defaultDeliveryCharge;
        _packagingCharge = settings.defaultPackagingCharge;
      });
    });
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuProvider);
    final currentOrder = ref.watch(currentOrderProvider);
    final settings = ref.watch(settingsProvider);
    final orderType = ref.watch(orderTypeProvider);

    final filteredMenuItems = menuItems.where((item) {
      return _searchQuery.isEmpty || 
             item.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
             item.category.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.total);
    final charges = _deliveryCharge + _packagingCharge;
    final taxableAmount = subtotal + charges;
    final tax = taxableAmount * settings.taxRate;
    final total = taxableAmount + tax;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(ref, 'menu')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        elevation: 0,
        actions: [
          if (currentOrder.isNotEmpty)
            Container(
              margin: const EdgeInsets.only(right: 8),
              child: TextButton.icon(
                onPressed: () => _placeOrder(),
                icon: const Icon(Icons.receipt_long),
                label: Text('${currentOrder.length} item${currentOrder.length > 1 ? 's' : ''}'),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                ),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Enhanced Order Type & Search Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.blue[50]!, Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border(bottom: BorderSide(color: Colors.grey[200]!)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Order Type Selection with better styling
                Row(
                  children: [
                    const Text('Order Type:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 12),
                Container(
                  width: double.infinity,
                  child: SegmentedButton<OrderType>(
                    segments: const [
                      ButtonSegment(
                        value: OrderType.dineIn,
                        label: Text('Dine In'),
                      ),
                      ButtonSegment(
                        value: OrderType.takeaway,
                        label: Text('Takeaway'),
                      ),
                      ButtonSegment(
                        value: OrderType.delivery,
                        label: Text('Home Delivery'),
                      ),
                    ],
                    selected: {orderType},
                    onSelectionChanged: (Set<OrderType> newSelection) {
                      ref.read(orderTypeProvider.notifier).state = newSelection.first;
                    },
                    style: SegmentedButton.styleFrom(
                      selectedBackgroundColor: const Color(0xFFFF9933),
                      selectedForegroundColor: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                
                // Enhanced Search Bar
                Row(
                  children: [
                    Icon(Icons.search, color: Colors.blue[700], size: 20),
                    const SizedBox(width: 8),
                    Text(l10n(ref, 'search_menu'), style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 16)),
                  ],
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    hintText: l10n(ref, 'search_placeholder'),
                    prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
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
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _searchQuery = value;
                    });
                  },
                ),
                
                // Search Results Info
                if (_searchQuery.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      '${filteredMenuItems.length} ${l10n(ref, 'items_found')}',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 14,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          
          // Enhanced Menu Items Section
          Expanded(
            child: filteredMenuItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          _searchQuery.isEmpty ? Icons.restaurant_menu : Icons.search_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          _searchQuery.isEmpty
                              ? l10n(ref, 'no_menu_items')
                              : '${l10n(ref, 'no_items_found')} "$_searchQuery"',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        if (_searchQuery.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          TextButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                            child: Text(l10n(ref, 'clear_search')),
                          ),
                        ],
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: filteredMenuItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredMenuItems[index];
                      final currentPrice = item.getPriceForOrderType(orderType);
                      final currentOrderItem = currentOrder.where((orderItem) => 
                          orderItem.menuItem.id == item.id && orderItem.orderType == orderType).firstOrNull;
                      
                      return Container(
                        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: currentOrderItem != null 
                                ? const Color(0xFFFF9933).withOpacity(0.5)
                                : Colors.grey[200]!,
                            width: currentOrderItem != null ? 2 : 1,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(12),
                            onTap: () {
                              if (item.isAvailable) {
                                if (currentOrderItem == null) {
                                  ref.read(currentOrderProvider.notifier).addItem(item, orderType);
                                }
                              }
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16),
                              child: Row(
                                children: [
                                  // Item Info
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              item.name,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                            if (!item.isAvailable) ...[
                                              const SizedBox(width: 8),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                                decoration: BoxDecoration(
                                                  color: Colors.red[100],
                                                  borderRadius: BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  'Out of Stock',
                                                  style: TextStyle(
                                                    fontSize: 10,
                                                    color: Colors.red[700],
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item.category,
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          children: [
                                            Text(
                                              'Price: ',
                                              style: TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey[600],
                                              ),
                                            ),
                                            Text(
                                              formatIndianCurrency(settings.currency, currentPrice),
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
                                  
                                  // Quantity Controls or Add Button
                                  currentOrderItem != null 
                                      ? Container(
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF9933).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(25),
                                            border: Border.all(color: const Color(0xFFFF9933)),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              InkWell(
                                                onTap: () => ref.read(currentOrderProvider.notifier)
                                                    .updateQuantity(item.id, currentOrderItem.quantity - 1, orderType),
                                                borderRadius: BorderRadius.circular(25),
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  alignment: Alignment.center,
                                                  child: const Icon(Icons.remove, size: 18, color: Color(0xFFFF9933)),
                                                ),
                                              ),
                                              Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 16),
                                                child: Text(
                                                  '${currentOrderItem.quantity}',
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 16,
                                                    color: Color(0xFFFF9933),
                                                  ),
                                                ),
                                              ),
                                              InkWell(
                                                onTap: () => ref.read(currentOrderProvider.notifier)
                                                    .updateQuantity(item.id, currentOrderItem.quantity + 1, orderType),
                                                borderRadius: BorderRadius.circular(25),
                                                child: Container(
                                                  width: 36,
                                                  height: 36,
                                                  alignment: Alignment.center,
                                                  decoration: const BoxDecoration(
                                                    color: Color(0xFFFF9933),
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: const Icon(Icons.add, size: 18, color: Colors.white),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : ElevatedButton.icon(
                                          onPressed: item.isAvailable ? () {
                                            ref.read(currentOrderProvider.notifier).addItem(item, orderType);
                                          } : null,
                                          icon: const Icon(Icons.add, size: 18),
                                          label: Text(l10n(ref, 'add_item')),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF9933),
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          
          // Enhanced Bottom Action Bar
          if (currentOrder.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [const Color(0xFFFF9933), const Color(0xFFFF7700)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 10,
                    offset: const Offset(0, -3),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: Row(
                  children: [
                    // Order Summary
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.shopping_cart, color: Colors.white, size: 18),
                              const SizedBox(width: 8),
                              Text(
                                '${currentOrder.length} item${currentOrder.length > 1 ? 's' : ''}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Text(
                                '${l10n(ref, 'total_amount')}: ',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.9),
                                  fontSize: 14,
                                ),
                              ),
                              Text(
                                formatIndianCurrency(settings.currency, total),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(width: 16),
                    
                    // Place Order Button
                    ElevatedButton(
                      onPressed: () => _placeOrder(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: const Color(0xFFFF9933),
                        elevation: 2,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                        textStyle: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text(l10n(ref, 'place_order')),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _placeOrder() {
    final currentOrder = ref.read(currentOrderProvider);
    final orderType = ref.read(orderTypeProvider);
    final settings = ref.read(settingsProvider);

    if (currentOrder.isEmpty) return;

    final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.total);
    final charges = _deliveryCharge + _packagingCharge;
    final taxableAmount = subtotal + charges;
    final tax = taxableAmount * settings.taxRate;
    final total = taxableAmount + tax;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          constraints: const BoxConstraints(maxWidth: 600),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.restaurant, color: Color(0xFFFF9933)),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Order Summary',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              
              const SizedBox(height: 24),
              
              // Order Summary Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.receipt_long_outlined, color: Colors.grey[700], size: 20),
                        const SizedBox(width: 8),
                        const Text(
                          'Order Items',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    // Order items list
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 200),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: currentOrder.length,
                        itemBuilder: (context, index) {
                          final item = currentOrder[index];
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Card(
                              margin: const EdgeInsets.symmetric(vertical: 2),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                item.menuItem.name,
                                                style: const TextStyle(fontWeight: FontWeight.w500),
                                              ),
                                              Text(
                                                '${item.orderType.name} • ${formatIndianCurrency(settings.currency, item.unitPrice)} each',
                                                style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.w500)),
                                        const SizedBox(width: 8),
                                        Text(
                                          formatIndianCurrency(settings.currency, item.total),
                                          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const Divider(height: 24),
                    // Order totals
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Subtotal:'),
                        Text(formatIndianCurrency(settings.currency, subtotal)),
                      ],
                    ),
                    
                    // Delivery/Packaging charges for delivery orders
                    if (orderType == OrderType.delivery) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Delivery Charge:'),
                          Text(formatIndianCurrency(settings.currency, _deliveryCharge)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Packaging Charge:'),
                          Text(formatIndianCurrency(settings.currency, _packagingCharge)),
                        ],
                      ),
                    ] else if (orderType == OrderType.takeaway) ...[
                      const SizedBox(height: 4),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Packaging Charge:'),
                          Text(formatIndianCurrency(settings.currency, _packagingCharge)),
                        ],
                      ),
                    ],
                    
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('GST (${(settings.taxRate * 100).toInt()}%):'),
                        Text(formatIndianCurrency(settings.currency, tax)),
                      ],
                    ),
                    const Divider(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text('Total:', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        Text(
                          formatIndianCurrency(settings.currency, total),
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Customer Information & Special Instructions Section (Optimized)
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.person_outline, color: Colors.grey[700], size: 18),
                        const SizedBox(width: 6),
                        const Text(
                          'Customer & Instructions',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Text(
                            'Optional',
                            style: TextStyle(fontSize: 10, color: Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Customer fields in a row for compact layout
                    Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _customerNameController,
                            decoration: InputDecoration(
                              labelText: 'Customer Name',
                              prefixIcon: const Icon(Icons.person, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _customerPhoneController,
                            decoration: InputDecoration(
                              labelText: 'Phone Number',
                              prefixIcon: const Icon(Icons.phone, size: 18),
                              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(8),
                                borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                              labelStyle: const TextStyle(fontSize: 12),
                            ),
                            style: const TextStyle(fontSize: 14),
                            keyboardType: TextInputType.phone,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Special instructions field
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Add special instructions...',
                        prefixIcon: const Icon(Icons.note_outlined, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        hintStyle: const TextStyle(fontSize: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              // Actions Section
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFFF9933), Color(0xFFFFAD5C)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          _confirmPlaceOrder();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.transparent,
                          shadowColor: Colors.transparent,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.check_circle, color: Colors.white, size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Place Order • ${formatIndianCurrency(settings.currency, total)}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }

  void _confirmPlaceOrder() {
    final currentOrder = ref.read(currentOrderProvider);
    final orderType = ref.read(orderTypeProvider);
    final settings = ref.read(settingsProvider);

    // Create customer info if provided
    CustomerInfo? customerInfo;
    if (_customerNameController.text.isNotEmpty || _customerPhoneController.text.isNotEmpty) {
      customerInfo = CustomerInfo(
        name: _customerNameController.text.isEmpty ? null : _customerNameController.text,
        phone: _customerPhoneController.text.isEmpty ? null : _customerPhoneController.text,
      );
    }

    // Create the order (Note: Orders will be stored in memory for now)
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Create and add the order to the orders list
    final orderCharges = OrderCharges(
      deliveryCharge: orderType == OrderType.delivery ? _deliveryCharge : 0.0,
      packagingCharge: (orderType == OrderType.takeaway || orderType == OrderType.delivery) ? _packagingCharge : 0.0,
    );

    final newOrder = Order(
      id: orderId,
      items: currentOrder,
      createdAt: DateTime.now(),
      type: orderType,
      status: OrderStatus.pending,
      notes: _notesController.text.isEmpty ? null : _notesController.text,
      customer: customerInfo,
      charges: orderCharges,
      kotPrinted: settings.kotEnabled,
    );
    
    // Add order to the orders provider
    ref.read(ordersProvider.notifier).addOrder(newOrder);
    
    // Clear current order and form
    ref.read(currentOrderProvider.notifier).clearOrder();
    _customerNameController.clear();
    _customerPhoneController.clear();
    _notesController.clear();
    
    // Reset charges
    setState(() {
      _deliveryCharge = settings.defaultDeliveryCharge;
      _packagingCharge = settings.defaultPackagingCharge;
    });
    
    // Print KOT if enabled
    if (settings.kotEnabled) {
      _printKOT(orderId, currentOrder, customerInfo);
    }
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #$orderId placed successfully!'),
        backgroundColor: Colors.green,
        action: SnackBarAction(
          label: 'View',
          textColor: Colors.white,
          onPressed: () {
            // Future: Navigate to order details
          },
        ),
      ),
    );
  }

  void _printKOT(String orderId, List<OrderItem> items, CustomerInfo? customer) {
    final settings = ref.read(settingsProvider);
    final orderType = ref.read(orderTypeProvider);
    final now = DateTime.now();
    
    // Create KOT content with 58mm-friendly format
    final kotContent = _formatKOTTicket(
      settings.businessName,
      orderId,
      orderType,
      customer,
      items,
      now,
    );

    // Show KOT preview dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.print, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            const Text('KOT Preview'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'PRINTED',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Text(
                kotContent,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // In a real implementation, this would send to printer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('KOT sent to kitchen printer'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.print),
            label: const Text('Print Again'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    // Console output for debugging
    print('=== KOT PRINTED ===');
    print(kotContent);
    print('==================');
  }

  // Enhanced KOT Formatting Functions
  String _formatKOTTicket(
    String businessName,
    String orderId,
    OrderType orderType,
    CustomerInfo? customer,
    List<OrderItem> items,
    DateTime timestamp,
  ) {
    final buffer = StringBuffer();
    
    // Header: Store name (bold), "KOT", token/table, orderType, server, timestamp
    buffer.writeln('================================');
    buffer.writeln('      ${businessName.toUpperCase()}');
    buffer.writeln('          *** KOT ***');
    buffer.writeln('================================');
    
    // Token/Order Info
    buffer.writeln('Order ID: #${orderId.substring(orderId.length - 6)}');
    if (customer?.name != null) {
      buffer.writeln('Table: ${customer!.name}');
    }
    buffer.writeln('Type: ${orderType.toString().split('.').last.toUpperCase()}');
    buffer.writeln('Server: Staff-01'); // Could be dynamic
    buffer.writeln('Time: ${_formatKOTTimestamp(timestamp)}');
    buffer.writeln('--------------------------------');
    
    // Body: Item lines (qty x name) + per-item notes
    buffer.writeln('ITEMS:');
    for (final item in items) {
      buffer.writeln('${item.quantity.toString().padLeft(2)} x ${item.menuItem.name}');
      if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty) {
        buffer.writeln('     >> ${item.specialInstructions}');
      }
    }
    
    // Footer: Separator line, deviceId/printed at
    buffer.writeln('--------------------------------');
    buffer.writeln('Total Items: ${items.fold(0, (sum, item) => sum + item.quantity)}');
    buffer.writeln('Device: POS-Terminal-01');
    buffer.writeln('Printed: ${_formatKOTTimestamp(DateTime.now())}');
    buffer.writeln('================================');
    
    return buffer.toString();
  }

  String _formatKOTSummaryReport(
    String dateRange,
    List<Order> orders,
    DateTime printTime,
    String businessName,
  ) {
    final buffer = StringBuffer();
    
    // Header: "KOT Summary – <Range>" with printed timestamp
    buffer.writeln('================================');
    buffer.writeln('     KOT SUMMARY - $dateRange');
    buffer.writeln('================================');
    buffer.writeln('Generated: ${_formatKOTTimestamp(printTime)}');
    buffer.writeln('--------------------------------');
    
    // Metrics: Orders, Gross Sales, Average Order, Items Sold
    final totalOrders = orders.length;
    final grossSales = orders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final averageOrder = totalOrders > 0 ? grossSales / totalOrders : 0.0;
    final totalItems = orders.fold(0, (sum, order) => 
      sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    
    buffer.writeln('METRICS:');
    buffer.writeln('Orders: $totalOrders');
    buffer.writeln('Gross Sales: ₹${grossSales.toStringAsFixed(2)}');
    buffer.writeln('Avg Order: ₹${averageOrder.toStringAsFixed(2)}');
    buffer.writeln('Items Sold: $totalItems');
    buffer.writeln('--------------------------------');
    
    // Top Items: name x qty
    final Map<String, int> itemCounts = {};
    for (final order in orders) {
      for (final item in order.items) {
        itemCounts[item.menuItem.name] = 
          (itemCounts[item.menuItem.name] ?? 0) + item.quantity;
      }
    }
    
    final topItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (topItems.isNotEmpty) {
      buffer.writeln('TOP ITEMS:');
      for (int i = 0; i < topItems.length && i < 5; i++) {
        final item = topItems[i];
        buffer.writeln('${item.key} x${item.value}');
      }
      buffer.writeln('--------------------------------');
    }
    
    // Footer: deviceId/store
    buffer.writeln('Store: $businessName');
    buffer.writeln('Device: POS-Terminal-01');
    buffer.writeln('================================');
    
    return buffer.toString();
  }

  String _formatKOTTimestamp(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

}

// Order History Screen
class OrderHistoryScreen extends ConsumerWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orders = ref.watch(ordersProvider);
    
    // Separate active and completed orders
    final activeOrders = orders.where((order) => 
      order.status == OrderStatus.pending ||
      order.status == OrderStatus.confirmed ||
      order.status == OrderStatus.preparing ||
      order.status == OrderStatus.ready
    ).toList();
    
    final completedOrders = orders.where((order) => 
      order.status == OrderStatus.completed ||
      order.status == OrderStatus.cancelled
    ).toList();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(ref, 'orders')),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: DefaultTabController(
        length: 2,
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                color: Color(0xFFFF9933),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
              ),
              child: TabBar(
                indicatorColor: Colors.white,
                labelColor: Colors.white,
                unselectedLabelColor: Colors.white70,
                tabs: [
                  Tab(
                    icon: Icon(Icons.pending_actions),
                    text: l10n(ref, 'active_orders'),
                  ),
                  Tab(
                    icon: Icon(Icons.history),
                    text: l10n(ref, 'completed_orders'),
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildActiveOrdersList(context, ref, activeOrders),
                  _buildCompletedOrdersList(context, ref, completedOrders),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrdersList(BuildContext context, WidgetRef ref, List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.pending_actions,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              l10n(ref, 'no_active_orders'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              l10n(ref, 'new_orders_appear'),
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        // Refresh logic can be added here
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return _buildOrderCard(context, ref, order, isActive: true);
        },
      ),
    );
  }

  Widget _buildCompletedOrdersList(BuildContext context, WidgetRef ref, List<Order> orders) {
    if (orders.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.history,
              size: 64,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              l10n(ref, 'no_completed_orders'),
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(height: 8),
            Text(
              l10n(ref, 'completed_orders_appear'),
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: orders.length,
      itemBuilder: (context, index) {
        final order = orders[index];
        return _buildOrderCard(context, ref, order, isActive: false);
      },
    );
  }

  Widget _buildOrderCard(BuildContext context, WidgetRef ref, Order order, {required bool isActive}) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Order Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${l10n(ref, 'order_number')}${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _formatDateTime(order.createdAt),
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                _buildStatusChip(order.status, ref),
              ],
            ),
            const SizedBox(height: 12),
            
            // Customer Info
            if (order.customer != null) ...[
              Row(
                children: [
                  Icon(Icons.person, size: 16, color: Colors.grey[600]),
                  const SizedBox(width: 8),
                  Text(
                    order.customer!.name ?? l10n(ref, 'customer'),
                    style: const TextStyle(fontSize: 14),
                  ),
                  if (order.customer!.phone != null) ...[
                    const SizedBox(width: 16),
                    Icon(Icons.phone, size: 16, color: Colors.grey[600]),
                    const SizedBox(width: 8),
                    Text(
                      order.customer!.phone!,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 8),
            ],
            
            // Order Type
            Row(
              children: [
                Text(
                  order.type.toString().split('.').last.toUpperCase(),
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 12),
            
            // Order Items Summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${l10n(ref, 'items_count')} (${order.items.length})',
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 8),
                  ...order.items.take(2).map((item) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            '${item.quantity}x ${item.menuItem.name}',
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                        Text(
                          '₹${item.total.toStringAsFixed(2)}',
                          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  )).toList(),
                  if (order.items.length > 2)
                    Text(
                      '+${order.items.length - 2} ${l10n(ref, 'more_items')}',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            
            // Total and Actions
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n(ref, 'total_amount_label'),
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                    Text(
                      '₹${order.grandTotal.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9933),
                      ),
                    ),
                  ],
                ),
                isActive 
                  ? _buildActionButtons(context, ref, order)
                  : _buildCompletedOrderActions(context, order),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusChip(OrderStatus status, WidgetRef ref) {
    Color color;
    String label;
    
    switch (status) {
      case OrderStatus.pending:
        color = Colors.orange;
        label = l10n(ref, 'pending');
        break;
      case OrderStatus.confirmed:
        color = Colors.blue;
        label = l10n(ref, 'confirmed');
        break;
      case OrderStatus.preparing:
        color = Colors.purple;
        label = l10n(ref, 'preparing');
        break;
      case OrderStatus.ready:
        color = Colors.green;
        label = l10n(ref, 'ready');
        break;
      case OrderStatus.completed:
        color = Colors.green[700]!;
        label = l10n(ref, 'completed');
        break;
      case OrderStatus.cancelled:
        color = Colors.red;
        label = l10n(ref, 'cancelled');
        break;
    }
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _buildActionButtons(BuildContext context, WidgetRef ref, Order order) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (order.status == OrderStatus.pending || order.status == OrderStatus.confirmed)
          OutlinedButton(
            onPressed: () => _updateOrderStatus(ref, order.id, OrderStatus.preparing),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF9933)),
              foregroundColor: const Color(0xFFFF9933),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(l10n(ref, 'start_prep'), style: TextStyle(fontSize: 12)),
          ),
        
        if (order.status == OrderStatus.preparing)
          OutlinedButton(
            onPressed: () => _updateOrderStatus(ref, order.id, OrderStatus.ready),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              foregroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(l10n(ref, 'mark_ready'), style: TextStyle(fontSize: 12)),
          ),
        
        if (order.status == OrderStatus.ready)
          ElevatedButton(
            onPressed: () => _updateOrderStatus(ref, order.id, OrderStatus.completed),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(l10n(ref, 'complete'), style: TextStyle(fontSize: 12)),
          ),
        
        const SizedBox(width: 8),
        PopupMenuButton<String>(
          onSelected: (value) {
            switch (value) {
              case 'view':
                _showOrderDetails(context, order);
                break;
              case 'print':
                _printOrderBill(context, order);
                break;
              case 'split':
                _splitOrderBill(context, order);
                break;
              case 'cancel':
                if (order.status != OrderStatus.completed) {
                  _showCancelOrderDialog(context, ref, order);
                }
                break;
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'view',
              child: Row(
                children: [
                  Icon(Icons.visibility, size: 16),
                  SizedBox(width: 8),
                  Text(l10n(ref, 'view_details')),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'print',
              child: Row(
                children: [
                  Icon(Icons.print, size: 16, color: Color(0xFFFF9933)),
                  SizedBox(width: 8),
                  Text('Print Bill', style: TextStyle(color: Color(0xFFFF9933))),
                ],
              ),
            ),
            PopupMenuItem(
              value: 'split',
              child: Row(
                children: [
                  Icon(Icons.call_split, size: 16, color: Color(0xFFFF9933)),
                  SizedBox(width: 8),
                  Text('Split Bill', style: TextStyle(color: Color(0xFFFF9933))),
                ],
              ),
            ),
            if (order.status != OrderStatus.completed && order.status != OrderStatus.cancelled)
              PopupMenuItem(
                value: 'cancel',
                child: Row(
                  children: [
                    Icon(Icons.cancel, size: 16, color: Colors.red),
                    SizedBox(width: 8),
                    Text(l10n(ref, 'cancel_order'), style: TextStyle(color: Colors.red)),
                  ],
                ),
              ),
          ],
          child: const Icon(Icons.more_vert, size: 20),
        ),
      ],
    );
  }

  Widget _buildCompletedOrderActions(BuildContext context, Order order) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showOrderDetails(context, order);
            break;
          case 'print':
            _printOrderBill(context, order);
            break;
        }
      },
      itemBuilder: (context) => [
        PopupMenuItem(
          value: 'view',
          child: Row(
            children: [
              Icon(Icons.visibility, size: 16),
              SizedBox(width: 8),
              Text('View Details'),
            ],
          ),
        ),
        PopupMenuItem(
          value: 'print',
          child: Row(
            children: [
              Icon(Icons.print, size: 16, color: Color(0xFFFF9933)),
              SizedBox(width: 8),
              Text('Print Bill', style: TextStyle(color: Color(0xFFFF9933))),
            ],
          ),
        ),
      ],
      child: const Icon(Icons.more_vert, size: 20),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  void _updateOrderStatus(WidgetRef ref, String orderId, OrderStatus newStatus) {
    ref.read(ordersProvider.notifier).updateOrderStatus(orderId, newStatus);
  }

  void _showOrderDetails(BuildContext context, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Order #${order.id}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Status: ${order.status.toString().split('.').last.toUpperCase()}'),
              const SizedBox(height: 8),
              Text('Type: ${order.type.toString().split('.').last.toUpperCase()}'),
              const SizedBox(height: 8),
              Text('Created: ${_formatDateTime(order.createdAt)}'),
              if (order.customer != null) ...[
                const SizedBox(height: 8),
                Text('Customer: ${order.customer!.name ?? 'N/A'}'),
                if (order.customer!.phone != null)
                  Text('Phone: ${order.customer!.phone}'),
              ],
              const SizedBox(height: 16),
              const Text('Items:', style: TextStyle(fontWeight: FontWeight.bold)),
              ...order.items.map((item) => Padding(
                padding: const EdgeInsets.only(top: 4),
                child: Text('${item.quantity}x ${item.menuItem.name} - ₹${item.total.toStringAsFixed(2)}'),
              )).toList(),
              const SizedBox(height: 16),
              const Text('Bill Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Subtotal:'),
                  Text('₹${order.subtotal.toStringAsFixed(2)}'),
                ],
              ),
              // Show delivery charge if delivery order
              if (order.type == OrderType.delivery && order.charges.deliveryCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Charge:'),
                    Text('₹${order.charges.deliveryCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              // Show packaging charge if applicable
              if (order.charges.packagingCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Packaging Charge:'),
                    Text('₹${order.charges.packagingCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              // Show service charge if applicable
              if (order.charges.serviceCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service Charge:'),
                    Text('₹${order.charges.serviceCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              const SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('GST (18%):'),
                  Text('₹${order.taxAmount.toStringAsFixed(2)}'),
                ],
              ),
              const Divider(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('₹${order.grandTotal.toStringAsFixed(2)}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ],
              ),
            ],
          ),
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

  void _showCancelOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Cancel Order'),
        content: Text('Are you sure you want to cancel Order #${order.id}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () {
              _updateOrderStatus(ref, order.id, OrderStatus.cancelled);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _printOrderBill(BuildContext context, Order order) {
    final settings = AppSettings(
      currency: 'INR',
      taxRate: 0.18, // Default 18% GST
    );
    
    final billContent = _generateOrderBillContent(order, settings);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.print, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Print Bill'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    billContent,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ],
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // In a real app, this would send to printer
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Bill sent to printer!')),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.print),
            label: const Text('Print'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _splitOrderBill(BuildContext context, Order order) {
    int numberOfSplits = 2;
    bool splitEqually = true;
    List<List<OrderItem>> splitOrders = [];
    
    final settings = AppSettings(
      currency: 'INR',
      taxRate: 0.18,
    );
    
    void _updateSplits() {
      if (splitEqually) {
        splitOrders = List.generate(numberOfSplits, (index) => <OrderItem>[]);
        for (int i = 0; i < order.items.length; i++) {
          splitOrders[i % numberOfSplits].add(order.items[i]);
        }
      }
    }
    
    _updateSplits();
    
    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: const Row(
            children: [
              Icon(Icons.call_split, color: Color(0xFFFF9933)),
              SizedBox(width: 8),
              Text('Split Bill'),
            ],
          ),
          content: SizedBox(
            width: double.maxFinite,
            height: 500,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Number of splits: '),
                    DropdownButton<int>(
                      value: numberOfSplits,
                      items: List.generate(8, (index) => index + 2)
                          .map((i) => DropdownMenuItem(
                                value: i,
                                child: Text('$i'),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          numberOfSplits = value!;
                          _updateSplits();
                        });
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Checkbox(
                      value: splitEqually,
                      onChanged: (value) {
                        setState(() {
                          splitEqually = value!;
                          _updateSplits();
                        });
                      },
                      activeColor: const Color(0xFFFF9933),
                    ),
                    const Text('Split equally'),
                  ],
                ),
                const SizedBox(height: 16),
                const Text('Split Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Expanded(
                  child: ListView.builder(
                    itemCount: numberOfSplits,
                    itemBuilder: (context, splitIndex) {
                      final splitItems = splitOrders[splitIndex];
                      final splitSubtotal = splitItems.fold(0.0, (sum, item) => sum + item.total);
                      final splitTax = splitSubtotal * settings.taxRate;
                      final splitGrandTotal = splitSubtotal + splitTax;
                      
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Bill ${splitIndex + 1}',
                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
                              ),
                              const SizedBox(height: 8),
                              ...splitItems.map((item) => Padding(
                                padding: const EdgeInsets.only(bottom: 4),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        '${item.menuItem.name} x${item.quantity}',
                                        style: const TextStyle(fontSize: 12),
                                      ),
                                    ),
                                    Text(
                                      '₹${item.total.toStringAsFixed(2)}',
                                      style: const TextStyle(fontSize: 12),
                                    ),
                                  ],
                                ),
                              )),
                              const Divider(height: 16),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Subtotal:', style: TextStyle(fontSize: 12)),
                                  Text('₹${splitSubtotal.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('GST (${(settings.taxRate * 100).toInt()}%):', style: const TextStyle(fontSize: 12)),
                                  Text('₹${splitTax.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              const Divider(height: 8),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold)),
                                  Text(
                                    '₹${splitGrandTotal.toStringAsFixed(2)}',
                                    style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
                                  ),
                                ],
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton.icon(
              onPressed: () {
                // Generate separate bills for each split
                for (int i = 0; i < numberOfSplits; i++) {
                  final splitItems = splitOrders[i];
                  final splitSubtotal = splitItems.fold(0.0, (sum, item) => sum + item.total);
                  final splitTax = splitSubtotal * settings.taxRate;
                  final billContent = _generateSplitOrderBillContent(splitItems, settings, splitSubtotal, splitTax, i + 1, numberOfSplits, order.id, order);
                  
                  // In a real app, this would print each bill separately
                  print('Split Bill ${i + 1}:\n$billContent');
                }
                
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('$numberOfSplits split bills generated!')),
                );
                Navigator.pop(context);
              },
              icon: const Icon(Icons.print),
              label: const Text('Generate Bills'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF9933),
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _generateOrderBillContent(Order order, AppSettings settings) {
    final buffer = StringBuffer();
    buffer.writeln('=' * 32);
    buffer.writeln('         RESTAURANT BILL');
    buffer.writeln('=' * 32);
    buffer.writeln('Order #: ${order.id}');
    buffer.writeln('Date: ${order.createdAt.day}/${order.createdAt.month}/${order.createdAt.year}');
    buffer.writeln('Time: ${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}');
    buffer.writeln('Type: ${order.type.toString().split('.').last.toUpperCase()}');
    
    if (order.customer != null) {
      buffer.writeln('-' * 32);
      buffer.writeln('Customer: ${order.customer!.name ?? 'N/A'}');
      if (order.customer!.phone != null) {
        buffer.writeln('Phone: ${order.customer!.phone}');
      }
    }
    
    buffer.writeln('-' * 32);
    buffer.writeln('ITEMS:');
    
    for (final item in order.items) {
      buffer.writeln('${item.menuItem.name}');
      buffer.writeln('  ${item.quantity} x ₹${item.menuItem.dineInPrice.toStringAsFixed(2)} = ₹${item.total.toStringAsFixed(2)}');
      buffer.writeln();
    }
    
    buffer.writeln('-' * 32);
    buffer.writeln('BILL BREAKDOWN:');
    buffer.writeln('Subtotal: ₹${order.subtotal.toStringAsFixed(2)}');
    
    // Add delivery charge if applicable
    if (order.type == OrderType.delivery && order.charges.deliveryCharge > 0) {
      buffer.writeln('Delivery Charge: ₹${order.charges.deliveryCharge.toStringAsFixed(2)}');
    }
    
    // Add packaging charge if applicable
    if (order.charges.packagingCharge > 0) {
      buffer.writeln('Packaging Charge: ₹${order.charges.packagingCharge.toStringAsFixed(2)}');
    }
    
    // Add service charge if applicable
    if (order.charges.serviceCharge > 0) {
      buffer.writeln('Service Charge: ₹${order.charges.serviceCharge.toStringAsFixed(2)}');
    }
    
    buffer.writeln('GST (18%): ₹${order.taxAmount.toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    buffer.writeln('TOTAL: ₹${order.grandTotal.toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    buffer.writeln('       Thank you!');
    buffer.writeln('   Visit us again!');
    
    return buffer.toString();
  }

  String _generateSplitOrderBillContent(List<OrderItem> items, AppSettings settings, double splitSubtotal, double splitTax, int billNumber, int totalBills, String orderId, Order originalOrder) {
    final buffer = StringBuffer();
    buffer.writeln('=' * 32);
    buffer.writeln('    SPLIT BILL $billNumber/$totalBills');
    buffer.writeln('=' * 32);
    buffer.writeln('Order #: $orderId');
    buffer.writeln('Date: ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}');
    buffer.writeln('Time: ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}');
    buffer.writeln('-' * 32);
    buffer.writeln('ITEMS:');
    
    for (final item in items) {
      buffer.writeln('${item.menuItem.name}');
      buffer.writeln('  ${item.quantity} x ₹${item.menuItem.dineInPrice.toStringAsFixed(2)} = ₹${item.total.toStringAsFixed(2)}');
      buffer.writeln();
    }
    
    buffer.writeln('-' * 32);
    buffer.writeln('BILL BREAKDOWN:');
    buffer.writeln('Subtotal: ₹${splitSubtotal.toStringAsFixed(2)}');
    
    // Calculate proportional charges based on split ratio
    final splitRatio = splitSubtotal / originalOrder.subtotal;
    
    // Add proportional delivery charge if applicable
    if (originalOrder.type == OrderType.delivery && originalOrder.charges.deliveryCharge > 0) {
      final splitDeliveryCharge = originalOrder.charges.deliveryCharge * splitRatio;
      buffer.writeln('Delivery Charge: ₹${splitDeliveryCharge.toStringAsFixed(2)}');
    }
    
    // Add proportional packaging charge if applicable
    if (originalOrder.charges.packagingCharge > 0) {
      final splitPackagingCharge = originalOrder.charges.packagingCharge * splitRatio;
      buffer.writeln('Packaging Charge: ₹${splitPackagingCharge.toStringAsFixed(2)}');
    }
    
    // Add proportional service charge if applicable
    if (originalOrder.charges.serviceCharge > 0) {
      final splitServiceCharge = originalOrder.charges.serviceCharge * splitRatio;
      buffer.writeln('Service Charge: ₹${splitServiceCharge.toStringAsFixed(2)}');
    }
    
    buffer.writeln('GST (18%): ₹${splitTax.toStringAsFixed(2)}');
    
    // Calculate total including proportional charges
    final proportionalCharges = (originalOrder.charges.deliveryCharge + originalOrder.charges.packagingCharge + originalOrder.charges.serviceCharge) * splitRatio;
    final splitTotal = splitSubtotal + proportionalCharges + splitTax;
    
    buffer.writeln('=' * 32);
    buffer.writeln('TOTAL: ₹${splitTotal.toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    buffer.writeln('       Thank you!');
    buffer.writeln('   Visit us again!');
    
    return buffer.toString();
  }
}

// Menu Screen
class MenuScreen extends ConsumerWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final menuItems = ref.watch(menuProvider);
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Menu Management'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showAddItemDialog(context, ref),
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: menuItems.length,
        itemBuilder: (context, index) {
          final item = menuItems[index];
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: ListTile(
              title: Text(item.name),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.category),
                  if (item.dineInPrice != item.takeawayPrice) ...[
                    Text('Dine In: ${formatIndianCurrency(settings.currency, item.dineInPrice)}'),
                    Text('Takeaway: ${formatIndianCurrency(settings.currency, item.takeawayPrice)}'),
                  ] else
                    Text('Price: ${formatIndianCurrency(settings.currency, item.dineInPrice)}'),
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: item.isAvailable,
                    onChanged: (value) {
                      final updatedItem = MenuItem(
                        id: item.id,
                        name: item.name,
                        dineInPrice: item.dineInPrice,
                        takeawayPrice: item.takeawayPrice,
                        category: item.category,
                        isAvailable: value,
                      );
                      ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () => _showEditItemDialog(context, ref, item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => ref.read(menuProvider.notifier).removeMenuItem(item.id),
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
    final nameController = TextEditingController();
    final dineInPriceController = TextEditingController();
    final takeawayPriceController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dineInPriceController,
                decoration: const InputDecoration(labelText: 'Dine In Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: takeawayPriceController,
                decoration: const InputDecoration(labelText: 'Takeaway Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
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
              if (nameController.text.isNotEmpty && dineInPriceController.text.isNotEmpty) {
                final item = MenuItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  dineInPrice: double.tryParse(dineInPriceController.text) ?? 0,
                  takeawayPrice: double.tryParse(takeawayPriceController.text) ?? 
                                double.tryParse(dineInPriceController.text) ?? 0,
                  category: categoryController.text.isEmpty ? 'General' : categoryController.text,
                );
                ref.read(menuProvider.notifier).addMenuItem(item);
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    final nameController = TextEditingController(text: item.name);
    final dineInPriceController = TextEditingController(text: item.dineInPrice.toString());
    final takeawayPriceController = TextEditingController(text: item.takeawayPrice.toString());
    final categoryController = TextEditingController(text: item.category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Menu Item'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Item Name'),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: dineInPriceController,
                decoration: const InputDecoration(labelText: 'Dine In Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: takeawayPriceController,
                decoration: const InputDecoration(labelText: 'Takeaway Price'),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 8),
              TextField(
                controller: categoryController,
                decoration: const InputDecoration(labelText: 'Category'),
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
              if (nameController.text.isNotEmpty && dineInPriceController.text.isNotEmpty) {
                final updatedItem = MenuItem(
                  id: item.id,
                  name: nameController.text,
                  dineInPrice: double.tryParse(dineInPriceController.text) ?? 0,
                  takeawayPrice: double.tryParse(takeawayPriceController.text) ?? 
                                double.tryParse(dineInPriceController.text) ?? 0,
                  category: categoryController.text.isEmpty ? 'General' : categoryController.text,
                  isAvailable: item.isAvailable,
                );
                ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }
}

// Enhanced Reports Screen with Comprehensive Analytics
class ReportsScreen extends ConsumerStatefulWidget {
  const ReportsScreen({super.key});

  @override
  ConsumerState<ReportsScreen> createState() => _ReportsScreenState();
}

enum ReportFilter {
  today,
  yesterday,
  thisWeek,
  last7Days,
  thisMonth,
  last30Days,
  thisYear,
  custom
}

class _ReportsScreenState extends ConsumerState<ReportsScreen> {
  DateTime _startDate = DateTime.now().subtract(const Duration(days: 30));
  DateTime _endDate = DateTime.now();
  ReportFilter _selectedFilter = ReportFilter.last30Days;

  @override
  Widget build(BuildContext context) {
    final allOrders = ref.watch(ordersProvider);
    final settings = ref.watch(settingsProvider);

    // Filter orders by date range
    final filteredOrders = allOrders.where((order) =>
        order.createdAt.isAfter(_startDate.subtract(const Duration(days: 1))) &&
        order.createdAt.isBefore(_endDate.add(const Duration(days: 1)))).toList();

    final totalSales = filteredOrders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final totalOrders = filteredOrders.length;
    final completedOrders = filteredOrders.where((order) => order.status == OrderStatus.completed).length;
    final averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;
    final totalItems = filteredOrders.fold(0, (sum, order) => sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    
    // Calculate additional metrics
    final packagingRevenue = filteredOrders.fold(0.0, (sum, order) => sum + order.charges.packagingCharge);
    final deliveryRevenue = filteredOrders.fold(0.0, (sum, order) => sum + order.charges.deliveryCharge);

    // Top selling items analysis
    final Map<String, Map<String, dynamic>> itemAnalysis = {};
    for (final order in filteredOrders) {
      for (final item in order.items) {
        final name = item.menuItem.name;
        if (!itemAnalysis.containsKey(name)) {
          itemAnalysis[name] = {'quantity': 0, 'revenue': 0.0};
        }
        itemAnalysis[name]!['quantity'] += item.quantity;
        itemAnalysis[name]!['revenue'] += item.unitPrice * item.quantity;
      }
    }
    final topItems = itemAnalysis.entries.toList()
      ..sort((a, b) => (b.value['quantity'] as int).compareTo(a.value['quantity'] as int));

    // Daily trend analysis
    final Map<String, Map<String, dynamic>> dailyData = {};
    for (final order in filteredOrders) {
      final dateKey = '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}';
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = {
          'date': DateTime(order.createdAt.year, order.createdAt.month, order.createdAt.day),
          'orders': 0,
          'sales': 0.0,
          'items': 0,
        };
      }
      dailyData[dateKey]!['orders']++;
      dailyData[dateKey]!['sales'] += order.grandTotal;
      dailyData[dateKey]!['items'] += order.items.fold(0, (sum, item) => sum + item.quantity);
    }
    final sortedDailyData = dailyData.values.toList()
      ..sort((a, b) => (b['date'] as DateTime).compareTo(a['date'] as DateTime));

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFF9933), Color(0xFFFFB366)],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Enhanced Header with Filters
              Container(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Sales Analytics',
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              Text(
                                '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Colors.white70,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.file_download, color: Colors.white, size: 20),
                              onPressed: () => _exportToCSV(context, filteredOrders, settings),
                              tooltip: 'Export Reports',
                              padding: const EdgeInsets.all(8),
                              constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    // Enhanced Filter Chips Section
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.white.withOpacity(0.3), width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFF9933).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: const Text(
                                  'Time Period',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const Spacer(),
                              Text(
                                '${_formatDate(_startDate)} - ${_formatDate(_endDate)}',
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          SizedBox(
                            height: 36,
                            child: ListView(
                              scrollDirection: Axis.horizontal,
                              children: [
                                _buildFilterChip('Today', ReportFilter.today),
                                _buildFilterChip('Yesterday', ReportFilter.yesterday),
                                _buildFilterChip('Last 7 Days', ReportFilter.last7Days),
                                _buildFilterChip('Custom Date', ReportFilter.custom),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Main Content Area
              Expanded(
                child: Container(
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Enhanced Key Metrics Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      const Color(0xFFFF9933).withOpacity(0.05),
                                      Colors.white,
                                    ],
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: const Color(0xFFFF9933).withOpacity(0.1)),
                                ),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.all(6),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFF9933).withOpacity(0.1),
                                            borderRadius: BorderRadius.circular(8),
                                          ),
                                          child: const Icon(
                                            Icons.analytics,
                                            color: Color(0xFFFF9933),
                                            size: 20,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Text(
                                          'Performance Overview',
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    GridView.count(
                                      shrinkWrap: true,
                                      physics: const NeverScrollableScrollPhysics(),
                                      crossAxisCount: 3,
                                      mainAxisSpacing: 12,
                                      crossAxisSpacing: 12,
                                      childAspectRatio: 1.1,
                                      children: [
                                        _buildMetricCard(
                                          'Total Orders',
                                          '$totalOrders',
                                          Icons.receipt_long,
                                          Colors.blue,
                                          '$completedOrders completed',
                                        ),
                                        _buildMetricCard(
                                          'Gross Sales',
                                          formatIndianCurrency(settings.currency, totalSales),
                                          Icons.trending_up,
                                          Colors.green,
                                          '${totalOrders > 0 ? (totalSales / totalOrders).toStringAsFixed(0) : '0'} avg per order',
                                        ),
                                        _buildMetricCard(
                                          'Items Sold',
                                          '$totalItems',
                                          Icons.inventory,
                                          Colors.orange,
                                          '${totalOrders > 0 ? (totalItems / totalOrders).toStringAsFixed(1) : '0'} avg per order',
                                        ),
                                        _buildMetricCard(
                                          'Packaging Revenue',
                                          formatIndianCurrency(settings.currency, packagingRevenue),
                                          Icons.inventory_2,
                                          Colors.teal,
                                          totalOrders > 0 ? '${(packagingRevenue / totalOrders).toStringAsFixed(0)} avg per order' : 'No charges',
                                        ),
                                        _buildMetricCard(
                                          'Delivery Revenue',
                                          formatIndianCurrency(settings.currency, deliveryRevenue),
                                          Icons.delivery_dining,
                                          Colors.indigo,
                                          totalOrders > 0 ? '${(deliveryRevenue / totalOrders).toStringAsFixed(0)} avg per order' : 'No deliveries',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Enhanced Top 5 Items Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.amber.withOpacity(0.05),
                                      Colors.white,
                                    ],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(color: Colors.amber.withOpacity(0.2)),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.amber.withOpacity(0.1),
                                      blurRadius: 6,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.amber.withOpacity(0.15),
                                                borderRadius: BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.star,
                                                color: Colors.amber,
                                                size: 24,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              'Top Selling Items',
                                              style: TextStyle(
                                                fontSize: 22,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.black87,
                                              ),
                                            ),
                                          ],
                                        ),
                                        TextButton.icon(
                                          onPressed: () {
                                            // Show full item analysis
                                          },
                                          icon: const Icon(Icons.analytics, size: 16),
                                          label: const Text('View All'),
                                          style: TextButton.styleFrom(
                                            foregroundColor: const Color(0xFFFF9933),
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 20),
                                    Container(
                                      padding: const EdgeInsets.all(20),
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(16),
                                        border: Border.all(color: Colors.grey[200]!),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: topItems.isEmpty
                                          ? const Center(
                                              child: Padding(
                                                padding: EdgeInsets.all(20),
                                                child: Column(
                                                  children: [
                                                    Icon(
                                                      Icons.inventory_2_outlined,
                                                      size: 48,
                                                      color: Colors.grey,
                                                    ),
                                                    SizedBox(height: 12),
                                                    Text(
                                                      'No items sold in this period',
                                                      style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 16,
                                                        fontWeight: FontWeight.w500,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                          : Column(
                                              children: topItems
                                                  .take(5)
                                                  .map((entry) => _buildTopItemRow(
                                                        topItems.indexOf(entry) + 1,
                                                        entry.key,
                                                        entry.value['quantity'],
                                                        entry.value['revenue'],
                                                        settings,
                                                      ))
                                                  .toList(),
                                            ),
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
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showKOTSummaryDialog(BuildContext context, List<Order> orders, String businessName) {
    final dateRange = '${_formatKOTTimestamp(_startDate)} to ${_formatKOTTimestamp(_endDate)}';
    final summaryContent = _formatKOTSummaryReport(
      dateRange,
      orders,
      DateTime.now(),
      businessName,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.print, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            Text(l10n(ref, 'kot_summary')),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'REPORT',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 500),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Text(
                summaryContent,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 12,
                  height: 1.2,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n(ref, 'close')),
          ),
          ElevatedButton.icon(
            onPressed: () {
              // In a real implementation, this would send to printer
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('${l10n(ref, 'kot_summary')} sent to printer'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.print),
            label: Text(l10n(ref, 'print_again')),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );

    // Console output for debugging
    print('=== KOT SUMMARY REPORT ===');
    print(summaryContent);
    print('==========================');
  }

  // Helper methods to access the KOT formatting functions
  String _formatKOTSummaryReport(String dateRange, List<Order> orders, DateTime printTime, String businessName) {
    // Create a temporary OrderPlacementScreen to access the formatting method
    // In a real app, these would be static methods or in a separate utility class
    final buffer = StringBuffer();
    
    // Header: "KOT Summary – <Range>" with printed timestamp
    buffer.writeln('================================');
    buffer.writeln('     KOT SUMMARY - $dateRange');
    buffer.writeln('================================');
    buffer.writeln('Generated: ${_formatKOTTimestamp(printTime)}');
    buffer.writeln('--------------------------------');
    
    // Metrics: Orders, Gross Sales, Average Order, Items Sold
    final totalOrders = orders.length;
    final grossSales = orders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final averageOrder = totalOrders > 0 ? grossSales / totalOrders : 0.0;
    final totalItems = orders.fold(0, (sum, order) => 
      sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    
    buffer.writeln('METRICS:');
    buffer.writeln('Orders: $totalOrders');
    buffer.writeln('Gross Sales: ₹${grossSales.toStringAsFixed(2)}');
    buffer.writeln('Avg Order: ₹${averageOrder.toStringAsFixed(2)}');
    buffer.writeln('Items Sold: $totalItems');
    buffer.writeln('--------------------------------');
    
    // Top Items: name x qty
    final Map<String, int> itemCounts = {};
    for (final order in orders) {
      for (final item in order.items) {
        itemCounts[item.menuItem.name] = 
          (itemCounts[item.menuItem.name] ?? 0) + item.quantity;
      }
    }
    
    final topItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (topItems.isNotEmpty) {
      buffer.writeln('TOP ITEMS:');
      for (int i = 0; i < topItems.length && i < 5; i++) {
        final item = topItems[i];
        buffer.writeln('${item.key} x${item.value}');
      }
      buffer.writeln('--------------------------------');
    }
    
    // Footer: deviceId/store
    buffer.writeln('Store: $businessName');
    buffer.writeln('Device: POS-Terminal-01');
    buffer.writeln('================================');
    
    return buffer.toString();
  }

  String _formatKOTTimestamp(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  // Enhanced Report Helper Methods
  Widget _buildFilterChip(String label, ReportFilter filter) {
    final isSelected = _selectedFilter == filter;
    return Container(
      margin: const EdgeInsets.only(right: 8),
      child: Material(
        elevation: isSelected ? 4 : 2,
        borderRadius: BorderRadius.circular(10),
        shadowColor: isSelected ? const Color(0xFFFF9933).withOpacity(0.4) : Colors.black26,
        child: InkWell(
          onTap: () => _applyFilter(filter),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: isSelected 
                  ? [const Color(0xFFFF9933), const Color(0xFFFFB366)]
                  : [Colors.white, const Color(0xFFF8F9FA)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? const Color(0xFFFF9933) : const Color(0xFF34495E),
                width: isSelected ? 1.5 : 1.2,
              ),
            ),
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF2C3E50),
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w700,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _applyFilter(ReportFilter filter) {
    setState(() {
      _selectedFilter = filter;
      final now = DateTime.now();
      
      switch (filter) {
        case ReportFilter.today:
          _startDate = DateTime(now.year, now.month, now.day);
          _endDate = now;
          break;
        case ReportFilter.yesterday:
          final yesterday = now.subtract(const Duration(days: 1));
          _startDate = DateTime(yesterday.year, yesterday.month, yesterday.day);
          _endDate = DateTime(yesterday.year, yesterday.month, yesterday.day, 23, 59, 59);
          break;
        case ReportFilter.last7Days:
          _startDate = now.subtract(const Duration(days: 7));
          _endDate = now;
          break;
        case ReportFilter.custom:
          _showDateRangePicker(context);
          break;
        // Handle removed cases with default behavior
        case ReportFilter.thisWeek:
        case ReportFilter.thisMonth:
        case ReportFilter.last30Days:
        case ReportFilter.thisYear:
          // Default to today if these are somehow selected
          _startDate = DateTime(now.year, now.month, now.day);
          _endDate = now;
          break;
      }
    });
  }

  Widget _buildMetricCard(String title, String value, IconData icon, Color color, String subtitle) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 18, color: color),
            ),
            const SizedBox(height: 6),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                value,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 3),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 1),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(
                subtitle,
                style: TextStyle(
                  fontSize: 9,
                  color: Colors.grey[600],
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTopItemRow(int rank, String name, int quantity, double revenue, AppSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: rank <= 3 ? _getRankColor(rank) : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Text(
                '$rank',
                style: TextStyle(
                  color: rank <= 3 ? Colors.white : Colors.grey[600],
                  fontSize: 12,
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
                  name,
                  style: const TextStyle(fontWeight: FontWeight.w500),
                ),
                Text(
                  '$quantity items • ${formatIndianCurrency(settings.currency, revenue)}',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9933).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              '$quantity sold',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFFFF9933),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Color _getRankColor(int rank) {
    switch (rank) {
      case 1:
        return Colors.amber; // Gold
      case 2:
        return Colors.grey; // Silver
      case 3:
        return Colors.brown; // Bronze
      default:
        return Colors.grey;
    }
  }

  Widget _buildDailyTrendRow(DateTime date, int orders, double sales, int items, AppSettings settings) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.grey[50],
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.grey[200]!),
        ),
        child: Row(
          children: [
            Expanded(
              flex: 2,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _formatDate(date),
                    style: const TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _getDayName(date),
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$orders',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const Text('Orders', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    formatIndianCurrency(settings.currency, sales),
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green),
                  ),
                  const Text('Sales', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
            Expanded(
              child: Column(
                children: [
                  Text(
                    '$items',
                    style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.orange),
                  ),
                  const Text('Items', style: TextStyle(fontSize: 11)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _exportToCSV(BuildContext context, List<Order> orders, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.file_download, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            const Text('Export Order Reports'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose the type of report to export for the selected period:',
              style: TextStyle(color: Colors.grey[600]),
            ),
            const SizedBox(height: 20),
            _buildExportOption(
              context,
              'Complete Order Report',
              'Detailed report with all order information',
              Icons.receipt_long,
              () => _exportCompleteOrderReport(context, orders, settings),
            ),
            const SizedBox(height: 12),
            _buildExportOption(
              context,
              'Sales Summary',
              'Summary of sales metrics and totals',
              Icons.analytics,
              () => _exportSalesSummary(context, orders, settings),
            ),
            const SizedBox(height: 12),
            _buildExportOption(
              context,
              'Item-wise Report',
              'Breakdown by menu items sold',
              Icons.inventory_2,
              () => _exportItemwiseReport(context, orders, settings),
            ),
          ],
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

  Widget _buildExportOption(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9933).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFFFF9933), size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
      ),
    );
  }

  void _exportCompleteOrderReport(BuildContext context, List<Order> orders, AppSettings settings) {
    final buffer = StringBuffer();
    
    // Report Header
    buffer.writeln('=== COMPLETE ORDER REPORT ===');
    buffer.writeln('Business: ${settings.businessName}');
    buffer.writeln('Period: ${_formatDate(_startDate)} to ${_formatDate(_endDate)}');
    buffer.writeln('Generated: ${_formatDate(DateTime.now())} at ${DateTime.now().hour}:${DateTime.now().minute.toString().padLeft(2, '0')}');
    buffer.writeln('Total Orders: ${orders.length}');
    buffer.writeln('');
    
    // Detailed CSV Header
    buffer.writeln('Date,Time,Order ID,Customer Name,Phone,Order Type,Status,Items Count,Subtotal,Tax,Grand Total,Payment Method,Items Detail');
    
    // Detailed CSV Data
    for (final order in orders) {
      final date = _formatDate(order.createdAt);
      final time = '${order.createdAt.hour}:${order.createdAt.minute.toString().padLeft(2, '0')}';
      final orderId = order.id.substring(order.id.length - 8);
      final customerName = order.customer?.name ?? 'Guest';
      final phone = order.customer?.phone ?? 'N/A';
      final orderType = _getOrderTypeLabel(order.type);
      final status = _getStatusLabel(order.status);
      final itemsCount = order.items.length;
      final subtotal = order.subtotal.toStringAsFixed(2);
      final tax = order.taxAmount.toStringAsFixed(2);
      final total = order.grandTotal.toStringAsFixed(2);
      final paymentMethod = order.payments.isNotEmpty ? 'Paid' : 'Pending';
      
      // Items detail
      final itemsDetail = order.items.map((item) => 
        '${item.menuItem.name} (Qty: ${item.quantity}, Price: ${item.unitPrice.toStringAsFixed(2)})'
      ).join('; ');
      
      buffer.writeln('"$date","$time","$orderId","$customerName","$phone","$orderType","$status",$itemsCount,$subtotal,$tax,$total,"$paymentMethod","$itemsDetail"');
    }
    
    _showExportDialog(context, 'Complete Order Report', buffer.toString());
  }

  void _exportSalesSummary(BuildContext context, List<Order> orders, AppSettings settings) {
    final buffer = StringBuffer();
    final totalSales = orders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final totalOrders = orders.length;
    final avgOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;
    
    // Group by order type
    final dineInOrders = orders.where((o) => o.type == OrderType.dineIn).length;
    final takeawayOrders = orders.where((o) => o.type == OrderType.takeaway).length;
    final deliveryOrders = orders.where((o) => o.type == OrderType.delivery).length;
    
    buffer.writeln('=== SALES SUMMARY REPORT ===');
    buffer.writeln('Business: ${settings.businessName}');
    buffer.writeln('Period: ${_formatDate(_startDate)} to ${_formatDate(_endDate)}');
    buffer.writeln('Generated: ${_formatDate(DateTime.now())}');
    buffer.writeln('');
    buffer.writeln('OVERVIEW');
    buffer.writeln('Total Sales,${totalSales.toStringAsFixed(2)}');
    buffer.writeln('Total Orders,$totalOrders');
    buffer.writeln('Average Order Value,${avgOrderValue.toStringAsFixed(2)}');
    buffer.writeln('');
    buffer.writeln('ORDER TYPE BREAKDOWN');
    buffer.writeln('Dine In,$dineInOrders');
    buffer.writeln('Takeaway,$takeawayOrders');
    buffer.writeln('Delivery,$deliveryOrders');
    buffer.writeln('');
    buffer.writeln('DAILY BREAKDOWN');
    buffer.writeln('Date,Orders,Sales');
    
    // Group by date
    final dailyData = <String, Map<String, dynamic>>{};
    for (final order in orders) {
      final dateKey = _formatDate(order.createdAt);
      if (!dailyData.containsKey(dateKey)) {
        dailyData[dateKey] = {'orders': 0, 'sales': 0.0};
      }
      dailyData[dateKey]!['orders']++;
      dailyData[dateKey]!['sales'] += order.grandTotal;
    }
    
    for (final entry in dailyData.entries) {
      buffer.writeln('${entry.key},${entry.value['orders']},${entry.value['sales'].toStringAsFixed(2)}');
    }
    
    _showExportDialog(context, 'Sales Summary Report', buffer.toString());
  }

  void _exportItemwiseReport(BuildContext context, List<Order> orders, AppSettings settings) {
    final buffer = StringBuffer();
    final itemData = <String, Map<String, dynamic>>{};
    
    // Aggregate item data
    for (final order in orders) {
      for (final item in order.items) {
        final itemName = item.menuItem.name;
        if (!itemData.containsKey(itemName)) {
          itemData[itemName] = {
            'quantity': 0,
            'revenue': 0.0,
            'orders': <String>{},
          };
        }
        itemData[itemName]!['quantity'] += item.quantity;
        itemData[itemName]!['revenue'] += item.unitPrice * item.quantity;
        itemData[itemName]!['orders'].add(order.id);
      }
    }
    
    // Sort by revenue
    final sortedItems = itemData.entries.toList()
      ..sort((a, b) => b.value['revenue'].compareTo(a.value['revenue']));
    
    buffer.writeln('=== ITEM-WISE SALES REPORT ===');
    buffer.writeln('Business: ${settings.businessName}');
    buffer.writeln('Period: ${_formatDate(_startDate)} to ${_formatDate(_endDate)}');
    buffer.writeln('Generated: ${_formatDate(DateTime.now())}');
    buffer.writeln('');
    buffer.writeln('Item Name,Quantity Sold,Revenue,Orders Count,Avg Price');
    
    for (final item in sortedItems) {
      final name = item.key;
      final quantity = item.value['quantity'];
      final revenue = item.value['revenue'].toStringAsFixed(2);
      final ordersCount = (item.value['orders'] as Set).length;
      final avgPrice = (item.value['revenue'] / quantity).toStringAsFixed(2);
      
      buffer.writeln('"$name",$quantity,$revenue,$ordersCount,$avgPrice');
    }
    
    _showExportDialog(context, 'Item-wise Sales Report', buffer.toString());
  }

  void _showExportDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.file_download, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            Expanded(child: Text(title, style: const TextStyle(fontSize: 16))),
          ],
        ),
        content: Container(
          width: double.maxFinite,
          constraints: const BoxConstraints(maxHeight: 400),
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Text(
                content,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 10,
                ),
              ),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('$title ready for download'),
                  backgroundColor: Colors.green,
                ),
              );
              Navigator.pop(context);
            },
            icon: const Icon(Icons.download),
            label: const Text('Download'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  String _getDayName(DateTime date) {
    const days = ['Sun', 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat'];
    return days[date.weekday % 7];
  }

  String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return Colors.orange;
      case OrderStatus.confirmed:
        return Colors.blue;
      case OrderStatus.preparing:
        return Colors.purple;
      case OrderStatus.ready:
        return Colors.green;
      case OrderStatus.completed:
        return Colors.grey;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _getStatusLabel(OrderStatus status) {
    switch (status) {
      case OrderStatus.pending:
        return 'Pending';
      case OrderStatus.confirmed:
        return 'Confirmed';
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

  String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  Future<void> _showDateRangePicker(BuildContext context) async {
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      initialDateRange: DateTimeRange(start: _startDate, end: _endDate),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: const Color(0xFFFF9933),
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
        _selectedFilter = ReportFilter.custom;
      });
    }
  }
}

// Settings Screen
class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n(ref, 'settings')),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Business Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(ref, 'business_information'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.business),
                      title: Text(l10n(ref, 'business_name')),
                      subtitle: Text(settings.businessName),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, ref, l10n(ref, 'business_name'), settings.businessName, 
                          (value) => ref.read(settingsProvider.notifier).updateBusinessName(value)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.location_on),
                      title: Text(l10n(ref, 'address')),
                      subtitle: Text(settings.address.isEmpty ? l10n(ref, 'not_set') : settings.address),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, ref, l10n(ref, 'address'), settings.address, 
                          (value) => ref.read(settingsProvider.notifier).updateAddress(value)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.phone),
                      title: Text(l10n(ref, 'phone')),
                      subtitle: Text(settings.phone.isEmpty ? l10n(ref, 'not_set') : settings.phone),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, ref, l10n(ref, 'phone'), settings.phone, 
                          (value) => ref.read(settingsProvider.notifier).updatePhone(value)),
                    ),
                    ListTile(
                      leading: const Icon(Icons.email),
                      title: Text(l10n(ref, 'email')),
                      subtitle: Text(settings.email.isEmpty ? l10n(ref, 'not_set') : settings.email),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showEditDialog(context, ref, l10n(ref, 'email'), settings.email, 
                          (value) => ref.read(settingsProvider.notifier).updateEmail(value)),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Menu Management Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.restaurant_menu, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        Text(l10n(ref, 'menu'), style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.add_circle, color: Color(0xFFFF9933)),
                      title: const Text('Add Menu Item'),
                      subtitle: const Text('Add new items to your menu'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showAddItemDialog(context, ref),
                    ),
                    ListTile(
                      leading: const Icon(Icons.edit, color: Color(0xFFFF9933)),
                      title: const Text('Manage Menu Items'),
                      subtitle: const Text('Edit existing menu items'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showMenuManagementDialog(context, ref),
                    ),
                    ListTile(
                      leading: const Icon(Icons.category, color: Color(0xFFFF9933)),
                      title: const Text('Categories'),
                      subtitle: const Text('Manage menu categories'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showCategoriesDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Financial Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(ref, 'financial_settings'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.currency_rupee),
                      title: Text(l10n(ref, 'currency')),
                      subtitle: Text(settings.currency),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showCurrencySelector(context, ref),
                    ),
                    ListTile(
                      leading: const Icon(Icons.percent),
                      title: Text(l10n(ref, 'tax_rate')),
                      subtitle: Text('${(settings.taxRate * 100).toInt()}% GST'),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showTaxRateDialog(context, ref, settings.taxRate),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Feature Settings Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n(ref, 'feature_settings'), style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      secondary: const Icon(Icons.print),
                      title: Text(l10n(ref, 'kot_printing')),
                      subtitle: Text(l10n(ref, 'kot_printing_desc')),
                      value: settings.kotEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(kotEnabled: value),
                        );
                      },
                    ),
                    ListTile(
                      leading: const Icon(Icons.translate),
                      title: Text(l10n(ref, 'default_language')),
                      subtitle: Text(settings.defaultLanguage == 'en' ? l10n(ref, 'english') : l10n(ref, 'hindi')),
                      trailing: const Icon(Icons.edit),
                      onTap: () => _showLanguageSelector(context, ref, settings.defaultLanguage),
                    ),
                    SwitchListTile(
                      secondary: const Icon(Icons.delivery_dining),
                      title: Text(l10n(ref, 'delivery_service')),
                      subtitle: Text(l10n(ref, 'delivery_service_desc')),
                      value: settings.deliveryEnabled,
                      activeColor: const Color(0xFFFF9933),
                      onChanged: (bool value) {
                        ref.read(settingsProvider.notifier).updateSettings(
                          settings.copyWith(deliveryEnabled: value),
                        );
                      },
                    ),
                    if (settings.deliveryEnabled) ...[
                      ListTile(
                        leading: const Icon(Icons.local_shipping),
                        title: const Text('Delivery Charge'),
                        subtitle: Text('${settings.currency}${settings.defaultDeliveryCharge.toStringAsFixed(2)}'),
                        trailing: const Icon(Icons.edit),
                        onTap: () => _showChargeDialog(context, ref, 'Delivery Charge', settings.defaultDeliveryCharge, 
                          (value) => ref.read(settingsProvider.notifier).updateSettings(
                            settings.copyWith(defaultDeliveryCharge: value),
                          ),
                        ),
                      ),
                      ListTile(
                        leading: const Icon(Icons.inventory),
                        title: const Text('Packaging Charge'),
                        subtitle: Text('${settings.currency}${settings.defaultPackagingCharge.toStringAsFixed(2)}'),
                        trailing: const Icon(Icons.edit),
                        onTap: () => _showChargeDialog(context, ref, 'Packaging Charge', settings.defaultPackagingCharge, 
                          (value) => ref.read(settingsProvider.notifier).updateSettings(
                            settings.copyWith(defaultPackagingCharge: value),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Reports & Analytics Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.analytics, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        const Text('Reports & Analytics', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      ],
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      leading: const Icon(Icons.bar_chart, color: Color(0xFFFF9933)),
                      title: const Text('Sales Reports'),
                      subtitle: const Text('View sales analytics and trends'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const ReportsScreen()),
                      ),
                    ),
                    ListTile(
                      leading: const Icon(Icons.receipt_long, color: Color(0xFFFF9933)),
                      title: const Text('KOT Summary'),
                      subtitle: const Text('Kitchen order ticket reports'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () => _showKOTReportsDialog(context, ref),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // App Information Card
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('App Information', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),
                    const ListTile(
                      leading: Icon(Icons.info),
                      title: Text('Version'),
                      subtitle: Text('1.0.0'),
                    ),
                    const ListTile(
                      leading: Icon(Icons.developer_mode),
                      title: Text('Developer'),
                      subtitle: Text('QSR Solutions'),
                    ),
                    ListTile(
                      leading: const Icon(Icons.help),
                      title: const Text('Support'),
                      subtitle: const Text('Get help and support'),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Contact support: support@qsrsolutions.com')),
                        );
                      },
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

  void _showEditDialog(BuildContext context, WidgetRef ref, String title, String currentValue, Function(String) onUpdate) {
    final controller = TextEditingController(text: currentValue);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: title,
            border: const OutlineInputBorder(),
          ),
          keyboardType: title == 'Phone' ? TextInputType.phone : 
                       title == 'Email' ? TextInputType.emailAddress : TextInputType.text,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              onUpdate(controller.text);
              Navigator.pop(context);
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showCurrencySelector(BuildContext context, WidgetRef ref) {
    final currencies = [
      {'symbol': '₹', 'name': 'Indian Rupee'},
      {'symbol': '\$', 'name': 'US Dollar'},
      {'symbol': '€', 'name': 'Euro'},
      {'symbol': '£', 'name': 'British Pound'},
    ];
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Currency'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: currencies.map((currency) => ListTile(
            leading: Text(currency['symbol']!, style: const TextStyle(fontSize: 24)),
            title: Text(currency['name']!),
            onTap: () {
              ref.read(settingsProvider.notifier).updateCurrency(currency['symbol']!);
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }

  void _showTaxRateDialog(BuildContext context, WidgetRef ref, double currentRate) {
    final controller = TextEditingController(text: (currentRate * 100).toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Tax Rate'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Tax Rate (%)',
                border: OutlineInputBorder(),
                helperText: 'Enter tax rate as percentage (e.g., 18 for 18%)',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            const Text('Common tax rates:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [0, 5, 12, 18, 28].map((rate) => 
                ActionChip(
                  label: Text('$rate%'),
                  onPressed: () => controller.text = rate.toString(),
                ),
              ).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final rate = double.tryParse(controller.text);
              if (rate != null && rate >= 0 && rate <= 100) {
                ref.read(settingsProvider.notifier).updateTaxRate(rate / 100);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showLanguageSelector(BuildContext context, WidgetRef ref, String currentLanguage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Select Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile<String>(
              title: const Text('English'),
              value: 'en',
              groupValue: currentLanguage,
              activeColor: const Color(0xFFFF9933),
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                    ref.read(settingsProvider).copyWith(defaultLanguage: value),
                  );
                  Navigator.pop(context);
                }
              },
            ),
            RadioListTile<String>(
              title: const Text('हिंदी (Hindi)'),
              value: 'hi',
              groupValue: currentLanguage,
              activeColor: const Color(0xFFFF9933),
              onChanged: (value) {
                if (value != null) {
                  ref.read(settingsProvider.notifier).updateSettings(
                    ref.read(settingsProvider).copyWith(defaultLanguage: value),
                  );
                  Navigator.pop(context);
                }
              },
            ),
          ],
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

  void _showChargeDialog(BuildContext context, WidgetRef ref, String title, double currentValue, Function(double) onUpdate) {
    final controller = TextEditingController(text: currentValue.toStringAsFixed(2));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '$title Amount',
            border: const OutlineInputBorder(),
            prefixText: '₹ ',
          ),
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(controller.text);
              if (amount != null && amount >= 0) {
                onUpdate(amount);
                Navigator.pop(context);
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  // Menu Management Methods
  void _showAddItemDialog(BuildContext context, WidgetRef ref) {
    final nameController = TextEditingController();
    final dineInPriceController = TextEditingController();
    final takeawayPriceController = TextEditingController();
    final deliveryPriceController = TextEditingController();
    final categoryController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Menu Item'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name*'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dineInPriceController,
                  decoration: const InputDecoration(labelText: 'Dine In Price*', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: takeawayPriceController,
                  decoration: const InputDecoration(labelText: 'Takeaway Price', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deliveryPriceController,
                  decoration: const InputDecoration(labelText: 'Delivery Price', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 8),
                const Text(
                  '* Required fields\nLeave takeaway/delivery price empty to use dine-in price',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
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
            onPressed: () {
              if (nameController.text.isNotEmpty && dineInPriceController.text.isNotEmpty) {
                final dineInPrice = double.tryParse(dineInPriceController.text) ?? 0;
                final item = MenuItem(
                  id: DateTime.now().millisecondsSinceEpoch.toString(),
                  name: nameController.text,
                  dineInPrice: dineInPrice,
                  takeawayPrice: double.tryParse(takeawayPriceController.text) ?? dineInPrice,
                  deliveryPrice: double.tryParse(deliveryPriceController.text),
                  category: categoryController.text.isEmpty ? 'General' : categoryController.text,
                );
                ref.read(menuProvider.notifier).addMenuItem(item);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${item.name} added to menu')),
                );
              }
            },
            child: const Text('Add Item'),
          ),
        ],
      ),
    );
  }

  void _showMenuManagementDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        child: Container(
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.8,
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Menu Management', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const Divider(),
              Expanded(
                child: Consumer(
                  builder: (context, ref, child) {
                    final menuItems = ref.watch(menuProvider);
                    final settings = ref.watch(settingsProvider);
                    
                    if (menuItems.isEmpty) {
                      return const Center(
                        child: Text('No menu items available\nTap + to add items'),
                      );
                    }
                    
                    return ListView.builder(
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) {
                        final item = menuItems[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item.name,
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                      ),
                                    ),
                                    Switch(
                                      value: item.isAvailable,
                                      activeColor: const Color(0xFFFF9933),
                                      onChanged: (value) {
                                        final updatedItem = MenuItem(
                                          id: item.id,
                                          name: item.name,
                                          dineInPrice: item.dineInPrice,
                                          takeawayPrice: item.takeawayPrice,
                                          deliveryPrice: item.deliveryPrice,
                                          category: item.category,
                                          isAvailable: value,
                                        );
                                        ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
                                      },
                                    ),
                                  ],
                                ),
                                Text(
                                  item.category,
                                  style: TextStyle(color: Colors.grey[600], fontSize: 14),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Dine In: ${formatIndianCurrency(settings.currency, item.dineInPrice)}'),
                                          Text('Takeaway: ${formatIndianCurrency(settings.currency, item.takeawayPrice)}'),
                                          if (item.deliveryPrice != null)
                                            Text('Delivery: ${formatIndianCurrency(settings.currency, item.deliveryPrice!)}')
                                          else
                                            Text('Delivery: ${formatIndianCurrency(settings.currency, item.takeawayPrice)}'),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      children: [
                                        IconButton(
                                          icon: const Icon(Icons.edit, color: Color(0xFFFF9933)),
                                          onPressed: () => _showEditItemDialog(context, ref, item),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete, color: Colors.red),
                                          onPressed: () => _showDeleteConfirmDialog(context, ref, item),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showEditItemDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    final nameController = TextEditingController(text: item.name);
    final dineInPriceController = TextEditingController(text: item.dineInPrice.toString());
    final takeawayPriceController = TextEditingController(text: item.takeawayPrice.toString());
    final deliveryPriceController = TextEditingController(text: item.deliveryPrice?.toString() ?? '');
    final categoryController = TextEditingController(text: item.category);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit ${item.name}'),
        content: SizedBox(
          width: double.maxFinite,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(labelText: 'Item Name*'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: categoryController,
                  decoration: const InputDecoration(labelText: 'Category'),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: dineInPriceController,
                  decoration: const InputDecoration(labelText: 'Dine In Price*', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: takeawayPriceController,
                  decoration: const InputDecoration(labelText: 'Takeaway Price*', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: deliveryPriceController,
                  decoration: const InputDecoration(labelText: 'Delivery Price', prefixText: '₹ '),
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
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
            onPressed: () {
              if (nameController.text.isNotEmpty && 
                  dineInPriceController.text.isNotEmpty && 
                  takeawayPriceController.text.isNotEmpty) {
                final updatedItem = MenuItem(
                  id: item.id,
                  name: nameController.text,
                  dineInPrice: double.tryParse(dineInPriceController.text) ?? 0,
                  takeawayPrice: double.tryParse(takeawayPriceController.text) ?? 0,
                  deliveryPrice: deliveryPriceController.text.isNotEmpty 
                      ? double.tryParse(deliveryPriceController.text)
                      : null,
                  category: categoryController.text.isEmpty ? 'General' : categoryController.text,
                  isAvailable: item.isAvailable,
                );
                ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('${updatedItem.name} updated')),
                );
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, WidgetRef ref, MenuItem item) {
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
              ref.read(menuProvider.notifier).removeMenuItem(item.id);
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('${item.name} removed from menu')),
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Delete', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showCategoriesDialog(BuildContext context, WidgetRef ref) {
    final menuItems = ref.read(menuProvider);
    final categories = menuItems.map((item) => item.category).toSet().toList();
    categories.sort();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Menu Categories'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: categories.isEmpty
              ? const Center(child: Text('No categories found'))
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final itemCount = menuItems.where((item) => item.category == category).length;
                    return ListTile(
                      leading: const Icon(Icons.category, color: Color(0xFFFF9933)),
                      title: Text(category),
                      subtitle: Text('$itemCount item${itemCount != 1 ? 's' : ''}'),
                    );
                  },
                ),
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

  // Reports & Analytics Methods
  void _showKOTReportsDialog(BuildContext context, WidgetRef ref) {
    final allOrders = ref.read(ordersProvider);
    final settings = ref.read(settingsProvider);
    final now = DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day);
    final endOfDay = startOfDay.add(const Duration(hours: 23, minutes: 59, seconds: 59));

    // Filter today's orders
    final todaysOrders = allOrders.where((order) =>
        order.createdAt.isAfter(startOfDay) &&
        order.createdAt.isBefore(endOfDay)).toList();

    final dateRange = '${_formatKOTTimestamp(startOfDay)} to ${_formatKOTTimestamp(endOfDay)}';
    final summaryContent = _formatKOTSummaryReport(
      dateRange,
      todaysOrders,
      now,
      settings.businessName,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            const Icon(Icons.receipt_long, color: Color(0xFFFF9933)),
            const SizedBox(width: 8),
            const Text('KOT Summary'),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Text(
                'TODAY',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Text(
              summaryContent,
              style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              print('Printing KOT Summary...\n$summaryContent');
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('KOT Summary sent to printer')),
              );
            },
            child: const Text('Print'),
          ),
        ],
      ),
    );
  }

  String _formatKOTTimestamp(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatKOTSummaryReport(String dateRange, List<Order> orders, DateTime printTime, String businessName) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('='.padRight(32, '='));
    buffer.writeln(businessName.length > 32 ? businessName.substring(0, 29) + '...' : businessName.padLeft((32 + businessName.length) ~/ 2));
    buffer.writeln('KOT SUMMARY REPORT'.padLeft(25));
    buffer.writeln('='.padRight(32, '='));
    buffer.writeln();
    
    // Report details
    buffer.writeln('Period: $dateRange');
    buffer.writeln('Generated: ${_formatKOTTimestamp(printTime)}');
    buffer.writeln('-'.padRight(32, '-'));
    
    if (orders.isEmpty) {
      buffer.writeln('No orders found for this period');
      buffer.writeln();
      buffer.writeln('='.padRight(32, '='));
      return buffer.toString();
    }
    
    // Summary stats
    final totalSales = orders.fold(0.0, (sum, order) => sum + order.grandTotal);
    final completedOrders = orders.where((order) => order.status == OrderStatus.completed).length;
    final avgOrderValue = totalSales / orders.length;
    
    buffer.writeln('SUMMARY:');
    buffer.writeln('Total Orders: ${orders.length}');
    buffer.writeln('Completed: $completedOrders');
    buffer.writeln('Total Sales: ₹${totalSales.toStringAsFixed(2)}');
    buffer.writeln('Avg Order: ₹${avgOrderValue.toStringAsFixed(2)}');
    buffer.writeln('-'.padRight(32, '-'));
    
    // Order breakdown by status
    final pendingOrders = orders.where((order) => order.status == OrderStatus.pending).length;
    final preparingOrders = orders.where((order) => order.status == OrderStatus.preparing).length;
    
    buffer.writeln('ORDER STATUS:');
    buffer.writeln('Pending: $pendingOrders');
    buffer.writeln('Preparing: $preparingOrders');
    buffer.writeln('Completed: $completedOrders');
    buffer.writeln('-'.padRight(32, '-'));
    
    // Top items
    final Map<String, int> itemCounts = {};
    for (final order in orders) {
      for (final item in order.items) {
        itemCounts[item.menuItem.name] = (itemCounts[item.menuItem.name] ?? 0) + item.quantity;
      }
    }
    
    final topItems = itemCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    
    if (topItems.isNotEmpty) {
      buffer.writeln('TOP ITEMS:');
      for (int i = 0; i < topItems.length && i < 5; i++) {
        final item = topItems[i];
        final name = item.key.length > 20 ? item.key.substring(0, 17) + '...' : item.key;
        buffer.writeln('${(i + 1).toString().padLeft(2)}. $name x${item.value}');
      }
      buffer.writeln('-'.padRight(32, '-'));
    }
    
    buffer.writeln();
    buffer.writeln('='.padRight(32, '='));
    
    return buffer.toString();
  }
}
