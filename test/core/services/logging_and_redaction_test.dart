import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/services/console_logging_service.dart';
import 'package:fitkarma/core/services/diagnostic_event.dart';
import 'package:fitkarma/core/services/sentry_crash_reporter.dart';
import 'package:fitkarma/core/services/sensitive_data_redactor.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('SensitiveDataRedactor PII & Secret Scrubbing', () {
    const redactor = SensitiveDataRedactor();

    test('redacts JWT tokens in freeform strings', () {
      const sampleJwt =
          'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIxMjM0NTY3ODkwIn0.doNotLeakThisSignature1234567890';
      const log = 'User logged in with token $sampleJwt successfully';

      final clean = redactor.redactString(log);
      expect(clean.contains('doNotLeakThisSignature'), isFalse);
      expect(clean.contains('[REDACTED_TOKEN]'), isTrue);
    });

    test('redacts Bearer tokens in headers and strings', () {
      const log = 'Authorization header: Bearer someSecretSessionTokenValue==';
      final clean = redactor.redactString(log);

      expect(clean.contains('someSecretSessionTokenValue'), isFalse);
      expect(clean, 'Authorization header: Bearer [REDACTED_TOKEN]');
    });

    test('redacts API keys (Razorpay, Groq, Supabase)', () {
      const log =
          'Invoking Groq with gsk_secretApiKey12345 and Razorpay rzp_test_sampleKey999';
      final clean = redactor.redactString(log);

      expect(clean.contains('gsk_secretApiKey12345'), isFalse);
      expect(clean.contains('rzp_test_sampleKey999'), isFalse);
      expect(clean.contains('[REDACTED_TOKEN]'), isTrue);
    });

    test('redacts email addresses', () {
      const log = 'User email is test.user@fitkarma.in for profile lookup';
      final clean = redactor.redactString(log);

      expect(clean.contains('test.user@fitkarma.in'), isFalse);
      expect(clean.contains('[REDACTED_EMAIL]'), isTrue);
    });

    test('redacts Indian phone numbers', () {
      const log = 'Phone OTP sent to +91 9876543210 and 9123456789';
      final clean = redactor.redactString(log);

      expect(clean.contains('9876543210'), isFalse);
      expect(clean.contains('9123456789'), isFalse);
      expect(clean.contains('[REDACTED_PHONE]'), isTrue);
    });

    test('redacts sensitive keys in nested maps and lists', () {
      final payload = {
        'user_id': 'usr-123',
        'password': 'PlainTextPassword123!',
        'otp_code': '654321',
        'auth_token': 'secret-auth-value',
        'metadata': {
          'email': 'sensitive@test.com',
          'card_cvv': '999',
          'safe_flag': true,
        },
        'items': [
          {'secret_key': 'xyz', 'name': 'Item 1'},
          'Contact: +919876543210',
        ],
      };

      final clean = redactor.redactMap(payload);

      expect(clean['password'], '[REDACTED]');
      expect(clean['otp_code'], '[REDACTED]');
      expect(clean['auth_token'], '[REDACTED]');
      expect(clean['user_id'], 'usr-123');

      final meta = clean['metadata'] as Map<String, dynamic>;
      expect(meta['email'], '[REDACTED]');
      expect(meta['card_cvv'], '[REDACTED]');
      expect(meta['safe_flag'], isTrue);

      final items = clean['items'] as List;
      final firstItem = items[0] as Map<String, dynamic>;
      expect(firstItem['secret_key'], '[REDACTED]');
      expect(firstItem['name'], 'Item 1');
      expect(items[1].toString().contains('9876543210'), isFalse);
      expect(items[1].toString().contains('[REDACTED_PHONE]'), isTrue);
    });
  });

  group('ConsoleLoggingService & Environment Awareness', () {
    test('suppresses debug logs in production environment', () {
      const prodConfig = AppConfig(
        environment: AppEnvironment.production,
        supabaseUrl: 'https://prod.supabase.co',
        supabaseAnonKey: 'prod-key',
      );

      final reporter = SentryCrashReporter(config: prodConfig);
      final logger = ConsoleLoggingService(prodConfig, crashReporter: reporter);

      // Verify no exception is thrown; logs are cleanly handled
      logger.debug(
        'This is a verbose debug log that should not output in prod',
      );
      logger.info('Production info event', {'status': 'healthy'});
      logger.warning('Warning message');

      expect(reporter.recentBreadcrumbs.length, 2);
    });

    test('records and scrubs diagnostic events', () {
      const devConfig = AppConfig(
        environment: AppEnvironment.development,
        supabaseUrl: 'https://dev.supabase.co',
        supabaseAnonKey: 'dev-key',
      );

      final reporter = SentryCrashReporter(config: devConfig);
      final logger = ConsoleLoggingService(devConfig, crashReporter: reporter);

      final event = DiagnosticEvent(
        name: 'user_signed_in',
        parameters: {
          'method': 'phone_otp',
          'phone': '+919876543210',
          'token': 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.xyz.abc',
        },
      );

      logger.recordDiagnosticEvent(event);

      expect(reporter.recentBreadcrumbs.length, 1);
      final breadcrumb = reporter.recentBreadcrumbs.first;
      expect(breadcrumb.contains('user_signed_in'), isTrue);
      expect(breadcrumb.contains('9876543210'), isFalse);
      expect(breadcrumb.contains('xyz.abc'), isFalse);
    });
  });

  group('SentryCrashReporter Boundary', () {
    test('operates safely without throwing when DSN is unconfigured', () async {
      const devConfig = AppConfig(
        environment: AppEnvironment.development,
        supabaseUrl: 'https://dev.supabase.co',
        supabaseAnonKey: 'dev-key',
      );

      final reporter = SentryCrashReporter(config: devConfig);
      expect(reporter.isConfigured, isFalse);

      await reporter.initialize();
      reporter.setUserId('usr-999');
      reporter.logBreadcrumb('Navigated to /dashboard', category: 'navigation');
      reporter.recordError(
        'Database connection failed with token eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.token.sig',
        StackTrace.current,
      );

      expect(reporter.recentBreadcrumbs.length, 1);
      expect(reporter.recordedErrors.length, 1);
      expect(
        reporter.recordedErrors.first['error'].toString().contains('token.sig'),
        isFalse,
      );
    });
  });
}
