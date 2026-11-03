import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/config/feature_flags.dart';
import 'package:fitkarma/core/config/remote_config.dart';
import 'package:fitkarma/core/config/remote_config_service.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('RemoteConfig & Plan Configuration', () {
    test('defaultConfig provides safe offline fallback plans', () {
      final config = RemoteConfig.defaultConfig();

      expect(config.plans.length, 4);

      final yogiFree = config.getPlan('yogi_free');
      expect(yogiFree, isNotNull);
      expect(yogiFree!.priceInRupees, 0);
      expect(yogiFree.billingCadence, 'free');
      expect(yogiFree.entitlements.contains('manual_logging'), isTrue);

      final karmaPro = config.getPlan('karma_pro');
      expect(karmaPro, isNotNull);
      expect(karmaPro!.priceInRupees, 199);
      expect(karmaPro.billingCadence, 'monthly');
      expect(karmaPro.entitlements.contains('whatsapp_logging'), isTrue);

      final elite = config.getPlan('fitkarma_elite');
      expect(elite, isNotNull);
      expect(elite!.priceInRupees, 1999);

      final sachet = config.getPlan('sachet_sprint');
      expect(sachet, isNotNull);
      expect(sachet!.priceInRupees, 49);
      expect(sachet.billingCadence, 'one_time');
    });

    test('parses dynamic backend-configured plan pricing and entitlements', () {
      final json = {
        'version': 2,
        'plans': [
          {
            'id': 'karma_pro_diwali_special',
            'display_name': 'Karma Pro Diwali',
            'price_in_rupees': 149,
            'billing_cadence': 'monthly',
            'entitlements': [
              'whatsapp_logging',
              'ai_meal_analysis',
              'festival_mode',
            ],
            'is_available': true,
          },
        ],
        'flags': {'photo_logging_enabled': true},
      };

      final config = RemoteConfig.fromJson(json);
      expect(config.version, 2);
      expect(config.plans.length, 1);

      final customPlan = config.getPlan('karma_pro_diwali_special');
      expect(customPlan, isNotNull);
      expect(customPlan!.displayName, 'Karma Pro Diwali');
      expect(customPlan.priceInRupees, 149);
      expect(customPlan.entitlements.contains('festival_mode'), isTrue);
    });
  });

  group('FeatureFlags & Kill Switches', () {
    test(
      'default flags keep P1/P2 gated features disabled and kill switches open',
      () {
        const flags = FeatureFlags();

        // P1/P2/PROPOSED gated features disabled by default
        expect(flags.photoLoggingEnabled, isFalse);
        expect(flags.aqiWeatherEnabled, isFalse);
        expect(flags.vernacularLanguagesEnabled, isFalse);
        expect(flags.familyDashboardEnabled, isFalse);
        expect(flags.cgmPipelineEnabled, isFalse);

        // Kill switches open (features enabled)
        expect(flags.aiEnabled, isTrue);
        expect(flags.whatsappEnabled, isTrue);
        expect(flags.externalProvidersEnabled, isTrue);

        expect(flags.isFeatureEnabled('photo_logging'), isFalse);
        expect(flags.isFeatureEnabled('ai'), isTrue);
      },
    );

    test('isFeatureEnabled evaluates dynamically from remote flag payload', () {
      final json = {
        'photo_logging_enabled': true,
        'aqi_weather_enabled': true,
        'ai_enabled': false, // Kill switch engaged
      };

      final flags = FeatureFlags.fromJson(json);
      expect(flags.photoLoggingEnabled, isTrue);
      expect(flags.aqiWeatherEnabled, isTrue);
      expect(flags.aiEnabled, isFalse);

      expect(flags.isFeatureEnabled('photo_logging'), isTrue);
      expect(flags.isFeatureEnabled('aqi_weather'), isTrue);
      expect(flags.isFeatureEnabled('ai'), isFalse);
      expect(flags.isFeatureEnabled('unknown_feature'), isFalse);
    });
  });

  group('RemoteConfigService Offline Caching & Fallback', () {
    test('returns safe default config when initialized', () async {
      final service = RemoteConfigService();
      final config = await service.fetchRemoteConfig();

      expect(config.version, 1);
      expect(config.plans.isNotEmpty, isTrue);
    });

    test(
      'caches updated configuration locally and recovers on reload',
      () async {
        final service = RemoteConfigService();

        final updatedJson = {
          'version': 5,
          'plans': [
            {
              'id': 'karma_pro',
              'display_name': 'Karma Pro Annual',
              'price_in_rupees': 1499,
              'billing_cadence': 'annual',
              'entitlements': ['all_features'],
            },
          ],
          'flags': {'family_dashboard_enabled': true},
        };

        await service.updateFromMap(updatedJson);

        expect(service.currentConfig.version, 5);
        expect(service.currentConfig.getPlan('karma_pro')!.priceInRupees, 1499);
        expect(service.currentConfig.flags.familyDashboardEnabled, isTrue);

        // Reload from cache
        final loadedFromCache = await service.loadFromCache();
        expect(loadedFromCache.version, 5);
        expect(loadedFromCache.getPlan('karma_pro')!.priceInRupees, 1499);
      },
    );

    test('rejects remote config payload containing server secrets', () async {
      final service = RemoteConfigService();

      final maliciousJson = {
        'version': 99,
        'plans': [],
        'flags': {},
        'SUPABASE_SERVICE_ROLE_KEY': 'leak-service-key-here',
      };

      expect(
        () => service.updateFromMap(maliciousJson),
        throwsA(isA<SecurityViolationException>()),
      );
    });
  });
}
