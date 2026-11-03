enum TadkaLevel {
  none,
  low,
  medium,
  high;

  String get label {
    switch (this) {
      case TadkaLevel.none:
        return 'No Tadka / Boiled';
      case TadkaLevel.low:
        return 'Low (1 tsp)';
      case TadkaLevel.medium:
        return 'Medium (2 tsp)';
      case TadkaLevel.high:
        return 'High (1 tbsp)';
    }
  }

  String get shortLabel {
    switch (this) {
      case TadkaLevel.none:
        return 'None';
      case TadkaLevel.low:
        return 'Low';
      case TadkaLevel.medium:
        return 'Medium';
      case TadkaLevel.high:
        return 'High';
    }
  }
}

enum TadkaFatSource {
  oil,
  ghee,
  butter;

  String get label {
    switch (this) {
      case TadkaFatSource.oil:
        return 'Cooking Oil';
      case TadkaFatSource.ghee:
        return 'Desi Ghee';
      case TadkaFatSource.butter:
        return 'Butter / Makhan';
    }
  }
}

class TadkaModel {
  final TadkaLevel level;
  final TadkaFatSource fatSource;

  /// Statutory and operational notice per Brain/trd.md §4.
  static const String estimateNotice =
      'Tadka fat addition is an estimated calculation, not an exact laboratory measurement.';

  const TadkaModel({
    this.level = TadkaLevel.none,
    this.fatSource = TadkaFatSource.oil,
  });

  double get additionalFatGrams {
    switch (level) {
      case TadkaLevel.none:
        return 0.0;
      case TadkaLevel.low:
        return 5.0; // 1 tsp ~ 5g
      case TadkaLevel.medium:
        return 10.0; // 2 tsp ~ 10g
      case TadkaLevel.high:
        return 15.0; // 1 tbsp ~ 15g
    }
  }

  double get additionalCalories {
    switch (fatSource) {
      case TadkaFatSource.oil:
      case TadkaFatSource.ghee:
        return double.parse((additionalFatGrams * 9.0).toStringAsFixed(1));
      case TadkaFatSource.butter:
        // Butter is ~80% fat, so ~7.2 kcal/g
        return double.parse((additionalFatGrams * 7.2).toStringAsFixed(1));
    }
  }

  TadkaModel copyWith({
    TadkaLevel? level,
    TadkaFatSource? fatSource,
  }) {
    return TadkaModel(
      level: level ?? this.level,
      fatSource: fatSource ?? this.fatSource,
    );
  }

  Map<String, dynamic> toJson() => {
        'level': level.name,
        'fat_source': fatSource.name,
        'additional_fat_grams': additionalFatGrams,
        'additional_calories': additionalCalories,
        'is_estimate': true,
      };

  factory TadkaModel.fromJson(Map<String, dynamic> json) {
    return TadkaModel(
      level: TadkaLevel.values.firstWhere(
        (l) => l.name == json['level'],
        orElse: () => TadkaLevel.none,
      ),
      fatSource: TadkaFatSource.values.firstWhere(
        (f) => f.name == json['fat_source'],
        orElse: () => TadkaFatSource.oil,
      ),
    );
  }
}

