import 'package:fitkarma/core/services/diagnostic_event.dart';

/// Contract boundary for application logging, observability, and diagnostic events.
abstract interface class LoggingServiceContract {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message, [Map<String, dynamic>? parameters]);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
  void recordDiagnosticEvent(DiagnosticEvent event);
}
