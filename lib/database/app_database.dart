import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

import '../extension/food_list_converter.dart';
import '../model/allergens.dart';
import '../model/food_and_dessert.dart';
import '../model/menu.dart';
import '../model/shopping.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [Allergens, FoodAndDessert, Shopping, Menu])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'weekly_dish_db.sqlite'));
    return NativeDatabase(file);
  });
}
