// ============================================================================
// CPCB NATIONAL AIR QUALITY INDEX (NAQI) DOMAIN MODELS
// ============================================================================

import 'package:flutter/material.dart';

enum CpcbAqiCategory {
  good, // 0 - 50: Minimal impact
  satisfactory, // 51 - 100: Minor breathing discomfort to sensitive people
  moderate, // 101 - 200: Breathing discomfort to asthma/heart patients
  poor, // 201 - 300: Breathing discomfort to most people on prolonged exposure
  veryPoor, // 301 - 400: Respiratory illness on prolonged exposure
  severe, // 401+: Affects healthy people; serious impacts on vulnerable
}

class CpcbAqiBand {
  final CpcbAqiCategory category;
  final String label;
  final String hindiLabel;
  final int minAqi;
  final int maxAqi;
  final Color color;
  final String healthImpact;
  final String outdoorExerciseGuidance;

  const CpcbAqiBand({
    required this.category,
    required this.label,
    required this.hindiLabel,
    required this.minAqi,
    required this.maxAqi,
    required this.color,
    required this.healthImpact,
    required this.outdoorExerciseGuidance,
  });

  static const CpcbAqiBand good = CpcbAqiBand(
    category: CpcbAqiCategory.good,
    label: 'Good',
    hindiLabel: 'अच्छा',
    minAqi: 0,
    maxAqi: 50,
    color: Color(0xFF4CAF50),
    healthImpact: 'Minimal impact on health.',
    outdoorExerciseGuidance: 'Ideal conditions for outdoor running, cycling, and fitness activities.',
  );

  static const CpcbAqiBand satisfactory = CpcbAqiBand(
    category: CpcbAqiCategory.satisfactory,
    label: 'Satisfactory',
    hindiLabel: 'संतोषजनक',
    minAqi: 51,
    maxAqi: 100,
    color: Color(0xFF8BC34A),
    healthImpact: 'Minor breathing discomfort to sensitive people.',
    outdoorExerciseGuidance: 'Generally safe for all outdoor workouts. Sensitive individuals should monitor exertion.',
  );

  static const CpcbAqiBand moderate = CpcbAqiBand(
    category: CpcbAqiCategory.moderate,
    label: 'Moderate',
    hindiLabel: 'मध्यम',
    minAqi: 101,
    maxAqi: 200,
    color: Color(0xFFFFEB3B),
    healthImpact: 'Breathing discomfort to people with asthma and heart disease.',
    outdoorExerciseGuidance: 'Reduce prolonged intense outdoor cardio. Prefer early morning or indoor sessions.',
  );

  static const CpcbAqiBand poor = CpcbAqiBand(
    category: CpcbAqiCategory.poor,
    label: 'Poor',
    hindiLabel: 'खराब',
    minAqi: 201,
    maxAqi: 300,
    color: Color(0xFFFF9800),
    healthImpact: 'Breathing discomfort to most people on prolonged exposure.',
    outdoorExerciseGuidance: 'Avoid outdoor running and cycling. Switch to indoor cardio, strength training, or yoga.',
  );

  static const CpcbAqiBand veryPoor = CpcbAqiBand(
    category: CpcbAqiCategory.veryPoor,
    label: 'Very Poor',
    hindiLabel: 'बहुत खराब',
    minAqi: 301,
    maxAqi: 400,
    color: Color(0xFFF44336),
    healthImpact: 'Respiratory illness on prolonged exposure.',
    outdoorExerciseGuidance: 'Strictly avoid outdoor exercise. Exercise in an air-purified indoor environment only.',
  );

  static const CpcbAqiBand severe = CpcbAqiBand(
    category: CpcbAqiCategory.severe,
    label: 'Severe',
    hindiLabel: 'गंभीर',
    minAqi: 401,
    maxAqi: 999,
    color: Color(0xFF9C27B0),
    healthImpact: 'Affects healthy people and seriously impacts those with existing diseases.',
    outdoorExerciseGuidance: 'Dangerous particulate exposure. Avoid all physical exertion. Stick to gentle indoor mobility or rest.',
  );

  static CpcbAqiBand fromAqi(int aqi) {
    if (aqi <= 50) return good;
    if (aqi <= 100) return satisfactory;
    if (aqi <= 200) return moderate;
    if (aqi <= 300) return poor;
    if (aqi <= 400) return veryPoor;
    return severe;
  }
}

class AqiReading {
  final int aqi;
  final CpcbAqiCategory category;
  final double? pm25;
  final double? pm10;
  final String city;
  final String? stationName;
  final DateTime recordedAt;
  final bool isStale;
  final String source;

  const AqiReading({
    required this.aqi,
    required this.category,
    this.pm25,
    this.pm10,
    required this.city,
    this.stationName,
    required this.recordedAt,
    this.isStale = false,
    this.source = 'CPCB Open Data',
  });

  CpcbAqiBand get band => CpcbAqiBand.fromAqi(aqi);

  bool get isOutdoorSafe => category == CpcbAqiCategory.good || category == CpcbAqiCategory.satisfactory;

  bool get shouldRecommendIndoorAlternative => aqi >= 201;

  AqiReading copyWith({
    int? aqi,
    CpcbAqiCategory? category,
    double? pm25,
    double? pm10,
    String? city,
    String? stationName,
    DateTime? recordedAt,
    bool? isStale,
    String? source,
  }) {
    return AqiReading(
      aqi: aqi ?? this.aqi,
      category: category ?? this.category,
      pm25: pm25 ?? this.pm25,
      pm10: pm10 ?? this.pm10,
      city: city ?? this.city,
      stationName: stationName ?? this.stationName,
      recordedAt: recordedAt ?? this.recordedAt,
      isStale: isStale ?? this.isStale,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'aqi': aqi,
      'category': category.name,
      'pm25': pm25,
      'pm10': pm10,
      'city': city,
      'station_name': stationName,
      'recorded_at': recordedAt.toIso8601String(),
      'is_stale': isStale,
      'source': source,
    };
  }

  factory AqiReading.fromJson(Map<String, dynamic> json) {
    final aqi = json['aqi'] as int;
    return AqiReading(
      aqi: aqi,
      category: CpcbAqiCategory.values.byName(json['category'] as String),
      pm25: (json['pm25'] as num?)?.toDouble(),
      pm10: (json['pm10'] as num?)?.toDouble(),
      city: json['city'] as String,
      stationName: json['station_name'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      isStale: json['is_stale'] as bool? ?? false,
      source: json['source'] as String? ?? 'CPCB Open Data',
    );
  }
}

