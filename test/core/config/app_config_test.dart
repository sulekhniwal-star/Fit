import 'dart:io';

import 'package:fitkarma/core/config/app_config.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppConfig Validation & Secret Boundary', () {
    final validMap = {
      'APP_ENV': 'development',
      'SUPABASE_URL': 'https://sample.supabase.co',
      'SUPABASE_ANON_KEY': 'sample-anon-key',
      'SENTRY_DSN': 'https://sample@sentry.io/123',
      'ENABLE_ANALYTICS': 'true',
    };

    test('successfully instantiates from valid map', () {
      final config = AppConfig.fromMap(validMap);

      expect(config.environment, AppEnvironment.development);
      expect(config.isDevelopment, isTrue);
      expect(config.isProduction, isFalse);
      expect(config.supabaseUrl, 'https://sample.supabase.co');
      expect(config.supabaseAnonKey, 'sample-anon-key');
      expect(config.sentryDsn, 'https://sample@sentry.io/123');
      expect(config.enableAnalytics, isTrue);
    });

    test('correctly parses environment variations', () {
      expect(
        AppConfig.fromMap({...validMap, 'APP_ENV': 'production'}).environment,
        AppEnvironment.production,
      );
      expect(
        AppConfig.fromMap({...validMap, 'APP_ENV': 'prod'}).environment,
        AppEnvironment.production,
      );
      expect(
        AppConfig.fromMap({...validMap, 'APP_ENV': 'staging'}).environment,
        AppEnvironment.staging,
      );
      expect(
        AppConfig.fromMap({...validMap, 'APP_ENV': 'unknown'}).environment,
        AppEnvironment.development,
      );
    });

    test('throws ArgumentError when required variables are missing', () {
      expect(
        () => AppConfig.fromMap({...validMap, 'SUPABASE_URL': ''}),
        throwsArgumentError,
      );
      expect(
        () => AppConfig.fromMap({...validMap, 'SUPABASE_ANON_KEY': ''}),
        throwsArgumentError,
      );
    });

    for (final prohibitedKey in AppConfig.prohibitedServerKeys) {
      test(
        'throws SecurityViolationException when $prohibitedKey is present',
        () {
          final leakedMap = Map<String, String>.from(validMap);
          leakedMap[prohibitedKey] = 'super-secret-value-123';

          expect(
            () => AppConfig.fromMap(leakedMap),
            throwsA(
              isA<SecurityViolationException>().having(
                (e) => e.detectedKey,
                'detectedKey',
                prohibitedKey,
              ),
            ),
          );
        },
      );
    }

    test('instantiates safe placeholder config from environment', () {
      final config = AppConfig.fromEnvironment();

      expect(config.environment, AppEnvironment.development);
      expect(config.supabaseUrl, isNotEmpty);
      expect(config.supabaseAnonKey, isNotEmpty);
    });
  });

  group('Git Ignore & Secret File Boundary Checks', () {
    test(
      '.gitignore exists and contains critical security exclusion patterns',
      () {
        final gitignoreFile = File('.gitignore');
        expect(gitignoreFile.existsSync(), isTrue);

        final content = gitignoreFile.readAsStringSync();

        // Must ignore .env files but retain .env.example
        expect(content.contains('.env'), isTrue);
        expect(content.contains('!.env.example'), isTrue);

        // Must ignore keystores and private certs
        expect(content.contains('*.jks'), isTrue);
        expect(content.contains('*.keystore'), isTrue);
        expect(content.contains('*.p12'), isTrue);
        expect(content.contains('*.key'), isTrue);

        // Must ignore local database files
        expect(content.contains('*.sqlite'), isTrue);
        expect(content.contains('*.db'), isTrue);

        // Must ignore server secrets
        expect(content.contains('supabase/.env'), isTrue);
      },
    );

    test('.env.example exists and contains no live secrets', () {
      final exampleFile = File('.env.example');
      expect(exampleFile.existsSync(), isTrue);

      final content = exampleFile.readAsStringSync();
      expect(content.contains('APP_ENV='), isTrue);
      expect(content.contains('SUPABASE_URL='), isTrue);
      expect(content.contains('SUPABASE_ANON_KEY='), isTrue);

      // Confirm warning about server-only secrets is present
      expect(content.contains('SERVER-ONLY SECRETS'), isTrue);
    });
  });
}
