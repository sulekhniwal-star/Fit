import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/brain/data/dip_repository.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/health/domain/sleep_record.dart';
import 'package:fitkarma/features/health/domain/step_record.dart';
import 'package:fitkarma/features/health/domain/vital_record.dart';
import 'package:fitkarma/features/health/domain/water_log.dart';
import 'package:fitkarma/features/nutrition/data/drift_meal_log_repository.dart';
import 'package:fitkarma/features/nutrition/domain/food_log_entry.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';
import 'package:fitkarma/features/workout/data/drift_workout_repository.dart';
import 'package:fitkarma/features/workout/domain/exercise.dart';
import 'package:fitkarma/features/workout/domain/workout_session.dart';
import 'package:fitkarma/features/workout/domain/workout_set.dart';

void main() {
  group('DipRepository Aggregation Integration Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftStepRepository stepRepo;
    late DriftSleepRepository sleepRepo;
    late DriftVitalsRepository vitalsRepo;
    late DriftWaterRepository waterRepo;
    late DriftMealLogRepository mealRepo;
    late DriftWorkoutRepository workoutRepo;
    late DipRepository dipRepo;

    const testUserId = 'user_dip_integration';
    final today = DateTime(2026, 11, 3, 13, 0); // 1:00 PM

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      stepRepo = DriftStepRepository(db, outbox);
      sleepRepo = DriftSleepRepository(db, outbox);
      vitalsRepo = DriftVitalsRepository(db, outbox);
      waterRepo = DriftWaterRepository(db, outbox);
      mealRepo = DriftMealLogRepository(db, outbox);
      workoutRepo = DriftWorkoutRepository(db, outbox);

      dipRepo = DipRepository(
        stepRepo: stepRepo,
        sleepRepo: sleepRepo,
        vitalsRepo: vitalsRepo,
        waterRepo: waterRepo,
        mealRepo: mealRepo,
        workoutRepo: workoutRepo,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('assembleContextInput accurately queries across 6 Drift tables', () async {
      // 1. Seed Steps
      await stepRepo.saveLocal(
        StepRecord(
          id: 'step_1',
          userId: testUserId,
          date: today,
          stepCount: 4200,
          goal: 10000,
        ),
      );

      // 2. Seed Sleep
      await sleepRepo.saveLocal(
        SleepRecord(
          id: 'sleep_1',
          userId: testUserId,
          startTime: DateTime(2026, 11, 2, 23, 0),
          endTime: DateTime(2026, 11, 3, 7, 0),
          durationMinutes: 480,
          qualityRating: 4,
        ),
      );

      // 3. Seed Vital (RHR)
      await vitalsRepo.saveLocal(
        VitalRecord(
          id: 'vital_1',
          userId: testUserId,
          recordedAt: DateTime(2026, 11, 3, 7, 30),
          vitalType: VitalType.bloodPressure,
          systolic: 118,
          diastolic: 78,
          pulse: 62,
        ),
      );

      // 4. Seed Water
      await waterRepo.saveLocal(
        WaterLog(
          id: 'water_1',
          userId: testUserId,
          recordedAt: DateTime(2026, 11, 3, 10, 0),
          amountMl: 750,
        ),
      );

      // 5. Seed Meal
      await mealRepo.saveLocal(
        FoodLogEntry(
          id: 'meal_1',
          userId: testUserId,
          loggedAt: DateTime(2026, 11, 3, 12, 30),
          mealSlot: MealSlot.lunch,
          foodName: 'Dal Khichdi & Dahi',
          portionQuantity: 2.0,
          portionUnit: PortionUnit.mediumKatori,
          calories: 520.0,
          proteinGrams: 22.0,
          carbsGrams: 75.0,
          fatGrams: 14.0,
        ),
      );

      // 6. Seed Workout
      await workoutRepo.saveLocal(
        WorkoutSession(
          id: 'work_1',
          userId: testUserId,
          title: 'Morning Akhada Conditioning',
          workoutType: WorkoutType.strength,
          startedAt: DateTime(2026, 11, 3, 8, 0),
          endedAt: DateTime(2026, 11, 3, 8, 45),
          sets: const [
            WorkoutSet(
              id: 'set_1',
              sessionId: 'work_1',
              exerciseId: 'dand',
              exerciseName: 'Dand',
              setNumber: 1,
              weightKg: 70.0,
              reps: 50,
              isCompleted: true,
              isWarmup: false,
            ),
          ],
          status: WorkoutSessionStatus.completed,
        ),
      );

      // Assemble DIP Context
      final context = await dipRepo.assembleContextInput(testUserId, today);

      expect(context.todaySteps, equals(4200));
      expect(context.sleep?.durationMinutes, equals(480));
      expect(context.restingHeartRate, equals(62.0));
      expect(context.consumedWaterMl, equals(750));
      expect(context.consumedCalories, equals(520.0));
      expect(context.recentMealCalories, equals(520.0));
      expect(context.acuteWorkload, equals(3500.0));
      expect(context.todayWorkoutsCount, equals(1));

      // Generate complete DIP
      final dip = await dipRepo.getDailyIntelligencePackage(testUserId, date: today);

      expect(dip.readinessScore.score, greaterThanOrEqualTo(70));
      expect(dip.summaryMetrics.todaySteps, equals(4200));
      expect(dip.summaryMetrics.consumedCalories, equals(520.0));
      expect(dip.summaryMetrics.consumedWaterMl, equals(750));
      expect(dip.topActions.length, inInclusiveRange(1, 3));
      // Shatapawali should be triggered because lunch was 30 mins ago with 520 kcal
      expect(dip.topActions.any((a) => a.id == 'action_shatapawali'), isTrue);
    });
  });
}
