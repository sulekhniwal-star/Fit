import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/cultural/data/drift_fasting_repository.dart';
import 'package:fitkarma/features/cultural/domain/fasting_protocol.dart';
import 'package:fitkarma/features/cultural/domain/fasting_session.dart';
import 'package:fitkarma/features/cultural/presentation/fasting_state_notifier.dart';

void main() {
  group('Drift Fasting Repository & State Notifier Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftFastingRepository repo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      repo = DriftFastingRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('starts and retrieves an active fasting session', () async {
      const userId = 'user_fast_test_1';
      final now = DateTime.now();

      final session = FastingSession(
        id: 'fast_session_1',
        userId: userId,
        protocolType: FastingProtocolType.if16_8,
        startTime: now,
        plannedEndTime: now.add(const Duration(hours: 16)),
        createdAt: now,
        updatedAt: now,
      );

      final startRes = await repo.startSession(session);
      expect(startRes.isSuccess, isTrue);

      final activeRes = await repo.getActiveSession(userId);
      expect(activeRes.isSuccess, isTrue);
      activeRes.when(
        onSuccess: (active) {
          expect(active, isNotNull);
          expect(active!.id, 'fast_session_1');
          expect(active.protocolType, FastingProtocolType.if16_8);
          expect(active.status, FastingSessionStatus.active);
        },
        onFailure: (f) => fail('Failed to fetch active session: $f'),
      );
    });

    test('completing active session sets status to completed and records actualEndTime', () async {
      const userId = 'user_fast_test_2';
      final now = DateTime.now();

      final session = FastingSession(
        id: 'fast_session_2',
        userId: userId,
        protocolType: FastingProtocolType.navratri,
        startTime: now.subtract(const Duration(hours: 15)),
        plannedEndTime: now.add(const Duration(hours: 1)),
        createdAt: now.subtract(const Duration(hours: 15)),
        updatedAt: now.subtract(const Duration(hours: 15)),
      );

      await repo.startSession(session);

      final completeRes = await repo.completeSession('fast_session_2', endTime: now);
      expect(completeRes.isSuccess, isTrue);

      final activeRes = await repo.getActiveSession(userId);
      activeRes.when(
        onSuccess: (active) => expect(active, isNull),
        onFailure: (f) => fail('Failed: $f'),
      );

      final historyRes = await repo.getSessionHistory(userId);
      historyRes.when(
        onSuccess: (history) {
          expect(history.length, 1);
          expect(history.first.status, FastingSessionStatus.completed);
          expect(history.first.actualEndTime, isNotNull);
        },
        onFailure: (f) => fail('History failed: $f'),
      );
    });

    test('FastingStateNotifier correctly sets reminder suppression flags', () async {
      const userId = 'user_fast_notifier_test';
      final notifier = FastingStateNotifier(repo, userId);

      // Initially inactive
      expect(notifier.state.isFastingActive, isFalse);
      expect(notifier.state.shouldSuppressMealReminders, isFalse);
      expect(notifier.state.shouldSuppressHydrationReminders, isFalse);

      // Start standard 16:8 fast
      await notifier.startFast(protocolType: FastingProtocolType.if16_8);
      expect(notifier.state.isFastingActive, isTrue);
      expect(notifier.state.shouldSuppressMealReminders, isTrue);
      expect(notifier.state.shouldSuppressHydrationReminders, isFalse); // Water is allowed in 16:8

      // Cancel fast
      await notifier.cancelFast();
      expect(notifier.state.isFastingActive, isFalse);
      expect(notifier.state.shouldSuppressMealReminders, isFalse);

      // Start Nirjala (Karwa Chauth) dry fast
      await notifier.startFast(protocolType: FastingProtocolType.karwaChauth);
      expect(notifier.state.isFastingActive, isTrue);
      expect(notifier.state.shouldSuppressMealReminders, isTrue);
      expect(notifier.state.shouldSuppressHydrationReminders, isTrue); // Dry fast suppresses water alerts
    });
  });
}

