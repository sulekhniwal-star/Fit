import 'portion_unit.dart';

enum FoodCategory {
  rotiBreads,
  riceGrains,
  dalsPulses,
  sabzisCurries,
  southIndian,
  snacksStreetFood,
  sweetsDesserts,
  dairyBeverages,
  meatPoultrySeafood,
  fruitsNuts,
  condimentsChutneys;

  String get displayName {
    switch (this) {
      case FoodCategory.rotiBreads:
        return 'Roti & Breads';
      case FoodCategory.riceGrains:
        return 'Rice & Grains';
      case FoodCategory.dalsPulses:
        return 'Dals & Pulses';
      case FoodCategory.sabzisCurries:
        return 'Sabzis & Curries';
      case FoodCategory.southIndian:
        return 'South Indian';
      case FoodCategory.snacksStreetFood:
        return 'Snacks & Street Food';
      case FoodCategory.sweetsDesserts:
        return 'Sweets & Desserts';
      case FoodCategory.dairyBeverages:
        return 'Dairy & Beverages';
      case FoodCategory.meatPoultrySeafood:
        return 'Meat, Poultry & Seafood';
      case FoodCategory.fruitsNuts:
        return 'Fruits & Nuts';
      case FoodCategory.condimentsChutneys:
        return 'Chutneys & Pickles';
    }
  }
}

class FoodItem {
  final String id;
  final String name;
  final String hindiName;
  final FoodCategory category;
  final double caloriesPer100g;
  final double proteinPer100g;
  final double carbsPer100g;
  final double fatPer100g;
  final double fiberPer100g;
  final bool isVegetarian;
  final bool isEgg;
  final bool isVegan;
  final String cuisineRegion;
  final PortionUnit defaultPortionUnit;
  final double basePortionGrams;
  final String provenance;

  const FoodItem({
    required this.id,
    required this.name,
    required this.hindiName,
    required this.category,
    required this.caloriesPer100g,
    required this.proteinPer100g,
    required this.carbsPer100g,
    required this.fatPer100g,
    this.fiberPer100g = 0.0,
    this.isVegetarian = true,
    this.isEgg = false,
    this.isVegan = false,
    this.cuisineRegion = 'Pan-Indian',
    this.defaultPortionUnit = PortionUnit.mediumKatori,
    this.basePortionGrams = 100.0,
    this.provenance = 'ICMR-NIN 2024 / IFCT Standard',
  });

  bool get isValid {
    return caloriesPer100g >= 0 &&
        proteinPer100g >= 0 &&
        carbsPer100g >= 0 &&
        fatPer100g >= 0 &&
        fiberPer100g >= 0 &&
        basePortionGrams > 0;
  }

  /// Calculates nutritional values for a specific portion and quantity.
  NutritionValues calculateForPortion(PortionUnit unit, double quantity) {
    if (quantity <= 0) {
      return const NutritionValues(
        calories: 0.0,
        proteinGrams: 0.0,
        carbsGrams: 0.0,
        fatGrams: 0.0,
        fiberGrams: 0.0,
      );
    }

    final totalGrams = PortionCalculator.calculateGrams(this, unit, quantity);
    final ratio = totalGrams / 100.0;

    return NutritionValues(
      calories: double.parse((caloriesPer100g * ratio).toStringAsFixed(1)),
      proteinGrams: double.parse((proteinPer100g * ratio).toStringAsFixed(1)),
      carbsGrams: double.parse((carbsPer100g * ratio).toStringAsFixed(1)),
      fatGrams: double.parse((fatPer100g * ratio).toStringAsFixed(1)),
      fiberGrams: double.parse((fiberPer100g * ratio).toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hindi_name': hindiName,
        'category': category.name,
        'calories_per_100g': caloriesPer100g,
        'protein_per_100g': proteinPer100g,
        'carbs_per_100g': carbsPer100g,
        'fat_per_100g': fatPer100g,
        'fiber_per_100g': fiberPer100g,
        'is_vegetarian': isVegetarian,
        'is_egg': isEgg,
        'is_vegan': isVegan,
        'cuisine_region': cuisineRegion,
        'default_portion_unit': defaultPortionUnit.name,
        'base_portion_grams': basePortionGrams,
        'provenance': provenance,
      };

  factory FoodItem.fromJson(Map<String, dynamic> json) {
    return FoodItem(
      id: json['id'] as String,
      name: json['name'] as String,
      hindiName: json['hindi_name'] as String? ?? '',
      category: FoodCategory.values.firstWhere(
        (c) => c.name == json['category'],
        orElse: () => FoodCategory.sabzisCurries,
      ),
      caloriesPer100g: (json['calories_per_100g'] as num).toDouble(),
      proteinPer100g: (json['protein_per_100g'] as num).toDouble(),
      carbsPer100g: (json['carbs_per_100g'] as num).toDouble(),
      fatPer100g: (json['fat_per_100g'] as num).toDouble(),
      fiberPer100g: (json['fiber_per_100g'] as num?)?.toDouble() ?? 0.0,
      isVegetarian: json['is_vegetarian'] as bool? ?? true,
      isEgg: json['is_egg'] as bool? ?? false,
      isVegan: json['is_vegan'] as bool? ?? false,
      cuisineRegion: json['cuisine_region'] as String? ?? 'Pan-Indian',
      defaultPortionUnit: PortionUnit.values.firstWhere(
        (u) => u.name == json['default_portion_unit'],
        orElse: () => PortionUnit.mediumKatori,
      ),
      basePortionGrams: (json['base_portion_grams'] as num?)?.toDouble() ?? 100.0,
      provenance: json['provenance'] as String? ?? 'ICMR-NIN 2024 / IFCT Standard',
    );
  }
}

/// Authoritative Indian portion conversion engine per Brain/trd.md §4.
class PortionCalculator {
  const PortionCalculator();

  /// Converts a household unit and quantity into equivalent weight in grams.
  static double calculateGrams(FoodItem food, PortionUnit unit, double quantity) {
    if (quantity <= 0) return 0.0;

    switch (unit) {
      case PortionUnit.gram:
        return quantity;

      case PortionUnit.ml:
        return quantity * _getFoodDensity(food);

      case PortionUnit.roti:
        // Standard phulka is ~40-45g cooked (~30g raw wheat flour)
        return quantity * (food.category == FoodCategory.rotiBreads ? food.basePortionGrams : 40.0);

      case PortionUnit.idli:
        return quantity * 40.0;

      case PortionUnit.piece:
        return quantity * food.basePortionGrams;

      case PortionUnit.serving:
        return quantity * food.basePortionGrams;

      case PortionUnit.teaspoon:
        return quantity * 5.0;

      case PortionUnit.tablespoon:
        return quantity * 15.0;

      case PortionUnit.glass:
        // 250ml glass
        return quantity * (250.0 * _getFoodDensity(food));

      case PortionUnit.smallKatori:
        // 150ml volume
        return quantity * _calculateKatoriGrams(food, 150.0);

      case PortionUnit.mediumKatori:
        // 200ml volume (Standard Indian bowl)
        return quantity * _calculateKatoriGrams(food, 200.0);

      case PortionUnit.largeKatori:
        // 250ml volume
        return quantity * _calculateKatoriGrams(food, 250.0);
    }
  }

  static double _calculateKatoriGrams(FoodItem food, double volumeMl) {
    switch (food.category) {
      case FoodCategory.dalsPulses:
      case FoodCategory.sabzisCurries:
        return volumeMl * 1.05; // Liquid/gravy density ~1.05 g/ml
      case FoodCategory.riceGrains:
        return volumeMl * 0.80; // Fluffy cooked grain density ~0.80 g/ml
      case FoodCategory.dairyBeverages:
        return volumeMl * 1.02; // Curd/raita ~1.02 g/ml
      default:
        return volumeMl * 0.90; // Default mixed dish density
    }
  }

  static double _getFoodDensity(FoodItem food) {
    if (food.category == FoodCategory.dairyBeverages) {
      if (food.name.toLowerCase().contains('lassi')) return 1.12;
      if (food.name.toLowerCase().contains('chaas') || food.name.toLowerCase().contains('buttermilk')) {
        return 1.01;
      }
      return 1.03;
    }
    return 1.0;
  }
}
