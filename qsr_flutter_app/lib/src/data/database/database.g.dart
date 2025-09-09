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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _categoryMeta =
      const VerificationMeta('category');
  @override
  late final GeneratedColumn<String> category = GeneratedColumn<String>(
      'category', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('General'));
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
  List<GeneratedColumn> get $columns => [
        id,
        name,
        price,
        category,
        isAvailable,
        createdAtEpoch,
        updatedAtEpoch,
        isDirty
      ];
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
    }
    if (data.containsKey('category')) {
      context.handle(_categoryMeta,
          category.isAcceptableOrUnknown(data['category']!, _categoryMeta));
    }
    if (data.containsKey('is_available')) {
      context.handle(
          _isAvailableMeta,
          isAvailable.isAcceptableOrUnknown(
              data['is_available']!, _isAvailableMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      category: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}category'])!,
      isAvailable: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_available'])!,
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
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
  final String id;
  final String name;
  final double price;
  final String category;
  final bool isAvailable;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  final bool isDirty;
  const MenuItem(
      {required this.id,
      required this.name,
      required this.price,
      required this.category,
      required this.isAvailable,
      required this.createdAtEpoch,
      required this.updatedAtEpoch,
      required this.isDirty});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['price'] = Variable<double>(price);
    map['category'] = Variable<String>(category);
    map['is_available'] = Variable<bool>(isAvailable);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    map['is_dirty'] = Variable<bool>(isDirty);
    return map;
  }

  MenuItemsCompanion toCompanion(bool nullToAbsent) {
    return MenuItemsCompanion(
      id: Value(id),
      name: Value(name),
      price: Value(price),
      category: Value(category),
      isAvailable: Value(isAvailable),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
      isDirty: Value(isDirty),
    );
  }

  factory MenuItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuItem(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      price: serializer.fromJson<double>(json['price']),
      category: serializer.fromJson<String>(json['category']),
      isAvailable: serializer.fromJson<bool>(json['isAvailable']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'price': serializer.toJson<double>(price),
      'category': serializer.toJson<String>(category),
      'isAvailable': serializer.toJson<bool>(isAvailable),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
      'isDirty': serializer.toJson<bool>(isDirty),
    };
  }

  MenuItem copyWith(
          {String? id,
          String? name,
          double? price,
          String? category,
          bool? isAvailable,
          int? createdAtEpoch,
          int? updatedAtEpoch,
          bool? isDirty}) =>
      MenuItem(
        id: id ?? this.id,
        name: name ?? this.name,
        price: price ?? this.price,
        category: category ?? this.category,
        isAvailable: isAvailable ?? this.isAvailable,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
        isDirty: isDirty ?? this.isDirty,
      );
  MenuItem copyWithCompanion(MenuItemsCompanion data) {
    return MenuItem(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      price: data.price.present ? data.price.value : this.price,
      category: data.category.present ? data.category.value : this.category,
      isAvailable:
          data.isAvailable.present ? data.isAvailable.value : this.isAvailable,
      createdAtEpoch: data.createdAtEpoch.present
          ? data.createdAtEpoch.value
          : this.createdAtEpoch,
      updatedAtEpoch: data.updatedAtEpoch.present
          ? data.updatedAtEpoch.value
          : this.updatedAtEpoch,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuItem(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('isDirty: $isDirty')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, price, category, isAvailable,
      createdAtEpoch, updatedAtEpoch, isDirty);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuItem &&
          other.id == this.id &&
          other.name == this.name &&
          other.price == this.price &&
          other.category == this.category &&
          other.isAvailable == this.isAvailable &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch &&
          other.isDirty == this.isDirty);
}

class MenuItemsCompanion extends UpdateCompanion<MenuItem> {
  final Value<String> id;
  final Value<String> name;
  final Value<double> price;
  final Value<String> category;
  final Value<bool> isAvailable;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  final Value<bool> isDirty;
  final Value<int> rowid;
  const MenuItemsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.isAvailable = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MenuItemsCompanion.insert({
    this.id = const Value.absent(),
    required String name,
    this.price = const Value.absent(),
    this.category = const Value.absent(),
    this.isAvailable = const Value.absent(),
    required int createdAtEpoch,
    required int updatedAtEpoch,
    this.isDirty = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : name = Value(name),
        createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch);
  static Insertable<MenuItem> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<double>? price,
    Expression<String>? category,
    Expression<bool>? isAvailable,
    Expression<int>? createdAtEpoch,
    Expression<int>? updatedAtEpoch,
    Expression<bool>? isDirty,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (price != null) 'price': price,
      if (category != null) 'category': category,
      if (isAvailable != null) 'is_available': isAvailable,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
      if (isDirty != null) 'is_dirty': isDirty,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MenuItemsCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<double>? price,
      Value<String>? category,
      Value<bool>? isAvailable,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch,
      Value<bool>? isDirty,
      Value<int>? rowid}) {
    return MenuItemsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      category: category ?? this.category,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      isDirty: isDirty ?? this.isDirty,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (price.present) {
      map['price'] = Variable<double>(price.value);
    }
    if (category.present) {
      map['category'] = Variable<String>(category.value);
    }
    if (isAvailable.present) {
      map['is_available'] = Variable<bool>(isAvailable.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuItemsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('price: $price, ')
          ..write('category: $category, ')
          ..write('isAvailable: $isAvailable, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('isDirty: $isDirty, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _orderTypeMeta =
      const VerificationMeta('orderType');
  @override
  late final GeneratedColumn<String> orderType = GeneratedColumn<String>(
      'order_type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('dine-in'));
  static const VerificationMeta _tokenMeta = const VerificationMeta('token');
  @override
  late final GeneratedColumn<String> token = GeneratedColumn<String>(
      'token', aliasedName, true,
      type: DriftSqlType.string, requiredDuringInsert: false);
  static const VerificationMeta _statusMeta = const VerificationMeta('status');
  @override
  late final GeneratedColumn<String> status = GeneratedColumn<String>(
      'status', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('open'));
  static const VerificationMeta _subtotalMeta =
      const VerificationMeta('subtotal');
  @override
  late final GeneratedColumn<double> subtotal = GeneratedColumn<double>(
      'subtotal', aliasedName, false,
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
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
      type: DriftSqlType.double,
      requiredDuringInsert: false,
      defaultValue: const Constant(0.0));
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
  static const VerificationMeta _serverMeta = const VerificationMeta('server');
  @override
  late final GeneratedColumn<String> server = GeneratedColumn<String>(
      'server', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('Staff'));
  static const VerificationMeta _deviceIdMeta =
      const VerificationMeta('deviceId');
  @override
  late final GeneratedColumn<String> deviceId = GeneratedColumn<String>(
      'device_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('device-001'));
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
  static const VerificationMeta _kotPrintedMeta =
      const VerificationMeta('kotPrinted');
  @override
  late final GeneratedColumn<bool> kotPrinted = GeneratedColumn<bool>(
      'kot_printed', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('CHECK ("kot_printed" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        orderType,
        token,
        status,
        subtotal,
        discount,
        tax,
        total,
        notes,
        server,
        deviceId,
        createdAtEpoch,
        updatedAtEpoch,
        isDirty,
        kotPrinted
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
    if (data.containsKey('order_type')) {
      context.handle(_orderTypeMeta,
          orderType.isAcceptableOrUnknown(data['order_type']!, _orderTypeMeta));
    }
    if (data.containsKey('token')) {
      context.handle(
          _tokenMeta, token.isAcceptableOrUnknown(data['token']!, _tokenMeta));
    }
    if (data.containsKey('status')) {
      context.handle(_statusMeta,
          status.isAcceptableOrUnknown(data['status']!, _statusMeta));
    }
    if (data.containsKey('subtotal')) {
      context.handle(_subtotalMeta,
          subtotal.isAcceptableOrUnknown(data['subtotal']!, _subtotalMeta));
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
    }
    if (data.containsKey('notes')) {
      context.handle(
          _notesMeta, notes.isAcceptableOrUnknown(data['notes']!, _notesMeta));
    }
    if (data.containsKey('server')) {
      context.handle(_serverMeta,
          server.isAcceptableOrUnknown(data['server']!, _serverMeta));
    }
    if (data.containsKey('device_id')) {
      context.handle(_deviceIdMeta,
          deviceId.isAcceptableOrUnknown(data['device_id']!, _deviceIdMeta));
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
    if (data.containsKey('is_dirty')) {
      context.handle(_isDirtyMeta,
          isDirty.isAcceptableOrUnknown(data['is_dirty']!, _isDirtyMeta));
    }
    if (data.containsKey('kot_printed')) {
      context.handle(
          _kotPrintedMeta,
          kotPrinted.isAcceptableOrUnknown(
              data['kot_printed']!, _kotPrintedMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      orderType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}order_type'])!,
      token: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}token']),
      status: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}status'])!,
      subtotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}subtotal'])!,
      discount: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}discount'])!,
      tax: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}tax'])!,
      total: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
      server: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}server'])!,
      deviceId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}device_id'])!,
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
      isDirty: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_dirty'])!,
      kotPrinted: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}kot_printed'])!,
    );
  }

  @override
  $OrdersTable createAlias(String alias) {
    return $OrdersTable(attachedDatabase, alias);
  }
}

class Order extends DataClass implements Insertable<Order> {
  final String id;
  final String orderType;
  final String? token;
  final String status;
  final double subtotal;
  final double discount;
  final double tax;
  final double total;
  final String notes;
  final String server;
  final String deviceId;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  final bool isDirty;
  final bool kotPrinted;
  const Order(
      {required this.id,
      required this.orderType,
      this.token,
      required this.status,
      required this.subtotal,
      required this.discount,
      required this.tax,
      required this.total,
      required this.notes,
      required this.server,
      required this.deviceId,
      required this.createdAtEpoch,
      required this.updatedAtEpoch,
      required this.isDirty,
      required this.kotPrinted});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['order_type'] = Variable<String>(orderType);
    if (!nullToAbsent || token != null) {
      map['token'] = Variable<String>(token);
    }
    map['status'] = Variable<String>(status);
    map['subtotal'] = Variable<double>(subtotal);
    map['discount'] = Variable<double>(discount);
    map['tax'] = Variable<double>(tax);
    map['total'] = Variable<double>(total);
    map['notes'] = Variable<String>(notes);
    map['server'] = Variable<String>(server);
    map['device_id'] = Variable<String>(deviceId);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    map['is_dirty'] = Variable<bool>(isDirty);
    map['kot_printed'] = Variable<bool>(kotPrinted);
    return map;
  }

  OrdersCompanion toCompanion(bool nullToAbsent) {
    return OrdersCompanion(
      id: Value(id),
      orderType: Value(orderType),
      token:
          token == null && nullToAbsent ? const Value.absent() : Value(token),
      status: Value(status),
      subtotal: Value(subtotal),
      discount: Value(discount),
      tax: Value(tax),
      total: Value(total),
      notes: Value(notes),
      server: Value(server),
      deviceId: Value(deviceId),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
      isDirty: Value(isDirty),
      kotPrinted: Value(kotPrinted),
    );
  }

  factory Order.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Order(
      id: serializer.fromJson<String>(json['id']),
      orderType: serializer.fromJson<String>(json['orderType']),
      token: serializer.fromJson<String?>(json['token']),
      status: serializer.fromJson<String>(json['status']),
      subtotal: serializer.fromJson<double>(json['subtotal']),
      discount: serializer.fromJson<double>(json['discount']),
      tax: serializer.fromJson<double>(json['tax']),
      total: serializer.fromJson<double>(json['total']),
      notes: serializer.fromJson<String>(json['notes']),
      server: serializer.fromJson<String>(json['server']),
      deviceId: serializer.fromJson<String>(json['deviceId']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
      isDirty: serializer.fromJson<bool>(json['isDirty']),
      kotPrinted: serializer.fromJson<bool>(json['kotPrinted']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'orderType': serializer.toJson<String>(orderType),
      'token': serializer.toJson<String?>(token),
      'status': serializer.toJson<String>(status),
      'subtotal': serializer.toJson<double>(subtotal),
      'discount': serializer.toJson<double>(discount),
      'tax': serializer.toJson<double>(tax),
      'total': serializer.toJson<double>(total),
      'notes': serializer.toJson<String>(notes),
      'server': serializer.toJson<String>(server),
      'deviceId': serializer.toJson<String>(deviceId),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
      'isDirty': serializer.toJson<bool>(isDirty),
      'kotPrinted': serializer.toJson<bool>(kotPrinted),
    };
  }

  Order copyWith(
          {String? id,
          String? orderType,
          Value<String?> token = const Value.absent(),
          String? status,
          double? subtotal,
          double? discount,
          double? tax,
          double? total,
          String? notes,
          String? server,
          String? deviceId,
          int? createdAtEpoch,
          int? updatedAtEpoch,
          bool? isDirty,
          bool? kotPrinted}) =>
      Order(
        id: id ?? this.id,
        orderType: orderType ?? this.orderType,
        token: token.present ? token.value : this.token,
        status: status ?? this.status,
        subtotal: subtotal ?? this.subtotal,
        discount: discount ?? this.discount,
        tax: tax ?? this.tax,
        total: total ?? this.total,
        notes: notes ?? this.notes,
        server: server ?? this.server,
        deviceId: deviceId ?? this.deviceId,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
        isDirty: isDirty ?? this.isDirty,
        kotPrinted: kotPrinted ?? this.kotPrinted,
      );
  Order copyWithCompanion(OrdersCompanion data) {
    return Order(
      id: data.id.present ? data.id.value : this.id,
      orderType: data.orderType.present ? data.orderType.value : this.orderType,
      token: data.token.present ? data.token.value : this.token,
      status: data.status.present ? data.status.value : this.status,
      subtotal: data.subtotal.present ? data.subtotal.value : this.subtotal,
      discount: data.discount.present ? data.discount.value : this.discount,
      tax: data.tax.present ? data.tax.value : this.tax,
      total: data.total.present ? data.total.value : this.total,
      notes: data.notes.present ? data.notes.value : this.notes,
      server: data.server.present ? data.server.value : this.server,
      deviceId: data.deviceId.present ? data.deviceId.value : this.deviceId,
      createdAtEpoch: data.createdAtEpoch.present
          ? data.createdAtEpoch.value
          : this.createdAtEpoch,
      updatedAtEpoch: data.updatedAtEpoch.present
          ? data.updatedAtEpoch.value
          : this.updatedAtEpoch,
      isDirty: data.isDirty.present ? data.isDirty.value : this.isDirty,
      kotPrinted:
          data.kotPrinted.present ? data.kotPrinted.value : this.kotPrinted,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Order(')
          ..write('id: $id, ')
          ..write('orderType: $orderType, ')
          ..write('token: $token, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('notes: $notes, ')
          ..write('server: $server, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('isDirty: $isDirty, ')
          ..write('kotPrinted: $kotPrinted')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
      id,
      orderType,
      token,
      status,
      subtotal,
      discount,
      tax,
      total,
      notes,
      server,
      deviceId,
      createdAtEpoch,
      updatedAtEpoch,
      isDirty,
      kotPrinted);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Order &&
          other.id == this.id &&
          other.orderType == this.orderType &&
          other.token == this.token &&
          other.status == this.status &&
          other.subtotal == this.subtotal &&
          other.discount == this.discount &&
          other.tax == this.tax &&
          other.total == this.total &&
          other.notes == this.notes &&
          other.server == this.server &&
          other.deviceId == this.deviceId &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch &&
          other.isDirty == this.isDirty &&
          other.kotPrinted == this.kotPrinted);
}

class OrdersCompanion extends UpdateCompanion<Order> {
  final Value<String> id;
  final Value<String> orderType;
  final Value<String?> token;
  final Value<String> status;
  final Value<double> subtotal;
  final Value<double> discount;
  final Value<double> tax;
  final Value<double> total;
  final Value<String> notes;
  final Value<String> server;
  final Value<String> deviceId;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  final Value<bool> isDirty;
  final Value<bool> kotPrinted;
  final Value<int> rowid;
  const OrdersCompanion({
    this.id = const Value.absent(),
    this.orderType = const Value.absent(),
    this.token = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.notes = const Value.absent(),
    this.server = const Value.absent(),
    this.deviceId = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
    this.isDirty = const Value.absent(),
    this.kotPrinted = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  OrdersCompanion.insert({
    this.id = const Value.absent(),
    this.orderType = const Value.absent(),
    this.token = const Value.absent(),
    this.status = const Value.absent(),
    this.subtotal = const Value.absent(),
    this.discount = const Value.absent(),
    this.tax = const Value.absent(),
    this.total = const Value.absent(),
    this.notes = const Value.absent(),
    this.server = const Value.absent(),
    this.deviceId = const Value.absent(),
    required int createdAtEpoch,
    required int updatedAtEpoch,
    this.isDirty = const Value.absent(),
    this.kotPrinted = const Value.absent(),
    this.rowid = const Value.absent(),
  })  : createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch);
  static Insertable<Order> custom({
    Expression<String>? id,
    Expression<String>? orderType,
    Expression<String>? token,
    Expression<String>? status,
    Expression<double>? subtotal,
    Expression<double>? discount,
    Expression<double>? tax,
    Expression<double>? total,
    Expression<String>? notes,
    Expression<String>? server,
    Expression<String>? deviceId,
    Expression<int>? createdAtEpoch,
    Expression<int>? updatedAtEpoch,
    Expression<bool>? isDirty,
    Expression<bool>? kotPrinted,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (orderType != null) 'order_type': orderType,
      if (token != null) 'token': token,
      if (status != null) 'status': status,
      if (subtotal != null) 'subtotal': subtotal,
      if (discount != null) 'discount': discount,
      if (tax != null) 'tax': tax,
      if (total != null) 'total': total,
      if (notes != null) 'notes': notes,
      if (server != null) 'server': server,
      if (deviceId != null) 'device_id': deviceId,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
      if (isDirty != null) 'is_dirty': isDirty,
      if (kotPrinted != null) 'kot_printed': kotPrinted,
      if (rowid != null) 'rowid': rowid,
    });
  }

  OrdersCompanion copyWith(
      {Value<String>? id,
      Value<String>? orderType,
      Value<String?>? token,
      Value<String>? status,
      Value<double>? subtotal,
      Value<double>? discount,
      Value<double>? tax,
      Value<double>? total,
      Value<String>? notes,
      Value<String>? server,
      Value<String>? deviceId,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch,
      Value<bool>? isDirty,
      Value<bool>? kotPrinted,
      Value<int>? rowid}) {
    return OrdersCompanion(
      id: id ?? this.id,
      orderType: orderType ?? this.orderType,
      token: token ?? this.token,
      status: status ?? this.status,
      subtotal: subtotal ?? this.subtotal,
      discount: discount ?? this.discount,
      tax: tax ?? this.tax,
      total: total ?? this.total,
      notes: notes ?? this.notes,
      server: server ?? this.server,
      deviceId: deviceId ?? this.deviceId,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      isDirty: isDirty ?? this.isDirty,
      kotPrinted: kotPrinted ?? this.kotPrinted,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (orderType.present) {
      map['order_type'] = Variable<String>(orderType.value);
    }
    if (token.present) {
      map['token'] = Variable<String>(token.value);
    }
    if (status.present) {
      map['status'] = Variable<String>(status.value);
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
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (server.present) {
      map['server'] = Variable<String>(server.value);
    }
    if (deviceId.present) {
      map['device_id'] = Variable<String>(deviceId.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    if (isDirty.present) {
      map['is_dirty'] = Variable<bool>(isDirty.value);
    }
    if (kotPrinted.present) {
      map['kot_printed'] = Variable<bool>(kotPrinted.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('OrdersCompanion(')
          ..write('id: $id, ')
          ..write('orderType: $orderType, ')
          ..write('token: $token, ')
          ..write('status: $status, ')
          ..write('subtotal: $subtotal, ')
          ..write('discount: $discount, ')
          ..write('tax: $tax, ')
          ..write('total: $total, ')
          ..write('notes: $notes, ')
          ..write('server: $server, ')
          ..write('deviceId: $deviceId, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('isDirty: $isDirty, ')
          ..write('kotPrinted: $kotPrinted, ')
          ..write('rowid: $rowid')
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
  late final GeneratedColumn<String> orderId = GeneratedColumn<String>(
      'order_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES orders (id) ON DELETE CASCADE'));
  static const VerificationMeta _menuItemIdMeta =
      const VerificationMeta('menuItemId');
  @override
  late final GeneratedColumn<String> menuItemId = GeneratedColumn<String>(
      'menu_item_id', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: true,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES menu_items (id) ON DELETE RESTRICT'));
  static const VerificationMeta _menuItemNameMeta =
      const VerificationMeta('menuItemName');
  @override
  late final GeneratedColumn<String> menuItemName = GeneratedColumn<String>(
      'menu_item_name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _quantityMeta =
      const VerificationMeta('quantity');
  @override
  late final GeneratedColumn<int> quantity = GeneratedColumn<int>(
      'quantity', aliasedName, false,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultValue: const Constant(1));
  static const VerificationMeta _priceMeta = const VerificationMeta('price');
  @override
  late final GeneratedColumn<double> price = GeneratedColumn<double>(
      'price', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _lineTotalMeta =
      const VerificationMeta('lineTotal');
  @override
  late final GeneratedColumn<double> lineTotal = GeneratedColumn<double>(
      'line_total', aliasedName, false,
      type: DriftSqlType.double, requiredDuringInsert: true);
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
      'notes', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant(''));
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
        menuItemName,
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
    if (data.containsKey('menu_item_name')) {
      context.handle(
          _menuItemNameMeta,
          menuItemName.isAcceptableOrUnknown(
              data['menu_item_name']!, _menuItemNameMeta));
    } else if (isInserting) {
      context.missing(_menuItemNameMeta);
    }
    if (data.containsKey('quantity')) {
      context.handle(_quantityMeta,
          quantity.isAcceptableOrUnknown(data['quantity']!, _quantityMeta));
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
          .read(DriftSqlType.string, data['${effectivePrefix}order_id'])!,
      menuItemId: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}menu_item_id'])!,
      menuItemName: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}menu_item_name'])!,
      quantity: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}quantity'])!,
      price: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}price'])!,
      lineTotal: attachedDatabase.typeMapping
          .read(DriftSqlType.double, data['${effectivePrefix}line_total'])!,
      notes: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}notes'])!,
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
  final String orderId;
  final String menuItemId;
  final String menuItemName;
  final int quantity;
  final double price;
  final double lineTotal;
  final String notes;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  const OrderItem(
      {required this.id,
      required this.orderId,
      required this.menuItemId,
      required this.menuItemName,
      required this.quantity,
      required this.price,
      required this.lineTotal,
      required this.notes,
      required this.createdAtEpoch,
      required this.updatedAtEpoch});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['order_id'] = Variable<String>(orderId);
    map['menu_item_id'] = Variable<String>(menuItemId);
    map['menu_item_name'] = Variable<String>(menuItemName);
    map['quantity'] = Variable<int>(quantity);
    map['price'] = Variable<double>(price);
    map['line_total'] = Variable<double>(lineTotal);
    map['notes'] = Variable<String>(notes);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    return map;
  }

  OrderItemsCompanion toCompanion(bool nullToAbsent) {
    return OrderItemsCompanion(
      id: Value(id),
      orderId: Value(orderId),
      menuItemId: Value(menuItemId),
      menuItemName: Value(menuItemName),
      quantity: Value(quantity),
      price: Value(price),
      lineTotal: Value(lineTotal),
      notes: Value(notes),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
    );
  }

  factory OrderItem.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return OrderItem(
      id: serializer.fromJson<int>(json['id']),
      orderId: serializer.fromJson<String>(json['orderId']),
      menuItemId: serializer.fromJson<String>(json['menuItemId']),
      menuItemName: serializer.fromJson<String>(json['menuItemName']),
      quantity: serializer.fromJson<int>(json['quantity']),
      price: serializer.fromJson<double>(json['price']),
      lineTotal: serializer.fromJson<double>(json['lineTotal']),
      notes: serializer.fromJson<String>(json['notes']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'orderId': serializer.toJson<String>(orderId),
      'menuItemId': serializer.toJson<String>(menuItemId),
      'menuItemName': serializer.toJson<String>(menuItemName),
      'quantity': serializer.toJson<int>(quantity),
      'price': serializer.toJson<double>(price),
      'lineTotal': serializer.toJson<double>(lineTotal),
      'notes': serializer.toJson<String>(notes),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
    };
  }

  OrderItem copyWith(
          {int? id,
          String? orderId,
          String? menuItemId,
          String? menuItemName,
          int? quantity,
          double? price,
          double? lineTotal,
          String? notes,
          int? createdAtEpoch,
          int? updatedAtEpoch}) =>
      OrderItem(
        id: id ?? this.id,
        orderId: orderId ?? this.orderId,
        menuItemId: menuItemId ?? this.menuItemId,
        menuItemName: menuItemName ?? this.menuItemName,
        quantity: quantity ?? this.quantity,
        price: price ?? this.price,
        lineTotal: lineTotal ?? this.lineTotal,
        notes: notes ?? this.notes,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      );
  OrderItem copyWithCompanion(OrderItemsCompanion data) {
    return OrderItem(
      id: data.id.present ? data.id.value : this.id,
      orderId: data.orderId.present ? data.orderId.value : this.orderId,
      menuItemId:
          data.menuItemId.present ? data.menuItemId.value : this.menuItemId,
      menuItemName: data.menuItemName.present
          ? data.menuItemName.value
          : this.menuItemName,
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
          ..write('menuItemName: $menuItemName, ')
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
  int get hashCode => Object.hash(id, orderId, menuItemId, menuItemName,
      quantity, price, lineTotal, notes, createdAtEpoch, updatedAtEpoch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is OrderItem &&
          other.id == this.id &&
          other.orderId == this.orderId &&
          other.menuItemId == this.menuItemId &&
          other.menuItemName == this.menuItemName &&
          other.quantity == this.quantity &&
          other.price == this.price &&
          other.lineTotal == this.lineTotal &&
          other.notes == this.notes &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch);
}

class OrderItemsCompanion extends UpdateCompanion<OrderItem> {
  final Value<int> id;
  final Value<String> orderId;
  final Value<String> menuItemId;
  final Value<String> menuItemName;
  final Value<int> quantity;
  final Value<double> price;
  final Value<double> lineTotal;
  final Value<String> notes;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  const OrderItemsCompanion({
    this.id = const Value.absent(),
    this.orderId = const Value.absent(),
    this.menuItemId = const Value.absent(),
    this.menuItemName = const Value.absent(),
    this.quantity = const Value.absent(),
    this.price = const Value.absent(),
    this.lineTotal = const Value.absent(),
    this.notes = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
  });
  OrderItemsCompanion.insert({
    this.id = const Value.absent(),
    required String orderId,
    required String menuItemId,
    required String menuItemName,
    this.quantity = const Value.absent(),
    required double price,
    required double lineTotal,
    this.notes = const Value.absent(),
    required int createdAtEpoch,
    required int updatedAtEpoch,
  })  : orderId = Value(orderId),
        menuItemId = Value(menuItemId),
        menuItemName = Value(menuItemName),
        price = Value(price),
        lineTotal = Value(lineTotal),
        createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch);
  static Insertable<OrderItem> custom({
    Expression<int>? id,
    Expression<String>? orderId,
    Expression<String>? menuItemId,
    Expression<String>? menuItemName,
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
      if (menuItemName != null) 'menu_item_name': menuItemName,
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
      Value<String>? orderId,
      Value<String>? menuItemId,
      Value<String>? menuItemName,
      Value<int>? quantity,
      Value<double>? price,
      Value<double>? lineTotal,
      Value<String>? notes,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch}) {
    return OrderItemsCompanion(
      id: id ?? this.id,
      orderId: orderId ?? this.orderId,
      menuItemId: menuItemId ?? this.menuItemId,
      menuItemName: menuItemName ?? this.menuItemName,
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
      map['order_id'] = Variable<String>(orderId.value);
    }
    if (menuItemId.present) {
      map['menu_item_id'] = Variable<String>(menuItemId.value);
    }
    if (menuItemName.present) {
      map['menu_item_name'] = Variable<String>(menuItemName.value);
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
          ..write('menuItemName: $menuItemName, ')
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

class $DevicesTable extends Devices with TableInfo<$DevicesTable, Device> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DevicesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
      'id', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
      'name', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
      'type', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('bluetooth'));
  static const VerificationMeta _addressMeta =
      const VerificationMeta('address');
  @override
  late final GeneratedColumn<String> address = GeneratedColumn<String>(
      'address', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isLastUsedMeta =
      const VerificationMeta('isLastUsed');
  @override
  late final GeneratedColumn<bool> isLastUsed = GeneratedColumn<bool>(
      'is_last_used', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("is_last_used" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _lastConnectedEpochMeta =
      const VerificationMeta('lastConnectedEpoch');
  @override
  late final GeneratedColumn<int> lastConnectedEpoch = GeneratedColumn<int>(
      'last_connected_epoch', aliasedName, true,
      type: DriftSqlType.int, requiredDuringInsert: false);
  static const VerificationMeta _capabilitiesMeta =
      const VerificationMeta('capabilities');
  @override
  late final GeneratedColumn<String> capabilities = GeneratedColumn<String>(
      'capabilities', aliasedName, false,
      type: DriftSqlType.string,
      requiredDuringInsert: false,
      defaultValue: const Constant('58mm'));
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
        name,
        type,
        address,
        isLastUsed,
        lastConnectedEpoch,
        capabilities,
        createdAtEpoch,
        updatedAtEpoch
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'devices';
  @override
  VerificationContext validateIntegrity(Insertable<Device> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
          _nameMeta, name.isAcceptableOrUnknown(data['name']!, _nameMeta));
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
          _typeMeta, type.isAcceptableOrUnknown(data['type']!, _typeMeta));
    }
    if (data.containsKey('address')) {
      context.handle(_addressMeta,
          address.isAcceptableOrUnknown(data['address']!, _addressMeta));
    } else if (isInserting) {
      context.missing(_addressMeta);
    }
    if (data.containsKey('is_last_used')) {
      context.handle(
          _isLastUsedMeta,
          isLastUsed.isAcceptableOrUnknown(
              data['is_last_used']!, _isLastUsedMeta));
    }
    if (data.containsKey('last_connected_epoch')) {
      context.handle(
          _lastConnectedEpochMeta,
          lastConnectedEpoch.isAcceptableOrUnknown(
              data['last_connected_epoch']!, _lastConnectedEpochMeta));
    }
    if (data.containsKey('capabilities')) {
      context.handle(
          _capabilitiesMeta,
          capabilities.isAcceptableOrUnknown(
              data['capabilities']!, _capabilitiesMeta));
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
  Device map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Device(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}id'])!,
      name: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}name'])!,
      type: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}type'])!,
      address: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}address'])!,
      isLastUsed: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}is_last_used'])!,
      lastConnectedEpoch: attachedDatabase.typeMapping.read(
          DriftSqlType.int, data['${effectivePrefix}last_connected_epoch']),
      capabilities: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}capabilities'])!,
      createdAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}created_at_epoch'])!,
      updatedAtEpoch: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}updated_at_epoch'])!,
    );
  }

  @override
  $DevicesTable createAlias(String alias) {
    return $DevicesTable(attachedDatabase, alias);
  }
}

class Device extends DataClass implements Insertable<Device> {
  final String id;
  final String name;
  final String type;
  final String address;
  final bool isLastUsed;
  final int? lastConnectedEpoch;
  final String capabilities;
  final int createdAtEpoch;
  final int updatedAtEpoch;
  const Device(
      {required this.id,
      required this.name,
      required this.type,
      required this.address,
      required this.isLastUsed,
      this.lastConnectedEpoch,
      required this.capabilities,
      required this.createdAtEpoch,
      required this.updatedAtEpoch});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['type'] = Variable<String>(type);
    map['address'] = Variable<String>(address);
    map['is_last_used'] = Variable<bool>(isLastUsed);
    if (!nullToAbsent || lastConnectedEpoch != null) {
      map['last_connected_epoch'] = Variable<int>(lastConnectedEpoch);
    }
    map['capabilities'] = Variable<String>(capabilities);
    map['created_at_epoch'] = Variable<int>(createdAtEpoch);
    map['updated_at_epoch'] = Variable<int>(updatedAtEpoch);
    return map;
  }

  DevicesCompanion toCompanion(bool nullToAbsent) {
    return DevicesCompanion(
      id: Value(id),
      name: Value(name),
      type: Value(type),
      address: Value(address),
      isLastUsed: Value(isLastUsed),
      lastConnectedEpoch: lastConnectedEpoch == null && nullToAbsent
          ? const Value.absent()
          : Value(lastConnectedEpoch),
      capabilities: Value(capabilities),
      createdAtEpoch: Value(createdAtEpoch),
      updatedAtEpoch: Value(updatedAtEpoch),
    );
  }

  factory Device.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Device(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      type: serializer.fromJson<String>(json['type']),
      address: serializer.fromJson<String>(json['address']),
      isLastUsed: serializer.fromJson<bool>(json['isLastUsed']),
      lastConnectedEpoch: serializer.fromJson<int?>(json['lastConnectedEpoch']),
      capabilities: serializer.fromJson<String>(json['capabilities']),
      createdAtEpoch: serializer.fromJson<int>(json['createdAtEpoch']),
      updatedAtEpoch: serializer.fromJson<int>(json['updatedAtEpoch']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'type': serializer.toJson<String>(type),
      'address': serializer.toJson<String>(address),
      'isLastUsed': serializer.toJson<bool>(isLastUsed),
      'lastConnectedEpoch': serializer.toJson<int?>(lastConnectedEpoch),
      'capabilities': serializer.toJson<String>(capabilities),
      'createdAtEpoch': serializer.toJson<int>(createdAtEpoch),
      'updatedAtEpoch': serializer.toJson<int>(updatedAtEpoch),
    };
  }

  Device copyWith(
          {String? id,
          String? name,
          String? type,
          String? address,
          bool? isLastUsed,
          Value<int?> lastConnectedEpoch = const Value.absent(),
          String? capabilities,
          int? createdAtEpoch,
          int? updatedAtEpoch}) =>
      Device(
        id: id ?? this.id,
        name: name ?? this.name,
        type: type ?? this.type,
        address: address ?? this.address,
        isLastUsed: isLastUsed ?? this.isLastUsed,
        lastConnectedEpoch: lastConnectedEpoch.present
            ? lastConnectedEpoch.value
            : this.lastConnectedEpoch,
        capabilities: capabilities ?? this.capabilities,
        createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
        updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      );
  Device copyWithCompanion(DevicesCompanion data) {
    return Device(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      type: data.type.present ? data.type.value : this.type,
      address: data.address.present ? data.address.value : this.address,
      isLastUsed:
          data.isLastUsed.present ? data.isLastUsed.value : this.isLastUsed,
      lastConnectedEpoch: data.lastConnectedEpoch.present
          ? data.lastConnectedEpoch.value
          : this.lastConnectedEpoch,
      capabilities: data.capabilities.present
          ? data.capabilities.value
          : this.capabilities,
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
    return (StringBuffer('Device(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('isLastUsed: $isLastUsed, ')
          ..write('lastConnectedEpoch: $lastConnectedEpoch, ')
          ..write('capabilities: $capabilities, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, type, address, isLastUsed,
      lastConnectedEpoch, capabilities, createdAtEpoch, updatedAtEpoch);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Device &&
          other.id == this.id &&
          other.name == this.name &&
          other.type == this.type &&
          other.address == this.address &&
          other.isLastUsed == this.isLastUsed &&
          other.lastConnectedEpoch == this.lastConnectedEpoch &&
          other.capabilities == this.capabilities &&
          other.createdAtEpoch == this.createdAtEpoch &&
          other.updatedAtEpoch == this.updatedAtEpoch);
}

class DevicesCompanion extends UpdateCompanion<Device> {
  final Value<String> id;
  final Value<String> name;
  final Value<String> type;
  final Value<String> address;
  final Value<bool> isLastUsed;
  final Value<int?> lastConnectedEpoch;
  final Value<String> capabilities;
  final Value<int> createdAtEpoch;
  final Value<int> updatedAtEpoch;
  final Value<int> rowid;
  const DevicesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.type = const Value.absent(),
    this.address = const Value.absent(),
    this.isLastUsed = const Value.absent(),
    this.lastConnectedEpoch = const Value.absent(),
    this.capabilities = const Value.absent(),
    this.createdAtEpoch = const Value.absent(),
    this.updatedAtEpoch = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DevicesCompanion.insert({
    required String id,
    required String name,
    this.type = const Value.absent(),
    required String address,
    this.isLastUsed = const Value.absent(),
    this.lastConnectedEpoch = const Value.absent(),
    this.capabilities = const Value.absent(),
    required int createdAtEpoch,
    required int updatedAtEpoch,
    this.rowid = const Value.absent(),
  })  : id = Value(id),
        name = Value(name),
        address = Value(address),
        createdAtEpoch = Value(createdAtEpoch),
        updatedAtEpoch = Value(updatedAtEpoch);
  static Insertable<Device> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? type,
    Expression<String>? address,
    Expression<bool>? isLastUsed,
    Expression<int>? lastConnectedEpoch,
    Expression<String>? capabilities,
    Expression<int>? createdAtEpoch,
    Expression<int>? updatedAtEpoch,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (type != null) 'type': type,
      if (address != null) 'address': address,
      if (isLastUsed != null) 'is_last_used': isLastUsed,
      if (lastConnectedEpoch != null)
        'last_connected_epoch': lastConnectedEpoch,
      if (capabilities != null) 'capabilities': capabilities,
      if (createdAtEpoch != null) 'created_at_epoch': createdAtEpoch,
      if (updatedAtEpoch != null) 'updated_at_epoch': updatedAtEpoch,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DevicesCompanion copyWith(
      {Value<String>? id,
      Value<String>? name,
      Value<String>? type,
      Value<String>? address,
      Value<bool>? isLastUsed,
      Value<int?>? lastConnectedEpoch,
      Value<String>? capabilities,
      Value<int>? createdAtEpoch,
      Value<int>? updatedAtEpoch,
      Value<int>? rowid}) {
    return DevicesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      address: address ?? this.address,
      isLastUsed: isLastUsed ?? this.isLastUsed,
      lastConnectedEpoch: lastConnectedEpoch ?? this.lastConnectedEpoch,
      capabilities: capabilities ?? this.capabilities,
      createdAtEpoch: createdAtEpoch ?? this.createdAtEpoch,
      updatedAtEpoch: updatedAtEpoch ?? this.updatedAtEpoch,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (address.present) {
      map['address'] = Variable<String>(address.value);
    }
    if (isLastUsed.present) {
      map['is_last_used'] = Variable<bool>(isLastUsed.value);
    }
    if (lastConnectedEpoch.present) {
      map['last_connected_epoch'] = Variable<int>(lastConnectedEpoch.value);
    }
    if (capabilities.present) {
      map['capabilities'] = Variable<String>(capabilities.value);
    }
    if (createdAtEpoch.present) {
      map['created_at_epoch'] = Variable<int>(createdAtEpoch.value);
    }
    if (updatedAtEpoch.present) {
      map['updated_at_epoch'] = Variable<int>(updatedAtEpoch.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DevicesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('type: $type, ')
          ..write('address: $address, ')
          ..write('isLastUsed: $isLastUsed, ')
          ..write('lastConnectedEpoch: $lastConnectedEpoch, ')
          ..write('capabilities: $capabilities, ')
          ..write('createdAtEpoch: $createdAtEpoch, ')
          ..write('updatedAtEpoch: $updatedAtEpoch, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$QSRDatabase extends GeneratedDatabase {
  _$QSRDatabase(QueryExecutor e) : super(e);
  $QSRDatabaseManager get managers => $QSRDatabaseManager(this);
  late final $MenuItemsTable menuItems = $MenuItemsTable(this);
  late final $OrdersTable orders = $OrdersTable(this);
  late final $OrderItemsTable orderItems = $OrderItemsTable(this);
  late final $DevicesTable devices = $DevicesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [menuItems, orders, orderItems, devices];
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
  Value<String> id,
  required String name,
  Value<double> price,
  Value<String> category,
  Value<bool> isAvailable,
  required int createdAtEpoch,
  required int updatedAtEpoch,
  Value<bool> isDirty,
  Value<int> rowid,
});
typedef $$MenuItemsTableUpdateCompanionBuilder = MenuItemsCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<double> price,
  Value<String> category,
  Value<bool> isAvailable,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
  Value<bool> isDirty,
  Value<int> rowid,
});

final class $$MenuItemsTableReferences
    extends BaseReferences<_$QSRDatabase, $MenuItemsTable, MenuItem> {
  $$MenuItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$QSRDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName:
              $_aliasNameGenerator(db.menuItems.id, db.orderItems.menuItemId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.menuItemId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$MenuItemsTableFilterComposer
    extends Composer<_$QSRDatabase, $MenuItemsTable> {
  $$MenuItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
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
    extends Composer<_$QSRDatabase, $MenuItemsTable> {
  $$MenuItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<double> get price => $composableBuilder(
      column: $table.price, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get category => $composableBuilder(
      column: $table.category, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));
}

class $$MenuItemsTableAnnotationComposer
    extends Composer<_$QSRDatabase, $MenuItemsTable> {
  $$MenuItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<double> get price =>
      $composableBuilder(column: $table.price, builder: (column) => column);

  GeneratedColumn<String> get category =>
      $composableBuilder(column: $table.category, builder: (column) => column);

  GeneratedColumn<bool> get isAvailable => $composableBuilder(
      column: $table.isAvailable, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);

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
    _$QSRDatabase,
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
  $$MenuItemsTableTableManager(_$QSRDatabase db, $MenuItemsTable table)
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
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenuItemsCompanion(
            id: id,
            name: name,
            price: price,
            category: category,
            isAvailable: isAvailable,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            isDirty: isDirty,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            required String name,
            Value<double> price = const Value.absent(),
            Value<String> category = const Value.absent(),
            Value<bool> isAvailable = const Value.absent(),
            required int createdAtEpoch,
            required int updatedAtEpoch,
            Value<bool> isDirty = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              MenuItemsCompanion.insert(
            id: id,
            name: name,
            price: price,
            category: category,
            isAvailable: isAvailable,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            isDirty: isDirty,
            rowid: rowid,
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
    _$QSRDatabase,
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
  Value<String> id,
  Value<String> orderType,
  Value<String?> token,
  Value<String> status,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> tax,
  Value<double> total,
  Value<String> notes,
  Value<String> server,
  Value<String> deviceId,
  required int createdAtEpoch,
  required int updatedAtEpoch,
  Value<bool> isDirty,
  Value<bool> kotPrinted,
  Value<int> rowid,
});
typedef $$OrdersTableUpdateCompanionBuilder = OrdersCompanion Function({
  Value<String> id,
  Value<String> orderType,
  Value<String?> token,
  Value<String> status,
  Value<double> subtotal,
  Value<double> discount,
  Value<double> tax,
  Value<double> total,
  Value<String> notes,
  Value<String> server,
  Value<String> deviceId,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
  Value<bool> isDirty,
  Value<bool> kotPrinted,
  Value<int> rowid,
});

final class $$OrdersTableReferences
    extends BaseReferences<_$QSRDatabase, $OrdersTable, Order> {
  $$OrdersTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$OrderItemsTable, List<OrderItem>>
      _orderItemsRefsTable(_$QSRDatabase db) => MultiTypedResultKey.fromTable(
          db.orderItems,
          aliasName: $_aliasNameGenerator(db.orders.id, db.orderItems.orderId));

  $$OrderItemsTableProcessedTableManager get orderItemsRefs {
    final manager = $$OrderItemsTableTableManager($_db, $_db.orderItems)
        .filter((f) => f.orderId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_orderItemsRefsTable($_db));
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: cache));
  }
}

class $$OrdersTableFilterComposer
    extends Composer<_$QSRDatabase, $OrdersTable> {
  $$OrdersTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get status => $composableBuilder(
      column: $table.status, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get subtotal => $composableBuilder(
      column: $table.subtotal, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get discount => $composableBuilder(
      column: $table.discount, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get tax => $composableBuilder(
      column: $table.tax, builder: (column) => ColumnFilters(column));

  ColumnFilters<double> get total => $composableBuilder(
      column: $table.total, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get server => $composableBuilder(
      column: $table.server, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get kotPrinted => $composableBuilder(
      column: $table.kotPrinted, builder: (column) => ColumnFilters(column));

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
    extends Composer<_$QSRDatabase, $OrdersTable> {
  $$OrdersTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get orderType => $composableBuilder(
      column: $table.orderType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get token => $composableBuilder(
      column: $table.token, builder: (column) => ColumnOrderings(column));

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

  ColumnOrderings<String> get notes => $composableBuilder(
      column: $table.notes, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get server => $composableBuilder(
      column: $table.server, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get deviceId => $composableBuilder(
      column: $table.deviceId, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isDirty => $composableBuilder(
      column: $table.isDirty, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get kotPrinted => $composableBuilder(
      column: $table.kotPrinted, builder: (column) => ColumnOrderings(column));
}

class $$OrdersTableAnnotationComposer
    extends Composer<_$QSRDatabase, $OrdersTable> {
  $$OrdersTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get orderType =>
      $composableBuilder(column: $table.orderType, builder: (column) => column);

  GeneratedColumn<String> get token =>
      $composableBuilder(column: $table.token, builder: (column) => column);

  GeneratedColumn<String> get status =>
      $composableBuilder(column: $table.status, builder: (column) => column);

  GeneratedColumn<double> get subtotal =>
      $composableBuilder(column: $table.subtotal, builder: (column) => column);

  GeneratedColumn<double> get discount =>
      $composableBuilder(column: $table.discount, builder: (column) => column);

  GeneratedColumn<double> get tax =>
      $composableBuilder(column: $table.tax, builder: (column) => column);

  GeneratedColumn<double> get total =>
      $composableBuilder(column: $table.total, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  GeneratedColumn<String> get server =>
      $composableBuilder(column: $table.server, builder: (column) => column);

  GeneratedColumn<String> get deviceId =>
      $composableBuilder(column: $table.deviceId, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);

  GeneratedColumn<bool> get isDirty =>
      $composableBuilder(column: $table.isDirty, builder: (column) => column);

  GeneratedColumn<bool> get kotPrinted => $composableBuilder(
      column: $table.kotPrinted, builder: (column) => column);

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
    _$QSRDatabase,
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
  $$OrdersTableTableManager(_$QSRDatabase db, $OrdersTable table)
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
            Value<String> id = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> tax = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> server = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
            Value<bool> isDirty = const Value.absent(),
            Value<bool> kotPrinted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersCompanion(
            id: id,
            orderType: orderType,
            token: token,
            status: status,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            total: total,
            notes: notes,
            server: server,
            deviceId: deviceId,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            isDirty: isDirty,
            kotPrinted: kotPrinted,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> orderType = const Value.absent(),
            Value<String?> token = const Value.absent(),
            Value<String> status = const Value.absent(),
            Value<double> subtotal = const Value.absent(),
            Value<double> discount = const Value.absent(),
            Value<double> tax = const Value.absent(),
            Value<double> total = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<String> server = const Value.absent(),
            Value<String> deviceId = const Value.absent(),
            required int createdAtEpoch,
            required int updatedAtEpoch,
            Value<bool> isDirty = const Value.absent(),
            Value<bool> kotPrinted = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              OrdersCompanion.insert(
            id: id,
            orderType: orderType,
            token: token,
            status: status,
            subtotal: subtotal,
            discount: discount,
            tax: tax,
            total: total,
            notes: notes,
            server: server,
            deviceId: deviceId,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            isDirty: isDirty,
            kotPrinted: kotPrinted,
            rowid: rowid,
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
    _$QSRDatabase,
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
  required String orderId,
  required String menuItemId,
  required String menuItemName,
  Value<int> quantity,
  required double price,
  required double lineTotal,
  Value<String> notes,
  required int createdAtEpoch,
  required int updatedAtEpoch,
});
typedef $$OrderItemsTableUpdateCompanionBuilder = OrderItemsCompanion Function({
  Value<int> id,
  Value<String> orderId,
  Value<String> menuItemId,
  Value<String> menuItemName,
  Value<int> quantity,
  Value<double> price,
  Value<double> lineTotal,
  Value<String> notes,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
});

final class $$OrderItemsTableReferences
    extends BaseReferences<_$QSRDatabase, $OrderItemsTable, OrderItem> {
  $$OrderItemsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $OrdersTable _orderIdTable(_$QSRDatabase db) => db.orders
      .createAlias($_aliasNameGenerator(db.orderItems.orderId, db.orders.id));

  $$OrdersTableProcessedTableManager get orderId {
    final $_column = $_itemColumn<String>('order_id')!;

    final manager = $$OrdersTableTableManager($_db, $_db.orders)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_orderIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }

  static $MenuItemsTable _menuItemIdTable(_$QSRDatabase db) =>
      db.menuItems.createAlias(
          $_aliasNameGenerator(db.orderItems.menuItemId, db.menuItems.id));

  $$MenuItemsTableProcessedTableManager get menuItemId {
    final $_column = $_itemColumn<String>('menu_item_id')!;

    final manager = $$MenuItemsTableTableManager($_db, $_db.menuItems)
        .filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_menuItemIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
        manager.$state.copyWith(prefetchedData: [item]));
  }
}

class $$OrderItemsTableFilterComposer
    extends Composer<_$QSRDatabase, $OrderItemsTable> {
  $$OrderItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get menuItemName => $composableBuilder(
      column: $table.menuItemName, builder: (column) => ColumnFilters(column));

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
    extends Composer<_$QSRDatabase, $OrderItemsTable> {
  $$OrderItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get menuItemName => $composableBuilder(
      column: $table.menuItemName,
      builder: (column) => ColumnOrderings(column));

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
    extends Composer<_$QSRDatabase, $OrderItemsTable> {
  $$OrderItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get menuItemName => $composableBuilder(
      column: $table.menuItemName, builder: (column) => column);

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
    _$QSRDatabase,
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
  $$OrderItemsTableTableManager(_$QSRDatabase db, $OrderItemsTable table)
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
            Value<String> orderId = const Value.absent(),
            Value<String> menuItemId = const Value.absent(),
            Value<String> menuItemName = const Value.absent(),
            Value<int> quantity = const Value.absent(),
            Value<double> price = const Value.absent(),
            Value<double> lineTotal = const Value.absent(),
            Value<String> notes = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
          }) =>
              OrderItemsCompanion(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            menuItemName: menuItemName,
            quantity: quantity,
            price: price,
            lineTotal: lineTotal,
            notes: notes,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String orderId,
            required String menuItemId,
            required String menuItemName,
            Value<int> quantity = const Value.absent(),
            required double price,
            required double lineTotal,
            Value<String> notes = const Value.absent(),
            required int createdAtEpoch,
            required int updatedAtEpoch,
          }) =>
              OrderItemsCompanion.insert(
            id: id,
            orderId: orderId,
            menuItemId: menuItemId,
            menuItemName: menuItemName,
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
    _$QSRDatabase,
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
typedef $$DevicesTableCreateCompanionBuilder = DevicesCompanion Function({
  required String id,
  required String name,
  Value<String> type,
  required String address,
  Value<bool> isLastUsed,
  Value<int?> lastConnectedEpoch,
  Value<String> capabilities,
  required int createdAtEpoch,
  required int updatedAtEpoch,
  Value<int> rowid,
});
typedef $$DevicesTableUpdateCompanionBuilder = DevicesCompanion Function({
  Value<String> id,
  Value<String> name,
  Value<String> type,
  Value<String> address,
  Value<bool> isLastUsed,
  Value<int?> lastConnectedEpoch,
  Value<String> capabilities,
  Value<int> createdAtEpoch,
  Value<int> updatedAtEpoch,
  Value<int> rowid,
});

class $$DevicesTableFilterComposer
    extends Composer<_$QSRDatabase, $DevicesTable> {
  $$DevicesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isLastUsed => $composableBuilder(
      column: $table.isLastUsed, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get lastConnectedEpoch => $composableBuilder(
      column: $table.lastConnectedEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnFilters(column));
}

class $$DevicesTableOrderingComposer
    extends Composer<_$QSRDatabase, $DevicesTable> {
  $$DevicesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get name => $composableBuilder(
      column: $table.name, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get type => $composableBuilder(
      column: $table.type, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get address => $composableBuilder(
      column: $table.address, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isLastUsed => $composableBuilder(
      column: $table.isLastUsed, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get lastConnectedEpoch => $composableBuilder(
      column: $table.lastConnectedEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get capabilities => $composableBuilder(
      column: $table.capabilities,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch,
      builder: (column) => ColumnOrderings(column));
}

class $$DevicesTableAnnotationComposer
    extends Composer<_$QSRDatabase, $DevicesTable> {
  $$DevicesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get address =>
      $composableBuilder(column: $table.address, builder: (column) => column);

  GeneratedColumn<bool> get isLastUsed => $composableBuilder(
      column: $table.isLastUsed, builder: (column) => column);

  GeneratedColumn<int> get lastConnectedEpoch => $composableBuilder(
      column: $table.lastConnectedEpoch, builder: (column) => column);

  GeneratedColumn<String> get capabilities => $composableBuilder(
      column: $table.capabilities, builder: (column) => column);

  GeneratedColumn<int> get createdAtEpoch => $composableBuilder(
      column: $table.createdAtEpoch, builder: (column) => column);

  GeneratedColumn<int> get updatedAtEpoch => $composableBuilder(
      column: $table.updatedAtEpoch, builder: (column) => column);
}

class $$DevicesTableTableManager extends RootTableManager<
    _$QSRDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, BaseReferences<_$QSRDatabase, $DevicesTable, Device>),
    Device,
    PrefetchHooks Function()> {
  $$DevicesTableTableManager(_$QSRDatabase db, $DevicesTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DevicesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DevicesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DevicesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> id = const Value.absent(),
            Value<String> name = const Value.absent(),
            Value<String> type = const Value.absent(),
            Value<String> address = const Value.absent(),
            Value<bool> isLastUsed = const Value.absent(),
            Value<int?> lastConnectedEpoch = const Value.absent(),
            Value<String> capabilities = const Value.absent(),
            Value<int> createdAtEpoch = const Value.absent(),
            Value<int> updatedAtEpoch = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) =>
              DevicesCompanion(
            id: id,
            name: name,
            type: type,
            address: address,
            isLastUsed: isLastUsed,
            lastConnectedEpoch: lastConnectedEpoch,
            capabilities: capabilities,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            rowid: rowid,
          ),
          createCompanionCallback: ({
            required String id,
            required String name,
            Value<String> type = const Value.absent(),
            required String address,
            Value<bool> isLastUsed = const Value.absent(),
            Value<int?> lastConnectedEpoch = const Value.absent(),
            Value<String> capabilities = const Value.absent(),
            required int createdAtEpoch,
            required int updatedAtEpoch,
            Value<int> rowid = const Value.absent(),
          }) =>
              DevicesCompanion.insert(
            id: id,
            name: name,
            type: type,
            address: address,
            isLastUsed: isLastUsed,
            lastConnectedEpoch: lastConnectedEpoch,
            capabilities: capabilities,
            createdAtEpoch: createdAtEpoch,
            updatedAtEpoch: updatedAtEpoch,
            rowid: rowid,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$DevicesTableProcessedTableManager = ProcessedTableManager<
    _$QSRDatabase,
    $DevicesTable,
    Device,
    $$DevicesTableFilterComposer,
    $$DevicesTableOrderingComposer,
    $$DevicesTableAnnotationComposer,
    $$DevicesTableCreateCompanionBuilder,
    $$DevicesTableUpdateCompanionBuilder,
    (Device, BaseReferences<_$QSRDatabase, $DevicesTable, Device>),
    Device,
    PrefetchHooks Function()>;

class $QSRDatabaseManager {
  final _$QSRDatabase _db;
  $QSRDatabaseManager(this._db);
  $$MenuItemsTableTableManager get menuItems =>
      $$MenuItemsTableTableManager(_db, _db.menuItems);
  $$OrdersTableTableManager get orders =>
      $$OrdersTableTableManager(_db, _db.orders);
  $$OrderItemsTableTableManager get orderItems =>
      $$OrderItemsTableTableManager(_db, _db.orderItems);
  $$DevicesTableTableManager get devices =>
      $$DevicesTableTableManager(_db, _db.devices);
}
