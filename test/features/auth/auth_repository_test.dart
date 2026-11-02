import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/errors/failures.dart';
import 'package:fitkarma/features/auth/data/supabase_auth_repository.dart';
import 'package:fitkarma/features/auth/presentation/auth_state_notifier.dart';

void main() {
  group('MockAuthRepository Unit Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    test('sendPhoneOtp validates 10-digit Indian phone format', () async {
      final invalidResult = await repository.sendPhoneOtp('12345');
      expect(invalidResult.isFailure, isTrue);
      invalidResult.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) {
          expect(failure, isA<ValidationFailure>());
          expect(failure.code, equals('FK-2001'));
        },
      );

      final validResult = await repository.sendPhoneOtp('9876543210');
      expect(validResult.isSuccess, isTrue);
    });

    test('sendPhoneOtp enforces 60s cooldown on immediate resend', () async {
      final firstSend = await repository.sendPhoneOtp('9876543210');
      expect(firstSend.isSuccess, isTrue);

      final secondSend = await repository.sendPhoneOtp('9876543210');
      expect(secondSend.isFailure, isTrue);
      secondSend.when(
        onSuccess: (_) => fail('Expected cooldown rate limit'),
        onFailure: (failure) {
          expect(failure, isA<RateLimitFailure>());
          expect(failure.code, equals('FK-1003'));
        },
      );
    });

    test('verifyPhoneOtp rejects invalid OTP code with FK-1001', () async {
      final result = await repository.verifyPhoneOtp('9876543210', '000000');
      expect(result.isFailure, isTrue);
      result.when(
        onSuccess: (_) => fail('Expected auth failure'),
        onFailure: (failure) {
          expect(failure, isA<AuthFailure>());
          expect(failure.code, equals('FK-1001'));
        },
      );
    });

    test('verifyPhoneOtp succeeds with valid token 123456 and creates user', () async {
      final result = await repository.verifyPhoneOtp('9876543210', '123456');
      expect(result.isSuccess, isTrue);
      result.when(
        onSuccess: (user) {
          expect(user.id, contains('9876543210'));
          expect(user.phone, equals('+919876543210'));
          expect(repository.currentUser, equals(user));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('signOut terminates current session', () async {
      await repository.verifyPhoneOtp('9876543210', '123456');
      expect(repository.currentUser, isNotNull);

      await repository.signOut();
      expect(repository.currentUser, isNull);
    });
  });

  group('AuthStateNotifier Unit Tests', () {
    late MockAuthRepository repository;
    late AuthStateNotifier notifier;

    setUp(() {
      repository = MockAuthRepository();
      notifier = AuthStateNotifier(repository);
    });

    tearDown(() {
      notifier.dispose();
      repository.dispose();
    });

    test('initial state is AuthUnauthenticated', () {
      expect(notifier.state, isA<AuthUnauthenticated>());
    });

    test('sendOtp transitions to AuthOtpSent on valid phone', () async {
      await notifier.sendOtp('9876543210');
      expect(notifier.state, isA<AuthOtpSent>());
      final sentState = notifier.state as AuthOtpSent;
      expect(sentState.phoneNumber, equals('9876543210'));
    });

    test('verifyOtp transitions to AuthAuthenticated on correct token', () async {
      await notifier.verifyOtp('9876543210', '123456');
      expect(notifier.state, isA<AuthAuthenticated>());
      final authState = notifier.state as AuthAuthenticated;
      expect(authState.user.phone, equals('+919876543210'));
    });

    test('verifyOtp transitions to AuthErrorState on incorrect token', () async {
      await notifier.verifyOtp('9876543210', '999999');
      expect(notifier.state, isA<AuthErrorState>());
    });

    test('signInWithGoogle transitions to AuthAuthenticated', () async {
      await notifier.signInWithGoogle();
      expect(notifier.state, isA<AuthAuthenticated>());
    });

    test('signOut transitions to AuthUnauthenticated', () async {
      await notifier.signInWithGoogle();
      expect(notifier.state, isA<AuthAuthenticated>());

      await notifier.signOut();
      expect(notifier.state, isA<AuthUnauthenticated>());
    });
  });
}

