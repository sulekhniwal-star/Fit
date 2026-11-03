class WorkoutSet {
  final String id;
  final String sessionId;
  final String exerciseId;
  final String exerciseName;
  final int setNumber;
  final double weightKg;
  final int reps;
  final bool isWarmup;
  final bool isCompleted;
  final int? rpe; // 1-10 Rate of Perceived Exertion
  final DateTime? completedAt;

  const WorkoutSet({
    required this.id,
    required this.sessionId,
    required this.exerciseId,
    required this.exerciseName,
    required this.setNumber,
    this.weightKg = 0.0,
    this.reps = 0,
    this.isWarmup = false,
    this.isCompleted = false,
    this.rpe,
    this.completedAt,
  });

  bool get isValid =>
      id.isNotEmpty && sessionId.isNotEmpty && exerciseId.isNotEmpty && setNumber > 0 && reps >= 0 && weightKg >= 0;

  /// Working volume: excludes warmup sets
  double get volumeKg => isWarmup ? 0.0 : (weightKg * reps);

  WorkoutSet copyWith({
    String? id,
    String? sessionId,
    String? exerciseId,
    String? exerciseName,
    int? setNumber,
    double? weightKg,
    int? reps,
    bool? isWarmup,
    bool? isCompleted,
    int? rpe,
    DateTime? completedAt,
  }) {
    return WorkoutSet(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      exerciseId: exerciseId ?? this.exerciseId,
      exerciseName: exerciseName ?? this.exerciseName,
      setNumber: setNumber ?? this.setNumber,
      weightKg: weightKg ?? this.weightKg,
      reps: reps ?? this.reps,
      isWarmup: isWarmup ?? this.isWarmup,
      isCompleted: isCompleted ?? this.isCompleted,
      rpe: rpe ?? this.rpe,
      completedAt: completedAt ?? this.completedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'session_id': sessionId,
        'exercise_id': exerciseId,
        'exercise_name': exerciseName,
        'set_number': setNumber,
        'weight_kg': weightKg,
        'reps': reps,
        'is_warmup': isWarmup,
        'is_completed': isCompleted,
        'rpe': rpe,
        'completed_at': completedAt?.toIso8601String(),
      };

  factory WorkoutSet.fromJson(Map<String, dynamic> json) {
    return WorkoutSet(
      id: json['id'] as String,
      sessionId: json['session_id'] as String,
      exerciseId: json['exercise_id'] as String,
      exerciseName: json['exercise_name'] as String? ?? 'Exercise',
      setNumber: json['set_number'] as int? ?? 1,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 0.0,
      reps: json['reps'] as int? ?? 0,
      isWarmup: json['is_warmup'] as bool? ?? false,
      isCompleted: json['is_completed'] as bool? ?? false,
      rpe: json['rpe'] as int?,
      completedAt: json['completed_at'] != null ? DateTime.tryParse(json['completed_at'] as String) : null,
    );
  }
}
