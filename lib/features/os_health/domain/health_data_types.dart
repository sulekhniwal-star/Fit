import '../../health/domain/health_primitives.dart';

enum HealthDataType {
  steps,
  sleep,
  heartRate,
  weight,
  bloodPressure,
  bloodGlucose;

  String get displayName {
    switch (this) {
      case HealthDataType.steps:
        return 'Steps & Activity';
      case HealthDataType.sleep:
        return 'Sleep Duration & Stages';
      case HealthDataType.heartRate:
        return 'Heart Rate (BPM)';
      case HealthDataType.weight:
        return 'Body Weight (kg)';
      case HealthDataType.bloodPressure:
        return 'Blood Pressure (mmHg)';
      case HealthDataType.bloodGlucose:
        return 'Blood Glucose (mg/dL)';
    }
  }
}

enum HealthPermissionStatus {
  notDetermined,
  authorized,
  denied,
  partiallyAuthorized,
  unsupported;

  bool get isAuthorized => this == HealthPermissionStatus.authorized;
}

class HealthRecordPayload {
  final String id;
  final HealthDataType dataType;
  final DateTime startTime;
  final DateTime endTime;
  final Map<String, dynamic> data;
  final HealthSource source;
  final String? deviceAttribution;
  final String? sourceApp;
  final DateTime recordedAt;
  final String? syncToken;

  const HealthRecordPayload({
    required this.id,
    required this.dataType,
    required this.startTime,
    required this.endTime,
    required this.data,
    required this.source,
    this.deviceAttribution,
    this.sourceApp,
    required this.recordedAt,
    this.syncToken,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'data_type': dataType.name,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'data': data,
        'source': source.name,
        if (deviceAttribution != null) 'device_attribution': deviceAttribution,
        if (sourceApp != null) 'source_app': sourceApp,
        'recorded_at': recordedAt.toIso8601String(),
        if (syncToken != null) 'sync_token': syncToken,
      };

  factory HealthRecordPayload.fromJson(Map<String, dynamic> json) {
    return HealthRecordPayload(
      id: json['id'] as String,
      dataType: HealthDataType.values.firstWhere(
        (t) => t.name == json['data_type'],
        orElse: () => HealthDataType.steps,
      ),
      startTime: DateTime.parse(json['start_time'] as String),
      endTime: DateTime.parse(json['end_time'] as String),
      data: Map<String, dynamic>.from(json['data'] as Map),
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.healthConnect,
      ),
      deviceAttribution: json['device_attribution'] as String?,
      sourceApp: json['source_app'] as String?,
      recordedAt: DateTime.parse(json['recorded_at'] as String),
      syncToken: json['sync_token'] as String?,
    );
  }
}
