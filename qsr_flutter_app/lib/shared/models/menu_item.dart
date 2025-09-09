import 'package:drift/drift.dart';

class MenuItems extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().withLength(min: 1, max: 100)();
  RealColumn get price => real().check(price.isBiggerThanValue(0))();
  BoolColumn get isAvailable => boolean().withDefault(const Constant(true))();
  IntColumn get updatedAtEpoch => integer()();
  IntColumn get createdAtEpoch => integer()();
  BoolColumn get isDirty => boolean().withDefault(const Constant(false))();
}

@DataClassName('MenuItem')
class MenuItemData {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;
  final int updatedAtEpoch;
  final int createdAtEpoch;
  final bool isDirty;

  const MenuItemData({
    required this.id,
    required this.name,
    required this.price,
    required this.isAvailable,
    required this.updatedAtEpoch,
    required this.createdAtEpoch,
    required this.isDirty,
  });

  MenuItemData copyWith({
    int? id,
    String? name,
    double? price,
    bool? isAvailable,
    int? updatedAtEpoch,
    int? createdAtEpoch,
    bool? isDirty,
  }) {
    return MenuItemData(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      isDirty: isDirty ?? this.isDirty,
    );
  }
}
