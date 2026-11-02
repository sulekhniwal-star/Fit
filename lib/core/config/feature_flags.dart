class FeatureFlagKeys {
  static const photoLogging = 'photo_logging';
  static const aqiAdvisory = 'aqi_advisory';
  static const regionalLanguages = 'regional_languages';
  static const familyDashboard = 'family_dashboard';
  static const cgmIntegration = 'cgm_integration';
  static const whatsappLogging = 'whatsapp_logging';
  static const aiMealAnalysis = 'ai_meal_analysis';
}

class PricingTier {
  final String id;
  final String name;
  final int priceInRupees;
  final String billingCadence;
  final List<String> entitlements;

  const PricingTier({
    required this.id,
    required this.name,
    required this.priceInRupees,
    required this.billingCadence,
    required this.entitlements,
  });

  factory PricingTier.fromJson(Map<String, dynamic> json) {
    return PricingTier(
      id: json['id'] as String,
      name: json['name'] as String,
      priceInRupees: (json['price_in_rupees'] as num).toInt(),
      billingCadence: json['billing_cadence'] as String,
      entitlements: (json['entitlements'] as List<dynamic>).map((e) => e.toString()).toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price_in_rupees': priceInRupees,
        'billing_cadence': billingCadence,
        'entitlements': entitlements,
      };
}
