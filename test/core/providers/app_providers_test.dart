import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('App Providers DI Override Tests', () {
    test('appConfigProvider throws UnimplementedError when not overridden', () {
      final container = ProviderContainer();
      addTearDown(container.dispose);

      expect(
        () => container.read(appConfigProvider),
        throwsA(isA<UnimplementedError>()),
      );
    });

    test('appConfigProvider returns overridden configuration', () {
      const customConfig = AppConfig(
        environment: AppEnvironment.staging,
        supabaseUrl: 'https://staging.fitkarma.internal',
        supabaseAnonKey: 'staging-key',
      );

      final container = ProviderContainer(
        overrides: [
          appConfigProvider.overrideWithValue(customConfig),
        ],
      );
      addTearDown(container.dispose);

      final resolved = container.read(appConfigProvider);
      expect(resolved.environment, AppEnvironment.staging);
      expect(resolved.supabaseUrl, 'https://staging.fitkarma.internal');
      expect(resolved.supabaseAnonKey, 'staging-key');
      expect(resolved.isDevelopment, false);
      expect(resolved.isProduction, false);
    });
  });
}
