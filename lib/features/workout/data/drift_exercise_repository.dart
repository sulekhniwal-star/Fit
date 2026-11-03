import 'dart:convert';
import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/exercise.dart';
import 'exercise_library_seed.dart';

class DriftExerciseRepository {
  final AppDatabase _db;
  bool _isSeeded = false;

  DriftExerciseRepository(this._db);

  /// Seeds default exercises if table is empty.
  Future<void> ensureSeeded() async {
    if (_isSeeded) return;

    final count = await _db.customSelect('SELECT COUNT(*) as c FROM exercises_table').getSingle();
    final rowCount = count.read<int>('c');

    if (rowCount < 30) {
      await _db.batch((batch) {
        batch.insertAllOnConflictUpdate(
          _db.exercisesTable,
          kDefaultExerciseSeedCatalog.map((item) => ExercisesTableCompanion.insert(
                id: item.id,
                name: item.name,
                hindiName: Value(item.hindiName),
                primaryMuscle: item.primaryMuscle.name,
                secondaryMusclesJson: Value(
                  jsonEncode(item.secondaryMuscles.map((m) => m.name).toList()),
                ),
                equipment: item.equipment.name,
                workoutType: item.workoutType.name,
                difficulty: Value(item.difficulty.name),
                instructions: Value(item.instructions),
                isHomeFriendly: Value(item.isHomeFriendly),
                isSystem: Value(item.isSystem),
              )),
        );
      });
    }

    _isSeeded = true;
  }

  /// Searches the exercise catalog by name / Hindi name and filters.
  Future<Result<List<Exercise>>> search({
    String query = '',
    MuscleGroup? primaryMuscle,
    EquipmentType? equipment,
    WorkoutType? workoutType,
    bool? isHomeFriendly,
    int limit = 50,
  }) async {
    try {
      await ensureSeeded();

      var selectQuery = _db.select(_db.exercisesTable);

      if (query.trim().isNotEmpty) {
        final clean = '%${query.trim().toLowerCase()}%';
        selectQuery = selectQuery
          ..where((tbl) => tbl.name.lower().like(clean) | tbl.hindiName.lower().like(clean));
      }

      if (primaryMuscle != null) {
        selectQuery = selectQuery..where((tbl) => tbl.primaryMuscle.equals(primaryMuscle.name));
      }

      if (equipment != null) {
        selectQuery = selectQuery..where((tbl) => tbl.equipment.equals(equipment.name));
      }

      if (workoutType != null) {
        selectQuery = selectQuery..where((tbl) => tbl.workoutType.equals(workoutType.name));
      }

      if (isHomeFriendly != null) {
        selectQuery = selectQuery..where((tbl) => tbl.isHomeFriendly.equals(isHomeFriendly));
      }

      selectQuery = selectQuery
        ..orderBy([(tbl) => OrderingTerm.asc(tbl.name)])
        ..limit(limit);

      final rows = await selectQuery.get();
      final exercises = rows.map(_mapRowToExercise).toList();
      return Result.success(exercises);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to search exercises: $e'));
    }
  }

  /// Retrieves an exercise by ID.
  Future<Result<Exercise>> getById(String id) async {
    try {
      await ensureSeeded();
      final row = await (_db.select(_db.exercisesTable)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
      if (row == null) {
        return const Result.failure(DatabaseFailure('Exercise not found'));
      }
      return Result.success(_mapRowToExercise(row));
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to retrieve exercise: $e'));
    }
  }

  /// Inserts or updates a user-defined custom exercise.
  Future<Result<Exercise>> addCustomExercise(Exercise exercise) async {
    try {
      await ensureSeeded();
      await _db.into(_db.exercisesTable).insertOnConflictUpdate(
            ExercisesTableCompanion.insert(
              id: exercise.id,
              name: exercise.name,
              hindiName: Value(exercise.hindiName),
              primaryMuscle: exercise.primaryMuscle.name,
              secondaryMusclesJson: Value(
                jsonEncode(exercise.secondaryMuscles.map((m) => m.name).toList()),
              ),
              equipment: exercise.equipment.name,
              workoutType: exercise.workoutType.name,
              difficulty: Value(exercise.difficulty.name),
              instructions: Value(exercise.instructions),
              isHomeFriendly: Value(exercise.isHomeFriendly),
              isSystem: const Value(false),
            ),
          );
      return Result.success(exercise);
    } catch (e) {
      return Result.failure(DatabaseFailure('Failed to add custom exercise: $e'));
    }
  }

  Exercise _mapRowToExercise(ExercisesTableData row) {
    List<MuscleGroup> secondary = [];
    try {
      final decoded = jsonDecode(row.secondaryMusclesJson) as List<dynamic>;
      secondary = decoded
          .map((m) => MuscleGroup.values.firstWhere(
                (v) => v.name == m,
                orElse: () => MuscleGroup.coreAbs,
              ))
          .toList();
    } catch (_) {
      secondary = [];
    }

    return Exercise(
      id: row.id,
      name: row.name,
      hindiName: row.hindiName,
      primaryMuscle: MuscleGroup.values.firstWhere(
        (m) => m.name == row.primaryMuscle,
        orElse: () => MuscleGroup.fullBody,
      ),
      secondaryMuscles: secondary,
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == row.equipment,
        orElse: () => EquipmentType.bodyweight,
      ),
      workoutType: WorkoutType.values.firstWhere(
        (w) => w.name == row.workoutType,
        orElse: () => WorkoutType.strength,
      ),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (d) => d.name == row.difficulty,
        orElse: () => ExerciseDifficulty.beginner,
      ),
      instructions: row.instructions,
      isHomeFriendly: row.isHomeFriendly,
      isSystem: row.isSystem,
    );
  }
}

final exerciseRepositoryProvider = Provider<DriftExerciseRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return DriftExerciseRepository(db);
});
