// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// ignore_for_file: type=lint
class $MenuItemsTable extends MenuItems
    with TableInfo<$MenuItemsTable, MenuItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 100),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      check: () => ComparableExpr(price).isBiggerThanValue(0),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _isAvailableMeta =
      const VerificationMeta('isAvailable');
  @override
  late final GeneratedColumn<bool> isAvailable = GeneratedColumn<bool>(
      'is_available', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_available" IN (0, 1))'),
      defaultValue: const Constant(true));
  static const VerificationMeta _updatedAtEpochMeta =
      const VerificationMeta('updatedAtEpoch');
  @override
  late final GeneratedColumn<int> updatedAtEpoch = GeneratedColumn<int>(
      'updated_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _createdAtEpochMeta =
      const VerificationMeta('createdAtEpoch');
  @override
  late final GeneratedColumn<int> createdAtEpoch = GeneratedColumn<int>(
      'created_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, name, price, isAvailable, updatedAtEpoch, createdAtEpoch, isDirty];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu_items';
  @override
  VerificationContext validateIntegrity(Insertable<MenuItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
    }
    if (data.containsKey('updated_at_epoch')) {
      context.handle(
          _updatedAtEpochMeta,
          updatedAtEpoch.isAcceptableOrUnknown(
              data['updated_at_epoch']!, _updatedAtEpochMeta));
    } else if (isInserting) {
      context.missing(_updatedAtEpochMeta);
    }
    if (data.containsKey('created_at_epoch')) {
      context.handle(
          _createdAtEpochMeta,
          createdAtEpoch.isAcceptableOrUnknown(
              data['created_at_epoch']!, _createdAtEpochMeta));
    } else if (isInserting) {
      context.missing(_createdAtEpochMeta);
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
    );
  }

  @override
  $MenuItemsTable createAlias(String alias) {
    return $MenuItemsTable(attachedDatabase, alias);
  }
}

class MenuItem extends DataClass implements Insertable<MenuItem> {
  final int id;
  final String name;
  final double price;
  final bool isAvailable;
  final int updatedAtEpoch;
  final int createdAtEpoch;
  final bool isDirty;
  const MenuItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.isAvailable,
      required this.updatedAtEpoch,
      required this.createdAtEpoch,
      required this.isDirty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['is_available'] = Variable<bool>(isAvailable);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['is_dirty'] = Variable<bool>(isDirty);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      isAvailable: Value(isAvailable),
      updatedAtEpoch: Value(updatedAtEpoch),
      createdAtEpoch: Value(createdAtEpoch),
      isDirty: Value(isDirty),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<int>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'isDirty': serializer.toJson<bool>(isDirty),
    };
  }

  MenuItem copyWith(
          {int? id,
          String? name,
          double? price,
          bool? isAvailable,
          int? updatedAtEpoch,
          int? createdAtEpoch,
          bool? isDirty}) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        isAvailable: isAvailable ?? this.isAvailable,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        isDirty: isDirty ?? this.isDirty,
      );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      updatedAtEpoch: data.updatedAtEpoch.present
          ? data.updatedAtEpoch.value
          : this.updatedAtEpoch,
      createdAtEpoch: data.createdAtEpoch.present
          ? data.createdAtEpoch.value
          : this.createdAtEpoch,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id, name, price, isAvailable, updatedAtEpoch, createdAtEpoch, isDirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.isAvailable == this.isAvailable &&
          other.updatedAtEpoch == this.updatedAtEpoch &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.isDirty == this.isDirty);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<int> id;
  final Value<String> name;
  final Value<double> price;
  final Value<bool> isAvailable;
  final Value<int> updatedAtEpoch;
  final Value<int> createdAtEpoch;
  final Value<bool> isDirty;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.isDirty = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    required double price,
    this.isAvailable = const Value.absent(),
    required int updatedAtEpoch,
    required int createdAtEpoch,
    this.isDirty = const Value.absent(),
  })  : name = Value(name),
        price = Value(price),
        updatedAtEpoch = Value(updatedAtEpoch),
        createdAtEpoch = Value(createdAtEpoch);
  static Insertable<MenuItem> custom({
    Expression<int>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<bool>? isAvailable,
    Expression<int>? updatedAtEpoch,
    Expression<int>? createdAtEpoch,
    Expression<bool>? isDirty,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (isAvailable != null) 'is_available': isAvailable,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (isDirty != null) 'is_dirty': isDirty,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<int>? id,
      Value<String>? name,
      Value<double>? price,
      Value<bool>? isAvailable,
      Value<int>? updatedAtEpoch,
      Value<int>? createdAtEpoch,
      Value<bool>? isDirty}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      isAvailable: isAvailable ?? this.isAvailable,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      isDirty: isDirty ?? this.isDirty,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }
}

class $OrdersTable extends Orders with TableInfo<$OrdersTable, Order> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrdersTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  @override
  late final GeneratedColumnWithTypeConverter<OrderType, String> orderType =
      GeneratedColumn<String>('order_type', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<OrderType>($OrdersTable.$converterorderType);
  static const VerificationMeta _tokenOrTableMeta =
      const VerificationMeta('tokenOrTable');
  @override
  late final GeneratedColumn<String> tokenOrTable = GeneratedColumn<String>(
      'token_or_table', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 50),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  @override
  late final GeneratedColumnWithTypeConverter<OrderStatus, String> status =
      GeneratedColumn<String>('status', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<OrderStatus>($OrdersTable.$converterstatus);
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _discountMeta =
      const VerificationMeta('discount');
  @override
  late final GeneratedColumn<double> discount = GeneratedColumn<double>(
      'discount', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _taxMeta = const VerificationMeta('tax');
  @override
  late final GeneratedColumn<double> tax = GeneratedColumn<double>(
      'tax', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _totalMeta = const VerificationMeta('total');
  @override
  late final GeneratedColumn<double> total = GeneratedColumn<double>(
      'total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _createdAtEpochMeta =
      const VerificationMeta('createdAtEpoch');
  @override
  late final GeneratedColumn<int> createdAtEpoch = GeneratedColumn<int>(
      'created_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtEpochMeta =
      const VerificationMeta('updatedAtEpoch');
  @override
  late final GeneratedColumn<int> updatedAtEpoch = GeneratedColumn<int>(
      'updated_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<String> server = GeneratedColumn<String>(
      'server', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isDirtyMeta =
      const VerificationMeta('isDirty');
  @override
  late final GeneratedColumn<bool> isDirty = GeneratedColumn<bool>(
      'is_dirty', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("is_dirty" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderType,
        tokenOrTable,
        status,
        subtotal,
        discount,
        tax,
        total,
        createdAtEpoch,
        updatedAtEpoch,
        server,
        deviceId,
        isDirty,
        notes
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'orders';
  @override
  VerificationContext validateIntegrity(Insertable<Order> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('token_or_table')) {
      context.handle(
          _tokenOrTableMeta,
          tokenOrTable.isAcceptableOrUnknown(
              data['token_or_table']!, _tokenOrTableMeta));
    } else if (isInserting) {
      context.missing(_tokenOrTableMeta);
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
    } else if (isInserting) {
      context.missing(_subtotalMeta);
    }
    if (data.containsKey('discount')) {
      context.handle(_discountMeta,
          discount.isAcceptableOrUnknown(data['discount']!, _discountMeta));
    }
    if (data.containsKey('tax')) {
      context.handle(
          _taxMeta, tax.isAcceptableOrUnknown(data['tax']!, _taxMeta));
    }
    if (data.containsKey('total')) {
      context.handle(
          _totalMeta, total.isAcceptableOrUnknown(data['total']!, _totalMeta));
    } else if (isInserting) {
      context.missing(_totalMeta);
    }
    if (data.containsKey('created_at_epoch')) {
      context.handle(
          _createdAtEpochMeta,
          createdAtEpoch.isAcceptableOrUnknown(
              data['created_at_epoch']!, _createdAtEpochMeta));
    } else if (isInserting) {
      context.missing(_createdAtEpochMeta);
    }
    if (data.containsKey('updated_at_epoch')) {
      context.handle(
          _updatedAtEpochMeta,
          updatedAtEpoch.isAcceptableOrUnknown(
              data['updated_at_epoch']!, _updatedAtEpochMeta));
    } else if (isInserting) {
      context.missing(_updatedAtEpochMeta);
    }
    if (data.containsKey('server')) {
      context.handle(_serverMeta,
          server.isAcceptableOrUnknown(data['server']!, _serverMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
    } else if (isInserting) {
      context.missing(_deviceIdMeta);
    }
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Order map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Order(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderType: $OrdersTable.$converterorderType.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!),
      tokenOrTable: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token_or_table'])!,
      status: $OrdersTable.$converterstatus.fromSql(attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!),
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      tax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
      server: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server']),
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }

  static JsonTypeConverter2<OrderType, String, String> $converterorderType =
      const EnumNameConverter<OrderType>(OrderType.values);
  static JsonTypeConverter2<OrderStatus, String, String> $converterstatus =
      const EnumNameConverter<OrderStatus>(OrderStatus.values);
}

class Order extends DataClass implements Insertable<Order> {
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
  const Order(
      {required this.id,
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
      this.notes});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    {
      map['order_type'] =
          Variable<String>($OrdersTable.$converterorderType.toSql(orderType));
    }
    map['token_or_table'] = Variable<String>(tokenOrTable);
    {
      map['status'] =
          Variable<String>($OrdersTable.$converterstatus.toSql(status));
    }
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['tax'] = Variable<double>(tax);
    map['total'] = Variable<double>(total);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    if (!nullToAbsent || server != null) {
      map['server'] = Variable<String>(server);
    }
    map['device_id'] = Variable<String>(deviceId);
    map['is_dirty'] = Variable<bool>(isDirty);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderType: Value(orderType),
      tokenOrTable: Value(tokenOrTable),
      status: Value(status),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      total: Value(total),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
      server:
          server == null && nullToAbsent ? const Value.absent() : Value(server),
      deviceId: Value(deviceId),
      isDirty: Value(isDirty),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<int>(json['id']),
      orderType: $OrdersTable.$converterorderType
          .fromJson(serializer.fromJson<String>(json['orderType'])),
      tokenOrTable: serializer.fromJson<String>(json['tokenOrTable']),
      status: $OrdersTable.$converterstatus
          .fromJson(serializer.fromJson<String>(json['status'])),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      tax: serializer.fromJson<double>(json['tax']),
      total: serializer.fromJson<double>(json['total']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
      server: serializer.fromJson<String?>(json['server']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderType': serializer
          .toJson<String>($OrdersTable.$converterorderType.toJson(orderType)),
      'tokenOrTable': serializer.toJson<String>(tokenOrTable),
      'status': serializer
          .toJson<String>($OrdersTable.$converterstatus.toJson(status)),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'tax': serializer.toJson<double>(tax),
      'total': serializer.toJson<double>(total),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
      'server': serializer.toJson<String?>(server),
      'deviceId': serializer.toJson<String>(deviceId),
      'isDirty': serializer.toJson<bool>(isDirty),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  Order copyWith(
          {int? id,
          OrderType? orderType,
          String? tokenOrTable,
          OrderStatus? status,
          double? subtotal,
          double? discount,
          double? tax,
          double? total,
          int? createdAtEpoch,
          int? updatedAtEpoch,
          Value<String?> server = const Value.absent(),
          String? deviceId,
          bool? isDirty,
          Value<String?> notes = const Value.absent()}) =>
      Order(
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
        server: server.present ? server.value : this.server,
        deviceId: deviceId ?? this.deviceId,
        isDirty: isDirty ?? this.isDirty,
        notes: notes.present ? notes.value : this.notes,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      tokenOrTable: data.tokenOrTable.present
          ? data.tokenOrTable.value
          : this.tokenOrTable,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      total: data.total.present ? data.total.value : this.total,
      createdAtEpoch: data.createdAtEpoch.present
          ? data.createdAtEpoch.value
          : this.createdAtEpoch,
      updatedAtEpoch: data.updatedAtEpoch.present
          ? data.updatedAtEpoch.value
          : this.updatedAtEpoch,
      server: data.server.present ? data.server.value : this.server,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderType: $orderType, ')
          ..write('tokenOrTable: $tokenOrTable, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('server: $server, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDirty: $isDirty, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderType,
      tokenOrTable,
      status,
      subtotal,
      discount,
      tax,
      total,
      createdAtEpoch,
      updatedAtEpoch,
      server,
      deviceId,
      isDirty,
      notes);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderType == this.orderType &&
          other.tokenOrTable == this.tokenOrTable &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.total == this.total &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch &&
          other.server == this.server &&
          other.deviceId == this.deviceId &&
          other.isDirty == this.isDirty &&
          other.notes == this.notes);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<int> id;
  final Value<OrderType> orderType;
  final Value<String> tokenOrTable;
  final Value<OrderStatus> status;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> tax;
  final Value<double> total;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  final Value<String?> server;
  final Value<String> deviceId;
  final Value<bool> isDirty;
  final Value<String?> notes;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderType = const Value.absent(),
    this.tokenOrTable = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
    this.server = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.notes = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    required OrderType orderType,
    required String tokenOrTable,
    required OrderStatus status,
    required double subtotal,
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    required double total,
    required int createdAtEpoch,
    required int updatedAtEpoch,
    this.server = const Value.absent(),
    required String deviceId,
    this.isDirty = const Value.absent(),
    this.notes = const Value.absent(),
  })  : orderType = Value(orderType),
        tokenOrTable = Value(tokenOrTable),
        status = Value(status),
        subtotal = Value(subtotal),
        total = Value(total),
        createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch),
        deviceId = Value(deviceId);
  static Insertable<Order> custom({
    Expression<int>? id,
    Expression<String>? orderType,
    Expression<String>? tokenOrTable,
    Expression<String>? status,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? tax,
    Expression<double>? total,
    Expression<int>? createdAtEpoch,
    Expression<int>? updatedAtEpoch,
    Expression<String>? server,
    Expression<String>? deviceId,
    Expression<bool>? isDirty,
    Expression<String>? notes,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderType != null) 'order_type': orderType,
      if (tokenOrTable != null) 'token_or_table': tokenOrTable,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (total != null) 'total': total,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
      if (server != null) 'server': server,
      if (deviceId != null) 'device_id': deviceId,
      if (isDirty != null) 'is_dirty': isDirty,
      if (notes != null) 'notes': notes,
    });
  }

  OrdersCompanion copyWith(
      {Value<int>? id,
      Value<OrderType>? orderType,
      Value<String>? tokenOrTable,
      Value<OrderStatus>? status,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<double>? tax,
      Value<double>? total,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch,
      Value<String?>? server,
      Value<String>? deviceId,
      Value<bool>? isDirty,
      Value<String?>? notes}) {
    return OrdersCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(
          $OrdersTable.$converterorderType.toSql(orderType.value));
    }
    if (tokenOrTable.present) {
      map['token_or_table'] = Variable<String>(tokenOrTable.value);
    }
    if (status.present) {
      map['status'] =
          Variable<String>($OrdersTable.$converterstatus.toSql(status.value));
    }
    if (subtotal.present) {
      map['subtotal'] = Variable<double>(subtotal.value);
    }
    if (discount.present) {
      map['discount'] = Variable<double>(discount.value);
    }
    if (tax.present) {
      map['tax'] = Variable<double>(tax.value);
    }
    if (total.present) {
      map['total'] = Variable<double>(total.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    if (server.present) {
      map['server'] = Variable<String>(server.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderType: $orderType, ')
          ..write('tokenOrTable: $tokenOrTable, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('server: $server, ')
          ..write('deviceId: $deviceId, ')
          ..write('isDirty: $isDirty, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }
}

class $OrderItemsTable extends OrderItems
    with TableInfo<$OrderItemsTable, OrderItem> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $OrderItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _orderIdMeta =
      const VerificationMeta('orderId');
  @override
  late final GeneratedColumn<int> orderId = GeneratedColumn<int>(
      'order_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES orders (id) ON DELETE CASCADE'));
  static const VerificationMeta _menuItemIdMeta =
      const VerificationMeta('menuItemId');
  @override
  late final GeneratedColumn<int> menuItemId = GeneratedColumn<int>(
      'menu_item_id', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: true,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('REFERENCES menu_items (id)'));
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      check: () => ComparableExpr(quantity).isBiggerThanValue(0),
      type: DriftSqlType.int,
      requiredDuringInsert: true);
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      check: () => ComparableExpr(price).isBiggerThanValue(0),
      type: DriftSqlType.double,
      requiredDuringInsert: true);
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _createdAtEpochMeta =
      const VerificationMeta('createdAtEpoch');
  @override
  late final GeneratedColumn<int> createdAtEpoch = GeneratedColumn<int>(
      'created_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  static const VerificationMeta _updatedAtEpochMeta =
      const VerificationMeta('updatedAtEpoch');
  @override
  late final GeneratedColumn<int> updatedAtEpoch = GeneratedColumn<int>(
      'updated_at_epoch', aliasedName, false,
      type: DriftSqlType.int, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderId,
        menuItemId,
        quantity,
        price,
        lineTotal,
        notes,
        createdAtEpoch,
        updatedAtEpoch
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'order_items';
  @override
  VerificationContext validateIntegrity(Insertable<OrderItem> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('order_id')) {
      context.handle(_orderIdMeta,
          orderId.isAcceptableOrUnknown(data['order_id']!, _orderIdMeta));
    } else if (isInserting) {
      context.missing(_orderIdMeta);
    }
    if (data.containsKey('menu_item_id')) {
      context.handle(
          _menuItemIdMeta,
          menuItemId.isAcceptableOrUnknown(
              data['menu_item_id']!, _menuItemIdMeta));
    } else if (isInserting) {
      context.missing(_menuItemIdMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
    } else if (isInserting) {
      context.missing(_quantityMeta);
    }
    if (data.containsKey('price')) {
      context.handle(
          _priceMeta, price.isAcceptableOrUnknown(data['price']!, _priceMeta));
    } else if (isInserting) {
      context.missing(_priceMeta);
    }
    if (data.containsKey('line_total')) {
      context.handle(_lineTotalMeta,
          lineTotal.isAcceptableOrUnknown(data['line_total']!, _lineTotalMeta));
    } else if (isInserting) {
      context.missing(_lineTotalMeta);
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('created_at_epoch')) {
      context.handle(
          _createdAtEpochMeta,
          createdAtEpoch.isAcceptableOrUnknown(
              data['created_at_epoch']!, _createdAtEpochMeta));
    } else if (isInserting) {
      context.missing(_createdAtEpochMeta);
    }
    if (data.containsKey('updated_at_epoch')) {
      context.handle(
          _updatedAtEpochMeta,
          updatedAtEpoch.isAcceptableOrUnknown(
              data['updated_at_epoch']!, _updatedAtEpochMeta));
    } else if (isInserting) {
      context.missing(_updatedAtEpochMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  OrderItem map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return OrderItem(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      orderId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}order_id'])!,
      menuItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}menu_item_id'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes']),
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
    );
  }

  @override
  $OrderItemsTable createAlias(String alias) {
    return $OrderItemsTable(attachedDatabase, alias);
  }
}

class OrderItem extends DataClass implements Insertable<OrderItem> {
  final int id;
  final int orderId;
  final int menuItemId;
  final int quantity;
  final double price;
  final double lineTotal;
  final String? notes;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.menuItemId,
      required this.quantity,
      required this.price,
      required this.lineTotal,
      this.notes,
      required this.createdAtEpoch,
      required this.updatedAtEpoch});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<int>(orderId);
    map['menu_item_id'] = Variable<int>(menuItemId);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    map['line_total'] = Variable<double>(lineTotal);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      menuItemId: Value(menuItemId),
      quantity: Value(quantity),
      price: Value(price),
      lineTotal: Value(lineTotal),
      notes:
          notes == null && nullToAbsent ? const Value.absent() : Value(notes),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<int>(json['orderId']),
      menuItemId: serializer.fromJson<int>(json['menuItemId']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      notes: serializer.fromJson<String?>(json['notes']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<int>(orderId),
      'menuItemId': serializer.toJson<int>(menuItemId),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'notes': serializer.toJson<String?>(notes),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
    };
  }

  OrderItem copyWith(
          {int? id,
          int? orderId,
          int? menuItemId,
          int? quantity,
          double? price,
          double? lineTotal,
          Value<String?> notes = const Value.absent(),
          int? createdAtEpoch,
          int? updatedAtEpoch}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        menuItemId: menuItemId ?? this.menuItemId,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        lineTotal: lineTotal ?? this.lineTotal,
        notes: notes.present ? notes.value : this.notes,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      menuItemId:
          data.menuItemId.present ? data.menuItemId.value : this.menuItemId,
      quantity: data.quantity.present ? data.quantity.value : this.quantity,
      price: data.price.present ? data.price.value : this.price,
      lineTotal: data.lineTotal.present ? data.lineTotal.value : this.lineTotal,
      notes: data.notes.present ? data.notes.value : this.notes,
      createdAtEpoch: data.createdAtEpoch.present
          ? data.createdAtEpoch.value
          : this.createdAtEpoch,
      updatedAtEpoch: data.updatedAtEpoch.present
          ? data.updatedAtEpoch.value
          : this.updatedAtEpoch,
    );
  }

  @override
  String toString() {
    return (StringBuffer('OrderItem(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('notes: $notes, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, orderId, menuItemId, quantity, price,
      lineTotal, notes, createdAtEpoch, updatedAtEpoch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.menuItemId == this.menuItemId &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.lineTotal == this.lineTotal &&
          other.notes == this.notes &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<int> orderId;
  final Value<int> menuItemId;
  final Value<int> quantity;
  final Value<double> price;
  final Value<double> lineTotal;
  final Value<String?> notes;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required int orderId,
    required int menuItemId,
    required int quantity,
    required double price,
    required double lineTotal,
    this.notes = const Value.absent(),
    required int createdAtEpoch,
    required int updatedAtEpoch,
  })  : orderId = Value(orderId),
        menuItemId = Value(menuItemId),
        quantity = Value(quantity),
        price = Value(price),
        lineTotal = Value(lineTotal),
        createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<int>? orderId,
    Expression<int>? menuItemId,
    Expression<int>? quantity,
    Expression<double>? price,
    Expression<double>? lineTotal,
    Expression<String>? notes,
    Expression<int>? createdAtEpoch,
    Expression<int>? updatedAtEpoch,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderId != null) 'order_id': orderId,
      if (menuItemId != null) 'menu_item_id': menuItemId,
      if (quantity != null) 'quantity': quantity,
      if (price != null) 'price': price,
      if (lineTotal != null) 'line_total': lineTotal,
      if (notes != null) 'notes': notes,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
    });
  }

  OrderItemsCompanion copyWith(
      {Value<int>? id,
      Value<int>? orderId,
      Value<int>? menuItemId,
      Value<int>? quantity,
      Value<double>? price,
      Value<double>? lineTotal,
      Value<String?>? notes,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch}) {
    return OrderItemsCompanion(
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

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (orderId.present) {
      map['order_id'] = Variable<int>(orderId.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<int>(menuItemId.value);
    }
    if (quantity.present) {
      map['quantity'] = Variable<int>(quantity.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (lineTotal.present) {
      map['line_total'] = Variable<double>(lineTotal.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrderItemsCompanion(')
          ..write('id: $id, ')
          ..write('orderId: $orderId, ')
          ..write('menuItemId: $menuItemId, ')
          ..write('quantity: $quantity, ')
          ..write('price: $price, ')
          ..write('lineTotal: $lineTotal, ')
          ..write('notes: $notes, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [menuItems, orders, orderItems];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules(
        [
          WritePropagation(
            on: TableUpdateQuery.onTableName('orders',
                limitUpdateKind: UpdateKind.delete),
            result: [
              TableUpdate('order_items', kind: UpdateKind.delete),
            ],
          ),
        ],
      );
}

typedef $$MenuItemsTableCreateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  required String name,
  required double price,
  Value<bool> isAvailable,
  required int updatedAtEpoch,
  required int createdAtEpoch,
  Value<bool> isDirty,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<int> id,
  Value<String> name,
  Value<double> price,
  Value<bool> isAvailable,
  Value<int> updatedAtEpoch,
  Value<int> createdAtEpoch,
  Value<bool> isDirty,
});

final class $$MenuItemsTableReferences
    extends BaseReferences<_$AppDatabase, $MenuItemsTable, MenuItem> {
  $$MenuItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName:
              $_aliasNameGenerator(db.menuItems.id, db.orderItems.menuItemId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.menuItemId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MenuItemsTableFilterComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.menuItemId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$MenuItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, $$MenuItemsTableReferences),
    MenuItem,
    PrefetchHooks Function({bool orderItemsRefs})> {
  $$MenuItemsTableTableManager(_$AppDatabase db, $MenuItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
          }) =>
              MenuItemsCompanion(
            id: id,
            name: name,
            price: price,
            isAvailable: isAvailable,
            updatedAtEpoch: updatedAtEpoch,
            createdAtEpoch: createdAtEpoch,
            isDirty: isDirty,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String name,
            required double price,
            Value<bool> isAvailable = const Value.absent(),
            required int updatedAtEpoch,
            required int createdAtEpoch,
            Value<bool> isDirty = const Value.absent(),
          }) =>
              MenuItemsCompanion.insert(
            id: id,
            name: name,
            price: price,
            isAvailable: isAvailable,
            updatedAtEpoch: updatedAtEpoch,
            createdAtEpoch: createdAtEpoch,
            isDirty: isDirty,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$MenuItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<MenuItem, $MenuItemsTable,
                            OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$MenuItemsTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$MenuItemsTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem:
                            (item, referencedItems) => referencedItems
                                .where((e) => e.menuItemId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$MenuItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuItemsTable,
    MenuItem,
    $$MenuItemsTableFilterComposer,
    $$MenuItemsTableOrderingComposer,
    $$MenuItemsTableAnnotationComposer,
    $$MenuItemsTableCreateCompanionBuilder,
    $$MenuItemsTableUpdateCompanionBuilder,
    (MenuItem, $$MenuItemsTableReferences),
    MenuItem,
    PrefetchHooks Function({bool orderItemsRefs})>;
typedef $$OrdersTableCreateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  required OrderType orderType,
  required String tokenOrTable,
  required OrderStatus status,
  required double subtotal,
  Value<double> discount,
  Value<double> tax,
  required double total,
  required int createdAtEpoch,
  required int updatedAtEpoch,
  Value<String?> server,
  required String deviceId,
  Value<bool> isDirty,
  Value<String?> notes,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<int> id,
  Value<OrderType> orderType,
  Value<String> tokenOrTable,
  Value<OrderStatus> status,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> tax,
  Value<double> total,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
  Value<String?> server,
  Value<String> deviceId,
  Value<bool> isDirty,
  Value<String?> notes,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$AppDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<int>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrderType, OrderType, String> get orderType =>
      $composableBuilder(
          column: $table.orderType,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<String> get tokenOrTable => $composableBuilder(
      column: $table.tokenOrTable, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<OrderStatus, OrderStatus, String> get status =>
      $composableBuilder(
          column: $table.status,
          builder: (column) => ColumnWithTypeConverterFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tax => $composableBuilder(
      column: $table.tax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get server => $composableBuilder(
      column: $table.server, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  Expression<bool> orderItemsRefs(
      Expression<bool> Function($$OrderItemsTableFilterComposer f) f) {
    final $$OrderItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableFilterComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableOrderingComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get tokenOrTable => $composableBuilder(
      column: $table.tokenOrTable,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get tax => $composableBuilder(
      column: $table.tax, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get server => $composableBuilder(
      column: $table.server, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderType, String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get tokenOrTable => $composableBuilder(
      column: $table.tokenOrTable, builder: (column) => column);

  GeneratedColumnWithTypeConverter<OrderStatus, String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);

  GeneratedColumn<String> get server =>
      $composableBuilder(column: $table.server, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  Expression<T> orderItemsRefs<T extends Object>(
      Expression<T> Function($$OrderItemsTableAnnotationComposer a) f) {
    final $$OrderItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.id,
        referencedTable: $db.orderItems,
        getReferencedColumn: (t) => t.orderId,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrderItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.orderItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return f(composer);
  }
}

class $$OrdersTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool orderItemsRefs})> {
  $$OrdersTableTableManager(_$AppDatabase db, $OrdersTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrdersTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrdersTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrdersTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<OrderType> orderType = const Value.absent(),
            Value<String> tokenOrTable = const Value.absent(),
            Value<OrderStatus> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> tax = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
            Value<String?> server = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            orderType: orderType,
            tokenOrTable: tokenOrTable,
            status: status,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            total: total,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            server: server,
            deviceId: deviceId,
            isDirty: isDirty,
            notes: notes,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required OrderType orderType,
            required String tokenOrTable,
            required OrderStatus status,
            required double subtotal,
            Value<double> discount = const Value.absent(),
            Value<double> tax = const Value.absent(),
            required double total,
            required int createdAtEpoch,
            required int updatedAtEpoch,
            Value<String?> server = const Value.absent(),
            required String deviceId,
            Value<bool> isDirty = const Value.absent(),
            Value<String?> notes = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            orderType: orderType,
            tokenOrTable: tokenOrTable,
            status: status,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            total: total,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            server: server,
            deviceId: deviceId,
            isDirty: isDirty,
            notes: notes,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) =>
                  (e.readTable(table), $$OrdersTableReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: ({orderItemsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (orderItemsRefs) db.orderItems],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (orderItemsRefs)
                    await $_getPrefetchedData<Order, $OrdersTable, OrderItem>(
                        currentTable: table,
                        referencedTable:
                            $$OrdersTableReferences._orderItemsRefsTable(db),
                        managerFromTypedResult: (p0) =>
                            $$OrdersTableReferences(db, table, p0)
                                .orderItemsRefs,
                        referencedItemsForCurrentItem: (item,
                                referencedItems) =>
                            referencedItems.where((e) => e.orderId == item.id),
                        typedResults: items)
                ];
              },
            );
          },
        ));
}

typedef $$OrdersTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrdersTable,
    Order,
    $$OrdersTableFilterComposer,
    $$OrdersTableOrderingComposer,
    $$OrdersTableAnnotationComposer,
    $$OrdersTableCreateCompanionBuilder,
    $$OrdersTableUpdateCompanionBuilder,
    (Order, $$OrdersTableReferences),
    Order,
    PrefetchHooks Function({bool orderItemsRefs})>;
typedef $$OrderItemsTableCreateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  required int orderId,
  required int menuItemId,
  required int quantity,
  required double price,
  required double lineTotal,
  Value<String?> notes,
  required int createdAtEpoch,
  required int updatedAtEpoch,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<int> orderId,
  Value<int> menuItemId,
  Value<int> quantity,
  Value<double> price,
  Value<double> lineTotal,
  Value<String?> notes,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$AppDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$AppDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<int>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MenuItemsTable _menuItemIdTable(_$AppDatabase db) =>
      db.menuItems.createAlias(
          $_aliasNameGenerator(db.orderItems.menuItemId, db.menuItems.id));

  $$MenuItemsTableProcessedTableManager get menuItemId {
    final $_column = $_itemColumn<int>('menu_item_id')!;

    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnFilters(column));

  $$OrdersTableFilterComposer get orderId {
    final $$OrdersTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableFilterComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableFilterComposer get menuItemId {
    final $$MenuItemsTableFilterComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableFilterComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get quantity => $composableBuilder(
      column: $table.quantity, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get lineTotal => $composableBuilder(
      column: $table.lineTotal, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));

  $$OrdersTableOrderingComposer get orderId {
    final $$OrdersTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableOrderingComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableOrderingComposer get menuItemId {
    final $$MenuItemsTableOrderingComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableOrderingComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get quantity =>
      $composableBuilder(column: $table.quantity, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<double> get lineTotal =>
      $composableBuilder(column: $table.lineTotal, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);

  $$OrdersTableAnnotationComposer get orderId {
    final $$OrdersTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.orderId,
        referencedTable: $db.orders,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$OrdersTableAnnotationComposer(
              $db: $db,
              $table: $db.orders,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }

  $$MenuItemsTableAnnotationComposer get menuItemId {
    final $$MenuItemsTableAnnotationComposer composer = $composerBuilder(
        composer: this,
        getCurrentColumn: (t) => t.menuItemId,
        referencedTable: $db.menuItems,
        getReferencedColumn: (t) => t.id,
        builder: (joinBuilder,
                {$addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer}) =>
            $$MenuItemsTableAnnotationComposer(
              $db: $db,
              $table: $db.menuItems,
              $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
              joinBuilder: joinBuilder,
              $removeJoinBuilderFromRootComposer:
                  $removeJoinBuilderFromRootComposer,
            ));
    return composer;
  }
}

class $$OrderItemsTableTableManager extends RootTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool menuItemId})> {
  $$OrderItemsTableTableManager(_$AppDatabase db, $OrderItemsTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$OrderItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$OrderItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$OrderItemsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<int> orderId = const Value.absent(),
            Value<int> menuItemId = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<String?> notes = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            quantity: quantity,
            price: price,
            lineTotal: lineTotal,
            notes: notes,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required int orderId,
            required int menuItemId,
            required int quantity,
            required double price,
            required double lineTotal,
            Value<String?> notes = const Value.absent(),
            required int createdAtEpoch,
            required int updatedAtEpoch,
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            quantity: quantity,
            price: price,
            lineTotal: lineTotal,
            notes: notes,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (
                    e.readTable(table),
                    $$OrderItemsTableReferences(db, table, e)
                  ))
              .toList(),
          prefetchHooksCallback: ({orderId = false, menuItemId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins: <
                  T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic>>(state) {
                if (orderId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.orderId,
                    referencedTable:
                        $$OrderItemsTableReferences._orderIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._orderIdTable(db).id,
                  ) as T;
                }
                if (menuItemId) {
                  state = state.withJoin(
                    currentTable: table,
                    currentColumn: table.menuItemId,
                    referencedTable:
                        $$OrderItemsTableReferences._menuItemIdTable(db),
                    referencedColumn:
                        $$OrderItemsTableReferences._menuItemIdTable(db).id,
                  ) as T;
                }

                return state;
              },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ));
}

typedef $$OrderItemsTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $OrderItemsTable,
    OrderItem,
    $$OrderItemsTableFilterComposer,
    $$OrderItemsTableOrderingComposer,
    $$OrderItemsTableAnnotationComposer,
    $$OrderItemsTableCreateCompanionBuilder,
    $$OrderItemsTableUpdateCompanionBuilder,
    (OrderItem, $$OrderItemsTableReferences),
    OrderItem,
    PrefetchHooks Function({bool orderId, bool menuItemId})>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
}
