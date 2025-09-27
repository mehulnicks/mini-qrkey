import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sqlite3/sqlite3.dart';
import 'package:sqlite3_flutter_libs/sqlite3_flutter_libs.dart';

// Import the table definitions
part 'database.g.dart';

// Table definitions
class MenuItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get price => real().check(price.isBiggerThanValue(0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAtEpoch => integer()();
  IntColumn get createdAtEpoch => integer()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
}

enum OrderType { dineIn, takeaway }
enum OrderStatus { open, completed, cancelled }

class Orders extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get orderType => textEnum<OrderType>()();
  TextColumn get tokenOrTable => text().withLength(min: 1, max: 50)();
  TextColumn get status => textEnum<OrderStatus>()();
  RealColumn get subtotal => real()();
  RealColumn get discount => real().withDefault(const Constant(0.0))();
  RealColumn get tax => real().withDefault(const Constant(0.0))();
  RealColumn get total => real()();
  IntColumn get createdAtEpoch => integer()();
  IntColumn get updatedAtEpoch => integer()();
  TextColumn get server => text().nullable()();
  TextColumn get deviceId => text()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
  TextColumn get notes => text().nullable()();
}

class OrderItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get orderId => integer().references(Orders, #id, onDelete: KeyAction.cascade)();
  IntColumn get menuItemId => integer().references(MenuItems, #id)();
  IntColumn get quantity => integer().check(quantity.isBiggerThanValue(0))();
  RealColumn get price => real().check(price.isBiggerThanValue(0))();
  RealColumn get lineTotal => real()();
  TextColumn get notes => text().nullable()();
  IntColumn get createdAtEpoch => integer()();
  IntColumn get updatedAtEpoch => integer()();
}

@DriftDatabase(tables: [MenuItems, Orders, OrderItems])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON');
    },
    onCreate: (Migrator m) async {
      await m.createAll();
      await _insertSeedData();
    },
  );

  Future<void> _insertSeedData() async {
    final seedItems = [
      MenuItemsCompanion.insert(
        name: 'Margherita Pizza',
        price: 12.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Chicken Burger',
        price: 8.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Caesar Salad',
        price: 7.49,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Fish & Chips',
        price: 11.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Pasta Carbonara',
        price: 10.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Grilled Chicken',
        price: 13.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Beef Tacos',
        price: 9.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Veggie Wrap',
        price: 6.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'BBQ Ribs',
        price: 16.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Mushroom Risotto',
        price: 12.49,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Club Sandwich',
        price: 8.49,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Chicken Wings',
        price: 9.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Greek Salad',
        price: 7.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Chicken Quesadilla',
        price: 8.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Beef Steak',
        price: 19.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Garlic Bread',
        price: 4.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Tomato Soup',
        price: 5.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Chocolate Cake',
        price: 6.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Iced Coffee',
        price: 3.99,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
      MenuItemsCompanion.insert(
        name: 'Fresh Orange Juice',
        price: 4.49,
        createdAtEpoch: DateTime.now().millisecondsSinceEpoch,
        updatedAtEpoch: DateTime.now().millisecondsSinceEpoch,
      ),
    ];

    for (final item in seedItems) {
      await into(menuItems).insert(item);
    }
  }

  // Menu Items queries
  Future<List<MenuItem>> getAllMenuItems() => select(menuItems).get();
  
  Future<List<MenuItem>> getAvailableMenuItems() => 
    (select(menuItems)..where((tbl) => tbl.isAvailable.equals(true))).get();

  Stream<List<MenuItem>> watchMenuItems() => select(menuItems).watch();

  Future<int> insertMenuItem(MenuItemsCompanion item) => 
    into(menuItems).insert(item);

  Future<bool> updateMenuItem(MenuItem item) => 
    update(menuItems).replace(item);

  Future<int> deleteMenuItem(int id) => 
    (delete(menuItems)..where((tbl) => tbl.id.equals(id))).go();

  // Orders queries
  Future<List<Order>> getAllOrders() => select(orders).get();

  Future<List<Order>> getOrdersByDateRange(int startEpoch, int endEpoch) =>
    (select(orders)
      ..where((tbl) => 
        tbl.createdAtEpoch.isBetweenValues(startEpoch, endEpoch)))
    .get();

  Future<List<Order>> getCompletedOrdersByDateRange(int startEpoch, int endEpoch) =>
    (select(orders)
      ..where((tbl) => 
        tbl.createdAtEpoch.isBetweenValues(startEpoch, endEpoch) &
        tbl.status.equals(OrderStatus.completed.name)))
    .get();

  Stream<List<Order>> watchOrders() => select(orders).watch();

  Future<int> insertOrder(OrdersCompanion order) => 
    into(orders).insert(order);

  Future<bool> updateOrder(Order order) => 
    update(orders).replace(order);

  Future<int> deleteOrder(int id) => 
    (delete(orders)..where((tbl) => tbl.id.equals(id))).go();

  // Order Items queries
  Future<List<OrderItem>> getOrderItems(int orderId) =>
    (select(orderItems)..where((tbl) => tbl.orderId.equals(orderId))).get();

  Future<int> insertOrderItem(OrderItemsCompanion item) => 
    into(orderItems).insert(item);

  Future<bool> updateOrderItem(OrderItem item) => 
    update(orderItems).replace(item);

  Future<int> deleteOrderItem(int id) => 
    (delete(orderItems)..where((tbl) => tbl.id.equals(id))).go();

  // Complex queries for reporting
  Future<double> getTotalSalesByDateRange(int startEpoch, int endEpoch) async {
    final query = selectOnly(orders)
      ..addColumns([orders.total.sum()])
      ..where(orders.createdAtEpoch.isBetweenValues(startEpoch, endEpoch) &
              orders.status.equals(OrderStatus.completed.name));
    
    final result = await query.getSingle();
    return result.read(orders.total.sum()) ?? 0.0;
  }

  Future<int> getOrderCountByDateRange(int startEpoch, int endEpoch) async {
    final query = selectOnly(orders)
      ..addColumns([orders.id.count()])
      ..where(orders.createdAtEpoch.isBetweenValues(startEpoch, endEpoch) &
              orders.status.equals(OrderStatus.completed.name));
    
    final result = await query.getSingle();
    return result.read(orders.id.count()) ?? 0;
  }

  Future<int> getTotalItemsSoldByDateRange(int startEpoch, int endEpoch) async {
    final query = selectOnly(orderItems)
      ..addColumns([orderItems.quantity.sum()])
      ..join([
        leftOuterJoin(orders, orders.id.equalsExp(orderItems.orderId))
      ])
      ..where(orders.createdAtEpoch.isBetweenValues(startEpoch, endEpoch) &
              orders.status.equals(OrderStatus.completed.name));
    
    final result = await query.getSingle();
    return result.read(orderItems.quantity.sum()) ?? 0;
  }

  Future<List<Map<String, dynamic>>> getTopItemsByDateRange(int startEpoch, int endEpoch, {int limit = 5}) async {
    final query = selectOnly(orderItems)
      ..addColumns([
        menuItems.name,
        orderItems.quantity.sum(),
      ])
      ..join([
        leftOuterJoin(orders, orders.id.equalsExp(orderItems.orderId)),
        leftOuterJoin(menuItems, menuItems.id.equalsExp(orderItems.menuItemId)),
      ])
      ..where(orders.createdAtEpoch.isBetweenValues(startEpoch, endEpoch) &
              orders.status.equals(OrderStatus.completed.name))
      ..groupBy([menuItems.name])
      ..orderBy([OrderingTerm.desc(orderItems.quantity.sum())])
      ..limit(limit);
    
    final results = await query.get();
    return results.map((row) => {
      'name': row.read(menuItems.name),
      'quantity': row.read(orderItems.quantity.sum()) ?? 0,
    }).toList();
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    if (Platform.isAndroid) {
      await applyWorkaroundToOpenSqlite3OnOldAndroidVersions();
    }

    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'qsr_app.db'));
    
    if (Platform.isAndroid) {
      sqlite3.tempDirectory = (await getTemporaryDirectory()).path;
    }
    
    return NativeDatabase.createInBackground(file);
  });
}
