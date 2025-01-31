import 'package:drift/drift.dart';
import '../database/app_database.dart';

// Define the food and dessert controller
class FoodAndDessertController {
  // Database instance
  final AppDatabase db;

  // Constructor
  FoodAndDessertController(this.db);

  // Insert a food or dessert item
  Future<void> insertFoodAndDessert(
      String itemType, String mealType, List<String> content) async {
    await db.into(db.foodAndDessert).insert(
          FoodAndDessertCompanion(
            itemType: Value(itemType),
            mealType: Value(mealType),
            content: Value(content),
          ),
        );
  }

  // Fetch all food and dessert items
  Future<List<FoodAndDessertData>> fetchAllFoodAndDessertItems() async {
    return await db.select(db.foodAndDessert).get();
  }

  // Fetch food or dessert items by type
  Future<List<FoodAndDessertData>> fetchItemsByType(String itemType) async {
    return await (db.select(db.foodAndDessert)
          ..where((tbl) => tbl.itemType.equals(itemType)))
        .get();
  }

  // Fetch food or dessert items by type and meal type
  Future<List<FoodAndDessertData>> fetchItemsByTypeAndMeal(
      String itemType, String mealType) async {
    return await (db.select(db.foodAndDessert)
          ..where((tbl) =>
              tbl.itemType.equals(itemType) & tbl.mealType.equals(mealType)))
        .get();
  }

  // Fetch a food or dessert item
  Future<FoodAndDessertData> fetchFoodAndDessertItem(int id) async {
    return await (db.select(db.foodAndDessert)
          ..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // Update a food or dessert item
  Future<void> updateFoodAndDessertItem(
    int id,
    String itemType,
    String mealType,
    List<String> content,
  ) async {
    await db.update(db.foodAndDessert).replace(
          FoodAndDessertCompanion(
            id: Value(id),
            itemType: Value(itemType),
            mealType: Value(mealType),
            content: Value(content),
          ),
        );
  }

  // Delete all food and dessert items
  Future<void> deleteAllFoodAndDessertItems() async {
    await db.delete(db.foodAndDessert).go();
  }

  // Delete a food or dessert item
  Future<void> deleteFoodAndDessertItem(int id) async {
    await (db.delete(db.foodAndDessert)..where((tbl) => tbl.id.equals(id)))
        .go();
  }

  // Delete food or dessert items by type
  Future<void> deleteItemsByType(String itemType) async {
    await (db.delete(db.foodAndDessert)
          ..where((tbl) => tbl.itemType.equals(itemType)))
        .go();
  }
}
