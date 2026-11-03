import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/database/local_database_contract.dart';
import 'package:fitkarma/core/services/console_logging_service.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:fitkarma/core/sync/sync_engine_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application configuration provider. Must be overridden with active config at bootstrap.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

/// Shared logging and observability service provider.
final loggingServiceProvider = Provider<LoggingServiceContract>((ref) {
  final config = ref.watch(appConfigProvider);
  return ConsoleLoggingService(config);
});

/// Contract provider for local database persistence (Drift + SQLCipher).
final localDatabaseProvider = Provider<LocalDatabaseContract>((ref) {
  throw UnimplementedError(
    'localDatabaseProvider must be overridden with persistence implementation',
  );
});

/// Contract provider for offline-first synchronization engine.
final syncEngineProvider = Provider<SyncEngineContract>((ref) {
  throw UnimplementedError(
    'syncEngineProvider must be overridden with synchronization implementation',
  );
});
