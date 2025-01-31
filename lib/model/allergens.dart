import 'package:drift/drift.dart';

// Define the allergens model
class Allergens extends Table {
  // Primary key of the table.
  IntColumn get id => integer().named("ID").autoIncrement()();

  // New added allergens name.
  TextColumn get allergens => text().named("Allergens")();
}
