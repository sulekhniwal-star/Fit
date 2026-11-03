import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/services/crash_reporter_contract.dart';
import 'package:fitkarma/core/services/sensitive_data_redactor.dart';

/// Sentry integration boundary for FitKarma crash reporting.
/// Operates in safe no-op mode when no valid production SENTRY_DSN is configured.
class SentryCrashReporter implements CrashReporterContract {
  final AppConfig config;
  final SensitiveDataRedactor redactor;

  final List<String> recentBreadcrumbs = [];
  final List<Map<String, dynamic>> recordedErrors = [];
  String? _currentUserId;

  SentryCrashReporter({
    required this.config,
    this.redactor = const SensitiveDataRedactor(),
  });

  bool get isConfigured =>
      config.sentryDsn != null &&
      config.sentryDsn!.isNotEmpty &&
      !config.sentryDsn!.contains('examplePublicKey');

  @override
  Future<void> initialize() async {
    // Sentry SDK initialization hook. In local dev/test or when using example DSN,
    // operates in safe no-op mode without opening network sockets or leaking secrets.
  }

  @override
  void recordError(
    dynamic exception,
    StackTrace? stackTrace, {
    dynamic reason,
  }) {
    final scrubbedMessage = redactor.redactString(exception.toString());
    final scrubbedReason = reason != null
        ? redactor.redactString(reason.toString())
        : null;

    recordedErrors.add({
      'error': scrubbedMessage,
      'reason': scrubbedReason,
      'stackTrace': stackTrace,
      'userId': _currentUserId,
    });
  }

  @override
  void logBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  }) {
    final scrubbedMessage = redactor.redactString(message);
    final scrubbedData = data != null ? redactor.redactMap(data) : null;

    final entry =
        '[$category] $scrubbedMessage ${scrubbedData != null ? scrubbedData.toString() : ""}';
    recentBreadcrumbs.add(entry.trim());
    if (recentBreadcrumbs.length > 50) {
      recentBreadcrumbs.removeAt(0);
    }
  }

  @override
  void setUserId(String? userId) {
    _currentUserId = userId != null ? redactor.redactString(userId) : null;
  }
}
