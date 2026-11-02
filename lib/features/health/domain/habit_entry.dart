import 'dart:math';

class HabitEntry {
  final String id;
  final String userId;
  final String title;
  final String frequency; // 'daily', 'weekly'
  final int targetDays;
  final int currentStreak;
  final int bestStreak;
  final DateTime? lastCompletedAt;

  const HabitEntry({
    required this.id,
    required this.userId,
    required this.title,
    this.frequency = 'daily',
    this.targetDays = 7,
    this.currentStreak = 0,
    this.bestStreak = 0,
    this.lastCompletedAt,
  });

  /// Check-in logic: non-punitive streak tracking across calendar days.
  HabitEntry checkIn(DateTime completedAt) {
    if (lastCompletedAt != null) {
      final lastDate = DateTime(lastCompletedAt!.year, lastCompletedAt!.month, lastCompletedAt!.day);
      final currentDate = DateTime(completedAt.year, completedAt.month, completedAt.day);

      final daysDiff = currentDate.difference(lastDate).inDays;
      if (daysDiff == 0) {
        // Already checked in today
        return this;
      } else if (daysDiff == 1) {
        // Consecutive day
        final nextStreak = currentStreak + 1;
        return copyWith(
          currentStreak: nextStreak,
          bestStreak: max(bestStreak, nextStreak),
          lastCompletedAt: completedAt,
        );
      }
    }

    // First check-in or broken streak restarts gently at 1
    const nextStreak = 1;
    return copyWith(
      currentStreak: nextStreak,
      bestStreak: max(bestStreak, nextStreak),
      lastCompletedAt: completedAt,
    );
  }

  HabitEntry copyWith({
    String? id,
    String? userId,
    String? title,
    String? frequency,
    int? targetDays,
    int? currentStreak,
    int? bestStreak,
    DateTime? lastCompletedAt,
  }) {
    return HabitEntry(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      frequency: frequency ?? this.frequency,
      targetDays: targetDays ?? this.targetDays,
      currentStreak: currentStreak ?? this.currentStreak,
      bestStreak: bestStreak ?? this.bestStreak,
      lastCompletedAt: lastCompletedAt ?? this.lastCompletedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'title': title,
        'frequency': frequency,
        'target_days': targetDays,
        'current_streak': currentStreak,
        'best_streak': bestStreak,
        if (lastCompletedAt != null) 'last_completed_at': lastCompletedAt!.toIso8601String(),
      };

  factory HabitEntry.fromJson(Map<String, dynamic> json) {
    return HabitEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      title: json['title'] as String? ?? '',
      frequency: json['frequency'] as String? ?? 'daily',
      targetDays: json['target_days'] as int? ?? 7,
      currentStreak: json['current_streak'] as int? ?? 0,
      bestStreak: json['best_streak'] as int? ?? 0,
      lastCompletedAt: json['last_completed_at'] != null
          ? DateTime.tryParse(json['last_completed_at'] as String)
          : null,
    );
  }
}

