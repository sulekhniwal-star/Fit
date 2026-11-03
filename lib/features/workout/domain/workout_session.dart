import 'exercise.dart';
import 'workout_set.dart';

enum WorkoutSessionStatus {
  inProgress,
  completed,
  discarded;

  String get displayName {
    switch (this) {
      case WorkoutSessionStatus.inProgress:
        return 'In Progress';
      case WorkoutSessionStatus.completed:
        return 'Completed';
      case WorkoutSessionStatus.discarded:
        return 'Discarded';
    }
  }
}

class WorkoutSession {
  final String id;
  final String userId;
  final String title;
  final WorkoutType workoutType;
  final DateTime startedAt;
  final DateTime? endedAt;
  final List<WorkoutSet> sets;
  final double totalVolumeKg;
  final int durationSeconds;
  final double caloriesBurned;
  final WorkoutSessionStatus status;
  final String? notes;

  const WorkoutSession({
    required this.id,
    required this.userId,
    required this.title,
    required this.workoutType,
    required this.startedAt,
    this.endedAt,
    this.sets = const [],
    this.totalVolumeKg = 0.0,
    this.durationSeconds = 0,
    this.caloriesBurned = 0.0,
    this.status = WorkoutSessionStatus.inProgress,
    this.notes,
  });

  bool get isValid => id.isNotEmpty && userId.isNotEmpty && title.isNotEmpty;

  /// Total working volume: sums all completed, non-warmup sets
  double computeTotalVolume() {
    return sets
        .where((s) => s.isCompleted && !s.isWarmup)
        .fold<double>(0.0, (sum, s) => sum + s.volumeKg);
  }

  /// Calculates elapsed duration in seconds
  int computeDurationSeconds([DateTime? now]) {
    final finish = endedAt ?? now ?? DateTime.now();
    final secs = finish.difference(startedAt).inSeconds;
    return secs < 0 ? 0 : secs;
  }

  /// Estimates calorie burn (standard MET estimate ~ 6 kcal/min for resistance training)
  double estimateCaloriesBurned() {
    final minutes = durationSeconds / 60.0;
    return (minutes * 6.0).clamp(0.0, 3000.0);
  }

  /// Distinct list of exercises performed in this session
  List<String> get uniqueExerciseIds =>
      sets.map((s) => s.exerciseId).toSet().toList();

  WorkoutSession copyWith({
    String? id,
    String? userId,
    String? title,
    WorkoutType? workoutType,
    DateTime? startedAt,
    DateTime? endedAt,
    List<WorkoutSet>? sets,
    double? totalVolumeKg,
    int? durationSeconds,
    double? caloriesBurned,
    WorkoutSessionStatus? status,
    String? notes,
  }) {
    return WorkoutSession(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      workoutType: workoutType ?? this.workoutType,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      sets: sets ?? this.sets,
      totalVolumeKg: totalVolumeKg ?? this.totalVolumeKg,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      caloriesBurned: caloriesBurned ?? this.caloriesBurned,
      status: status ?? this.status,
      notes: notes ?? this.notes,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'workout_type': workoutType.name,
        'started_at': startedAt.toIso8601String(),
        'ended_at': endedAt?.toIso8601String(),
        'sets': sets.map((s) => s.toJson()).toList(),
        'total_volume_kg': totalVolumeKg,
        'duration_seconds': durationSeconds,
        'calories_burned': caloriesBurned,
        'status': status.name,
        'notes': notes,
      };

  factory WorkoutSession.fromJson(Map<String, dynamic> json) {
    final rawSets = json['sets'] as List<dynamic>? ?? [];
    return WorkoutSession(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String,
      workoutType: WorkoutType.values.firstWhere(
        (w) => w.name == json['workout_type'],
        orElse: () => WorkoutType.strength,
      ),
      startedAt: DateTime.parse(json['started_at'] as String),
      endedAt: json['ended_at'] != null ? DateTime.tryParse(json['ended_at'] as String) : null,
      sets: rawSets.map((s) => WorkoutSet.fromJson(s as Map<String, dynamic>)).toList(),
      totalVolumeKg: (json['total_volume_kg'] as num?)?.toDouble() ?? 0.0,
      durationSeconds: json['duration_seconds'] as int? ?? 0,
      caloriesBurned: (json['calories_burned'] as num?)?.toDouble() ?? 0.0,
      status: WorkoutSessionStatus.values.firstWhere(
        (s) => s.name == json['status'],
        orElse: () => WorkoutSessionStatus.inProgress,
      ),
      notes: json['notes'] as String?,
    );
  }
}
