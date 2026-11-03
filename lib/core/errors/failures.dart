sealed class Failure {
  final String code;
  final String message;
  final bool retryable;
  final String? requestId;

  const Failure({
    required this.code,
    required this.message,
    this.retryable = false,
    this.requestId,
  });

  Map<String, dynamic> toJson() => {
        'code': code,
        'message': message,
        'retryable': retryable,
        if (requestId != null) 'request_id': requestId,
      };

  @override
  String toString() => 'Failure(code: $code, message: $message, retryable: $retryable)';
}

class AuthFailure extends Failure {
  const AuthFailure({
    super.code = 'FK-1001',
    super.message = 'Authentication required or session expired. Please sign in again.',
    super.retryable = false,
    super.requestId,
  });
}

class AuthZFailure extends Failure {
  const AuthZFailure({
    super.code = 'FK-1002',
    super.message = 'You do not have permission to access this resource.',
    super.retryable = false,
    super.requestId,
  });
}

class RateLimitFailure extends Failure {
  final int retryAfterSeconds;

  const RateLimitFailure({
    super.code = 'FK-1003',
    required super.message,
    this.retryAfterSeconds = 60,
    super.retryable = true,
    super.requestId,
  });
}

class ValidationFailure extends Failure {
  const ValidationFailure({
    super.code = 'FK-2001',
    required super.message,
    super.retryable = false,
    super.requestId,
  });
}

class OfflineQueuedFailure extends Failure {
  const OfflineQueuedFailure({
    super.code = 'FK-3001',
    super.message = 'Network offline. Saved locally and will sync when connected.',
    super.retryable = true,
    super.requestId,
  });
}

class SyncFailure extends Failure {
  const SyncFailure({
    super.code = 'FK-3002',
    super.message = 'Sync temporarily unavailable. Retrying automatically.',
    super.retryable = true,
    super.requestId,
  });
}

class ConflictFailure extends Failure {
  const ConflictFailure({
    super.code = 'FK-3003',
    super.message = 'Data conflict detected. Reconciliation required.',
    super.retryable = false,
    super.requestId,
  });
}

class AIFailure extends Failure {
  const AIFailure({
    super.code = 'FK-4001',
    super.message = 'Unable to parse AI response. Falling back to manual entry.',
    super.retryable = true,
    super.requestId,
  });
}

class AIConfirmationNeededFailure extends Failure {
  const AIConfirmationNeededFailure({
    super.code = 'FK-4002',
    super.message = 'AI confidence is low. Please confirm the identified food items.',
    super.retryable = false,
    super.requestId,
  });
}

class PaymentFailure extends Failure {
  const PaymentFailure({
    super.code = 'FK-5001',
    super.message = 'Payment request failed. Please check your payment method and try again.',
    super.retryable = true,
    super.requestId,
  });
}

class ExternalServiceFailure extends Failure {
  const ExternalServiceFailure({
    super.code = 'FK-6001',
    super.message = 'External service is temporarily unavailable.',
    super.retryable = true,
    super.requestId,
  });
}

class PrivacyOperationFailure extends Failure {
  const PrivacyOperationFailure({
    super.code = 'FK-7001',
    super.message = 'Data privacy operation failed. Please contact support.',
    super.retryable = false,
    super.requestId,
  });
}

class DatabaseFailure extends Failure {
  const DatabaseFailure(
    String message, {
    super.code = 'FK-8001',
    super.retryable = false,
    super.requestId,
  }) : super(message: message);
}

