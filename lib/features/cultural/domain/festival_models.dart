// ============================================================================
// INDIAN FESTIVAL DOMAIN MODELS
// ============================================================================

import 'fasting_protocol.dart';
import 'festive_food.dart';

class FestivalEvent {
  final String id;
  final String name;
  final String hindiName;
  final DateTime startDate;
  final DateTime endDate;
  final String description;
  final String culturalGreeting;
  final String hindiCulturalGreeting;
  final List<FestiveFood> traditionalFoods;
  final bool isFastingAssociated;
  final FastingProtocolType? fastingProtocolType;
  final List<String> balanceTips;

  const FestivalEvent({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.startDate,
    required this.endDate,
    required this.description,
    required this.culturalGreeting,
    required this.hindiCulturalGreeting,
    required this.traditionalFoods,
    this.isFastingAssociated = false,
    this.fastingProtocolType,
    required this.balanceTips,
  });

  bool isCurrentlyActive([DateTime? forDate]) {
    final now = forDate ?? DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final end = DateTime(endDate.year, endDate.month, endDate.day, 23, 59, 59);
    return now.isAfter(start.subtract(const Duration(seconds: 1))) &&
        now.isBefore(end.add(const Duration(seconds: 1)));
  }

  bool isUpcoming([DateTime? fromDate, int lookaheadDays = 14]) {
    final now = fromDate ?? DateTime.now();
    final start = DateTime(startDate.year, startDate.month, startDate.day);
    final maxDate = now.add(Duration(days: lookaheadDays));
    return start.isAfter(now) && start.isBefore(maxDate);
  }
}

