import 'dart:convert';
import 'portion_unit.dart';

class RecipeIngredient {
  final String foodName;
  final double quantity;
  final PortionUnit unit;
  final NutritionValues nutrition;

  const RecipeIngredient({
    required this.foodName,
    required this.quantity,
    required this.unit,
    required this.nutrition,
  });

  Map<String, dynamic> toJson() => {
        'food_name': foodName,
        'quantity': quantity,
        'unit': unit.name,
        'nutrition': nutrition.toJson(),
      };

  factory RecipeIngredient.fromJson(Map<String, dynamic> json) {
    return RecipeIngredient(
      foodName: json['food_name'] as String,
      quantity: (json['quantity'] as num).toDouble(),
      unit: PortionUnit.values.firstWhere(
        (u) => u.name == json['unit'],
        orElse: () => PortionUnit.gram,
      ),
      nutrition: NutritionValues.fromJson(json['nutrition'] as Map<String, dynamic>),
    );
  }
}

class FamilyRecipe {
  final String id;
  final String userId;
  final String name;
  final List<RecipeIngredient> ingredients;
  final double totalYieldGramsOrKatoris;
  final String yieldUnitLabel; // 'katoris', 'grams', 'servings'
  final DateTime createdAt;

  const FamilyRecipe({
    required this.id,
    required this.userId,
    required this.name,
    required this.ingredients,
    required this.totalYieldGramsOrKatoris,
    this.yieldUnitLabel = 'katoris',
    required this.createdAt,
  });

  /// Computes cumulative batch pot nutrition.
  NutritionValues get totalNutrition {
    double cal = 0.0;
    double p = 0.0;
    double c = 0.0;
    double f = 0.0;
    double fib = 0.0;

    for (final ing in ingredients) {
      cal += ing.nutrition.calories;
      p += ing.nutrition.proteinGrams;
      c += ing.nutrition.carbsGrams;
      f += ing.nutrition.fatGrams;
      fib += ing.nutrition.fiberGrams;
    }

    return NutritionValues(
      calories: double.parse(cal.toStringAsFixed(1)),
      proteinGrams: double.parse(p.toStringAsFixed(1)),
      carbsGrams: double.parse(c.toStringAsFixed(1)),
      fatGrams: double.parse(f.toStringAsFixed(1)),
      fiberGrams: double.parse(fib.toStringAsFixed(1)),
    );
  }

  /// Splits recipe by percentage (e.g. 25.0 for 25% of the family pot).
  NutritionValues splitByPercentage(double percentage) {
    if (percentage <= 0.0) {
      return const NutritionValues(
        calories: 0.0,
        proteinGrams: 0.0,
        carbsGrams: 0.0,
        fatGrams: 0.0,
        fiberGrams: 0.0,
      );
    }

    final ratio = (percentage / 100.0).clamp(0.0, 1.0);
    return totalNutrition * ratio;
  }

  /// Splits recipe by household katoris consumed out of total pot yield.
  NutritionValues splitByKatoris(double consumedKatoris) {
    if (consumedKatoris <= 0.0 || totalYieldGramsOrKatoris <= 0.0) {
      return const NutritionValues(
        calories: 0.0,
        proteinGrams: 0.0,
        carbsGrams: 0.0,
        fatGrams: 0.0,
        fiberGrams: 0.0,
      );
    }

    final ratio = (consumedKatoris / totalYieldGramsOrKatoris).clamp(0.0, 1.0);
    return totalNutrition * ratio;
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'name': name,
        'ingredients': ingredients.map((i) => i.toJson()).toList(),
        'total_yield_grams_or_katoris': totalYieldGramsOrKatoris,
        'yield_unit_label': yieldUnitLabel,
        'created_at': createdAt.toIso8601String(),
      };

  factory FamilyRecipe.fromJson(Map<String, dynamic> json) {
    final rawIngs = json['ingredients'] as List<dynamic>? ?? [];
    return FamilyRecipe(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      name: json['name'] as String,
      ingredients: rawIngs.map((i) => RecipeIngredient.fromJson(i as Map<String, dynamic>)).toList(),
      totalYieldGramsOrKatoris: (json['total_yield_grams_or_katoris'] as num).toDouble(),
      yieldUnitLabel: json['yield_unit_label'] as String? ?? 'katoris',
      createdAt: DateTime.tryParse(json['created_at'] as String? ?? '') ?? DateTime.now(),
    );
  }

  String get ingredientsJson => jsonEncode(ingredients.map((i) => i.toJson()).toList());
}
