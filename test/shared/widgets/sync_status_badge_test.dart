import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/core/sync/sync_state.dart';
import 'package:fitkarma/shared/widgets/sync_status_badge.dart';

void main() {
  group('SyncStatusBadge Widget Tests', () {
    late AppDatabase db;
    late OutboxQueue queue;

    setUp(() {
      db = AppDatabase.memory();
      queue = OutboxQueue(db);
    });

    tearDown(() async {
      await db.close();
    });

    Widget buildTestWidget({required SyncCoordinator coordinator, VoidCallback? onTap}) {
      return ProviderScope(
        overrides: [
          syncCoordinatorProvider.overrideWith((ref) => coordinator),
        ],
        child: MaterialApp(
          home: Scaffold(
            body: Center(
              child: SyncStatusBadge(onTap: onTap),
            ),
          ),
        ),
      );
    }

    testWidgets('displays Synced in initial state', (tester) async {
      final coordinator = SyncCoordinator(queue, initialOnline: true);
      await tester.pumpWidget(buildTestWidget(coordinator: coordinator));

      expect(find.text('Synced'), findsOneWidget);
    });

    testWidgets('displays Offline with count when disconnected', (tester) async {
      final coordinator = SyncCoordinator(queue, initialOnline: true);
      coordinator.state = const SyncOffline(pendingCount: 3);

      await tester.pumpWidget(buildTestWidget(coordinator: coordinator));

      expect(find.text('Offline (3)'), findsOneWidget);
    });

    testWidgets('displays Syncing when sync is active', (tester) async {
      final coordinator = SyncCoordinator(queue, initialOnline: true);
      coordinator.state = const Syncing(pendingCount: 2);

      await tester.pumpWidget(buildTestWidget(coordinator: coordinator));

      expect(find.text('Syncing (2)'), findsOneWidget);
    });

    testWidgets('tapping invokes onTap or triggerSync', (tester) async {
      final coordinator = SyncCoordinator(queue, initialOnline: true);
      bool tapped = false;

      await tester.pumpWidget(buildTestWidget(
        coordinator: coordinator,
        onTap: () => tapped = true,
      ));

      await tester.tap(find.byKey(const Key('sync_status_badge')));
      await tester.pump();

      expect(tapped, isTrue);
    });
  });
}

