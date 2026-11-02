import 'package:fitkarma/core/errors/failures.dart';
import 'package:fitkarma/core/errors/result.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Error & Result Primitives (FK-xxxx)', () {
    test('Failures map to standard FK-xxxx codes and sanitize user output', () {
      const auth = AuthFailure();
      expect(auth.code, 'FK-1001');
      expect(auth.retryable, false);
      expect(auth.message, contains('sign in again'));

      const offline = OfflineQueuedFailure();
      expect(offline.code, 'FK-3001');
      expect(offline.retryable, true);

      const ai = AIFailure();
      expect(ai.code, 'FK-4001');

      const payment = PaymentFailure();
      expect(payment.code, 'FK-5001');

      final json = payment.toJson();
      expect(json['code'], 'FK-5001');
      expect(json.containsKey('stack_trace'), false);
    });

    test('Result fold executes corresponding branch cleanly', () {
      const Result<int> success = Success(42);
      final successValue = success.fold(
        onSuccess: (data) => data * 2,
        onFailure: (failure) => 0,
      );
      expect(successValue, 84);
      expect(success.isSuccess, true);
      expect(success.isFailure, false);

      const Result<int> failure = FailureResult(AuthFailure());
      final failureValue = failure.fold(
        onSuccess: (data) => data * 2,
        onFailure: (f) => f.code,
      );
      expect(failureValue, 'FK-1001');
      expect(failure.isSuccess, false);
      expect(failure.isFailure, true);
    });
  });
}

