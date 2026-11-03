/// Contract boundary for application logging, observability, and diagnostic events.
abstract interface class LoggingServiceContract {
  void debug(String message, [Object? error, StackTrace? stackTrace]);
  void info(String message);
  void warning(String message, [Object? error, StackTrace? stackTrace]);
  void error(String message, [Object? error, StackTrace? stackTrace]);
}

