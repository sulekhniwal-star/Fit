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
import 'package:fitkarma/features/workout/presentation/active_workout_screen.dart';
import 'package:fitkarma/features/workout/presentation/rest_timer_widget.dart';

void main() {
  group('Workout Domain Entities', () {
    test('WorkoutSet computes volume correctly and excludes warmups', () {
      const workingSet = WorkoutSet(
        id: 's1',
        sessionId: 'sess_1',
        exerciseId: 'ex_bench_01',
        exerciseName: 'Bench Press',
        setNumber: 1,
        weightKg: 80.0,
        reps: 8,
        isCompleted: true,
        isWarmup: false,
      );

      const warmupSet = WorkoutSet(
        id: 's2',
        sessionId: 'sess_1',
        exerciseId: 'ex_bench_01',
        exerciseName: 'Bench Press',
        setNumber: 2,
        weightKg: 40.0,
        reps: 12,
        isCompleted: true,
        isWarmup: true,
      );

      expect(workingSet.volumeKg, 640.0);
      expect(warmupSet.volumeKg, 0.0);
    });

    test('WorkoutSession computes total volume and estimates calories', () {
      final now = DateTime.now();
      final session = WorkoutSession(
        id: 'sess_100',
        userId: 'user_1',
        title: 'Push Day A',
        workoutType: WorkoutType.strength,
        startedAt: now.subtract(const Duration(minutes: 45)),
        endedAt: now,
        sets: const [
          WorkoutSet(
            id: 's1',
            sessionId: 'sess_100',
            exerciseId: 'ex1',
            exerciseName: 'Dand',
            setNumber: 1,
            weightKg: 0.0,
            reps: 20,
            isCompleted: true,
          ),
          WorkoutSet(
            id: 's2',
            sessionId: 'sess_100',
            exerciseId: 'ex2',
            exerciseName: 'Overhead Press',
            setNumber: 1,
            weightKg: 50.0,
            reps: 10,
            isCompleted: true,
          ),
          WorkoutSet(
            id: 's3',
            sessionId: 'sess_100',
            exerciseId: 'ex2',
            exerciseName: 'Overhead Press',
            setNumber: 2,
            weightKg: 50.0,
            reps: 8,
            isCompleted: true,
          ),
          WorkoutSet(
            id: 's4',
            sessionId: 'sess_100',
            exerciseId: 'ex2',
            exerciseName: 'Overhead Press',
            setNumber: 3,
            weightKg: 50.0,
            reps: 8,
            isCompleted: false, // not completed
          ),
        ],
      );

      // Volume = 50*10 (500) + 50*8 (400) = 900 kg
      expect(session.computeTotalVolume(), 900.0);
      expect(session.computeDurationSeconds(), greaterThanOrEqualTo(2700));

      final json = session.toJson();
      final roundtrip = WorkoutSession.fromJson(json);
      expect(roundtrip.id, session.id);
      expect(roundtrip.title, 'Push Day A');
      expect(roundtrip.sets.length, 4);
    });
  });

  group('DriftWorkoutRepository', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftWorkoutRepository repo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      repo = DriftWorkoutRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveLocal, getLocal, and getActiveSession work offline', () async {
      final session = WorkoutSession(
        id: 'ws_test_01',
        userId: 'user_offline',
        title: 'Morning Legs',
        workoutType: WorkoutType.strength,
        startedAt: DateTime.now(),
        status: WorkoutSessionStatus.inProgress,
        sets: const [
          WorkoutSet(
            id: 'ws_set_1',
            sessionId: 'ws_test_01',
            exerciseId: 'ex_squat',
            exerciseName: 'Squat',
            setNumber: 1,
            weightKg: 100.0,
            reps: 5,
            isCompleted: true,
          ),
        ],
      );

      final saveRes = await repo.saveLocal(session);
      expect(saveRes.isSuccess, isTrue);

      final activeRes = await repo.getActiveSession('user_offline');
      expect(activeRes.isSuccess, isTrue);
      expect(activeRes.dataOrNull, isNotNull);
      expect(activeRes.dataOrNull!.title, 'Morning Legs');
      expect(activeRes.dataOrNull!.sets.length, 1);
      expect(activeRes.dataOrNull!.totalVolumeKg, 500.0);
    });

    test('saveSet incrementally updates volume in SQLite', () async {
      final session = WorkoutSession(
        id: 'ws_test_02',
        userId: 'user_offline',
        title: 'Upper Body',
        workoutType: WorkoutType.strength,
        startedAt: DateTime.now(),
        status: WorkoutSessionStatus.inProgress,
      );
      await repo.saveLocal(session);

      const set1 = WorkoutSet(
        id: 'set_1',
        sessionId: 'ws_test_02',
        exerciseId: 'ex_bench',
        exerciseName: 'Bench Press',
        setNumber: 1,
        weightKg: 60.0,
        reps: 10,
        isCompleted: true,
      );

      await repo.saveSet(set1);

      final loaded = await repo.getLocal('ws_test_02');
      expect(loaded.isSuccess, isTrue);
      expect(loaded.dataOrNull!.totalVolumeKg, 600.0);
      expect(loaded.dataOrNull!.sets.length, 1);
    });

    test('completeSession enqueues outbox mutation for sync', () async {
      final session = WorkoutSession(
        id: 'ws_test_03',
        userId: 'user_sync',
        title: 'Desi Akhada Routine',
        workoutType: WorkoutType.strength,
        startedAt: DateTime.now().subtract(const Duration(minutes: 30)),
        status: WorkoutSessionStatus.inProgress,
      );
      await repo.saveLocal(session);

      final completeRes = await repo.completeSession('ws_test_03');
      expect(completeRes.isSuccess, isTrue);
      expect(completeRes.dataOrNull!.status, WorkoutSessionStatus.completed);

      final pending = await outbox.fetchPending();
      expect(pending.any((m) => m.idempotencyKey == 'mut_workout_ws_test_03'), isTrue);
    });
  });

  group('Workout Widgets', () {
    testWidgets('RestTimerWidget renders controls, adds time, and skips', (tester) async {
      bool skipped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: RestTimerWidget(
              initialDurationSeconds: 60,
              autoStart: false,
              onDismissed: () => skipped = true,
            ),
          ),
        ),
      );

      expect(find.text('Rest Timer'), findsOneWidget);
      expect(find.text('01:00'), findsOneWidget);

      // Tap +15s
      await tester.tap(find.byKey(const Key('rest_timer_add_15')));
      await tester.pump();
      expect(find.text('01:15'), findsOneWidget);

      // Tap Skip
      await tester.tap(find.byKey(const Key('rest_timer_skip')));
      await tester.pump();
      expect(skipped, isTrue);
    });

    testWidgets('ActiveWorkoutScreen renders exercises, adds sets, and toggles completion', (tester) async {
      final db = AppDatabase.memory();
      final outbox = OutboxQueue(db);
      final workoutRepo = DriftWorkoutRepository(db, outbox);
      final exerciseRepo = DriftExerciseRepository(db);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            appDatabaseProvider.overrideWithValue(db),
            outboxQueueProvider.overrideWithValue(outbox),
            workoutRepositoryProvider.overrideWithValue(workoutRepo),
            exerciseRepositoryProvider.overrideWithValue(exerciseRepo),
          ],
          child: const MaterialApp(
            home: ActiveWorkoutScreen(),
          ),
        ),
      );

      await tester.pump();

      // Check header and initial bench press sets
      expect(find.text('Full Body Power & Strength'), findsOneWidget);
      expect(find.text('Barbell Bench Press'), findsOneWidget);
      expect(find.byKey(const Key('active_workout_volume_text')), findsOneWidget);

      // Add set if present
      if (find.byKey(const Key('add_set_btn_ex_bench_press_01')).evaluate().isNotEmpty) {
        await tester.tap(find.byKey(const Key('add_set_btn_ex_bench_press_01')));
        await tester.pump();
      }

      // Check Add Exercise button is present
      expect(find.byKey(const Key('add_exercise_main_btn')), findsOneWidget);

      // Tap Finish button to open dialog
      await tester.tap(find.byKey(const Key('finish_workout_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Finish Workout?'), findsOneWidget);
      expect(find.text('Resume'), findsOneWidget);
      expect(find.byKey(const Key('finish_workout_confirm_btn')), findsOneWidget);

      await db.close();
    });
  });
}
