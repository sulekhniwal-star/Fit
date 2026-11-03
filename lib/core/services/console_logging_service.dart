import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';
import 'package:flutter/foundation.dart';

/// Default Console Logging Service for development and test execution.
class ConsoleLoggingService implements LoggingServiceContract {
  final AppConfig config;

  const ConsoleLoggingService(this.config);

  @override
  void debug(String message, [Object? error, StackTrace? stackTrace]) {
    if (!config.isProduction) {
      debugPrint('[DEBUG] $message');
      if (error != null) debugPrint('Error: $error');
      if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
    }
  }

  @override
  void info(String message) {
    debugPrint('[INFO] $message');
  }

  @override
  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[WARN] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }

  @override
  void error(String message, [Object? error, StackTrace? stackTrace]) {
    debugPrint('[ERROR] $message');
    if (error != null) debugPrint('Error: $error');
    if (stackTrace != null) debugPrint('StackTrace: $stackTrace');
  }
}
