import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/cooking_multiplier.dart';
import '../domain/food_item.dart';
import 'cooking_multipliers_seed.dart';

class DriftCookingRepository {
  final AppDatabase _db;
  bool _isSeeded = false;

  DriftCookingRepository(this._db);

  Future<void> ensureSeeded() async {
    if (_isSeeded) return;

    final count = await _db.customSelect('SELECT COUNT(*) as c FROM cooking_multipliers_table').getSingle();
    final rowCount = count.read<int>('c');

    if (rowCount == 0) {
      await _db.batch((batch) {
        batch.insertAll(
          _db.cookingMultipliersTable,
          CookingMultipliersSeed.standardMultipliers.map((m) => CookingMultipliersTableCompanion.insert(
                id: m.id,
                foodCategory: m.foodCategory.name,
                yieldFactor: m.yieldFactor,
                waterAbsorptionPct: Value(m.waterAbsorptionPct),
                version: Value(m.version),
                notes: Value(m.notes),
              )),
        );
      });
    }

    _isSeeded = true;
  }

  Future<Result<CookingYieldMultiplier>> getMultiplier(
    FoodCategory category, {
    int version = 1,
  }) async {
    await ensureSeeded();

    final row = await (_db.select(_db.cookingMultipliersTable)
          ..where((tbl) => tbl.foodCategory.equals(category.name) & tbl.version.equals(version))
          ..limit(1))
        .getSingleOrNull();

    if (row == null) {
      // Default to 1.0 if not found
      return Result.success(CookingYieldMultiplier(
        id: 'default_${category.name}',
        foodCategory: category,
        yieldFactor: 1.0,
        version: version,
        notes: 'Fallback default 1:1 yield',
      ));
    }

    return Result.success(_fromRow(row));
  }

  Future<Result<CookingYieldMultiplier>> getMultiplierById(String id) async {
    await ensureSeeded();

    final row = await (_db.select(_db.cookingMultipliersTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) {
      return const Result.failure(ValidationFailure(message: 'Multiplier not found'));
    }
    return Result.success(_fromRow(row));
  }

  Future<Result<List<CookingYieldMultiplier>>> getAllMultipliers() async {
    await ensureSeeded();
    final rows = await _db.select(_db.cookingMultipliersTable).get();
    return Result.success(rows.map(_fromRow).toList());
  }

  CookingYieldMultiplier _fromRow(CookingMultipliersTableData row) {
    return CookingYieldMultiplier(
      id: row.id,
      foodCategory: FoodCategory.values.firstWhere(
        (c) => c.name == row.foodCategory,
        orElse: () => FoodCategory.sabzisCurries,
      ),
      yieldFactor: row.yieldFactor,
      waterAbsorptionPct: row.waterAbsorptionPct,
      version: row.version,
      notes: row.notes,
    );
  }
}

final cookingRepositoryProvider = Provider<DriftCookingRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftCookingRepository(db);
});
