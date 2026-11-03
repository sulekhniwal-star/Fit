import '../../nutrition/data/drift_food_catalog_repository.dart';
import '../../nutrition/domain/food_item.dart';
import '../../nutrition/domain/portion_unit.dart';
import 'ai_models.dart';

class IndianFoodMatcher {
  final DriftFoodCatalogRepository _catalogRepo;

  const IndianFoodMatcher(this._catalogRepo);

  Future<AiMealAnalysisResult> matchAndNormalize(
    AiMealAnalysisResult rawResult,
  ) async {
    final normalizedItems = <AiCandidateItem>[];

    for (final item in rawResult.candidateItems) {
      final matchedItem = await _matchSingleItem(item);
      normalizedItems.add(matchedItem);
    }

    final totalCal = normalizedItems.fold<double>(
      0.0,
      (s, i) => s + (i.estimatedCalories * i.quantity),
    );
    final totalP = normalizedItems.fold<double>(
      0.0,
      (s, i) => s + (i.proteinGrams * i.quantity),
    );
    final totalC = normalizedItems.fold<double>(
      0.0,
      (s, i) => s + (i.carbsGrams * i.quantity),
    );
    final totalF = normalizedItems.fold<double>(
      0.0,
      (s, i) => s + (i.fatGrams * i.quantity),
    );

    return AiMealAnalysisResult(
      summary: rawResult.summary,
      candidateItems: normalizedItems,
      totalCalories: double.parse(totalCal.toStringAsFixed(1)),
      totalProtein: double.parse(totalP.toStringAsFixed(1)),
      totalCarbs: double.parse(totalC.toStringAsFixed(1)),
      totalFat: double.parse(totalF.toStringAsFixed(1)),
      overallConfidence: rawResult.overallConfidence,
      uncertaintyReasons: rawResult.uncertaintyReasons,
      coaching: rawResult.coaching,
      statutoryDisclaimer: rawResult.statutoryDisclaimer,
    );
  }

  Future<AiCandidateItem> _matchSingleItem(AiCandidateItem item) async {
    // Extract candidate search terms
    final terms = _generateSearchTerms(item.foodName);

    FoodItem? bestMatch;
    for (final term in terms) {
      final searchRes = await _catalogRepo.search(term, limit: 5);
      final matches = searchRes.dataOrNull ?? [];
      if (matches.isNotEmpty) {
        // Find best match by exact prefix or first result
        bestMatch = matches.firstWhere(
          (m) =>
              m.name.toLowerCase().contains(term.toLowerCase()) ||
              m.hindiName.toLowerCase().contains(term.toLowerCase()),
          orElse: () => matches.first,
        );
        break;
      }
    }

    if (bestMatch == null) {
      return item.copyWith(isVerifiedInCatalog: false);
    }

    // Calculate verified portion nutrition
    final gramsPerUnit = _estimateGramsPerUnit(item.unit, bestMatch);
    final totalGrams = gramsPerUnit;
    final factor = totalGrams / 100.0;

    final verifiedCal = double.parse((bestMatch.caloriesPer100g * factor).toStringAsFixed(1));
    final verifiedP = double.parse((bestMatch.proteinPer100g * factor).toStringAsFixed(1));
    final verifiedC = double.parse((bestMatch.carbsPer100g * factor).toStringAsFixed(1));
    final verifiedF = double.parse((bestMatch.fatPer100g * factor).toStringAsFixed(1));

    return item.copyWith(
      foodName: bestMatch.name,
      estimatedCalories: verifiedCal,
      proteinGrams: verifiedP,
      carbsGrams: verifiedC,
      fatGrams: verifiedF,
      isVerifiedInCatalog: true,
      matchedCatalogFoodId: bestMatch.id,
      confidence: (item.confidence + 0.1).clamp(0.0, 1.0),
    );
  }

  List<String> _generateSearchTerms(String foodName) {
    final clean = foodName.replaceAll(RegExp(r'[^\w\s]'), ' ').trim();
    final parts = clean.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();

    final terms = <String>[foodName];
    if (parts.isNotEmpty) {
      terms.add(parts.first);
      if (parts.length > 1) {
        terms.add(parts.take(2).join(' '));
      }
    }
    return terms;
  }

  double _estimateGramsPerUnit(PortionUnit unit, FoodItem match) {
    switch (unit) {
      case PortionUnit.piece:
      case PortionUnit.roti:
      case PortionUnit.idli:
      case PortionUnit.serving:
        return match.basePortionGrams;
      case PortionUnit.smallKatori:
        return 150.0;
      case PortionUnit.mediumKatori:
        return 200.0;
      case PortionUnit.largeKatori:
        return 250.0;
      case PortionUnit.glass:
        return 250.0;
      case PortionUnit.tablespoon:
        return 15.0;
      case PortionUnit.teaspoon:
        return 5.0;
      case PortionUnit.gram:
      case PortionUnit.ml:
        return 100.0;
    }
  }
}

