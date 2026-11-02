import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/models/outbox_mutation.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';

void main() {
  group('DriftBodyMetricsRepository Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftBodyMetricsRepository repository;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      repository = DriftBodyMetricsRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('saveLocal persists entry and enqueues outbox mutation', () async {
      final entry = BodyMetricEntry(
        id: 'bm-1',
        userId: 'u1',
        metricType: BodyMetricType.weight,
        value: 72.5,
        unit: HealthUnit.kg,
        recordedAt: DateTime.now(),
      );

      final saveResult = await repository.saveLocal(entry);
      expect(saveResult.isSuccess, isTrue);

      final historyResult = await repository.getHistory(userId: 'u1');
      expect(historyResult.isSuccess, isTrue);
      historyResult.when(
        onSuccess: (list) {
          expect(list.length, equals(1));
          expect(list.first.value, equals(72.5));
          expect(list.first.metricType, equals(BodyMetricType.weight));
        },
        onFailure: (_) => fail('Expected success'),
      );

      final pendingOutbox = await outbox.fetchPending();
      expect(pendingOutbox.length, equals(1));
      expect(pendingOutbox.first.entityType, equals('body_metrics'));
      expect(pendingOutbox.first.operation, equals(OutboxOperation.insert));
    });

    test('saveLocal rejects entry outside boundaries without creating outbox mutation', () async {
      final invalidEntry = BodyMetricEntry(
        id: 'bm-inv',
        userId: 'u1',
        metricType: BodyMetricType.weight,
        value: 10.0, // Less than 20kg
        unit: HealthUnit.kg,
        recordedAt: DateTime.now(),
      );

      final result = await repository.saveLocal(invalidEntry);
      expect(result.isFailure, isTrue);
      expect(await outbox.getPendingCount(), equals(0));
    });

    test('deleteLocal removes record and enqueues outbox delete', () async {
      final entry = BodyMetricEntry(
        id: 'bm-del',
        userId: 'u1',
        metricType: BodyMetricType.waist,
        value: 82.0,
        unit: HealthUnit.cm,
        recordedAt: DateTime.now(),
      );

      await repository.saveLocal(entry);
      await outbox.purgeCompleted();

      final deleteResult = await repository.deleteLocal('bm-del');
      expect(deleteResult.isSuccess, isTrue);

      final historyResult = await repository.getHistory(userId: 'u1');
      historyResult.when(
        onSuccess: (list) => expect(list, isEmpty),
        onFailure: (_) => fail('Expected success'),
      );

      final pending = await outbox.fetchPending();
      expect(pending.any((m) => m.operation == OutboxOperation.delete), isTrue);
    });
  });
}

