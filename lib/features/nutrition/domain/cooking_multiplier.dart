import 'food_item.dart';
import 'portion_unit.dart';

enum CookingState {
  raw,
  cooked;

  String get label {
    switch (this) {
      case CookingState.raw:
        return 'Raw / Uncooked';
      case CookingState.cooked:
        return 'Cooked / Prepared';
    }
  }
}

enum CookingMethod {
  boiled,
  steamed,
  shallowFried,
  deepFried,
  roastedTandoor,
  curryGravy,
  rawUncooked;

  String get label {
    switch (this) {
      case CookingMethod.boiled:
        return 'Boiled';
      case CookingMethod.steamed:
        return 'Steamed';
      case CookingMethod.shallowFried:
        return 'Tawa / Shallow Fried';
      case CookingMethod.deepFried:
        return 'Deep Fried';
      case CookingMethod.roastedTandoor:
        return 'Tandoor / Roasted';
      case CookingMethod.curryGravy:
        return 'Curry / Gravy';
      case CookingMethod.rawUncooked:
        return 'Raw';
    }
  }
}

class CookingYieldMultiplier {
  final String id;
  final FoodCategory foodCategory;
  final double yieldFactor;
  final double waterAbsorptionPct;
  final int version;
  final String? notes;

  const CookingYieldMultiplier({
    required this.id,
    required this.foodCategory,
    required this.yieldFactor,
    this.waterAbsorptionPct = 0.0,
    this.version = 1,
    this.notes,
  });

  bool get isValid => yieldFactor > 0 && version > 0;

  Map<String, dynamic> toJson() => {
        'id': id,
        'food_category': foodCategory.name,
        'yield_factor': yieldFactor,
        'water_absorption_pct': waterAbsorptionPct,
        'version': version,
        if (notes != null) 'notes': notes,
      };

  factory CookingYieldMultiplier.fromJson(Map<String, dynamic> json) {
    return CookingYieldMultiplier(
      id: json['id'] as String,
      foodCategory: FoodCategory.values.firstWhere(
        (c) => c.name == json['food_category'],
        orElse: () => FoodCategory.sabzisCurries,
      ),
      yieldFactor: (json['yield_factor'] as num).toDouble(),
      waterAbsorptionPct: (json['water_absorption_pct'] as num?)?.toDouble() ?? 0.0,
      version: (json['version'] as num?)?.toInt() ?? 1,
      notes: json['notes'] as String?,
    );
  }
}

/// Deterministic cooking yield conversion engine per Brain/trd.md §4.
class CookingMultiplierEngine {
  const CookingMultiplierEngine();

  /// Calculates cooked weight in grams from raw weight.
  static double calculateCookedWeight(double rawWeightGrams, double yieldFactor) {
    if (rawWeightGrams <= 0 || yieldFactor <= 0) return 0.0;
    return double.parse((rawWeightGrams * yieldFactor).toStringAsFixed(1));
  }

  /// Calculates raw equivalent weight in grams from cooked weight.
  static double calculateRawWeight(double cookedWeightGrams, double yieldFactor) {
    if (cookedWeightGrams <= 0 || yieldFactor <= 0) return 0.0;
    return double.parse((cookedWeightGrams / yieldFactor).toStringAsFixed(1));
  }

  /// Converts nutrition values per 100g between raw and cooked states.
  static NutritionValues convertNutritionDensity({
    required NutritionValues baseValues,
    required CookingState sourceState,
    required CookingState targetState,
    required double yieldFactor,
  }) {
    if (sourceState == targetState || yieldFactor <= 0) {
      return baseValues;
    }

    if (sourceState == CookingState.raw && targetState == CookingState.cooked) {
      // 100g raw expands into (100 * yieldFactor)g cooked.
      // Therefore, 100g cooked has density = raw / yieldFactor.
      return baseValues * (1.0 / yieldFactor);
    } else {
      // source is cooked, target is raw.
      return baseValues * yieldFactor;
    }
  }
}
