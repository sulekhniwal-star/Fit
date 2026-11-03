import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/os_health/data/health_integration_service.dart';
import 'package:fitkarma/features/os_health/data/mock_platform_health_adapter.dart';
import 'package:fitkarma/features/os_health/presentation/os_health_settings_screen.dart';
import 'package:fitkarma/features/os_health/presentation/os_health_sync_card.dart';

void main() {
  group('OsHealthSyncCard & Settings Screen Widget Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late HealthIntegrationService service;
    late MockPlatformHealthAdapter mockAdapter;

    const testUserId = 'test_widget_user';

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      mockAdapter = MockPlatformHealthAdapter();
      service = HealthIntegrationService(
        adapter: mockAdapter,
        stepRepo: DriftStepRepository(db, outbox),
        sleepRepo: DriftSleepRepository(db, outbox),
        vitalsRepo: DriftVitalsRepository(db, outbox),
        bodyMetricsRepo: DriftBodyMetricsRepository(db, outbox),
      );
    });

    tearDown(() async {
      await db.close();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          healthIntegrationServiceProvider.overrideWithValue(service),
        ],
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('OsHealthSyncCard displays platform details, permissions, and sync controls',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(const OsHealthSyncCard(userId: testUserId)),
      );
      await tester.pumpAndSettle();

      // Platform title & connected badge
      expect(find.text('Google Health Connect'), findsOneWidget);
      expect(find.text('Connected'), findsOneWidget);

      // Data type chips
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Sleep'), findsOneWidget);
      expect(find.text('Body'), findsOneWidget);

      // Controls
      expect(find.byKey(const Key('os_health_last_sync_text')), findsOneWidget);
      expect(find.byKey(const Key('os_health_sync_now_btn')), findsOneWidget);
      expect(find.byKey(const Key('os_health_toggle_btn')), findsOneWidget);

      // Tap Sync Now
      await tester.tap(find.byKey(const Key('os_health_sync_now_btn')));
      await tester.pump();
      await tester.pumpAndSettle();

      expect(find.text('OS health data synced successfully.'), findsOneWidget);
    });

    testWidgets('Tapping Disconnect toggles status to Disconnected', (tester) async {
      await tester.pumpWidget(
        createTestApp(const OsHealthSyncCard(userId: testUserId)),
      );
      await tester.pumpAndSettle();

      expect(find.text('Disconnect'), findsOneWidget);

      // Tap Disconnect
      await tester.tap(find.byKey(const Key('os_health_toggle_btn')));
      await tester.pumpAndSettle();

      expect(find.text('Disconnected'), findsOneWidget);
      expect(find.text('Connect'), findsOneWidget);
    });

    testWidgets('OsHealthSettingsScreen renders complete settings view with battery & DPDP notices',
        (tester) async {
      await tester.pumpWidget(
        createTestApp(const OsHealthSettingsScreen(userId: testUserId)),
      );
      await tester.pumpAndSettle();

      expect(find.text('OS Health Integration'), findsOneWidget);
      expect(find.text('Battery-Conscious Sync'), findsOneWidget);
      expect(find.text('Data Sovereignty & DPDP 2023'), findsOneWidget);
      expect(find.text('Min Interval: 15 mins'), findsOneWidget);
    });
  });
}
