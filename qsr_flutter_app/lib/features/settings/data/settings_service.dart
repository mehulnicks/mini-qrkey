import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _kotEnabledKey = 'kot_enabled';
  static const String _selectedPrinterKey = 'selected_printer';
  static const String _storeNameKey = 'store_name';
  static const String _serverNameKey = 'server_name';
  static const String _deviceIdKey = 'device_id';
  static const String _taxRateKey = 'tax_rate';
  static const String _currencySymbolKey = 'currency_symbol';

  static const bool _defaultKotEnabled = true;
  static const String _defaultStoreName = 'QSR Restaurant';
  static const String _defaultServerName = 'Server 1';
  static const double _defaultTaxRate = 0.0;
  static const String _defaultCurrencySymbol = '\$';

  SharedPreferences? _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    if (_prefs == null) {
      throw StateError('SettingsService not initialized. Call init() first.');
    }
    return _prefs!;
  }

  // KOT Feature Flag
  bool get kotEnabled => prefs.getBool(_kotEnabledKey) ?? _defaultKotEnabled;
  
  Future<void> setKotEnabled(bool enabled) async {
    await prefs.setBool(_kotEnabledKey, enabled);
  }

  // Printer Settings
  String? get selectedPrinter => prefs.getString(_selectedPrinterKey);
  
  Future<void> setSelectedPrinter(String? printer) async {
    if (printer == null) {
      await prefs.remove(_selectedPrinterKey);
    } else {
      await prefs.setString(_selectedPrinterKey, printer);
    }
  }

  // Store Information
  String get storeName => prefs.getString(_storeNameKey) ?? _defaultStoreName;
  
  Future<void> setStoreName(String name) async {
    await prefs.setString(_storeNameKey, name);
  }

  String get serverName => prefs.getString(_serverNameKey) ?? _defaultServerName;
  
  Future<void> setServerName(String name) async {
    await prefs.setString(_serverNameKey, name);
  }

  String get deviceId {
    String? id = prefs.getString(_deviceIdKey);
    if (id == null) {
      id = DateTime.now().millisecondsSinceEpoch.toString();
      prefs.setString(_deviceIdKey, id);
    }
    return id;
  }

  // Tax and Currency
  double get taxRate => prefs.getDouble(_taxRateKey) ?? _defaultTaxRate;
  
  Future<void> setTaxRate(double rate) async {
    await prefs.setDouble(_taxRateKey, rate);
  }

  String get currencySymbol => prefs.getString(_currencySymbolKey) ?? _defaultCurrencySymbol;
  
  Future<void> setCurrencySymbol(String symbol) async {
    await prefs.setString(_currencySymbolKey, symbol);
  }

  // Backup and Restore
  Future<Map<String, dynamic>> exportSettings() async {
    return {
      'kot_enabled': kotEnabled,
      'selected_printer': selectedPrinter,
      'store_name': storeName,
      'server_name': serverName,
      'tax_rate': taxRate,
      'currency_symbol': currencySymbol,
      'exported_at': DateTime.now().toIso8601String(),
    };
  }

  Future<void> importSettings(Map<String, dynamic> settings) async {
    if (settings.containsKey('kot_enabled')) {
      await setKotEnabled(settings['kot_enabled'] as bool);
    }
    if (settings.containsKey('selected_printer')) {
      await setSelectedPrinter(settings['selected_printer'] as String?);
    }
    if (settings.containsKey('store_name')) {
      await setStoreName(settings['store_name'] as String);
    }
    if (settings.containsKey('server_name')) {
      await setServerName(settings['server_name'] as String);
    }
    if (settings.containsKey('tax_rate')) {
      await setTaxRate(settings['tax_rate'] as double);
    }
    if (settings.containsKey('currency_symbol')) {
      await setCurrencySymbol(settings['currency_symbol'] as String);
    }
  }

  Future<String> exportSettingsAsJson() async {
    final settings = await exportSettings();
    return jsonEncode(settings);
  }

  Future<void> importSettingsFromJson(String json) async {
    final settings = jsonDecode(json) as Map<String, dynamic>;
    await importSettings(settings);
  }

  // Reset to defaults
  Future<void> resetToDefaults() async {
    await Future.wait([
      setKotEnabled(_defaultKotEnabled),
      setSelectedPrinter(null),
      setStoreName(_defaultStoreName),
      setServerName(_defaultServerName),
      setTaxRate(_defaultTaxRate),
      setCurrencySymbol(_defaultCurrencySymbol),
    ]);
  }
}
