import 'health_primitives.dart';

enum VitalType {
  bloodPressure,
  bloodGlucose,
}

class VitalRecord {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final VitalType vitalType;
  final int? systolic;
  final int? diastolic;
  final int? pulse;
  final double? glucoseMgDl;
  final String? contextTag; // 'fasting', 'postPrandial', 'random'
  final HealthSource source;

  /// Statutory disclaimer distinguishing wellness tracking from clinical diagnostics.
  static const String nonMedicalDisclaimer =
      'FitKarma observations are personal wellness tracking logs. '
      'They do not constitute medical diagnosis, clinical treatment, or physician advice.';

  const VitalRecord({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.vitalType,
    this.systolic,
    this.diastolic,
    this.pulse,
    this.glucoseMgDl,
    this.contextTag,
    this.source = HealthSource.manual,
  });

  /// Flags elevated readings for informative user awareness without diagnosing illness.
  bool get isElevatedReading {
    if (vitalType == VitalType.bloodPressure) {
      return (systolic != null && systolic! >= 135) || (diastolic != null && diastolic! >= 85);
    } else if (vitalType == VitalType.bloodGlucose) {
      if (contextTag == 'fasting') {
        return glucoseMgDl != null && glucoseMgDl! >= 126.0;
      }
      return glucoseMgDl != null && glucoseMgDl! >= 200.0;
    }
    return false;
  }

  bool get isValid {
    if (vitalType == VitalType.bloodPressure) {
      if (systolic == null || diastolic == null) return false;
      return systolic! >= 60 && systolic! <= 260 && diastolic! >= 40 && diastolic! <= 160;
    } else if (vitalType == VitalType.bloodGlucose) {
      if (glucoseMgDl == null) return false;
      return glucoseMgDl! >= 20.0 && glucoseMgDl! <= 600.0;
    }
    return false;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'recorded_at': recordedAt.toIso8601String(),
        'vital_type': vitalType.name,
        if (systolic != null) 'systolic': systolic,
        if (diastolic != null) 'diastolic': diastolic,
        if (pulse != null) 'pulse': pulse,
        if (glucoseMgDl != null) 'glucose_mg_dl': glucoseMgDl,
        if (contextTag != null) 'context_tag': contextTag,
        'source': source.name,
        'disclaimer': nonMedicalDisclaimer,
      };

  factory VitalRecord.fromJson(Map<String, dynamic> json) {
    return VitalRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? '') ?? DateTime.now(),
      vitalType: VitalType.values.firstWhere(
        (v) => v.name == json['vital_type'],
        orElse: () => VitalType.bloodPressure,
      ),
      systolic: json['systolic'] as int?,
      diastolic: json['diastolic'] as int?,
      pulse: json['pulse'] as int?,
      glucoseMgDl: (json['glucose_mg_dl'] as num?)?.toDouble(),
      contextTag: json['context_tag'] as String?,
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.manual,
      ),
    );
  }
}

