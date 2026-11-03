import 'package:fitkarma/core/errors/failure.dart';
import 'package:fitkarma/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Failure Primitives & FK-xxxx Taxonomy Mapping', () {
    test('ValidationFailure maps to FK-2001 and non-retryable', () {
      const failure = ValidationFailure(requestId: 'req-1');
      expect(failure.code, FailureCodes.validation);
      expect(failure.retryable, isFalse);
      expect(failure.requestId, 'req-1');
    });

    test('AuthFailure maps to FK-1001', () {
      const failure = AuthFailure();
      expect(failure.code, FailureCodes.authRequired);
      expect(failure.retryable, isFalse);
    });

    test('AuthZFailure maps to FK-1002', () {
      const failure = AuthZFailure();
      expect(failure.code, FailureCodes.accessDenied);
      expect(failure.retryable, isFalse);
    });

    test('OfflineFailure maps to FK-3001', () {
      const failure = OfflineFailure();
      expect(failure.code, FailureCodes.offlineQueued);
      expect(failure.retryable, isFalse);
    });

    test('SyncFailure maps to FK-3002 and is retryable', () {
      const failure = SyncFailure();
      expect(failure.code, FailureCodes.syncTransient);
      expect(failure.retryable, isTrue);
    });

    test('ConflictFailure maps to FK-3003', () {
      const failure = ConflictFailure();
      expect(failure.code, FailureCodes.conflictReconciliation);
      expect(failure.retryable, isFalse);
    });

    test('NetworkFailure maps to FK-6001 and is retryable', () {
      const failure = NetworkFailure();
      expect(failure.code, FailureCodes.externalUnavailable);
      expect(failure.retryable, isTrue);
    });

    test('AIFailure maps correctly for unparseable and low confidence', () {
      const unparseable = AIFailure.unparseable();
      expect(unparseable.code, FailureCodes.aiUnparseable);
      expect(unparseable.retryable, isTrue);

      const lowConfidence = AIFailure.lowConfidence();
      expect(lowConfidence.code, FailureCodes.aiLowConfidence);
      expect(lowConfidence.retryable, isFalse);
    });

    test('PaymentFailure maps correctly across payment lifecycle', () {
      const reqFailed = PaymentFailure.requestFailed();
      expect(reqFailed.code, FailureCodes.paymentRequestFailed);
      expect(reqFailed.retryable, isTrue);

      const verFailed = PaymentFailure.verificationFailed();
      expect(verFailed.code, FailureCodes.paymentVerificationFailed);
      expect(verFailed.retryable, isFalse);

      const mandateFailed = PaymentFailure.mandateFailed();
      expect(mandateFailed.code, FailureCodes.paymentMandateFailed);
      expect(mandateFailed.retryable, isFalse);

      const dup = PaymentFailure.webhookDuplicate();
      expect(dup.code, FailureCodes.paymentWebhookDuplicate);
      expect(dup.retryable, isFalse);
    });

    test('ThirdPartyFailure maps to FK-6001', () {
      const failure = ThirdPartyFailure();
      expect(failure.code, FailureCodes.externalUnavailable);
      expect(failure.retryable, isTrue);
    });

    test('PrivacyFailure maps to FK-7001', () {
      const failure = PrivacyFailure();
      expect(failure.code, FailureCodes.privacyOperationFailed);
      expect(failure.retryable, isTrue);
    });

    test('InternalFailure maps to FK-9999', () {
      const failure = InternalFailure();
      expect(failure.code, FailureCodes.unknownInternal);
      expect(failure.retryable, isFalse);
    });
  });

  group('Failure Serialization & Envelope Verification', () {
    test(
      'toJson produces valid contract envelope per Brain/error_handling.md',
      () {
        const failure = SyncFailure(
          message: 'Sync transient error',
          requestId: 'req-xyz',
        );

        final json = failure.toJson();
        expect(json, {
          'code': 'FK-3002',
          'message': 'Sync transient error',
          'retryable': true,
          'request_id': 'req-xyz',
        });
      },
    );

    test('fromJson cleanly deserializes all standard failure types', () {
      final inputJson = {
        'code': 'FK-5001',
        'message': 'Unable to connect to Razorpay',
        'retryable': true,
        'request_id': 'req-pay-123',
      };

      final parsed = Failure.fromJson(inputJson);
      expect(parsed, isA<PaymentFailure>());
      expect(parsed.code, 'FK-5001');
      expect(parsed.message, 'Unable to connect to Razorpay');
      expect(parsed.retryable, isTrue);
      expect(parsed.requestId, 'req-pay-123');
    });

    test(
      'messages are display-safe and do not leak stack traces or secrets',
      () {
        final failures = [
          const ValidationFailure(),
          const AuthFailure(),
          const AuthZFailure(),
          const OfflineFailure(),
          const SyncFailure(),
          const ConflictFailure(),
          const NetworkFailure(),
          const AIFailure.unparseable(),
          const AIFailure.lowConfidence(),
          const PaymentFailure.requestFailed(),
          const PaymentFailure.verificationFailed(),
          const ThirdPartyFailure(),
          const PrivacyFailure(),
          const InternalFailure(),
        ];

        for (final f in failures) {
          // Assert no technical leakage
          expect(f.message.contains('Exception'), isFalse);
          expect(f.message.contains('Error:'), isFalse);
          expect(f.message.contains('at /'), isFalse);
          expect(f.message.contains('.dart:'), isFalse);
          expect(f.message.contains('token'), isFalse);
          expect(f.message.contains('secret'), isFalse);
        }
      },
    );
  });

  group('Result Monad Functional Operations', () {
    test('Success branch properties and transformations', () {
      const result = Result<int>.success(100);

      expect(result.isSuccess, isTrue);
      expect(result.isFailure, isFalse);
      expect(result.dataOrNull, 100);
      expect(result.failureOrNull, isNull);
      expect(result.getOrThrow(), 100);
      expect(result.getOrElse((_) => 0), 100);

      // fold
      final folded = result.fold(
        onSuccess: (val) => val * 2,
        onFailure: (err) => -1,
      );
      expect(folded, 200);

      // map
      final mapped = result.map((val) => 'Value: $val');
      expect(mapped, const Result<String>.success('Value: 100'));

      // flatMap
      final flatMapped = result.flatMap(
        (val) => Result<double>.success(val / 2),
      );
      expect(flatMapped, const Result<double>.success(50.0));
    });

    test('Failure branch properties and transformations', () {
      const failure = ValidationFailure(message: 'Invalid email');
      const result = Result<int>.failure(failure);

      expect(result.isSuccess, isFalse);
      expect(result.isFailure, isTrue);
      expect(result.dataOrNull, isNull);
      expect(result.failureOrNull, failure);
      expect(() => result.getOrThrow(), throwsStateError);
      expect(result.getOrElse((_) => 999), 999);

      // fold
      final folded = result.fold(
        onSuccess: (val) => 'Success: $val',
        onFailure: (err) => 'Failure: ${err.code}',
      );
      expect(folded, 'Failure: FK-2001');

      // map maintains failure
      final mapped = result.map((val) => val * 2);
      expect(mapped.isFailure, isTrue);
      expect(mapped.failureOrNull, failure);

      // flatMap maintains failure
      final flatMapped = result.flatMap((val) => Result<int>.success(val * 2));
      expect(flatMapped.isFailure, isTrue);
      expect(flatMapped.failureOrNull, failure);
    });
  });
}
