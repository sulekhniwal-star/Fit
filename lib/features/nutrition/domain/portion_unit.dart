enum PortionUnit {
  gram,
  ml,
  smallKatori,
  mediumKatori,
  largeKatori,
  glass,
  teaspoon,
  tablespoon,
  piece,
  serving,
  roti,
  idli;

  String get label {
    switch (this) {
      case PortionUnit.gram:
        return 'g';
      case PortionUnit.ml:
        return 'ml';
      case PortionUnit.smallKatori:
        return 'Small Katori (150ml)';
      case PortionUnit.mediumKatori:
        return 'Medium Katori (200ml)';
      case PortionUnit.largeKatori:
        return 'Large Katori (250ml)';
      case PortionUnit.glass:
        return 'Glass (250ml)';
      case PortionUnit.teaspoon:
        return 'Teaspoon (5g)';
      case PortionUnit.tablespoon:
        return 'Tablespoon (15g)';
      case PortionUnit.piece:
        return 'Piece';
      case PortionUnit.serving:
        return 'Standard Serving';
      case PortionUnit.roti:
        return 'Roti';
      case PortionUnit.idli:
        return 'Idli';
    }
  }

  String get shortLabel {
    switch (this) {
      case PortionUnit.gram:
        return 'g';
      case PortionUnit.ml:
        return 'ml';
      case PortionUnit.smallKatori:
        return 'sm katori';
      case PortionUnit.mediumKatori:
        return 'katori';
      case PortionUnit.largeKatori:
        return 'lg katori';
      case PortionUnit.glass:
        return 'glass';
      case PortionUnit.teaspoon:
        return 'tsp';
      case PortionUnit.tablespoon:
        return 'tbsp';
      case PortionUnit.piece:
        return 'pc';
      case PortionUnit.serving:
        return 'serving';
      case PortionUnit.roti:
        return 'roti';
      case PortionUnit.idli:
        return 'idli';
    }
  }
}

class NutritionValues {
  final double calories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double fiberGrams;

  const NutritionValues({
    required this.calories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.fiberGrams,
  });

  NutritionValues operator *(double factor) {
    return NutritionValues(
      calories: double.parse((calories * factor).toStringAsFixed(1)),
      proteinGrams: double.parse((proteinGrams * factor).toStringAsFixed(1)),
      carbsGrams: double.parse((carbsGrams * factor).toStringAsFixed(1)),
      fatGrams: double.parse((fatGrams * factor).toStringAsFixed(1)),
      fiberGrams: double.parse((fiberGrams * factor).toStringAsFixed(1)),
    );
  }

  NutritionValues operator +(NutritionValues other) {
    return NutritionValues(
      calories: double.parse((calories + other.calories).toStringAsFixed(1)),
      proteinGrams: double.parse((proteinGrams + other.proteinGrams).toStringAsFixed(1)),
      carbsGrams: double.parse((carbsGrams + other.carbsGrams).toStringAsFixed(1)),
      fatGrams: double.parse((fatGrams + other.fatGrams).toStringAsFixed(1)),
      fiberGrams: double.parse((fiberGrams + other.fiberGrams).toStringAsFixed(1)),
    );
  }

  Map<String, dynamic> toJson() => {
        'calories': calories,
        'protein_grams': proteinGrams,
        'carbs_grams': carbsGrams,
        'fat_grams': fatGrams,
        'fiber_grams': fiberGrams,
      };

  factory NutritionValues.fromJson(Map<String, dynamic> json) {
    return NutritionValues(
      calories: (json['calories'] as num?)?.toDouble() ?? 0.0,
      proteinGrams: (json['protein_grams'] as num?)?.toDouble() ?? 0.0,
      carbsGrams: (json['carbs_grams'] as num?)?.toDouble() ?? 0.0,
      fatGrams: (json['fat_grams'] as num?)?.toDouble() ?? 0.0,
      fiberGrams: (json['fiber_grams'] as num?)?.toDouble() ?? 0.0,
    );
  }
}

