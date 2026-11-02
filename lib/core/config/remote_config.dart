import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'feature_flags.dart';

class RemoteConfig {
  static const _cacheKey = 'fitkarma_remote_config_cache';

  final Map<String, bool> _flags;
  final List<PricingTier> _tiers;
  final SharedPreferences? prefs;

  RemoteConfig({
    required Map<String, bool> flags,
    required List<PricingTier> tiers,
    this.prefs,
  })  : _flags = Map.from(flags),
        _tiers = List.from(tiers);

  bool isFeatureEnabled(String flagKey, {bool fallback = false}) {
    return _flags[flagKey] ?? fallback;
  }

  List<PricingTier> get pricingTiers => List.unmodifiable(_tiers);

  PricingTier? getTierById(String id) {
    try {
      return _tiers.firstWhere((t) => t.id == id);
    } catch (_) {
      return null;
    }
  }

  static RemoteConfig createDefault({SharedPreferences? prefs}) {
    return RemoteConfig(
      flags: const {
        FeatureFlagKeys.photoLogging: false,
        FeatureFlagKeys.aqiAdvisory: true,
        FeatureFlagKeys.regionalLanguages: false,
        FeatureFlagKeys.familyDashboard: false,
        FeatureFlagKeys.cgmIntegration: false,
        FeatureFlagKeys.whatsappLogging: true,
        FeatureFlagKeys.aiMealAnalysis: true,
      },
      tiers: const [
        PricingTier(
          id: 'yogi_free',
          name: 'Yogi Free',
          priceInRupees: 0,
          billingCadence: 'free',
          entitlements: ['manual_logging', 'offline_mode', 'basic_wellness'],
        ),
        PricingTier(
          id: 'karma_pro_monthly',
          name: 'Karma Pro Monthly',
          priceInRupees: 199,
          billingCadence: 'monthly',
          entitlements: ['whatsapp_voice', 'ai_meal_analysis', 'ad_free', 'dynamic_tdee'],
        ),
        PricingTier(
          id: 'karma_pro_yearly',
          name: 'Karma Pro Annual',
          priceInRupees: 1499,
          billingCadence: 'annual',
          entitlements: ['whatsapp_voice', 'ai_meal_analysis', 'ad_free', 'dynamic_tdee'],
        ),
      ],
      prefs: prefs,
    );
  }

  Future<void> cacheToLocal() async {
    final sharedPrefs = prefs;
    if (sharedPrefs == null) return;
    final payload = {
      'flags': _flags,
      'tiers': _tiers.map((t) => t.toJson()).toList(),
    };
    await sharedPrefs.setString(_cacheKey, jsonEncode(payload));
  }

  static RemoteConfig fromLocalCache(SharedPreferences prefs) {
    final cached = prefs.getString(_cacheKey);
    if (cached == null) {
      return createDefault(prefs: prefs);
    }

    try {
      final decoded = jsonDecode(cached) as Map<String, dynamic>;
      final flagsMap = (decoded['flags'] as Map<String, dynamic>).map(
        (key, value) => MapEntry(key, value as bool),
      );
      final tiersList = (decoded['tiers'] as List<dynamic>)
          .map((e) => PricingTier.fromJson(e as Map<String, dynamic>))
          .toList();

      return RemoteConfig(flags: flagsMap, tiers: tiersList, prefs: prefs);
    } catch (_) {
      return createDefault(prefs: prefs);
    }
  }
}
