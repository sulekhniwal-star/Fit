import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/health/domain/sleep_record.dart';
import 'package:fitkarma/features/health/domain/step_record.dart';

void main() {
  group('Sleep & Step Engine Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftStepRepository stepRepo;
    late DriftSleepRepository sleepRepo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      stepRepo = DriftStepRepository(db, outbox);
      sleepRepo = DriftSleepRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('SleepRecord.fromInterval accurately calculates overnight duration across midnight', () {
      final start = DateTime(2026, 11, 2, 23, 30);
      final end = DateTime(2026, 11, 2, 7, 0); // End before start -> adjusted to next day

      final record = SleepRecord.fromInterval(
        id: 's1',
        userId: 'u1',
        startTime: start,
        endTime: end,
        qualityRating: 4,
      );

      // 23:30 to 07:00 next day = 7 hours 30 mins = 450 minutes
      expect(record.durationMinutes, equals(450));
      expect(record.durationFormatted, equals('7h 30m'));
    });

    test('DriftSleepRepository saves sleep record and retrieves history', () async {
      final record = SleepRecord(
        id: 'sleep-1',
        userId: 'u1',
        startTime: DateTime(2026, 11, 2, 23, 0),
        endTime: DateTime(2026, 11, 3, 7, 0),
        durationMinutes: 480,
        qualityRating: 4,
      );

      final saveResult = await sleepRepo.saveLocal(record);
      expect(saveResult.isSuccess, isTrue);

      final historyResult = await sleepRepo.getHistory('u1');
      expect(historyResult.isSuccess, isTrue);
      historyResult.when(
        onSuccess: (history) {
          expect(history.length, equals(1));
          expect(history.first.durationMinutes, equals(480));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('StepRecord computes progressRatio and goal met state', () {
      final record = StepRecord(
        id: 'step-1',
        userId: 'u1',
        date: DateTime.now(),
        stepCount: 8500,
        goal: 10000,
      );

      expect(record.progressRatio, equals(0.85));
      expect(record.isGoalMet, isFalse);

      final completedRecord = record.copyWith(stepCount: 10500);
      expect(completedRecord.progressRatio, equals(1.0));
      expect(completedRecord.isGoalMet, isTrue);
    });

    test('DriftStepRepository stores and retrieves step count for date', () async {
      final today = DateTime.now();
      final record = StepRecord(
        id: 'step-today',
        userId: 'u1',
        date: today,
        stepCount: 7500,
        goal: 10000,
        source: HealthSource.manual,
      );

      await stepRepo.saveLocal(record);

      final fetchResult = await stepRepo.getForDate('u1', today);
      expect(fetchResult.isSuccess, isTrue);
      fetchResult.when(
        onSuccess: (r) {
          expect(r, isNotNull);
          expect(r!.stepCount, equals(7500));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });
  });
}

