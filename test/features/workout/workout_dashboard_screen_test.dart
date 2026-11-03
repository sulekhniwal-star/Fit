import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/features/workout/data/drift_exercise_repository.dart';
import 'package:fitkarma/features/workout/data/drift_workout_repository.dart';
import 'package:fitkarma/features/workout/domain/exercise.dart';
import 'package:fitkarma/features/workout/domain/workout_session.dart';
import 'package:fitkarma/features/workout/domain/workout_set.dart';
import 'package:fitkarma/features/workout/presentation/workout_dashboard_screen.dart';

void main() {
  group('WorkoutDashboardScreen Widget Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftWorkoutRepository workoutRepo;
    late DriftExerciseRepository exerciseRepo;
    const testUserId = 'test_athlete_1';

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      workoutRepo = DriftWorkoutRepository(db, outbox);
      exerciseRepo = DriftExerciseRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    Widget createScreen() {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          outboxQueueProvider.overrideWithValue(outbox),
          workoutRepositoryProvider.overrideWithValue(workoutRepo),
          exerciseRepositoryProvider.overrideWithValue(exerciseRepo),
        ],
        child: const MaterialApp(
          home: WorkoutDashboardScreen(userId: testUserId),
        ),
      );
    }

    testWidgets('renders all core dashboard cards: readiness, volume, quick start, and history',
        (tester) async {
      // Pre-populate a completed workout
      final session = WorkoutSession(
        id: 'ws_hist_1',
        userId: testUserId,
        title: 'Akhada Leg Blast',
        workoutType: WorkoutType.strength,
        startedAt: DateTime.now().subtract(const Duration(hours: 2)),
        endedAt: DateTime.now().subtract(const Duration(hours: 1)),
        durationSeconds: 3600,
        totalVolumeKg: 4200.0,
        status: WorkoutSessionStatus.completed,
        sets: const [
          WorkoutSet(
            id: 'ws_set_1',
            sessionId: 'ws_hist_1',
            exerciseId: 'ex_baithak_01',
            exerciseName: 'Baithak (Hindu Squat)',
            setNumber: 1,
            weightKg: 84.0,
            reps: 50,
            isCompleted: true,
          ),
        ],
      );
      await workoutRepo.saveLocal(session);

      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Verify Screen Title
      expect(find.text('Fitness & Workout'), findsOneWidget);

      // Verify Recovery Readiness Card
      expect(find.text('Recovery Readiness'), findsOneWidget);
      expect(find.byKey(const Key('readiness_score_text')), findsOneWidget);
      expect(find.textContaining('not medical or physical therapy clearance'), findsOneWidget);

      // Verify Weekly Volume Progression Card
      expect(find.text('Weekly Volume Progress'), findsOneWidget);
      expect(find.byKey(const Key('weekly_volume_tonnage_text')), findsOneWidget);
      expect(find.text('4200 kg'), findsWidgets);

      // Verify Quick Start Routines Card
      expect(find.text('Quick Start Routines'), findsOneWidget);
      expect(find.byKey(const Key('quick_start_empty')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_surya')), findsOneWidget);
      expect(find.byKey(const Key('quick_start_akhada')), findsOneWidget);

      // Verify Recent Workouts Section
      await tester.scrollUntilVisible(find.text('Recent Workouts'), 200);
      expect(find.text('Recent Workouts'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Akhada Leg Blast'), 200);
      expect(find.text('Akhada Leg Blast'), findsOneWidget);

      // Verify FAB
      expect(find.byKey(const Key('start_workout_fab')), findsOneWidget);
    });

    testWidgets('tapping Quick Start Surya Namaskar launches ActiveWorkoutScreen with Yoga routine',
        (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pumpAndSettle();

      // Tap Surya Namaskar quick chip
      await tester.tap(find.byKey(const Key('quick_start_surya')));
      await tester.pumpAndSettle();

      // Should have pushed ActiveWorkoutScreen
      expect(find.text('Surya Namaskar Flow (सूर्य नमस्कार)'), findsOneWidget);
      expect(find.text('Surya Namaskar'), findsOneWidget);
      expect(find.byKey(const Key('finish_workout_btn')), findsOneWidget);
    });
  });
}
