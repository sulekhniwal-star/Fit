/// FitKarma Feature Flags and Kill Switches Model.
class FeatureFlags {
  // Gated features (P1 / P2 / PROPOSED)
  final bool photoLoggingEnabled;
  final bool aqiWeatherEnabled;
  final bool vernacularLanguagesEnabled;
  final bool familyDashboardEnabled;
  final bool cgmPipelineEnabled;

  // Kill switches
  final bool aiEnabled;
  final bool whatsappEnabled;
  final bool externalProvidersEnabled;

  const FeatureFlags({
    this.photoLoggingEnabled = false,
    this.aqiWeatherEnabled = false,
    this.vernacularLanguagesEnabled = false,
    this.familyDashboardEnabled = false,
    this.cgmPipelineEnabled = false,
    this.aiEnabled = true,
    this.whatsappEnabled = true,
    this.externalProvidersEnabled = true,
  });

  Map<String, dynamic> toJson() => {
    'photo_logging_enabled': photoLoggingEnabled,
    'aqi_weather_enabled': aqiWeatherEnabled,
    'vernacular_languages_enabled': vernacularLanguagesEnabled,
    'family_dashboard_enabled': familyDashboardEnabled,
    'cgm_pipeline_enabled': cgmPipelineEnabled,
    'ai_enabled': aiEnabled,
    'whatsapp_enabled': whatsappEnabled,
    'external_providers_enabled': externalProvidersEnabled,
  };

  factory FeatureFlags.fromJson(Map<String, dynamic> json) => FeatureFlags(
    photoLoggingEnabled: json['photo_logging_enabled'] as bool? ?? false,
    aqiWeatherEnabled: json['aqi_weather_enabled'] as bool? ?? false,
    vernacularLanguagesEnabled:
        json['vernacular_languages_enabled'] as bool? ?? false,
    familyDashboardEnabled: json['family_dashboard_enabled'] as bool? ?? false,
    cgmPipelineEnabled: json['cgm_pipeline_enabled'] as bool? ?? false,
    aiEnabled: json['ai_enabled'] as bool? ?? true,
    whatsappEnabled: json['whatsapp_enabled'] as bool? ?? true,
    externalProvidersEnabled:
        json['external_providers_enabled'] as bool? ?? true,
  );

  bool isFeatureEnabled(String key) {
    return switch (key) {
      'photo_logging' => photoLoggingEnabled,
      'aqi_weather' => aqiWeatherEnabled,
      'vernacular_languages' => vernacularLanguagesEnabled,
      'family_dashboard' => familyDashboardEnabled,
      'cgm_pipeline' => cgmPipelineEnabled,
      'ai' => aiEnabled,
      'whatsapp' => whatsappEnabled,
      'external_providers' => externalProvidersEnabled,
      _ => false,
    };
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FeatureFlags &&
          runtimeType == other.runtimeType &&
          photoLoggingEnabled == other.photoLoggingEnabled &&
          aqiWeatherEnabled == other.aqiWeatherEnabled &&
          vernacularLanguagesEnabled == other.vernacularLanguagesEnabled &&
          familyDashboardEnabled == other.familyDashboardEnabled &&
          cgmPipelineEnabled == other.cgmPipelineEnabled &&
          aiEnabled == other.aiEnabled &&
          whatsappEnabled == other.whatsappEnabled &&
          externalProvidersEnabled == other.externalProvidersEnabled;

  @override
  int get hashCode => Object.hash(
    photoLoggingEnabled,
    aqiWeatherEnabled,
    vernacularLanguagesEnabled,
    familyDashboardEnabled,
    cgmPipelineEnabled,
    aiEnabled,
    whatsappEnabled,
    externalProvidersEnabled,
  );
}
