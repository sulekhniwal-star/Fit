import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/services/crash_reporter_contract.dart';
import 'package:fitkarma/core/services/diagnostic_event.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:fitkarma/core/services/sensitive_data_redactor.dart';
import 'package:flutter/foundation.dart';

/// Default Logging Service for FitKarma.
/// Performs automatic PII scrubbing and environment-aware output.
class ConsoleLoggingService implements LoggingServiceContract {
  final AppConfig config;
  final SensitiveDataRedactor redactor;
  final CrashReporterContract? crashReporter;

  const ConsoleLoggingService(
    this.config, {
    this.redactor = const SensitiveDataRedactor(),
    this.crashReporter,
  });

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    // Debug logs are strictly suppressed in production environments
    if (!config.isProduction) {
      final cleanMessage = redactor.redactString(message);
      debugPrint('[DEBUG] $cleanMessage');
      if (error != null) {
        debugPrint('Error: ${redactor.redactString(error.toString())}');
      }
      if (stackTrace != null) {
        debugPrint('StackTrace: $stackTrace');
      }
    }
  }

  @override
  void info(String message, [Map<String, dynamic>? parameters]) {
    final cleanMessage = redactor.redactString(message);
    final cleanParams = parameters != null
        ? redactor.redactMap(parameters)
        : null;

    debugPrint('[INFO] $cleanMessage ${cleanParams ?? ""}');
    crashReporter?.logBreadcrumb(
      cleanMessage,
      category: 'info',
      data: cleanParams,
    );
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    final cleanMessage = redactor.redactString(message);
    debugPrint('[WARN] $cleanMessage');
    if (error != null) {
      debugPrint('Error: ${redactor.redactString(error.toString())}');
    }
    crashReporter?.logBreadcrumb(cleanMessage, category: 'warning');
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    final cleanMessage = redactor.redactString(message);
    debugPrint('[ERROR] $cleanMessage');
    if (error != null) {
      debugPrint('Error: ${redactor.redactString(error.toString())}');
    }
    if (stackTrace != null) {
      debugPrint('StackTrace: $stackTrace');
    }

    crashReporter?.recordError(
      cleanMessage,
      stackTrace,
      reason: error != null ? redactor.redactString(error.toString()) : null,
    );
  }

  @override
  void recordDiagnosticEvent(DiagnosticEvent event) {
    final cleanParams = redactor.redactMap(event.parameters);
    debugPrint('[EVENT] ${event.name}: $cleanParams');
    crashReporter?.logBreadcrumb(
      'Event: ${event.name}',
      category: 'diagnostic',
      data: cleanParams,
    );
  }
}
