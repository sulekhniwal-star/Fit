import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/domain/mood_log.dart';
import 'package:fitkarma/features/health/domain/water_log.dart';
import 'package:fitkarma/features/health/presentation/mood_selector_card.dart';
import 'package:fitkarma/features/health/presentation/water_quick_add_card.dart';

void main() {
  group('Water & Mood Integration Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftWaterRepository waterRepo;
    late DriftMoodRepository moodRepo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      waterRepo = DriftWaterRepository(db, outbox);
      moodRepo = DriftMoodRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    Widget buildTestWidget({required Widget child}) {
      return ProviderScope(
        overrides: [
          waterRepositoryProvider.overrideWithValue(waterRepo),
          moodRepositoryProvider.overrideWithValue(moodRepo),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: SingleChildScrollView(child: child),
          ),
        ),
      );
    }

    test('DriftWaterRepository sums daily intake accurately', () async {
      final now = DateTime.now();
      await waterRepo.saveLocal(WaterLog(
        id: 'w1',
        userId: 'u1',
        recordedAt: now,
        amountMl: 250,
      ));
      await waterRepo.saveLocal(WaterLog(
        id: 'w2',
        userId: 'u1',
        recordedAt: now,
        amountMl: 500,
      ));

      final totalResult = await waterRepo.getDailyTotalMl('u1', now);
      expect(totalResult.isSuccess, isTrue);
      totalResult.when(
        onSuccess: (total) => expect(total, equals(750)),
        onFailure: (_) => fail('Expected success'),
      );
    });

    testWidgets('WaterQuickAddCard adds 250ml and updates UI', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        child: const WaterQuickAddCard(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('0 / 2500 ml'), findsOneWidget);

      await tester.tap(find.byKey(const Key('add_water_250_btn')));
      await tester.pumpAndSettle();

      expect(find.text('250 / 2500 ml'), findsOneWidget);
    });

    test('DriftMoodRepository saves and retrieves latest mood', () async {
      final now = DateTime.now();
      await moodRepo.saveLocal(MoodLog(
        id: 'm1',
        userId: 'u1',
        recordedAt: now.subtract(const Duration(hours: 2)),
        mood: MoodState.neutral,
      ));
      await moodRepo.saveLocal(MoodLog(
        id: 'm2',
        userId: 'u1',
        recordedAt: now,
        mood: MoodState.energized,
      ));

      final latest = await moodRepo.getLatest('u1');
      expect(latest.isSuccess, isTrue);
      latest.when(
        onSuccess: (m) {
          expect(m, isNotNull);
          expect(m!.mood, equals(MoodState.energized));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    testWidgets('MoodSelectorCard renders mood emojis and updates state', (tester) async {
      await tester.pumpWidget(buildTestWidget(
        child: const MoodSelectorCard(userId: 'u1'),
      ));
      await tester.pumpAndSettle();

      expect(find.text('Daily Mood'), findsOneWidget);

      // Tap Energized (score 5)
      await tester.tap(find.byKey(const Key('mood_item_5')));
      await tester.pumpAndSettle();

      expect(find.text('Energized'), findsWidgets);
    });
  });
}
