import 'package:fitkarma/core/logging/app_logger.dart';
import 'package:fitkarma/core/logging/pii_redactor.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:logger/logger.dart';

class TestLogSink implements AppLogSink {
  final List<String> capturedMessages = [];

  @override
  void log(Level level, String message, {Object? error, StackTrace? stackTrace}) {
    capturedMessages.add(message);
  }
}

void main() {
  group('PII Redactor & Logger Tests', () {
    test('PiiRedactor scrubs Indian phone numbers, emails, and tokens', () {
      const input =
          'User logged in with email: user.test+99@fitkarma.in and phone +91 9876543210 using Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.sflKxwRJSMeKKF2QT4fwpMeJf36POk6yJV_adQssw5c';

      final output = PiiRedactor.redact(input);

      expect(output.contains('user.test+99@fitkarma.in'), false);
      expect(output.contains('[REDACTED_EMAIL]'), true);
      expect(output.contains('9876543210'), false);
      expect(output.contains('[REDACTED_PHONE]'), true);
      expect(output.contains('eyJhbGciOiJIUzI1NiJ9'), false);
      expect(output.contains('[REDACTED_JWT]'), true);
    });

    test('PiiRedactor scrubs sensitive keys from map metadata', () {
      final meta = {
        'name': 'Rohan Sharma',
        'phone': '9988776655',
        'password': 'super-secret-password',
        'auth_token': 'secret-bearer-12345',
      };

      final sanitized = PiiRedactor.redactMap(meta);
      expect(sanitized['password'], '[REDACTED_SECRET]');
      expect(sanitized['auth_token'], '[REDACTED_SECRET]');
      expect(sanitized['phone'], '[REDACTED_PHONE]');
    });

    test('AppLogger dispatches redacted output to registered sinks', () {
      final sink = TestLogSink();
      final appLogger = AppLogger(sinks: [sink]);

      appLogger.info('Incoming OTP for +919876543210');

      expect(sink.capturedMessages.length, 1);
      expect(sink.capturedMessages.first.contains('9876543210'), false);
      expect(sink.capturedMessages.first.contains('[REDACTED_PHONE]'), true);
    });
  });
}
