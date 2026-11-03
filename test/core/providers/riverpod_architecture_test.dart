import 'package:fitkarma/app/fitkarma_app.dart';
import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/database/local_database_contract.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/core/providers/app_state_observer.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:fitkarma/core/sync/sync_engine_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockLoggingService implements LoggingServiceContract {
  final List<String> logs = [];

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    logs.add('DEBUG: $message');
  }

  @override
  void info(String message) {
    logs.add('INFO: $message');
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    logs.add('WARN: $message');
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    logs.add('ERROR: $message');
  }
}

class MockLocalDatabase implements LocalDatabaseContract {
  bool initialized = false;

  @override
  Future<void> initialize() async {
    initialized = true;
  }

  @override
  Future<void> close() async {
    initialized = false;
  }

  @override
  Future<void> clearAllData() async {}

  @override
  bool get isOpen => initialized;
}

class MockSyncEngine implements SyncEngineContract {
  @override
  Future<void> enqueueOutboxOperation({
    required String operationId,
    required String entityType,
    required Map<String, dynamic> payload,
  }) async {}

  @override
  Future<void> processOutbox() async {}

  @override
  Stream<bool> get isSyncingStream => Stream.value(false);
}

void main() {
  group('Riverpod Architecture & Dependency Injection', () {
    test('appConfigProvider throws UnimplementedError if not overridden at startup', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(() => container.read(appConfigProvider), throwsUnimplementedError);
    });

    test(
      'contracts throw UnimplementedError when uninitialized/not overridden',
      () {
        final container = ProviderContainer();
        addTearDown(container.dispose);

        expect(
          () => container.read(localDatabaseProvider),
          throwsUnimplementedError,
        );
        expect(
          () => container.read(syncEngineProvider),
          throwsUnimplementedError,
        );
      },
    );

    test('dependencies can be cleanly overridden in ProviderContainer', () {
      final mockLogger = MockLoggingService();
      final mockDb = MockLocalDatabase();
      final mockSync = MockSyncEngine();

      const testConfig = AppConfig(
        environment: AppEnvironment.staging,
        supabaseUrl: 'https://staging.supabase.co',
        supabaseAnonKey: 'test-anon-key',
      );

      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(testConfig),
          loggingServiceProvider.overrideWithValue(mockLogger),
          localDatabaseProvider.overrideWithValue(mockDb),
          syncEngineProvider.overrideWithValue(mockSync),
        ],
      );
      addTearDown(container.dispose);

      expect(
        container.read(appConfigProvider).environment,
        AppEnvironment.staging,
      );
      expect(container.read(loggingServiceProvider), mockLogger);
      expect(container.read(localDatabaseProvider), mockDb);
      expect(container.read(syncEngineProvider), mockSync);
    });

    test(
      'AppProviderObserver intercepts provider lifecycle events via logger',
      () {
        final mockLogger = MockLoggingService();
        final observer = AppProviderObserver(logger: mockLogger);

        final testProvider = Provider<int>((ref) => 42);

        final container = ProviderContainer(observers: [observer]);
        addTearDown(container.dispose);

        final value = container.read(testProvider);
        expect(value, 42);
        expect(
          mockLogger.logs.any((log) => log.contains('Provider added')),
          isTrue,
        );
      },
    );
  });

  group('Riverpod Application Bootstrap Smoke Test', () {
    testWidgets('FitKarmaApp mounts and boots cleanly with ProviderScope', (
      WidgetTester tester,
    ) async {
      const testConfig = AppConfig(
        environment: AppEnvironment.development,
        supabaseUrl: 'https://dev.supabase.co',
        supabaseAnonKey: 'dev-anon-key',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(testConfig)],
          child: const FitKarmaApp(),
        ),
      );

      expect(find.text('FitKarma'), findsOneWidget);
      expect(find.text('Env: development'), findsOneWidget);
    });
  });
}
