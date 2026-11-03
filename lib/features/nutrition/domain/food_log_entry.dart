import 'cooking_multiplier.dart';
import 'portion_unit.dart';
import 'tadka_model.dart';

enum MealSlot {
  breakfast,
  lunch,
  dinner,
  snack;

  String get label {
    switch (this) {
      case MealSlot.breakfast:
        return 'Breakfast';
      case MealSlot.lunch:
        return 'Lunch';
      case MealSlot.dinner:
        return 'Dinner';
      case MealSlot.snack:
        return 'Snacks & Evening';
    }
  }
}

class FoodLogEntry {
  final String id;
  final String userId;
  final DateTime loggedAt;
  final MealSlot mealSlot;
  final String foodName;
  final double portionQuantity;
  final PortionUnit portionUnit;
  final CookingState cookingState;
  final TadkaLevel tadkaLevel;
  final TadkaFatSource tadkaFatSource;
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;

  const FoodLogEntry({
    required this.id,
    required this.userId,
    required this.loggedAt,
    required this.mealSlot,
    required this.foodName,
    required this.portionQuantity,
    required this.portionUnit,
    this.cookingState = CookingState.cooked,
    this.tadkaLevel = TadkaLevel.none,
    this.tadkaFatSource = TadkaFatSource.oil,
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    this.fiberGrams = 0.0,
  });

  bool get isValid => calories >= 0 && proteinGrams >= 0 && carbsGrams >= 0 && fatGrams >= 0 && portionQuantity > 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'logged_at': loggedAt.toIso8601String(),
        'meal_slot': mealSlot.name,
        'food_name': foodName,
        'portion_quantity': portionQuantity,
        'portion_unit': portionUnit.name,
        'cooking_state': cookingState.name,
        'tadka_level': tadkaLevel.name,
        'tadka_fat_source': tadkaFatSource.name,
        'calories': calories,
        'protein_grams': proteinGrams,
        'carbs_grams': carbsGrams,
        'fat_grams': fatGrams,
        'fiber_grams': fiberGrams,
      };

  factory FoodLogEntry.fromJson(Map<String, dynamic> json) {
    return FoodLogEntry(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      loggedAt: DateTime.tryParse(json['logged_at'] as String? ?? '') ?? DateTime.now(),
      mealSlot: MealSlot.values.firstWhere(
        (m) => m.name == json['meal_slot'],
        orElse: () => MealSlot.lunch,
      ),
      foodName: json['food_name'] as String,
      portionQuantity: (json['portion_quantity'] as num).toDouble(),
      portionUnit: PortionUnit.values.firstWhere(
        (u) => u.name == json['portion_unit'],
        orElse: () => PortionUnit.mediumKatori,
      ),
      cookingState: CookingState.values.firstWhere(
        (c) => c.name == json['cooking_state'],
        orElse: () => CookingState.cooked,
      ),
      tadkaLevel: TadkaLevel.values.firstWhere(
        (t) => t.name == json['tadka_level'],
        orElse: () => TadkaLevel.none,
      ),
      tadkaFatSource: TadkaFatSource.values.firstWhere(
        (f) => f.name == json['tadka_fat_source'],
        orElse: () => TadkaFatSource.oil,
      ),
      calories: (json['calories'] as num).toDouble(),
      proteinGrams: (json['protein_grams'] as num).toDouble(),
      carbsGrams: (json['carbs_grams'] as num).toDouble(),
      fatGrams: (json['fat_grams'] as num).toDouble(),
      fiberGrams: (json['fiber_grams'] as num?)?.toDouble() ?? 0.0,
    );
  }
}
