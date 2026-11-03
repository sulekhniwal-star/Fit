import 'health_primitives.dart';

class SleepRecord {
  final String id;
  final String userId;
  final DateTime startTime;
  final DateTime endTime;
  final int durationMinutes;
  final int qualityRating; // 1 to 5
  final int? deepSleepMinutes;
  final int? remSleepMinutes;
  final HealthSource source;

  const SleepRecord({
    required this.id,
    required this.userId,
    required this.startTime,
    required this.endTime,
    required this.durationMinutes,
    this.qualityRating = 3,
    this.deepSleepMinutes,
    this.remSleepMinutes,
    this.source = HealthSource.manual,
  });

  factory SleepRecord.fromInterval({
    required String id,
    required String userId,
    required DateTime startTime,
    required DateTime endTime,
    int qualityRating = 3,
    int? deepSleepMinutes,
    int? remSleepMinutes,
    HealthSource source = HealthSource.manual,
  }) {
    // Overnight boundary resolution
    var adjustedEnd = endTime;
    if (adjustedEnd.isBefore(startTime)) {
      adjustedEnd = adjustedEnd.add(const Duration(days: 1));
    }

    final duration = adjustedEnd.difference(startTime).inMinutes;

    return SleepRecord(
      id: id,
      userId: userId,
      startTime: startTime,
      endTime: adjustedEnd,
      durationMinutes: duration,
      qualityRating: qualityRating.clamp(1, 5),
      deepSleepMinutes: deepSleepMinutes,
      remSleepMinutes: remSleepMinutes,
      source: source,
    );
  }

  String get durationFormatted {
    final hours = durationMinutes ~/ 60;
    final mins = durationMinutes % 60;
    return '${hours}h ${mins}m';
  }

  SleepRecord copyWith({
    String? id,
    String? userId,
    DateTime? startTime,
    DateTime? endTime,
    int? durationMinutes,
    int? qualityRating,
    int? deepSleepMinutes,
    int? remSleepMinutes,
    HealthSource? source,
  }) {
    return SleepRecord(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationMinutes: durationMinutes ?? this.durationMinutes,
      qualityRating: qualityRating ?? this.qualityRating,
      deepSleepMinutes: deepSleepMinutes ?? this.deepSleepMinutes,
      remSleepMinutes: remSleepMinutes ?? this.remSleepMinutes,
      source: source ?? this.source,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'start_time': startTime.toIso8601String(),
        'end_time': endTime.toIso8601String(),
        'duration_minutes': durationMinutes,
        'quality_rating': qualityRating,
        if (deepSleepMinutes != null) 'deep_sleep_minutes': deepSleepMinutes,
        if (remSleepMinutes != null) 'rem_sleep_minutes': remSleepMinutes,
        'source': source.name,
      };

  factory SleepRecord.fromJson(Map<String, dynamic> json) {
    return SleepRecord(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      startTime: DateTime.tryParse(json['start_time'] as String? ?? '') ?? DateTime.now(),
      endTime: DateTime.tryParse(json['end_time'] as String? ?? '') ?? DateTime.now(),
      durationMinutes: json['duration_minutes'] as int? ?? 0,
      qualityRating: json['quality_rating'] as int? ?? 3,
      deepSleepMinutes: json['deep_sleep_minutes'] as int?,
      remSleepMinutes: json['rem_sleep_minutes'] as int?,
      source: HealthSource.values.firstWhere(
        (s) => s.name == json['source'],
        orElse: () => HealthSource.manual,
      ),
    );
  }
}

