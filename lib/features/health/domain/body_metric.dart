import 'health_primitives.dart';

enum BodyMetricType {
  weight,
  waist,
  hip,
  chest,
  arm,
  thigh,
  bodyFat,
}

class BodyMetricEntry {
  final String id;
  final String userId;
  final BodyMetricType metricType;
  final double value;
  final HealthUnit unit;
  final DateTime recordedAt;
  final HealthSource source;
  final String? notes;

  const BodyMetricEntry({
    required this.id,
    required this.userId,
    required this.metricType,
    required this.value,
    required this.unit,
    required this.recordedAt,
    this.source = HealthSource.manual,
    this.notes,
  });

  /// True if metric value falls within realistic physiological limits.
  bool get isValid {
    switch (metricType) {
      case BodyMetricType.weight:
        final inKg = unit == HealthUnit.lbs ? HealthUnit.lbsToKg(value) : value;
        return inKg >= 20.0 && inKg <= 400.0;
      case BodyMetricType.waist:
      case BodyMetricType.hip:
      case BodyMetricType.chest:
      case BodyMetricType.arm:
      case BodyMetricType.thigh:
        final inCm = unit == HealthUnit.inch ? HealthUnit.inchesToCm(value) : value;
        return inCm >= 15.0 && inCm <= 300.0;
      case BodyMetricType.bodyFat:
        return value >= 2.0 && value <= 70.0;
    }
  }

  /// Returns the entry with value normalized to standard base unit (kg, cm, or percent).
  BodyMetricEntry toBaseUnit() {
    if (metricType == BodyMetricType.weight && unit == HealthUnit.lbs) {
      return copyWith(
        value: HealthUnit.lbsToKg(value),
        unit: HealthUnit.kg,
      );
    } else if (metricType != BodyMetricType.weight &&
        metricType != BodyMetricType.bodyFat &&
        unit == HealthUnit.inch) {
      return copyWith(
        value: HealthUnit.inchesToCm(value),
        unit: HealthUnit.cm,
      );
    }
    return this;
  }

  BodyMetricEntry copyWith({
    String? id,
    String? userId,
    BodyMetricType? metricType,
    double? value,
    HealthUnit? unit,
    DateTime? recordedAt,
    HealthSource? source,
    String? notes,
  }) {
    return BodyMetricEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      metricType: metricType ?? this.metricType,
      value: value ?? this.value,
      unit: unit ?? this.unit,
      recordedAt: recordedAt ?? this.recordedAt,
      source: source ?? this.source,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'metric_type': metricType.name,
        'value': value,
        'unit': unit.name,
        'recorded_at': recordedAt.toIso8601String(),
        'source': source.name,
        if (notes != null) 'notes': notes,
      };

  factory BodyMetricEntry.fromJson(Map<String, dynamic> json) {
    return BodyMetricEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      metricType: BodyMetricType.values.firstWhere(
        (m) => m.name == json['metric_type'],
        orElse: () => BodyMetricType.weight,
      ),
      value: (json['value'] as num).toDouble(),
      unit: HealthUnit.values.firstWhere(
        (u) => u.name == json['unit'],
        orElse: () => HealthUnit.kg,
      ),
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? '') ?? DateTime.now(),
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.manual,
      ),
      notes: json['notes'] as String?,
    );
  }
}

