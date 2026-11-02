import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/presentation/weight_logger_sheet.dart';

void main() {
  group('WeightLoggerSheet Widget Tests', () {
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

    Widget buildTestWidget({VoidCallback? onSaved}) {
      return ProviderScope(
        overrides: [
          bodyMetricsRepositoryProvider.overrideWithValue(repository),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: WeightLoggerSheet(
              userId: 'u1',
              initialWeightKg: 70.0,
              onSaved: onSaved,
            ),
          ),
        ),
      );
    }

    testWidgets('renders initial 70.0 kg and converts to lbs on chip selection', (tester) async {
      await tester.pumpWidget(buildTestWidget());

      expect(find.text('Log Body Weight'), findsOneWidget);
      expect(find.text('70.0'), findsOneWidget);

      // Select LBS
      await tester.tap(find.byKey(const Key('unit_chip_lbs')));
      await tester.pump();

      expect(find.text('154.3'), findsOneWidget);
    });

    testWidgets('saves weight entry and triggers onSaved callback', (tester) async {
      bool saved = false;
      await tester.pumpWidget(buildTestWidget(onSaved: () => saved = true));

      final input = find.byKey(const Key('weight_input_field'));
      await tester.enterText(input, '73.5');
      await tester.pump();

      await tester.tap(find.byKey(const Key('save_weight_button')));
      await tester.pumpAndSettle();

      expect(saved, isTrue);

      final history = await repository.getHistory(userId: 'u1', metricType: BodyMetricType.weight);
      history.when(
        onSuccess: (list) {
          expect(list.length, equals(1));
          expect(list.first.value, equals(73.5));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });
  });
}
