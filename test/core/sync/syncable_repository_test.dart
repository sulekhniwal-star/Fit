import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/errors/failures.dart';
import 'package:fitkarma/core/sync/models/outbox_mutation.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/realtime_sync_bridge.dart';
import 'package:fitkarma/features/profile/data/drift_profile_repository.dart';
import 'package:fitkarma/features/profile/domain/user_profile.dart';

void main() {
  group('DriftProfileRepository Syncable Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftProfileRepository repository;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      repository = DriftProfileRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveProfile saves locally and enqueues outbox mutation', () async {
      final profile = UserProfile(
        userId: 'u1',
        displayName: 'Aarav Patel',
        age: 29,
        biologicalSex: BiologicalSex.male,
        heightCm: 175.0,
        weightKg: 74.0,
        activityLevel: ActivityLevel.moderatelyActive,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      final saveResult = await repository.saveProfile(profile);
      expect(saveResult.isSuccess, isTrue);

      // Verify local retrieval
      final getResult = await repository.getProfile('u1');
      expect(getResult.isSuccess, isTrue);
      getResult.when(
        onSuccess: (p) => expect(p.displayName, equals('Aarav Patel')),
        onFailure: (_) => fail('Expected success'),
      );

      // Verify outbox mutation was enqueued
      final pending = await outbox.fetchPending();
      expect(pending.length, equals(1));
      expect(pending.first.entityType, equals('user_profiles'));
      expect(pending.first.operation, equals(OutboxOperation.update));
      expect(pending.first.payload['display_name'], equals('Aarav Patel'));
    });

    test('rejects invalid profile without enqueuing outbox mutation', () async {
      final invalidProfile = UserProfile(
        userId: 'u2',
        displayName: 'Invalid',
        age: -5,
        biologicalSex: BiologicalSex.male,
        heightCm: 175.0,
        weightKg: 70.0,
        activityLevel: ActivityLevel.sedentary,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      final result = await repository.saveProfile(invalidProfile);
      expect(result.isFailure, isTrue);
      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (f) => expect(f, isA<ValidationFailure>()),
      );

      // No mutation was enqueued
      expect(await outbox.getPendingCount(), equals(0));
    });

    test('deleteProfile removes record and enqueues delete mutation', () async {
      final profile = UserProfile(
        userId: 'u3',
        displayName: 'To Delete',
        age: 25,
        biologicalSex: BiologicalSex.female,
        heightCm: 160.0,
        weightKg: 55.0,
        activityLevel: ActivityLevel.lightlyActive,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );
      await repository.saveProfile(profile);
      await outbox.purgeCompleted();

      final deleteResult = await repository.deleteProfile('u3');
      expect(deleteResult.isSuccess, isTrue);

      final getResult = await repository.getProfile('u3');
      expect(getResult.isFailure, isTrue);

      // Outbox now has delete mutation
      final pending = await outbox.fetchPending();
      expect(pending.any((m) => m.operation == OutboxOperation.delete), isTrue);
    });
  });

  group('RealtimeSyncBridge Tests', () {
    late RealtimeSyncBridge bridge;

    setUp(() {
      bridge = RealtimeSyncBridge();
    });

    test('dispatches realtime payload to registered table handler', () async {
      bool handled = false;
      bridge.registerHandler('user_profiles', (eventType, table, record) async {
        handled = true;
        expect(eventType, equals('UPDATE'));
        expect(record['user_id'], equals('u123'));
      });

      final result = await bridge.handleRealtimePayload({
        'eventType': 'UPDATE',
        'table': 'user_profiles',
        'record': {'user_id': 'u123', 'name': 'Updated'},
      });

      expect(result, isTrue);
      expect(handled, isTrue);
    });

    test('suppresses duplicate event if idempotency key is acknowledged', () async {
      bridge.recordAcknowledgedKey('idemp-known-123');

      bool handled = false;
      bridge.registerHandler('user_profiles', (eventType, table, record) async {
        handled = true;
      });

      final result = await bridge.handleRealtimePayload({
        'eventType': 'INSERT',
        'table': 'user_profiles',
        'record': {'idempotency_key': 'idemp-known-123'},
      });

      expect(result, isFalse); // Suppressed echo
      expect(handled, isFalse);
    });
  });
}
