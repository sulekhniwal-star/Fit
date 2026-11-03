/// Contract boundary for crash reporting and error monitoring (e.g. Sentry).
abstract interface class CrashReporterContract {
  Future<void> initialize();
  void recordError(dynamic exception, StackTrace? stackTrace, {dynamic reason});
  void logBreadcrumb(
    String message, {
    String? category,
    Map<String, dynamic>? data,
  });
  void setUserId(String? userId);
}
