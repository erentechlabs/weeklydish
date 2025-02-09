import 'package:drift/drift.dart';

// Define the menu model
class Menu extends Table {
  // Primary key of the table.
  IntColumn get id => integer().autoIncrement()();

  // it can take values like "food" or "dessert".
  TextColumn get itemType => text().named("Item_Type")();

  // Meal information such as breakfast, lunch, dinner.
  TextColumn get mealType => text().named("Meal_Type")();

  // Date and time of the meal.
  DateTimeColumn get datetime => dateTime().named("Datetime")();

  // Food or dessert list (stored as a list).
  TextColumn get content => text().named("Content")();

  // Recipe list (in the same order as the foods/desserts).
  TextColumn get recipe => text().named("Recipe")();

  // Calories list (in the same order as the foods/desserts).
  IntColumn get calories => integer().named("Calories")();

  // Protein list (in the same order as the foods/desserts).
  IntColumn get protein => integer().named("Protein")();

  // Carbohydrate list (in the same order as the foods/desserts).
  IntColumn get carbohydrate => integer().named("Carbohydrate")();

  // Fat list (in the same order as the foods/desserts).
  IntColumn get fat => integer().named("Fat")();

  // Determine whether the recipe is updated.
  BoolColumn get isMenuDetailUpdate =>
      boolean().named("Menu_Detail_Updated").withDefault(const Constant(false))();

  // Determine whether the allergens are updated.
  BoolColumn get isAllergensUpdated =>
      boolean().named("Allergens_Updated").withDefault(const Constant(false))();
}
