import 'package:fitkarma/core/config/feature_flags.dart';
import 'package:fitkarma/core/config/plan_config.dart';

/// Aggregated Remote Configuration Model for FitKarma.
class RemoteConfig {
  final List<PlanConfig> plans;
  final FeatureFlags flags;
  final int version;
  final DateTime lastUpdated;

  const RemoteConfig({
    required this.plans,
    required this.flags,
    this.version = 1,
    required this.lastUpdated,
  });

  PlanConfig? getPlan(String planId) {
    for (final plan in plans) {
      if (plan.id == planId) {
        return plan;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() => {
    'version': version,
    'last_updated': lastUpdated.toIso8601String(),
    'plans': plans.map((p) => p.toJson()).toList(),
    'flags': flags.toJson(),
  };

  factory RemoteConfig.fromJson(Map<String, dynamic> json) => RemoteConfig(
    version: json['version'] as int? ?? 1,
    lastUpdated: json['last_updated'] != null
        ? DateTime.tryParse(json['last_updated'] as String) ?? DateTime.now()
        : DateTime.now(),
    plans:
        (json['plans'] as List<dynamic>?)
            ?.map((p) => PlanConfig.fromJson(p as Map<String, dynamic>))
            .toList() ??
        defaultPlans,
    flags: json['flags'] != null
        ? FeatureFlags.fromJson(json['flags'] as Map<String, dynamic>)
        : const FeatureFlags(),
  );

  /// Safe offline fallback plans as defined in FitKarma_Master_Documentation_v1.md.
  static const List<PlanConfig> defaultPlans = [
    PlanConfig(
      id: 'yogi_free',
      displayName: 'Yogi Free',
      priceInRupees: 0,
      billingCadence: 'free',
      entitlements: ['manual_logging', 'steps', 'basic_wellness'],
    ),
    PlanConfig(
      id: 'karma_pro',
      displayName: 'Karma Pro',
      priceInRupees: 199,
      billingCadence: 'monthly',
      entitlements: [
        'whatsapp_logging',
        'ai_meal_analysis',
        'indian_recipes',
        'dynamic_tdee',
        'ad_free',
      ],
    ),
    PlanConfig(
      id: 'fitkarma_elite',
      displayName: 'FitKarma Elite',
      priceInRupees: 1999,
      billingCadence: 'monthly',
      entitlements: [
        'whatsapp_logging',
        'ai_meal_analysis',
        'indian_recipes',
        'dynamic_tdee',
        'clinical_dossier',
        'family_monitoring',
        'ad_free',
      ],
    ),
    PlanConfig(
      id: 'sachet_sprint',
      displayName: 'Sachet Sprint',
      priceInRupees: 49,
      billingCadence: 'one_time',
      entitlements: ['focused_health_report'],
    ),
  ];

  /// Factory providing safe, offline-ready initial configuration.
  factory RemoteConfig.defaultConfig() => RemoteConfig(
    plans: defaultPlans,
    flags: const FeatureFlags(),
    version: 1,
    lastUpdated: DateTime(2026, 11, 1),
  );
}
