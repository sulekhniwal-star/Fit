import 'exercise.dart';
import 'workout_session.dart';

class VolumeProgressionCalculator {
  const VolumeProgressionCalculator();

  /// Calculates total volume for a single session excluding warmups and uncompleted sets
  double calculateSessionVolume(WorkoutSession session) {
    return session.computeTotalVolume();
  }

  /// Calculates total tonnage across all completed sessions in a 7-day window
  double calculateWeeklyTotalVolume(List<WorkoutSession> sessions, DateTime windowStart) {
    final windowEnd = windowStart.add(const Duration(days: 7));
    return sessions
        .where((s) =>
            s.status == WorkoutSessionStatus.completed &&
            s.startedAt.isAfter(windowStart.subtract(const Duration(seconds: 1))) &&
            s.startedAt.isBefore(windowEnd))
        .fold<double>(0.0, (sum, s) => sum + s.totalVolumeKg);
  }

  /// Categorizes volume by targeted MuscleGroup using an exercise to muscle lookup map
  Map<MuscleGroup, double> calculateWeeklyVolumeByMuscle({
    required List<WorkoutSession> sessions,
    required Map<String, MuscleGroup> exerciseToMuscleMap,
    required DateTime windowStart,
  }) {
    final windowEnd = windowStart.add(const Duration(days: 7));
    final Map<MuscleGroup, double> muscleVolume = {};

    for (final session in sessions) {
      if (session.status != WorkoutSessionStatus.completed) continue;
      if (session.startedAt.isBefore(windowStart) || session.startedAt.isAfter(windowEnd)) continue;

      for (final s in session.sets) {
        if (!s.isCompleted || s.isWarmup) continue;
        final muscle = exerciseToMuscleMap[s.exerciseId] ?? MuscleGroup.fullBody;
        muscleVolume[muscle] = (muscleVolume[muscle] ?? 0.0) + s.volumeKg;
      }
    }

    return muscleVolume;
  }

  /// Computes percentage trend comparison between current and previous week
  double calculateVolumeTrend({
    required double currentWeekVolume,
    required double previousWeekVolume,
  }) {
    if (previousWeekVolume <= 0.0) {
      return currentWeekVolume > 0.0 ? 100.0 : 0.0;
    }
    final delta = ((currentWeekVolume - previousWeekVolume) / previousWeekVolume) * 100.0;
    return double.parse(delta.toStringAsFixed(1));
  }
}
