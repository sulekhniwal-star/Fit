/// FitKarma Shared Error & Failure Primitives
///
/// Implements the FK-xxxx failure taxonomy defined in Brain/error_handling.md.
/// Guarantees that user-facing messages are safe, non-technical, and free of secrets or stack traces.
library;

abstract class Failure {
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

  /// Standard error envelope representation matching Brain/error_handling.md.
  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'retryable': retryable,
      if (requestId != null) 'request_id': requestId,
    };
  }

  /// Deserializes a Failure envelope from a JSON map.
  factory Failure.fromJson(Map<String, dynamic> json) {
    final code = json['code'] as String? ?? FailureCodes.unknownInternal;
    final message =
        json['message'] as String? ?? 'An unexpected error occurred.';
    final retryable = json['retryable'] as bool? ?? false;
    final requestId = json['request_id'] as String?;

    return switch (code) {
      FailureCodes.authRequired => AuthFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.accessDenied => AuthZFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.validation => ValidationFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.offlineQueued => OfflineFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.syncTransient => SyncFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.conflictReconciliation => ConflictFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.aiUnparseable => AIFailure.unparseable(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.aiLowConfidence => AIFailure.lowConfidence(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.paymentRequestFailed => PaymentFailure.requestFailed(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.paymentVerificationFailed =>
        PaymentFailure.verificationFailed(
          message: message,
          requestId: requestId,
        ),
      FailureCodes.paymentMandateFailed => PaymentFailure.mandateFailed(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.paymentWebhookDuplicate => PaymentFailure.webhookDuplicate(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.externalUnavailable => ThirdPartyFailure(
        message: message,
        requestId: requestId,
      ),
      FailureCodes.privacyOperationFailed => PrivacyFailure(
        message: message,
        requestId: requestId,
      ),
      _ => InternalFailure(
        message: message,
        requestId: requestId,
        retryable: retryable,
      ),
    };
  }

  @override
  String toString() =>
      '$runtimeType(code: $code, message: $message, retryable: $retryable)';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Failure &&
          runtimeType == other.runtimeType &&
          code == other.code &&
          message == other.message &&
          retryable == other.retryable &&
          requestId == other.requestId;

  @override
  int get hashCode =>
      Object.hash(runtimeType, code, message, retryable, requestId);
}

/// Standard Taxonomy Codes from Brain/error_handling.md.
class FailureCodes {
  FailureCodes._();

  static const String authRequired = 'FK-1001';
  static const String accessDenied = 'FK-1002';
  static const String validation = 'FK-2001';
  static const String offlineQueued = 'FK-3001';
  static const String syncTransient = 'FK-3002';
  static const String conflictReconciliation = 'FK-3003';
  static const String aiUnparseable = 'FK-4001';
  static const String aiLowConfidence = 'FK-4002';
  static const String paymentRequestFailed = 'FK-5001';
  static const String paymentVerificationFailed = 'FK-5002';
  static const String paymentMandateFailed = 'FK-5003';
  static const String paymentWebhookDuplicate = 'FK-5004';
  static const String externalUnavailable = 'FK-6001';
  static const String privacyOperationFailed = 'FK-7001';
  static const String unknownInternal = 'FK-9999';
}

/// Validation failure (FK-2001) - invalid user input.
class ValidationFailure extends Failure {
  const ValidationFailure({
    super.message =
        'The provided information is invalid. Please check your entries.',
    super.requestId,
  }) : super(code: FailureCodes.validation, retryable: false);
}

/// Authentication failure (FK-1001) - login required or token expired.
class AuthFailure extends Failure {
  const AuthFailure({
    super.message = 'Your session has expired or authentication is required. Please log in.',
    super.requestId,
  }) : super(code: FailureCodes.authRequired, retryable: false);
}

/// Authorization failure (FK-1002) - access denied.
class AuthZFailure extends Failure {
  const AuthZFailure({
    super.message = 'You do not have permission to perform this action.',
    super.requestId,
  }) : super(code: FailureCodes.accessDenied, retryable: false);
}

/// Offline failure (FK-3001) - action queued locally for later sync.
class OfflineFailure extends Failure {
  const OfflineFailure({
    super.message =
        'You are currently offline. Your changes have been saved locally.',
    super.requestId,
  }) : super(code: FailureCodes.offlineQueued, retryable: false);
}

/// Synchronization failure (FK-3002) - transient sync error, safe to retry.
class SyncFailure extends Failure {
  const SyncFailure({
    super.message =
        'Unable to synchronize changes right now. We will retry automatically.',
    super.requestId,
  }) : super(code: FailureCodes.syncTransient, retryable: true);
}

/// Conflict reconciliation failure (FK-3003) - conflicting changes exist.
class ConflictFailure extends Failure {
  const ConflictFailure({
    super.message = 'Conflicting updates were detected. Please review and resolve the conflict.',
    super.requestId,
  }) : super(code: FailureCodes.conflictReconciliation, retryable: false);
}

/// Network failure (FK-6001) - network connection unavailable or timed out.
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message =
        'Network connection issue. Please check your internet connection.',
    super.requestId,
  }) : super(code: FailureCodes.externalUnavailable, retryable: true);
}

/// AI analysis failure (FK-4001 or FK-4002).
class AIFailure extends Failure {
  const AIFailure.unparseable({
    super.message = 'Unable to recognize food or recipe from input. Please try manual entry.',
    super.requestId,
  }) : super(code: FailureCodes.aiUnparseable, retryable: true);

  const AIFailure.lowConfidence({
    super.message =
        'Identified food with low confidence. Please review and confirm.',
    super.requestId,
  }) : super(code: FailureCodes.aiLowConfidence, retryable: false);
}

/// Third-party provider failure (FK-6001).
class ThirdPartyFailure extends Failure {
  const ThirdPartyFailure({
    super.message =
        'External service is temporarily unavailable. Please try again later.',
    super.requestId,
  }) : super(code: FailureCodes.externalUnavailable, retryable: true);
}

/// Payment failure (FK-5001 through FK-5004).
class PaymentFailure extends Failure {
  const PaymentFailure.requestFailed({
    super.message =
        'Unable to initiate payment with Razorpay. Please try again.',
    super.requestId,
  }) : super(code: FailureCodes.paymentRequestFailed, retryable: true);

  const PaymentFailure.verificationFailed({
    super.message = 'Payment verification could not be completed. Your card/account has not been billed.',
    super.requestId,
  }) : super(code: FailureCodes.paymentVerificationFailed, retryable: false);

  const PaymentFailure.mandateFailed({
    super.message = 'UPI AutoPay mandate creation failed. Please check your UPI app or payment method.',
    super.requestId,
  }) : super(code: FailureCodes.paymentMandateFailed, retryable: false);

  const PaymentFailure.webhookDuplicate({
    super.message = 'Payment notification has already been processed.',
    super.requestId,
  }) : super(code: FailureCodes.paymentWebhookDuplicate, retryable: false);
}

/// Privacy operation failure (FK-7001) - deletion or export failed.
class PrivacyFailure extends Failure {
  const PrivacyFailure({
    super.message =
        'Data privacy operation could not be completed. Please try again.',
    super.requestId,
  }) : super(code: FailureCodes.privacyOperationFailed, retryable: true);
}

/// Internal / Unknown failure (FK-9999).
class InternalFailure extends Failure {
  const InternalFailure({
    super.message = 'An unexpected error occurred. Please try again later.',
    super.requestId,
    super.retryable = false,
  }) : super(code: FailureCodes.unknownInternal);
}
