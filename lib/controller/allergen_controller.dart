import 'package:drift/drift.dart';
import '../database/app_database.dart';

// Define the allergens controller
class AllergensController {
  // Database instance
  final AppDatabase db;

  // Constructor
  AllergensController(this.db);

  // Insert allergens
  Future<void> insertAllergens(String allergen) async {
    await db.into(db.allergens).insert(
          AllergensCompanion(
            allergens: Value(allergen),
          ),
        );
  }

  // Fetch all allergens items
  Future<List<Allergen>> fetchAllergensItems() async {
    return await db.select(db.allergens).get();
  }

  // Fetch an allergen item
  Future<Allergen> fetchAllergenItem(int id) async {
    return await (db.select(db.allergens)..where((tbl) => tbl.id.equals(id)))
        .getSingle();
  }

  // Update an allergen item
  Future<void> updateAllergenItem(int id, String allergen) async {
    await db.update(db.allergens).replace(
          AllergensCompanion(
            id: Value(id),
            allergens: Value(allergen),
          ),
        );
  }

  // Delete all allergens items
  Future<void> deleteAllAllergensItems() async {
    await db.delete(db.allergens).go();
  }

  // Delete an allergen item
  Future<void> deleteAllergenItem(int id) async {
    await (db.delete(db.allergens)..where((tbl) => tbl.id.equals(id))).go();
  }
}
