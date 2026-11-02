import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/auth/data/supabase_auth_repository.dart';
import 'package:fitkarma/features/auth/presentation/auth_state_notifier.dart';
import 'package:fitkarma/features/auth/presentation/otp_verification_screen.dart';
import 'package:fitkarma/features/auth/presentation/phone_login_screen.dart';
import 'package:fitkarma/shared/widgets/action_button.dart';

void main() {
  Widget buildTestWidget({
    required MockAuthRepository repository,
    required Widget child,
  }) {
    return ProviderScope(
      overrides: [
        authRepositoryProvider.overrideWithValue(repository),
      ],
      child: MaterialApp(
        home: child,
      ),
    );
  }

  group('PhoneLoginScreen Widget Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    testWidgets('renders phone input field and initially disabled Get OTP button', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          repository: repository,
          child: const PhoneLoginScreen(),
        ),
      );

      expect(find.text('Mobile Number'), findsOneWidget);
      expect(find.text('+91'), findsOneWidget);
      expect(find.byKey(const Key('phone_input_field')), findsOneWidget);

      final button = tester.widget<ActionButton>(find.byKey(const Key('get_otp_button')));
      expect(button.onPressed, isNull);
    });

    testWidgets('enables Get OTP button when 10 valid digits are entered', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          repository: repository,
          child: const PhoneLoginScreen(),
        ),
      );

      final phoneInput = find.byKey(const Key('phone_input_field'));

      // Enter invalid phone: starts with 1
      await tester.enterText(phoneInput, '1234567890');
      await tester.pump();
      var button = tester.widget<ActionButton>(find.byKey(const Key('get_otp_button')));
      expect(button.onPressed, isNull);

      // Enter valid Indian phone: starts with 9
      await tester.enterText(phoneInput, '9876543210');
      await tester.pump();
      button = tester.widget<ActionButton>(find.byKey(const Key('get_otp_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('tapping Get OTP navigates to OtpVerificationScreen', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          repository: repository,
          child: const PhoneLoginScreen(),
        ),
      );

      final phoneInput = find.byKey(const Key('phone_input_field'));
      await tester.enterText(phoneInput, '9876543210');
      await tester.pump();

      await tester.tap(find.byKey(const Key('get_otp_button')));
      await tester.pumpAndSettle();

      expect(find.byType(OtpVerificationScreen), findsOneWidget);
      expect(find.text('Verify Phone'), findsOneWidget);
    });
  });

  group('OtpVerificationScreen Widget Tests', () {
    late MockAuthRepository repository;

    setUp(() {
      repository = MockAuthRepository();
    });

    tearDown(() {
      repository.dispose();
    });

    testWidgets('enables Verify button only after entering 6 digits', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          repository: repository,
          child: const OtpVerificationScreen(phoneNumber: '9876543210'),
        ),
      );

      final otpInput = find.byKey(const Key('otp_input_field'));
      var button = tester.widget<ActionButton>(find.byKey(const Key('verify_otp_button')));
      expect(button.onPressed, isNull);

      await tester.enterText(otpInput, '123');
      await tester.pump();
      button = tester.widget<ActionButton>(find.byKey(const Key('verify_otp_button')));
      expect(button.onPressed, isNull);

      await tester.enterText(otpInput, '123456');
      await tester.pump();
      button = tester.widget<ActionButton>(find.byKey(const Key('verify_otp_button')));
      expect(button.onPressed, isNotNull);
    });

    testWidgets('shows error text when invalid OTP token is submitted', (tester) async {
      await tester.pumpWidget(
        buildTestWidget(
          repository: repository,
          child: const OtpVerificationScreen(phoneNumber: '9876543210'),
        ),
      );

      final otpInput = find.byKey(const Key('otp_input_field'));
      await tester.enterText(otpInput, '000000');
      await tester.pump();

      await tester.tap(find.byKey(const Key('verify_otp_button')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('otp_error_text')), findsOneWidget);
      expect(find.text('Invalid or expired OTP token.'), findsOneWidget);
    });
  });
}

