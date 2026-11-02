import 'package:fitkarma/core/config/feature_flags.dart';
import 'package:fitkarma/core/config/remote_config.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('Remote Config & Feature Flags Tests', () {
    test('Default configuration provides expected safe defaults', () {
      final config = RemoteConfig.createDefault();

      expect(config.isFeatureEnabled(FeatureFlagKeys.whatsappLogging), true);
      expect(config.isFeatureEnabled(FeatureFlagKeys.photoLogging), false);
      expect(config.isFeatureEnabled('unknown_key', fallback: true), true);

      final freeTier = config.getTierById('yogi_free');
      expect(freeTier, isNotNull);
      expect(freeTier!.priceInRupees, 0);

      final proMonthly = config.getTierById('karma_pro_monthly');
      expect(proMonthly, isNotNull);
      expect(proMonthly!.priceInRupees, 199);
      expect(proMonthly.entitlements.contains('whatsapp_voice'), true);
    });

    test('Remote config caches and reloads from local storage offline', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      final updatedConfig = RemoteConfig(
        flags: const {
          FeatureFlagKeys.photoLogging: true,
          FeatureFlagKeys.whatsappLogging: false,
        },
        tiers: const [
          PricingTier(
            id: 'promo_tier',
            name: 'Diwali Sachet',
            priceInRupees: 49,
            billingCadence: 'one_time',
            entitlements: ['ai_meal_analysis'],
          ),
        ],
        prefs: prefs,
      );

      await updatedConfig.cacheToLocal();

      // Read back from cache
      final restored = RemoteConfig.fromLocalCache(prefs);
      expect(restored.isFeatureEnabled(FeatureFlagKeys.photoLogging), true);
      expect(restored.isFeatureEnabled(FeatureFlagKeys.whatsappLogging), false);
      expect(restored.getTierById('promo_tier')!.priceInRupees, 49);
    });
  });
}

