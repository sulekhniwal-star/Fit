import 'package:fitkarma/core/errors/failure.dart';

/// A value-typed Result monad representing either a success with data of type [T]
/// or a failure with a [Failure].
sealed class Result<T> {
  const Result();

  /// Creates a successful [Result] containing [data].
  const factory Result.success(T data) = Success<T>;

  /// Creates a failed [Result] containing [failure].
  const factory Result.failure(Failure failure) = FailureResult<T>;

  /// Returns true if this instance represents a success.
  bool get isSuccess => this is Success<T>;

  /// Returns true if this instance represents a failure.
  bool get isFailure => this is FailureResult<T>;

  /// Returns data if success, or null if failure.
  T? get dataOrNull => switch (this) {
    Success<T>(data: final d) => d,
    FailureResult<T>() => null,
  };

  /// Returns failure if failure, or null if success.
  Failure? get failureOrNull => switch (this) {
    Success<T>() => null,
    FailureResult<T>(failure: final f) => f,
  };

  /// Unwraps the data if success, or throws an [Exception] with the failure message.
  T getOrThrow() => switch (this) {
    Success<T>(data: final d) => d,
    FailureResult<T>(failure: final f) => throw StateError(
      'Result is a failure: $f',
    ),
  };

  /// Returns the data if success, or calls [fallback] with the failure.
  T getOrElse(T Function(Failure failure) fallback) => switch (this) {
    Success<T>(data: final d) => d,
    FailureResult<T>(failure: final f) => fallback(f),
  };

  /// Applies [onSuccess] if success, or [onFailure] if failure.
  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(Failure failure) onFailure,
  }) => switch (this) {
    Success<T>(data: final d) => onSuccess(d),
    FailureResult<T>(failure: final f) => onFailure(f),
  };

  /// Transforms the successful value with [transform].
  Result<R> map<R>(R Function(T data) transform) => switch (this) {
    Success<T>(data: final d) => Result.success(transform(d)),
    FailureResult<T>(failure: final f) => Result.failure(f),
  };

  /// Chains another [Result]-producing function with [transform].
  Result<R> flatMap<R>(Result<R> Function(T data) transform) => switch (this) {
    Success<T>(data: final d) => transform(d),
    FailureResult<T>(failure: final f) => Result.failure(f),
  };
}

/// Concrete successful implementation of [Result].
final class Success<T> extends Result<T> {
  final T data;

  const Success(this.data);

  @override
  String toString() => 'Success($data)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Success<T> &&
          runtimeType == other.runtimeType &&
          data == other.data;

  @override
  int get hashCode => data.hashCode;
}

/// Concrete failure implementation of [Result].
final class FailureResult<T> extends Result<T> {
  final Failure failure;

  const FailureResult(this.failure);

  @override
  String toString() => 'FailureResult($failure)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FailureResult<T> &&
          runtimeType == other.runtimeType &&
          failure == other.failure;

  @override
  int get hashCode => failure.hashCode;
}
