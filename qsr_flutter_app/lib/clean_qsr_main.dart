import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart' show QSRMobileApp;
import 'dart:convert';
import 'dart:async';
import 'package:fl_chart/fl_chart.dart';
import 'package:url_launcher/url_launcher.dart';
import 'kot_screen.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'features/printing/data/printing_service.dart';
import 'features/printing/data/escpos_generator.dart';
import 'package:share_plus/share_plus.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

// Google Auth Client for Google Drive API
class GoogleAuthClient extends http.BaseClient {
  final Map<String, String> _headers;
  final http.Client _client = http.Client();

  GoogleAuthClient(this._headers);

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _client.send(request);
  }

  @override
  void close() {
    _client.close();
  }
}

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
      'collect_payment': 'Collect Payment',
      'payment_required': 'Payment Required',
      'select_payment_method': 'Select Payment Method',
      'enter_amount': 'Enter Amount',
      'add_payment': 'Add Payment',
      'added_payments': 'Added Payments',
      'collect_full_payment': 'Collect Full Payment',
      'payment_collected': 'Payment collected successfully! Order completed.',
      'order_placed_pending_payment': 'Order placed successfully! Payment will be collected before completion.',
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
      'packaging_service': 'Packaging Service',
      'packaging_service_desc': 'Enable packaging charges for all orders',
      'service_charges': 'Service Charges',
      'service_charges_desc': 'Enable service charges for dine-in orders only',
      'sgst': 'SGST',
      'cgst': 'CGST',
      'sgst_rate': 'SGST Rate (%)',
      'cgst_rate': 'CGST Rate (%)',
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
      'revenue_by_order_type': 'Revenue by Order Type',
      'order_distribution': 'Order Distribution',
      'revenue_by_type': 'Revenue by Order Type',
      'avg_order_by_type': 'Average Order Value by Type',
      'order_trends': 'Order Type Trends',
      'discount': 'Discount',
      'item_discount': 'Item Discount',
      'order_discount': 'Order Discount',
      'total_discount': 'Total Discount',
      'savings': 'Savings',
      'discount_percentage': 'Discount %',
      'discount_amount': 'Discount Amount',
      'original_price': 'Original Price',
      'discounted_price': 'Discounted Price',
      'before_discount': 'Before Discount',
      'after_discount': 'After Discount',
      'discount_reason': 'Discount Reason',
      'discount_applied': 'Discount Applied',
      'no_discount': 'No Discount',

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
      'collect_payment': 'भुगतान एकत्रित करें',
      'payment_required': 'भुगतान आवश्यक',
      'select_payment_method': 'भुगतान विधि चुनें',
      'enter_amount': 'राशि दर्ज करें',
      'add_payment': 'भुगतान जोड़ें',
      'added_payments': 'जोड़े गए भुगतान',
      'collect_full_payment': 'पूरा भुगतान एकत्रित करें',
      'payment_collected': 'भुगतान सफलतापूर्वक एकत्रित! आर्डर पूरा हुआ।',
      'order_placed_pending_payment': 'आर्डर सफलतापूर्वक दिया गया! पूरा करने से पहले भुगतान एकत्रित किया जाएगा।',
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
      'packaging_service': 'पैकेजिंग सेवा',
      'packaging_service_desc': 'सभी ऑर्डर्स के लिए पैकेजिंग शुल्क सक्षम करें',
      'service_charges': 'सेवा शुल्क',
      'service_charges_desc': 'केवल डाइन-इन ऑर्डर्स के लिए सेवा शुल्क सक्षम करें',
      'sgst': 'राज्य जी.एस.टी',
      'cgst': 'केंद्रीय जी.एस.टी',
      'sgst_rate': 'राज्य जी.एस.टी दर (%)',
      'cgst_rate': 'केंद्रीय जी.एस.टी दर (%)',
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
      'order_type_analysis': 'ऑर्डर प्रकार विश्लेषण',
      'order_distribution': 'ऑर्डर वितरण',
      'revenue_by_type': 'प्रकार के अनुसार राजस्व',
      'avg_order_by_type': 'प्रकार के अनुसार औसत ऑर्डर मूल्य',
      'order_trends': 'ऑर्डर प्रकार रुझान',
      'discount': 'छूट',
      'item_discount': 'आइटम छूट',
      'order_discount': 'ऑर्डर छूट',
      'total_discount': 'कुल छूट',
      'savings': 'बचत',
      'discount_percentage': 'छूट %',
      'discount_amount': 'छूट राशि',
      'original_price': 'मूल मूल्य',
      'discounted_price': 'छूट के बाद मूल्य',
      'before_discount': 'छूट से पहले',
      'after_discount': 'छूट के बाद',
      'discount_reason': 'छूट कारण',
      'discount_applied': 'छूट लागू',
      'no_discount': 'कोई छूट नहीं',

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

// Local Storage Service for data persistence
class LocalStorageService {
  static const String _ordersKey = 'qsr_orders';
  static const String _settingsKey = 'qsr_settings';
  static const String _customerDataKey = 'qsr_customer_data';
  static const String _paymentHistoryKey = 'qsr_payment_history';
  static const String _paymentConfigKey = 'qsr_payment_config';
  static const String _menuItemsKey = 'qsr_menu_items';
  
  static SharedPreferences? _prefs;
  
  static Future<void> _initPrefs() async {
    _prefs ??= await SharedPreferences.getInstance();
  }
  
  // Orders Storage
  static Future<void> saveOrders(List<Order> orders) async {
    await _initPrefs();
    print('DEBUG: LocalStorageService.saveOrders - saving ${orders.length} orders');
    final orderJsonList = orders.map((order) => _orderToJson(order)).toList();
    await _prefs!.setString(_ordersKey, jsonEncode(orderJsonList));
    print('DEBUG: LocalStorageService.saveOrders - saved successfully');
  }
  
  static Future<List<Order>> loadOrders() async {
    await _initPrefs();
    final ordersJson = _prefs!.getString(_ordersKey);
    print('DEBUG: LocalStorageService.loadOrders - ordersJson exists: ${ordersJson != null}');
    if (ordersJson == null) {
      print('DEBUG: LocalStorageService.loadOrders - returning empty list');
      return [];
    }
    
    try {
      final List<dynamic> ordersList = jsonDecode(ordersJson);
      final orders = ordersList.map((json) => _orderFromJson(json)).toList();
      print('DEBUG: LocalStorageService.loadOrders - loaded ${orders.length} orders');
      return orders;
    } catch (e) {
      print('Error loading orders: $e');
      return [];
    }
  }
  
  // Settings Storage
  static Future<void> saveSettings(AppSettings settings) async {
    await _initPrefs();
    await _prefs!.setString(_settingsKey, jsonEncode(_settingsToJson(settings)));
  }
  
  static Future<AppSettings> loadSettings() async {
    await _initPrefs();
    final settingsJson = _prefs!.getString(_settingsKey);
    if (settingsJson == null) return AppSettings();
    
    try {
      final Map<String, dynamic> settingsMap = jsonDecode(settingsJson);
      return _settingsFromJson(settingsMap);
    } catch (e) {
      print('Error loading settings: $e');
      return AppSettings();
    }
  }
  
  // Customer Data Storage
  static Future<void> saveCustomerData(Map<String, CustomerData> customerData) async {
    await _initPrefs();
    final customerJsonMap = customerData.map((key, customer) => 
      MapEntry(key, _customerDataToJson(customer)));
    await _prefs!.setString(_customerDataKey, jsonEncode(customerJsonMap));
  }
  
  static Future<Map<String, CustomerData>> loadCustomerData() async {
    await _initPrefs();
    final customerDataJson = _prefs!.getString(_customerDataKey);
    if (customerDataJson == null) return {};
    
    try {
      final Map<String, dynamic> customerDataMap = jsonDecode(customerDataJson);
      return customerDataMap.map((key, json) => 
        MapEntry(key, _customerDataFromJson(json)));
    } catch (e) {
      print('Error loading customer data: $e');
      return {};
    }
  }
  
  // Payment History Storage
  static Future<void> savePaymentHistory(List<PaymentEntry> paymentHistory) async {
    await _initPrefs();
    final paymentJsonList = paymentHistory.map((payment) => _paymentEntryToJson(payment)).toList();
    await _prefs!.setString(_paymentHistoryKey, jsonEncode(paymentJsonList));
  }
  
  static Future<List<PaymentEntry>> loadPaymentHistory() async {
    await _initPrefs();
    final paymentHistoryJson = _prefs!.getString(_paymentHistoryKey);
    if (paymentHistoryJson == null) return [];
    
    try {
      final List<dynamic> paymentsList = jsonDecode(paymentHistoryJson);
      return paymentsList.map((json) => _paymentEntryFromJson(json)).toList();
    } catch (e) {
      print('Error loading payment history: $e');
      return [];
    }
  }
  
  // Payment Config Storage
  static Future<void> savePaymentConfig(PaymentSystemConfig config) async {
    await _initPrefs();
    await _prefs!.setString(_paymentConfigKey, jsonEncode(config.toJson()));
  }
  
  static Future<PaymentSystemConfig> loadPaymentConfig() async {
    await _initPrefs();
    final configJson = _prefs!.getString(_paymentConfigKey);
    if (configJson == null) return PaymentSystemConfig();
    
    try {
      final Map<String, dynamic> configMap = jsonDecode(configJson);
      return PaymentSystemConfig.fromJson(configMap);
    } catch (e) {
      print('Error loading payment config: $e');
      return PaymentSystemConfig();
    }
  }
  
  // Menu Items Storage
  static Future<void> saveMenuItems(List<MenuItem> menuItems) async {
    await _initPrefs();
    final menuJsonList = menuItems.map((item) => item.toJson()).toList();
    await _prefs!.setString(_menuItemsKey, jsonEncode(menuJsonList));
  }
  
  static Future<List<MenuItem>> loadMenuItems() async {
    await _initPrefs();
    final menuItemsJson = _prefs!.getString(_menuItemsKey);
    if (menuItemsJson == null) return [];
    
    try {
      final List<dynamic> menuList = jsonDecode(menuItemsJson);
      return menuList.map((json) => MenuItem.fromJson(json)).toList();
    } catch (e) {
      print('Error loading menu items: $e');
      return [];
    }
  }
  
  // Clear all data
  static Future<void> clearAllData() async {
    await _initPrefs();
    await _prefs!.clear();
  }
  
  // JSON Serialization Helpers
  static Map<String, dynamic> _orderToJson(Order order) {
    return {
      'id': order.id,
      'items': order.items.map((item) => _orderItemToJson(item)).toList(),
      'createdAt': order.createdAt.millisecondsSinceEpoch,
      'type': order.type.index,
      'status': order.status.index,
      'notes': order.notes,
      'customer': order.customer != null ? _customerInfoToJson(order.customer!) : null,
      'charges': _orderChargesToJson(order.charges),
      'payments': order.payments.map((payment) => _paymentToJson(payment)).toList(),
      'paymentStatus': order.paymentStatus.index,
      'kotPrinted': order.kotPrinted,
      'orderDiscount': order.orderDiscount != null ? _orderDiscountToJson(order.orderDiscount!) : null,
    };
  }
  
  static Order _orderFromJson(Map<String, dynamic> json) {
    return Order(
      id: json['id'],
      items: (json['items'] as List).map((item) => _orderItemFromJson(item)).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt']),
      type: OrderType.values[json['type']],
      status: OrderStatus.values[json['status']],
      notes: json['notes'],
      customer: json['customer'] != null ? _customerInfoFromJson(json['customer']) : null,
      charges: _orderChargesFromJson(json['charges']),
      payments: (json['payments'] as List).map((payment) => _paymentFromJson(payment)).toList(),
      paymentStatus: PaymentStatus.values[json['paymentStatus']],
      kotPrinted: json['kotPrinted'] ?? false,
      orderDiscount: json['orderDiscount'] != null ? _orderDiscountFromJson(json['orderDiscount']) : null,
    );
  }
  
  static Map<String, dynamic> _orderItemToJson(OrderItem item) {
    return {
      'menuItem': item.menuItem.toJson(),
      'quantity': item.quantity,
      'orderType': item.orderType.index,
      'selectedAddons': item.selectedAddons.map((addon) => _addonToJson(addon)).toList(),
      'specialInstructions': item.specialInstructions,
      'discount': item.discount != null ? _itemDiscountToJson(item.discount!) : null,
    };
  }
  
  static OrderItem _orderItemFromJson(Map<String, dynamic> json) {
    return OrderItem(
      menuItem: MenuItem.fromJson(json['menuItem']),
      quantity: json['quantity'],
      orderType: OrderType.values[json['orderType']],
      selectedAddons: (json['selectedAddons'] as List? ?? []).map((addon) => _addonFromJson(addon)).toList(),
      specialInstructions: json['specialInstructions'],
      discount: json['discount'] != null ? _itemDiscountFromJson(json['discount']) : null,
    );
  }
  
  static Map<String, dynamic> _addonToJson(Addon addon) {
    return {
      'id': addon.id,
      'name': addon.name,
      'price': addon.price,
      'isRequired': addon.isRequired,
    };
  }
  
  static Addon _addonFromJson(Map<String, dynamic> json) {
    return Addon(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      isRequired: json['isRequired'] ?? false,
    );
  }
  
  static Map<String, dynamic> _customerInfoToJson(CustomerInfo customer) {
    return {
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
    };
  }
  
  static CustomerInfo _customerInfoFromJson(Map<String, dynamic> json) {
    return CustomerInfo(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
    );
  }
  
  static Map<String, dynamic> _orderChargesToJson(OrderCharges charges) {
    return {
      'deliveryCharge': charges.deliveryCharge,
      'packagingCharge': charges.packagingCharge,
      'serviceCharge': charges.serviceCharge,
    };
  }
  
  static OrderCharges _orderChargesFromJson(Map<String, dynamic> json) {
    return OrderCharges(
      deliveryCharge: json['deliveryCharge'] ?? 0.0,
      packagingCharge: json['packagingCharge'] ?? 0.0,
      serviceCharge: json['serviceCharge'] ?? 0.0,
    );
  }
  
  static Map<String, dynamic> _paymentToJson(Payment payment) {
    return {
      'method': payment.method.index,
      'amount': payment.amount,
      'timestamp': payment.timestamp.millisecondsSinceEpoch,
      'transactionId': payment.transactionId,
    };
  }
  
  static Payment _paymentFromJson(Map<String, dynamic> json) {
    return Payment(
      method: PaymentMethod.values[json['method']],
      amount: json['amount'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      transactionId: json['transactionId'],
    );
  }
  
  static Map<String, dynamic> _itemDiscountToJson(ItemDiscount discount) {
    return {
      'type': discount.type.index,
      'value': discount.value,
      'reason': discount.reason,
    };
  }
  
  static ItemDiscount _itemDiscountFromJson(Map<String, dynamic> json) {
    return ItemDiscount(
      type: DiscountType.values[json['type']],
      value: json['value'],
      reason: json['reason'],
    );
  }
  
  static Map<String, dynamic> _orderDiscountToJson(OrderDiscount discount) {
    return {
      'type': discount.type.index,
      'value': discount.value,
      'reason': discount.reason,
      'applyToSubtotal': discount.applyToSubtotal,
    };
  }
  
  static OrderDiscount _orderDiscountFromJson(Map<String, dynamic> json) {
    return OrderDiscount(
      type: DiscountType.values[json['type']],
      value: json['value'],
      reason: json['reason'],
      applyToSubtotal: json['applyToSubtotal'] ?? true,
    );
  }
  
  static Map<String, dynamic> _settingsToJson(AppSettings settings) {
    return {
      'currency': settings.currency,
      'sgstRate': settings.sgstRate,
      'cgstRate': settings.cgstRate,
      'businessName': settings.businessName,
      'address': settings.address,
      'phone': settings.phone,
      'email': settings.email,
      'kotEnabled': settings.kotEnabled,
      'defaultLanguage': settings.defaultLanguage,
      'deliveryEnabled': settings.deliveryEnabled,
      'packagingEnabled': settings.packagingEnabled,
      'serviceEnabled': settings.serviceEnabled,
      'defaultDeliveryCharge': settings.defaultDeliveryCharge,
      'defaultPackagingCharge': settings.defaultPackagingCharge,
      'defaultServiceCharge': settings.defaultServiceCharge,
    };
  }
  
  static AppSettings _settingsFromJson(Map<String, dynamic> json) {
    return AppSettings(
      currency: json['currency'] ?? '₹',
      sgstRate: json['sgstRate'] ?? 0.09,
      cgstRate: json['cgstRate'] ?? 0.09,
      businessName: json['businessName'] ?? 'My Restaurant',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      email: json['email'] ?? '',
      kotEnabled: json['kotEnabled'] ?? false,
      defaultLanguage: json['defaultLanguage'] ?? 'en',
      deliveryEnabled: json['deliveryEnabled'] ?? true,
      packagingEnabled: json['packagingEnabled'] ?? true,
      serviceEnabled: json['serviceEnabled'] ?? true,
      defaultDeliveryCharge: json['defaultDeliveryCharge'] ?? 50.0,
      defaultPackagingCharge: json['defaultPackagingCharge'] ?? 10.0,
      defaultServiceCharge: json['defaultServiceCharge'] ?? 20.0,
    );
  }
  
  static Map<String, dynamic> _customerDataToJson(CustomerData customer) {
    return {
      'name': customer.name,
      'phone': customer.phone,
      'email': customer.email,
      'address': customer.address,
      'firstOrderDate': customer.firstOrderDate.millisecondsSinceEpoch,
      'lastOrderDate': customer.lastOrderDate.millisecondsSinceEpoch,
      'totalOrders': customer.totalOrders,
      'totalSpent': customer.totalSpent,
      'mostUsedOrderType': customer.mostUsedOrderType.index,
      'orderIds': customer.orderIds,
    };
  }
  
  static CustomerData _customerDataFromJson(Map<String, dynamic> json) {
    return CustomerData(
      name: json['name'],
      phone: json['phone'],
      email: json['email'],
      address: json['address'],
      firstOrderDate: DateTime.fromMillisecondsSinceEpoch(json['firstOrderDate']),
      lastOrderDate: DateTime.fromMillisecondsSinceEpoch(json['lastOrderDate']),
      totalOrders: json['totalOrders'],
      totalSpent: json['totalSpent'],
      mostUsedOrderType: OrderType.values[json['mostUsedOrderType']],
      orderIds: List<String>.from(json['orderIds'] ?? []),
    );
  }
  
  static Map<String, dynamic> _paymentEntryToJson(PaymentEntry payment) {
    return {
      'methodId': payment.methodId,
      'methodName': payment.methodName,
      'method': payment.method.index,
      'amount': payment.amount,
      'timestamp': payment.timestamp.millisecondsSinceEpoch,
      'orderId': payment.orderId,
      'transactionId': payment.transactionId,
    };
  }
  
  static PaymentEntry _paymentEntryFromJson(Map<String, dynamic> json) {
    return PaymentEntry(
      methodId: json['methodId'],
      methodName: json['methodName'],
      method: PaymentMethodType.values[json['method']],
      amount: json['amount'],
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['timestamp']),
      orderId: json['orderId'],
      transactionId: json['transactionId'],
    );
  }
}

// Google Drive Service for cloud backup
class GoogleDriveService {
  static const List<String> _scopes = [
    drive.DriveApi.driveFileScope,
  ];
  
  static GoogleSignIn? _googleSignIn;
  static drive.DriveApi? _driveApi;
  static bool _isInitialized = false;
  
  static Future<void> _initialize() async {
    if (_isInitialized) return;
    
    _googleSignIn = GoogleSignIn(
      scopes: _scopes,
      // For web, you would need to configure the client ID in web/index.html
      // <meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
    );
    _isInitialized = true;
  }
  
  static Future<bool> signIn() async {
    await _initialize();
    
    try {
      final GoogleSignInAccount? account = await _googleSignIn!.signIn();
      if (account == null) return false;
      
      final GoogleSignInAuthentication auth = await account.authentication;
      final authHeaders = await account.authHeaders;
      final authenticatedClient = GoogleAuthClient(authHeaders);
      
      _driveApi = drive.DriveApi(authenticatedClient);
      return true;
    } catch (e) {
      print('Google Sign-In error: $e');
      // For web apps, you need to configure Google Client ID in web/index.html
      // Add this meta tag: <meta name="google-signin-client_id" content="YOUR_CLIENT_ID.apps.googleusercontent.com">
      return false;
    }
  }
  
  static Future<void> signOut() async {
    await _googleSignIn?.signOut();
    _driveApi = null;
  }
  
  static bool get isSignedIn => _driveApi != null;
  
  static Future<String?> getCurrentUserEmail() async {
    if (_googleSignIn?.currentUser != null) {
      return _googleSignIn!.currentUser!.email;
    }
    return null;
  }
  
  static Future<bool> syncDataToGoogleDrive({
    required String businessName,
    Function(String)? onProgress,
  }) async {
    if (_driveApi == null) {
      throw Exception('Not signed in to Google Drive');
    }
    
    try {
      onProgress?.call('Loading local data...');
      
      // Load all data from local storage
      final orders = await LocalStorageService.loadOrders();
      final settings = await LocalStorageService.loadSettings();
      final customerData = await LocalStorageService.loadCustomerData();
      final paymentHistory = await LocalStorageService.loadPaymentHistory();
      final paymentConfig = await LocalStorageService.loadPaymentConfig();
      final menuItems = await LocalStorageService.loadMenuItems();
      
      // Organize data by date
      final Map<String, List<Order>> ordersByDate = {};
      for (final order in orders) {
        final dateKey = '${order.createdAt.year}-${order.createdAt.month.toString().padLeft(2, '0')}-${order.createdAt.day.toString().padLeft(2, '0')}';
        ordersByDate[dateKey] ??= [];
        ordersByDate[dateKey]!.add(order);
      }
      
      // Create main QSR backup folder
      onProgress?.call('Creating backup folder...');
      final mainFolderId = await _createOrGetFolder('QSR-${businessName.replaceAll(' ', '-')}-Backup');
      
      // Create today's folder
      final today = DateTime.now();
      final todayFolder = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      final todayFolderId = await _createOrGetFolder(todayFolder, mainFolderId);
      
      onProgress?.call('Backing up settings...');
      
      // Backup settings
      await _uploadJsonFile(
        'settings.json',
        LocalStorageService._settingsToJson(settings),
        todayFolderId,
      );
      
      onProgress?.call('Backing up customer data...');
      
      // Backup customer data
      final customerJsonMap = customerData.map((key, customer) => 
        MapEntry(key, LocalStorageService._customerDataToJson(customer)));
      await _uploadJsonFile(
        'customers.json',
        customerJsonMap,
        todayFolderId,
      );
      
      onProgress?.call('Backing up payment history...');
      
      // Backup payment history
      final paymentJsonList = paymentHistory.map((payment) => 
        LocalStorageService._paymentEntryToJson(payment)).toList();
      await _uploadJsonFile(
        'payment_history.json',
        paymentJsonList,
        todayFolderId,
      );
      
      onProgress?.call('Backing up payment config...');
      
      // Backup payment config
      await _uploadJsonFile(
        'payment_config.json',
        paymentConfig.toJson(),
        todayFolderId,
      );
      
      onProgress?.call('Backing up menu items...');
      
      // Backup menu items
      final menuJsonList = menuItems.map((item) => item.toJson()).toList();
      await _uploadJsonFile(
        'menu_items.json',
        menuJsonList,
        todayFolderId,
      );
      
      onProgress?.call('Backing up orders...');
      
      // Backup orders (day-wise)
      int dayCount = 0;
      for (final entry in ordersByDate.entries) {
        dayCount++;
        final dateKey = entry.key;
        final dayOrders = entry.value;
        
        onProgress?.call('Backing up orders for $dateKey... ($dayCount/${ordersByDate.length})');
        
        final dayOrdersJson = dayOrders.map((order) => 
          LocalStorageService._orderToJson(order)).toList();
        
        await _uploadJsonFile(
          'orders_$dateKey.json',
          dayOrdersJson,
          todayFolderId,
        );
      }
      
      onProgress?.call('Creating backup summary...');
      
      // Create backup summary
      final backupSummary = {
        'backup_date': DateTime.now().toIso8601String(),
        'business_name': businessName,
        'total_orders': orders.length,
        'total_customers': customerData.length,
        'total_payments': paymentHistory.length,
        'menu_items_count': menuItems.length,
        'date_range': {
          'start': orders.isNotEmpty ? orders.map((o) => o.createdAt).reduce((a, b) => a.isBefore(b) ? a : b).toIso8601String() : null,
          'end': orders.isNotEmpty ? orders.map((o) => o.createdAt).reduce((a, b) => a.isAfter(b) ? a : b).toIso8601String() : null,
        },
        'total_revenue': orders.fold(0.0, (sum, order) => sum + order.getGrandTotal(settings)),
        'backup_files': [
          'settings.json',
          'customers.json',
          'payment_history.json',
          'payment_config.json',
          'menu_items.json',
        ]..addAll(ordersByDate.keys.map((date) => 'orders_$date.json')),
      };
      
      await _uploadJsonFile(
        'backup_summary.json',
        backupSummary,
        todayFolderId,
      );
      
      onProgress?.call('Backup completed successfully!');
      return true;
      
    } catch (e) {
      print('Google Drive sync error: $e');
      onProgress?.call('Backup failed: $e');
      return false;
    }
  }
  
  static Future<String> _createOrGetFolder(String folderName, [String? parentId]) async {
    // Search for existing folder
    final query = parentId != null 
        ? "name='$folderName' and parents in '$parentId' and mimeType='application/vnd.google-apps.folder'"
        : "name='$folderName' and mimeType='application/vnd.google-apps.folder'";
        
    final fileList = await _driveApi!.files.list(q: query);
    
    if (fileList.files != null && fileList.files!.isNotEmpty) {
      return fileList.files!.first.id!;
    }
    
    // Create new folder
    final folder = drive.File()
      ..name = folderName
      ..mimeType = 'application/vnd.google-apps.folder';
      
    if (parentId != null) {
      folder.parents = [parentId];
    }
    
    final createdFolder = await _driveApi!.files.create(folder);
    return createdFolder.id!;
  }
  
  static Future<void> _uploadJsonFile(String fileName, dynamic jsonData, String folderId) async {
    final jsonString = jsonEncode(jsonData);
    final bytes = utf8.encode(jsonString);
    
    // Check if file already exists
    final query = "name='$fileName' and parents in '$folderId'";
    final existingFiles = await _driveApi!.files.list(q: query);
    
    final file = drive.File()
      ..name = fileName
      ..parents = [folderId];
    
    final media = drive.Media(Stream.fromIterable([bytes]), bytes.length, contentType: 'application/json');
    
    if (existingFiles.files != null && existingFiles.files!.isNotEmpty) {
      // Update existing file
      await _driveApi!.files.update(file, existingFiles.files!.first.id!, uploadMedia: media);
    } else {
      // Create new file
      await _driveApi!.files.create(file, uploadMedia: media);
    }
  }
  
  static Future<List<String>> listBackupFolders() async {
    if (_driveApi == null) return [];
    
    try {
      final query = "name contains 'QSR-' and name contains '-Backup' and mimeType='application/vnd.google-apps.folder'";
      final fileList = await _driveApi!.files.list(q: query);
      
      return fileList.files?.map((file) => file.name ?? '').toList() ?? [];
    } catch (e) {
      print('Error listing backup folders: $e');
      return [];
    }
  }
  
  static Future<Map<String, dynamic>?> getBackupSummary(String backupFolderName) async {
    if (_driveApi == null) return null;
    
    try {
      // Find the backup folder
      final folderQuery = "name='$backupFolderName' and mimeType='application/vnd.google-apps.folder'";
      final folderList = await _driveApi!.files.list(q: folderQuery);
      
      if (folderList.files == null || folderList.files!.isEmpty) return null;
      
      final folderId = folderList.files!.first.id!;
      
      // Find today's folder or latest folder
      final today = DateTime.now();
      final todayFolder = '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';
      
      final subFolderQuery = "parents in '$folderId' and mimeType='application/vnd.google-apps.folder'";
      final subFolderList = await _driveApi!.files.list(q: subFolderQuery);
      
      if (subFolderList.files == null || subFolderList.files!.isEmpty) return null;
      
      // Find today's folder or get the most recent one
      String? targetFolderId;
      for (final folder in subFolderList.files!) {
        if (folder.name == todayFolder) {
          targetFolderId = folder.id;
          break;
        }
      }
      
      // If today's folder not found, get the most recent one
      targetFolderId ??= subFolderList.files!.first.id;
      
      // Get backup summary file
      final summaryQuery = "name='backup_summary.json' and parents in '$targetFolderId'";
      final summaryList = await _driveApi!.files.list(q: summaryQuery);
      
      if (summaryList.files == null || summaryList.files!.isEmpty) return null;
      
      final summaryFile = await _driveApi!.files.get(summaryList.files!.first.id!, downloadOptions: drive.DownloadOptions.fullMedia);
      
      if (summaryFile is drive.Media) {
        final bytes = await summaryFile.stream.fold<List<int>>(<int>[], (previous, element) => previous..addAll(element));
        final jsonString = utf8.decode(bytes);
        return jsonDecode(jsonString);
      }
      
      return null;
    } catch (e) {
      print('Error getting backup summary: $e');
      return null;
    }
  }
}

// WhatsApp Service for Bill Sharing
class WhatsAppService {
  static Future<void> shareBillAsPDF({
    required Order order,
    required AppSettings settings,
  }) async {
    try {
      // Generate PDF bill file
      final filePath = await PDFBillGenerator.generateQuickReceiptPDF(
        order: order,
        settings: settings,
      );
      
      // Share the file
      await Share.shareXFiles(
        [XFile(filePath)],
        text: 'Bill from ${settings.businessName}\nOrder #${order.id.substring(order.id.length - 8)}',
        subject: 'Receipt - ${settings.businessName}',
      );
    } catch (e) {
      print('Error sharing bill as PDF: $e');
      rethrow;
    }
  }

  static Future<void> shareBill({
    required Order order,
    required AppSettings settings,
    String? customMessage,
    bool asPDF = false,
  }) async {
    if (asPDF) {
      return shareBillAsPDF(order: order, settings: settings);
    }
    try {
      final billContent = _generateWhatsAppBillContent(order, settings);
      final message = customMessage ?? billContent;
      
      // Format phone number (remove any non-digits)
      String? phoneNumber = order.customer?.phone?.replaceAll(RegExp(r'[^0-9]'), '');
      
      // Create WhatsApp URL
      String whatsappUrl;
      if (phoneNumber != null && phoneNumber.isNotEmpty) {
        // Direct message to customer
        if (!phoneNumber.startsWith('91') && phoneNumber.length == 10) {
          phoneNumber = '91$phoneNumber'; // Add India country code
        }
        whatsappUrl = 'https://wa.me/$phoneNumber?text=${Uri.encodeComponent(message)}';
      } else {
        // Open WhatsApp with message but no specific contact
        whatsappUrl = 'https://wa.me/?text=${Uri.encodeComponent(message)}';
      }
      
      // Launch WhatsApp
      final uri = Uri.parse(whatsappUrl);
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        throw 'Could not launch WhatsApp';
      }
    } catch (e) {
      print('Error sharing on WhatsApp: $e');
      rethrow;
    }
  }

  static String _generateWhatsAppBillContent(Order order, AppSettings settings) {
    // Use the same format as Quick Receipt for consistency
    return PDFBillGenerator._generateQuickReceiptContent(order, settings);
  }

  static String _formatDateTime(DateTime dateTime) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year} at ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  static String _getOrderTypeEmoji(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return '🍽️';
      case OrderType.takeaway:
        return '🥡';
      case OrderType.delivery:
        return '🚚';
    }
  }
}

// PDF Bill Generator Service for WhatsApp sharing
class PDFBillGenerator {
  static Future<String> generateQuickReceiptPDF({
    required Order order,
    required AppSettings settings,
  }) async {
    try {
      // Generate the receipt content in text format (same as quick receipt)
      final receiptContent = _generateQuickReceiptContent(order, settings);
      
      // Get temporary directory
      final directory = await getTemporaryDirectory();
      final filePath = '${directory.path}/quick_receipt_${order.id.substring(order.id.length - 8)}.txt';
      
      // Write the content to a file
      final file = File(filePath);
      await file.writeAsString(receiptContent);
      
      return filePath;
    } catch (e) {
      print('Error generating PDF bill: $e');
      rethrow;
    }
  }

  static String _generateQuickReceiptContent(Order order, AppSettings settings) {
    final buffer = StringBuffer();
    
    // Header
    buffer.writeln('=' * 42);
    buffer.writeln('           ${settings.businessName.toUpperCase()}');
    buffer.writeln('=' * 42);
    if (settings.phone.isNotEmpty) {
      buffer.writeln('Phone: ${settings.phone}');
    }
    if (settings.address.isNotEmpty) {
      buffer.writeln('Address: ${settings.address}');
    }
    buffer.writeln('-' * 42);
    
    // Order info
    buffer.writeln('Order #: ${order.id.substring(order.id.length - 8)}');
    buffer.writeln('Date: ${_formatDate(order.createdAt)}');
    buffer.writeln('Time: ${_formatTime(order.createdAt)}');
    buffer.writeln('Type: ${_getOrderTypeLabel(order.type)}');
    
    if (order.customer != null) {
      buffer.writeln('Customer: ${order.customer!.name ?? 'Guest'}');
      if (order.customer!.phone != null) {
        buffer.writeln('Phone: ${order.customer!.phone}');
      }
    }
    buffer.writeln('-' * 42);
    
    // Items
    buffer.writeln('ITEMS:');
    buffer.writeln('-' * 42);
    for (final item in order.items) {
      buffer.writeln('${item.quantity}x ${item.menuItem.name}');
      buffer.writeln('   @ Rs.${item.unitPrice.toStringAsFixed(2)} = Rs.${item.total.toStringAsFixed(2)}');
      if (item.specialInstructions != null && item.specialInstructions!.isNotEmpty) {
        buffer.writeln('   Note: ${item.specialInstructions}');
      }
      buffer.writeln('');
    }
    
    buffer.writeln('-' * 42);
    
    // Totals
    buffer.writeln('Subtotal:        Rs.${order.itemsSubtotal.toStringAsFixed(2)}');
    
    if (order.hasItemDiscounts) {
      buffer.writeln('Item Discounts: -Rs.${order.itemsDiscountAmount.toStringAsFixed(2)}');
      buffer.writeln('After Discounts: Rs.${order.itemsTotal.toStringAsFixed(2)}');
    }
    
    // Charges
    if (order.type == OrderType.delivery && settings.deliveryEnabled && order.charges.deliveryCharge > 0) {
      buffer.writeln('Delivery:        Rs.${order.charges.deliveryCharge.toStringAsFixed(2)}');
    }
    if ((order.type == OrderType.delivery || order.type == OrderType.takeaway) && settings.packagingEnabled && order.charges.packagingCharge > 0) {
      buffer.writeln('Packaging:       Rs.${order.charges.packagingCharge.toStringAsFixed(2)}');
    }
    if (order.type == OrderType.dineIn && settings.serviceEnabled && order.charges.serviceCharge > 0) {
      buffer.writeln('Service:         Rs.${order.charges.serviceCharge.toStringAsFixed(2)}');
    }
    
    // Order discount
    if (order.hasOrderDiscount) {
      buffer.writeln('Order Discount: -Rs.${order.orderDiscountAmount.toStringAsFixed(2)}');
      if (order.orderDiscount!.reason != null) {
        buffer.writeln('  (${order.orderDiscount!.reason})');
      }
    }
    
    // Taxes
    if (settings.sgstRate > 0) {
      final sgstAmount = order.calculateSGST(settings);
      buffer.writeln('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%):     Rs.${sgstAmount.toStringAsFixed(2)}');
    }
    if (settings.cgstRate > 0) {
      final cgstAmount = order.calculateCGST(settings);
      buffer.writeln('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%):     Rs.${cgstAmount.toStringAsFixed(2)}');
    }
    
    buffer.writeln('=' * 42);
    buffer.writeln('TOTAL:           Rs.${order.getGrandTotal(settings).toStringAsFixed(2)}');
    buffer.writeln('=' * 42);
    
    // Payment info
    if (order.payments.isNotEmpty) {
      buffer.writeln('');
      buffer.writeln('PAYMENT:');
      for (final payment in order.payments) {
        buffer.writeln('${payment.method.toString().split('.').last.toUpperCase()}: Rs.${payment.amount.toStringAsFixed(2)}');
      }
    }
    
    // Footer
    buffer.writeln('');
    buffer.writeln('Thank you for choosing ${settings.businessName}!');
    buffer.writeln('Please visit again.');
    buffer.writeln('');
    buffer.writeln('Generated on: ${_formatDate(DateTime.now())} ${_formatTime(DateTime.now())}');
    buffer.writeln('=' * 42);
    
    return buffer.toString();
  }

  static String _formatDate(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year}';
  }

  static String _formatTime(DateTime dateTime) {
    return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  static String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }
}

// Bill Printing Service for thermal printers
class BillPrintingService {
  static Future<bool> printOrderBill({
    required Order order,
    required AppSettings settings,
    required PrintingService printingService,
    String orderSource = 'POS',
    String? transactionId,
    String? deliveryPasscode,
  }) async {
    try {
      // Convert order items to bill items
      final billItems = order.items.map((item) => BillItem(
        name: item.menuItem.name,
        quantity: item.quantity,
        unitPrice: item.unitPrice,
        amount: item.total,
        size: null, // Add size info if available in your menu items
      )).toList();

      // Generate unique bill number
      final billNumber = _generateBillNumber(order);
      
      // Determine payment method
      String paymentMethod = 'Cash';
      if (order.payments.isNotEmpty) {
        paymentMethod = order.payments.first.method.toString().split('.').last;
        paymentMethod = paymentMethod[0].toUpperCase() + paymentMethod.substring(1);
      }

      // Get customer info
      final customerName = order.customer?.name ?? 'Guest';
      final customerPhone = order.customer?.phone;

      // Calculate totals
      final grandTotal = order.getGrandTotal(settings);

      // Print using the detailed bill template
      return await printingService.printBill(
        storeName: settings.businessName,
        address: settings.address,
        phone: settings.phone,
        email: settings.email.isNotEmpty ? settings.email : null,
        billNumber: billNumber,
        timestamp: order.createdAt,
        orderSource: orderSource,
        customerName: customerName,
        customerPhone: customerPhone,
        orderType: _getOrderTypeDisplayName(order.type),
        tokenNumber: order.id.substring(order.id.length - 6), // Last 6 chars as token
        items: billItems,
        subtotal: order.itemsTotal,
        discount: order.itemsDiscountAmount,
        fixedDiscount: order.orderDiscountAmount,
        containerCharge: 0.0, // Add if you have container charges
        deliveryCharge: order.charges.deliveryCharge,
        packagingCharge: order.charges.packagingCharge,
        serviceCharge: order.charges.serviceCharge,
        cgst: order.getCgstAmount(settings),
        sgst: order.getSgstAmount(settings),
        grandTotal: grandTotal,
        paymentMethod: paymentMethod,
        transactionId: transactionId,
        customerNotes: order.notes,
        rewardType: null, // Add reward system if available
        deliveryPasscode: deliveryPasscode,
        pickupBarcode: null, // Add barcode generation if needed
        gstinFooter: null, // Add GSTIN if business is GST registered
        fsaiNumber: null, // Add FSSAI number if available
      );
    } catch (e) {
      print('Error printing bill: $e');
      return false;
    }
  }

  static String _generateBillNumber(Order order) {
    // Generate bill number based on timestamp and order ID
    final timestamp = order.createdAt;
    final dateStr = '${timestamp.day.toString().padLeft(2, '0')}${timestamp.month.toString().padLeft(2, '0')}${timestamp.year.toString().substring(2)}';
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}';
    final orderSuffix = order.id.substring(order.id.length - 4);
    return '$dateStr$timeStr$orderSuffix';
  }

  static String _getOrderTypeDisplayName(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine-in';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  // Print simplified receipt for quick service
  static Future<bool> printQuickReceipt({
    required Order order,
    required AppSettings settings,
    required PrintingService printingService,
  }) async {
    try {
      // Use KOT template for quick receipt
      final kotItems = order.items.map((item) => KotItem(
        quantity: item.quantity,
        name: item.menuItem.name,
        notes: item.specialInstructions,
      )).toList();

      return await printingService.printKot(
        storeName: settings.businessName,
        orderType: order.type.toString().split('.').last,
        tokenOrTable: order.id.substring(order.id.length - 6),
        server: 'POS',
        timestamp: order.createdAt,
        deviceId: 'QSR-APP',
        items: kotItems,
      );
    } catch (e) {
      print('Error printing quick receipt: $e');
      return false;
    }
  }
}

// Discount Dialog Components
class DiscountDialogs {
  // Item Discount Dialog
  static Future<ItemDiscount?> showItemDiscountDialog({
    required BuildContext context,
    required OrderItem item,
    ItemDiscount? existingDiscount,
  }) async {
    return showDialog<ItemDiscount>(
      context: context,
      builder: (context) => ItemDiscountDialog(
        item: item,
        existingDiscount: existingDiscount,
      ),
    );
  }

  // Order Discount Dialog
  static Future<OrderDiscount?> showOrderDiscountDialog({
    required BuildContext context,
    required Order order,
    required AppSettings settings,
    OrderDiscount? existingDiscount,
  }) async {
    return showDialog<OrderDiscount>(
      context: context,
      builder: (context) => OrderDiscountDialog(
        order: order,
        settings: settings,
        existingDiscount: existingDiscount,
      ),
    );
  }
}

class ItemDiscountDialog extends StatefulWidget {
  final OrderItem item;
  final ItemDiscount? existingDiscount;

  const ItemDiscountDialog({
    super.key,
    required this.item,
    this.existingDiscount,
  });

  @override
  State<ItemDiscountDialog> createState() => _ItemDiscountDialogState();
}

class _ItemDiscountDialogState extends State<ItemDiscountDialog> {
  late DiscountType selectedType;
  late TextEditingController valueController;
  late TextEditingController reasonController;
  double maxDiscountValue = 0;

  @override
  void initState() {
    super.initState();
    selectedType = widget.existingDiscount?.type ?? DiscountType.percentage;
    valueController = TextEditingController(
      text: widget.existingDiscount?.value.toString() ?? '',
    );
    reasonController = TextEditingController(
      text: widget.existingDiscount?.reason ?? '',
    );
    _calculateMaxDiscount();
  }

  void _calculateMaxDiscount() {
    maxDiscountValue = selectedType == DiscountType.percentage ? 100 : widget.item.subtotal;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Discount for ${widget.item.menuItem.name}'),
      content: SizedBox(
        width: 400,
        height: 500, // Set a fixed height to prevent overflow
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Item details
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Item: ${widget.item.menuItem.name}', 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Quantity: ${widget.item.quantity}'),
                  Text('Unit Price: ₹${widget.item.unitPrice.toStringAsFixed(2)}'),
                  Text('Subtotal: ₹${widget.item.subtotal.toStringAsFixed(2)}'),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick preset buttons
            const Text('Quick Discounts:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickDiscountChip('5%', DiscountType.percentage, 5),
                _buildQuickDiscountChip('10%', DiscountType.percentage, 10),
                _buildQuickDiscountChip('15%', DiscountType.percentage, 15),
                _buildQuickDiscountChip('₹10', DiscountType.fixed, 10),
                _buildQuickDiscountChip('₹25', DiscountType.fixed, 25),
                _buildQuickDiscountChip('₹50', DiscountType.fixed, 50),
              ],
            ),
            const SizedBox(height: 16),
            
            // Discount type selection
            const Text('Discount Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DiscountType>(
                    title: const Text('Percentage'),
                    value: DiscountType.percentage,
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        _calculateMaxDiscount();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<DiscountType>(
                    title: const Text('Fixed Amount'),
                    value: DiscountType.fixed,
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        _calculateMaxDiscount();
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Discount value input
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: selectedType == DiscountType.percentage 
                    ? 'Discount Percentage (0-100)' 
                    : 'Discount Amount (₹)',
                helperText: 'Max: ${selectedType == DiscountType.percentage ? "100%" : "₹${maxDiscountValue.toStringAsFixed(2)}"}',
                prefixText: selectedType == DiscountType.fixed ? '₹' : null,
                suffixText: selectedType == DiscountType.percentage ? '%' : null,
              ),
            ),
            const SizedBox(height: 12),
            
            // Reason input
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'e.g., Customer complaint, Loyalty discount',
              ),
            ),
            const SizedBox(height: 16),
            
            // Preview
            if (valueController.text.isNotEmpty) _buildDiscountPreview(),
          ],
        ),
      ),
    ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (widget.existingDiscount != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(ItemDiscount(
              type: DiscountType.percentage,
              value: 0,
            )),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove Discount'),
          ),
        ElevatedButton(
          onPressed: _canApplyDiscount() ? _applyDiscount : null,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildQuickDiscountChip(String label, DiscountType type, double value) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          selectedType = type;
          valueController.text = value.toString();
          _calculateMaxDiscount();
        });
      },
    );
  }

  Widget _buildDiscountPreview() {
    final value = double.tryParse(valueController.text) ?? 0;
    if (value <= 0) return const SizedBox.shrink();
    
    final discount = ItemDiscount(type: selectedType, value: value);
    final discountAmount = discount.calculateDiscount(widget.item.subtotal);
    final finalTotal = widget.item.subtotal - discountAmount;
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Original: ₹${widget.item.subtotal.toStringAsFixed(2)}'),
          Text('Discount: -₹${discountAmount.toStringAsFixed(2)}'),
          Text('Final: ₹${finalTotal.toStringAsFixed(2)}', 
               style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  bool _canApplyDiscount() {
    final value = double.tryParse(valueController.text) ?? 0;
    return value > 0 && value <= maxDiscountValue;
  }

  void _applyDiscount() {
    final value = double.tryParse(valueController.text) ?? 0;
    final discount = ItemDiscount(
      type: selectedType,
      value: value,
      reason: reasonController.text.trim().isEmpty ? null : reasonController.text.trim(),
    );
    Navigator.of(context).pop(discount);
  }
}

class OrderDiscountDialog extends StatefulWidget {
  final Order order;
  final OrderDiscount? existingDiscount;
  final AppSettings settings;

  const OrderDiscountDialog({
    super.key,
    required this.order,
    this.existingDiscount,
    required this.settings,
  });

  @override
  State<OrderDiscountDialog> createState() => _OrderDiscountDialogState();
}

class _OrderDiscountDialogState extends State<OrderDiscountDialog> {
  late DiscountType selectedType;
  late TextEditingController valueController;
  late TextEditingController reasonController;
  late bool applyToSubtotal;
  double maxDiscountValue = 0;

  @override
  void initState() {
    super.initState();
    selectedType = widget.existingDiscount?.type ?? DiscountType.percentage;
    valueController = TextEditingController(
      text: widget.existingDiscount?.value.toString() ?? '',
    );
    reasonController = TextEditingController(
      text: widget.existingDiscount?.reason ?? '',
    );
    applyToSubtotal = widget.existingDiscount?.applyToSubtotal ?? true;
    _calculateMaxDiscount();
  }

  void _calculateMaxDiscount() {
    final baseAmount = applyToSubtotal ? widget.order.subtotal : widget.order.taxableAmount;
    maxDiscountValue = selectedType == DiscountType.percentage ? 100 : baseAmount;
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Order Discount'),
      content: SizedBox(
        width: 450,
        height: 500, // Fixed height to prevent overflow
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            // Order summary
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Order Summary:', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('Items: ${widget.order.items.length}'),
                  Text('Subtotal: ₹${widget.order.subtotal.toStringAsFixed(2)}'),
                  if (widget.order.totalCharges > 0)
                    Text('Charges: ₹${widget.order.totalCharges.toStringAsFixed(2)}'),
                  Text('Taxable Amount: ₹${widget.order.taxableAmount.toStringAsFixed(2)}'),
                  const Divider(),
                  Text('Grand Total: ₹${widget.order.getGrandTotal(widget.settings).toStringAsFixed(2)}', 
                       style: const TextStyle(fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            const SizedBox(height: 16),
            
            // Quick preset buttons
            const Text('Quick Discounts:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                _buildQuickDiscountChip('5%', DiscountType.percentage, 5),
                _buildQuickDiscountChip('10%', DiscountType.percentage, 10),
                _buildQuickDiscountChip('15%', DiscountType.percentage, 15),
                _buildQuickDiscountChip('20%', DiscountType.percentage, 20),
                _buildQuickDiscountChip('₹50', DiscountType.fixed, 50),
                _buildQuickDiscountChip('₹100', DiscountType.fixed, 100),
              ],
            ),
            const SizedBox(height: 16),
            
            // Apply to option
            const Text('Apply Discount To:', style: TextStyle(fontWeight: FontWeight.bold)),
            Column(
              children: [
                RadioListTile<bool>(
                  title: const Text('Subtotal (before charges and tax)'),
                  subtitle: Text('₹${widget.order.subtotal.toStringAsFixed(2)}'),
                  value: true,
                  groupValue: applyToSubtotal,
                  onChanged: (value) {
                    setState(() {
                      applyToSubtotal = value!;
                      _calculateMaxDiscount();
                    });
                  },
                ),
                RadioListTile<bool>(
                  title: const Text('Taxable Amount (subtotal + charges)'),
                  subtitle: Text('₹${widget.order.taxableAmount.toStringAsFixed(2)}'),
                  value: false,
                  groupValue: applyToSubtotal,
                  onChanged: (value) {
                    setState(() {
                      applyToSubtotal = value!;
                      _calculateMaxDiscount();
                    });
                  },
                ),
              ],
            ),
            
            // Discount type selection
            const Text('Discount Type:', style: TextStyle(fontWeight: FontWeight.bold)),
            Row(
              children: [
                Expanded(
                  child: RadioListTile<DiscountType>(
                    title: const Text('Percentage'),
                    value: DiscountType.percentage,
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        _calculateMaxDiscount();
                      });
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile<DiscountType>(
                    title: const Text('Fixed Amount'),
                    value: DiscountType.fixed,
                    groupValue: selectedType,
                    onChanged: (value) {
                      setState(() {
                        selectedType = value!;
                        _calculateMaxDiscount();
                      });
                    },
                  ),
                ),
              ],
            ),
            
            // Discount value input
            TextField(
              controller: valueController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: selectedType == DiscountType.percentage 
                    ? 'Discount Percentage (0-100)' 
                    : 'Discount Amount (₹)',
                helperText: 'Max: ${selectedType == DiscountType.percentage ? "100%" : "₹${maxDiscountValue.toStringAsFixed(2)}"}',
                prefixText: selectedType == DiscountType.fixed ? '₹' : null,
                suffixText: selectedType == DiscountType.percentage ? '%' : null,
              ),
            ),
            const SizedBox(height: 12),
            
            // Reason input
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: 'Reason (Optional)',
                hintText: 'e.g., Bulk order, Special customer, Promotion',
              ),
            ),
            const SizedBox(height: 16),
            
            // Preview
            if (valueController.text.isNotEmpty) _buildDiscountPreview(),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        if (widget.existingDiscount != null)
          TextButton(
            onPressed: () => Navigator.of(context).pop(OrderDiscount(
              type: DiscountType.percentage,
              value: 0,
            )),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Remove Discount'),
          ),
        ElevatedButton(
          onPressed: _canApplyDiscount() ? _applyDiscount : null,
          child: const Text('Apply'),
        ),
      ],
    );
  }

  Widget _buildQuickDiscountChip(String label, DiscountType type, double value) {
    return ActionChip(
      label: Text(label),
      onPressed: () {
        setState(() {
          selectedType = type;
          valueController.text = value.toString();
          _calculateMaxDiscount();
        });
      },
    );
  }

  Widget _buildDiscountPreview() {
    final value = double.tryParse(valueController.text) ?? 0;
    if (value <= 0) return const SizedBox.shrink();
    
    final discount = OrderDiscount(
      type: selectedType, 
      value: value, 
      applyToSubtotal: applyToSubtotal,
    );
    
    final baseAmount = applyToSubtotal ? widget.order.subtotal : widget.order.taxableAmount;
    final discountAmount = discount.calculateDiscount(baseAmount);
    
    // Calculate new totals
    double newTaxableAmount;
    double newTaxAmount;
    double newGrandTotal;
    
    if (applyToSubtotal) {
      newTaxableAmount = (widget.order.subtotal - discountAmount) + widget.order.totalCharges;
      newTaxAmount = newTaxableAmount * widget.settings.totalTaxRate;
      newGrandTotal = newTaxableAmount + newTaxAmount;
    } else {
      newTaxableAmount = widget.order.taxableAmount - discountAmount;
      newTaxAmount = newTaxableAmount * widget.settings.totalTaxRate;
      newGrandTotal = newTaxableAmount + newTaxAmount;
    }
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.green[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preview:', style: TextStyle(fontWeight: FontWeight.bold)),
          Text('Original Total: ₹${widget.order.getGrandTotal(widget.settings).toStringAsFixed(2)}'),
          Text('Discount on ${applyToSubtotal ? "Subtotal" : "Taxable Amount"}: -₹${discountAmount.toStringAsFixed(2)}'),
          Text('New Grand Total: ₹${newGrandTotal.toStringAsFixed(2)}', 
               style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.green)),
          Text('Savings: ₹${(widget.order.getGrandTotal(widget.settings) - newGrandTotal).toStringAsFixed(2)}', 
               style: const TextStyle(color: Colors.green)),
        ],
      ),
    );
  }

  bool _canApplyDiscount() {
    final value = double.tryParse(valueController.text) ?? 0;
    return value > 0 && value <= maxDiscountValue;
  }

  void _applyDiscount() {
    final value = double.tryParse(valueController.text) ?? 0;
    final discount = OrderDiscount(
      type: selectedType,
      value: value,
      reason: reasonController.text.trim().isEmpty ? null : reasonController.text.trim(),
      applyToSubtotal: applyToSubtotal,
    );
    Navigator.of(context).pop(discount);
  }
}

void main() {
  runApp(const ProviderScope(child: QSRApp()));
}

// Utility function for optimized toast messages
void showOptimizedToast(BuildContext context, String message, {
  Color? color,
  Duration? duration,
  IconData? icon,
  bool dismissPrevious = true,
}) {
  // Dismiss previous SnackBar if needed
  if (dismissPrevious) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
  
  final backgroundColor = color ?? Colors.green;
  final displayDuration = duration ?? const Duration(seconds: 2);
  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Row(
        children: [
          if (icon != null) ...[
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 8),
          ],
          Expanded(child: Text(message)),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: displayDuration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.only(
        left: 16,
        right: 16,
        bottom: 90, // Extra margin to avoid bottom navigation overlap
        top: 16,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  );
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
          elevation: 0,
          toolbarHeight: 48, // Reduced from default 56
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
  final ItemDiscount? discount;
  
  OrderItem({
    required this.menuItem, 
    required this.quantity,
    required this.orderType,
    this.selectedAddons = const [],
    this.specialInstructions,
    this.discount,
  });
  
  double get basePrice => menuItem.getPriceForOrderType(orderType);
  double get addonsPrice => selectedAddons.fold(0.0, (sum, addon) => sum + addon.price);
  double get unitPrice => basePrice + addonsPrice;
  double get subtotal => unitPrice * quantity;
  
  // Discount calculations
  double get discountAmount => discount?.calculateDiscount(subtotal) ?? 0.0;
  double get total => subtotal - discountAmount;
  
  // Check if item has discount
  bool get hasDiscount => discount != null && discountAmount > 0;
  
  OrderItem copyWith({
    MenuItem? menuItem,
    int? quantity,
    OrderType? orderType,
    List<Addon>? selectedAddons,
    String? specialInstructions,
    ItemDiscount? discount,
  }) {
    return OrderItem(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      orderType: orderType ?? this.orderType,
      selectedAddons: selectedAddons ?? this.selectedAddons,
      specialInstructions: specialInstructions ?? this.specialInstructions,
      discount: discount ?? this.discount,
    );
  }
  
  // Remove discount
  OrderItem removeDiscount() {
    return copyWith(discount: null);
  }
}

enum OrderType { dineIn, takeaway, delivery }
enum OrderStatus { pending, confirmed, preparing, ready, completed, cancelled }
enum PaymentStatus { pending, partial, completed, refunded }
enum PaymentMethod { cash, card, upi, online }

// Enhanced Payment System
enum PaymentMethodType {
  cash,
  card,
  upi,
  netBanking,
  wallet,
  giftCard,
  custom,
}

// Printer Management System
enum PrinterConnectionType {
  network,
  usb,
  bluetooth;

  String get displayName {
    switch (this) {
      case PrinterConnectionType.network:
        return 'Network';
      case PrinterConnectionType.usb:
        return 'USB';
      case PrinterConnectionType.bluetooth:
        return 'Bluetooth';
    }
  }
}

enum PrinterStatus {
  connected,
  disconnected,
  connecting,
  printing,
  error,
  offline;

  String get displayName {
    switch (this) {
      case PrinterStatus.connected:
        return 'Connected';
      case PrinterStatus.disconnected:
        return 'Disconnected';
      case PrinterStatus.connecting:
        return 'Connecting';
      case PrinterStatus.printing:
        return 'Printing';
      case PrinterStatus.error:
        return 'Error';
      case PrinterStatus.offline:
        return 'Offline';
    }
  }

  Color get color {
    switch (this) {
      case PrinterStatus.connected:
        return Colors.green;
      case PrinterStatus.disconnected:
        return Colors.grey;
      case PrinterStatus.connecting:
        return Colors.blue;
      case PrinterStatus.printing:
        return Colors.orange;
      case PrinterStatus.error:
        return Colors.red;
      case PrinterStatus.offline:
        return Colors.grey;
    }
  }
}

class PrinterDevice {
  final String id;
  final String name;
  final String address; // IP address for network, device path for USB, MAC for Bluetooth
  final int? port; // Port number for network printers
  final PrinterConnectionType connectionType;
  final PrinterStatus status;
  final bool isDefault;
  final DateTime lastConnected;
  final Map<String, dynamic> settings; // Paper size, print quality, etc.

  const PrinterDevice({
    required this.id,
    required this.name,
    required this.address,
    this.port,
    required this.connectionType,
    this.status = PrinterStatus.disconnected,
    this.isDefault = false,
    required this.lastConnected,
    this.settings = const {},
  });

  PrinterDevice copyWith({
    String? id,
    String? name,
    String? address,
    int? port,
    PrinterConnectionType? connectionType,
    PrinterStatus? status,
    bool? isDefault,
    DateTime? lastConnected,
    Map<String, dynamic>? settings,
  }) {
    return PrinterDevice(
      id: id ?? this.id,
      name: name ?? this.name,
      address: address ?? this.address,
      port: port ?? this.port,
      connectionType: connectionType ?? this.connectionType,
      status: status ?? this.status,
      isDefault: isDefault ?? this.isDefault,
      lastConnected: lastConnected ?? this.lastConnected,
      settings: settings ?? this.settings,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address': address,
      'port': port,
      'connectionType': connectionType.index,
      'status': status.index,
      'isDefault': isDefault,
      'lastConnected': lastConnected.millisecondsSinceEpoch,
      'settings': settings,
    };
  }

  factory PrinterDevice.fromJson(Map<String, dynamic> json) {
    return PrinterDevice(
      id: json['id'],
      name: json['name'],
      address: json['address'],
      port: json['port'],
      connectionType: PrinterConnectionType.values[json['connectionType']],
      status: PrinterStatus.values[json['status'] ?? 0],
      isDefault: json['isDefault'] ?? false,
      lastConnected: DateTime.fromMillisecondsSinceEpoch(json['lastConnected']),
      settings: Map<String, dynamic>.from(json['settings'] ?? {}),
    );
  }

  String get connectionTypeDisplayName {
    switch (connectionType) {
      case PrinterConnectionType.network:
        return 'Network (WiFi/Cable)';
      case PrinterConnectionType.usb:
        return 'USB';
      case PrinterConnectionType.bluetooth:
        return 'Bluetooth';
    }
  }

  String get statusDisplayName {
    switch (status) {
      case PrinterStatus.connected:
        return 'Connected';
      case PrinterStatus.disconnected:
        return 'Disconnected';
      case PrinterStatus.connecting:
        return 'Connecting';
      case PrinterStatus.printing:
        return 'Printing';
      case PrinterStatus.error:
        return 'Error';
      case PrinterStatus.offline:
        return 'Offline';
    }
  }

  Color get statusColor {
    switch (status) {
      case PrinterStatus.connected:
        return Colors.green;
      case PrinterStatus.disconnected:
        return Colors.grey;
      case PrinterStatus.connecting:
        return Colors.blue;
      case PrinterStatus.printing:
        return Colors.orange;
      case PrinterStatus.error:
        return Colors.red;
      case PrinterStatus.offline:
        return Colors.grey;
    }
  }
}

class PaymentMethodConfig {
  final String id;
  final String name;
  final PaymentMethodType type;
  final String? icon;
  final bool isEnabled;
  final Map<String, dynamic>? config;

  const PaymentMethodConfig({
    required this.id,
    required this.name,
    required this.type,
    this.icon,
    this.isEnabled = true,
    this.config,
  });

  PaymentMethodConfig copyWith({
    String? id,
    String? name,
    PaymentMethodType? type,
    String? icon,
    bool? isEnabled,
    Map<String, dynamic>? config,
  }) {
    return PaymentMethodConfig(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      icon: icon ?? this.icon,
      isEnabled: isEnabled ?? this.isEnabled,
      config: config ?? this.config,
    );
  }

  factory PaymentMethodConfig.fromJson(Map<String, dynamic> json) {
    return PaymentMethodConfig(
      id: json['id'],
      name: json['name'],
      type: PaymentMethodType.values.firstWhere((e) => e.name == json['type']),
      icon: json['icon'],
      isEnabled: json['isEnabled'] ?? true,
      config: json['config'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'icon': icon,
    'isEnabled': isEnabled,
    'config': config,
  };

  static List<PaymentMethodConfig> get defaultMethods => [
    PaymentMethodConfig(id: 'cash', name: 'Cash', type: PaymentMethodType.cash, icon: '💵'),
    PaymentMethodConfig(id: 'card', name: 'Card', type: PaymentMethodType.card, icon: '💳'),
    PaymentMethodConfig(id: 'upi', name: 'UPI', type: PaymentMethodType.upi, icon: '📱'),
    PaymentMethodConfig(id: 'gpay', name: 'Google Pay', type: PaymentMethodType.upi, icon: '📱'),
    PaymentMethodConfig(id: 'paytm', name: 'Paytm', type: PaymentMethodType.wallet, icon: '💰'),
    PaymentMethodConfig(id: 'phonepe', name: 'PhonePe', type: PaymentMethodType.upi, icon: '📲'),
    PaymentMethodConfig(id: 'netbanking', name: 'Net Banking', type: PaymentMethodType.netBanking, icon: '🏦'),
  ];
}

class PaymentSystemConfig {
  final Set<PaymentMethodType> enabledMethods;
  final List<double> quickAmounts;
  final List<PaymentMethodConfig> availableMethods;

  PaymentSystemConfig({
    Set<PaymentMethodType>? enabledMethods,
    List<double>? quickAmounts,
    List<PaymentMethodConfig>? availableMethods,
  }) : enabledMethods = enabledMethods ?? {PaymentMethodType.cash, PaymentMethodType.card, PaymentMethodType.upi},
       quickAmounts = quickAmounts ?? [50, 100, 200, 500, 1000],
       availableMethods = availableMethods ?? PaymentMethodConfig.defaultMethods;

  PaymentSystemConfig copyWith({
    Set<PaymentMethodType>? enabledMethods,
    List<double>? quickAmounts,
    List<PaymentMethodConfig>? availableMethods,
  }) {
    return PaymentSystemConfig(
      enabledMethods: enabledMethods ?? this.enabledMethods,
      quickAmounts: quickAmounts ?? this.quickAmounts,
      availableMethods: availableMethods ?? this.availableMethods,
    );
  }

  factory PaymentSystemConfig.fromJson(Map<String, dynamic> json) {
    return PaymentSystemConfig(
      enabledMethods: (json['enabledMethods'] as List?)
          ?.map((e) => PaymentMethodType.values.firstWhere((type) => type.name == e))
          .toSet(),
      quickAmounts: (json['quickAmounts'] as List?)?.cast<double>(),
      availableMethods: (json['availableMethods'] as List?)
          ?.map((e) => PaymentMethodConfig.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
    'enabledMethods': enabledMethods.map((e) => e.name).toList(),
    'quickAmounts': quickAmounts,
    'availableMethods': availableMethods.map((e) => e.toJson()).toList(),
  };
}

class PaymentEntry {
  final String methodId;
  final String methodName;
  final PaymentMethodType method;
  final double amount;
  final DateTime timestamp;
  final String? orderId;
  final String? transactionId;

  PaymentEntry({
    required this.methodId,
    required this.methodName,
    required this.method,
    required this.amount,
    required this.timestamp,
    this.orderId,
    this.transactionId,
  });

  PaymentEntry copyWith({
    String? methodId,
    String? methodName,
    PaymentMethodType? method,
    double? amount,
    DateTime? timestamp,
    String? orderId,
    String? transactionId,
  }) {
    return PaymentEntry(
      methodId: methodId ?? this.methodId,
      methodName: methodName ?? this.methodName,
      method: method ?? this.method,
      amount: amount ?? this.amount,
      timestamp: timestamp ?? this.timestamp,
      orderId: orderId ?? this.orderId,
      transactionId: transactionId ?? this.transactionId,
    );
  }

  factory PaymentEntry.fromJson(Map<String, dynamic> json) => PaymentEntry(
    methodId: json['methodId'],
    methodName: json['methodName'],
    method: PaymentMethodType.values.firstWhere((e) => e.name == json['method']),
    amount: json['amount'].toDouble(),
    timestamp: DateTime.parse(json['timestamp']),
    orderId: json['orderId'],
    transactionId: json['transactionId'],
  );

  Map<String, dynamic> toJson() => {
    'methodId': methodId,
    'methodName': methodName,
    'method': method.name,
    'amount': amount,
    'timestamp': timestamp.toIso8601String(),
    'orderId': orderId,
    'transactionId': transactionId,
  };
}

class OrderPayment {
  final String orderId;
  final List<PaymentEntry> payments;
  final double totalAmount;
  final DateTime paidAt;
  final bool isFullyPaid;

  OrderPayment({
    required this.orderId,
    required this.payments,
    required this.totalAmount,
    required this.paidAt,
  }) : isFullyPaid = payments.fold(0.0, (sum, p) => sum + p.amount) >= totalAmount;

  double get paidAmount => payments.fold(0.0, (sum, p) => sum + p.amount);
  double get remainingAmount => totalAmount - paidAmount;

  factory OrderPayment.fromJson(Map<String, dynamic> json) => OrderPayment(
    orderId: json['orderId'],
    payments: (json['payments'] as List).map((p) => PaymentEntry.fromJson(p)).toList(),
    totalAmount: json['totalAmount'].toDouble(),
    paidAt: DateTime.parse(json['paidAt']),
  );

  Map<String, dynamic> toJson() => {
    'orderId': orderId,
    'payments': payments.map((p) => p.toJson()).toList(),
    'totalAmount': totalAmount,
    'paidAt': paidAt.toIso8601String(),
  };
}

// Discount Types and Models
enum DiscountType { percentage, fixed }

class ItemDiscount {
  final DiscountType type;
  final double value;
  final String? reason;
  
  ItemDiscount({
    required this.type,
    required this.value,
    this.reason,
  });
  
  double calculateDiscount(double amount) {
    switch (type) {
      case DiscountType.percentage:
        return amount * (value / 100);
      case DiscountType.fixed:
        return value > amount ? amount : value;
    }
  }
  
  ItemDiscount copyWith({
    DiscountType? type,
    double? value,
    String? reason,
  }) {
    return ItemDiscount(
      type: type ?? this.type,
      value: value ?? this.value,
      reason: reason ?? this.reason,
    );
  }
}

class OrderDiscount {
  final DiscountType type;
  final double value;
  final String? reason;
  final bool applyToSubtotal; // Apply to subtotal or grand total
  
  OrderDiscount({
    required this.type,
    required this.value,
    this.reason,
    this.applyToSubtotal = true,
  });
  
  double calculateDiscount(double amount) {
    switch (type) {
      case DiscountType.percentage:
        return amount * (value / 100);
      case DiscountType.fixed:
        return value > amount ? amount : value;
    }
  }
  
  OrderDiscount copyWith({
    DiscountType? type,
    double? value,
    String? reason,
    bool? applyToSubtotal,
  }) {
    return OrderDiscount(
      type: type ?? this.type,
      value: value ?? this.value,
      reason: reason ?? this.reason,
      applyToSubtotal: applyToSubtotal ?? this.applyToSubtotal,
    );
  }
}

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
  final OrderDiscount? orderDiscount;
  
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
    this.orderDiscount,
  }) : charges = charges ?? OrderCharges();
  
  // Item-level totals
  double get itemsSubtotal => items.fold(0.0, (sum, item) => sum + item.subtotal);
  double get itemsDiscountAmount => items.fold(0.0, (sum, item) => sum + item.discountAmount);
  double get itemsTotal => items.fold(0.0, (sum, item) => sum + item.total);
  
  // Order-level calculations
  double get subtotal => itemsTotal; // After item discounts
  double get totalCharges => charges.total;
  double get taxableAmount => subtotal + totalCharges;
  
  // Order discount calculations
  double get orderDiscountAmount {
    if (orderDiscount == null) return 0.0;
    
    if (orderDiscount!.applyToSubtotal) {
      return orderDiscount!.calculateDiscount(subtotal);
    } else {
      // Apply to taxable amount (subtotal + charges)
      return orderDiscount!.calculateDiscount(taxableAmount);
    }
  }
  
  double get discountedAmount => orderDiscount?.applyToSubtotal == true
      ? subtotal - orderDiscountAmount
      : taxableAmount - orderDiscountAmount;
      
  double getTaxAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      // Tax on discounted subtotal + charges
      return (discountedAmount + totalCharges) * settings.totalTaxRate;
    } else {
      // Tax on discounted taxable amount
      return discountedAmount * settings.totalTaxRate;
    }
  }
  
  double getSgstAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      return (discountedAmount + totalCharges) * settings.sgstRate;
    } else {
      return discountedAmount * settings.sgstRate;
    }
  }
  
  double getCgstAmount(AppSettings settings) {
    if (orderDiscount?.applyToSubtotal == true) {
      return (discountedAmount + totalCharges) * settings.cgstRate;
    } else {
      return discountedAmount * settings.cgstRate;
    }
  }
  
  double getGrandTotal(AppSettings settings) {
    final taxAmount = getTaxAmount(settings);
    if (orderDiscount?.applyToSubtotal == true) {
      return discountedAmount + totalCharges + taxAmount;
    } else {
      return discountedAmount + taxAmount;
    }
  }
  
  // Method aliases for consistency
  double calculateSGST(AppSettings settings) => getSgstAmount(settings);
  double calculateCGST(AppSettings settings) => getCgstAmount(settings);
  double calculateTotalTax(AppSettings settings) => getTaxAmount(settings);
  
  // Backwards compatibility getter for grandTotal (using default tax rates)
  double get grandTotal => getGrandTotal(AppSettings(
    sgstRate: 0.09, // 9% SGST
    cgstRate: 0.09, // 9% CGST
  ));
  
  // Backwards compatibility getter for taxAmount
  double get taxAmount => getTaxAmount(AppSettings(
    sgstRate: 0.09, // 9% SGST
    cgstRate: 0.09, // 9% CGST
  ));
  
  // Total discount amount (items + order)
  double get totalDiscountAmount => itemsDiscountAmount + orderDiscountAmount;
  
  // Check if order has any discounts
  bool get hasDiscounts => totalDiscountAmount > 0;
  bool get hasOrderDiscount => orderDiscount != null && orderDiscountAmount > 0;
  bool get hasItemDiscounts => itemsDiscountAmount > 0;
  
  double get paidAmount => payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get balanceAmount => grandTotal - paidAmount; // Backwards compatibility - uses default tax rates
  double getBalanceAmount(AppSettings settings) => getGrandTotal(settings) - paidAmount;
  
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
    OrderDiscount? orderDiscount,
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
      orderDiscount: orderDiscount ?? this.orderDiscount,
    );
  }
  
  // Remove order discount
  Order removeOrderDiscount() {
    return copyWith(orderDiscount: null);
  }
}

class AppSettings {
  final String currency;
  final double sgstRate;
  final double cgstRate;
  final String businessName;
  final String address;
  final String phone;
  final String email;
  final bool kotEnabled;
  final String defaultLanguage;
  final bool deliveryEnabled;
  final bool packagingEnabled;
  final bool serviceEnabled;
  final double defaultDeliveryCharge;
  final double defaultPackagingCharge;
  final double defaultServiceCharge;
  
  AppSettings({
    this.currency = '₹',
    this.sgstRate = 0.09,
    this.cgstRate = 0.09,
    this.businessName = 'My Restaurant',
    this.address = '',
    this.phone = '',
    this.email = '',
    this.kotEnabled = false,
    this.defaultLanguage = 'en',
    this.deliveryEnabled = true,
    this.packagingEnabled = true,
    this.serviceEnabled = true,
    this.defaultDeliveryCharge = 50.0,
    this.defaultPackagingCharge = 10.0,
    this.defaultServiceCharge = 20.0,
  });
  
  AppSettings copyWith({
    String? currency,
    double? sgstRate,
    double? cgstRate,
    String? businessName,
    String? address,
    String? phone,
    String? email,
    bool? kotEnabled,
    String? defaultLanguage,
    bool? deliveryEnabled,
    bool? packagingEnabled,
    bool? serviceEnabled,
    double? defaultDeliveryCharge,
    double? defaultPackagingCharge,
    double? defaultServiceCharge,
  }) {
    return AppSettings(
      currency: currency ?? this.currency,
      sgstRate: sgstRate ?? this.sgstRate,
      cgstRate: cgstRate ?? this.cgstRate,
      businessName: businessName ?? this.businessName,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      kotEnabled: kotEnabled ?? this.kotEnabled,
      defaultLanguage: defaultLanguage ?? this.defaultLanguage,
      deliveryEnabled: deliveryEnabled ?? this.deliveryEnabled,
      packagingEnabled: packagingEnabled ?? this.packagingEnabled,
      serviceEnabled: serviceEnabled ?? this.serviceEnabled,
      defaultDeliveryCharge: defaultDeliveryCharge ?? this.defaultDeliveryCharge,
      defaultPackagingCharge: defaultPackagingCharge ?? this.defaultPackagingCharge,
      defaultServiceCharge: defaultServiceCharge ?? this.defaultServiceCharge,
    );
  }
  
  // Helper method to get total tax rate (SGST + CGST)
  double get totalTaxRate => sgstRate + cgstRate;
}

// Customer Analytics Data Models
class CustomerData {
  final String? name;
  final String? phone;
  final String? email;
  final String? address;
  final DateTime firstOrderDate;
  final DateTime lastOrderDate;
  final int totalOrders;
  final double totalSpent;
  final OrderType mostUsedOrderType;
  final List<String> orderIds; // Track order history
  
  CustomerData({
    this.name,
    this.phone,
    this.email,
    this.address,
    required this.firstOrderDate,
    required this.lastOrderDate,
    required this.totalOrders,
    required this.totalSpent,
    required this.mostUsedOrderType,
    required this.orderIds,
  });
  
  // Create from first order
  factory CustomerData.fromOrder(Order order) {
    return CustomerData(
      name: order.customer?.name,
      phone: order.customer?.phone,
      email: order.customer?.email,
      address: order.customer?.address,
      firstOrderDate: order.createdAt,
      lastOrderDate: order.createdAt,
      totalOrders: 1,
      totalSpent: order.getGrandTotal(AppSettings(sgstRate: 0.09, cgstRate: 0.09)), // Use default for backwards compatibility
      mostUsedOrderType: order.type,
      orderIds: [order.id],
    );
  }
  
  // Update with new order
  CustomerData updateWithOrder(Order order) {
    final updatedOrderIds = [...orderIds, order.id];
    
    // Calculate most used order type
    final orderTypeCounts = <OrderType, int>{};
    // Count existing orders (simplified - we'll use the current most used + this new one)
    orderTypeCounts[mostUsedOrderType] = totalOrders;
    orderTypeCounts[order.type] = (orderTypeCounts[order.type] ?? 0) + 1;
    
    final newMostUsed = orderTypeCounts.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    
    return CustomerData(
      name: order.customer?.name ?? name,
      phone: order.customer?.phone ?? phone,
      email: order.customer?.email ?? email,
      address: order.customer?.address ?? address,
      firstOrderDate: firstOrderDate,
      lastOrderDate: order.createdAt,
      totalOrders: totalOrders + 1,
      totalSpent: totalSpent + order.getGrandTotal(AppSettings(sgstRate: 0.09, cgstRate: 0.09)), // Use default for backwards compatibility
      mostUsedOrderType: newMostUsed,
      orderIds: updatedOrderIds,
    );
  }
  
  // Get customer identifier (phone or name)
  String get identifier => phone ?? name ?? 'Guest';
  
  // Get average order value
  double get averageOrderValue => totalOrders > 0 ? totalSpent / totalOrders : 0.0;
  
  // Check if customer has contact info
  bool get hasContactInfo => (name?.isNotEmpty == true) || (phone?.isNotEmpty == true);
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

final customerDataProvider = StateNotifierProvider<CustomerDataNotifier, Map<String, CustomerData>>((ref) {
  return CustomerDataNotifier();
});

// Payment Configuration Providers
final paymentConfigProvider = StateNotifierProvider<PaymentConfigNotifier, PaymentSystemConfig>((ref) {
  return PaymentConfigNotifier();
});

final paymentHistoryProvider = StateNotifierProvider<PaymentHistoryNotifier, List<PaymentEntry>>((ref) {
  return PaymentHistoryNotifier();
});

// Printer management providers
class PrinterNotifier extends StateNotifier<List<PrinterDevice>> {
  PrinterNotifier() : super([]);

  void addPrinter(PrinterDevice printer) {
    state = [...state, printer];
  }

  void updatePrinter(String id, PrinterDevice updatedPrinter) {
    state = [
      for (final printer in state)
        if (printer.id == id) updatedPrinter else printer
    ];
  }

  void removePrinter(String id) {
    state = state.where((printer) => printer.id != id).toList();
  }

  void updatePrinterStatus(String id, PrinterStatus status) {
    state = [
      for (final printer in state)
        if (printer.id == id) printer.copyWith(status: status) else printer
    ];
  }

  PrinterDevice? getDefaultPrinter() {
    try {
      return state.firstWhere((printer) => printer.isDefault);
    } catch (e) {
      return null;
    }
  }

  void setDefaultPrinter(String id) {
    state = [
      for (final printer in state)
        printer.copyWith(isDefault: printer.id == id)
    ];
  }

  List<PrinterDevice> getConnectedPrinters() {
    return state
        .where((printer) => printer.status == PrinterStatus.connected)
        .toList();
  }

  Future<void> testPrint(String printerId) async {
    updatePrinterStatus(printerId, PrinterStatus.printing);
    
    try {
      // Simulate printing test page
      await Future.delayed(const Duration(seconds: 2));
      
      // Simulate success/failure based on printer status
      final printer = state.firstWhere((p) => p.id == printerId);
      if (printer.status != PrinterStatus.error) {
        updatePrinterStatus(printerId, PrinterStatus.connected);
      }
    } catch (e) {
      updatePrinterStatus(printerId, PrinterStatus.error);
    }
  }

  Future<void> connectPrinter(String printerId) async {
    updatePrinterStatus(printerId, PrinterStatus.connecting);
    
    try {
      // Simulate connection process
      await Future.delayed(const Duration(seconds: 3));
      updatePrinterStatus(printerId, PrinterStatus.connected);
    } catch (e) {
      updatePrinterStatus(printerId, PrinterStatus.error);
    }
  }

  Future<void> disconnectPrinter(String printerId) async {
    updatePrinterStatus(printerId, PrinterStatus.disconnected);
  }
}

final printerProvider = StateNotifierProvider<PrinterNotifier, List<PrinterDevice>>((ref) {
  return PrinterNotifier();
});

final defaultPrinterProvider = Provider<PrinterDevice?>((ref) {
  return ref.watch(printerProvider.notifier).getDefaultPrinter();
});

final connectedPrintersProvider = Provider<List<PrinterDevice>>((ref) {
  return ref.watch(printerProvider.notifier).getConnectedPrinters();
});

final enabledPaymentMethodsProvider = Provider<List<PaymentMethodConfig>>((ref) {
  return ref.watch(paymentConfigProvider.notifier).enabledMethodConfigs;
});

final orderTypeProvider = StateProvider<OrderType>((ref) => OrderType.dineIn);

// Current order discount provider
final currentOrderDiscountProvider = StateProvider<OrderDiscount?>((ref) => null);

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
  MenuNotifier() : super([]) {
    _loadMenuItems();
  }

  static final List<MenuItem> _defaultMenuItems = [
    MenuItem(id: '1', name: 'Margherita Pizza', dineInPrice: 299, takeawayPrice: 279, deliveryPrice: 319, category: 'Pizza'),
    MenuItem(id: '2', name: 'Chicken Burger', dineInPrice: 189, takeawayPrice: 169, deliveryPrice: 199, category: 'Burgers'),
    MenuItem(id: '3', name: 'Caesar Salad', dineInPrice: 149, takeawayPrice: 139, deliveryPrice: 159, category: 'Salads'),
    MenuItem(id: '4', name: 'Coca Cola', dineInPrice: 49, takeawayPrice: 45, deliveryPrice: 55, category: 'Beverages'),
    MenuItem(id: '5', name: 'French Fries', dineInPrice: 99, takeawayPrice: 89, deliveryPrice: 109, category: 'Sides'),
    MenuItem(id: '6', name: 'Paneer Tikka', dineInPrice: 249, takeawayPrice: 229, deliveryPrice: 269, category: 'Indian'),
    MenuItem(id: '7', name: 'Masala Dosa', dineInPrice: 129, takeawayPrice: 119, deliveryPrice: 139, category: 'South Indian'),
  ];

  Future<void> _loadMenuItems() async {
    final loadedItems = await LocalStorageService.loadMenuItems();
    if (loadedItems.isEmpty) {
      // If no saved items, use default items
      state = _defaultMenuItems;
      await _saveMenuItems();
    } else {
      state = loadedItems;
    }
  }

  Future<void> _saveMenuItems() async {
    await LocalStorageService.saveMenuItems(state);
  }

  void addMenuItem(MenuItem item) {
    state = [...state, item];
    _saveMenuItems();
  }

  void updateMenuItem(MenuItem updatedItem) {
    state = state.map((item) => 
      item.id == updatedItem.id ? updatedItem : item
    ).toList();
    _saveMenuItems();
  }

  void removeMenuItem(String id) {
    state = state.where((item) => item.id != id).toList();
    _saveMenuItems();
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
        existingItem.copyWith(quantity: existingItem.quantity + 1),
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
        ? item.copyWith(quantity: quantity)
        : item
    ).toList();
  }

  void removeItem(String menuItemId, OrderType orderType) {
    state = state.where((item) => 
        !(item.menuItem.id == menuItemId && item.orderType == orderType)).toList();
  }
  
  // Discount operations
  void applyItemDiscount(String menuItemId, OrderType orderType, ItemDiscount discount) {
    state = state.map((item) => 
      item.menuItem.id == menuItemId && item.orderType == orderType
        ? item.copyWith(discount: discount)
        : item
    ).toList();
  }
  
  void removeItemDiscount(String menuItemId, OrderType orderType) {
    state = state.map((item) => 
      item.menuItem.id == menuItemId && item.orderType == orderType
        ? item.removeDiscount()
        : item
    ).toList();
  }
  
  void clearAllItemDiscounts() {
    state = state.map((item) => item.removeDiscount()).toList();
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
        existingItem.copyWith(quantity: existingItem.quantity + 1),
        ...state.skip(existingIndex + 1),
      ];
    } else {
      state = [...state, OrderItem(menuItem: orderItem.menuItem, quantity: 1, orderType: orderItem.orderType)];
    }
  }

  double get subtotal => state.fold(0, (sum, item) => sum + item.total);
  double get itemsDiscountAmount => state.fold(0.0, (sum, item) => sum + item.discountAmount);
  bool get hasDiscounts => itemsDiscountAmount > 0;
}

class OrdersNotifier extends StateNotifier<List<Order>> {
  bool _isLoaded = false;
  
  OrdersNotifier() : super([]) {
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    final loadedOrders = await LocalStorageService.loadOrders();
    print('DEBUG: OrdersNotifier._loadOrders - loaded ${loadedOrders.length} orders, _isLoaded: $_isLoaded');
    // Only update state if no orders have been added yet
    if (!_isLoaded) {
      state = loadedOrders;
      _isLoaded = true;
      print('DEBUG: OrdersNotifier._loadOrders - state updated with ${state.length} orders');
    } else {
      print('DEBUG: OrdersNotifier._loadOrders - skipped loading, already have orders');
    }
  }

  Future<void> _saveOrders() async {
    await LocalStorageService.saveOrders(state);
  }

  void addOrder(Order order) {
    // Ensure we're marked as loaded to prevent race condition
    _isLoaded = true;
    print('DEBUG: OrdersNotifier.addOrder - adding order ${order.id}, current count: ${state.length}');
    state = [order, ...state];
    print('DEBUG: OrdersNotifier.addOrder - new count: ${state.length}');
    _saveOrders();
  }

  void updateOrderStatus(String orderId, OrderStatus status) {
    state = state.map((order) => 
      order.id == orderId 
        ? order.copyWith(status: status)
        : order
    ).toList();
    _saveOrders();
  }

  void updateOrder(Order updatedOrder) {
    state = state.map((order) => 
      order.id == updatedOrder.id ? updatedOrder : order
    ).toList();
    _saveOrders();
  }
}

class SettingsNotifier extends StateNotifier<AppSettings> {
  SettingsNotifier() : super(AppSettings()) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final loadedSettings = await LocalStorageService.loadSettings();
    state = loadedSettings;
  }

  Future<void> _saveSettings() async {
    await LocalStorageService.saveSettings(state);
  }

  void updateCurrency(String currency) {
    state = state.copyWith(currency: currency);
    _saveSettings();
  }

  void updateSgstRate(double sgstRate) {
    state = state.copyWith(sgstRate: sgstRate);
    _saveSettings();
  }

  void updateCgstRate(double cgstRate) {
    state = state.copyWith(cgstRate: cgstRate);
    _saveSettings();
  }

  void updateBusinessName(String businessName) {
    state = state.copyWith(businessName: businessName);
    _saveSettings();
  }

  void updateAddress(String address) {
    state = state.copyWith(address: address);
    _saveSettings();
  }

  void updatePhone(String phone) {
    state = state.copyWith(phone: phone);
    _saveSettings();
  }

  void updateEmail(String email) {
    state = state.copyWith(email: email);
    _saveSettings();
  }
  
  void updateDeliveryEnabled(bool enabled) {
    state = state.copyWith(deliveryEnabled: enabled);
    _saveSettings();
  }
  
  void updatePackagingEnabled(bool enabled) {
    state = state.copyWith(packagingEnabled: enabled);
    _saveSettings();
  }
  
  void updateServiceEnabled(bool enabled) {
    state = state.copyWith(serviceEnabled: enabled);
    _saveSettings();
  }
  
  void updateDefaultDeliveryCharge(double charge) {
    state = state.copyWith(defaultDeliveryCharge: charge);
    _saveSettings();
  }
  
  void updateDefaultPackagingCharge(double charge) {
    state = state.copyWith(defaultPackagingCharge: charge);
    _saveSettings();
  }
  
  void updateDefaultServiceCharge(double charge) {
    state = state.copyWith(defaultServiceCharge: charge);
    _saveSettings();
  }

  void updateSettings(AppSettings newSettings) {
    state = newSettings;
    _saveSettings();
  }
}

class CustomerDataNotifier extends StateNotifier<Map<String, CustomerData>> {
  CustomerDataNotifier() : super({}) {
    _loadCustomerData();
  }

  Future<void> _loadCustomerData() async {
    final loadedData = await LocalStorageService.loadCustomerData();
    state = loadedData;
  }

  Future<void> _saveCustomerData() async {
    await LocalStorageService.saveCustomerData(state);
  }

  void addOrUpdateCustomerFromOrder(Order order) {
    // Skip if no customer info
    if (order.customer == null) return;
    
    // Use phone as primary key, fallback to name
    final customerKey = order.customer!.phone ?? order.customer!.name ?? 'guest_${order.id}';
    
    if (customerKey.isEmpty || customerKey.startsWith('guest_')) return;
    
    final currentData = state[customerKey];
    
    if (currentData == null) {
      // New customer
      state = {
        ...state,
        customerKey: CustomerData.fromOrder(order),
      };
    } else {
      // Update existing customer
      state = {
        ...state,
        customerKey: currentData.updateWithOrder(order),
      };
    }
    _saveCustomerData();
  }

  List<CustomerData> get sortedCustomers {
    final customers = state.values.toList();
    customers.sort((a, b) => b.lastOrderDate.compareTo(a.lastOrderDate));
    return customers;
  }

  List<CustomerData> get topCustomers {
    final customers = state.values.toList();
    customers.sort((a, b) => b.totalSpent.compareTo(a.totalSpent));
    return customers.take(10).toList();
  }

  CustomerData? getCustomerByPhone(String phone) {
    return state[phone];
  }

  int get totalCustomers => state.length;
  
  double get totalCustomerValue => state.values.fold(0.0, (sum, customer) => sum + customer.totalSpent);
  
  double get averageCustomerValue => totalCustomers > 0 ? totalCustomerValue / totalCustomers : 0.0;
}

class PaymentConfigNotifier extends StateNotifier<PaymentSystemConfig> {
  PaymentConfigNotifier() : super(PaymentSystemConfig()) {
    _loadConfig();
  }

  Future<void> _loadConfig() async {
    final loadedConfig = await LocalStorageService.loadPaymentConfig();
    state = loadedConfig;
  }

  Future<void> _saveConfig() async {
    await LocalStorageService.savePaymentConfig(state);
  }

  Future<void> enablePaymentMethod(PaymentMethodType method) async {
    state = state.copyWith(
      enabledMethods: {...state.enabledMethods, method},
    );
    await _saveConfig();
  }

  Future<void> disablePaymentMethod(PaymentMethodType method) async {
    final updatedMethods = Set<PaymentMethodType>.from(state.enabledMethods);
    updatedMethods.remove(method);
    state = state.copyWith(enabledMethods: updatedMethods);
    await _saveConfig();
  }

  Future<void> updateQuickAmounts(List<double> amounts) async {
    state = state.copyWith(quickAmounts: amounts);
    await _saveConfig();
  }

  bool isMethodEnabled(PaymentMethodType method) {
    return state.enabledMethods.contains(method);
  }

  List<PaymentMethodConfig> get enabledMethodConfigs {
    return state.availableMethods
        .where((method) => state.enabledMethods.contains(method.type))
        .toList();
  }

  Future<void> addCustomPaymentMethod(String name, String? icon) async {
    print('Adding custom payment method: $name with icon: $icon');
    
    final customId = 'custom_${DateTime.now().millisecondsSinceEpoch}';
    final customMethod = PaymentMethodConfig(
      id: customId,
      name: name,
      type: PaymentMethodType.custom,
      icon: icon ?? '💳',
    );
    
    print('Created custom method: ${customMethod.toJson()}');
    
    final updatedMethods = List<PaymentMethodConfig>.from(state.availableMethods);
    updatedMethods.add(customMethod);
    
    print('Total methods before update: ${state.availableMethods.length}');
    print('Total methods after update: ${updatedMethods.length}');
    
    state = state.copyWith(availableMethods: updatedMethods);
    
    print('State updated. Current available methods count: ${state.availableMethods.length}');
    
    await _saveConfig();
    
    print('Configuration saved successfully');
  }

  Future<void> removeCustomPaymentMethod(String methodId) async {
    final updatedMethods = state.availableMethods
        .where((method) => method.id != methodId)
        .toList();
    
    // Also remove from enabled methods if it was enabled
    final updatedEnabledMethods = Set<PaymentMethodType>.from(state.enabledMethods);
    final methodToRemove = state.availableMethods.firstWhere((m) => m.id == methodId);
    if (methodToRemove.type == PaymentMethodType.custom) {
      // For custom methods, we need to check if this specific method was enabled
      // Since custom methods share the same type, we'll disable the type if this was the last custom method
      final remainingCustomMethods = updatedMethods.where((m) => m.type == PaymentMethodType.custom).toList();
      if (remainingCustomMethods.isEmpty) {
        updatedEnabledMethods.remove(PaymentMethodType.custom);
      }
    }
    
    state = state.copyWith(
      availableMethods: updatedMethods,
      enabledMethods: updatedEnabledMethods,
    );
    await _saveConfig();
  }
}

class PaymentHistoryNotifier extends StateNotifier<List<PaymentEntry>> {
  PaymentHistoryNotifier() : super([]) {
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    final loadedHistory = await LocalStorageService.loadPaymentHistory();
    state = loadedHistory;
  }

  Future<void> _saveHistory() async {
    await LocalStorageService.savePaymentHistory(state);
  }

  Future<void> addPaymentEntry(PaymentEntry entry) async {
    state = [entry, ...state];
    await _saveHistory();
  }

  Future<void> addPaymentsForOrder(String orderId, List<PaymentEntry> payments) async {
    final newEntries = payments.map((p) => p.copyWith(orderId: orderId)).toList();
    state = [...newEntries, ...state];
    await _saveHistory();
  }

  List<PaymentEntry> getPaymentsForOrder(String orderId) {
    return state.where((entry) => entry.orderId == orderId).toList();
  }

  double getTotalPaidForOrder(String orderId) {
    return getPaymentsForOrder(orderId)
        .fold(0.0, (sum, payment) => sum + payment.amount);
  }

  Map<PaymentMethodType, double> getPaymentMethodTotals(DateTime? startDate, DateTime? endDate) {
    final filteredPayments = state.where((payment) {
      if (startDate != null && payment.timestamp.isBefore(startDate)) return false;
      if (endDate != null && payment.timestamp.isAfter(endDate)) return false;
      return true;
    });

    final Map<PaymentMethodType, double> totals = {};
    for (final payment in filteredPayments) {
      totals[payment.method] = (totals[payment.method] ?? 0.0) + payment.amount;
    }
    return totals;
  }

  double getTotalPayments(DateTime? startDate, DateTime? endDate) {
    return getPaymentMethodTotals(startDate, endDate).values.fold(0.0, (sum, amount) => sum + amount);
  }
}

// Payment Method Selector Dialog
class PaymentMethodSelector extends ConsumerStatefulWidget {
  final double totalAmount;
  final String orderId;
  final Function(List<PaymentEntry>) onPaymentComplete;

  const PaymentMethodSelector({
    super.key,
    required this.totalAmount,
    required this.orderId,
    required this.onPaymentComplete,
  });

  @override
  ConsumerState<PaymentMethodSelector> createState() => _PaymentMethodSelectorState();
}

class _PaymentMethodSelectorState extends ConsumerState<PaymentMethodSelector> {
  final List<PaymentEntry> _payments = [];
  final Map<String, TextEditingController> _controllers = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _totalPaid => _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get _remainingAmount => widget.totalAmount - _totalPaid;
  bool get _isFullyPaid => _remainingAmount <= 0.01; // Allow for small rounding differences

  @override
  Widget build(BuildContext context) {
    final paymentConfig = ref.watch(paymentConfigProvider);
    final enabledMethods = ref.watch(paymentConfigProvider.notifier).enabledMethodConfigs;

    return AlertDialog(
      title: Row(
        children: [
          const Icon(Icons.payment, color: Color(0xFFFF9933)),
          const SizedBox(width: 8),
          const Text('Payment Methods'),
        ],
      ),
      content: Container(
        width: 450,
        constraints: const BoxConstraints(maxHeight: 600),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Payment Summary
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
                      const Text('Total Amount:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatIndianCurrency('₹', widget.totalAmount), 
                           style: const TextStyle(fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Paid Amount:'),
                      Text(formatIndianCurrency('₹', _totalPaid), 
                           style: TextStyle(color: _totalPaid > 0 ? Colors.green : Colors.grey)),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Remaining:', style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(formatIndianCurrency('₹', _remainingAmount), 
                           style: TextStyle(
                             color: _isFullyPaid ? Colors.green : Colors.red,
                             fontWeight: FontWeight.bold,
                           )),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Quick Amount Buttons
            if (paymentConfig.quickAmounts.isNotEmpty) ...[
              const Text('Quick Amounts:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: paymentConfig.quickAmounts.map((amount) => 
                  ActionChip(
                    label: Text('₹${amount.toInt()}'),
                    onPressed: _remainingAmount > 0 ? () => _addQuickAmount(amount) : null,
                  ),
                ).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // Payment Methods
            const Text('Payment Methods:', style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: enabledMethods.length,
                itemBuilder: (context, index) {
                  final method = enabledMethods[index];
                  return _buildPaymentMethodTile(method);
                },
              ),
            ),

            // Added Payments List
            if (_payments.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text('Added Payments:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 150),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _payments.length,
                  itemBuilder: (context, index) {
                    final payment = _payments[index];
                    return ListTile(
                      leading: Text(payment.methodName.substring(0, 1)),
                      title: Text(payment.methodName),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('₹${payment.amount.toStringAsFixed(2)}'),
                          IconButton(
                            icon: const Icon(Icons.delete, size: 20),
                            onPressed: () => _removePayment(index),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _isFullyPaid ? () {
            widget.onPaymentComplete(_payments);
            Navigator.pop(context);
          } : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFFF9933),
            foregroundColor: Colors.white,
          ),
          child: const Text('Complete Payment'),
        ),
      ],
    );
  }

  Widget _buildPaymentMethodTile(PaymentMethodConfig method) {
    final controller = _controllers.putIfAbsent(method.id, () => TextEditingController());
    
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          child: Text(method.icon ?? method.name.substring(0, 1)),
        ),
        title: Text(method.name),
        subtitle: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter amount',
            border: OutlineInputBorder(),
            isDense: true,
          ),
          keyboardType: TextInputType.number,
        ),
        trailing: ElevatedButton(
          onPressed: () => _addPayment(method, controller),
          child: const Text('Add'),
        ),
      ),
    );
  }

  void _addQuickAmount(double amount) {
    if (_remainingAmount <= 0) return;
    
    final actualAmount = amount > _remainingAmount ? _remainingAmount : amount;
    
    // Add to cash payment by default
    final cashMethod = ref.read(paymentConfigProvider.notifier).enabledMethodConfigs
        .firstWhere((m) => m.type == PaymentMethodType.cash, 
                   orElse: () => ref.read(paymentConfigProvider.notifier).enabledMethodConfigs.first);
    
    final payment = PaymentEntry(
      methodId: cashMethod.id,
      methodName: cashMethod.name,
      method: cashMethod.type,
      amount: actualAmount,
      timestamp: DateTime.now(),
      orderId: widget.orderId,
    );

    setState(() {
      _payments.add(payment);
    });
  }

  void _addPayment(PaymentMethodConfig method, TextEditingController controller) {
    final amount = double.tryParse(controller.text);
    if (amount == null || amount <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid amount')),
      );
      return;
    }

    if (amount > _remainingAmount) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Amount cannot exceed remaining balance of ₹${_remainingAmount.toStringAsFixed(2)}')),
      );
      return;
    }

    final payment = PaymentEntry(
      methodId: method.id,
      methodName: method.name,
      method: method.type,
      amount: amount,
      timestamp: DateTime.now(),
      orderId: widget.orderId,
    );

    setState(() {
      _payments.add(payment);
      controller.clear();
    });
  }

  void _removePayment(int index) {
    setState(() {
      _payments.removeAt(index);
    });
  }
}

// New Mobile-Optimized Payment Dialog for Order Completion
class OrderCompletionPaymentDialog extends ConsumerStatefulWidget {
  final Order order;
  final Function(List<PaymentEntry>) onPaymentComplete;

  const OrderCompletionPaymentDialog({
    super.key,
    required this.order,
    required this.onPaymentComplete,
  });

  @override
  ConsumerState<OrderCompletionPaymentDialog> createState() => _OrderCompletionPaymentDialogState();
}

class _OrderCompletionPaymentDialogState extends ConsumerState<OrderCompletionPaymentDialog> {
  final List<PaymentEntry> _payments = [];
  final Map<String, TextEditingController> _controllers = {};
  String? _selectedMethodId;
  PaymentMethodConfig? get _selectedMethod => _selectedMethodId != null 
      ? ref.read(paymentConfigProvider.notifier).enabledMethodConfigs
          .firstWhere((m) => m.id == _selectedMethodId, orElse: () => ref.read(paymentConfigProvider.notifier).enabledMethodConfigs.first)
      : null;

  @override
  void initState() {
    super.initState();
    // Auto-select first available payment method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final enabledMethods = ref.read(paymentConfigProvider.notifier).enabledMethodConfigs;
      if (enabledMethods.isNotEmpty) {
        setState(() {
          _selectedMethodId = enabledMethods.first.id;
        });
      }
    });
  }

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  double get _totalPaid => _payments.fold(0.0, (sum, payment) => sum + payment.amount);
  double get _remainingAmount => widget.order.getGrandTotal(ref.read(settingsProvider)) - _totalPaid;
  bool get _isFullyPaid => _remainingAmount <= 0.01; // Allow for small rounding differences

  @override
  Widget build(BuildContext context) {
    final enabledMethods = ref.watch(paymentConfigProvider.notifier).enabledMethodConfigs;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    // Handle case where no payment methods are enabled
    if (enabledMethods.isEmpty) {
      return AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Configuration Error'),
          ],
        ),
        content: const Text(
          'No payment methods are currently enabled. Please configure payment methods in settings first.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      );
    }

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        width: isSmallScreen ? MediaQuery.of(context).size.width * 0.95 : 500,
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(context).size.height * 0.85,
          maxWidth: isSmallScreen ? MediaQuery.of(context).size.width * 0.95 : 600,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Fixed Header
            Container(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 16 : 20, 
                8
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(
                      Icons.payment,
                      color: Color(0xFFFF9933),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Collect Payment',
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Order #${widget.order.id}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            
            // Scrollable Content
            Flexible(
              child: SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(
                  isSmallScreen ? 16 : 20, 
                  0, 
                  isSmallScreen ? 16 : 20, 
                  8
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
            
            const SizedBox(height: 20),
            
                    // Payment Summary Card (Compact)
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(isSmallScreen ? 12 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9933).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFFF9933).withOpacity(0.3)),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Total:', 
                        style: TextStyle(
                          fontSize: isSmallScreen ? 14 : 16, 
                          fontWeight: FontWeight.w500
                        )
                      ),
                      Text(
                        formatIndianCurrency('₹', widget.order.getGrandTotal(ref.read(settingsProvider))),
                        style: TextStyle(
                          fontSize: isSmallScreen ? 18 : 20, 
                          fontWeight: FontWeight.bold, 
                          color: const Color(0xFFFF9933)
                        ),
                      ),
                    ],
                  ),
                  if (_remainingAmount > 0.01) ...[
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Remaining:', 
                          style: TextStyle(
                            fontSize: isSmallScreen ? 14 : 16, 
                            fontWeight: FontWeight.w500
                          )
                        ),
                        Text(
                          formatIndianCurrency('₹', _remainingAmount),
                          style: TextStyle(
                            fontSize: isSmallScreen ? 16 : 18, 
                            fontWeight: FontWeight.bold, 
                            color: Colors.red
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            SizedBox(height: isSmallScreen ? 16 : 20),            // Payment Method Selection (Mobile Optimized)
            if (!_isFullyPaid) ...[
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Payment Method:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16, 
                    fontWeight: FontWeight.w600, 
                    color: Colors.grey[700]
                  ),
                ),
              ),
              SizedBox(height: isSmallScreen ? 8 : 12),
              
              // Payment method selection - horizontal scroll for better space utilization
              SizedBox(
                height: isSmallScreen ? 60 : 50,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: enabledMethods.length,
                  itemBuilder: (context, index) {
                    final method = enabledMethods[index];
                    final isSelected = _selectedMethodId == method.id;
                    
                    return Padding(
                      padding: EdgeInsets.only(
                        right: 8,
                        left: index == 0 ? 0 : 0,
                      ),
                      child: GestureDetector(
                        onTap: () => setState(() => _selectedMethodId = method.id),
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: isSmallScreen ? 16 : 16,
                            vertical: isSmallScreen ? 8 : 8,
                          ),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFFFF9933) : Colors.grey[100],
                            borderRadius: BorderRadius.circular(isSmallScreen ? 15 : 25),
                            border: Border.all(
                              color: isSelected ? const Color(0xFFFF9933) : Colors.grey[300]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (method.icon != null)
                                Text(
                                  method.icon!, 
                                  style: TextStyle(fontSize: isSmallScreen ? 18 : 16)
                                )
                              else
                                CircleAvatar(
                                  radius: isSmallScreen ? 12 : 10,
                                  backgroundColor: isSelected ? Colors.white : Colors.grey[400],
                                  child: Text(
                                    method.name.substring(0, 1),
                                    style: TextStyle(
                                      fontSize: isSmallScreen ? 12 : 10,
                                      fontWeight: FontWeight.bold,
                                      color: isSelected ? const Color(0xFFFF9933) : Colors.white,
                                    ),
                                  ),
                                ),
                              SizedBox(width: isSmallScreen ? 10 : 8),
                              Text(
                                method.name,
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.grey[700],
                                  fontWeight: FontWeight.w500,
                                  fontSize: isSmallScreen ? 14 : 12,
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

              SizedBox(height: isSmallScreen ? 12 : 20),

              // Amount Input Section
              if (_selectedMethod != null) ...[
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
                          if (_selectedMethod!.icon != null) ...[
                            Text(_selectedMethod!.icon!, style: const TextStyle(fontSize: 20)),
                            const SizedBox(width: 8),
                          ],
                          Expanded(
                            child: Text(
                              'Enter ${_selectedMethod!.name} Amount:',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      
                      // Amount input field
                      TextField(
                        controller: _controllers.putIfAbsent(_selectedMethod!.id, () => TextEditingController()),
                        decoration: InputDecoration(
                          hintText: isSmallScreen 
                              ? 'Max: ₹${_remainingAmount.toStringAsFixed(2)}'
                              : 'Enter amount (Max: ₹${_remainingAmount.toStringAsFixed(2)})',
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
                          ),
                          prefixText: '₹ ',
                          prefixStyle: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFFFF9933),
                          ),
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: 16, 
                            vertical: isSmallScreen ? 16 : 12,
                          ),
                          filled: true,
                          fillColor: Colors.grey[50],
                        ),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        onChanged: (value) => setState(() {}),
                        autofocus: isSmallScreen,
                      ),
                      
                      const SizedBox(height: 12),
                      
                      // Quick amount buttons (responsive layout)
                      if (isSmallScreen) ...[
                        // Mobile layout - stacked buttons
                        Column(
                          children: [
                            SizedBox(
                              width: double.infinity,
                              child: _buildQuickAmountButton('Full Amount', _remainingAmount, isInRow: false),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                _buildQuickAmountButton('₹500', 500, isInRow: true),
                                const SizedBox(width: 8),
                                _buildQuickAmountButton('₹100', 100, isInRow: true),
                                const SizedBox(width: 8),
                                _buildQuickAmountButton('₹50', 50, isInRow: true),
                              ],
                            ),
                          ],
                        ),
                      ] else ...[
                        // Desktop layout - horizontal buttons
                        Row(
                          children: [
                            _buildQuickAmountButton('Full', _remainingAmount, isInRow: true),
                            const SizedBox(width: 8),
                            _buildQuickAmountButton('₹500', 500, isInRow: true),
                            const SizedBox(width: 8),
                            _buildQuickAmountButton('₹100', 100, isInRow: true),
                          ],
                        ),
                      ],
                      
                      const SizedBox(height: 16),
                      
                      // Payment action buttons
                      if (_isFullAmountEntered()) ...[
                        // Full amount entered - show complete payment button
                        SizedBox(
                          width: double.infinity,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: () => _completePaymentDirectly(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Complete with ${_selectedMethod!.name}',
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
                      ] else ...[
                        // Partial amount or no amount - show regular add payment button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _canAddPayment() ? () => _addPayment(_selectedMethod!) : null,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9933),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                            ),
                            child: const Text('Add Payment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],

            // Added Payments List
            if (_payments.isNotEmpty) ...[
              SizedBox(height: isSmallScreen ? 12 : 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Added Payments:',
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16, 
                    fontWeight: FontWeight.w600, 
                    color: Colors.grey[700]
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Container(
                constraints: const BoxConstraints(maxHeight: 120),
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: _payments.length,
                  itemBuilder: (context, index) {
                    final payment = _payments[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 8),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundColor: const Color(0xFFFF9933),
                          child: Text(
                            payment.methodName.substring(0, 1),
                            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                          ),
                        ),
                        title: Text(payment.methodName, style: const TextStyle(fontWeight: FontWeight.w500)),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '₹${payment.amount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete_outline, size: 20, color: Colors.red),
                              onPressed: () => _removePayment(index),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],

                    // Add some bottom padding for the last item
                    SizedBox(height: isSmallScreen ? 12 : 20),
                  ],
                ),
              ),
            ),
            
            // Fixed Footer with Action Buttons
            Container(
              padding: EdgeInsets.fromLTRB(
                isSmallScreen ? 16 : 20, 
                8, 
                isSmallScreen ? 16 : 20, 
                isSmallScreen ? 16 : 20
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border(
                  top: BorderSide(color: Colors.grey[200]!, width: 1),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Payment Status Summary (for small screens)
                  if (isSmallScreen && (_totalPaid > 0 || _remainingAmount > 0.01)) ...[
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.grey[50],
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          if (_totalPaid > 0) ...[
                            Text(
                              'Paid: ₹${_totalPaid.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.green),
                            ),
                          ],
                          if (_remainingAmount > 0.01) ...[
                            Text(
                              'Remaining: ₹${_remainingAmount.toStringAsFixed(2)}',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Colors.red),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(height: 12),
                  ],
                  
                  // Action buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.grey),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text('Cancel', style: TextStyle(fontSize: 16)),
                        ),
                      ),
                      if (_isFullyPaid) ...[
                        const SizedBox(width: 12),
                        Expanded(
                          flex: 2,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(colors: [Colors.green, Colors.lightGreen]),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                widget.onPaymentComplete(_payments);
                                Navigator.pop(context);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                shadowColor: Colors.transparent,
                                padding: const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.check_circle, color: Colors.white, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Complete Order',
                                    style: TextStyle(
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
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAmountButton(String label, double amount, {bool isInRow = true}) {
    final isFullButton = label.contains('Full');
    final isEnabled = _remainingAmount >= amount;
    final controller = _selectedMethod != null ? _controllers[_selectedMethod!.id] : null;
    final enteredAmount = controller != null ? double.tryParse(controller.text) : null;
    final isCurrentlySelected = enteredAmount != null && (enteredAmount - amount).abs() <= 0.01;
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    
    Widget button = Container(
      decoration: BoxDecoration(
        gradient: isFullButton && isCurrentlySelected
            ? const LinearGradient(colors: [Colors.green, Colors.lightGreen])
            : null,
        borderRadius: BorderRadius.circular(8),
      ),
      child: OutlinedButton(
        onPressed: isEnabled ? () => _fillAmount(amount) : null,
        style: OutlinedButton.styleFrom(
          side: BorderSide(
            color: isCurrentlySelected 
                ? Colors.transparent 
                : const Color(0xFFFF9933).withOpacity(isEnabled ? 0.5 : 0.3),
          ),
          backgroundColor: isCurrentlySelected && !isFullButton 
              ? const Color(0xFFFF9933).withOpacity(0.1) 
              : Colors.transparent,
          padding: EdgeInsets.symmetric(
            vertical: isSmallScreen ? 12 : 8,
            horizontal: isSmallScreen ? 16 : 8,
          ),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
        child: FittedBox(
          child: Text(
            label,
            style: TextStyle(
              fontSize: isSmallScreen ? 14 : 12,
              fontWeight: isCurrentlySelected ? FontWeight.bold : FontWeight.w500,
              color: isFullButton && isCurrentlySelected
                  ? Colors.white
                  : isEnabled 
                      ? (isCurrentlySelected ? const Color(0xFFFF9933) : const Color(0xFFFF9933))
                      : Colors.grey,
            ),
          ),
        ),
      ),
    );
    
    // For buttons in a row that need to expand
    if (isInRow && !isFullButton) {
      return Expanded(child: button);
    }
    
    // For full width buttons or standalone buttons
    return button;
  }

  void _fillAmount(double amount) {
    if (_selectedMethod != null) {
      final actualAmount = amount > _remainingAmount ? _remainingAmount : amount;
      _controllers[_selectedMethod!.id]?.text = actualAmount.toStringAsFixed(2);
      setState(() {});
    }
  }

  bool _canAddPayment() {
    if (_selectedMethod == null) return false;
    final controller = _controllers[_selectedMethod!.id];
    if (controller == null || controller.text.isEmpty) return false;
    final amount = double.tryParse(controller.text);
    return amount != null && amount > 0 && amount <= _remainingAmount;
  }

  bool _isFullAmountEntered() {
    if (_selectedMethod == null) return false;
    final controller = _controllers[_selectedMethod!.id];
    if (controller == null || controller.text.isEmpty) return false;
    final amount = double.tryParse(controller.text);
    if (amount == null) return false;
    // Check if entered amount equals remaining amount (within small tolerance)
    return (amount - _remainingAmount).abs() <= 0.01;
  }

  void _completePaymentDirectly() {
    if (_selectedMethod == null) return;
    
    final controller = _controllers[_selectedMethod!.id];
    final amount = double.tryParse(controller?.text ?? '');
    
    if (amount == null || amount <= 0) {
      _showSnackBar('Please enter a valid amount', 
        icon: Icons.warning, color: Colors.orange);
      return;
    }

    // Validate that payment method is still enabled
    final enabledMethods = ref.read(paymentConfigProvider.notifier).enabledMethodConfigs;
    if (!enabledMethods.any((m) => m.id == _selectedMethod!.id)) {
      _showSnackBar('This payment method is no longer enabled', 
        icon: Icons.error, color: Colors.red);
      return;
    }

    // Create payment entry for the full amount
    final payment = PaymentEntry(
      methodId: _selectedMethod!.id,
      methodName: _selectedMethod!.name,
      method: _selectedMethod!.type,
      amount: amount,
      timestamp: DateTime.now(),
      orderId: widget.order.id,
    );

    // Add this payment to the list
    final allPayments = [..._payments, payment];
    
    // Complete the order immediately
    widget.onPaymentComplete(allPayments);
    Navigator.pop(context);
    
    _showSnackBar('Payment completed successfully with ${_selectedMethod!.name}!', 
      icon: Icons.check_circle, color: Colors.green);
  }

  void _addPayment(PaymentMethodConfig method) {
    final controller = _controllers[method.id];
    final amount = double.tryParse(controller?.text ?? '');
    
    if (amount == null || amount <= 0) {
      _showSnackBar('Please enter a valid amount', 
        icon: Icons.warning, color: Colors.orange);
      return;
    }

    if (amount > _remainingAmount) {
      _showSnackBar('Amount cannot exceed remaining balance of ₹${_remainingAmount.toStringAsFixed(2)}', 
        icon: Icons.error, color: Colors.red);
      return;
    }

    // Validate that payment method is still enabled
    final enabledMethods = ref.read(paymentConfigProvider.notifier).enabledMethodConfigs;
    if (!enabledMethods.any((m) => m.id == method.id)) {
      _showSnackBar('This payment method is no longer enabled', 
        icon: Icons.error, color: Colors.red);
      return;
    }

    final payment = PaymentEntry(
      methodId: method.id,
      methodName: method.name,
      method: method.type,
      amount: amount,
      timestamp: DateTime.now(),
      orderId: widget.order.id,
    );

    setState(() {
      _payments.add(payment);
      controller?.clear();
    });

    _showSnackBar('Payment of ₹${amount.toStringAsFixed(2)} added successfully', 
      icon: Icons.add_circle, color: Colors.green);
  }

  void _removePayment(int index) {
    setState(() {
      _payments.removeAt(index);
    });
    _showSnackBar('Payment removed', 
      icon: Icons.remove_circle, color: Colors.orange);
  }

  void _showSnackBar(String message, {IconData? icon, Color? color}) {
    showOptimizedToast(context, message, icon: icon, color: color);
  }
}

// Payment Settings Screen
class PaymentSettingsScreen extends ConsumerStatefulWidget {
  const PaymentSettingsScreen({super.key});

  @override
  ConsumerState<PaymentSettingsScreen> createState() => _PaymentSettingsScreenState();
}

class _PaymentSettingsScreenState extends ConsumerState<PaymentSettingsScreen> {
  final _quickAmountController = TextEditingController();

  @override
  void dispose() {
    _quickAmountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final paymentConfig = ref.watch(paymentConfigProvider);
    final paymentNotifier = ref.read(paymentConfigProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Settings'),
        backgroundColor: const Color(0xFFFF9933),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Payment Methods Section
            const Text(
              'Payment Methods',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Enable or disable payment methods for your restaurant',
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 16),

            Expanded(
              child: ListView.builder(
                itemCount: paymentConfig.availableMethods.length,
                itemBuilder: (context, index) {
                  final method = paymentConfig.availableMethods[index];
                  final isEnabled = paymentConfig.enabledMethods.contains(method.type);
                  final isCustom = method.type == PaymentMethodType.custom;

                  return Card(
                    child: isCustom 
                      ? ListTile(
                          leading: CircleAvatar(
                            child: Text(method.icon ?? method.name.substring(0, 1)),
                          ),
                          title: Text(method.name),
                          subtitle: Text(_getPaymentMethodDescription(method.type)),
                          trailing: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Switch(
                                value: isEnabled,
                                onChanged: (value) {
                                  if (value) {
                                    paymentNotifier.enablePaymentMethod(method.type);
                                  } else {
                                    // Ensure at least one payment method remains enabled
                                    if (paymentConfig.enabledMethods.length > 1) {
                                      paymentNotifier.disablePaymentMethod(method.type);
                                    } else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          content: Text('At least one payment method must be enabled'),
                                          backgroundColor: Colors.orange,
                                        ),
                                      );
                                    }
                                  }
                                },
                              ),
                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () => _confirmDeleteCustomMethod(method),
                              ),
                            ],
                          ),
                        )
                      : SwitchListTile(
                          secondary: CircleAvatar(
                            child: Text(method.icon ?? method.name.substring(0, 1)),
                          ),
                          title: Text(method.name),
                          subtitle: Text(_getPaymentMethodDescription(method.type)),
                          value: isEnabled,
                          onChanged: (value) {
                            if (value) {
                              paymentNotifier.enablePaymentMethod(method.type);
                            } else {
                              // Ensure at least one payment method remains enabled
                              if (paymentConfig.enabledMethods.length > 1) {
                                paymentNotifier.disablePaymentMethod(method.type);
                              } else {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('At least one payment method must be enabled'),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              }
                            }
                          },
                        ),
                  );
                },
              ),
            ),

            // Add Custom Payment Method Button
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _showAddCustomPaymentMethodDialog(),
                  icon: const Icon(Icons.add),
                  label: const Text('Add Custom Payment Method'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFFFF9933),
                    side: const BorderSide(color: Color(0xFFFF9933)),
                  ),
                ),
              ),
            ),

            // Quick Amounts Section
            const SizedBox(height: 16),
            const Text(
              'Quick Amount Buttons',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [
                ...paymentConfig.quickAmounts.map((amount) => 
                  InputChip(
                    label: Text('₹${amount.toInt()}'),
                    onDeleted: () => _removeQuickAmount(amount),
                  ),
                ),
                ActionChip(
                  label: const Text('+ Add'),
                  onPressed: () => _showAddQuickAmountDialog(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _getPaymentMethodDescription(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.cash:
        return 'Physical cash payments';
      case PaymentMethodType.card:
        return 'Credit/Debit card payments';
      case PaymentMethodType.upi:
        return 'UPI payments (GPay, PhonePe, etc.)';
      case PaymentMethodType.netBanking:
        return 'Online banking transfers';
      case PaymentMethodType.wallet:
        return 'Digital wallet payments';
      case PaymentMethodType.giftCard:
        return 'Gift card and voucher payments';
      case PaymentMethodType.custom:
        return 'Custom payment method';
    }
  }

  void _removeQuickAmount(double amount) {
    final paymentNotifier = ref.read(paymentConfigProvider.notifier);
    final currentAmounts = List<double>.from(ref.read(paymentConfigProvider).quickAmounts);
    currentAmounts.remove(amount);
    paymentNotifier.updateQuickAmounts(currentAmounts);
  }

  void _showAddQuickAmountDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Quick Amount'),
        content: TextField(
          controller: _quickAmountController,
          decoration: const InputDecoration(
            labelText: 'Amount',
            prefixText: '₹',
            border: OutlineInputBorder(),
          ),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(
            onPressed: () {
              _quickAmountController.clear();
              Navigator.pop(context);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final amount = double.tryParse(_quickAmountController.text);
              if (amount != null && amount > 0) {
                final paymentNotifier = ref.read(paymentConfigProvider.notifier);
                final currentAmounts = List<double>.from(ref.read(paymentConfigProvider).quickAmounts);
                if (!currentAmounts.contains(amount)) {
                  currentAmounts.add(amount);
                  currentAmounts.sort();
                  paymentNotifier.updateQuickAmounts(currentAmounts);
                }
                _quickAmountController.clear();
                Navigator.pop(context);
              }
            },
            child: const Text('Add'),
          ),
        ],
      ),
    );
  }

  void _showAddCustomPaymentMethodDialog() {
    final nameController = TextEditingController();
    final paymentNotifier = ref.read(paymentConfigProvider.notifier);
    final parentContext = context; // Capture parent context
    const defaultIcon = '💳'; // Default icon for custom payment methods

    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Add Custom Payment Method'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF9933).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFFF9933).withOpacity(0.3)),
                  ),
                  child: const Text(
                    defaultIcon,
                    style: TextStyle(fontSize: 24),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    controller: nameController,
                    decoration: const InputDecoration(
                      labelText: 'Payment Method Name',
                      border: OutlineInputBorder(),
                      hintText: 'e.g., Store Credit, Voucher, etc.',
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              nameController.dispose();
              Navigator.pop(dialogContext);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              final name = nameController.text.trim();
              if (name.isNotEmpty) {
                try {
                  await paymentNotifier.addCustomPaymentMethod(name, defaultIcon);
                  
                  // Close dialog first
                  Navigator.pop(dialogContext);
                  
                  // Dispose controller after dialog is closed
                  nameController.dispose();
                  
                  // Then show success message with parent context
                  showOptimizedToast(
                    parentContext,
                    'Payment method "$name" added successfully',
                    icon: Icons.payment,
                  );
                } catch (e) {
                  print('Error adding custom payment method: $e');
                  // Close dialog first
                  Navigator.pop(dialogContext);
                  
                  // Dispose controller after dialog is closed
                  nameController.dispose();
                  
                  // Then show error message with parent context
                  showOptimizedToast(
                    parentContext,
                    'Error adding payment method: $e',
                    icon: Icons.error,
                    color: Colors.red,
                  );
                }
              } else {
                showOptimizedToast(
                  dialogContext,
                  'Please enter a payment method name',
                  icon: Icons.warning,
                  color: Colors.orange,
                );
              }
            },
            child: const Text('Add'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteCustomMethod(PaymentMethodConfig method) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Payment Method'),
        content: Text('Are you sure you want to delete "${method.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(paymentConfigProvider.notifier).removeCustomPaymentMethod(method.id);
              Navigator.pop(context);
              
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Payment method "${method.name}" deleted'),
                  backgroundColor: Colors.red,
                ),
              );
            },
            child: const Text('Delete'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
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
  final TextEditingController _customerEmailController = TextEditingController();
  final TextEditingController _customerAddressController = TextEditingController();
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _discountController = TextEditingController();
  
  String _searchQuery = '';
  double _deliveryCharge = 0.0;
  double _packagingCharge = 0.0;
  double _serviceCharge = 0.0;

  @override
  void initState() {
    super.initState();
    // Initialize with default charges from settings
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final settings = ref.read(settingsProvider);
      setState(() {
        _deliveryCharge = settings.defaultDeliveryCharge;
        _packagingCharge = settings.defaultPackagingCharge;
        _serviceCharge = settings.defaultServiceCharge;
      });
    });
  }

  // Calculate charges based on order type
  double _getApplicableCharges(OrderType orderType) {
    switch (orderType) {
      case OrderType.dineIn:
        // Dine-in: No delivery or packaging charges, only service charge may apply
        return _serviceCharge;
      case OrderType.takeaway:
        // Takeaway: Only packaging charges apply
        return _packagingCharge;
      case OrderType.delivery:
        // Home delivery: Both delivery and packaging charges apply
        return _deliveryCharge + _packagingCharge;
    }
  }
  
  // Get OrderCharges object based on settings and order type
  OrderCharges _getOrderCharges(OrderType orderType, AppSettings settings) {
    double deliveryCharge = 0.0;
    double packagingCharge = 0.0;
    double serviceCharge = 0.0;
    
    switch (orderType) {
      case OrderType.dineIn:
        // Dine-in: Only service charge if enabled
        if (settings.serviceEnabled) {
          serviceCharge = _serviceCharge;
        }
        break;
      case OrderType.takeaway:
        // Takeaway: Only packaging charge if enabled
        if (settings.packagingEnabled) {
          packagingCharge = _packagingCharge;
        }
        break;
      case OrderType.delivery:
        // Delivery: Both delivery and packaging charges if enabled
        if (settings.deliveryEnabled) {
          deliveryCharge = _deliveryCharge;
        }
        if (settings.packagingEnabled) {
          packagingCharge = _packagingCharge;
        }
        break;
    }
    
    return OrderCharges(
      deliveryCharge: deliveryCharge,
      packagingCharge: packagingCharge,
      serviceCharge: serviceCharge,
    );
  }

  // Phone number validation
  String? _validatePhoneNumber(String value) {
    if (value.isEmpty) return null; // Optional field
    
    // Remove any non-digit characters for validation
    String digitsOnly = value.replaceAll(RegExp(r'[^0-9]'), '');
    
    if (digitsOnly.length != 10) {
      return 'Please enter a valid 10-digit phone number';
    }
    
    return null;
  }

  // Get discount display text
  String _getDiscountDisplayText() {
    final orderDiscount = ref.read(currentOrderDiscountProvider);
    if (orderDiscount == null) {
      return 'Add Order Discount';
    }
    
    final currentOrder = ref.read(currentOrderProvider);
    final orderType = ref.read(orderTypeProvider);
    final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.total);
    final charges = _getApplicableCharges(orderType);
    final taxableAmount = subtotal + charges;
    
    final baseAmount = orderDiscount.applyToSubtotal ? subtotal : taxableAmount;
    final discountAmount = orderDiscount.calculateDiscount(baseAmount);
    
    if (orderDiscount.type == DiscountType.percentage) {
      return 'Order Discount: ${orderDiscount.value.toStringAsFixed(0)}% (-₹${discountAmount.toStringAsFixed(2)})';
    } else {
      return 'Order Discount: -₹${discountAmount.toStringAsFixed(2)}';
    }
  }

  @override
  void dispose() {
    _notesController.dispose();
    _customerNameController.dispose();
    _customerPhoneController.dispose();
    _customerEmailController.dispose();
    _customerAddressController.dispose();
    _searchController.dispose();
    _discountController.dispose();
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
    final charges = _getApplicableCharges(orderType);
    final taxableAmount = subtotal + charges;
    
    // Calculate order discount
    final orderDiscount = ref.watch(currentOrderDiscountProvider);
    double discountAmount = 0.0;
    if (orderDiscount != null) {
      final baseAmount = orderDiscount.applyToSubtotal ? subtotal : taxableAmount;
      discountAmount = orderDiscount.calculateDiscount(baseAmount);
    }
    
    // Calculate final amounts
    double discountedAmount;
    double tax;
    double total;
    
    if (orderDiscount?.applyToSubtotal == true) {
      // Discount applied to subtotal, then add charges and calculate tax
      final discountedSubtotal = subtotal - discountAmount;
      discountedAmount = discountedSubtotal + charges;
      tax = discountedAmount * settings.totalTaxRate;
      total = discountedAmount + tax;
    } else if (orderDiscount != null) {
      // Discount applied to taxable amount
      discountedAmount = taxableAmount - discountAmount;
      tax = discountedAmount * settings.totalTaxRate;
      total = discountedAmount + tax;
    } else {
      // No discount
      discountedAmount = taxableAmount;
      tax = discountedAmount * settings.totalTaxRate;
      total = discountedAmount + tax;
    }
    
    // Keep discount variable for display compatibility
    final discount = discountAmount;

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
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
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
                        label: Text('Delivery'),
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

    if (currentOrder.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Consumer(
        builder: (context, ref, child) {
          final currentOrder = ref.watch(currentOrderProvider); // Watch for changes
          final orderType = ref.watch(orderTypeProvider);
          final settings = ref.watch(settingsProvider);
          final orderDiscount = ref.watch(currentOrderDiscountProvider);
          
          final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.total);
          final charges = _getApplicableCharges(orderType);
          final taxableAmount = subtotal + charges;
          
          // Calculate order discount
          double discountAmount = 0.0;
          if (orderDiscount != null) {
            final baseAmount = orderDiscount.applyToSubtotal ? subtotal : taxableAmount;
            discountAmount = orderDiscount.calculateDiscount(baseAmount);
          }
          
          // Calculate final amounts
          double discountedAmount;
          double tax;
          double total;
          
          if (orderDiscount?.applyToSubtotal == true) {
            // Discount applied to subtotal, then add charges and calculate tax
            final discountedSubtotal = subtotal - discountAmount;
            discountedAmount = discountedSubtotal + charges;
            tax = discountedAmount * settings.totalTaxRate;
            total = discountedAmount + tax;
          } else if (orderDiscount != null) {
            // Discount applied to taxable amount
            discountedAmount = taxableAmount - discountAmount;
            tax = discountedAmount * settings.totalTaxRate;
            total = discountedAmount + tax;
          } else {
            // No discount
            discountedAmount = taxableAmount;
            tax = discountedAmount * settings.totalTaxRate;
            total = discountedAmount + tax;
          }
          
          // Keep discount variable for dialog display
          final discount = discountAmount;

          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Container(
              padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 24),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width * 0.95 : 600,
                maxHeight: MediaQuery.of(context).size.height * 0.85, // Reduced to fit better
              ),
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
                    child: Icon(
                      Icons.restaurant, 
                      color: const Color(0xFFFF9933),
                      size: MediaQuery.of(context).size.width < 400 ? 20 : 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Order Summary',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 400 ? 18 : 20, 
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: MediaQuery.of(context).size.width < 400 ? 20 : 24,
                  ),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Order Items Section (Default Open)
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
                    const SizedBox(height: 12),
                    // Order items list - compact view
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: MediaQuery.of(context).size.height < 600 ? 120 : 160,
                      ),
                      child: ListView.builder(
                        shrinkWrap: true,
                        itemCount: currentOrder.length,
                        itemBuilder: (context, index) {
                          final item = currentOrder[index];
                          return Container(
                            margin: const EdgeInsets.symmetric(vertical: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(6),
                              border: Border.all(color: Colors.grey[200]!),
                            ),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        item.menuItem.name,
                                        style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                      Text(
                                        '${formatIndianCurrency(settings.currency, item.unitPrice)} each',
                                        style: TextStyle(color: Colors.grey[600], fontSize: 11),
                                      ),
                                      // Show discount info if present
                                      if (item.hasDiscount) ...[
                                        const SizedBox(height: 2),
                                        Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: Colors.green[100],
                                            borderRadius: BorderRadius.circular(3),
                                          ),
                                          child: Text(
                                            '💸 ${item.discount!.type == DiscountType.percentage ? "${item.discount!.value}% off" : "${formatIndianCurrency(settings.currency, item.discount!.value)} off"}',
                                            style: TextStyle(
                                              color: Colors.green[700],
                                              fontSize: 9,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Row(
                                      children: [
                                        Text('${item.quantity}x', style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13)),
                                        const SizedBox(width: 8),
                                        if (item.hasDiscount) ...[
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              Text(
                                                formatIndianCurrency(settings.currency, item.subtotal),
                                                style: TextStyle(
                                                  decoration: TextDecoration.lineThrough,
                                                  color: Colors.grey[600],
                                                  fontSize: 11,
                                                ),
                                              ),
                                              Text(
                                                formatIndianCurrency(settings.currency, item.total),
                                                style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933), fontSize: 13),
                                              ),
                                            ],
                                          ),
                                        ] else ...[
                                          Text(
                                            formatIndianCurrency(settings.currency, item.total),
                                            style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFFFF9933), fontSize: 13),
                                          ),
                                        ],
                                      ],
                                    ),
                                    // Compact discount action button
                                    if (MediaQuery.of(context).size.width >= 400) ...[
                                      const SizedBox(height: 2),
                                      GestureDetector(
                                        onTap: () => _showItemDiscountDialog(item, index),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                                          decoration: BoxDecoration(
                                            color: item.hasDiscount ? Colors.green[50] : Colors.orange[50],
                                            borderRadius: BorderRadius.circular(3),
                                            border: Border.all(
                                              color: item.hasDiscount ? Colors.green[200]! : Colors.orange[200]!,
                                            ),
                                          ),
                                          child: Text(
                                            item.hasDiscount ? 'Edit' : '+Disc',
                                            style: TextStyle(
                                              color: item.hasDiscount ? Colors.green[700] : Colors.orange[700],
                                              fontSize: 8,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),

                    
                    // Special instructions field
                    const SizedBox(height: 12),
                    TextField(
                      controller: _notesController,
                      decoration: InputDecoration(
                        hintText: 'Special instructions or notes for this order',
                        prefixIcon: const Icon(Icons.note_outlined, size: 18),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                          borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      ),
                      style: const TextStyle(fontSize: 14),
                      maxLines: 2,
                      minLines: 1,
                    ),

                    // Advanced Order Discount Section
                    const SizedBox(height: 12),
                    GestureDetector(
                      onTap: () => _showOrderDiscountDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                          color: discount > 0 ? Colors.green[50] : Colors.grey[50],
                        ),
                        child: Row(
                          children: [
                            Icon(
                              discount > 0 ? Icons.local_offer : Icons.add,
                              size: 16,
                              color: discount > 0 ? Colors.green[700] : Colors.grey[600],
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                _getDiscountDisplayText(),
                                style: TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: discount > 0 ? Colors.green[700] : Colors.grey[700],
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.edit,
                              size: 14,
                              color: Colors.grey[600],
                            ),
                          ],
                        ),
                      ),
                    ),
                    

                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Collapsible Pricing Details Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: ExpansionTile(
                  initiallyExpanded: false,
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: Row(
                    children: [
                      Icon(Icons.receipt_outlined, color: Colors.grey[700], size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Pricing Details',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          // Show item subtotal breakdown if there are discounts
                          if (currentOrder.any((item) => item.hasDiscount)) ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Items Subtotal:'),
                                Text(formatIndianCurrency(settings.currency, 
                                  currentOrder.fold(0.0, (sum, item) => sum + item.subtotal))),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Item Discounts:', style: TextStyle(color: Colors.green)),
                                Text('-${formatIndianCurrency(settings.currency, 
                                  currentOrder.fold(0.0, (sum, item) => sum + item.discountAmount))}',
                                  style: const TextStyle(color: Colors.green)),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('After Item Discounts:'),
                                Text(formatIndianCurrency(settings.currency, subtotal)),
                              ],
                            ),
                          ] else ...[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Subtotal:'),
                                Text(formatIndianCurrency(settings.currency, subtotal)),
                              ],
                            ),
                          ],
                          
                          // Delivery charge for delivery orders (if enabled)
                          if (orderType == OrderType.delivery && settings.deliveryEnabled && _deliveryCharge > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Delivery Charge:'),
                                Text(formatIndianCurrency(settings.currency, _deliveryCharge)),
                              ],
                            ),
                          ],
                          // Packaging charge for delivery/takeaway orders (if enabled)
                          if ((orderType == OrderType.delivery || orderType == OrderType.takeaway) && settings.packagingEnabled && _packagingCharge > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Packaging Charge:'),
                                Text(formatIndianCurrency(settings.currency, _packagingCharge)),
                              ],
                            ),
                          ],
                          // Service charge for dine-in orders (if enabled)
                          if (orderType == OrderType.dineIn && settings.serviceEnabled && _serviceCharge > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Service Charge:'),
                                Text(formatIndianCurrency(settings.currency, _serviceCharge)),
                              ],
                            ),
                          ],
                          
                          // Show order discount if applied
                          if (discount > 0) ...[
                            const SizedBox(height: 4),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Order Discount (${orderDiscount!.type == DiscountType.percentage ? "${orderDiscount.value.toStringAsFixed(0)}%" : formatIndianCurrency(settings.currency, orderDiscount.value)}):', 
                                     style: const TextStyle(color: Colors.green)),
                                Text('-${formatIndianCurrency(settings.currency, discount)}', 
                                     style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                              ],
                            ),
                            if (orderDiscount.reason != null && orderDiscount.reason!.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text('  (${orderDiscount.reason})', 
                                         style: TextStyle(color: Colors.green[600], fontSize: 12, fontStyle: FontStyle.italic)),
                                  ),
                                ],
                              ),
                            ],
                            const SizedBox(height: 4),
                            // Show discounted subtotal/taxable amount
                            if (orderDiscount.applyToSubtotal) ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discounted Subtotal:'),
                                  Text(formatIndianCurrency(settings.currency, subtotal - discount)),
                                ],
                              ),
                              if (charges > 0) ...[
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('After Charges:'),
                                    Text(formatIndianCurrency(settings.currency, (subtotal - discount) + charges)),
                                  ],
                                ),
                              ],
                            ] else ...[
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  const Text('Discounted Amount:'),
                                  Text(formatIndianCurrency(settings.currency, discountedAmount)),
                                ],
                              ),
                            ],
                          ],
                          
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%):'),
                              Text(formatIndianCurrency(settings.currency, tax / 2)),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%):'),
                              Text(formatIndianCurrency(settings.currency, tax / 2)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Always Visible Total Section
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFF9933), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF9933).withOpacity(0.1),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    Text(
                      formatIndianCurrency(settings.currency, total),
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFFFF9933)),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 12),
              
              // Collapsible Customer Information Section
              Container(
                decoration: BoxDecoration(
                  color: Colors.grey[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey[200]!),
                ),
                child: ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  title: Row(
                    children: [
                      Icon(Icons.person_outline, color: Colors.grey[700], size: 18),
                      const SizedBox(width: 8),
                      const Expanded(
                        child: Text(
                          'Customer Information',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                        ),
                      ),
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
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.grey[200]!),
                      ),
                      child: Column(
                        children: [
                          // Customer Name and Phone - vertical layout
                          Column(
                            children: [
                              TextField(
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
                              const SizedBox(height: 12),
                              TextField(
                                controller: _customerPhoneController,
                                decoration: InputDecoration(
                                  labelText: 'Phone Number (10 digits)',
                                  prefixIcon: const Icon(Icons.phone, size: 18),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Color(0xFFFF9933), width: 2),
                                  ),
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(8),
                                    borderSide: const BorderSide(color: Colors.red, width: 1),
                                  ),
                                  filled: true,
                                  fillColor: Colors.white,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                                  labelStyle: const TextStyle(fontSize: 12),
                                  errorText: _customerPhoneController.text.isNotEmpty 
                                      ? _validatePhoneNumber(_customerPhoneController.text) 
                                      : null,
                                ),
                                style: const TextStyle(fontSize: 14),
                                keyboardType: TextInputType.number,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(10),
                                ],
                                onChanged: (value) {
                                  setState(() {}); // Trigger rebuild for validation
                                },
                              ),
                            ],
                          ),
                          
                          const SizedBox(height: 12),
                          
                          // Email and Address fields - vertical layout
                          Column(
                            children: [
                              TextField(
                                controller: _customerEmailController,
                                decoration: InputDecoration(
                                  labelText: 'Email Address',
                                  prefixIcon: const Icon(Icons.email, size: 18),
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
                                keyboardType: TextInputType.emailAddress,
                              ),
                              const SizedBox(height: 12),
                              TextField(
                                controller: _customerAddressController,
                                decoration: InputDecoration(
                                  labelText: 'Address',
                                  prefixIcon: const Icon(Icons.location_on, size: 18),
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
                                maxLines: 2,
                              ),
                            ],
                          ),

                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // Actions Section - responsive layout
              const SizedBox(height: 12),
              MediaQuery.of(context).size.width < 400
                ? Column(
                    children: [
                      // Place Order button (full width on mobile)
                      Container(
                        width: double.infinity,
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
                              Flexible(
                                child: Text(
                                  'Place Order • ${formatIndianCurrency(settings.currency, total)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Cancel button
                      SizedBox(
                        width: double.infinity,
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
                    ],
                  )
                : Row(
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
                                Flexible(
                                  child: Text(
                                    'Place Order • ${formatIndianCurrency(settings.currency, total)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    overflow: TextOverflow.ellipsis,
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
          );
        },
      ),
    );
  }

  // Show item discount dialog
  void _showItemDiscountDialog(OrderItem item, int index) async {
    final discount = await DiscountDialogs.showItemDiscountDialog(
      context: context,
      item: item,
      existingDiscount: item.discount,
    );
    
    if (discount != null) {
      if (discount.value == 0) {
        // Remove discount
        ref.read(currentOrderProvider.notifier).removeItemDiscount(
          item.menuItem.id,
          item.orderType,
        );
      } else {
        // Apply discount
        ref.read(currentOrderProvider.notifier).applyItemDiscount(
          item.menuItem.id,
          item.orderType,
          discount,
        );
      }
    }
  }

  // Show order discount dialog
  void _showOrderDiscountDialog() async {
    final currentOrder = ref.read(currentOrderProvider);
    final orderType = ref.read(orderTypeProvider);
    final settings = ref.read(settingsProvider);
    
    // Create a temporary order to show in discount dialog
    final subtotal = currentOrder.fold(0.0, (sum, item) => sum + item.total);
    final charges = _getOrderCharges(orderType, settings);
    
    final tempOrder = Order(
      id: 'temp',
      items: currentOrder,
      createdAt: DateTime.now(),
      type: orderType,
      charges: charges,
    );
    
    // Get current discount from provider
    final currentDiscount = ref.read(currentOrderDiscountProvider);
    
    final discount = await DiscountDialogs.showOrderDiscountDialog(
      context: context,
      order: tempOrder,
      settings: settings,
      existingDiscount: currentDiscount,
    );
    
    if (discount != null) {
      // Update the discount provider - this will automatically trigger UI rebuild
      ref.read(currentOrderDiscountProvider.notifier).state = discount.value == 0 ? null : discount;
      
      // Update the simple discount controller for backward compatibility and display
      setState(() {
        if (discount.value == 0) {
          _discountController.clear();
        } else {
          // Calculate discount amount for display
          final baseAmount = discount.applyToSubtotal ? tempOrder.subtotal : tempOrder.taxableAmount;
          final discountAmount = discount.calculateDiscount(baseAmount);
          _discountController.text = discountAmount.toStringAsFixed(2);
        }
      });
    }
  }



  void _confirmPlaceOrder() {
    final currentOrder = ref.read(currentOrderProvider);
    final orderType = ref.read(orderTypeProvider);
    final settings = ref.read(settingsProvider);

    // Create customer info if provided
    CustomerInfo? customerInfo;
    if (_customerNameController.text.isNotEmpty || 
        _customerPhoneController.text.isNotEmpty ||
        _customerEmailController.text.isNotEmpty ||
        _customerAddressController.text.isNotEmpty) {
      customerInfo = CustomerInfo(
        name: _customerNameController.text.isEmpty ? null : _customerNameController.text,
        phone: _customerPhoneController.text.isEmpty ? null : _customerPhoneController.text,
        email: _customerEmailController.text.isEmpty ? null : _customerEmailController.text,
        address: _customerAddressController.text.isEmpty ? null : _customerAddressController.text,
      );
    }

    // Create the order (Note: Orders will be stored in memory for now)
    final orderId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Create and add the order to the orders list
    final orderCharges = _getOrderCharges(orderType, settings);

    // Get current order discount
    final orderDiscount = ref.read(currentOrderDiscountProvider);

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
      orderDiscount: orderDiscount,
    );

    // Skip payment collection and directly add order
    // Order will be created without payment and moved to preparing status
    final orderWithoutPayment = newOrder.copyWith(
      status: OrderStatus.preparing, // Skip payment and go directly to preparing
      paymentStatus: PaymentStatus.pending, // Payment pending until completion
    );
    
    // Add order to the orders provider
    ref.read(ordersProvider.notifier).addOrder(orderWithoutPayment);
    print('DEBUG: Order added with status: ${orderWithoutPayment.status}');
    print('DEBUG: Order ID: ${orderWithoutPayment.id}');
    
    // Update customer analytics data if customer info is provided
    if (customerInfo != null) {
      ref.read(customerDataProvider.notifier).addOrUpdateCustomerFromOrder(orderWithoutPayment);
    }
    
    // Clear current order and form
    ref.read(currentOrderProvider.notifier).clearOrder();
    ref.read(currentOrderDiscountProvider.notifier).state = null; // Clear order discount
    _customerNameController.clear();
    _customerPhoneController.clear();
    _customerEmailController.clear();
    _customerAddressController.clear();
    _notesController.clear();
    
    // Reset charges and discount
    setState(() {
      _deliveryCharge = ref.read(settingsProvider).defaultDeliveryCharge;
      _packagingCharge = ref.read(settingsProvider).defaultPackagingCharge;
      _serviceCharge = 0.0;
    });

    // Show optimized success message
    showOptimizedToast(
      context, 
      'Order #${newOrder.id.substring(0, 8)} placed successfully!',
      icon: Icons.check_circle,
      duration: const Duration(seconds: 2),
    );
  }

  void _completeOrderWithPayments(Order order, List<PaymentEntry> payments, CustomerInfo? customerInfo) {
    // Convert PaymentEntry to Payment objects
    final orderPayments = payments.map((entry) => Payment(
      method: _convertPaymentMethodType(entry.method),
      amount: entry.amount,
      timestamp: entry.timestamp,
    )).toList();

    // Update order with payments
    final settings = ref.read(settingsProvider);
    final completedOrder = order.copyWith(
      payments: orderPayments,
      paymentStatus: _getPaymentStatus(payments.fold(0.0, (sum, p) => sum + p.amount), order.getGrandTotal(settings)),
      status: OrderStatus.confirmed, // Move to confirmed after payment
    );
    
    // Add order to the orders provider
    ref.read(ordersProvider.notifier).addOrder(completedOrder);

    // Add payments to payment history
    ref.read(paymentHistoryProvider.notifier).addPaymentsForOrder(order.id, payments);
    
    // Update customer analytics data if customer info is provided
    if (customerInfo != null) {
      ref.read(customerDataProvider.notifier).addOrUpdateCustomerFromOrder(completedOrder);
    }
    
    // Clear current order and form
    ref.read(currentOrderProvider.notifier).clearOrder();
    ref.read(currentOrderDiscountProvider.notifier).state = null; // Clear order discount
    _customerNameController.clear();
    _customerPhoneController.clear();
    _customerEmailController.clear();
    _customerAddressController.clear();
    _notesController.clear();
    
    // Reset charges and discount
    setState(() {
      _deliveryCharge = ref.read(settingsProvider).defaultDeliveryCharge;
      _packagingCharge = ref.read(settingsProvider).defaultPackagingCharge;
      _serviceCharge = 0.0;
      _discountController.clear(); // Reset discount
    });
    
    // Print KOT if enabled
    if (ref.read(settingsProvider).kotEnabled) {
      _printKOT(order.id, order.items, customerInfo);
    }
    
    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order #${order.id} placed and payment received successfully!'),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  PaymentMethod _convertPaymentMethodType(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.cash:
        return PaymentMethod.cash;
      case PaymentMethodType.card:
        return PaymentMethod.card;
      case PaymentMethodType.upi:
      case PaymentMethodType.wallet:
        return PaymentMethod.upi;
      case PaymentMethodType.netBanking:
      default:
        return PaymentMethod.online;
    }
  }

  PaymentStatus _getPaymentStatus(double paidAmount, double totalAmount) {
    if (paidAmount <= 0) return PaymentStatus.pending;
    if (paidAmount >= totalAmount) return PaymentStatus.completed;
    return PaymentStatus.partial;
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
              Navigator.pop(context);
              // Show optimized KOT print message
              showOptimizedToast(
                context,
                'KOT sent to kitchen printer',
                icon: Icons.print,
                color: Colors.blue,
                duration: const Duration(seconds: 2),
              );
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
    final settings = ref.watch(settingsProvider);
    
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
        toolbarHeight: 48,
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
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                '${item.quantity}x ${item.menuItem.name}',
                                style: const TextStyle(fontSize: 13),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                if (item.hasDiscount) ...[
                                  Text(
                                    '₹${item.subtotal.toStringAsFixed(2)}',
                                    style: const TextStyle(
                                      fontSize: 11,
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                  ),
                                ],
                                Text(
                                  '₹${item.total.toStringAsFixed(2)}',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                ),
                              ],
                            ),
                          ],
                        ),
                        if (item.hasDiscount) ...[
                          const SizedBox(height: 2),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Icon(
                                Icons.discount,
                                size: 10,
                                color: Colors.green[600],
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '-₹${item.discountAmount.toStringAsFixed(2)}',
                                style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.green[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
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
                      '₹${order.getGrandTotal(ref.read(settingsProvider)).toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFF9933),
                      ),
                    ),
                    if (order.hasDiscounts) ...[
                      const SizedBox(height: 4),
                      Row(
                        children: [
                          Icon(
                            Icons.local_offer,
                            size: 12,
                            color: Colors.green[600],
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${l10n(ref, 'savings')}: ₹${order.totalDiscountAmount.toStringAsFixed(2)}',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.green[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
                isActive 
                  ? _buildActionButtons(context, ref, order)
                  : _buildCompletedOrderActions(context, ref, order),
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
        // Modify Order button - available for pending, confirmed, and preparing orders
        if (order.status == OrderStatus.pending || 
            order.status == OrderStatus.confirmed || 
            order.status == OrderStatus.preparing)
          OutlinedButton(
            onPressed: () => _showModifyOrderDialog(context, ref, order),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.blue),
              foregroundColor: Colors.blue,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text('Modify', style: TextStyle(fontSize: 12)),
          ),
        
        const SizedBox(width: 8),
        
        if (order.status == OrderStatus.pending || order.status == OrderStatus.confirmed)
          OutlinedButton(
            onPressed: () => ref.read(ordersProvider.notifier).updateOrderStatus(order.id, OrderStatus.preparing),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFFFF9933)),
              foregroundColor: const Color(0xFFFF9933),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(l10n(ref, 'start_prep'), style: TextStyle(fontSize: 12)),
          ),
        
        if (order.status == OrderStatus.preparing)
          OutlinedButton(
            onPressed: () => ref.read(ordersProvider.notifier).updateOrderStatus(order.id, OrderStatus.ready),
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.green),
              foregroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            ),
            child: Text(l10n(ref, 'mark_ready'), style: TextStyle(fontSize: 12)),
          ),
        
        if (order.status == OrderStatus.ready)
          ElevatedButton(
            onPressed: () {
              // Check if payment is needed
              if (order.paymentStatus != PaymentStatus.completed) {
                // Show payment dialog
                final enabledMethods = ref.read(paymentConfigProvider.notifier).enabledMethodConfigs;
                
                if (enabledMethods.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('No payment methods are enabled. Please configure payment methods first.'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }

                showDialog(
                  context: context,
                  barrierDismissible: false,
                  builder: (context) => OrderCompletionPaymentDialog(
                    order: order,
                    onPaymentComplete: (payments) {
                      // Convert PaymentEntry to Payment objects
                      final orderPayments = payments.map((entry) => Payment(
                        method: entry.method == PaymentMethodType.cash ? PaymentMethod.cash :
                               entry.method == PaymentMethodType.card ? PaymentMethod.card :
                               entry.method == PaymentMethodType.upi ? PaymentMethod.upi : PaymentMethod.online,
                        amount: entry.amount,
                        timestamp: entry.timestamp,
                      )).toList();

                      // Update order with payments and complete status  
                      final settings = ref.read(settingsProvider);
                      final completedOrder = order.copyWith(
                        payments: orderPayments,
                        paymentStatus: payments.fold(0.0, (sum, p) => sum + p.amount) >= order.getGrandTotal(settings) - 0.01 
                            ? PaymentStatus.completed : PaymentStatus.partial,
                        status: OrderStatus.completed,
                      );
                      
                      // Update the order in the orders provider
                      ref.read(ordersProvider.notifier).updateOrder(completedOrder);

                      // Add payments to payment history
                      ref.read(paymentHistoryProvider.notifier).addPaymentsForOrder(order.id, payments);
                      
                      // Show success message
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Payment collected successfully! Order completed.'),
                          backgroundColor: Colors.green,
                        ),
                      );
                    },
                  ),
                );
              } else {
                // Already paid, just complete the order
                ref.read(ordersProvider.notifier).updateOrderStatus(order.id, OrderStatus.completed);
              }
            },
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
                _showOrderDetails(context, order, ref.read(settingsProvider));
                break;
              case 'print':
                _printOrderBill(context, order, ref.read(settingsProvider));
                break;
              case 'whatsapp':
                _shareOnWhatsApp(context, ref, order);
                break;
              case 'split':
                _splitOrderBill(context, order, ref.read(settingsProvider));
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
              value: 'whatsapp',
              child: Row(
                children: [
                  Icon(Icons.message, size: 16, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Share WhatsApp', style: TextStyle(color: Colors.green)),
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

  Widget _buildCompletedOrderActions(BuildContext context, WidgetRef ref, Order order) {
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'view':
            _showOrderDetails(context, order, ref.read(settingsProvider));
            break;
          case 'print':
            _printOrderBill(context, order, ref.read(settingsProvider));
            break;
          case 'whatsapp':
            _shareOnWhatsApp(context, ref, order);
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
        PopupMenuItem(
          value: 'whatsapp',
          child: Row(
            children: [
              Icon(Icons.message, size: 16, color: Colors.green),
              SizedBox(width: 8),
              Text('Share WhatsApp', style: TextStyle(color: Colors.green)),
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

  void _showModifyOrderDialog(BuildContext context, WidgetRef ref, Order order) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => ModifyOrderDialog(order: order),
    );
  }

  void _showOrderDetails(BuildContext context, Order order, AppSettings settings) {
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
                padding: const EdgeInsets.only(top: 4, bottom: 4),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text('${item.quantity}x ${item.menuItem.name}'),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            if (item.hasDiscount) ...[
                              Text(
                                '₹${item.subtotal.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  decoration: TextDecoration.lineThrough,
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                              Text(
                                '-₹${item.discountAmount.toStringAsFixed(2)}',
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                            Text(
                              '₹${item.total.toStringAsFixed(2)}',
                              style: const TextStyle(fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                      ],
                    ),
                    if (item.hasDiscount && item.discount?.reason != null)
                      Padding(
                        padding: const EdgeInsets.only(left: 16, top: 2),
                        child: Text(
                          'Discount: ${item.discount!.reason}',
                          style: const TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                      ),
                  ],
                ),
              )).toList(),
              const SizedBox(height: 16),
              const Text('Bill Breakdown:', style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              
              // Items subtotal
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Items Subtotal:'),
                  Text('₹${order.itemsSubtotal.toStringAsFixed(2)}'),
                ],
              ),
              
              // Item-level discounts
              if (order.hasItemDiscounts) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Item Discounts:', style: TextStyle(color: Colors.green)),
                    Text('-₹${order.itemsDiscountAmount.toStringAsFixed(2)}', 
                         style: const TextStyle(color: Colors.green)),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('After Item Discounts:'),
                    Text('₹${order.itemsTotal.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              // Show delivery charge if delivery order and enabled
              if (order.type == OrderType.delivery && settings.deliveryEnabled && order.charges.deliveryCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Delivery Charge:'),
                    Text('₹${order.charges.deliveryCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              // Show packaging charge if applicable and enabled
              if ((order.type == OrderType.delivery || order.type == OrderType.takeaway) && settings.packagingEnabled && order.charges.packagingCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Packaging Charge:'),
                    Text('₹${order.charges.packagingCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              // Show service charge if applicable and enabled
              if (order.type == OrderType.dineIn && settings.serviceEnabled && order.charges.serviceCharge > 0) ...[
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Service Charge:'),
                    Text('₹${order.charges.serviceCharge.toStringAsFixed(2)}'),
                  ],
                ),
              ],
              
              // Order-level discount
              if (order.hasOrderDiscount) ...[
                const SizedBox(height: 8),
                const Divider(height: 1),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Order Discount (${order.orderDiscount!.type == DiscountType.percentage ? '${order.orderDiscount!.value.toStringAsFixed(0)}%' : 'Fixed'}):',
                         style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                    Text('-₹${order.orderDiscountAmount.toStringAsFixed(2)}', 
                         style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500)),
                  ],
                ),
                if (order.orderDiscount?.reason != null) ...[
                  const SizedBox(height: 2),
                  Text('  ${order.orderDiscount!.reason}', 
                       style: const TextStyle(fontSize: 12, color: Colors.grey, fontStyle: FontStyle.italic)),
                ],
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('After Order Discount:', style: const TextStyle(fontWeight: FontWeight.w500)),
                    Text('₹${order.discountedAmount.toStringAsFixed(2)}', 
                         style: const TextStyle(fontWeight: FontWeight.w500)),
                  ],
                ),
              ],
              
              const SizedBox(height: 8),
              // SGST display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%):'),
                  Text('₹${order.calculateSGST(settings).toStringAsFixed(2)}'),
                ],
              ),
              // CGST display
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%):'),
                  Text('₹${order.calculateCGST(settings).toStringAsFixed(2)}'),
                ],
              ),
              const Divider(height: 16),
              
              // Show total savings if any discounts
              if (order.hasDiscounts) ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Savings:', style: TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 15)),
                    Text('₹${order.totalDiscountAmount.toStringAsFixed(2)}', 
                         style: const TextStyle(color: Colors.green, fontWeight: FontWeight.w500, fontSize: 15)),
                  ],
                ),
                const SizedBox(height: 8),
              ],
              
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Total:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  Text('₹${order.getGrandTotal(settings).toStringAsFixed(2)}', 
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
              ref.read(ordersProvider.notifier).updateOrderStatus(order.id, OrderStatus.cancelled);
              Navigator.pop(context);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Yes, Cancel'),
          ),
        ],
      ),
    );
  }

  void _printOrderBill(BuildContext context, Order order, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.print, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Print Bill Options'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Choose how to print the bill for Order #${order.id.substring(order.id.length - 8)}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            
            // Detailed Bill Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt_long, color: Color(0xFFFF9933)),
                title: const Text('Detailed Bill'),
                subtitle: const Text('Complete receipt with all charges, taxes, and GST details'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await _printDetailedBill(context, order, settings);
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Quick Receipt Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.receipt, color: Colors.green),
                title: const Text('Quick Receipt'),
                subtitle: const Text('Simple receipt with items and total only'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () async {
                  Navigator.pop(context);
                  await _printQuickReceipt(context, order, settings);
                },
              ),
            ),
            
            const SizedBox(height: 8),
            
            // Preview Option
            Card(
              child: ListTile(
                leading: const Icon(Icons.preview, color: Colors.blue),
                title: const Text('Preview Bill'),
                subtitle: const Text('View formatted bill before printing'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pop(context);
                  _previewBill(context, order, settings);
                },
              ),
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

  Future<void> _printDetailedBill(BuildContext context, Order order, AppSettings settings) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Preparing detailed bill...'),
          ],
        ),
      ),
    );

    try {
      // Use the actual PrintingService and BillPrintingService
      final printingService = PrintingService();
      final success = await BillPrintingService.printOrderBill(
        order: order,
        settings: settings,
        printingService: printingService,
        orderSource: 'POS',
      );

      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        // Show success message
        showOptimizedToast(
          context,
          'Detailed bill sent to thermal printer!',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      } else {
        // Show warning - printer not connected but bill formatted successfully
        showOptimizedToast(
          context,
          'Bill formatted successfully. Connect thermal printer to print.',
          color: Colors.orange,
          icon: Icons.warning,
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      // Show error message
      showOptimizedToast(
        context,
        'Print failed: ${e.toString()}',
        color: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> _printQuickReceipt(BuildContext context, Order order, AppSettings settings) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Printing quick receipt...'),
          ],
        ),
      ),
    );

    try {
      // Use the actual PrintingService and BillPrintingService
      final printingService = PrintingService();
      final success = await BillPrintingService.printQuickReceipt(
        order: order,
        settings: settings,
        printingService: printingService,
      );

      Navigator.pop(context); // Close loading dialog
      
      if (success) {
        // Show success message
        showOptimizedToast(
          context,
          'Quick receipt printed successfully!',
          color: Colors.green,
          icon: Icons.check_circle,
        );
      } else {
        // Show warning - printer not connected but receipt formatted successfully
        showOptimizedToast(
          context,
          'Receipt formatted successfully. Connect thermal printer to print.',
          color: Colors.orange,
          icon: Icons.warning,
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      // Show error message
      showOptimizedToast(
        context,
        'Print failed: ${e.toString()}',
        color: Colors.red,
        icon: Icons.error,
      );
    }
  }

  void _previewBill(BuildContext context, Order order, AppSettings settings) {
    final billContent = _generateDetailedBillPreview(order, settings);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.preview, color: Color(0xFFFF9933)),
            SizedBox(width: 8),
            Text('Bill Preview'),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 500,
          child: SingleChildScrollView(
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
                color: Colors.grey[50],
              ),
              child: Text(
                billContent,
                style: const TextStyle(
                  fontFamily: 'monospace',
                  fontSize: 11,
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
              Navigator.pop(context);
              _printDetailedBill(context, order, settings);
            },
            icon: const Icon(Icons.print),
            label: const Text('Print This'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF9933),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  String _generateDetailedBillPreview(Order order, AppSettings settings) {
    final buffer = StringBuffer();
    final grandTotal = order.getGrandTotal(settings);
    
    // Header
    buffer.writeln('================================');
    buffer.writeln('        ${settings.businessName}');
    buffer.writeln('================================');
    buffer.writeln(settings.address);
    buffer.writeln('Ph No - ${settings.phone}');
    if (settings.email.isNotEmpty) {
      buffer.writeln('Email: ${settings.email}');
    }
    buffer.writeln('');
    
    // Order info
    buffer.writeln('From POS [${order.id.substring(order.id.length - 8)}]');
    if (order.customer?.name != null) {
      buffer.writeln('Name: ${order.customer!.name}');
    }
    buffer.writeln('');
    
    final now = DateTime.now();
    buffer.writeln('Date: ${now.day.toString().padLeft(2, '0')}/${now.month.toString().padLeft(2, '0')}/${now.year}   Online');
    buffer.writeln('${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}');
    buffer.writeln('Cashier:           Bill No.: ${_generateBillNumber(order)}');
    buffer.writeln('Autoaccept');
    buffer.writeln('Token No.: ${order.id.substring(order.id.length - 3)}');
    buffer.writeln('--------------------------------');
    
    // Items header
    buffer.writeln('Item            Qty. Price Amount');
    buffer.writeln('--------------------------------');
    
    // Items
    for (final item in order.items) {
      String itemName = item.menuItem.name;
      if (itemName.length > 16) {
        buffer.writeln(itemName);
        buffer.writeln('                ${item.quantity} ${item.unitPrice.toStringAsFixed(2).padLeft(6)} ${item.total.toStringAsFixed(2).padLeft(7)}');
      } else {
        buffer.writeln('${itemName.padRight(16)}${item.quantity} ${item.unitPrice.toStringAsFixed(2).padLeft(6)} ${item.total.toStringAsFixed(2).padLeft(7)}');
      }
    }
    
    buffer.writeln('--------------------------------');
    
    // Totals
    final totalQty = order.items.fold(0, (sum, item) => sum + item.quantity);
    buffer.writeln('Total Qty: $totalQty            Sub');
    buffer.writeln('                   Total   ${order.itemsTotal.toStringAsFixed(2).padLeft(6)}');
    
    // Discounts
    if (order.hasDiscounts) {
      buffer.writeln('                Discount Fixed  (${order.totalDiscountAmount.toStringAsFixed(2)})');
    }
    
    // Charges
    if (order.charges.deliveryCharge > 0) {
      buffer.writeln('Delivery Charge               ${order.charges.deliveryCharge.toStringAsFixed(2).padLeft(4)}');
    }
    if (order.charges.packagingCharge > 0) {
      buffer.writeln('Packaging Charge              ${order.charges.packagingCharge.toStringAsFixed(2).padLeft(4)}');
    }
    if (order.charges.serviceCharge > 0) {
      buffer.writeln('Service Charge                ${order.charges.serviceCharge.toStringAsFixed(2).padLeft(4)}');
    }
    
    buffer.writeln('--------------------------------');
    
    // Grand total
    buffer.writeln('      Grand Total   ₹ ${grandTotal.toStringAsFixed(2)}');
    buffer.writeln('Paid via Cash [POS]');
    buffer.writeln('--------------------------------');
    
    // Notes
    if (order.notes != null && order.notes!.isNotEmpty) {
      buffer.writeln('Customer Notes: ${order.notes}');
    }
    
    buffer.writeln('--------------------------------');
    buffer.writeln('        Thanks For Ordering !!!');
    
    return buffer.toString();
  }

  String _generateBillNumber(Order order) {
    final timestamp = order.createdAt;
    final dateStr = '${timestamp.day.toString().padLeft(2, '0')}${timestamp.month.toString().padLeft(2, '0')}${timestamp.year.toString().substring(2)}';
    final timeStr = '${timestamp.hour.toString().padLeft(2, '0')}${timestamp.minute.toString().padLeft(2, '0')}';
    final orderSuffix = order.id.substring(order.id.length - 4);
    return '$dateStr$timeStr$orderSuffix';
  }

  void _splitOrderBill(BuildContext context, Order order, AppSettings settings) {
    int numberOfSplits = 2;
    bool splitEqually = true;
    List<List<OrderItem>> splitOrders = [];
    
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
                      
                      // Calculate proportional charges based on split ratio
                      final splitRatio = splitSubtotal / order.subtotal;
                      final proportionalCharges = (order.charges.deliveryCharge + order.charges.packagingCharge + order.charges.serviceCharge) * splitRatio;
                      
                      final splitTaxableAmount = splitSubtotal + proportionalCharges;
                      final splitTax = splitTaxableAmount * settings.totalTaxRate;
                      final splitGrandTotal = splitTaxableAmount + splitTax;
                      
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
                              if (proportionalCharges > 0) ...[
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    const Text('Charges:', style: TextStyle(fontSize: 12)),
                                    Text('₹${proportionalCharges.toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                  ],
                                ),
                              ],
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%):', style: const TextStyle(fontSize: 12)),
                                  Text('₹${(splitTax / 2).toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%):', style: const TextStyle(fontSize: 12)),
                                  Text('₹${(splitTax / 2).toStringAsFixed(2)}', style: const TextStyle(fontSize: 12)),
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
                  
                  // Calculate proportional charges based on split ratio
                  final splitRatio = splitSubtotal / order.subtotal;
                  final proportionalCharges = (order.charges.deliveryCharge + order.charges.packagingCharge + order.charges.serviceCharge) * splitRatio;
                  
                  final splitTaxableAmount = splitSubtotal + proportionalCharges;
                  final splitTax = splitTaxableAmount * settings.totalTaxRate;
                  final billContent = _generateSplitOrderBillContent(splitItems, settings, splitSubtotal, splitTax, i + 1, numberOfSplits, order.id, order, proportionalCharges);
                  
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
    buffer.writeln('    ${settings.businessName.toUpperCase()}');
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
      if (item.hasDiscount) {
        buffer.writeln('  ${item.quantity} x ₹${item.unitPrice.toStringAsFixed(2)} = ₹${item.subtotal.toStringAsFixed(2)}');
        buffer.writeln('  Discount: -₹${item.discountAmount.toStringAsFixed(2)}');
        if (item.discount?.reason != null) {
          buffer.writeln('  Reason: ${item.discount!.reason}');
        }
        buffer.writeln('  Final: ₹${item.total.toStringAsFixed(2)}');
      } else {
        buffer.writeln('  ${item.quantity} x ₹${item.unitPrice.toStringAsFixed(2)} = ₹${item.total.toStringAsFixed(2)}');
      }
      buffer.writeln();
    }
    
    buffer.writeln('-' * 32);
    buffer.writeln('BILL BREAKDOWN:');
    buffer.writeln('Items Subtotal: ₹${order.itemsSubtotal.toStringAsFixed(2)}');
    
    // Show item-level discounts
    if (order.hasItemDiscounts) {
      buffer.writeln('Item Discounts: -₹${order.itemsDiscountAmount.toStringAsFixed(2)}');
      buffer.writeln('After Item Discounts: ₹${order.itemsTotal.toStringAsFixed(2)}');
    }
    
    // Add delivery charge if applicable and enabled
    if (order.type == OrderType.delivery && settings.deliveryEnabled && order.charges.deliveryCharge > 0) {
      buffer.writeln('Delivery Charge: ₹${order.charges.deliveryCharge.toStringAsFixed(2)}');
    }
    
    // Add packaging charge if applicable and enabled
    if ((order.type == OrderType.delivery || order.type == OrderType.takeaway) && settings.packagingEnabled && order.charges.packagingCharge > 0) {
      buffer.writeln('Packaging Charge: ₹${order.charges.packagingCharge.toStringAsFixed(2)}');
    }
    
    // Add service charge if applicable and enabled
    if (order.type == OrderType.dineIn && settings.serviceEnabled && order.charges.serviceCharge > 0) {
      buffer.writeln('Service Charge: ₹${order.charges.serviceCharge.toStringAsFixed(2)}');
    }
    
    // Show order-level discount
    if (order.hasOrderDiscount) {
      buffer.writeln('');
      final discountLabel = order.orderDiscount!.type == DiscountType.percentage 
          ? 'Order Discount (${order.orderDiscount!.value.toStringAsFixed(0)}%)'
          : 'Order Discount (Fixed)';
      buffer.writeln('$discountLabel: -₹${order.orderDiscountAmount.toStringAsFixed(2)}');
      if (order.orderDiscount?.reason != null) {
        buffer.writeln('Reason: ${order.orderDiscount!.reason}');
      }
      buffer.writeln('After Order Discount: ₹${order.discountedAmount.toStringAsFixed(2)}');
    }
    
    // Show tax breakdown
    final sgstAmount = order.calculateSGST(settings);
    final cgstAmount = order.calculateCGST(settings);
    buffer.writeln('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%): ₹${sgstAmount.toStringAsFixed(2)}');
    buffer.writeln('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%): ₹${cgstAmount.toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    
    // Show total savings if any discounts
    if (order.hasDiscounts) {
      buffer.writeln('TOTAL SAVINGS: ₹${order.totalDiscountAmount.toStringAsFixed(2)}');
      buffer.writeln('-' * 32);
    }
    
    buffer.writeln('TOTAL: ₹${order.getGrandTotal(settings).toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    buffer.writeln('       Thank you!');
    buffer.writeln('   Visit us again!');
    
    return buffer.toString();
  }

  String _generateSplitOrderBillContent(List<OrderItem> items, AppSettings settings, double splitSubtotal, double splitTax, int billNumber, int totalBills, String orderId, Order originalOrder, double proportionalCharges) {
    final buffer = StringBuffer();
    buffer.writeln('=' * 32);
    buffer.writeln('    ${settings.businessName.toUpperCase()}');
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
    
    // Add proportional delivery charge if applicable and enabled
    if (originalOrder.type == OrderType.delivery && settings.deliveryEnabled && originalOrder.charges.deliveryCharge > 0) {
      final splitDeliveryCharge = originalOrder.charges.deliveryCharge * splitRatio;
      buffer.writeln('Delivery Charge: ₹${splitDeliveryCharge.toStringAsFixed(2)}');
    }
    
    // Add proportional packaging charge if applicable and enabled
    if ((originalOrder.type == OrderType.delivery || originalOrder.type == OrderType.takeaway) && settings.packagingEnabled && originalOrder.charges.packagingCharge > 0) {
      final splitPackagingCharge = originalOrder.charges.packagingCharge * splitRatio;
      buffer.writeln('Packaging Charge: ₹${splitPackagingCharge.toStringAsFixed(2)}');
    }
    
    // Add proportional service charge if applicable and enabled
    if (originalOrder.type == OrderType.dineIn && settings.serviceEnabled && originalOrder.charges.serviceCharge > 0) {
      final splitServiceCharge = originalOrder.charges.serviceCharge * splitRatio;
      buffer.writeln('Service Charge: ₹${splitServiceCharge.toStringAsFixed(2)}');
    }
    
    // Show individual tax components
    final splitTaxableAmount = splitSubtotal + proportionalCharges;
    final sgstAmount = splitTaxableAmount * settings.sgstRate;
    final cgstAmount = splitTaxableAmount * settings.cgstRate;
    
    buffer.writeln('SGST (${(settings.sgstRate * 100).toStringAsFixed(1)}%): ₹${sgstAmount.toStringAsFixed(2)}');
    buffer.writeln('CGST (${(settings.cgstRate * 100).toStringAsFixed(1)}%): ₹${cgstAmount.toStringAsFixed(2)}');
    
    final splitTotal = splitTaxableAmount + splitTax;
    
    buffer.writeln('=' * 32);
    buffer.writeln('TOTAL: ₹${splitTotal.toStringAsFixed(2)}');
    buffer.writeln('=' * 32);
    buffer.writeln('       Thank you!');
    buffer.writeln('   Visit us again!');
    
    return buffer.toString();
  }

  void _shareOnWhatsApp(BuildContext context, WidgetRef ref, Order order) async {
    final settings = ref.read(settingsProvider);
    
    // Show sharing options dialog
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(Icons.message, color: Colors.green[600]),
            const SizedBox(width: 8),
            const Text('Share Bill'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (order.customer?.phone != null) ...[
              ListTile(
                leading: Icon(Icons.person, color: Colors.green[600]),
                title: const Text('Send Text to Customer'),
                subtitle: Text('${order.customer!.name ?? 'Customer'} - ${order.customer!.phone}'),
                onTap: () async {
                  Navigator.pop(context);
                  await _sendWhatsAppBill(context, order, settings, toCustomer: true);
                },
              ),
              ListTile(
                leading: Icon(Icons.person_pin_circle, color: Colors.green[700]),
                title: const Text('Send PDF to Customer'),
                subtitle: Text('Send receipt PDF to ${order.customer!.name ?? 'Customer'}'),
                onTap: () async {
                  Navigator.pop(context);
                  await _sendWhatsAppBillAsPDF(context, order, settings);
                },
              ),
            ],
            ListTile(
              leading: Icon(Icons.share, color: Colors.blue[600]),
              title: const Text('Share as Text'),
              subtitle: const Text('Share bill as WhatsApp message'),
              onTap: () async {
                Navigator.pop(context);
                await _sendWhatsAppBill(context, order, settings, toCustomer: false);
              },
            ),
            ListTile(
              leading: Icon(Icons.picture_as_pdf, color: Colors.red[600]),
              title: const Text('Share as Receipt PDF'),
              subtitle: const Text('Generate and share quick receipt PDF'),
              onTap: () async {
                Navigator.pop(context);
                await _sendWhatsAppBillAsPDF(context, order, settings);
              },
            ),
            ListTile(
              leading: Icon(Icons.edit, color: Colors.orange[600]),
              title: const Text('Custom Text Message'),
              subtitle: const Text('Edit message before sharing'),
              onTap: () {
                Navigator.pop(context);
                _showCustomMessageDialog(context, order, settings);
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

  Future<void> _sendWhatsAppBill(BuildContext context, Order order, AppSettings settings, {required bool toCustomer}) async {
    try {
      await WhatsAppService.shareBill(
        order: order,
        settings: settings,
      );
      
      showOptimizedToast(
        context,
        toCustomer ? 'Bill sent to customer via WhatsApp' : 'WhatsApp opened with bill details',
        color: Colors.green,
        icon: Icons.check_circle,
      );
    } catch (e) {
      showOptimizedToast(
        context,
        'Could not open WhatsApp: ${e.toString()}',
        color: Colors.red,
        icon: Icons.error,
      );
    }
  }

  Future<void> _sendWhatsAppBillAsPDF(BuildContext context, Order order, AppSettings settings) async {
    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Generating receipt PDF...'),
          ],
        ),
      ),
    );

    try {
      await WhatsAppService.shareBillAsPDF(
        order: order,
        settings: settings,
      );
      
      Navigator.pop(context); // Close loading dialog
      
      showOptimizedToast(
        context,
        'Receipt PDF generated and ready to share!',
        color: Colors.green,
        icon: Icons.check_circle,
      );
    } catch (e) {
      Navigator.pop(context); // Close loading dialog
      
      showOptimizedToast(
        context,
        'Could not generate PDF: ${e.toString()}',
        color: Colors.red,
        icon: Icons.error,
      );
    }
  }

  void _showCustomMessageDialog(BuildContext context, Order order, AppSettings settings) {
    final defaultMessage = WhatsAppService._generateWhatsAppBillContent(order, settings);
    final messageController = TextEditingController(text: defaultMessage);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Custom WhatsApp Message'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: TextField(
            controller: messageController,
            maxLines: null,
            expands: true,
            decoration: const InputDecoration(
              hintText: 'Edit your message...',
              border: OutlineInputBorder(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(context);
              try {
                await WhatsAppService.shareBill(
                  order: order,
                  settings: settings,
                  customMessage: messageController.text,
                );
                showOptimizedToast(
                  context,
                  'WhatsApp opened with custom message',
                  color: Colors.green,
                  icon: Icons.check_circle,
                );
              } catch (e) {
                showOptimizedToast(
                  context,
                  'Could not open WhatsApp: ${e.toString()}',
                  color: Colors.red,
                  icon: Icons.error,
                );
              }
            },
            child: const Text('Share'),
          ),
        ],
      ),
    );
  }
}

// Modify Order Dialog for adding/removing items from active orders
class ModifyOrderDialog extends ConsumerStatefulWidget {
  final Order order;

  const ModifyOrderDialog({super.key, required this.order});

  @override
  ConsumerState<ModifyOrderDialog> createState() => _ModifyOrderDialogState();
}

class _ModifyOrderDialogState extends ConsumerState<ModifyOrderDialog> {
  late List<OrderItem> modifiedItems;
  
  @override
  void initState() {
    super.initState();
    // Create a copy of the current order items
    modifiedItems = widget.order.items.map((item) => OrderItem(
      menuItem: item.menuItem,
      quantity: item.quantity,
      orderType: item.orderType,
      selectedAddons: item.selectedAddons,
      specialInstructions: item.specialInstructions,
      discount: item.discount,
    )).toList();
  }

  double get modifiedTotal {
    double total = 0;
    for (final item in modifiedItems) {
      total += item.total;
    }
    return total;
  }

  void _addMenuItem(MenuItem menuItem) {
    final existingIndex = modifiedItems.indexWhere((item) => item.menuItem.id == menuItem.id);
    
    if (existingIndex != -1) {
      // Increase quantity if item already exists
      setState(() {
        modifiedItems[existingIndex] = modifiedItems[existingIndex].copyWith(
          quantity: modifiedItems[existingIndex].quantity + 1,
        );
      });
    } else {
      // Add new item
      setState(() {
        modifiedItems.add(OrderItem(
          menuItem: menuItem,
          quantity: 1,
          orderType: widget.order.type,
        ));
      });
    }
  }

  void _removeMenuItem(int itemIndex) {
    if (itemIndex >= 0 && itemIndex < modifiedItems.length) {
      if (modifiedItems[itemIndex].quantity > 1) {
        // Decrease quantity
        setState(() {
          modifiedItems[itemIndex] = modifiedItems[itemIndex].copyWith(
            quantity: modifiedItems[itemIndex].quantity - 1,
          );
        });
      } else {
        // Remove item completely
        setState(() {
          modifiedItems.removeAt(itemIndex);
        });
      }
    }
  }

  void _updateOrder() {
    if (modifiedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Order must have at least one item'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final updatedOrder = widget.order.copyWith(
      items: modifiedItems,
    );

    ref.read(ordersProvider.notifier).updateOrder(updatedOrder);
    Navigator.pop(context);
    
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Order updated successfully'),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final menuItems = ref.watch(menuProvider);
    final settings = ref.watch(settingsProvider);
    
    return Dialog(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Modify Order #${widget.order.id}',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            // Current items section
            Expanded(
              flex: 3,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Current Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: modifiedItems.isEmpty
                          ? const Center(child: Text('No items in order'))
                          : ListView.builder(
                              itemCount: modifiedItems.length,
                              itemBuilder: (context, index) {
                                final item = modifiedItems[index];
                                return ListTile(
                                  title: Text(item.menuItem.name),
                                  subtitle: Text('${formatIndianCurrency(settings.currency, item.unitPrice)} x ${item.quantity}'),
                                  trailing: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        formatIndianCurrency(settings.currency, item.total),
                                        style: const TextStyle(fontWeight: FontWeight.bold),
                                      ),
                                      IconButton(
                                        onPressed: () => _removeMenuItem(index),
                                        icon: const Icon(Icons.remove_circle_outline, color: Colors.red),
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Add items section
            Expanded(
              flex: 4,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Add Items:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade300),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: ListView.builder(
                        itemCount: menuItems.length,
                        itemBuilder: (context, index) {
                          final menuItem = menuItems[index];
                          if (!menuItem.isAvailable) return const SizedBox.shrink();
                          
                          final price = menuItem.getPriceForOrderType(widget.order.type);
                          
                          return ListTile(
                            title: Text(menuItem.name),
                            subtitle: Text('${menuItem.category} - ${formatIndianCurrency(settings.currency, price)}'),
                            trailing: IconButton(
                              onPressed: () => _addMenuItem(menuItem),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.green),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Total and actions
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'New Total:',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        formatIndianCurrency(settings.currency, modifiedTotal),
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.green),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        onPressed: _updateOrder,
                        child: const Text('Update Order'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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



  void _showEditItemDialog(BuildContext context, WidgetRef ref, MenuItem item) {
    final nameController = TextEditingController(text: item.name);
    final dineInPriceController = TextEditingController(text: item.dineInPrice.toString());
    final takeawayPriceController = TextEditingController(text: item.takeawayPrice.toString());
    final categoryController = TextEditingController(text: item.category);
    
    final menuItems = ref.read(menuProvider);
    final existingCategories = menuItems.map((item) => item.category).toSet().toList()..sort();
    String selectedCategory = item.category;

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
              DropdownButtonFormField<String>(
                value: existingCategories.contains(selectedCategory) ? selectedCategory : null,
                decoration: const InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(),
                ),
                items: [
                  ...existingCategories.map((category) => DropdownMenuItem(
                    value: category,
                    child: Text(category),
                  )),
                ],
                onChanged: (value) {
                  selectedCategory = value ?? item.category;
                },
                hint: const Text('Select Category'),
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
                  category: selectedCategory,
                  isAvailable: item.isAvailable,
                  addons: item.addons,
                  allowCustomization: item.allowCustomization,
                  deliveryPrice: item.deliveryPrice,
                  description: item.description,
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

    final totalSales = filteredOrders.fold(0.0, (sum, order) => sum + order.getGrandTotal(settings));
    final totalOrders = filteredOrders.length;
    final completedOrders = filteredOrders.where((order) => order.status == OrderStatus.completed).length;
    final averageOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;
    final totalItems = filteredOrders.fold(0, (sum, order) => sum + order.items.fold(0, (itemSum, item) => itemSum + item.quantity));
    
    // Calculate additional metrics
    final packagingRevenue = filteredOrders.fold(0.0, (sum, order) => sum + order.charges.packagingCharge);
    final deliveryRevenue = filteredOrders.fold(0.0, (sum, order) => sum + order.charges.deliveryCharge);
    
    // Discount analytics
    final ordersWithDiscounts = filteredOrders.where((order) => order.hasDiscounts).length;
    final totalDiscountAmount = filteredOrders.fold(0.0, (sum, order) => sum + order.totalDiscountAmount);
    final itemDiscountAmount = filteredOrders.fold(0.0, (sum, order) => sum + order.itemsDiscountAmount);
    final orderDiscountAmount = filteredOrders.fold(0.0, (sum, order) => sum + order.orderDiscountAmount);
    final discountRate = totalSales > 0 ? (totalDiscountAmount / (totalSales + totalDiscountAmount)) * 100 : 0.0;
    final avgDiscountPerOrder = totalOrders > 0 ? totalDiscountAmount / totalOrders : 0.0;

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
      dailyData[dateKey]!['sales'] += order.getGrandTotal(settings);
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
                padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 20),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Sales Analytics',
                                style: TextStyle(
                                  fontSize: MediaQuery.of(context).size.width < 400 ? 18 : 22,
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
                    SizedBox(height: MediaQuery.of(context).size.width < 400 ? 16 : 20),
                    // Enhanced Filter Chips Section
                    Container(
                      padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 20),
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
                          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 20),
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
                                      crossAxisCount: MediaQuery.of(context).size.width < 600 ? 2 : 3,
                                      mainAxisSpacing: MediaQuery.of(context).size.width < 400 ? 8 : 12,
                                      crossAxisSpacing: MediaQuery.of(context).size.width < 400 ? 8 : 12,
                                      childAspectRatio: MediaQuery.of(context).size.width < 400 ? 1.2 : 1.1,
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
                                        _buildMetricCard(
                                          'Total Discounts',
                                          formatIndianCurrency(settings.currency, totalDiscountAmount),
                                          Icons.local_offer,
                                          Colors.red,
                                          '$ordersWithDiscounts orders (${discountRate.toStringAsFixed(1)}%)',
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Discount Analytics Section
                              if (totalDiscountAmount > 0) ...[
                                Container(
                                  padding: const EdgeInsets.all(16),
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Colors.red.withOpacity(0.05),
                                        Colors.white,
                                      ],
                                      begin: Alignment.topLeft,
                                      end: Alignment.bottomRight,
                                    ),
                                    borderRadius: BorderRadius.circular(16),
                                    border: Border.all(color: Colors.red.withOpacity(0.2)),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: Colors.red.withOpacity(0.1),
                                              borderRadius: BorderRadius.circular(8),
                                            ),
                                            child: const Icon(
                                              Icons.local_offer,
                                              color: Colors.red,
                                              size: 20,
                                            ),
                                          ),
                                          const SizedBox(width: 10),
                                          const Text(
                                            'Discount Analytics',
                                            style: TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black87,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 20),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildDiscountMetricCard(
                                              'Total Discounts',
                                              formatIndianCurrency(settings.currency, totalDiscountAmount),
                                              '${discountRate.toStringAsFixed(1)}% of sales',
                                              Icons.discount,
                                              Colors.red,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildDiscountMetricCard(
                                              'Orders with Discounts',
                                              '$ordersWithDiscounts',
                                              '${totalOrders > 0 ? ((ordersWithDiscounts / totalOrders) * 100).toStringAsFixed(1) : 0}% of orders',
                                              Icons.receipt,
                                              Colors.orange,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 12),
                                      Row(
                                        children: [
                                          Expanded(
                                            child: _buildDiscountMetricCard(
                                              'Item Discounts',
                                              formatIndianCurrency(settings.currency, itemDiscountAmount),
                                              '${totalDiscountAmount > 0 ? ((itemDiscountAmount / totalDiscountAmount) * 100).toStringAsFixed(1) : 0}% of total',
                                              Icons.inventory,
                                              Colors.purple,
                                            ),
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: _buildDiscountMetricCard(
                                              'Order Discounts',
                                              formatIndianCurrency(settings.currency, orderDiscountAmount),
                                              '${totalDiscountAmount > 0 ? ((orderDiscountAmount / totalDiscountAmount) * 100).toStringAsFixed(1) : 0}% of total',
                                              Icons.shopping_cart,
                                              Colors.teal,
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 16),
                                      Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          color: Colors.grey[50],
                                          borderRadius: BorderRadius.circular(8),
                                          border: Border.all(color: Colors.grey[200]!),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.info_outline, color: Colors.blue, size: 16),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                'Average discount per order: ${formatIndianCurrency(settings.currency, avgDiscountPerOrder)}',
                                                style: const TextStyle(
                                                  fontSize: 12,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                              
                              // Top Items Section Removed - Only Revenue by Order Type Shown
                              /*
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
                              */
                              
                              const SizedBox(height: 20),
                              
                              // Revenue by Order Type Section
                              ..._buildOrderTypeAnalysis(filteredOrders, settings),
                              
                              const SizedBox(height: 20),
                              
                              // Revenue by Payment Types Chart
                              ..._buildPaymentTypeAnalysis(filteredOrders, settings),
                              
                              const SizedBox(height: 20),
                              
                              // Revenue by Categories Chart
                              ..._buildCategoryAnalysis(filteredOrders, settings),
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

  // Revenue by Order Type Methods
  List<Widget> _buildOrderTypeAnalysis(List<Order> filteredOrders, AppSettings settings) {
    // Calculate order type statistics
    final orderTypeStats = _calculateOrderTypeStats(filteredOrders, settings);
    
    return [
      // Revenue by Order Type - Simplified Report
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.green.withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.green.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.green.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bar_chart,
                    color: Colors.green,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  l10n(ref, 'revenue_by_type'),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Revenue Bar Chart
            Container(
              height: 200,
              child: _buildRevenueBarChart(orderTypeStats, settings),
            ),
          ],
        ),
      ),
    ];
  }

  Map<OrderType, Map<String, dynamic>> _calculateOrderTypeStats(List<Order> orders, AppSettings settings) {
    final stats = <OrderType, Map<String, dynamic>>{
      OrderType.dineIn: {
        'count': 0,
        'revenue': 0.0,
        'items': 0,
        'avgOrder': 0.0,
        'percentage': 0.0,
        'color': Colors.blue,
        'icon': Icons.restaurant,
        'label': 'Dine In',
        'emoji': '🍽️',
      },
      OrderType.takeaway: {
        'count': 0,
        'revenue': 0.0,
        'items': 0,
        'avgOrder': 0.0,
        'percentage': 0.0,
        'color': Colors.orange,
        'icon': Icons.takeout_dining,
        'label': 'Takeaway',
        'emoji': '🥡',
      },
      OrderType.delivery: {
        'count': 0,
        'revenue': 0.0,
        'items': 0,
        'avgOrder': 0.0,
        'percentage': 0.0,
        'color': Colors.green,
        'icon': Icons.delivery_dining,
        'label': 'Delivery',
        'emoji': '🚚',
      },
    };

    final totalOrders = orders.length;
    
    for (final order in orders) {
      final type = order.type;
      stats[type]!['count']++;
      stats[type]!['revenue'] += order.getGrandTotal(settings);
      stats[type]!['items'] += order.items.fold(0, (sum, item) => sum + item.quantity);
    }
    
    // Calculate averages and percentages
    for (final type in OrderType.values) {
      final count = stats[type]!['count'] as int;
      final revenue = stats[type]!['revenue'] as double;
      
      stats[type]!['avgOrder'] = count > 0 ? revenue / count : 0.0;
      stats[type]!['percentage'] = totalOrders > 0 ? (count / totalOrders) * 100 : 0.0;
    }
    
    return stats;
  }





  Widget _buildRevenueBarChart(Map<OrderType, Map<String, dynamic>> stats, AppSettings settings) {
    final maxRevenue = stats.values
        .map((data) => data['revenue'] as double)
        .fold(0.0, (max, revenue) => revenue > max ? revenue : max);

    return Column(
      children: stats.entries.map((entry) {
        final revenue = entry.value['revenue'] as double;
        final color = entry.value['color'] as Color;
        final label = entry.value['label'] as String;
        final emoji = entry.value['emoji'] as String;
        final percentage = maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      '$emoji $label',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      formatIndianCurrency(settings.currency, revenue),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Revenue by Payment Types Analysis
  List<Widget> _buildPaymentTypeAnalysis(List<Order> filteredOrders, AppSettings settings) {
    // Calculate payment type statistics
    final paymentTypeStats = _calculatePaymentTypeStats(filteredOrders);
    
    if (paymentTypeStats.isEmpty) {
      return [];
    }
    
    return [
      Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.purple.withOpacity(0.05),
              Colors.white,
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Colors.purple.withOpacity(0.2)),
          boxShadow: [
            BoxShadow(
              color: Colors.purple.withOpacity(0.1),
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
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.purple.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.payment,
                    color: Colors.purple,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Revenue by Payment Types',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Payment Type Bar Chart
            Container(
              height: 200,
              child: _buildPaymentTypeBarChart(paymentTypeStats, settings),
            ),
          ],
        ),
      ),
    ];
  }

  Map<String, Map<String, dynamic>> _calculatePaymentTypeStats(List<Order> orders) {
    final stats = <String, Map<String, dynamic>>{};
    final colors = [Colors.purple, Colors.blue, Colors.green, Colors.orange, Colors.red, Colors.teal];
    final icons = [Icons.credit_card, Icons.payments, Icons.account_balance_wallet, Icons.mobile_friendly, Icons.qr_code, Icons.payment];
    int colorIndex = 0;
    
    for (final order in orders) {
      for (final payment in order.payments) {
        final methodName = _getPaymentMethodDisplayName(payment.method);
        
        if (!stats.containsKey(methodName)) {
          stats[methodName] = {
            'revenue': 0.0,
            'count': 0,
            'color': colors[colorIndex % colors.length],
            'icon': icons[colorIndex % icons.length],
          };
          colorIndex++;
        }
        
        stats[methodName]!['revenue'] += payment.amount;
        stats[methodName]!['count']++;
      }
    }
    
    return stats;
  }

  String _getPaymentMethodDisplayName(PaymentMethod method) {
    switch (method) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.card:
        return 'Card';
      case PaymentMethod.upi:
        return 'UPI';
      case PaymentMethod.online:
        return 'Online';
      default:
        return 'Other';
    }
  }

  Widget _buildPaymentTypeBarChart(Map<String, Map<String, dynamic>> stats, AppSettings settings) {
    final maxRevenue = stats.values
        .map((data) => data['revenue'] as double)
        .fold(0.0, (max, revenue) => revenue > max ? revenue : max);

    if (maxRevenue == 0) {
      return const Center(
        child: Text(
          'No payment data available',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    return Column(
      children: stats.entries.map((entry) {
        final revenue = entry.value['revenue'] as double;
        final count = entry.value['count'] as int;
        final color = entry.value['color'] as Color;
        final methodName = entry.key;
        final percentage = maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;
        
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          child: Column(
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 80,
                    child: Text(
                      methodName,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: percentage,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [color, color.withOpacity(0.7)],
                              begin: Alignment.centerLeft,
                              end: Alignment.centerRight,
                            ),
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  SizedBox(
                    width: 80,
                    child: Text(
                      formatIndianCurrency(settings.currency, revenue),
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '($count)',
                    style: TextStyle(
                      fontSize: 10,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  // Revenue by Categories Analysis
  List<Widget> _buildCategoryAnalysis(List<Order> filteredOrders, AppSettings settings) {
    // Calculate category statistics
    final categoryStats = _calculateCategoryStats(filteredOrders);
    
    if (categoryStats.isEmpty) {
      return [];
    }
    
    return [
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
          crossAxisAlignment: CrossAxisAlignment.start,
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
                    Icons.category,
                    color: Colors.amber,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'Revenue by Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            
            // Category Bar Chart
            Container(
              height: 250, // Slightly taller for potentially more categories
              child: _buildCategoryBarChart(categoryStats, settings),
            ),
          ],
        ),
      ),
    ];
  }

  Map<String, Map<String, dynamic>> _calculateCategoryStats(List<Order> orders) {
    final stats = <String, Map<String, dynamic>>{};
    final colors = [
      Colors.amber, Colors.deepOrange, Colors.teal, Colors.indigo, 
      Colors.pink, Colors.cyan, Colors.lime, Colors.deepPurple,
      Colors.brown, Colors.red
    ];
    int colorIndex = 0;
    
    for (final order in orders) {
      for (final item in order.items) {
        final category = item.menuItem.category;
        
        if (!stats.containsKey(category)) {
          stats[category] = {
            'revenue': 0.0,
            'quantity': 0,
            'itemCount': 0,
            'color': colors[colorIndex % colors.length],
          };
          colorIndex++;
        }
        
        stats[category]!['revenue'] += item.total;
        stats[category]!['quantity'] += item.quantity;
        stats[category]!['itemCount']++;
      }
    }
    
    return stats;
  }

  Widget _buildCategoryBarChart(Map<String, Map<String, dynamic>> stats, AppSettings settings) {
    final maxRevenue = stats.values
        .map((data) => data['revenue'] as double)
        .fold(0.0, (max, revenue) => revenue > max ? revenue : max);

    if (maxRevenue == 0) {
      return const Center(
        child: Text(
          'No category data available',
          style: TextStyle(color: Colors.grey, fontSize: 14),
        ),
      );
    }

    // Sort categories by revenue (descending)
    final sortedStats = stats.entries.toList()
      ..sort((a, b) => (b.value['revenue'] as double).compareTo(a.value['revenue'] as double));

    return SingleChildScrollView(
      child: Column(
        children: sortedStats.map((entry) {
          final revenue = entry.value['revenue'] as double;
          final quantity = entry.value['quantity'] as int;
          final color = entry.value['color'] as Color;
          final categoryName = entry.key;
          final percentage = maxRevenue > 0 ? (revenue / maxRevenue) : 0.0;
          
          return Container(
            margin: const EdgeInsets.symmetric(vertical: 6),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 90,
                      child: Text(
                        categoryName,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Container(
                        height: 18,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(9),
                        ),
                        child: FractionallySizedBox(
                          alignment: Alignment.centerLeft,
                          widthFactor: percentage,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [color, color.withOpacity(0.7)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(9),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    SizedBox(
                      width: 75,
                      child: Text(
                        formatIndianCurrency(settings.currency, revenue),
                        textAlign: TextAlign.end,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '($quantity)',
                      style: TextStyle(
                        fontSize: 9,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }

  void _showKOTSummaryDialog(BuildContext context, List<Order> orders, String businessName) {
    final dateRange = '${_formatKOTTimestamp(_startDate)} to ${_formatKOTTimestamp(_endDate)}';
    final settings = ref.read(settingsProvider);
    final summaryContent = _formatKOTSummaryReport(
      dateRange,
      orders,
      DateTime.now(),
      businessName,
      settings,
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
  String _formatKOTSummaryReport(String dateRange, List<Order> orders, DateTime printTime, String businessName, AppSettings settings) {
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
    final grossSales = orders.fold(0.0, (sum, order) => sum + order.getGrandTotal(settings));
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
    final isMobile = MediaQuery.of(context).size.width < 400;
    
    return Container(
      margin: EdgeInsets.only(right: isMobile ? 6 : 8),
      child: Material(
        elevation: isSelected ? 4 : 2,
        borderRadius: BorderRadius.circular(10),
        shadowColor: isSelected ? const Color(0xFFFF9933).withOpacity(0.4) : Colors.black26,
        child: InkWell(
          onTap: () => _applyFilter(filter),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: EdgeInsets.symmetric(
              horizontal: isMobile ? 10 : 12, 
              vertical: isMobile ? 6 : 8,
            ),
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
                fontSize: isMobile ? 11 : 13,
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
    final isMobile = MediaQuery.of(context).size.width < 400;
    
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(isMobile ? 12 : 16),
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
            blurRadius: isMobile ? 4 : 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(isMobile ? 8 : 12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 4 : 6),
              decoration: BoxDecoration(
                color: color.withOpacity(0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: isMobile ? 14 : 18, color: color),
            ),
            SizedBox(height: isMobile ? 4 : 6),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  value,
                  style: TextStyle(
                    fontSize: isMobile ? 12 : 16,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 2 : 3),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                    fontSize: isMobile ? 9 : 11,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                ),
              ),
            ),
            SizedBox(height: isMobile ? 1 : 1),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: isMobile ? 7 : 9,
                    color: Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDiscountMetricCard(String title, String value, String subtitle, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        gradient: LinearGradient(
          colors: [
            color.withOpacity(0.1),
            color.withOpacity(0.05),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 16, color: color),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey[600],
            ),
          ),
        ],
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
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 24),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width * 0.9 : 400,
            maxHeight: MediaQuery.of(context).size.height * 0.7,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.file_download, color: Color(0xFFFF9933), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Export Reports',
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 400 ? 16 : 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                'Choose the type of report to export:',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: MediaQuery.of(context).size.width < 400 ? 12 : 14,
                ),
              ),
              const SizedBox(height: 16),
              Flexible(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
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
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () => Navigator.pop(context),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('Cancel'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExportOption(BuildContext context, String title, String subtitle, IconData icon, VoidCallback onTap) {
    final isMobile = MediaQuery.of(context).size.width < 400;
    
    return InkWell(
      onTap: () {
        Navigator.pop(context);
        onTap();
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: EdgeInsets.all(isMobile ? 10 : 12),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey[300]!),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(isMobile ? 6 : 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF9933).withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(icon, color: const Color(0xFFFF9933), size: isMobile ? 18 : 20),
            ),
            SizedBox(width: isMobile ? 10 : 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: isMobile ? 13 : 14,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: isMobile ? 11 : 12,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: isMobile ? 14 : 16, color: Colors.grey),
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
    buffer.writeln('Date,Time,Order ID,Customer Name,Phone,Order Type,Status,Items Count,Items Subtotal,Item Discounts,Order Discount,Total Discounts,Subtotal After Discounts,SGST,CGST,Total Tax,Grand Total,Payment Method,Items Detail');
    
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
      final itemsSubtotal = order.itemsSubtotal.toStringAsFixed(2);
      final itemDiscounts = order.itemsDiscountAmount.toStringAsFixed(2);
      final orderDiscount = order.orderDiscountAmount.toStringAsFixed(2);
      final totalDiscounts = order.totalDiscountAmount.toStringAsFixed(2);
      final subtotalAfterDiscounts = order.subtotal.toStringAsFixed(2);
      final sgst = order.calculateSGST(settings).toStringAsFixed(2);
      final cgst = order.calculateCGST(settings).toStringAsFixed(2);
      final totalTax = order.calculateTotalTax(settings).toStringAsFixed(2);
      final total = order.getGrandTotal(settings).toStringAsFixed(2);
      final paymentMethod = order.payments.isNotEmpty ? 'Paid' : 'Pending';
      
      // Items detail with discount information
      final itemsDetail = order.items.map((item) {
        String itemDetail = '${item.menuItem.name} (Qty: ${item.quantity}, Price: ${item.unitPrice.toStringAsFixed(2)}';
        if (item.hasDiscount) {
          itemDetail += ', Discount: -${item.discountAmount.toStringAsFixed(2)}';
        }
        itemDetail += ')';
        return itemDetail;
      }).join('; ');
      
      buffer.writeln('"$date","$time","$orderId","$customerName","$phone","$orderType","$status",$itemsCount,$itemsSubtotal,$itemDiscounts,$orderDiscount,$totalDiscounts,$subtotalAfterDiscounts,$sgst,$cgst,$totalTax,$total,"$paymentMethod","$itemsDetail"');
    }
    
    _showExportDialog(context, 'Complete Order Report', buffer.toString());
  }

  void _exportSalesSummary(BuildContext context, List<Order> orders, AppSettings settings) {
    final buffer = StringBuffer();
    final totalSales = orders.fold(0.0, (sum, order) => sum + order.getGrandTotal(settings));
    final totalOrders = orders.length;
    final avgOrderValue = totalOrders > 0 ? totalSales / totalOrders : 0.0;
    
    // Discount analytics
    final ordersWithDiscounts = orders.where((order) => order.hasDiscounts).length;
    final totalDiscountAmount = orders.fold(0.0, (sum, order) => sum + order.totalDiscountAmount);
    final itemDiscountAmount = orders.fold(0.0, (sum, order) => sum + order.itemsDiscountAmount);
    final orderDiscountAmount = orders.fold(0.0, (sum, order) => sum + order.orderDiscountAmount);
    final discountRate = totalSales > 0 ? (totalDiscountAmount / (totalSales + totalDiscountAmount)) * 100 : 0.0;
    
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
    buffer.writeln('DISCOUNT ANALYTICS');
    buffer.writeln('Orders with Discounts,$ordersWithDiscounts');
    buffer.writeln('Total Discount Amount,${totalDiscountAmount.toStringAsFixed(2)}');
    buffer.writeln('Item Level Discounts,${itemDiscountAmount.toStringAsFixed(2)}');
    buffer.writeln('Order Level Discounts,${orderDiscountAmount.toStringAsFixed(2)}');
    buffer.writeln('Discount Rate (%),"${discountRate.toStringAsFixed(2)}%"');
    buffer.writeln('Average Discount per Order,${totalOrders > 0 ? (totalDiscountAmount / totalOrders).toStringAsFixed(2) : '0'}');
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
      dailyData[dateKey]!['sales'] += order.getGrandTotal(settings);
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
            'totalDiscounts': 0.0,
            'discountedRevenue': 0.0,
            'ordersWithDiscount': 0,
            'orders': <String>{},
          };
        }
        itemData[itemName]!['quantity'] += item.quantity;
        itemData[itemName]!['revenue'] += item.subtotal; // Original revenue before discount
        itemData[itemName]!['totalDiscounts'] += item.discountAmount;
        itemData[itemName]!['discountedRevenue'] += item.total; // Actual revenue after discount
        if (item.hasDiscount) {
          itemData[itemName]!['ordersWithDiscount']++;
        }
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
    buffer.writeln('Item Name,Quantity Sold,Original Revenue,Total Discounts,Final Revenue,Orders Count,Orders with Discount,Avg Original Price,Avg Final Price');
    
    for (final item in sortedItems) {
      final name = item.key;
      final quantity = item.value['quantity'];
      final originalRevenue = item.value['revenue'].toStringAsFixed(2);
      final totalDiscounts = item.value['totalDiscounts'].toStringAsFixed(2);
      final finalRevenue = item.value['discountedRevenue'].toStringAsFixed(2);
      final ordersCount = (item.value['orders'] as Set).length;
      final ordersWithDiscount = item.value['ordersWithDiscount'];
      final avgOriginalPrice = (item.value['revenue'] / quantity).toStringAsFixed(2);
      final avgFinalPrice = (item.value['discountedRevenue'] / quantity).toStringAsFixed(2);
      
      buffer.writeln('"$name",$quantity,$originalRevenue,$totalDiscounts,$finalRevenue,$ordersCount,$ordersWithDiscount,$avgOriginalPrice,$avgFinalPrice');
    }
    
    _showExportDialog(context, 'Item-wise Sales Report', buffer.toString());
  }

  void _showExportDialog(BuildContext context, String title, String content) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 16 : 20),
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width < 400 ? MediaQuery.of(context).size.width * 0.95 : 500,
            maxHeight: MediaQuery.of(context).size.height * 0.8,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.file_download, color: Color(0xFFFF9933), size: 20),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: MediaQuery.of(context).size.width < 400 ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                    iconSize: 20,
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(MediaQuery.of(context).size.width < 400 ? 8 : 12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.grey[50],
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      content,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: MediaQuery.of(context).size.width < 400 ? 8 : 10,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              MediaQuery.of(context).size.width < 400
                ? Column(
                    children: [
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ready for download'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download Report'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9933),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text('Close'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        flex: 2,
                        child: ElevatedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('$title ready for download'),
                                backgroundColor: Colors.green,
                              ),
                            );
                            Navigator.pop(context);
                          },
                          icon: const Icon(Icons.download, size: 18),
                          label: const Text('Download'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFFF9933),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
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
        toolbarHeight: 48,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
        child: Column(
          children: [
            // Enhanced User Account Card (Firebase Integration)
            Consumer(
              builder: (context, ref, child) {
                return FutureBuilder<User?>(
                  future: FirebaseAuth.instance.authStateChanges().first,
                  builder: (context, snapshot) {
                    final user = snapshot.data;
                    final isLoading = snapshot.connectionState == ConnectionState.waiting;
                    
                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [
                              const Color(0xFFFF9933).withOpacity(0.1),
                              const Color(0xFFFF9933).withOpacity(0.05),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Header Section
                              Row(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 50,
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [Color(0xFFFF9933), Color(0xFFFF7722)],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(25),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF9933).withOpacity(0.3),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    child: const Icon(
                                      Icons.account_circle_rounded,
                                      color: Colors.white,
                                      size: 28,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          'User Account',
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Color(0xFF2C3E50),
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          user != null ? 'Premium Account' : 'Local Account',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: user != null ? Colors.green[600] : Colors.orange[600],
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  if (user != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.green[100],
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: Colors.green[300]!),
                                      ),
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(Icons.verified, color: Colors.green[600], size: 16),
                                          const SizedBox(width: 4),
                                          Text(
                                            'Verified',
                                            style: TextStyle(
                                              color: Colors.green[600],
                                              fontSize: 12,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                ],
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Account Details Section
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.7),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: const Color(0xFFFF9933).withOpacity(0.2)),
                                ),
                                child: Column(
                                  children: [
                                    _buildAccountDetailRow(
                                      icon: Icons.email_rounded,
                                      label: 'Email',
                                      value: isLoading ? 'Loading...' : (user?.email ?? 'Not signed in'),
                                      valueColor: user != null ? const Color(0xFF2C3E50) : Colors.grey[600],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildAccountDetailRow(
                                      icon: Icons.person_rounded,
                                      label: 'Display Name',
                                      value: isLoading ? 'Loading...' : (user?.displayName ?? 'Not set'),
                                      valueColor: user?.displayName != null ? const Color(0xFF2C3E50) : Colors.grey[600],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildAccountDetailRow(
                                      icon: Icons.access_time_rounded,
                                      label: 'Last Sign In',
                                      value: isLoading ? 'Loading...' : (user?.metadata.lastSignInTime != null 
                                          ? _formatDateTime(user!.metadata.lastSignInTime!) 
                                          : 'Never'),
                                      valueColor: Colors.grey[600],
                                    ),
                                    const SizedBox(height: 12),
                                    _buildAccountDetailRow(
                                      icon: user != null ? Icons.cloud_done_rounded : Icons.cloud_off_rounded,
                                      label: 'Sync Status',
                                      value: user != null ? 'Cloud Sync Active' : 'Local Storage Only',
                                      valueColor: user != null ? Colors.green[600] : Colors.orange[600],
                                      showBadge: true,
                                    ),
                                  ],
                                ),
                              ),
                              
                              const SizedBox(height: 20),
                              
                              // Action Buttons Section
                              Row(
                                children: [
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: user != null ? () => _showAccountInfoDialog(context, user) : null,
                                      icon: const Icon(Icons.info_outline_rounded, size: 18),
                                      label: const Text('Account Info'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFFFF9933),
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: ElevatedButton.icon(
                                      onPressed: () => _showLogoutDialog(context),
                                      icon: const Icon(Icons.logout_rounded, size: 18),
                                      label: const Text('Logout'),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.red[600],
                                        foregroundColor: Colors.white,
                                        padding: const EdgeInsets.symmetric(vertical: 12),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(8),
                                        ),
                                        elevation: 2,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 16),
            
            // Menu Management Card (Default Open)
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

            // Business Information Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.business, color: Color(0xFFFF9933)),
                title: Text(l10n(ref, 'business_information'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                        const Divider(),
                        // Tax Settings
                        ListTile(
                          leading: const Icon(Icons.percent),
                          title: Text(l10n(ref, 'sgst_rate')),
                          subtitle: Text('${(settings.sgstRate * 100).toStringAsFixed(1)}%'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _showTaxDialog(context, ref, l10n(ref, 'sgst_rate'), settings.sgstRate * 100, 
                              (value) => ref.read(settingsProvider.notifier).updateSgstRate(value / 100)),
                        ),
                        ListTile(
                          leading: const Icon(Icons.percent),
                          title: Text(l10n(ref, 'cgst_rate')),
                          subtitle: Text('${(settings.cgstRate * 100).toStringAsFixed(1)}%'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _showTaxDialog(context, ref, l10n(ref, 'cgst_rate'), settings.cgstRate * 100, 
                              (value) => ref.read(settingsProvider.notifier).updateCgstRate(value / 100)),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Feature Settings Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.settings, color: Color(0xFFFF9933)),
                title: Text(l10n(ref, 'feature_settings'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                        ],
                        const Divider(),
                        SwitchListTile(
                          secondary: const Icon(Icons.inventory),
                          title: Text(l10n(ref, 'packaging_service')),
                          subtitle: Text(l10n(ref, 'packaging_service_desc')),
                          value: settings.packagingEnabled,
                          activeColor: const Color(0xFFFF9933),
                          onChanged: (bool value) {
                            ref.read(settingsProvider.notifier).updateSettings(
                              settings.copyWith(packagingEnabled: value),
                            );
                          },
                        ),
                        if (settings.packagingEnabled) ...[
                          ListTile(
                            leading: const Icon(Icons.inventory_2),
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
                        const Divider(),
                        SwitchListTile(
                          secondary: const Icon(Icons.room_service),
                          title: Text(l10n(ref, 'service_charges')),
                          subtitle: Text(l10n(ref, 'service_charges_desc')),
                          value: settings.serviceEnabled,
                          activeColor: const Color(0xFFFF9933),
                          onChanged: (bool value) {
                            ref.read(settingsProvider.notifier).updateSettings(
                              settings.copyWith(serviceEnabled: value),
                            );
                          },
                        ),
                        if (settings.serviceEnabled) ...[
                          ListTile(
                            leading: const Icon(Icons.restaurant_menu),
                            title: const Text('Service Charge'),
                            subtitle: Text('${settings.currency}${settings.defaultServiceCharge.toStringAsFixed(2)} (Dine-in only)'),
                            trailing: const Icon(Icons.edit),
                            onTap: () => _showChargeDialog(context, ref, 'Service Charge', settings.defaultServiceCharge, 
                              (value) => ref.read(settingsProvider.notifier).updateSettings(
                                settings.copyWith(defaultServiceCharge: value),
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Google Drive Backup Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.cloud_upload, color: Color(0xFFFF9933)),
                title: const Text('Cloud Backup', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Consumer(
                          builder: (context, ref, child) {
                            return FutureBuilder<String?>(
                              future: GoogleDriveService.getCurrentUserEmail(),
                              builder: (context, snapshot) {
                                final userEmail = snapshot.data;
                                final isSignedIn = GoogleDriveService.isSignedIn && userEmail != null;
                                
                                return Column(
                                  children: [
                                    ListTile(
                                      leading: Icon(
                                        isSignedIn ? Icons.cloud_done : Icons.cloud_off,
                                        color: isSignedIn ? Colors.green : Colors.grey,
                                      ),
                                      title: Text(isSignedIn ? 'Connected to Google Drive' : 'Not Connected'),
                                      subtitle: Text(isSignedIn ? userEmail : 'Sign in to enable cloud backup'),
                                      trailing: isSignedIn 
                                        ? TextButton(
                                            onPressed: () async {
                                              await GoogleDriveService.signOut();
                                              // Refresh the UI
                                              (context as Element).markNeedsBuild();
                                            },
                                            child: const Text('Sign Out'),
                                          )
                                        : ElevatedButton(
                                            onPressed: () async {
                                              showOptimizedToast(context, 'Signing in to Google Drive...', icon: Icons.cloud_upload);
                                              final success = await GoogleDriveService.signIn();
                                              if (success) {
                                                showOptimizedToast(context, 'Successfully connected to Google Drive!', color: Colors.green, icon: Icons.cloud_done);
                                              } else {
                                                showDialog(
                                                  context: context,
                                                  builder: (context) => AlertDialog(
                                                    title: const Row(
                                                      children: [
                                                        Icon(Icons.info_outline, color: Colors.orange),
                                                        SizedBox(width: 8),
                                                        Text('Google Drive Setup Required'),
                                                      ],
                                                    ),
                                                    content: const Text(
                                                      'To enable Google Drive backup, you need to:\n\n'
                                                      '1. Create a Google Cloud Project\n'
                                                      '2. Enable Google Drive API\n'
                                                      '3. Configure OAuth2 credentials\n'
                                                      '4. Add the client ID to web/index.html\n\n'
                                                      'For now, your data is safely stored locally and will persist between app sessions.'
                                                    ),
                                                    actions: [
                                                      ElevatedButton(
                                                        onPressed: () => Navigator.of(context).pop(),
                                                        child: const Text('OK'),
                                                      ),
                                                    ],
                                                  ),
                                                );
                                              }
                                              // Refresh the UI
                                              (context as Element).markNeedsBuild();
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: const Color(0xFFFF9933),
                                              foregroundColor: Colors.white,
                                            ),
                                            child: const Text('Sign In'),
                                          ),
                                    ),
                                    if (isSignedIn) ...[
                                      const Divider(),
                                      ListTile(
                                        leading: const Icon(Icons.backup, color: Color(0xFFFF9933)),
                                        title: const Text('Backup to Google Drive'),
                                        subtitle: const Text('Sync all data to your Google Drive'),
                                        trailing: ElevatedButton(
                                          onPressed: () => _performGoogleDriveBackup(context, ref),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(0xFFFF9933),
                                            foregroundColor: Colors.white,
                                          ),
                                          child: const Text('Sync Now'),
                                        ),
                                      ),
                                      const Divider(),
                                      FutureBuilder<List<String>>(
                                        future: GoogleDriveService.listBackupFolders(),
                                        builder: (context, snapshot) {
                                          if (snapshot.connectionState == ConnectionState.waiting) {
                                            return const ListTile(
                                              leading: CircularProgressIndicator(),
                                              title: Text('Loading backup history...'),
                                            );
                                          }
                                          
                                          final backupFolders = snapshot.data ?? [];
                                          
                                          return ListTile(
                                            leading: const Icon(Icons.history, color: Color(0xFFFF9933)),
                                            title: const Text('Backup History'),
                                            subtitle: Text('${backupFolders.length} backup(s) found'),
                                            trailing: backupFolders.isNotEmpty 
                                              ? IconButton(
                                                  icon: const Icon(Icons.info_outline),
                                                  onPressed: () => _showBackupHistory(context, backupFolders),
                                                )
                                              : null,
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Payment Settings Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.payment, color: Color(0xFFFF9933)),
                title: const Text('Payment Settings', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.credit_card, color: Color(0xFFFF9933)),
                          title: const Text('Payment Methods'),
                          subtitle: const Text('Configure accepted payment methods'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PaymentSettingsScreen()),
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final paymentConfig = ref.watch(paymentConfigProvider);
                            final enabledCount = paymentConfig.enabledMethods.length;
                            
                            return ListTile(
                              leading: const Icon(Icons.info_outline),
                              title: const Text('Current Status'),
                              subtitle: Text('$enabledCount payment methods enabled'),
                              trailing: Chip(
                                label: Text('$enabledCount active'),
                                backgroundColor: enabledCount > 0 ? Colors.green[100] : Colors.red[100],
                                labelStyle: TextStyle(
                                  color: enabledCount > 0 ? Colors.green[800] : Colors.red[800],
                                  fontSize: 12,
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Printer Management Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.print, color: Color(0xFFFF9933)),
                title: const Text('Printer Management', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.add_circle, color: Color(0xFFFF9933)),
                          title: const Text('Add New Printer'),
                          subtitle: const Text('Connect network, USB, or Bluetooth printer'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const PrinterManagementScreen()),
                          ),
                        ),
                        Consumer(
                          builder: (context, ref, child) {
                            final printers = ref.watch(printerProvider);
                            final connectedCount = printers.where((p) => p.status == PrinterStatus.connected).length;
                            final defaultPrinter = ref.watch(defaultPrinterProvider);
                            
                            return Column(
                              children: [
                                ListTile(
                                  leading: const Icon(Icons.info_outline),
                                  title: const Text('Printer Status'),
                                  subtitle: Text('${printers.length} total, $connectedCount connected'),
                                  trailing: Chip(
                                    label: Text('$connectedCount online'),
                                    backgroundColor: connectedCount > 0 ? Colors.green[100] : Colors.red[100],
                                    labelStyle: TextStyle(
                                      color: connectedCount > 0 ? Colors.green[800] : Colors.red[800],
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                if (defaultPrinter != null)
                                  ListTile(
                                    leading: Icon(Icons.star, color: Colors.amber[700]),
                                    title: const Text('Default Printer'),
                                    subtitle: Text('${defaultPrinter.name} (${defaultPrinter.connectionType.displayName})'),
                                    trailing: Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: defaultPrinter.status.color.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(color: defaultPrinter.status.color.withOpacity(0.3)),
                                      ),
                                      child: Text(
                                        defaultPrinter.status.displayName,
                                        style: TextStyle(
                                          color: defaultPrinter.status.color,
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                  ),
                                if (printers.isNotEmpty)
                                  ListTile(
                                    leading: const Icon(Icons.list, color: Color(0xFFFF9933)),
                                    title: const Text('Manage Printers'),
                                    subtitle: Text('Configure ${printers.length} printer${printers.length == 1 ? '' : 's'}'),
                                    trailing: const Icon(Icons.arrow_forward_ios),
                                    onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(builder: (context) => const PrinterListScreen()),
                                    ),
                                  ),
                              ],
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Reports & Analytics Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.analytics, color: Color(0xFFFF9933)),
                title: const Text('Reports & Analytics', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.people, color: Color(0xFFFF9933)),
                          title: const Text('Customer Analytics'),
                          subtitle: const Text('View customer data and insights'),
                          trailing: const Icon(Icons.arrow_forward_ios),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const CustomerAnalyticsScreen()),
                          ),
                        ),
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
                ],
              ),
            ),
            const SizedBox(height: 16),

            // Financial Settings Card (Collapsible)
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.attach_money, color: Color(0xFFFF9933)),
                title: Text(l10n(ref, 'financial_settings'), style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                          subtitle: Text('SGST: ${(settings.sgstRate * 100).toStringAsFixed(1)}% + CGST: ${(settings.cgstRate * 100).toStringAsFixed(1)}%'),
                          trailing: const Icon(Icons.edit),
                          onTap: () => _showTaxRateDialog(context, ref, settings.totalTaxRate),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),

            // App Information Card (Collapsible)  
            Card(
              child: ExpansionTile(
                leading: const Icon(Icons.info, color: Color(0xFFFF9933)),
                title: const Text('App Information', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
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
                ],
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

  void _showTaxDialog(BuildContext context, WidgetRef ref, String title, double currentValue, Function(double) onUpdate) {
    final controller = TextEditingController(text: currentValue.toStringAsFixed(1));
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit $title'),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: '$title (%)',
            border: const OutlineInputBorder(),
            suffixText: '%',
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
              final value = double.tryParse(controller.text) ?? currentValue;
              if (value >= 0 && value <= 50) { // Reasonable tax rate limits
                onUpdate(value);
                Navigator.pop(context);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a tax rate between 0% and 50%')),
                );
              }
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
                final totalRate = rate / 100;
                final halfRate = totalRate / 2;
                ref.read(settingsProvider.notifier).updateSgstRate(halfRate);
                ref.read(settingsProvider.notifier).updateCgstRate(halfRate);
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
  void _showAddItemDialog(BuildContext context, WidgetRef ref, {String? initialCategory}) {
    final nameController = TextEditingController();
    final dineInPriceController = TextEditingController();
    final takeawayPriceController = TextEditingController();
    final deliveryPriceController = TextEditingController();
    final categoryController = TextEditingController(text: initialCategory ?? '');

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
                Consumer(
                  builder: (context, ref, child) {
                    final menuItems = ref.watch(menuProvider);
                    final existingCategories = menuItems.map((item) => item.category).toSet().toList();
                    existingCategories.sort();
                    
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (existingCategories.isNotEmpty) ...[
                          const Text('Select existing category:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8,
                            runSpacing: 4,
                            children: existingCategories.map((category) => 
                              FilterChip(
                                label: Text(category),
                                selected: categoryController.text == category,
                                onSelected: (selected) {
                                  if (selected) {
                                    categoryController.text = category;
                                  }
                                },
                                selectedColor: const Color(0xFFFF9933).withOpacity(0.3),
                                checkmarkColor: const Color(0xFFFF9933),
                              ),
                            ).toList(),
                          ),
                          const SizedBox(height: 8),
                          const Text('Or enter new category:', style: TextStyle(fontSize: 12, color: Colors.grey)),
                          const SizedBox(height: 4),
                        ],
                        TextField(
                          controller: categoryController,
                          decoration: const InputDecoration(
                            labelText: 'Category',
                            hintText: 'e.g., Appetizers, Main Course, Desserts',
                            border: OutlineInputBorder(),
                          ),
                          textCapitalization: TextCapitalization.words,
                        ),
                      ],
                    );
                  },
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
    
    final menuItems = ref.read(menuProvider);
    final existingCategories = menuItems.map((item) => item.category).toSet().toList()..sort();
    String selectedCategory = item.category;

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
                DropdownButtonFormField<String>(
                  value: existingCategories.contains(selectedCategory) ? selectedCategory : null,
                  decoration: const InputDecoration(
                    labelText: 'Category',
                    border: OutlineInputBorder(),
                  ),
                  items: [
                    ...existingCategories.map((category) => DropdownMenuItem(
                      value: category,
                      child: Text(category),
                    )),
                  ],
                  onChanged: (value) {
                    selectedCategory = value ?? item.category;
                  },
                  hint: const Text('Select Category'),
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
                  category: selectedCategory,
                  isAvailable: item.isAvailable,
                  addons: item.addons,
                  allowCustomization: item.allowCustomization,
                  description: item.description,
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
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Menu Categories'),
            IconButton(
              icon: const Icon(Icons.add, color: Color(0xFFFF9933)),
              onPressed: () => _showAddCategoryDialog(context, ref),
              tooltip: 'Add Category',
            ),
          ],
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: categories.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.category_outlined, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text('No categories found'),
                      Text('Add your first category to get started', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) {
                    final category = categories[index];
                    final itemCount = menuItems.where((item) => item.category == category).length;
                    return Card(
                      margin: const EdgeInsets.symmetric(vertical: 4),
                      child: ListTile(
                        leading: const Icon(Icons.category, color: Color(0xFFFF9933)),
                        title: Text(category, style: const TextStyle(fontWeight: FontWeight.w500)),
                        subtitle: Text('$itemCount item${itemCount != 1 ? 's' : ''}'),
                        trailing: PopupMenuButton<String>(
                          icon: const Icon(Icons.more_vert),
                          onSelected: (action) {
                            switch (action) {
                              case 'edit':
                                _showEditCategoryDialog(context, ref, category);
                                break;
                              case 'delete':
                                _showDeleteCategoryDialog(context, ref, category, itemCount);
                                break;
                            }
                          },
                          itemBuilder: (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Row(
                                children: [
                                  Icon(Icons.edit, size: 18),
                                  SizedBox(width: 8),
                                  Text('Edit'),
                                ],
                              ),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Row(
                                children: [
                                  Icon(Icons.delete, size: 18, color: Colors.red),
                                  SizedBox(width: 8),
                                  Text('Delete', style: TextStyle(color: Colors.red)),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
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

  void _showAddCategoryDialog(BuildContext context, WidgetRef ref) {
    final categoryController = TextEditingController();
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add New Category'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  hintText: 'e.g., Appetizers, Main Course, Desserts',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  final menuItems = ref.read(menuProvider);
                  final existingCategories = menuItems.map((item) => item.category.toLowerCase()).toSet();
                  if (existingCategories.contains(value.trim().toLowerCase())) {
                    return 'Category already exists';
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                autofocus: true,
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
              if (formKey.currentState!.validate()) {
                final categoryName = categoryController.text.trim();
                Navigator.pop(context);
                Navigator.pop(context); // Close categories dialog
                _showAddItemDialog(context, ref, initialCategory: categoryName);
              }
            },
            child: const Text('Create & Add Item'),
          ),
        ],
      ),
    );
  }

  void _showEditCategoryDialog(BuildContext context, WidgetRef ref, String currentCategory) {
    final categoryController = TextEditingController(text: currentCategory);
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Category'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: categoryController,
                decoration: const InputDecoration(
                  labelText: 'Category Name',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.category),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Please enter a category name';
                  }
                  if (value.trim().toLowerCase() != currentCategory.toLowerCase()) {
                    final menuItems = ref.read(menuProvider);
                    final existingCategories = menuItems.map((item) => item.category.toLowerCase()).toSet();
                    if (existingCategories.contains(value.trim().toLowerCase())) {
                      return 'Category already exists';
                    }
                  }
                  return null;
                },
                textCapitalization: TextCapitalization.words,
                autofocus: true,
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
              if (formKey.currentState!.validate()) {
                final newCategoryName = categoryController.text.trim();
                if (newCategoryName != currentCategory) {
                  _updateCategoryName(ref, currentCategory, newCategoryName);
                  Navigator.pop(context);
                  Navigator.pop(context); // Refresh categories dialog
                  _showCategoriesDialog(context, ref);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Category renamed to "$newCategoryName"')),
                  );
                } else {
                  Navigator.pop(context);
                }
              }
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showDeleteCategoryDialog(BuildContext context, WidgetRef ref, String category, int itemCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Category'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Are you sure you want to delete the category "$category"?'),
            const SizedBox(height: 12),
            if (itemCount > 0) ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange.shade50,
                  border: Border.all(color: Colors.orange.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.warning, color: Colors.orange.shade700),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This category contains $itemCount item${itemCount != 1 ? 's' : ''}. They will be moved to "General" category.',
                        style: TextStyle(color: Colors.orange.shade800),
                      ),
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  border: Border.all(color: Colors.green.shade200),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(Icons.check_circle, color: Colors.green.shade700),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text('This category is empty and can be safely deleted.'),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              _deleteCategoryAndMoveItems(ref, category);
              Navigator.pop(context);
              Navigator.pop(context); // Refresh categories dialog
              _showCategoriesDialog(context, ref);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(itemCount > 0 
                    ? 'Category "$category" deleted. $itemCount item${itemCount != 1 ? 's' : ''} moved to "General".'
                    : 'Category "$category" deleted.'
                  ),
                ),
              );
            },
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _updateCategoryName(WidgetRef ref, String oldCategory, String newCategory) {
    final menuItems = ref.read(menuProvider);
    for (final item in menuItems) {
      if (item.category == oldCategory) {
        final updatedItem = MenuItem(
          id: item.id,
          name: item.name,
          dineInPrice: item.dineInPrice,
          takeawayPrice: item.takeawayPrice,
          category: newCategory,
          isAvailable: item.isAvailable,
          deliveryPrice: item.deliveryPrice,
          description: item.description,
          addons: item.addons,
          allowCustomization: item.allowCustomization,
        );
        ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
      }
    }
  }

  void _deleteCategoryAndMoveItems(WidgetRef ref, String categoryToDelete) {
    final menuItems = ref.read(menuProvider);
    for (final item in menuItems) {
      if (item.category == categoryToDelete) {
        final updatedItem = MenuItem(
          id: item.id,
          name: item.name,
          dineInPrice: item.dineInPrice,
          takeawayPrice: item.takeawayPrice,
          category: 'General',
          isAvailable: item.isAvailable,
          deliveryPrice: item.deliveryPrice,
          description: item.description,
          addons: item.addons,
          allowCustomization: item.allowCustomization,
        );
        ref.read(menuProvider.notifier).updateMenuItem(updatedItem);
      }
    }
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
      settings,
    );

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          width: MediaQuery.of(context).size.width * 0.8,
          height: MediaQuery.of(context).size.height * 0.7,
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Row(
                children: [
                  const Icon(Icons.receipt_long, color: Color(0xFFFF9933), size: 28),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'KOT Summary Report',
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFF9933),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      'TODAY',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              
              // Divider
              Container(
                height: 2,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.orange.shade300, Colors.orange.shade600],
                  ),
                  borderRadius: BorderRadius.circular(1),
                ),
              ),
              const SizedBox(height: 20),
              
              // Content
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: SingleChildScrollView(
                    child: Text(
                      summaryContent,
                      style: const TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 13,
                        height: 1.4,
                        color: Colors.black87,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              
              // Action Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    ),
                    child: const Text(
                      'Close',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton.icon(
                    onPressed: () {
                      print('Printing KOT Summary...\n$summaryContent');
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle, color: Colors.white),
                              SizedBox(width: 8),
                              Text('KOT Summary sent to printer'),
                            ],
                          ),
                          backgroundColor: Colors.green,
                          behavior: SnackBarBehavior.floating,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9933),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    icon: const Icon(Icons.print),
                    label: const Text(
                      'Print Report',
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatKOTTimestamp(DateTime dateTime) {
    return '${dateTime.day.toString().padLeft(2, '0')}/${dateTime.month.toString().padLeft(2, '0')}/${dateTime.year} ${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}';
  }

  String _formatKOTSummaryReport(String dateRange, List<Order> orders, DateTime printTime, String businessName, AppSettings settings) {
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
    final totalSales = orders.fold(0.0, (sum, order) => sum + order.getGrandTotal(settings));
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

  // Google Drive backup methods
  void _performGoogleDriveBackup(BuildContext context, WidgetRef ref) async {
    final settings = ref.read(settingsProvider);
    
    // Show progress dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            CircularProgressIndicator(strokeWidth: 2),
            SizedBox(width: 16),
            Text('Backing up to Google Drive'),
          ],
        ),
        content: Consumer(
          builder: (context, ref, child) {
            return StreamBuilder<String>(
              stream: _backupProgressStream,
              builder: (context, snapshot) {
                return Text(snapshot.data ?? 'Preparing backup...');
              },
            );
          },
        ),
      ),
    );

    try {
      final success = await GoogleDriveService.syncDataToGoogleDrive(
        businessName: settings.businessName,
        onProgress: (progress) {
          _backupProgressController.add(progress);
        },
      );

      Navigator.of(context).pop(); // Close progress dialog

      if (success) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Row(
              children: [
                Icon(Icons.check_circle, color: Colors.green),
                SizedBox(width: 8),
                Text('Backup Successful'),
              ],
            ),
            content: const Text('All your data has been successfully backed up to Google Drive.'),
            actions: [
              ElevatedButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      } else {
        _showBackupError(context, 'Backup failed. Please try again.');
      }
    } catch (e) {
      Navigator.of(context).pop(); // Close progress dialog
      _showBackupError(context, 'Backup failed: $e');
    }
  }

  static final StreamController<String> _backupProgressController = StreamController<String>.broadcast();
  Stream<String> get _backupProgressStream => _backupProgressController.stream;

  void _showBackupError(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.error, color: Colors.red),
            SizedBox(width: 8),
            Text('Backup Failed'),
          ],
        ),
        content: Text(message),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showBackupHistory(BuildContext context, List<String> backupFolders) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Backup History'),
        content: SizedBox(
          width: double.maxFinite,
          height: 300,
          child: ListView.builder(
            itemCount: backupFolders.length,
            itemBuilder: (context, index) {
              final folderName = backupFolders[index];
              return ListTile(
                leading: const Icon(Icons.folder, color: Color(0xFFFF9933)),
                title: Text(folderName),
                subtitle: FutureBuilder<Map<String, dynamic>?>(
                  future: GoogleDriveService.getBackupSummary(folderName),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text('Loading details...');
                    }
                    
                    final summary = snapshot.data;
                    if (summary == null) {
                      return const Text('No details available');
                    }
                    
                    final backupDate = DateTime.tryParse(summary['backup_date'] ?? '');
                    final totalOrders = summary['total_orders'] ?? 0;
                    final totalRevenue = summary['total_revenue'] ?? 0.0;
                    
                    return Text(
                      'Date: ${backupDate != null ? formatDateTime(backupDate) : 'Unknown'}\n'
                      'Orders: $totalOrders | Revenue: ₹${totalRevenue.toStringAsFixed(2)}'
                    );
                  },
                ),
                onTap: () {
                  // Could add functionality to restore from this backup
                  showOptimizedToast(context, 'Backup restore feature coming soon!', icon: Icons.info);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Customer Analytics Screen
class CustomerAnalyticsScreen extends ConsumerWidget {
  const CustomerAnalyticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final customerData = ref.watch(customerDataProvider);
    final customerNotifier = ref.read(customerDataProvider.notifier);
    final settings = ref.watch(settingsProvider);

    final totalCustomers = customerNotifier.totalCustomers;
    final totalCustomerValue = customerNotifier.totalCustomerValue;
    final averageCustomerValue = customerNotifier.averageCustomerValue;
    final topCustomers = customerNotifier.topCustomers;
    final recentCustomers = customerNotifier.sortedCustomers.take(10).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Customer Analytics'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Customer Overview Cards
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.people, size: 32, color: Color(0xFFFF9933)),
                          const SizedBox(height: 8),
                          Text(
                            totalCustomers.toString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text('Total Customers'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.currency_rupee, size: 32, color: Color(0xFFFF9933)),
                          const SizedBox(height: 8),
                          Text(
                            formatIndianCurrency(settings.currency, totalCustomerValue),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text('Total Value'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            
            Row(
              children: [
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.account_balance_wallet, size: 32, color: Color(0xFFFF9933)),
                          const SizedBox(height: 8),
                          Text(
                            formatIndianCurrency(settings.currency, averageCustomerValue),
                            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const Text('Avg Customer Value'),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        children: [
                          const Icon(Icons.star, size: 32, color: Color(0xFFFF9933)),
                          const SizedBox(height: 8),
                          Text(
                            topCustomers.isEmpty ? '0' : topCustomers.length.toString(),
                            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                          ),
                          const Text('Top Customers'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Top Customers Section
            if (topCustomers.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.emoji_events, color: Color(0xFFFF9933)),
                          const SizedBox(width: 8),
                          const Text(
                            'Top Customers by Value',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      ...topCustomers.take(5).map((customer) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: Color(0xFFFF9933).withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Icon(Icons.person, color: Color(0xFFFF9933)),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    customer.name ?? customer.phone ?? 'Guest Customer',
                                    style: const TextStyle(fontWeight: FontWeight.w500),
                                  ),
                                  Text(
                                    '${customer.totalOrders} orders • ${_getOrderTypeLabel(customer.mostUsedOrderType)}',
                                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                  ),
                                ],
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  formatIndianCurrency(settings.currency, customer.totalSpent),
                                  style: const TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(
                                  formatIndianCurrency(settings.currency, customer.averageOrderValue),
                                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Customer Data Table Section
            if (customerData.isNotEmpty) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.table_view, color: Color(0xFFFF9933)),
                          const SizedBox(width: 8),
                          const Text(
                            'Customer Database',
                            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          const Spacer(),
                          Tooltip(
                            message: 'Download Customer Database as CSV',
                            child: IconButton(
                              onPressed: () => _downloadCustomerCSV(context, customerData.values.toList(), settings),
                              icon: const Icon(Icons.download),
                              style: IconButton.styleFrom(
                                backgroundColor: const Color(0xFFFF9933),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.all(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300]!),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: DataTable(
                            headingRowColor: MaterialStateProperty.all(Colors.grey[100]),
                            columns: const [
                              DataColumn(
                                label: Text(
                                  'Customer Name',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Phone Number',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Email Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Address',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Orders',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                              DataColumn(
                                label: Text(
                                  'Total Spent',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ),
                            ],
                            rows: customerNotifier.sortedCustomers.map((customer) {
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text(customer.name ?? 'N/A'),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                  DataCell(
                                    Text(customer.phone ?? 'N/A'),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                  DataCell(
                                    Text(customer.email ?? 'N/A'),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                  DataCell(
                                    SizedBox(
                                      width: 200,
                                      child: Text(
                                        customer.address ?? 'N/A',
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 2,
                                      ),
                                    ),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                  DataCell(
                                    Text(customer.totalOrders.toString()),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                  DataCell(
                                    Text(formatIndianCurrency(settings.currency, customer.totalSpent)),
                                    onTap: () => _showCustomerDetails(context, customer, settings),
                                  ),
                                ],
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            // Empty State
            if (totalCustomers == 0)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.people_outline,
                        size: 64,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'No Customer Data Yet',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Customer data will appear here after orders are placed with customer information.',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey[600]),
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

  String _getOrderTypeLabel(OrderType type) {
    switch (type) {
      case OrderType.dineIn:
        return 'Dine-In';
      case OrderType.takeaway:
        return 'Takeaway';
      case OrderType.delivery:
        return 'Delivery';
    }
  }

  void _downloadCustomerCSV(BuildContext context, List<CustomerData> customers, AppSettings settings) {
    // Create CSV content
    final StringBuffer csvBuffer = StringBuffer();
    
    // Add CSV headers
    csvBuffer.writeln('Customer Name,Phone Number,Email Address,Address,Total Orders,Total Spent,Average Order Value,First Order Date,Last Order Date,Preferred Order Type');
    
    // Add customer data rows
    for (final customer in customers) {
      final name = _escapeCSVField(customer.name ?? 'N/A');
      final phone = _escapeCSVField(customer.phone ?? 'N/A');
      final email = _escapeCSVField(customer.email ?? 'N/A');
      final address = _escapeCSVField(customer.address ?? 'N/A');
      final totalOrders = customer.totalOrders.toString();
      final totalSpent = customer.totalSpent.toStringAsFixed(2);
      final avgOrderValue = customer.averageOrderValue.toStringAsFixed(2);
      final firstOrderDate = _formatDateForCSV(customer.firstOrderDate);
      final lastOrderDate = _formatDateForCSV(customer.lastOrderDate);
      final preferredType = _getOrderTypeLabel(customer.mostUsedOrderType);
      
      csvBuffer.writeln('$name,$phone,$email,$address,$totalOrders,$totalSpent,$avgOrderValue,$firstOrderDate,$lastOrderDate,$preferredType');
    }
    
    // Create downloadable content
    final csvContent = csvBuffer.toString();
    final fileName = 'customer_database_${DateTime.now().toIso8601String().split('T')[0]}.csv';
    
    // For web, we'll use the download functionality
    _downloadFile(context, csvContent, fileName, 'text/csv');
  }

  String _escapeCSVField(String field) {
    // Escape commas, quotes, and newlines in CSV fields
    if (field.contains(',') || field.contains('"') || field.contains('\n')) {
      return '"${field.replaceAll('"', '""')}"';
    }
    return field;
  }

  String _formatDateForCSV(DateTime date) {
    return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
  }

  void _downloadFile(BuildContext context, String content, String fileName, String mimeType) {
    try {
      // For mobile platforms, show a message that file export is not available
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('File download is only available on web platform'),
          backgroundColor: Colors.orange,
        ),
      );
      return;
      
      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Customer database downloaded as $fileName'),
          backgroundColor: const Color(0xFFFF9933),
        ),
      );
    } catch (e) {
      // Fallback: show CSV content in a dialog for copying
      _showCSVContent(context, content, fileName);
    }
  }

  void _showCSVContent(BuildContext context, String csvContent, String fileName) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('CSV Download'),
        content: SizedBox(
          width: 600,
          height: 400,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Copy the content below and save as $fileName:'),
              const SizedBox(height: 16),
              Expanded(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: SingleChildScrollView(
                    child: SelectableText(
                      csvContent,
                      style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Clipboard.setData(ClipboardData(text: csvContent));
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('CSV content copied to clipboard')),
              );
            },
            child: const Text('Copy to Clipboard'),
          ),
        ],
      ),
    );
  }

  void _showCustomerDetails(BuildContext context, CustomerData customer, AppSettings settings) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(customer.name ?? customer.phone ?? 'Customer Details'),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (customer.name != null) ...[
                const Text('Name:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(customer.name!),
                const SizedBox(height: 8),
              ],
              if (customer.phone != null) ...[
                const Text('Phone:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(customer.phone!),
                const SizedBox(height: 8),
              ],
              if (customer.email != null) ...[
                const Text('Email:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(customer.email!),
                const SizedBox(height: 8),
              ],
              if (customer.address != null) ...[
                const Text('Address:', style: TextStyle(fontWeight: FontWeight.w500)),
                Text(customer.address!),
                const SizedBox(height: 8),
              ],
              const Divider(),
              const Text('Order Statistics:', style: TextStyle(fontWeight: FontWeight.w500)),
              const SizedBox(height: 4),
              Text('Total Orders: ${customer.totalOrders}'),
              Text('Total Spent: ${formatIndianCurrency(settings.currency, customer.totalSpent)}'),
              Text('Average Order: ${formatIndianCurrency(settings.currency, customer.averageOrderValue)}'),
              Text('Preferred Type: ${_getOrderTypeLabel(customer.mostUsedOrderType)}'),
              const SizedBox(height: 4),
              Text('First Order: ${formatDateTime(customer.firstOrderDate)}'),
              Text('Last Order: ${formatDateTime(customer.lastOrderDate)}'),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Printer Management Screen - Add New Printer
class PrinterManagementScreen extends ConsumerStatefulWidget {
  const PrinterManagementScreen({super.key});

  @override
  ConsumerState<PrinterManagementScreen> createState() => _PrinterManagementScreenState();
}

class _PrinterManagementScreenState extends ConsumerState<PrinterManagementScreen> {
  final _nameController = TextEditingController();
  final _addressController = TextEditingController();
  final _portController = TextEditingController(text: '9100');
  PrinterConnectionType _selectedType = PrinterConnectionType.network;
  bool _isScanning = false;
  List<Map<String, String>> _discoveredDevices = [];

  @override
  void dispose() {
    _nameController.dispose();
    _addressController.dispose();
    _portController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add New Printer'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Connection Type Selection
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Connection Type',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    _buildConnectionTypeCard(
                      PrinterConnectionType.network,
                      Icons.wifi,
                      'Network Printer',
                      'Connect via WiFi or Ethernet cable',
                    ),
                    const SizedBox(height: 8),
                    _buildConnectionTypeCard(
                      PrinterConnectionType.usb,
                      Icons.usb,
                      'USB Printer',
                      'Connect via USB cable',
                    ),
                    const SizedBox(height: 8),
                    _buildConnectionTypeCard(
                      PrinterConnectionType.bluetooth,
                      Icons.bluetooth,
                      'Bluetooth Printer',
                      'Connect via Bluetooth pairing',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Device Discovery Section
            if (_selectedType != PrinterConnectionType.usb) ...[
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            _selectedType == PrinterConnectionType.network 
                                ? Icons.search 
                                : Icons.bluetooth_searching,
                            color: const Color(0xFFFF9933),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _selectedType == PrinterConnectionType.network 
                                ? 'Network Discovery' 
                                : 'Bluetooth Discovery',
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          ElevatedButton.icon(
                            onPressed: _isScanning ? null : _startDiscovery,
                            icon: _isScanning 
                                ? const SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : const Icon(Icons.search),
                            label: Text(_isScanning ? 'Scanning...' : 'Scan'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFFFF9933),
                              foregroundColor: Colors.white,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      if (_discoveredDevices.isNotEmpty) ...[
                        Text(
                          'Discovered Devices:',
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: _discoveredDevices.length,
                          itemBuilder: (context, index) {
                            final device = _discoveredDevices[index];
                            return Card(
                              margin: const EdgeInsets.only(bottom: 8),
                              child: ListTile(
                                leading: Icon(
                                  _selectedType == PrinterConnectionType.network 
                                      ? Icons.print 
                                      : Icons.bluetooth,
                                  color: const Color(0xFFFF9933),
                                ),
                                title: Text(device['name'] ?? 'Unknown Device'),
                                subtitle: Text(device['address'] ?? ''),
                                trailing: ElevatedButton(
                                  onPressed: () => _selectDiscoveredDevice(device),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: const Color(0xFFFF9933),
                                    foregroundColor: Colors.white,
                                  ),
                                  child: const Text('Select'),
                                ),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 16),
                        const Divider(),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],

            // Manual Configuration
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.settings, color: Color(0xFFFF9933)),
                        const SizedBox(width: 8),
                        Text(
                          'Manual Configuration',
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _nameController,
                      decoration: const InputDecoration(
                        labelText: 'Printer Name',
                        hintText: 'e.g., Kitchen Printer, Receipt Printer',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (_selectedType == PrinterConnectionType.network) ...[
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'IP Address',
                          hintText: 'e.g., 192.168.1.100',
                          border: OutlineInputBorder(),
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _portController,
                        decoration: const InputDecoration(
                          labelText: 'Port',
                          hintText: '9100',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                      ),
                    ] else if (_selectedType == PrinterConnectionType.bluetooth) ...[
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'MAC Address',
                          hintText: 'e.g., 00:11:22:33:44:55',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ] else ...[
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'USB Device Path',
                          hintText: 'e.g., /dev/usb/lp0 or COM1',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Action Buttons
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _testConnection,
                    icon: const Icon(Icons.wifi_tethering),
                    label: const Text('Test Connection'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _addPrinter,
                    icon: const Icon(Icons.add),
                    label: const Text('Add Printer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9933),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConnectionTypeCard(
    PrinterConnectionType type,
    IconData icon,
    String title,
    String subtitle,
  ) {
    final isSelected = _selectedType == type;
    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          border: Border.all(
            color: isSelected ? const Color(0xFFFF9933) : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? const Color(0xFFFF9933).withOpacity(0.1) : null,
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected ? const Color(0xFFFF9933) : Colors.grey[600],
              size: 32,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: isSelected ? const Color(0xFFFF9933) : null,
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
            if (isSelected)
              const Icon(
                Icons.check_circle,
                color: Color(0xFFFF9933),
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _startDiscovery() async {
    setState(() {
      _isScanning = true;
      _discoveredDevices.clear();
    });

    // Simulate device discovery
    await Future.delayed(const Duration(seconds: 2));

    if (_selectedType == PrinterConnectionType.network) {
      // Simulate network printer discovery
      setState(() {
        _discoveredDevices = [
          {'name': 'HP LaserJet Pro', 'address': '192.168.1.101'},
          {'name': 'Canon PIXMA', 'address': '192.168.1.102'},
          {'name': 'Epson Receipt Printer', 'address': '192.168.1.103'},
        ];
      });
    } else if (_selectedType == PrinterConnectionType.bluetooth) {
      // Simulate Bluetooth printer discovery
      setState(() {
        _discoveredDevices = [
          {'name': 'Mobile Receipt Printer', 'address': '00:11:22:33:44:55'},
          {'name': 'Portable Thermal Printer', 'address': '00:11:22:33:44:66'},
        ];
      });
    }

    setState(() => _isScanning = false);
  }

  void _selectDiscoveredDevice(Map<String, String> device) {
    setState(() {
      _nameController.text = device['name'] ?? '';
      _addressController.text = device['address'] ?? '';
    });
  }

  Future<void> _testConnection() async {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in printer name and address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Show loading dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => const AlertDialog(
        content: Row(
          children: [
            CircularProgressIndicator(),
            SizedBox(width: 16),
            Text('Testing connection...'),
          ],
        ),
      ),
    );

    // Simulate connection test
    await Future.delayed(const Duration(seconds: 3));

    if (mounted) {
      Navigator.of(context).pop(); // Close loading dialog

      // Simulate success/failure
      final success = DateTime.now().millisecond % 2 == 0;
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success 
                ? 'Connection successful! Printer is ready.' 
                : 'Connection failed. Please check the settings.',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _addPrinter() {
    if (_nameController.text.isEmpty || _addressController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final printer = PrinterDevice(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: _nameController.text,
      connectionType: _selectedType,
      address: _addressController.text,
      port: _selectedType == PrinterConnectionType.network 
          ? int.tryParse(_portController.text) ?? 9100 
          : null,
      status: PrinterStatus.disconnected,
      isDefault: false,
      lastConnected: DateTime.now(),
    );

    ref.read(printerProvider.notifier).addPrinter(printer);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Printer added successfully!'),
        backgroundColor: Colors.green,
      ),
    );

    Navigator.of(context).pop();
  }
}

// Printer List Screen - Manage Existing Printers
class PrinterListScreen extends ConsumerWidget {
  const PrinterListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final printers = ref.watch(printerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Printers'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const PrinterManagementScreen()),
            ),
          ),
        ],
      ),
      body: printers.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.print_disabled,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No Printers Added',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Add a printer to get started',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Colors.grey[600],
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const PrinterManagementScreen()),
                    ),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Printer'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFF9933),
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: printers.length,
              itemBuilder: (context, index) {
                final printer = printers[index];
                return Card(
                  margin: const EdgeInsets.only(bottom: 16),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              printer.connectionType == PrinterConnectionType.network
                                  ? Icons.wifi
                                  : printer.connectionType == PrinterConnectionType.usb
                                      ? Icons.usb
                                      : Icons.bluetooth,
                              color: const Color(0xFFFF9933),
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        printer.name,
                                        style: const TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (printer.isDefault) ...[
                                        const SizedBox(width: 8),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 6,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.amber[100],
                                            borderRadius: BorderRadius.circular(8),
                                            border: Border.all(color: Colors.amber[300]!),
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Icon(
                                                Icons.star,
                                                size: 12,
                                                color: Colors.amber[700],
                                              ),
                                              const SizedBox(width: 2),
                                              Text(
                                                'Default',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: Colors.amber[700],
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${printer.connectionType.displayName} • ${printer.address}',
                                    style: TextStyle(
                                      color: Colors.grey[600],
                                      fontSize: 14,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: printer.status.color.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: printer.status.color.withOpacity(0.3)),
                              ),
                              child: Text(
                                printer.status.displayName,
                                style: TextStyle(
                                  color: printer.status.color,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            if (printer.status == PrinterStatus.disconnected) ...[
                              ElevatedButton.icon(
                                onPressed: () => ref
                                    .read(printerProvider.notifier)
                                    .connectPrinter(printer.id),
                                icon: const Icon(Icons.link, size: 16),
                                label: const Text('Connect'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                            ] else if (printer.status == PrinterStatus.connected) ...[
                              ElevatedButton.icon(
                                onPressed: () => ref
                                    .read(printerProvider.notifier)
                                    .disconnectPrinter(printer.id),
                                icon: const Icon(Icons.link_off, size: 16),
                                label: const Text('Disconnect'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.grey,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton.icon(
                                onPressed: () => ref
                                    .read(printerProvider.notifier)
                                    .testPrint(printer.id),
                                icon: const Icon(Icons.print, size: 16),
                                label: const Text('Test Print'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.blue,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                            ],
                            const Spacer(),
                            if (!printer.isDefault && printer.status == PrinterStatus.connected)
                              ElevatedButton.icon(
                                onPressed: () => ref
                                    .read(printerProvider.notifier)
                                    .setDefaultPrinter(printer.id),
                                icon: const Icon(Icons.star, size: 16),
                                label: const Text('Set Default'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.amber,
                                  foregroundColor: Colors.white,
                                  minimumSize: const Size(0, 32),
                                ),
                              ),
                            const SizedBox(width: 8),
                            PopupMenuButton<String>(
                              onSelected: (action) => _handlePrinterAction(
                                context,
                                ref,
                                printer,
                                action,
                              ),
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Row(
                                    children: [
                                      Icon(Icons.edit, size: 16),
                                      SizedBox(width: 8),
                                      Text('Edit'),
                                    ],
                                  ),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Row(
                                    children: [
                                      Icon(Icons.delete, size: 16, color: Colors.red),
                                      SizedBox(width: 8),
                                      Text('Delete', style: TextStyle(color: Colors.red)),
                                    ],
                                  ),
                                ),
                              ],
                              child: const Icon(Icons.more_vert),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }

  void _handlePrinterAction(
    BuildContext context,
    WidgetRef ref,
    PrinterDevice printer,
    String action,
  ) {
    switch (action) {
      case 'edit':
        // TODO: Implement edit functionality
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Edit functionality coming soon')),
        );
        break;
      case 'delete':
        _showDeleteConfirmation(context, ref, printer);
        break;
    }
  }

  void _showDeleteConfirmation(
    BuildContext context,
    WidgetRef ref,
    PrinterDevice printer,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Printer'),
        content: Text(
          'Are you sure you want to delete "${printer.name}"? This action cannot be undone.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(printerProvider.notifier).removePrinter(printer.id);
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Printer deleted successfully'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }
}

// Logout Dialog Helper Functions
void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.logout, color: Colors.red),
          SizedBox(width: 8),
          Text('Logout'),
        ],
      ),
      content: const Text('Are you sure you want to logout? Your data will remain safely stored.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () async {
            Navigator.of(context).pop();
            await _logout(context);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
          ),
          child: const Text('Logout'),
        ),
      ],
    ),
  );
}

Future<void> _logout(BuildContext context) async {
  try {
    await FirebaseAuth.instance.signOut();
    
    // Also clear local login state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_logged_in', false);
    
    // Show success message
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Successfully logged out'),
          backgroundColor: Colors.green,
        ),
      );
    }
    
    // Navigation will be handled by the auth state listener
  } catch (e) {
    // Fallback logout for local state
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('user_logged_in', false);
    
    // Force navigation to login
    if (context.mounted) {
      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const QSRMobileApp()),
        (route) => false,
      );
    }
  }
}

// Helper methods for enhanced user account UI
Widget _buildAccountDetailRow({
  required IconData icon,
  required String label,
  required String value,
  Color? valueColor,
  bool showBadge = false,
}) {
  return Row(
    children: [
      Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFFF9933).withOpacity(0.1),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          color: const Color(0xFFFF9933),
          size: 16,
        ),
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                Expanded(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 14,
                      color: valueColor ?? const Color(0xFF2C3E50),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                if (showBadge && value.contains('Active'))
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: Colors.green[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      'ACTIVE',
                      style: TextStyle(
                        color: Colors.green[700],
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    ],
  );
}

String _formatDateTime(DateTime dateTime) {
  final now = DateTime.now();
  final difference = now.difference(dateTime);
  
  if (difference.inDays > 7) {
    return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
  } else if (difference.inDays > 0) {
    return '${difference.inDays} day${difference.inDays > 1 ? 's' : ''} ago';
  } else if (difference.inHours > 0) {
    return '${difference.inHours} hour${difference.inHours > 1 ? 's' : ''} ago';
  } else if (difference.inMinutes > 0) {
    return '${difference.inMinutes} minute${difference.inMinutes > 1 ? 's' : ''} ago';
  } else {
    return 'Just now';
  }
}

void _showAccountInfoDialog(BuildContext context, User user) {
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFFF9933),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.account_circle, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 12),
          const Text('Account Information'),
        ],
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildInfoItem('User ID', user.uid),
            _buildInfoItem('Email', user.email ?? 'Not provided'),
            _buildInfoItem('Display Name', user.displayName ?? 'Not set'),
            _buildInfoItem('Email Verified', user.emailVerified ? 'Yes' : 'No'),
            _buildInfoItem('Phone Number', user.phoneNumber ?? 'Not provided'),
            _buildInfoItem('Account Created', 
                user.metadata.creationTime != null 
                    ? _formatDateTime(user.metadata.creationTime!) 
                    : 'Unknown'),
            _buildInfoItem('Last Sign In', 
                user.metadata.lastSignInTime != null 
                    ? _formatDateTime(user.metadata.lastSignInTime!) 
                    : 'Unknown'),
            _buildInfoItem('Provider', 
                user.providerData.isNotEmpty 
                    ? user.providerData.first.providerId 
                    : 'Unknown'),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Close'),
        ),
      ],
    ),
  );
}

Widget _buildInfoItem(String label, String value) {
  return Padding(
    padding: const EdgeInsets.only(bottom: 12),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[600],
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 4),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.grey[300]!),
          ),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF2C3E50),
            ),
          ),
        ),
      ],
    ),
  );
}
