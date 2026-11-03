import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/database/app_database.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../../health/data/drift_health_repositories.dart';
import '../../health/data/drift_vitals_repositories.dart';
import '../../health/domain/sleep_record.dart';
import '../../nutrition/data/drift_meal_log_repository.dart';
import '../../workout/data/drift_workout_repository.dart';
import '../../workout/domain/workout_session.dart';
import '../domain/dip_models.dart';
import '../domain/dip_rule_engine.dart';

class DipRepository {
  final DriftStepRepository stepRepo;
  final DriftSleepRepository sleepRepo;
  final DriftVitalsRepository vitalsRepo;
  final DriftWaterRepository waterRepo;
  final DriftMealLogRepository mealRepo;
  final DriftWorkoutRepository workoutRepo;
  final DipRuleEngine _ruleEngine;

  DipRepository({
    required this.stepRepo,
    required this.sleepRepo,
    required this.vitalsRepo,
    required this.waterRepo,
    required this.mealRepo,
    required this.workoutRepo,
    DipRuleEngine? ruleEngine,
  })  : _ruleEngine = ruleEngine ?? DipRuleEngine();

  Future<DipContextInput> assembleContextInput(
    String userId,
    DateTime date,
  ) async {
    // 1. Steps
    final stepRes = await stepRepo.getForDate(userId, date);
    final todaySteps = stepRes.dataOrNull?.stepCount ?? 0;
    final stepGoal = stepRes.dataOrNull?.goal ?? 10000;

    // 2. Sleep (most recent night)
    final sleepRes = await sleepRepo.getHistory(userId, limit: 3);
    final sleepList = sleepRes.dataOrNull ?? [];
    SleepRecord? latestSleep;
    if (sleepList.isNotEmpty) {
      // Find sleep ending today or last 24 hours
      for (final s in sleepList) {
        if (s.endTime.year == date.year &&
            s.endTime.month == date.month &&
            s.endTime.day == date.day) {
          latestSleep = s;
          break;
        }
      }
      latestSleep ??= sleepList.first;
    }

    // 3. Resting Heart Rate from Vitals
    final vitalsRes = await vitalsRepo.getRecent(userId, limit: 10);
    final vitalsList = vitalsRes.dataOrNull ?? [];
    double? restingHeartRate;
    for (final v in vitalsList) {
      if (v.pulse != null) {
        restingHeartRate = v.pulse!.toDouble();
        break;
      }
    }

    // 4. Hydration
    final waterRes = await waterRepo.getDailyTotalMl(userId, date);
    final consumedWaterMl = waterRes.dataOrNull ?? 0;

    // 5. Nutrition & Meals
    final mealsRes = await mealRepo.getForDay(userId, date);
    final meals = mealsRes.dataOrNull ?? [];

    double consumedCalories = 0.0;
    DateTime? recentMealTimestamp;
    double? recentMealCalories;

    for (final m in meals) {
      consumedCalories += m.calories;
      if (recentMealTimestamp == null || m.loggedAt.isAfter(recentMealTimestamp)) {
        recentMealTimestamp = m.loggedAt;
        recentMealCalories = m.calories;
      }
    }

    // 6. Workout Sessions & Workload (ACWR)
    final workoutsRes = await workoutRepo.getRecentSessions(userId, limit: 30);
    final sessions = workoutsRes.dataOrNull ?? [];

    final now = date;
    final sevenDaysAgo = now.subtract(const Duration(days: 7));
    final twentyEightDaysAgo = now.subtract(const Duration(days: 28));

    double acuteWorkload = 0.0;
    double twentyEightDayVolume = 0.0;
    int todayWorkoutsCount = 0;

    for (final s in sessions) {
      if (s.status != WorkoutSessionStatus.completed) continue;

      if (s.startedAt.year == date.year &&
          s.startedAt.month == date.month &&
          s.startedAt.day == date.day) {
        todayWorkoutsCount++;
      }

      if (s.startedAt.isAfter(sevenDaysAgo)) {
        acuteWorkload += s.totalVolumeKg;
      }

      if (s.startedAt.isAfter(twentyEightDaysAgo)) {
        twentyEightDayVolume += s.totalVolumeKg;
      }
    }

    // Chronic workload = weekly average over 4 weeks
    final chronicWorkload = twentyEightDayVolume > 0 ? (twentyEightDayVolume / 4.0) : 0.0;

    return DipContextInput(
      userId: userId,
      timestamp: date,
      sleep: latestSleep,
      todaySteps: todaySteps,
      stepGoal: stepGoal,
      restingHeartRate: restingHeartRate,
      acuteWorkload: acuteWorkload,
      chronicWorkload: chronicWorkload,
      consumedCalories: consumedCalories,
      targetCalories: 2000.0,
      consumedWaterMl: consumedWaterMl,
      targetWaterMl: 3000,
      recentMealTimestamp: recentMealTimestamp,
      recentMealCalories: recentMealCalories,
      todayWorkoutsCount: todayWorkoutsCount,
    );
  }

  Future<DailyIntelligencePackage> getDailyIntelligencePackage(
    String userId, {
    DateTime? date,
  }) async {
    final effectiveDate = date ?? DateTime.now();
    final input = await assembleContextInput(userId, effectiveDate);
    return _ruleEngine.assemblePackage(input);
  }
}

// --- RIVERPOD PROVIDERS ---

final dipRuleEngineProvider = Provider<DipRuleEngine>((ref) {
  return DipRuleEngine();
});

final dipRepositoryProvider = Provider<DipRepository>((ref) {
  final db = ref.watch(appDatabaseProvider);
  final outbox = OutboxQueue(db);

  return DipRepository(
    stepRepo: DriftStepRepository(db, outbox),
    sleepRepo: DriftSleepRepository(db, outbox),
    vitalsRepo: DriftVitalsRepository(db, outbox),
    waterRepo: DriftWaterRepository(db, outbox),
    mealRepo: DriftMealLogRepository(db, outbox),
    workoutRepo: DriftWorkoutRepository(db, outbox),
    ruleEngine: ref.watch(dipRuleEngineProvider),
  );
});

final dailyIntelligencePackageProvider =
    FutureProvider<DailyIntelligencePackage>((ref) async {
  final authState = ref.watch(authStateNotifierProvider);
  final userId = authState is AuthAuthenticated ? authState.user.id : 'user_default';
  final repo = ref.watch(dipRepositoryProvider);
  return repo.getDailyIntelligencePackage(userId);
});
