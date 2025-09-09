import 'package:drift/drift.dart';

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

  @override
  Set<Column> get primaryKey => {id};
}

@DataClassName('OrderItem')
class OrderItemData {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double price;
  final double lineTotal;
  final String? notes;
  final int createdAtEpoch;
  final int updatedAtEpoch;

  const OrderItemData({
    required this.id,
    required this.orderId,
    required this.menuItemId,
    required this.quantity,
    required this.price,
    required this.lineTotal,
    this.notes,
    required this.createdAtEpoch,
    required this.updatedAtEpoch,
  });

  OrderItemData copyWith({
    int? id,
    int? orderId,
    int? menuItemId,
    int? quantity,
    double? price,
    double? lineTotal,
    String? notes,
    int? createdAtEpoch,
    int? updatedAtEpoch,
  }) {
    return OrderItemData(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      lineTotal: lineTotal ?? this.lineTotal,
      notes: notes ?? this.notes,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
    );
  }
}
