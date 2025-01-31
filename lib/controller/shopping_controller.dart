import 'package:drift/drift.dart';
import '../database/app_database.dart';

// Define the shopping controller
class ShoppingController {
  // Database instance
  final AppDatabase db;

  // Constructor
  ShoppingController(this.db);

  // Insert a shopping item
  Future<void> insertShoppingItem(
      String title, String contentJson, bool isAIGenerated) async {
    await db.into(db.shopping).insert(
          ShoppingCompanion(
            title: Value(title),
            shoppingList: Value(contentJson),
            createdAt: Value(DateTime.now()),
            isAIGenerated: Value(isAIGenerated),
          ),
        );
  }

  // Fetch all shopping items
  Future<List<ShoppingData>> fetchShoppingItems() async {
    return await db.select(db.shopping).get();
  }

  // Fetch a shopping item
  Future<ShoppingData> fetchShoppingItem(int id) async {
    return await (db.select(db.shopping)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // Update a shopping item
  Future<void> updateShoppingItem(
      int id, String title, String contentJson, bool isAIGenerated) async {
    await db.update(db.shopping).replace(
          ShoppingCompanion(
            id: Value(id),
            title: Value(title),
            shoppingList: Value(contentJson),
            createdAt: Value(DateTime.now()),
            isAIGenerated: Value(isAIGenerated),
          ),
        );
  }

  // Delete all shopping items
  Future<void> deleteAllShoppingItems() async {
    await db.delete(db.shopping).go();
  }

  // Delete a shopping item
  Future<void> deleteShoppingItem(int id) async {
    await (db.delete(db.shopping)..where((tbl) => tbl.id.equals(id))).go();
  }
}
