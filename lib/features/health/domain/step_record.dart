import 'health_primitives.dart';

class StepRecord {
  final String id;
  final String userId;
  final DateTime date;
  final int stepCount;
  final int goal;
  final HealthSource source;

  const StepRecord({
    required this.id,
    required this.userId,
    required this.date,
    required this.stepCount,
    this.goal = 10000,
    this.source = HealthSource.manual,
  });

  double get progressRatio => (stepCount / goal).clamp(0.0, 1.0);
  bool get isGoalMet => stepCount >= goal;

  StepRecord copyWith({
    String? id,
    String? userId,
    DateTime? date,
    int? stepCount,
    int? goal,
    HealthSource? source,
  }) {
    return StepRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      stepCount: stepCount ?? this.stepCount,
      goal: goal ?? this.goal,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'date': date.toIso8601String(),
        'step_count': stepCount,
        'goal': goal,
        'source': source.name,
      };

  factory StepRecord.fromJson(Map<String, dynamic> json) {
    return StepRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      stepCount: json['step_count'] as int? ?? 0,
      goal: json['goal'] as int? ?? 10000,
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.manual,
      ),
    );
  }
}

