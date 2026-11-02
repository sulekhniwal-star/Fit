import 'body_metric.dart';

class WeightTrend {
  final double currentWeightKg;
  final double movingAverage7DayKg;
  final double rateOfChangeKgPerWeek;
  final int totalEntries;

  const WeightTrend({
    required this.currentWeightKg,
    required this.movingAverage7DayKg,
    required this.rateOfChangeKgPerWeek,
    required this.totalEntries,
  });
}

class WeightTrendCalculator {
  const WeightTrendCalculator();

  /// Computes the 7-day moving average and weekly rate of change from weight entries.
  WeightTrend? calculate(List<BodyMetricEntry> entries) {
    final weights = entries
        .where((e) => e.metricType == BodyMetricType.weight && e.isValid)
        .map((e) => e.toBaseUnit())
        .toList()
      ..sort((a, b) => a.recordedAt.compareTo(b.recordedAt));

    if (weights.isEmpty) return null;

    final latest = weights.last;
    final now = latest.recordedAt;

    // Filter to last 7 days
    final last7Days = weights.where((e) {
      return now.difference(e.recordedAt).inDays <= 7;
    }).toList();

    final avg7Day = last7Days.isNotEmpty
        ? last7Days.map((e) => e.value).reduce((a, b) => a + b) / last7Days.length
        : latest.value;

    // Filter to prior 7 days (day 8 to 14) for rate of change calculation
    final prior7Days = weights.where((e) {
      final daysDiff = now.difference(e.recordedAt).inDays;
      return daysDiff > 7 && daysDiff <= 14;
    }).toList();

    double rateOfChange = 0.0;
    if (prior7Days.isNotEmpty) {
      final priorAvg = prior7Days.map((e) => e.value).reduce((a, b) => a + b) / prior7Days.length;
      rateOfChange = avg7Day - priorAvg;
    } else if (weights.length >= 2) {
      final days = latest.recordedAt.difference(weights.first.recordedAt).inDays;
      if (days > 0) {
        final change = latest.value - weights.first.value;
        rateOfChange = (change / days) * 7.0;
      }
    }

    return WeightTrend(
      currentWeightKg: latest.value,
      movingAverage7DayKg: double.parse(avg7Day.toStringAsFixed(2)),
      rateOfChangeKgPerWeek: double.parse(rateOfChange.toStringAsFixed(2)),
      totalEntries: weights.length,
    );
  }
}
