import '../../nutrition/domain/cooking_multiplier.dart';
import '../../nutrition/domain/portion_unit.dart';
import '../../nutrition/domain/tadka_model.dart';

enum AiConfidenceLevel {
  high,
  medium,
  low;

  static AiConfidenceLevel fromScore(double score) {
    if (score >= 0.85) return AiConfidenceLevel.high;
    if (score >= 0.65) return AiConfidenceLevel.medium;
    return AiConfidenceLevel.low;
  }

  String get label {
    switch (this) {
      case AiConfidenceLevel.high:
        return 'High Confidence';
      case AiConfidenceLevel.medium:
        return 'Moderate Confidence';
      case AiConfidenceLevel.low:
        return 'Low Confidence (Verify Items)';
    }
  }
}

class AiCandidateItem {
  final String foodName;
  final double quantity;
  final PortionUnit unit;
  final CookingState cookingState;
  final TadkaLevel tadkaLevel;
  final double estimatedCalories;
  final double proteinGrams;
  final double carbsGrams;
  final double fatGrams;
  final double confidence; // 0.0 to 1.0
  final bool isVerifiedInCatalog;
  final String? matchedCatalogFoodId;

  const AiCandidateItem({
    required this.foodName,
    required this.quantity,
    required this.unit,
    this.cookingState = CookingState.cooked,
    this.tadkaLevel = TadkaLevel.medium,
    required this.estimatedCalories,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.fatGrams,
    required this.confidence,
    this.isVerifiedInCatalog = false,
    this.matchedCatalogFoodId,
  });

  AiCandidateItem copyWith({
    String? foodName,
    double? quantity,
    PortionUnit? unit,
    CookingState? cookingState,
    TadkaLevel? tadkaLevel,
    double? estimatedCalories,
    double? proteinGrams,
    double? carbsGrams,
    double? fatGrams,
    double? confidence,
    bool? isVerifiedInCatalog,
    String? matchedCatalogFoodId,
  }) {
    return AiCandidateItem(
      foodName: foodName ?? this.foodName,
      quantity: quantity ?? this.quantity,
      unit: unit ?? this.unit,
      cookingState: cookingState ?? this.cookingState,
      tadkaLevel: tadkaLevel ?? this.tadkaLevel,
      estimatedCalories: estimatedCalories ?? this.estimatedCalories,
      proteinGrams: proteinGrams ?? this.proteinGrams,
      carbsGrams: carbsGrams ?? this.carbsGrams,
      fatGrams: fatGrams ?? this.fatGrams,
      confidence: confidence ?? this.confidence,
      isVerifiedInCatalog: isVerifiedInCatalog ?? this.isVerifiedInCatalog,
      matchedCatalogFoodId: matchedCatalogFoodId ?? this.matchedCatalogFoodId,
    );
  }

  Map<String, dynamic> toJson() => {
        'food_name': foodName,
        'quantity': quantity,
        'unit': unit.name,
        'cooking_state': cookingState.name,
        'tadka_level': tadkaLevel.name,
        'estimated_calories': estimatedCalories,
        'protein_g': proteinGrams,
        'carbs_g': carbsGrams,
        'fat_g': fatGrams,
        'confidence': confidence,
        'is_verified': isVerifiedInCatalog,
        if (matchedCatalogFoodId != null) 'matched_id': matchedCatalogFoodId,
      };

  factory AiCandidateItem.fromJson(Map<String, dynamic> json) {
    return AiCandidateItem(
      foodName: json['food_name'] as String? ?? 'Indian Dish',
      quantity: (json['quantity'] as num?)?.toDouble() ?? 1.0,
      unit: _parseUnit(json['unit'] as String?),
      cookingState: json['cooking_state'] == 'raw'
          ? CookingState.raw
          : CookingState.cooked,
      tadkaLevel: _parseTadka(json['tadka_level'] as String?),
      estimatedCalories: (json['estimated_calories'] as num?)?.toDouble() ?? 150.0,
      proteinGrams: (json['protein_g'] as num?)?.toDouble() ?? 5.0,
      carbsGrams: (json['carbs_g'] as num?)?.toDouble() ?? 25.0,
      fatGrams: (json['fat_g'] as num?)?.toDouble() ?? 4.0,
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.8,
      isVerifiedInCatalog: json['is_verified'] as bool? ?? false,
      matchedCatalogFoodId: json['matched_id'] as String?,
    );
  }

  static PortionUnit _parseUnit(String? unitStr) {
    if (unitStr == null) return PortionUnit.mediumKatori;
    final lower = unitStr.toLowerCase();
    if (lower.contains('piece') || lower.contains('roti')) return PortionUnit.piece;
    if (lower.contains('small')) return PortionUnit.smallKatori;
    if (lower.contains('large')) return PortionUnit.largeKatori;
    if (lower.contains('katori') || lower.contains('bowl')) return PortionUnit.mediumKatori;
    if (lower.contains('glass') || lower.contains('cup')) return PortionUnit.glass;
    if (lower.contains('tablespoon') || lower.contains('tbsp')) return PortionUnit.tablespoon;
    if (lower.contains('teaspoon') || lower.contains('tsp')) return PortionUnit.teaspoon;
    if (lower.contains('gram') || lower == 'g') return PortionUnit.gram;
    return PortionUnit.mediumKatori;
  }

  static TadkaLevel _parseTadka(String? tadkaStr) {
    if (tadkaStr == null) return TadkaLevel.medium;
    final lower = tadkaStr.toLowerCase();
    if (lower.contains('none') || lower.contains('no')) return TadkaLevel.none;
    if (lower.contains('low')) return TadkaLevel.low;
    if (lower.contains('high') || lower.contains('heavy')) return TadkaLevel.high;
    return TadkaLevel.medium;
  }
}

class AiHinglishInsight {
  final String headline;
  final String hinglishText;
  final String tone;

  const AiHinglishInsight({
    required this.headline,
    required this.hinglishText,
    this.tone = 'supportive',
  });

  Map<String, dynamic> toJson() => {
        'headline': headline,
        'hinglish_text': hinglishText,
        'tone': tone,
      };

  factory AiHinglishInsight.fromJson(Map<String, dynamic> json) =>
      AiHinglishInsight(
        headline: json['headline'] as String? ?? 'Nutrition Insight',
        hinglishText: json['hinglish_text'] as String? ??
            'Aapka meal log ready hai. Portions check karke confirm karein!',
        tone: json['tone'] as String? ?? 'supportive',
      );
}

class AiMealAnalysisResult {
  final String summary;
  final List<AiCandidateItem> candidateItems;
  final double totalCalories;
  final double totalProtein;
  final double totalCarbs;
  final double totalFat;
  final AiConfidenceLevel overallConfidence;
  final List<String> uncertaintyReasons;
  final AiHinglishInsight coaching;
  final String statutoryDisclaimer;

  const AiMealAnalysisResult({
    required this.summary,
    required this.candidateItems,
    required this.totalCalories,
    required this.totalProtein,
    required this.totalCarbs,
    required this.totalFat,
    required this.overallConfidence,
    required this.uncertaintyReasons,
    required this.coaching,
    this.statutoryDisclaimer =
        'Nutritional estimate only. Not clinical or medical guidance.',
  });

  factory AiMealAnalysisResult.fromGatewayJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List<dynamic>?) ?? [];
    final items = rawItems
        .map((it) => AiCandidateItem.fromJson(it as Map<String, dynamic>))
        .toList();

    final cal = items.fold<double>(0.0, (s, i) => s + (i.estimatedCalories * i.quantity));
    final p = items.fold<double>(0.0, (s, i) => s + (i.proteinGrams * i.quantity));
    final c = items.fold<double>(0.0, (s, i) => s + (i.carbsGrams * i.quantity));
    final f = items.fold<double>(0.0, (s, i) => s + (i.fatGrams * i.quantity));

    final confidenceScore = (json['confidence_overall'] as num?)?.toDouble() ?? 0.85;

    final reasons = (json['uncertainty_reasons'] as List<dynamic>?)
            ?.map((r) => r.toString())
            .toList() ??
        [];

    final coachingText = json['hinglish_insight'] as String? ??
        'Badhiya tracking! Portions check karke confirm karein.';

    return AiMealAnalysisResult(
      summary: json['summary'] as String? ?? 'Estimated meal items',
      candidateItems: items,
      totalCalories: cal,
      totalProtein: p,
      totalCarbs: c,
      totalFat: f,
      overallConfidence: AiConfidenceLevel.fromScore(confidenceScore),
      uncertaintyReasons: reasons,
      coaching: AiHinglishInsight(
        headline: 'AI Meal Estimate',
        hinglishText: coachingText,
      ),
      statutoryDisclaimer: json['statutory_disclaimer'] as String? ??
          'Nutritional estimate only. Not clinical or medical guidance.',
    );
  }
}

