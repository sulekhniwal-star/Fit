import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/workout/domain/exercise.dart';
import 'package:fitkarma/features/workout/domain/recovery_readiness_calculator.dart';
import 'package:fitkarma/features/workout/domain/volume_progression_calculator.dart';
import 'package:fitkarma/features/workout/domain/workout_session.dart';
import 'package:fitkarma/features/workout/domain/workout_set.dart';

void main() {
  group('VolumeProgressionCalculator Tests', () {
    const calc = VolumeProgressionCalculator();
    final now = DateTime(2026, 3, 10, 10, 0);

    test('calculateSessionVolume accurately ignores warmups and uncompleted sets', () {
      final session = WorkoutSession(
        id: 's1',
        userId: 'u1',
        title: 'Leg Day',
        workoutType: WorkoutType.strength,
        startedAt: now,
        sets: const [
          WorkoutSet(
            id: 'set1',
            sessionId: 's1',
            exerciseId: 'ex_squat',
            exerciseName: 'Squat',
            setNumber: 1,
            weightKg: 60.0,
            reps: 10,
            isCompleted: true,
            isWarmup: true, // warmup: 0
          ),
          WorkoutSet(
            id: 'set2',
            sessionId: 's1',
            exerciseId: 'ex_squat',
            exerciseName: 'Squat',
            setNumber: 2,
            weightKg: 100.0,
            reps: 5,
            isCompleted: true,
            isWarmup: false, // 500
          ),
          WorkoutSet(
            id: 'set3',
            sessionId: 's1',
            exerciseId: 'ex_squat',
            exerciseName: 'Squat',
            setNumber: 3,
            weightKg: 100.0,
            reps: 5,
            isCompleted: false, // uncompleted: 0
            isWarmup: false,
          ),
        ],
      );

      expect(calc.calculateSessionVolume(session), 500.0);
    });

    test('calculateWeeklyTotalVolume sums completed sessions inside the 7-day window', () {
      final session1 = WorkoutSession(
        id: 's1',
        userId: 'u1',
        title: 'Workout 1',
        workoutType: WorkoutType.strength,
        startedAt: DateTime(2026, 3, 11),
        totalVolumeKg: 1200.0,
        status: WorkoutSessionStatus.completed,
      );
      final session2 = WorkoutSession(
        id: 's2',
        userId: 'u1',
        title: 'Workout 2',
        workoutType: WorkoutType.strength,
        startedAt: DateTime(2026, 3, 13),
        totalVolumeKg: 1800.0,
        status: WorkoutSessionStatus.completed,
      );
      final sessionOld = WorkoutSession(
        id: 's_old',
        userId: 'u1',
        title: 'Workout Old',
        workoutType: WorkoutType.strength,
        startedAt: DateTime(2026, 3, 1),
        totalVolumeKg: 3000.0,
        status: WorkoutSessionStatus.completed,
      );

      final total = calc.calculateWeeklyTotalVolume(
        [session1, session2, sessionOld],
        DateTime(2026, 3, 10),
      );

      expect(total, 3000.0);
    });

    test('calculateWeeklyVolumeByMuscle partitions tonnage per muscle group', () {
      final session = WorkoutSession(
        id: 's1',
        userId: 'u1',
        title: 'Upper Day',
        workoutType: WorkoutType.strength,
        startedAt: DateTime(2026, 3, 11),
        status: WorkoutSessionStatus.completed,
        sets: const [
          WorkoutSet(
            id: 'set1',
            sessionId: 's1',
            exerciseId: 'ex_bench',
            exerciseName: 'Bench Press',
            setNumber: 1,
            weightKg: 80.0,
            reps: 10,
            isCompleted: true,
          ),
          WorkoutSet(
            id: 'set2',
            sessionId: 's1',
            exerciseId: 'ex_row',
            exerciseName: 'Barbell Row',
            setNumber: 1,
            weightKg: 70.0,
            reps: 10,
            isCompleted: true,
          ),
        ],
      );

      final muscleMap = {
        'ex_bench': MuscleGroup.chest,
        'ex_row': MuscleGroup.back,
      };

      final breakdown = calc.calculateWeeklyVolumeByMuscle(
        sessions: [session],
        exerciseToMuscleMap: muscleMap,
        windowStart: DateTime(2026, 3, 10),
      );

      expect(breakdown[MuscleGroup.chest], 800.0);
      expect(breakdown[MuscleGroup.back], 700.0);
    });

    test('calculateVolumeTrend calculates percentage deltas accurately', () {
      expect(calc.calculateVolumeTrend(currentWeekVolume: 5500.0, previousWeekVolume: 5000.0), 10.0);
      expect(calc.calculateVolumeTrend(currentWeekVolume: 4000.0, previousWeekVolume: 5000.0), -20.0);
      expect(calc.calculateVolumeTrend(currentWeekVolume: 3000.0, previousWeekVolume: 0.0), 100.0);
    });
  });

  group('RecoveryReadinessCalculator Tests', () {
    const calc = RecoveryReadinessCalculator();

    test('high sleep and balanced ACWR produces High Readiness tier', () {
      final result = calc.calculateReadiness(
        sleepMinutes: 480, // 8 hours
        acuteWorkloadKg: 10000.0,
        chronicWorkloadKg: 10000.0, // ACWR 1.0 (optimal)
        subjectiveMoodScore: 5,
      );

      expect(result.score, greaterThanOrEqualTo(75));
      expect(result.tier, ReadinessTier.high);
      expect(result.guidance, contains('Peak Condition'));
      expect(result.disclaimer, contains('not medical or physical therapy clearance'));
    });

    test('poor sleep and heavy workload spike produces Recovery tier', () {
      final result = calc.calculateReadiness(
        sleepMinutes: 240, // 4 hours
        acuteWorkloadKg: 20000.0,
        chronicWorkloadKg: 10000.0, // ACWR 2.0 (spike)
        subjectiveMoodScore: 2,
      );

      expect(result.score, lessThan(50));
      expect(result.tier, ReadinessTier.recovery);
      expect(result.guidance, contains('Active Recovery Recommended'));
    });
  });
}
