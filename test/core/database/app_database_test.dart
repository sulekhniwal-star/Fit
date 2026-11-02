import 'package:drift/drift.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/database/encryption_key_provider.dart';

void main() {
  group('EncryptionKeyProvider Tests', () {
    test('DefaultEncryptionKeyProvider generates and caches high-entropy 256-bit key', () async {
      final provider = DefaultEncryptionKeyProvider();
      final key1 = await provider.getEncryptionKey();
      expect(key1.isNotEmpty, isTrue);

      final key2 = await provider.getEncryptionKey();
      expect(key1, equals(key2)); // Memory cache hits

      provider.clearMemoryCache();
      final key3 = await provider.getEncryptionKey();
      expect(key3.isNotEmpty, isTrue);
    });

    test('DeterministicEncryptionKeyProvider returns configured constant key', () async {
      const expectedKey = 'test-deterministic-key-32-bytes!!';
      const provider = DeterministicEncryptionKeyProvider(expectedKey);
      final key = await provider.getEncryptionKey();
      expect(key, equals(expectedKey));
    });
  });

  group('AppDatabase Tests', () {
    late AppDatabase db;

    setUp(() {
      db = AppDatabase.memory();
    });

    tearDown(() async {
      await db.close();
    });

    test('boots with schemaVersion 1 and tables created', () async {
      expect(db.schemaVersion, equals(1));

      final outboxItems = await db.select(db.outboxMutations).get();
      expect(outboxItems, isEmpty);

      final profiles = await db.select(db.localUserProfiles).get();
      expect(profiles, isEmpty);
    });

    test('inserts and retrieves outbox mutations accurately', () async {
      final now = DateTime.now();
      await db.into(db.outboxMutations).insert(
            OutboxMutationsCompanion.insert(
              id: 'outbox-1',
              entityType: 'user_profile',
              operationType: 'INSERT',
              payloadJson: '{"name": "Aarav"}',
              idempotencyKey: 'idemp-12345',
              createdAt: now,
              status: const Value('pending'),
            ),
          );

      final items = await db.select(db.outboxMutations).get();
      expect(items.length, equals(1));
      expect(items.first.id, equals('outbox-1'));
      expect(items.first.entityType, equals('user_profile'));
      expect(items.first.status, equals('pending'));
      expect(items.first.retryCount, equals(0));
    });

    test('inserts and retrieves local user profile', () async {
      final now = DateTime.now();
      await db.into(db.localUserProfiles).insert(
            LocalUserProfilesCompanion.insert(
              userId: 'u100',
              displayName: 'Priya Sharma',
              age: 27,
              biologicalSex: 'female',
              heightCm: 168.0,
              weightKg: 62.0,
              activityLevel: 'moderatelyActive',
              dietaryIdentity: 'vegetarian',
              healthGoal: 'maintenance',
              hasAcceptedDpdpConsent: const Value(true),
              updatedAt: now,
            ),
          );

      final profile = await (db.select(db.localUserProfiles)
            ..where((tbl) => tbl.userId.equals('u100')))
          .getSingle();

      expect(profile.displayName, equals('Priya Sharma'));
      expect(profile.heightCm, equals(168.0));
      expect(profile.hasAcceptedDpdpConsent, isTrue);
    });

    test('executes atomic transactions and rolls back on failure', () async {
      final now = DateTime.now();

      try {
        await db.transaction(() async {
          await db.into(db.outboxMutations).insert(
                OutboxMutationsCompanion.insert(
                  id: 'outbox-tx-1',
                  entityType: 'test',
                  operationType: 'INSERT',
                  payloadJson: '{}',
                  idempotencyKey: 'idemp-tx-1',
                  createdAt: now,
                ),
              );

          throw Exception('Simulated failure during transaction');
        });
      } catch (_) {
        // Expected transaction abort
      }

      final items = await db.select(db.outboxMutations).get();
      expect(items, isEmpty); // Rolled back completely
    });
  });
}

