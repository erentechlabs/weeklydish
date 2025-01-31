// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $AllergensTable extends Allergens
    with TableInfo<$AllergensTable, Allergen> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AllergensTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'ID', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _allergensMeta =
      const VerificationMeta('allergens');
  @override
  late final GeneratedColumn<String> allergens = GeneratedColumn<String>(
      'Allergens', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, allergens];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'allergens';
  @override
  VerificationContext validateIntegrity(Insertable<Allergen> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ID')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['ID']!, _idMeta));
    }
    if (data.containsKey('Allergens')) {
      context.handle(_allergensMeta,
          allergens.isAcceptableOrUnknown(data['Allergens']!, _allergensMeta));
    } else if (isInserting) {
      context.missing(_allergensMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Allergen map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Allergen(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ID'])!,
      allergens: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Allergens'])!,
    );
  }

  @override
  $AllergensTable createAlias(String alias) {
    return $AllergensTable(attachedDatabase, alias);
  }
}

class Allergen extends DataClass implements Insertable<Allergen> {
  final int id;
  final String allergens;
  const Allergen({required this.id, required this.allergens});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ID'] = Variable<int>(id);
    map['Allergens'] = Variable<String>(allergens);
    return map;
  }

  AllergensCompanion toCompanion(bool nullToAbsent) {
    return AllergensCompanion(
      id: Value(id),
      allergens: Value(allergens),
    );
  }

  factory Allergen.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Allergen(
      id: serializer.fromJson<int>(json['id']),
      allergens: serializer.fromJson<String>(json['allergens']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'allergens': serializer.toJson<String>(allergens),
    };
  }

  Allergen copyWith({int? id, String? allergens}) => Allergen(
        id: id ?? this.id,
        allergens: allergens ?? this.allergens,
      );
  Allergen copyWithCompanion(AllergensCompanion data) {
    return Allergen(
      id: data.id.present ? data.id.value : this.id,
      allergens: data.allergens.present ? data.allergens.value : this.allergens,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Allergen(')
          ..write('id: $id, ')
          ..write('allergens: $allergens')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, allergens);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Allergen &&
          other.id == this.id &&
          other.allergens == this.allergens);
}

class AllergensCompanion extends UpdateCompanion<Allergen> {
  final Value<int> id;
  final Value<String> allergens;
  const AllergensCompanion({
    this.id = const Value.absent(),
    this.allergens = const Value.absent(),
  });
  AllergensCompanion.insert({
    this.id = const Value.absent(),
    required String allergens,
  }) : allergens = Value(allergens);
  static Insertable<Allergen> custom({
    Expression<int>? id,
    Expression<String>? allergens,
  }) {
    return RawValuesInsertable({
      if (id != null) 'ID': id,
      if (allergens != null) 'Allergens': allergens,
    });
  }

  AllergensCompanion copyWith({Value<int>? id, Value<String>? allergens}) {
    return AllergensCompanion(
      id: id ?? this.id,
      allergens: allergens ?? this.allergens,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['ID'] = Variable<int>(id.value);
    }
    if (allergens.present) {
      map['Allergens'] = Variable<String>(allergens.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AllergensCompanion(')
          ..write('id: $id, ')
          ..write('allergens: $allergens')
          ..write(')'))
        .toString();
  }
}

class $FoodAndDessertTable extends FoodAndDessert
    with TableInfo<$FoodAndDessertTable, FoodAndDessertData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FoodAndDessertTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'Item_Type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'Meal_Type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumnWithTypeConverter<List<String>, String> content =
      GeneratedColumn<String>('Content', aliasedName, false,
              type: DriftSqlType.string, requiredDuringInsert: true)
          .withConverter<List<String>>($FoodAndDessertTable.$convertercontent);
  @override
  List<GeneratedColumn> get $columns => [id, itemType, mealType, content];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'food_and_dessert';
  @override
  VerificationContext validateIntegrity(Insertable<FoodAndDessertData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('Item_Type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['Item_Type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('Meal_Type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['Meal_Type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    context.handle(_contentMeta, const VerificationResult.success());
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FoodAndDessertData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FoodAndDessertData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Item_Type'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Meal_Type'])!,
      content: $FoodAndDessertTable.$convertercontent.fromSql(attachedDatabase
          .typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Content'])!),
    );
  }

  @override
  $FoodAndDessertTable createAlias(String alias) {
    return $FoodAndDessertTable(attachedDatabase, alias);
  }

  static TypeConverter<List<String>, String> $convertercontent =
      const ListConverter();
}

class FoodAndDessertData extends DataClass
    implements Insertable<FoodAndDessertData> {
  final int id;
  final String itemType;
  final String mealType;
  final List<String> content;
  const FoodAndDessertData(
      {required this.id,
      required this.itemType,
      required this.mealType,
      required this.content});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['Item_Type'] = Variable<String>(itemType);
    map['Meal_Type'] = Variable<String>(mealType);
    {
      map['Content'] = Variable<String>(
          $FoodAndDessertTable.$convertercontent.toSql(content));
    }
    return map;
  }

  FoodAndDessertCompanion toCompanion(bool nullToAbsent) {
    return FoodAndDessertCompanion(
      id: Value(id),
      itemType: Value(itemType),
      mealType: Value(mealType),
      content: Value(content),
    );
  }

  factory FoodAndDessertData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FoodAndDessertData(
      id: serializer.fromJson<int>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      mealType: serializer.fromJson<String>(json['mealType']),
      content: serializer.fromJson<List<String>>(json['content']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer.toJson<String>(itemType),
      'mealType': serializer.toJson<String>(mealType),
      'content': serializer.toJson<List<String>>(content),
    };
  }

  FoodAndDessertData copyWith(
          {int? id,
          String? itemType,
          String? mealType,
          List<String>? content}) =>
      FoodAndDessertData(
        id: id ?? this.id,
        itemType: itemType ?? this.itemType,
        mealType: mealType ?? this.mealType,
        content: content ?? this.content,
      );
  FoodAndDessertData copyWithCompanion(FoodAndDessertCompanion data) {
    return FoodAndDessertData(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      content: data.content.present ? data.content.value : this.content,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FoodAndDessertData(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('mealType: $mealType, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemType, mealType, content);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FoodAndDessertData &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.mealType == this.mealType &&
          other.content == this.content);
}

class FoodAndDessertCompanion extends UpdateCompanion<FoodAndDessertData> {
  final Value<int> id;
  final Value<String> itemType;
  final Value<String> mealType;
  final Value<List<String>> content;
  const FoodAndDessertCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.mealType = const Value.absent(),
    this.content = const Value.absent(),
  });
  FoodAndDessertCompanion.insert({
    this.id = const Value.absent(),
    required String itemType,
    required String mealType,
    required List<String> content,
  })  : itemType = Value(itemType),
        mealType = Value(mealType),
        content = Value(content);
  static Insertable<FoodAndDessertData> custom({
    Expression<int>? id,
    Expression<String>? itemType,
    Expression<String>? mealType,
    Expression<String>? content,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'Item_Type': itemType,
      if (mealType != null) 'Meal_Type': mealType,
      if (content != null) 'Content': content,
    });
  }

  FoodAndDessertCompanion copyWith(
      {Value<int>? id,
      Value<String>? itemType,
      Value<String>? mealType,
      Value<List<String>>? content}) {
    return FoodAndDessertCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      mealType: mealType ?? this.mealType,
      content: content ?? this.content,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['Item_Type'] = Variable<String>(itemType.value);
    }
    if (mealType.present) {
      map['Meal_Type'] = Variable<String>(mealType.value);
    }
    if (content.present) {
      map['Content'] = Variable<String>(
          $FoodAndDessertTable.$convertercontent.toSql(content.value));
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FoodAndDessertCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('mealType: $mealType, ')
          ..write('content: $content')
          ..write(')'))
        .toString();
  }
}

class $ShoppingTable extends Shopping
    with TableInfo<$ShoppingTable, ShoppingData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ShoppingTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'ID', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
      'Title', aliasedName, false,
      additionalChecks:
          GeneratedColumn.checkTextLength(minTextLength: 1, maxTextLength: 32),
      type: DriftSqlType.string,
      requiredDuringInsert: true);
  static const VerificationMeta _shoppingListMeta =
      const VerificationMeta('shoppingList');
  @override
  late final GeneratedColumn<String> shoppingList = GeneratedColumn<String>(
      'Shopping_List', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _createdAtMeta =
      const VerificationMeta('createdAt');
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
      'Created_At', aliasedName, true,
      type: DriftSqlType.dateTime, requiredDuringInsert: false);
  static const VerificationMeta _isAIGeneratedMeta =
      const VerificationMeta('isAIGenerated');
  @override
  late final GeneratedColumn<bool> isAIGenerated = GeneratedColumn<bool>(
      'AI_Generated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("AI_Generated" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns =>
      [id, title, shoppingList, createdAt, isAIGenerated];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'shopping';
  @override
  VerificationContext validateIntegrity(Insertable<ShoppingData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('ID')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['ID']!, _idMeta));
    }
    if (data.containsKey('Title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['Title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('Shopping_List')) {
      context.handle(
          _shoppingListMeta,
          shoppingList.isAcceptableOrUnknown(
              data['Shopping_List']!, _shoppingListMeta));
    } else if (isInserting) {
      context.missing(_shoppingListMeta);
    }
    if (data.containsKey('Created_At')) {
      context.handle(_createdAtMeta,
          createdAt.isAcceptableOrUnknown(data['Created_At']!, _createdAtMeta));
    }
    if (data.containsKey('AI_Generated')) {
      context.handle(
          _isAIGeneratedMeta,
          isAIGenerated.isAcceptableOrUnknown(
              data['AI_Generated']!, _isAIGeneratedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ShoppingData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ShoppingData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}ID'])!,
      title: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Title'])!,
      shoppingList: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Shopping_List'])!,
      createdAt: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}Created_At']),
      isAIGenerated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}AI_Generated'])!,
    );
  }

  @override
  $ShoppingTable createAlias(String alias) {
    return $ShoppingTable(attachedDatabase, alias);
  }
}

class ShoppingData extends DataClass implements Insertable<ShoppingData> {
  final int id;
  final String title;
  final String shoppingList;
  final DateTime? createdAt;
  final bool isAIGenerated;
  const ShoppingData(
      {required this.id,
      required this.title,
      required this.shoppingList,
      this.createdAt,
      required this.isAIGenerated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['ID'] = Variable<int>(id);
    map['Title'] = Variable<String>(title);
    map['Shopping_List'] = Variable<String>(shoppingList);
    if (!nullToAbsent || createdAt != null) {
      map['Created_At'] = Variable<DateTime>(createdAt);
    }
    map['AI_Generated'] = Variable<bool>(isAIGenerated);
    return map;
  }

  ShoppingCompanion toCompanion(bool nullToAbsent) {
    return ShoppingCompanion(
      id: Value(id),
      title: Value(title),
      shoppingList: Value(shoppingList),
      createdAt: createdAt == null && nullToAbsent
          ? const Value.absent()
          : Value(createdAt),
      isAIGenerated: Value(isAIGenerated),
    );
  }

  factory ShoppingData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ShoppingData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      shoppingList: serializer.fromJson<String>(json['shoppingList']),
      createdAt: serializer.fromJson<DateTime?>(json['createdAt']),
      isAIGenerated: serializer.fromJson<bool>(json['isAIGenerated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'shoppingList': serializer.toJson<String>(shoppingList),
      'createdAt': serializer.toJson<DateTime?>(createdAt),
      'isAIGenerated': serializer.toJson<bool>(isAIGenerated),
    };
  }

  ShoppingData copyWith(
          {int? id,
          String? title,
          String? shoppingList,
          Value<DateTime?> createdAt = const Value.absent(),
          bool? isAIGenerated}) =>
      ShoppingData(
        id: id ?? this.id,
        title: title ?? this.title,
        shoppingList: shoppingList ?? this.shoppingList,
        createdAt: createdAt.present ? createdAt.value : this.createdAt,
        isAIGenerated: isAIGenerated ?? this.isAIGenerated,
      );
  ShoppingData copyWithCompanion(ShoppingCompanion data) {
    return ShoppingData(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      shoppingList: data.shoppingList.present
          ? data.shoppingList.value
          : this.shoppingList,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      isAIGenerated: data.isAIGenerated.present
          ? data.isAIGenerated.value
          : this.isAIGenerated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shoppingList: $shoppingList, ')
          ..write('createdAt: $createdAt, ')
          ..write('isAIGenerated: $isAIGenerated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, shoppingList, createdAt, isAIGenerated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ShoppingData &&
          other.id == this.id &&
          other.title == this.title &&
          other.shoppingList == this.shoppingList &&
          other.createdAt == this.createdAt &&
          other.isAIGenerated == this.isAIGenerated);
}

class ShoppingCompanion extends UpdateCompanion<ShoppingData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> shoppingList;
  final Value<DateTime?> createdAt;
  final Value<bool> isAIGenerated;
  const ShoppingCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.shoppingList = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
  });
  ShoppingCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String shoppingList,
    this.createdAt = const Value.absent(),
    this.isAIGenerated = const Value.absent(),
  })  : title = Value(title),
        shoppingList = Value(shoppingList);
  static Insertable<ShoppingData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? shoppingList,
    Expression<DateTime>? createdAt,
    Expression<bool>? isAIGenerated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'ID': id,
      if (title != null) 'Title': title,
      if (shoppingList != null) 'Shopping_List': shoppingList,
      if (createdAt != null) 'Created_At': createdAt,
      if (isAIGenerated != null) 'AI_Generated': isAIGenerated,
    });
  }

  ShoppingCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? shoppingList,
      Value<DateTime?>? createdAt,
      Value<bool>? isAIGenerated}) {
    return ShoppingCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      shoppingList: shoppingList ?? this.shoppingList,
      createdAt: createdAt ?? this.createdAt,
      isAIGenerated: isAIGenerated ?? this.isAIGenerated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['ID'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['Title'] = Variable<String>(title.value);
    }
    if (shoppingList.present) {
      map['Shopping_List'] = Variable<String>(shoppingList.value);
    }
    if (createdAt.present) {
      map['Created_At'] = Variable<DateTime>(createdAt.value);
    }
    if (isAIGenerated.present) {
      map['AI_Generated'] = Variable<bool>(isAIGenerated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ShoppingCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('shoppingList: $shoppingList, ')
          ..write('createdAt: $createdAt, ')
          ..write('isAIGenerated: $isAIGenerated')
          ..write(')'))
        .toString();
  }
}

class $MenuTable extends Menu with TableInfo<$MenuTable, MenuData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MenuTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
      'id', aliasedName, false,
      hasAutoIncrement: true,
      type: DriftSqlType.int,
      requiredDuringInsert: false,
      defaultConstraints:
          GeneratedColumn.constraintIsAlways('PRIMARY KEY AUTOINCREMENT'));
  static const VerificationMeta _itemTypeMeta =
      const VerificationMeta('itemType');
  @override
  late final GeneratedColumn<String> itemType = GeneratedColumn<String>(
      'Item_Type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _mealTypeMeta =
      const VerificationMeta('mealType');
  @override
  late final GeneratedColumn<String> mealType = GeneratedColumn<String>(
      'Meal_Type', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _datetimeMeta =
      const VerificationMeta('datetime');
  @override
  late final GeneratedColumn<DateTime> datetime = GeneratedColumn<DateTime>(
      'Datetime', aliasedName, false,
      type: DriftSqlType.dateTime, requiredDuringInsert: true);
  static const VerificationMeta _contentMeta =
      const VerificationMeta('content');
  @override
  late final GeneratedColumn<String> content = GeneratedColumn<String>(
      'Content', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _recipeMeta = const VerificationMeta('recipe');
  @override
  late final GeneratedColumn<String> recipe = GeneratedColumn<String>(
      'Recipe', aliasedName, false,
      type: DriftSqlType.string, requiredDuringInsert: true);
  static const VerificationMeta _isRecipeUpdatedMeta =
      const VerificationMeta('isRecipeUpdated');
  @override
  late final GeneratedColumn<bool> isRecipeUpdated = GeneratedColumn<bool>(
      'Recipe_Updated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("Recipe_Updated" IN (0, 1))'),
      defaultValue: const Constant(false));
  static const VerificationMeta _isAllergensUpdatedMeta =
      const VerificationMeta('isAllergensUpdated');
  @override
  late final GeneratedColumn<bool> isAllergensUpdated = GeneratedColumn<bool>(
      'Allergens_Updated', aliasedName, false,
      type: DriftSqlType.bool,
      requiredDuringInsert: false,
      defaultConstraints: GeneratedColumn.constraintIsAlways(
          'CHECK ("Allergens_Updated" IN (0, 1))'),
      defaultValue: const Constant(false));
  @override
  List<GeneratedColumn> get $columns => [
        id,
        itemType,
        mealType,
        datetime,
        content,
        recipe,
        isRecipeUpdated,
        isAllergensUpdated
      ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'menu';
  @override
  VerificationContext validateIntegrity(Insertable<MenuData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('Item_Type')) {
      context.handle(_itemTypeMeta,
          itemType.isAcceptableOrUnknown(data['Item_Type']!, _itemTypeMeta));
    } else if (isInserting) {
      context.missing(_itemTypeMeta);
    }
    if (data.containsKey('Meal_Type')) {
      context.handle(_mealTypeMeta,
          mealType.isAcceptableOrUnknown(data['Meal_Type']!, _mealTypeMeta));
    } else if (isInserting) {
      context.missing(_mealTypeMeta);
    }
    if (data.containsKey('Datetime')) {
      context.handle(_datetimeMeta,
          datetime.isAcceptableOrUnknown(data['Datetime']!, _datetimeMeta));
    } else if (isInserting) {
      context.missing(_datetimeMeta);
    }
    if (data.containsKey('Content')) {
      context.handle(_contentMeta,
          content.isAcceptableOrUnknown(data['Content']!, _contentMeta));
    } else if (isInserting) {
      context.missing(_contentMeta);
    }
    if (data.containsKey('Recipe')) {
      context.handle(_recipeMeta,
          recipe.isAcceptableOrUnknown(data['Recipe']!, _recipeMeta));
    } else if (isInserting) {
      context.missing(_recipeMeta);
    }
    if (data.containsKey('Recipe_Updated')) {
      context.handle(
          _isRecipeUpdatedMeta,
          isRecipeUpdated.isAcceptableOrUnknown(
              data['Recipe_Updated']!, _isRecipeUpdatedMeta));
    }
    if (data.containsKey('Allergens_Updated')) {
      context.handle(
          _isAllergensUpdatedMeta,
          isAllergensUpdated.isAcceptableOrUnknown(
              data['Allergens_Updated']!, _isAllergensUpdatedMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  MenuData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MenuData(
      id: attachedDatabase.typeMapping
          .read(DriftSqlType.int, data['${effectivePrefix}id'])!,
      itemType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Item_Type'])!,
      mealType: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Meal_Type'])!,
      datetime: attachedDatabase.typeMapping
          .read(DriftSqlType.dateTime, data['${effectivePrefix}Datetime'])!,
      content: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Content'])!,
      recipe: attachedDatabase.typeMapping
          .read(DriftSqlType.string, data['${effectivePrefix}Recipe'])!,
      isRecipeUpdated: attachedDatabase.typeMapping
          .read(DriftSqlType.bool, data['${effectivePrefix}Recipe_Updated'])!,
      isAllergensUpdated: attachedDatabase.typeMapping.read(
          DriftSqlType.bool, data['${effectivePrefix}Allergens_Updated'])!,
    );
  }

  @override
  $MenuTable createAlias(String alias) {
    return $MenuTable(attachedDatabase, alias);
  }
}

class MenuData extends DataClass implements Insertable<MenuData> {
  final int id;
  final String itemType;
  final String mealType;
  final DateTime datetime;
  final String content;
  final String recipe;
  final bool isRecipeUpdated;
  final bool isAllergensUpdated;
  const MenuData(
      {required this.id,
      required this.itemType,
      required this.mealType,
      required this.datetime,
      required this.content,
      required this.recipe,
      required this.isRecipeUpdated,
      required this.isAllergensUpdated});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['Item_Type'] = Variable<String>(itemType);
    map['Meal_Type'] = Variable<String>(mealType);
    map['Datetime'] = Variable<DateTime>(datetime);
    map['Content'] = Variable<String>(content);
    map['Recipe'] = Variable<String>(recipe);
    map['Recipe_Updated'] = Variable<bool>(isRecipeUpdated);
    map['Allergens_Updated'] = Variable<bool>(isAllergensUpdated);
    return map;
  }

  MenuCompanion toCompanion(bool nullToAbsent) {
    return MenuCompanion(
      id: Value(id),
      itemType: Value(itemType),
      mealType: Value(mealType),
      datetime: Value(datetime),
      content: Value(content),
      recipe: Value(recipe),
      isRecipeUpdated: Value(isRecipeUpdated),
      isAllergensUpdated: Value(isAllergensUpdated),
    );
  }

  factory MenuData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MenuData(
      id: serializer.fromJson<int>(json['id']),
      itemType: serializer.fromJson<String>(json['itemType']),
      mealType: serializer.fromJson<String>(json['mealType']),
      datetime: serializer.fromJson<DateTime>(json['datetime']),
      content: serializer.fromJson<String>(json['content']),
      recipe: serializer.fromJson<String>(json['recipe']),
      isRecipeUpdated: serializer.fromJson<bool>(json['isRecipeUpdated']),
      isAllergensUpdated: serializer.fromJson<bool>(json['isAllergensUpdated']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'itemType': serializer.toJson<String>(itemType),
      'mealType': serializer.toJson<String>(mealType),
      'datetime': serializer.toJson<DateTime>(datetime),
      'content': serializer.toJson<String>(content),
      'recipe': serializer.toJson<String>(recipe),
      'isRecipeUpdated': serializer.toJson<bool>(isRecipeUpdated),
      'isAllergensUpdated': serializer.toJson<bool>(isAllergensUpdated),
    };
  }

  MenuData copyWith(
          {int? id,
          String? itemType,
          String? mealType,
          DateTime? datetime,
          String? content,
          String? recipe,
          bool? isRecipeUpdated,
          bool? isAllergensUpdated}) =>
      MenuData(
        id: id ?? this.id,
        itemType: itemType ?? this.itemType,
        mealType: mealType ?? this.mealType,
        datetime: datetime ?? this.datetime,
        content: content ?? this.content,
        recipe: recipe ?? this.recipe,
        isRecipeUpdated: isRecipeUpdated ?? this.isRecipeUpdated,
        isAllergensUpdated: isAllergensUpdated ?? this.isAllergensUpdated,
      );
  MenuData copyWithCompanion(MenuCompanion data) {
    return MenuData(
      id: data.id.present ? data.id.value : this.id,
      itemType: data.itemType.present ? data.itemType.value : this.itemType,
      mealType: data.mealType.present ? data.mealType.value : this.mealType,
      datetime: data.datetime.present ? data.datetime.value : this.datetime,
      content: data.content.present ? data.content.value : this.content,
      recipe: data.recipe.present ? data.recipe.value : this.recipe,
      isRecipeUpdated: data.isRecipeUpdated.present
          ? data.isRecipeUpdated.value
          : this.isRecipeUpdated,
      isAllergensUpdated: data.isAllergensUpdated.present
          ? data.isAllergensUpdated.value
          : this.isAllergensUpdated,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MenuData(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('mealType: $mealType, ')
          ..write('datetime: $datetime, ')
          ..write('content: $content, ')
          ..write('recipe: $recipe, ')
          ..write('isRecipeUpdated: $isRecipeUpdated, ')
          ..write('isAllergensUpdated: $isAllergensUpdated')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, itemType, mealType, datetime, content,
      recipe, isRecipeUpdated, isAllergensUpdated);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MenuData &&
          other.id == this.id &&
          other.itemType == this.itemType &&
          other.mealType == this.mealType &&
          other.datetime == this.datetime &&
          other.content == this.content &&
          other.recipe == this.recipe &&
          other.isRecipeUpdated == this.isRecipeUpdated &&
          other.isAllergensUpdated == this.isAllergensUpdated);
}

class MenuCompanion extends UpdateCompanion<MenuData> {
  final Value<int> id;
  final Value<String> itemType;
  final Value<String> mealType;
  final Value<DateTime> datetime;
  final Value<String> content;
  final Value<String> recipe;
  final Value<bool> isRecipeUpdated;
  final Value<bool> isAllergensUpdated;
  const MenuCompanion({
    this.id = const Value.absent(),
    this.itemType = const Value.absent(),
    this.mealType = const Value.absent(),
    this.datetime = const Value.absent(),
    this.content = const Value.absent(),
    this.recipe = const Value.absent(),
    this.isRecipeUpdated = const Value.absent(),
    this.isAllergensUpdated = const Value.absent(),
  });
  MenuCompanion.insert({
    this.id = const Value.absent(),
    required String itemType,
    required String mealType,
    required DateTime datetime,
    required String content,
    required String recipe,
    this.isRecipeUpdated = const Value.absent(),
    this.isAllergensUpdated = const Value.absent(),
  })  : itemType = Value(itemType),
        mealType = Value(mealType),
        datetime = Value(datetime),
        content = Value(content),
        recipe = Value(recipe);
  static Insertable<MenuData> custom({
    Expression<int>? id,
    Expression<String>? itemType,
    Expression<String>? mealType,
    Expression<DateTime>? datetime,
    Expression<String>? content,
    Expression<String>? recipe,
    Expression<bool>? isRecipeUpdated,
    Expression<bool>? isAllergensUpdated,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (itemType != null) 'Item_Type': itemType,
      if (mealType != null) 'Meal_Type': mealType,
      if (datetime != null) 'Datetime': datetime,
      if (content != null) 'Content': content,
      if (recipe != null) 'Recipe': recipe,
      if (isRecipeUpdated != null) 'Recipe_Updated': isRecipeUpdated,
      if (isAllergensUpdated != null) 'Allergens_Updated': isAllergensUpdated,
    });
  }

  MenuCompanion copyWith(
      {Value<int>? id,
      Value<String>? itemType,
      Value<String>? mealType,
      Value<DateTime>? datetime,
      Value<String>? content,
      Value<String>? recipe,
      Value<bool>? isRecipeUpdated,
      Value<bool>? isAllergensUpdated}) {
    return MenuCompanion(
      id: id ?? this.id,
      itemType: itemType ?? this.itemType,
      mealType: mealType ?? this.mealType,
      datetime: datetime ?? this.datetime,
      content: content ?? this.content,
      recipe: recipe ?? this.recipe,
      isRecipeUpdated: isRecipeUpdated ?? this.isRecipeUpdated,
      isAllergensUpdated: isAllergensUpdated ?? this.isAllergensUpdated,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (itemType.present) {
      map['Item_Type'] = Variable<String>(itemType.value);
    }
    if (mealType.present) {
      map['Meal_Type'] = Variable<String>(mealType.value);
    }
    if (datetime.present) {
      map['Datetime'] = Variable<DateTime>(datetime.value);
    }
    if (content.present) {
      map['Content'] = Variable<String>(content.value);
    }
    if (recipe.present) {
      map['Recipe'] = Variable<String>(recipe.value);
    }
    if (isRecipeUpdated.present) {
      map['Recipe_Updated'] = Variable<bool>(isRecipeUpdated.value);
    }
    if (isAllergensUpdated.present) {
      map['Allergens_Updated'] = Variable<bool>(isAllergensUpdated.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MenuCompanion(')
          ..write('id: $id, ')
          ..write('itemType: $itemType, ')
          ..write('mealType: $mealType, ')
          ..write('datetime: $datetime, ')
          ..write('content: $content, ')
          ..write('recipe: $recipe, ')
          ..write('isRecipeUpdated: $isRecipeUpdated, ')
          ..write('isAllergensUpdated: $isAllergensUpdated')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $AllergensTable allergens = $AllergensTable(this);
  late final $FoodAndDessertTable foodAndDessert = $FoodAndDessertTable(this);
  late final $ShoppingTable shopping = $ShoppingTable(this);
  late final $MenuTable menu = $MenuTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities =>
      [allergens, foodAndDessert, shopping, menu];
}

typedef $$AllergensTableCreateCompanionBuilder = AllergensCompanion Function({
  Value<int> id,
  required String allergens,
});
typedef $$AllergensTableUpdateCompanionBuilder = AllergensCompanion Function({
  Value<int> id,
  Value<String> allergens,
});

class $$AllergensTableFilterComposer
    extends Composer<_$AppDatabase, $AllergensTable> {
  $$AllergensTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get allergens => $composableBuilder(
      column: $table.allergens, builder: (column) => ColumnFilters(column));
}

class $$AllergensTableOrderingComposer
    extends Composer<_$AppDatabase, $AllergensTable> {
  $$AllergensTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get allergens => $composableBuilder(
      column: $table.allergens, builder: (column) => ColumnOrderings(column));
}

class $$AllergensTableAnnotationComposer
    extends Composer<_$AppDatabase, $AllergensTable> {
  $$AllergensTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get allergens =>
      $composableBuilder(column: $table.allergens, builder: (column) => column);
}

class $$AllergensTableTableManager extends RootTableManager<
    _$AppDatabase,
    $AllergensTable,
    Allergen,
    $$AllergensTableFilterComposer,
    $$AllergensTableOrderingComposer,
    $$AllergensTableAnnotationComposer,
    $$AllergensTableCreateCompanionBuilder,
    $$AllergensTableUpdateCompanionBuilder,
    (Allergen, BaseReferences<_$AppDatabase, $AllergensTable, Allergen>),
    Allergen,
    PrefetchHooks Function()> {
  $$AllergensTableTableManager(_$AppDatabase db, $AllergensTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AllergensTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AllergensTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AllergensTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> allergens = const Value.absent(),
          }) =>
              AllergensCompanion(
            id: id,
            allergens: allergens,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String allergens,
          }) =>
              AllergensCompanion.insert(
            id: id,
            allergens: allergens,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$AllergensTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $AllergensTable,
    Allergen,
    $$AllergensTableFilterComposer,
    $$AllergensTableOrderingComposer,
    $$AllergensTableAnnotationComposer,
    $$AllergensTableCreateCompanionBuilder,
    $$AllergensTableUpdateCompanionBuilder,
    (Allergen, BaseReferences<_$AppDatabase, $AllergensTable, Allergen>),
    Allergen,
    PrefetchHooks Function()>;
typedef $$FoodAndDessertTableCreateCompanionBuilder = FoodAndDessertCompanion
    Function({
  Value<int> id,
  required String itemType,
  required String mealType,
  required List<String> content,
});
typedef $$FoodAndDessertTableUpdateCompanionBuilder = FoodAndDessertCompanion
    Function({
  Value<int> id,
  Value<String> itemType,
  Value<String> mealType,
  Value<List<String>> content,
});

class $$FoodAndDessertTableFilterComposer
    extends Composer<_$AppDatabase, $FoodAndDessertTable> {
  $$FoodAndDessertTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnWithTypeConverterFilters<List<String>, List<String>, String>
      get content => $composableBuilder(
          column: $table.content,
          builder: (column) => ColumnWithTypeConverterFilters(column));
}

class $$FoodAndDessertTableOrderingComposer
    extends Composer<_$AppDatabase, $FoodAndDessertTable> {
  $$FoodAndDessertTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));
}

class $$FoodAndDessertTableAnnotationComposer
    extends Composer<_$AppDatabase, $FoodAndDessertTable> {
  $$FoodAndDessertTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumnWithTypeConverter<List<String>, String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);
}

class $$FoodAndDessertTableTableManager extends RootTableManager<
    _$AppDatabase,
    $FoodAndDessertTable,
    FoodAndDessertData,
    $$FoodAndDessertTableFilterComposer,
    $$FoodAndDessertTableOrderingComposer,
    $$FoodAndDessertTableAnnotationComposer,
    $$FoodAndDessertTableCreateCompanionBuilder,
    $$FoodAndDessertTableUpdateCompanionBuilder,
    (
      FoodAndDessertData,
      BaseReferences<_$AppDatabase, $FoodAndDessertTable, FoodAndDessertData>
    ),
    FoodAndDessertData,
    PrefetchHooks Function()> {
  $$FoodAndDessertTableTableManager(
      _$AppDatabase db, $FoodAndDessertTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FoodAndDessertTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FoodAndDessertTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$FoodAndDessertTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<List<String>> content = const Value.absent(),
          }) =>
              FoodAndDessertCompanion(
            id: id,
            itemType: itemType,
            mealType: mealType,
            content: content,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String itemType,
            required String mealType,
            required List<String> content,
          }) =>
              FoodAndDessertCompanion.insert(
            id: id,
            itemType: itemType,
            mealType: mealType,
            content: content,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$FoodAndDessertTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $FoodAndDessertTable,
    FoodAndDessertData,
    $$FoodAndDessertTableFilterComposer,
    $$FoodAndDessertTableOrderingComposer,
    $$FoodAndDessertTableAnnotationComposer,
    $$FoodAndDessertTableCreateCompanionBuilder,
    $$FoodAndDessertTableUpdateCompanionBuilder,
    (
      FoodAndDessertData,
      BaseReferences<_$AppDatabase, $FoodAndDessertTable, FoodAndDessertData>
    ),
    FoodAndDessertData,
    PrefetchHooks Function()>;
typedef $$ShoppingTableCreateCompanionBuilder = ShoppingCompanion Function({
  Value<int> id,
  required String title,
  required String shoppingList,
  Value<DateTime?> createdAt,
  Value<bool> isAIGenerated,
});
typedef $$ShoppingTableUpdateCompanionBuilder = ShoppingCompanion Function({
  Value<int> id,
  Value<String> title,
  Value<String> shoppingList,
  Value<DateTime?> createdAt,
  Value<bool> isAIGenerated,
});

class $$ShoppingTableFilterComposer
    extends Composer<_$AppDatabase, $ShoppingTable> {
  $$ShoppingTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get shoppingList => $composableBuilder(
      column: $table.shoppingList, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAIGenerated => $composableBuilder(
      column: $table.isAIGenerated, builder: (column) => ColumnFilters(column));
}

class $$ShoppingTableOrderingComposer
    extends Composer<_$AppDatabase, $ShoppingTable> {
  $$ShoppingTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get title => $composableBuilder(
      column: $table.title, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get shoppingList => $composableBuilder(
      column: $table.shoppingList,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
      column: $table.createdAt, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAIGenerated => $composableBuilder(
      column: $table.isAIGenerated,
      builder: (column) => ColumnOrderings(column));
}

class $$ShoppingTableAnnotationComposer
    extends Composer<_$AppDatabase, $ShoppingTable> {
  $$ShoppingTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get shoppingList => $composableBuilder(
      column: $table.shoppingList, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<bool> get isAIGenerated => $composableBuilder(
      column: $table.isAIGenerated, builder: (column) => column);
}

class $$ShoppingTableTableManager extends RootTableManager<
    _$AppDatabase,
    $ShoppingTable,
    ShoppingData,
    $$ShoppingTableFilterComposer,
    $$ShoppingTableOrderingComposer,
    $$ShoppingTableAnnotationComposer,
    $$ShoppingTableCreateCompanionBuilder,
    $$ShoppingTableUpdateCompanionBuilder,
    (ShoppingData, BaseReferences<_$AppDatabase, $ShoppingTable, ShoppingData>),
    ShoppingData,
    PrefetchHooks Function()> {
  $$ShoppingTableTableManager(_$AppDatabase db, $ShoppingTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ShoppingTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ShoppingTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ShoppingTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> title = const Value.absent(),
            Value<String> shoppingList = const Value.absent(),
            Value<DateTime?> createdAt = const Value.absent(),
            Value<bool> isAIGenerated = const Value.absent(),
          }) =>
              ShoppingCompanion(
            id: id,
            title: title,
            shoppingList: shoppingList,
            createdAt: createdAt,
            isAIGenerated: isAIGenerated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String title,
            required String shoppingList,
            Value<DateTime?> createdAt = const Value.absent(),
            Value<bool> isAIGenerated = const Value.absent(),
          }) =>
              ShoppingCompanion.insert(
            id: id,
            title: title,
            shoppingList: shoppingList,
            createdAt: createdAt,
            isAIGenerated: isAIGenerated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$ShoppingTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $ShoppingTable,
    ShoppingData,
    $$ShoppingTableFilterComposer,
    $$ShoppingTableOrderingComposer,
    $$ShoppingTableAnnotationComposer,
    $$ShoppingTableCreateCompanionBuilder,
    $$ShoppingTableUpdateCompanionBuilder,
    (ShoppingData, BaseReferences<_$AppDatabase, $ShoppingTable, ShoppingData>),
    ShoppingData,
    PrefetchHooks Function()>;
typedef $$MenuTableCreateCompanionBuilder = MenuCompanion Function({
  Value<int> id,
  required String itemType,
  required String mealType,
  required DateTime datetime,
  required String content,
  required String recipe,
  Value<bool> isRecipeUpdated,
  Value<bool> isAllergensUpdated,
});
typedef $$MenuTableUpdateCompanionBuilder = MenuCompanion Function({
  Value<int> id,
  Value<String> itemType,
  Value<String> mealType,
  Value<DateTime> datetime,
  Value<String> content,
  Value<String> recipe,
  Value<bool> isRecipeUpdated,
  Value<bool> isAllergensUpdated,
});

class $$MenuTableFilterComposer extends Composer<_$AppDatabase, $MenuTable> {
  $$MenuTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnFilters(column));

  ColumnFilters<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnFilters(column));

  ColumnFilters<String> get recipe => $composableBuilder(
      column: $table.recipe, builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isRecipeUpdated => $composableBuilder(
      column: $table.isRecipeUpdated,
      builder: (column) => ColumnFilters(column));

  ColumnFilters<bool> get isAllergensUpdated => $composableBuilder(
      column: $table.isAllergensUpdated,
      builder: (column) => ColumnFilters(column));
}

class $$MenuTableOrderingComposer extends Composer<_$AppDatabase, $MenuTable> {
  $$MenuTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
      column: $table.id, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get itemType => $composableBuilder(
      column: $table.itemType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get mealType => $composableBuilder(
      column: $table.mealType, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<DateTime> get datetime => $composableBuilder(
      column: $table.datetime, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get content => $composableBuilder(
      column: $table.content, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<String> get recipe => $composableBuilder(
      column: $table.recipe, builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isRecipeUpdated => $composableBuilder(
      column: $table.isRecipeUpdated,
      builder: (column) => ColumnOrderings(column));

  ColumnOrderings<bool> get isAllergensUpdated => $composableBuilder(
      column: $table.isAllergensUpdated,
      builder: (column) => ColumnOrderings(column));
}

class $$MenuTableAnnotationComposer
    extends Composer<_$AppDatabase, $MenuTable> {
  $$MenuTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get itemType =>
      $composableBuilder(column: $table.itemType, builder: (column) => column);

  GeneratedColumn<String> get mealType =>
      $composableBuilder(column: $table.mealType, builder: (column) => column);

  GeneratedColumn<DateTime> get datetime =>
      $composableBuilder(column: $table.datetime, builder: (column) => column);

  GeneratedColumn<String> get content =>
      $composableBuilder(column: $table.content, builder: (column) => column);

  GeneratedColumn<String> get recipe =>
      $composableBuilder(column: $table.recipe, builder: (column) => column);

  GeneratedColumn<bool> get isRecipeUpdated => $composableBuilder(
      column: $table.isRecipeUpdated, builder: (column) => column);

  GeneratedColumn<bool> get isAllergensUpdated => $composableBuilder(
      column: $table.isAllergensUpdated, builder: (column) => column);
}

class $$MenuTableTableManager extends RootTableManager<
    _$AppDatabase,
    $MenuTable,
    MenuData,
    $$MenuTableFilterComposer,
    $$MenuTableOrderingComposer,
    $$MenuTableAnnotationComposer,
    $$MenuTableCreateCompanionBuilder,
    $$MenuTableUpdateCompanionBuilder,
    (MenuData, BaseReferences<_$AppDatabase, $MenuTable, MenuData>),
    MenuData,
    PrefetchHooks Function()> {
  $$MenuTableTableManager(_$AppDatabase db, $MenuTable table)
      : super(TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MenuTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MenuTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MenuTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<int> id = const Value.absent(),
            Value<String> itemType = const Value.absent(),
            Value<String> mealType = const Value.absent(),
            Value<DateTime> datetime = const Value.absent(),
            Value<String> content = const Value.absent(),
            Value<String> recipe = const Value.absent(),
            Value<bool> isRecipeUpdated = const Value.absent(),
            Value<bool> isAllergensUpdated = const Value.absent(),
          }) =>
              MenuCompanion(
            id: id,
            itemType: itemType,
            mealType: mealType,
            datetime: datetime,
            content: content,
            recipe: recipe,
            isRecipeUpdated: isRecipeUpdated,
            isAllergensUpdated: isAllergensUpdated,
          ),
          createCompanionCallback: ({
            Value<int> id = const Value.absent(),
            required String itemType,
            required String mealType,
            required DateTime datetime,
            required String content,
            required String recipe,
            Value<bool> isRecipeUpdated = const Value.absent(),
            Value<bool> isAllergensUpdated = const Value.absent(),
          }) =>
              MenuCompanion.insert(
            id: id,
            itemType: itemType,
            mealType: mealType,
            datetime: datetime,
            content: content,
            recipe: recipe,
            isRecipeUpdated: isRecipeUpdated,
            isAllergensUpdated: isAllergensUpdated,
          ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ));
}

typedef $$MenuTableProcessedTableManager = ProcessedTableManager<
    _$AppDatabase,
    $MenuTable,
    MenuData,
    $$MenuTableFilterComposer,
    $$MenuTableOrderingComposer,
    $$MenuTableAnnotationComposer,
    $$MenuTableCreateCompanionBuilder,
    $$MenuTableUpdateCompanionBuilder,
    (MenuData, BaseReferences<_$AppDatabase, $MenuTable, MenuData>),
    MenuData,
    PrefetchHooks Function()>;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$AllergensTableTableManager get allergens =>
      $$AllergensTableTableManager(_db, _db.allergens);
  $$FoodAndDessertTableTableManager get foodAndDessert =>
      $$FoodAndDessertTableTableManager(_db, _db.foodAndDessert);
  $$ShoppingTableTableManager get shopping =>
      $$ShoppingTableTableManager(_db, _db.shopping);
  $$MenuTableTableManager get menu => $$MenuTableTableManager(_db, _db.menu);
}
