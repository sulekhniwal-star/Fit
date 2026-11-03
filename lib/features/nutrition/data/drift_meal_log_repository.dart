import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/sync_coordinator.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/cooking_multiplier.dart';
import '../domain/family_recipe.dart';
import '../domain/food_log_entry.dart';
import '../domain/portion_unit.dart';
import '../domain/tadka_model.dart';

class DriftMealLogRepository extends SyncableRepository<FoodLogEntry, String> {
  final AppDatabase _db;

  DriftMealLogRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'food_logs';

  @override
  Future<Result<FoodLogEntry>> getLocal(String id) async {
    final row = await (_db.select(_db.mealLogsTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
    if (row == null) return const Result.failure(ValidationFailure(message: 'Meal log not found'));
    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(FoodLogEntry entity) async {
    if (!entity.isValid) {
      return const Result.failure(ValidationFailure(message: 'Meal log values are invalid'));
    }

    await _db.into(_db.mealLogsTable).insertOnConflictUpdate(
          MealLogsTableCompanion.insert(
            id: entity.id,
            userId: entity.userId,
            loggedAt: entity.loggedAt,
            mealSlot: entity.mealSlot.name,
            foodName: entity.foodName,
            portionQuantity: entity.portionQuantity,
            portionUnit: entity.portionUnit.name,
            cookingState: Value(entity.cookingState.name),
            tadkaLevel: Value(entity.tadkaLevel.name),
            tadkaFatSource: Value(entity.tadkaFatSource.name),
            calories: entity.calories,
            proteinGrams: entity.proteinGrams,
            carbsGrams: entity.carbsGrams,
            fatGrams: entity.fatGrams,
            fiberGrams: Value(entity.fiberGrams),
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_meal_${entity.id}',
      entityType: entityType,
      operation: OutboxOperation.insert,
      payload: entity.toJson(),
      idempotencyKey: 'meal_${entity.id}_${entity.loggedAt.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.mealLogsTable)..where((tbl) => tbl.id.equals(id))).go();

    final mutation = SyncMutation(
      id: 'mut_del_meal_$id',
      entityType: entityType,
      operation: OutboxOperation.delete,
      payload: {'id': id},
      idempotencyKey: 'del_meal_${id}_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  /// Retrieves all meal logs for a specific calendar day.
  Future<Result<List<FoodLogEntry>>> getForDay(String userId, DateTime date) async {
    final startOfDay = DateTime(date.year, date.month, date.day);
    final endOfDay = DateTime(date.year, date.month, date.day, 23, 59, 59);

    final rows = await (_db.select(_db.mealLogsTable)
          ..where((tbl) => tbl.userId.equals(userId) & tbl.loggedAt.isBetweenValues(startOfDay, endOfDay))
          ..orderBy([(tbl) => OrderingTerm.asc(tbl.loggedAt)]))
        .get();

    return Result.success(rows.map(_fromRow).toList());
  }

  /// Computes cumulative daily macronutrient totals.
  Future<Result<NutritionValues>> getDailyMacroTotals(String userId, DateTime date) async {
    final listResult = await getForDay(userId, date);
    if (listResult.isFailure) return Result.failure(listResult.failureOrNull!);

    final entries = listResult.dataOrNull ?? [];
    double cal = 0.0;
    double p = 0.0;
    double c = 0.0;
    double f = 0.0;
    double fib = 0.0;

    for (final e in entries) {
      cal += e.calories;
      p += e.proteinGrams;
      c += e.carbsGrams;
      f += e.fatGrams;
      fib += e.fiberGrams;
    }

    return Result.success(NutritionValues(
      calories: double.parse(cal.toStringAsFixed(1)),
      proteinGrams: double.parse(p.toStringAsFixed(1)),
      carbsGrams: double.parse(c.toStringAsFixed(1)),
      fatGrams: double.parse(f.toStringAsFixed(1)),
      fiberGrams: double.parse(fib.toStringAsFixed(1)),
    ));
  }

  // --- FAMILY RECIPES SUPPORT ---

  Future<Result<void>> saveRecipe(FamilyRecipe recipe) async {
    await _db.into(_db.recipesTable).insertOnConflictUpdate(
          RecipesTableCompanion.insert(
            id: recipe.id,
            userId: recipe.userId,
            name: recipe.name,
            ingredientsJson: recipe.ingredientsJson,
            totalYieldGramsOrKatoris: recipe.totalYieldGramsOrKatoris,
            totalCalories: recipe.totalNutrition.calories,
            totalProtein: recipe.totalNutrition.proteinGrams,
            totalCarbs: recipe.totalNutrition.carbsGrams,
            totalFat: recipe.totalNutrition.fatGrams,
            totalFiber: Value(recipe.totalNutrition.fiberGrams),
            createdAt: recipe.createdAt,
          ),
        );

    final mutation = SyncMutation(
      id: 'mut_recipe_${recipe.id}',
      entityType: 'recipes',
      operation: OutboxOperation.insert,
      payload: recipe.toJson(),
      idempotencyKey: 'recipe_${recipe.id}_${recipe.createdAt.millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  Future<Result<List<FamilyRecipe>>> getAllRecipes(String userId) async {
    final rows = await (_db.select(_db.recipesTable)..where((tbl) => tbl.userId.equals(userId))).get();
    final list = rows.map((r) {
      final rawList = jsonDecode(r.ingredientsJson) as List<dynamic>? ?? [];
      final ingredients = rawList.map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>)).toList();
      return FamilyRecipe(
        id: r.id,
        userId: r.userId,
        name: r.name,
        ingredients: ingredients,
        totalYieldGramsOrKatoris: r.totalYieldGramsOrKatoris,
        createdAt: r.createdAt,
      );
    }).toList();

    return Result.success(list);
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async => const Result.success(null);

  @override
  Future<Result<int>> pullRemote(DateTime since) async => const Result.success(0);

  FoodLogEntry _fromRow(MealLogsTableData row) {
    return FoodLogEntry(
      id: row.id,
      userId: row.userId,
      loggedAt: row.loggedAt,
      mealSlot: MealSlot.values.firstWhere(
        (m) => m.name == row.mealSlot,
        orElse: () => MealSlot.lunch,
      ),
      foodName: row.foodName,
      portionQuantity: row.portionQuantity,
      portionUnit: PortionUnit.values.firstWhere(
        (u) => u.name == row.portionUnit,
        orElse: () => PortionUnit.mediumKatori,
      ),
      cookingState: CookingState.values.firstWhere(
        (c) => c.name == row.cookingState,
        orElse: () => CookingState.cooked,
      ),
      tadkaLevel: TadkaLevel.values.firstWhere(
        (t) => t.name == row.tadkaLevel,
        orElse: () => TadkaLevel.none,
      ),
      tadkaFatSource: TadkaFatSource.values.firstWhere(
        (f) => f.name == row.tadkaFatSource,
        orElse: () => TadkaFatSource.oil,
      ),
      calories: row.calories,
      proteinGrams: row.proteinGrams,
      carbsGrams: row.carbsGrams,
      fatGrams: row.fatGrams,
      fiberGrams: row.fiberGrams,
    );
  }
}

final mealLogRepositoryProvider = Provider<DriftMealLogRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final queue = ref.watch(outboxQueueProvider);
  return DriftMealLogRepository(db, queue);
});
