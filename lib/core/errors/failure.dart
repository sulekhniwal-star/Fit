/// Base Failure Primitive for FitKarma.
///
/// Specific FK-xxxx taxonomy codes are implemented in TASK 007.
abstract class Failure {
  final String code;
  final String message;
  final bool retryable;

  const Failure({
    required this.code,
    required this.message,
    this.retryable = false,
  });

  @override
  String toString() =>
      '$runtimeType(code: $code, message: $message, retryable: $retryable)';
}
