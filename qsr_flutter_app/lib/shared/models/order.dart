import 'package:drift/drift.dart';

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

@DataClassName('Order')
class OrderData {
  final int id;
  final OrderType orderType;
  final String tokenOrTable;
  final OrderStatus status;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  final String? server;
  final String deviceId;
  final bool isDirty;
  final String? notes;

  const OrderData({
    required this.id,
    required this.orderType,
    required this.tokenOrTable,
    required this.status,
    required this.subtotal,
    required this.discount,
    required this.tax,
    required this.total,
    required this.createdAtEpoch,
    required this.updatedAtEpoch,
    this.server,
    required this.deviceId,
    required this.isDirty,
    this.notes,
  });

  OrderData copyWith({
    int? id,
    OrderType? orderType,
    String? tokenOrTable,
    OrderStatus? status,
    double? subtotal,
    double? discount,
    double? tax,
    double? total,
    int? createdAtEpoch,
    int? updatedAtEpoch,
    String? server,
    String? deviceId,
    bool? isDirty,
    String? notes,
  }) {
    return OrderData(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      tokenOrTable: tokenOrTable ?? this.tokenOrTable,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      server: server ?? this.server,
      deviceId: deviceId ?? this.deviceId,
      isDirty: isDirty ?? this.isDirty,
      notes: notes ?? this.notes,
    );
  }
}
