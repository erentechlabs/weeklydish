import 'package:drift/drift.dart';
import '../extension/food_list_converter.dart';

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

  // Determine whether the recipe is updated.
  BoolColumn get isRecipeUpdated =>
      boolean().named("Recipe_Updated").withDefault(const Constant(false))();

  // Determine whether the allergens are updated.
  BoolColumn get isAllergensUpdated =>
      boolean().named("Allergens_Updated").withDefault(const Constant(false))();
}
