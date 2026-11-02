import 'dart:convert';

enum MoodState {
  awful(1, 'Awful', '😫'),
  low(2, 'Low', '😔'),
  neutral(3, 'Neutral', '😐'),
  good(4, 'Good', '😊'),
  energized(5, 'Energized', '⚡');

  final int score;
  final String label;
  final String emoji;
  const MoodState(this.score, this.label, this.emoji);

  static MoodState fromScore(int score) {
    return MoodState.values.firstWhere(
      (m) => m.score == score,
      orElse: () => MoodState.neutral,
    );
  }
}

class MoodLog {
  final String id;
  final String userId;
  final DateTime recordedAt;
  final MoodState mood;
  final String? note;
  final List<String> tags;

  const MoodLog({
    required this.id,
    required this.userId,
    required this.recordedAt,
    required this.mood,
    this.note,
    this.tags = const [],
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'recorded_at': recordedAt.toIso8601String(),
        'mood_score': mood.score,
        if (note != null) 'note': note,
        'tags': tags,
      };

  factory MoodLog.fromJson(Map<String, dynamic> json) {
    return MoodLog(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      recordedAt: DateTime.tryParse(json['recorded_at'] as String? ?? '') ?? DateTime.now(),
      mood: MoodState.fromScore(json['mood_score'] as int? ?? 3),
      note: json['note'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? const [],
    );
  }

  String get tagsJson => jsonEncode(tags);
}
