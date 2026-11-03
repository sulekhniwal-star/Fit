import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/workout/data/drift_exercise_repository.dart';
import 'package:fitkarma/features/workout/domain/exercise.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Exercise Domain Model', () {
    test('Exercise serialization and deserialization roundtrip', () {
      const exercise = Exercise(
        id: 'test_dand',
        name: 'Dand',
        hindiName: 'दंड',
        primaryMuscle: MuscleGroup.chest,
        secondaryMuscles: [MuscleGroup.shoulders, MuscleGroup.triceps],
        equipment: EquipmentType.bodyweight,
        workoutType: WorkoutType.strength,
        difficulty: ExerciseDifficulty.intermediate,
        instructions: 'Akhada style push up',
        isHomeFriendly: true,
        isSystem: true,
      );

      final json = exercise.toJson();
      final roundtrip = Exercise.fromJson(json);

      expect(roundtrip.id, 'test_dand');
      expect(roundtrip.name, 'Dand');
      expect(roundtrip.hindiName, 'दंड');
      expect(roundtrip.primaryMuscle, MuscleGroup.chest);
      expect(roundtrip.secondaryMuscles, [MuscleGroup.shoulders, MuscleGroup.triceps]);
      expect(roundtrip.equipment, EquipmentType.bodyweight);
      expect(roundtrip.workoutType, WorkoutType.strength);
      expect(roundtrip.difficulty, ExerciseDifficulty.intermediate);
      expect(roundtrip.instructions, 'Akhada style push up');
      expect(roundtrip.isHomeFriendly, isTrue);
      expect(roundtrip.isValid, isTrue);
    });
  });

  group('DriftExerciseRepository', () {
    late AppDatabase db;
    late DriftExerciseRepository repo;

    setUp(() {
      db = AppDatabase.memory();
      repo = DriftExerciseRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('ensureSeeded populates 30+ default exercises including Akhada & Yoga', () async {
      final res = await repo.search();
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull!.length, greaterThanOrEqualTo(30));

      final dand = res.dataOrNull!.firstWhere((e) => e.name.contains('Dand'));
      expect(dand.hindiName, contains('दंड'));
      expect(dand.primaryMuscle, MuscleGroup.chest);
      expect(dand.isHomeFriendly, isTrue);
    });

    test('search filters by English and Hindi query keywords', () async {
      final englishRes = await repo.search(query: 'Push-Up');
      expect(englishRes.isSuccess, isTrue);
      expect(englishRes.dataOrNull!.isNotEmpty, isTrue);

      final hindiRes = await repo.search(query: 'सूर्य नमस्कार');
      expect(hindiRes.isSuccess, isTrue);
      expect(hindiRes.dataOrNull!.any((e) => e.name.contains('Surya Namaskar')), isTrue);
    });

    test('search filters by MuscleGroup', () async {
      final res = await repo.search(primaryMuscle: MuscleGroup.quadriceps);
      expect(res.isSuccess, isTrue);
      for (final ex in res.dataOrNull!) {
        expect(ex.primaryMuscle, MuscleGroup.quadriceps);
      }
    });

    test('search filters by EquipmentType', () async {
      final res = await repo.search(equipment: EquipmentType.dumbbells);
      expect(res.isSuccess, isTrue);
      for (final ex in res.dataOrNull!) {
        expect(ex.equipment, EquipmentType.dumbbells);
      }
    });

    test('search filters by homeFriendly flag', () async {
      final res = await repo.search(isHomeFriendly: false);
      expect(res.isSuccess, isTrue);
      for (final ex in res.dataOrNull!) {
        expect(ex.isHomeFriendly, isFalse);
      }
    });

    test('addCustomExercise persists and can be retrieved by getById', () async {
      const custom = Exercise(
        id: 'user_ex_101',
        name: 'Desi Akhada Mudgar Swings',
        hindiName: 'मुद्गर घुमाना',
        primaryMuscle: MuscleGroup.shoulders,
        secondaryMuscles: [MuscleGroup.coreAbs, MuscleGroup.back],
        equipment: EquipmentType.kettlebell,
        workoutType: WorkoutType.strength,
        difficulty: ExerciseDifficulty.advanced,
        instructions: 'Swinging traditional Indian clubbells around the neck and shoulders.',
        isHomeFriendly: true,
        isSystem: false,
      );

      final insertRes = await repo.addCustomExercise(custom);
      expect(insertRes.isSuccess, isTrue);

      final getRes = await repo.getById('user_ex_101');
      expect(getRes.isSuccess, isTrue);
      expect(getRes.dataOrNull!.name, 'Desi Akhada Mudgar Swings');
      expect(getRes.dataOrNull!.isSystem, isFalse);
    });
  });
}
