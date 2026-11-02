import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/food_item.dart';
import '../domain/portion_unit.dart';
import 'food_catalog_seed.dart';

class DriftFoodCatalogRepository {
  final AppDatabase _db;
  bool _isSeeded = false;

  DriftFoodCatalogRepository(this._db);

  /// Guarantees that the 500+ authentic Indian items are seeded into the local encrypted table.
  Future<void> ensureSeeded() async {
    if (_isSeeded) return;

    final count = await _db.customSelect('SELECT COUNT(*) as c FROM food_catalog_entries_table').getSingle();
    final rowCount = count.read<int>('c');

    if (rowCount < 500) {
      final items = FoodCatalogSeed.getAllSeedItems();
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.foodCatalogEntriesTable,
          items.map((item) => FoodCatalogEntriesTableCompanion.insert(
                id: item.id,
                name: item.name,
                hindiName: Value(item.hindiName),
                category: item.category.name,
                caloriesPer100g: item.caloriesPer100g,
                proteinPer100g: item.proteinPer100g,
                carbsPer100g: item.carbsPer100g,
                fatPer100g: item.fatPer100g,
                fiberPer100g: Value(item.fiberPer100g),
                isVegetarian: Value(item.isVegetarian),
                isEgg: Value(item.isEgg),
                isVegan: Value(item.isVegan),
                cuisineRegion: Value(item.cuisineRegion),
                defaultPortionUnit: Value(item.defaultPortionUnit.name),
                basePortionGrams: Value(item.basePortionGrams),
                provenance: Value(item.provenance),
              )),
        );
      });
    }

    _isSeeded = true;
  }

  /// Searches food catalog using English or Hindi terms with optional category filtering.
  Future<Result<List<FoodItem>>> search(
    String query, {
    FoodCategory? category,
    int limit = 50,
  }) async {
    await ensureSeeded();

    final cleanQuery = query.trim().toLowerCase();
    var selectQuery = _db.select(_db.foodCatalogEntriesTable);

    if (cleanQuery.isNotEmpty) {
      selectQuery = selectQuery
        ..where((tbl) =>
            tbl.name.lower().contains(cleanQuery) |
            tbl.hindiName.lower().contains(cleanQuery));
    }

    if (category != null) {
      selectQuery = selectQuery..where((tbl) => tbl.category.equals(category.name));
    }

    selectQuery = selectQuery
      ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)])
      ..limit(limit);

    final rows = await selectQuery.get();
    return Result.success(rows.map(_fromRow).toList());
  }

  /// Retrieves a specific food item by ID.
  Future<Result<FoodItem>> getById(String id) async {
    await ensureSeeded();

    final row = await (_db.select(_db.foodCatalogEntriesTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return const Result.failure(ValidationFailure(message: 'Food item not found'));
    }
    return Result.success(_fromRow(row));
  }

  /// Retrieves total item count in local catalog.
  Future<int> getItemCount() async {
    await ensureSeeded();
    final count = await _db.customSelect('SELECT COUNT(*) as c FROM food_catalog_entries_table').getSingle();
    return count.read<int>('c');
  }

  FoodItem _fromRow(FoodCatalogEntriesTableData row) {
    return FoodItem(
      id: row.id,
      name: row.name,
      hindiName: row.hindiName,
      category: FoodCategory.values.firstWhere(
        (c) => c.name == row.category,
        orElse: () => FoodCategory.sabzisCurries,
      ),
      caloriesPer100g: row.caloriesPer100g,
      proteinPer100g: row.proteinPer100g,
      carbsPer100g: row.carbsPer100g,
      fatPer100g: row.fatPer100g,
      fiberPer100g: row.fiberPer100g,
      isVegetarian: row.isVegetarian,
      isEgg: row.isEgg,
      isVegan: row.isVegan,
      cuisineRegion: row.cuisineRegion,
      defaultPortionUnit: PortionUnit.values.firstWhere(
        (u) => u.name == row.defaultPortionUnit,
        orElse: () => PortionUnit.mediumKatori,
      ),
      basePortionGrams: row.basePortionGrams,
      provenance: row.provenance,
    );
  }
}

final foodCatalogRepositoryProvider = Provider<DriftFoodCatalogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftFoodCatalogRepository(db);
});
