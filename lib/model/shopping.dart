import 'package:drift/drift.dart';

// Define the shopping model
class Shopping extends Table {
  // Primary key of the table.
  IntColumn get id => integer().named("ID").autoIncrement()();

  // Title of the shopping list.
  TextColumn get title => text().named("Title").withLength(min: 1, max: 32)();

  // Shopping list.
  TextColumn get shoppingList => text().named('Shopping_List')();

  // Date and time of the shopping list.
  DateTimeColumn get createdAt => dateTime().named("Created_At").nullable()();

  // Determine whether the shopping list is AI-generated.
  BoolColumn get isAIGenerated =>
      boolean().named("AI_Generated").withDefault(const Constant(false))();
}
