// ============================================================================
// FASTING SESSION DOMAIN MODEL
// ============================================================================

import 'fasting_phase.dart';
import 'fasting_protocol.dart';

enum FastingSessionStatus {
  active,
  completed,
  cancelled,
}

class FastingSession {
  final String id;
  final String userId;
  final FastingProtocolType protocolType;
  final DateTime startTime;
  final DateTime plannedEndTime;
  final DateTime? actualEndTime;
  final FastingSessionStatus status;
  final bool isWaterless;
  final bool hydrationRemindersEnabled;
  final String? notes;
  final DateTime createdAt;
  final DateTime updatedAt;

  const FastingSession({
    required this.id,
    required this.userId,
    required this.protocolType,
    required this.startTime,
    required this.plannedEndTime,
    this.actualEndTime,
    this.status = FastingSessionStatus.active,
    this.isWaterless = false,
    this.hydrationRemindersEnabled = true,
    this.notes,
    required this.createdAt,
    required this.updatedAt,
  });

  bool get isActive => status == FastingSessionStatus.active;
  bool get isCompleted => status == FastingSessionStatus.completed;
  bool get isCancelled => status == FastingSessionStatus.cancelled;

  Duration get elapsedDuration {
    final end = actualEndTime ?? DateTime.now();
    return end.isAfter(startTime) ? end.difference(startTime) : Duration.zero;
  }

  double get elapsedHours => elapsedDuration.inMinutes / 60.0;

  Duration get plannedDuration => plannedEndTime.difference(startTime);

  double get plannedHours => plannedDuration.inMinutes / 60.0;

  double get progressPercentage => FastingPhaseCalculator.calculateProgress(
        startTime: startTime,
        plannedEndTime: plannedEndTime,
        currentTime: actualEndTime,
      );

  FastingStage get currentStage => FastingPhaseCalculator.getStage(elapsedHours);

  FastingStageInfo get currentStageInfo => FastingPhaseCalculator.getStageInfo(elapsedHours);

  bool get isTargetReached => elapsedDuration >= plannedDuration;

  FastingSession copyWith({
    String? id,
    String? userId,
    FastingProtocolType? protocolType,
    DateTime? startTime,
    DateTime? plannedEndTime,
    DateTime? actualEndTime,
    FastingSessionStatus? status,
    bool? isWaterless,
    bool? hydrationRemindersEnabled,
    String? notes,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return FastingSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      protocolType: protocolType ?? this.protocolType,
      startTime: startTime ?? this.startTime,
      plannedEndTime: plannedEndTime ?? this.plannedEndTime,
      actualEndTime: actualEndTime ?? this.actualEndTime,
      status: status ?? this.status,
      isWaterless: isWaterless ?? this.isWaterless,
      hydrationRemindersEnabled: hydrationRemindersEnabled ?? this.hydrationRemindersEnabled,
      notes: notes ?? this.notes,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'protocol_type': protocolType.name,
      'start_time': startTime.toIso8601String(),
      'planned_end_time': plannedEndTime.toIso8601String(),
      'actual_end_time': actualEndTime?.toIso8601String(),
      'status': status.name,
      'is_waterless': isWaterless,
      'hydration_reminders_enabled': hydrationRemindersEnabled,
      'notes': notes,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }

  factory FastingSession.fromJson(Map<String, dynamic> json) {
    return FastingSession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      protocolType: FastingProtocolType.values.byName(json['protocol_type'] as String),
      startTime: DateTime.parse(json['start_time'] as String),
      plannedEndTime: DateTime.parse(json['planned_end_time'] as String),
      actualEndTime: json['actual_end_time'] != null ? DateTime.parse(json['actual_end_time'] as String) : null,
      status: FastingSessionStatus.values.byName(json['status'] as String? ?? 'active'),
      isWaterless: json['is_waterless'] as bool? ?? false,
      hydrationRemindersEnabled: json['hydration_reminders_enabled'] as bool? ?? true,
      notes: json['notes'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }
}

