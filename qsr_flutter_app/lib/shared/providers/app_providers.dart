import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/database/database.dart';
import '../features/settings/data/settings_service.dart';

// Database Provider
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

// Settings Service Provider
final settingsServiceProvider = Provider<SettingsService>((ref) {
  return SettingsService();
});

// Settings State Provider
final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>((ref) {
  final settingsService = ref.watch(settingsServiceProvider);
  return SettingsNotifier(settingsService);
});

class SettingsState {
  final bool kotEnabled;
  final String? selectedPrinter;
  final String storeName;
  final String serverName;
  final double taxRate;
  final String currencySymbol;
  final String deviceId;
  final bool isLoading;

  const SettingsState({
    required this.kotEnabled,
    this.selectedPrinter,
    required this.storeName,
    required this.serverName,
    required this.taxRate,
    required this.currencySymbol,
    required this.deviceId,
    this.isLoading = false,
  });

  SettingsState copyWith({
    bool? kotEnabled,
    String? selectedPrinter,
    String? storeName,
    String? serverName,
    double? taxRate,
    String? currencySymbol,
    String? deviceId,
    bool? isLoading,
  }) {
    return SettingsState(
      kotEnabled: kotEnabled ?? this.kotEnabled,
      selectedPrinter: selectedPrinter ?? this.selectedPrinter,
      storeName: storeName ?? this.storeName,
      serverName: serverName ?? this.serverName,
      taxRate: taxRate ?? this.taxRate,
      currencySymbol: currencySymbol ?? this.currencySymbol,
      deviceId: deviceId ?? this.deviceId,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final SettingsService _settingsService;

  SettingsNotifier(this._settingsService) : super(
    const SettingsState(
      kotEnabled: true,
      storeName: 'QSR Restaurant',
      serverName: 'Server 1',
      taxRate: 0.0,
      currencySymbol: '\$',
      deviceId: '',
      isLoading: true,
    ),
  ) {
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    try {
      await _settingsService.init();
      state = state.copyWith(
        kotEnabled: _settingsService.kotEnabled,
        selectedPrinter: _settingsService.selectedPrinter,
        storeName: _settingsService.storeName,
        serverName: _settingsService.serverName,
        taxRate: _settingsService.taxRate,
        currencySymbol: _settingsService.currencySymbol,
        deviceId: _settingsService.deviceId,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(isLoading: false);
    }
  }

  Future<void> setKotEnabled(bool enabled) async {
    await _settingsService.setKotEnabled(enabled);
    state = state.copyWith(kotEnabled: enabled);
  }

  Future<void> setSelectedPrinter(String? printer) async {
    await _settingsService.setSelectedPrinter(printer);
    state = state.copyWith(selectedPrinter: printer);
  }

  Future<void> setStoreName(String name) async {
    await _settingsService.setStoreName(name);
    state = state.copyWith(storeName: name);
  }

  Future<void> setServerName(String name) async {
    await _settingsService.setServerName(name);
    state = state.copyWith(serverName: name);
  }

  Future<void> setTaxRate(double rate) async {
    await _settingsService.setTaxRate(rate);
    state = state.copyWith(taxRate: rate);
  }

  Future<void> setCurrencySymbol(String symbol) async {
    await _settingsService.setCurrencySymbol(symbol);
    state = state.copyWith(currencySymbol: symbol);
  }

  Future<void> resetToDefaults() async {
    state = state.copyWith(isLoading: true);
    await _settingsService.resetToDefaults();
    await _loadSettings();
  }
}

// Menu Items Provider
final menuItemsProvider = StreamProvider<List<MenuItem>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchMenuItems();
});

final availableMenuItemsProvider = Provider<AsyncValue<List<MenuItem>>>((ref) {
  return ref.watch(menuItemsProvider).whenData(
    (items) => items.where((item) => item.isAvailable).toList(),
  );
});

// Orders Provider
final ordersProvider = StreamProvider<List<Order>>((ref) {
  final database = ref.watch(databaseProvider);
  return database.watchOrders();
});

// Current Order State
final currentOrderProvider = StateNotifierProvider<CurrentOrderNotifier, CurrentOrderState>((ref) {
  final database = ref.watch(databaseProvider);
  final settings = ref.watch(settingsProvider);
  return CurrentOrderNotifier(database, settings);
});

class CurrentOrderState {
  final List<OrderItemState> items;
  final OrderType orderType;
  final String tokenOrTable;
  final String? notes;
  final double subtotal;
  final double tax;
  final double total;
  final bool isLoading;

  const CurrentOrderState({
    this.items = const [],
    this.orderType = OrderType.dineIn,
    this.tokenOrTable = '',
    this.notes,
    this.subtotal = 0.0,
    this.tax = 0.0,
    this.total = 0.0,
    this.isLoading = false,
  });

  CurrentOrderState copyWith({
    List<OrderItemState>? items,
    OrderType? orderType,
    String? tokenOrTable,
    String? notes,
    double? subtotal,
    double? tax,
    double? total,
    bool? isLoading,
  }) {
    return CurrentOrderState(
      items: items ?? this.items,
      orderType: orderType ?? this.orderType,
      tokenOrTable: tokenOrTable ?? this.tokenOrTable,
      notes: notes ?? this.notes,
      subtotal: subtotal ?? this.subtotal,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class OrderItemState {
  final MenuItem menuItem;
  final int quantity;
  final double price;
  final String? notes;

  const OrderItemState({
    required this.menuItem,
    required this.quantity,
    required this.price,
    this.notes,
  });

  double get lineTotal => quantity * price;

  OrderItemState copyWith({
    MenuItem? menuItem,
    int? quantity,
    double? price,
    String? notes,
  }) {
    return OrderItemState(
      menuItem: menuItem ?? this.menuItem,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      notes: notes ?? this.notes,
    );
  }
}

class CurrentOrderNotifier extends StateNotifier<CurrentOrderState> {
  final AppDatabase _database;
  final SettingsState _settings;

  CurrentOrderNotifier(this._database, this._settings) : super(const CurrentOrderState());

  void addItem(MenuItem menuItem, {int quantity = 1, String? notes}) {
    final existingIndex = state.items.indexWhere(
      (item) => item.menuItem.id == menuItem.id && item.notes == notes,
    );

    List<OrderItemState> newItems;
    if (existingIndex >= 0) {
      newItems = [...state.items];
      newItems[existingIndex] = newItems[existingIndex].copyWith(
        quantity: newItems[existingIndex].quantity + quantity,
      );
    } else {
      final newItem = OrderItemState(
        menuItem: menuItem,
        quantity: quantity,
        price: menuItem.price,
        notes: notes,
      );
      newItems = [...state.items, newItem];
    }

    _updateState(newItems);
  }

  void updateItemQuantity(int index, int quantity) {
    if (index < 0 || index >= state.items.length) return;

    List<OrderItemState> newItems = [...state.items];
    if (quantity <= 0) {
      newItems.removeAt(index);
    } else {
      newItems[index] = newItems[index].copyWith(quantity: quantity);
    }

    _updateState(newItems);
  }

  void removeItem(int index) {
    if (index < 0 || index >= state.items.length) return;

    final newItems = [...state.items];
    newItems.removeAt(index);
    _updateState(newItems);
  }

  void setOrderType(OrderType type) {
    state = state.copyWith(orderType: type);
  }

  void setTokenOrTable(String value) {
    state = state.copyWith(tokenOrTable: value);
  }

  void setNotes(String? notes) {
    state = state.copyWith(notes: notes);
  }

  void _updateState(List<OrderItemState> items) {
    final subtotal = items.fold<double>(0.0, (sum, item) => sum + item.lineTotal);
    final tax = subtotal * _settings.taxRate;
    final total = subtotal + tax;

    state = state.copyWith(
      items: items,
      subtotal: subtotal,
      tax: tax,
      total: total,
    );
  }

  Future<int?> saveOrder() async {
    if (state.items.isEmpty || state.tokenOrTable.isEmpty) return null;

    state = state.copyWith(isLoading: true);

    try {
      final now = DateTime.now().millisecondsSinceEpoch;
      
      // Insert order
      final orderId = await _database.insertOrder(
        OrdersCompanion.insert(
          orderType: state.orderType,
          tokenOrTable: state.tokenOrTable,
          status: OrderStatus.open,
          subtotal: state.subtotal,
          tax: state.tax,
          total: state.total,
          createdAtEpoch: now,
          updatedAtEpoch: now,
          server: _settings.serverName,
          deviceId: _settings.deviceId,
          notes: Value(state.notes),
        ),
      );

      // Insert order items
      for (final item in state.items) {
        await _database.insertOrderItem(
          OrderItemsCompanion.insert(
            orderId: orderId,
            menuItemId: item.menuItem.id,
            quantity: item.quantity,
            price: item.price,
            lineTotal: item.lineTotal,
            notes: Value(item.notes),
            createdAtEpoch: now,
            updatedAtEpoch: now,
          ),
        );
      }

      // Clear current order
      clear();
      
      return orderId;
    } catch (e) {
      state = state.copyWith(isLoading: false);
      rethrow;
    }
  }

  void clear() {
    state = const CurrentOrderState();
  }
}
