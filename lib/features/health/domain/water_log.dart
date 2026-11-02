class WaterLog {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final int amountMl;
  final int dailyGoalMl;

  const WaterLog({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.amountMl,
    this.dailyGoalMl = 2500,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'recorded_at': recordedAt.toIso8601String(),
        'amount_ml': amountMl,
        'daily_goal_ml': dailyGoalMl,
      };

  factory WaterLog.fromJson(Map<String, dynamic> json) {
    return WaterLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? '') ?? DateTime.now(),
      amountMl: json['amount_ml'] as int? ?? 0,
      dailyGoalMl: json['daily_goal_ml'] as int? ?? 2500,
    );
  }
}

