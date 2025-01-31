import 'package:drift/drift.dart';
import '../extension/food_list_converter.dart';

// Define the menu model
class FoodAndDessert extends Table {
  // Primary key of the table.
  IntColumn get id => integer().autoIncrement()();

  // it can take values like "food" or "dessert".
  TextColumn get itemType => text().named("Item_Type")();

  // Meal information such as breakfast, lunch, dinner.
  TextColumn get mealType => text().named("Meal_Type")();

  // Food or dessert list (stored as a list).
  TextColumn get content =>
      text().named("Content").map(const ListConverter())();
}
