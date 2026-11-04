import 'dart:ui';

import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/config/feature_flags.dart';
import 'package:fitkarma/core/config/remote_config.dart';
import 'package:fitkarma/core/config/remote_config_service.dart';
import 'package:fitkarma/core/config/remote_config_service_contract.dart';
import 'package:fitkarma/core/database/local_database_contract.dart';
import 'package:fitkarma/core/localization/ai_phrasing_config.dart';
import 'package:fitkarma/core/localization/app_language.dart';
import 'package:fitkarma/core/localization/app_locale_notifier.dart';
import 'package:fitkarma/core/localization/app_strings.dart';
import 'package:fitkarma/core/services/console_logging_service.dart';
import 'package:fitkarma/core/services/crash_reporter_contract.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:fitkarma/core/services/sentry_crash_reporter.dart';
import 'package:fitkarma/core/services/sensitive_data_redactor.dart';
import 'package:fitkarma/core/sync/sync_engine_contract.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Application configuration provider. Must be overridden with active config at bootstrap.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be overridden at startup');
});

/// Sensitive data redactor provider for PII scrubbing and secret masking.
final sensitiveDataRedactorProvider = Provider<SensitiveDataRedactor>((ref) {
  return const SensitiveDataRedactor();
});

/// Crash reporter provider. Defaults to [SentryCrashReporter] with PII scrubbing.
final crashReporterProvider = Provider<CrashReporterContract>((ref) {
  final config = ref.watch(appConfigProvider);
  final redactor = ref.watch(sensitiveDataRedactorProvider);
  return SentryCrashReporter(config: config, redactor: redactor);
});

/// Shared logging and observability service provider.
final loggingServiceProvider = Provider<LoggingServiceContract>((ref) {
  final config = ref.watch(appConfigProvider);
  final redactor = ref.watch(sensitiveDataRedactorProvider);
  final crashReporter = ref.watch(crashReporterProvider);
  return ConsoleLoggingService(
    config,
    redactor: redactor,
    crashReporter: crashReporter,
  );
});

/// Remote configuration and feature-flag service provider.
final remoteConfigServiceProvider = Provider<RemoteConfigServiceContract>((
  ref,
) {
  final logger = ref.watch(loggingServiceProvider);
  return RemoteConfigService(logger: logger);
});

/// Active [RemoteConfig] snapshot provider.
final remoteConfigProvider = Provider<RemoteConfig>((ref) {
  final service = ref.watch(remoteConfigServiceProvider);
  return service.currentConfig;
});

/// Active [FeatureFlags] snapshot provider.
final featureFlagsProvider = Provider<FeatureFlags>((ref) {
  return ref.watch(remoteConfigProvider).flags;
});

/// Active [AppLanguage] state provider.
final appLanguageProvider =
    StateNotifierProvider<AppLocaleNotifier, AppLanguage>((ref) {
      return AppLocaleNotifier();
    });

/// Active Flutter [Locale] provider.
final appLocaleProvider = Provider<Locale>((ref) {
  return ref.watch(appLanguageProvider).toLocale;
});

/// Active typed [AppStrings] catalog provider for UI localization.
final appStringsProvider = Provider<AppStrings>((ref) {
  final language = ref.watch(appLanguageProvider);
  return AppStrings.forLanguage(language);
});

/// Active [AiPhrasingConfig] state provider for LLM conversational guidance.
final aiPhrasingConfigProvider =
    StateNotifierProvider<AiPhrasingConfigNotifier, AiPhrasingConfig>((ref) {
      return AiPhrasingConfigNotifier();
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
