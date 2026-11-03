import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/features/cultural/data/drift_fasting_repository.dart';
import 'package:fitkarma/features/cultural/domain/fasting_protocol.dart';
import 'package:fitkarma/features/cultural/domain/fasting_session.dart';
import 'package:fitkarma/features/cultural/presentation/fasting_screen.dart';
import 'package:fitkarma/features/cultural/presentation/fasting_tracker_card.dart';
import 'package:fitkarma/features/cultural/presentation/refeeding_guidance_sheet.dart';

void main() {
  group('Fasting UI & Widget Tests', () {
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

    Widget createTestApp(Widget child, {String userId = 'test_user'}) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          outboxQueueProvider.overrideWithValue(outbox),
          fastingRepositoryProvider.overrideWithValue(repo),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      );
    }

    testWidgets('FastingTrackerCard renders inactive state with Start Fast button', (tester) async {
      await tester.pumpWidget(createTestApp(const FastingTrackerCard()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Fasting & Cultural Vrat'), findsOneWidget);
      expect(find.text('Start Fast'), findsOneWidget);
    });

    testWidgets('FastingTrackerCard renders active fast with protocol, timer, and End Fast button', (tester) async {
      final now = DateTime.now();
      await repo.startSession(FastingSession(
        id: 'fast_active_ui',
        userId: 'default_user',
        protocolType: FastingProtocolType.if16_8,
        startTime: now.subtract(const Duration(hours: 14)),
        plannedEndTime: now.add(const Duration(hours: 2)),
        createdAt: now,
        updatedAt: now,
      ));

      await tester.pumpWidget(createTestApp(const FastingTrackerCard()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('16:8 Intermittent Fast'), findsOneWidget);
      expect(find.text('14h 0m'), findsOneWidget);
      expect(find.text('/ 16h target'), findsOneWidget);
      expect(find.text('End Fast'), findsOneWidget);
    });

    testWidgets('RefeedingGuidanceSheet displays gentle recovery meals and disclaimers', (tester) async {
      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: Builder(
            builder: (ctx) => ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: ctx,
                builder: (_) => const RefeedingGuidanceSheet(),
              ),
              child: const Text('Open Sheet'),
            ),
          ),
        ),
      ));

      await tester.tap(find.text('Open Sheet'));
      await tester.pumpAndSettle();

      expect(find.text('Safe Break-Fast Protocol'), findsOneWidget);
      expect(find.textContaining('Statutory Advisory'), findsOneWidget);
      expect(find.text('Tender Coconut Water & Soaked Almonds'), findsOneWidget);
      expect(find.text('Moong Dal & Lauki Khichdi'), findsOneWidget);
      expect(find.text('Got it, Break Fast Gently'), findsOneWidget);

      final gotItBtn = find.text('Got it, Break Fast Gently');
      await tester.ensureVisible(gotItBtn);
      await tester.tap(gotItBtn);
      await tester.pumpAndSettle();
      expect(find.text('Safe Break-Fast Protocol'), findsNothing);
    });

    testWidgets('FastingScreen allows protocol selection and starting a fast', (tester) async {
      await tester.pumpWidget(createTestApp(const FastingScreen()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Fasting & Cultural Vrat'), findsOneWidget);
      expect(find.text('Select Fasting Protocol'), findsOneWidget);
      expect(find.text('Begin Fasting Window'), findsOneWidget);

      // Tap Navratri chip
      final navratriChip = find.text('Navratri Vrat (Sattvic / Phalahar)');
      expect(navratriChip, findsOneWidget);
      await tester.tap(navratriChip);
      await tester.pump();

      // Begin fast
      final beginBtn = find.text('Begin Fasting Window');
      await tester.ensureVisible(beginBtn);
      await tester.tap(beginBtn);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 200));

      // Screen now shows active fast state with Cancel & End buttons
      expect(find.text('Cancel Fast'), findsOneWidget);
      expect(find.text('End Fast'), findsOneWidget);
    });
  });
}
