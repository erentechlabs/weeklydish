import 'package:drift/drift.dart';
import '../database/app_database.dart';

// Define the menu controller
class MenusController {
  // Database instance
  final AppDatabase db;

  // Constructor
  MenusController(this.db);

  // Insert a menu item
  Future<void> insertMenu(
    String itemType,
    String mealType,
    DateTime datetime,
    String content,
    String recipe,
    bool isRecipeUpdated,
    bool isAllergensUpdated,
  ) async {
    await db.into(db.menu).insert(
          MenuCompanion(
            itemType: Value(itemType),
            mealType: Value(mealType),
            datetime: Value(datetime),
            content: Value(content),
            recipe: Value(recipe),
            isRecipeUpdated: Value(isRecipeUpdated),
            isAllergensUpdated: Value(isAllergensUpdated),
          ),
        );
  }

  // Fetch all menu items
  Future<List<MenuData>> fetchMenuItems() async {
    return await db.select(db.menu).get();
  }

  // Fetch menu items by type
  Future<List<MenuData>> fetchItemsByType(String itemType) async {
    return await (db.select(db.menu)
          ..where((tbl) => tbl.itemType.equals(itemType)))
        .get();
  }

  // Fetch menu items by type and meal type
  Future<List<MenuData>> fetchItemsByTypeAndMeal(
      String itemType, String mealType) async {
    return await (db.select(db.menu)
          ..where((tbl) =>
              tbl.itemType.equals(itemType) & tbl.mealType.equals(mealType)))
        .get();
  }

  // In MenusController class
  Future<MenuData?> getMenuItemForDayAndMealType(
      DateTime date, String mealType) async {
    // Use db.select to query the menu table
    final result = await (db.select(db.menu)
          ..where((tbl) =>
              tbl.datetime.equals(date) & tbl.mealType.equals(mealType)))
        .get();

    if (result.isNotEmpty) {
      return result.first; // Return the first matching item
    } else {
      return null; // No item found for the given date and mealType
    }
  }

  // Fetch menu items by type and date
  // Fetch menu items by date and meal type
  Future<List<MenuData>> fetchItemsByDateAndMeal(
      DateTime date, String itemType, String mealType) async {
    return await (db.select(db.menu)
          ..where((tbl) =>
              tbl.datetime.equals(date) &
              tbl.itemType.equals(itemType) &
              tbl.mealType.equals(mealType)))
        .get();
  }

  // Fetch a menu item
  Future<MenuData> fetchMenuItem(int id) async {
    return await (db.select(db.menu)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // Update a menu item
  Future<void> updateFoodAndDessertItem(
    int id,
    String itemType,
    String mealType,
    DateTime datetime,
    String content,
    String recipe,
    bool isRecipeUpdated,
    bool isAllergensUpdated,
  ) async {
    await db.update(db.menu).replace(
          MenuCompanion(
            id: Value(id),
            itemType: Value(itemType),
            mealType: Value(mealType),
            datetime: Value(datetime),
            content: Value(content),
            recipe: Value(recipe),
            isRecipeUpdated: Value(isRecipeUpdated),
            isAllergensUpdated: Value(isAllergensUpdated),
          ),
        );
  }

  // Update specific fields of a menu item
  Future<void> updateMenuItem(
      int id, String newContent, bool isRecipeUpdate) async {
    await (db.update(db.menu)..where((tbl) => tbl.id.equals(id))).write(
      MenuCompanion(
        content: Value(newContent),
        isRecipeUpdated: Value(isRecipeUpdate),
      ),
    );
  }

  // Update recipe of a menu item
  Future<void> updateMenuRecipe(int id, String newRecipe, bool isRecipeUpdate,
      bool isAllergensUpdate) async {
    await (db.update(db.menu)..where((tbl) => tbl.id.equals(id))).write(
      MenuCompanion(
        recipe: Value(newRecipe),
        isRecipeUpdated: Value(isRecipeUpdate),
        isAllergensUpdated: Value(isAllergensUpdate),
      ),
    );
  }

  // Update just allergens for all menu item which equals true and false
  Future<void> updateAllergensForAllMenuItems(bool isAllergensUpdate) async {
    await db.update(db.menu).write(
          MenuCompanion(
            isAllergensUpdated: Value(isAllergensUpdate),
          ),
        );
  }

  // Delete all menu items
  Future<void> deleteAllMenuItems() async {
    await db.delete(db.menu).go();
  }

  // Delete a menu item
  Future<void> deleteMenuItem(int id) async {
    await (db.delete(db.menu)..where((tbl) => tbl.id.equals(id))).go();
  }

  // Delete menu items by type
  Future<void> deleteItemsByType(String itemType) async {
    await (db.delete(db.menu)..where((tbl) => tbl.itemType.equals(itemType)))
        .go();
  }
}
