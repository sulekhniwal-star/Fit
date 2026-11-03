import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:logger/logger.dart';
import 'pii_redactor.dart';

abstract class AppLogSink {
  void log(Level level, String message, {Object? error, StackTrace? stackTrace});
}

class SentryBoundarySink implements AppLogSink {
  final bool isConfigured;
  const SentryBoundarySink({this.isConfigured = false});

  @override
  void log(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    if (!isConfigured) return;
    // In production, forward redacted event to Sentry Flutter
  }
}

class AppLogger {
  final Logger _logger;
  final List<AppLogSink> _sinks;

  AppLogger({
    Logger? logger,
    List<AppLogSink>? sinks,
  })  : _logger = logger ??
            Logger(
              printer: PrettyPrinter(
                methodCount: 0,
                errorMethodCount: 5,
                lineLength: 80,
                colors: false,
                printEmojis: false,
              ),
            ),
        _sinks = sinks ?? const [SentryBoundarySink()];

  void debug(String message, [Map<String, dynamic>? metadata]) {
    final sanitizedMessage = PiiRedactor.redact(message);
    _logger.d(sanitizedMessage);
    _dispatchToSinks(Level.debug, sanitizedMessage);
  }

  void info(String message, [Map<String, dynamic>? metadata]) {
    final sanitizedMessage = PiiRedactor.redact(message);
    _logger.i(sanitizedMessage);
    _dispatchToSinks(Level.info, sanitizedMessage);
  }

  void warning(String message, [Map<String, dynamic>? metadata]) {
    final sanitizedMessage = PiiRedactor.redact(message);
    _logger.w(sanitizedMessage);
    _dispatchToSinks(Level.warning, sanitizedMessage);
  }

  void error(String message, {Object? error, StackTrace? stackTrace, Map<String, dynamic>? metadata}) {
    final sanitizedMessage = PiiRedactor.redact(message);
    _logger.e(sanitizedMessage, error: error, stackTrace: stackTrace);
    _dispatchToSinks(Level.error, sanitizedMessage, error: error, stackTrace: stackTrace);
  }

  void _dispatchToSinks(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    for (final sink in _sinks) {
      sink.log(level, message, error: error, stackTrace: stackTrace);
    }
  }
}

final appLoggerProvider = Provider<AppLogger>((ref) => AppLogger());

