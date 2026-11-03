import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/ai/domain/ai_models.dart';
import 'package:fitkarma/features/ai/domain/indian_food_matcher.dart';
import 'package:fitkarma/features/nutrition/data/drift_food_catalog_repository.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';

void main() {
  group('IndianFoodMatcher Integration Tests', () {
    late AppDatabase db;
    late DriftFoodCatalogRepository repo;
    late IndianFoodMatcher matcher;

    setUp(() async {
      db = AppDatabase.memory();
      repo = DriftFoodCatalogRepository(db);
      await repo.ensureSeeded();
      matcher = IndianFoodMatcher(repo);
    });

    tearDown(() async {
      await db.close();
    });

    test('matches recognized Indian dishes and normalizes nutrition with catalog data', () async {
      const rawResult = AiMealAnalysisResult(
        summary: '2 rotis and 1 bowl dal',
        candidateItems: [
          AiCandidateItem(
            foodName: 'Phulka Roti',
            quantity: 2.0,
            unit: PortionUnit.piece,
            estimatedCalories: 150.0,
            proteinGrams: 4.0,
            carbsGrams: 30.0,
            fatGrams: 2.0,
            confidence: 0.85,
          ),
          AiCandidateItem(
            foodName: 'Toor Dal Tadka',
            quantity: 1.0,
            unit: PortionUnit.mediumKatori,
            estimatedCalories: 180.0,
            proteinGrams: 7.0,
            carbsGrams: 25.0,
            fatGrams: 6.0,
            confidence: 0.90,
          ),
        ],
        totalCalories: 330.0,
        totalProtein: 11.0,
        totalCarbs: 55.0,
        totalFat: 8.0,
        overallConfidence: AiConfidenceLevel.high,
        uncertaintyReasons: [],
        coaching: AiHinglishInsight(
          headline: 'Great balanced lunch',
          hinglishText: 'Roti aur Dal ka perfect balance hai!',
        ),
      );

      final normalized = await matcher.matchAndNormalize(rawResult);

      expect(normalized.candidateItems.length, equals(2));

      // Phulka check
      final rotiItem = normalized.candidateItems[0];
      expect(rotiItem.isVerifiedInCatalog, isTrue);
      expect(rotiItem.matchedCatalogFoodId, isNotNull);
      // Catalog: base portion = 40g, 265 kcal / 100g -> ~106 kcal per roti
      expect(rotiItem.estimatedCalories, closeTo(106.0, 5.0));

      // Dal check
      final dalItem = normalized.candidateItems[1];
      expect(dalItem.isVerifiedInCatalog, isTrue);
      expect(dalItem.matchedCatalogFoodId, isNotNull);
      // Medium katori = 200g, 105 kcal / 100g -> ~210 kcal
      expect(dalItem.estimatedCalories, closeTo(210.0, 5.0));

      // Re-aggregated totals
      // 2 rotis (2 * 106 = 212) + 1 dal (210) = ~422 kcal
      expect(normalized.totalCalories, closeTo(422.0, 15.0));
      expect(normalized.totalProtein, greaterThan(15.0));
    });

    test('retains raw estimates gracefully for unknown regional or custom foods', () async {
      const rawResult = AiMealAnalysisResult(
        summary: 'Grandmother secret stew',
        candidateItems: [
          AiCandidateItem(
            foodName: 'RandomUnknownFoodX99',
            quantity: 1.0,
            unit: PortionUnit.mediumKatori,
            estimatedCalories: 250.0,
            proteinGrams: 10.0,
            carbsGrams: 30.0,
            fatGrams: 8.0,
            confidence: 0.60,
          ),
        ],
        totalCalories: 250.0,
        totalProtein: 10.0,
        totalCarbs: 30.0,
        totalFat: 8.0,
        overallConfidence: AiConfidenceLevel.medium,
        uncertaintyReasons: ['Item not in standard database'],
        coaching: AiHinglishInsight(
          headline: 'Custom Dish',
          hinglishText: 'Item catalog mein nahi mila, portions manually check kar lein.',
        ),
      );

      final normalized = await matcher.matchAndNormalize(rawResult);

      expect(normalized.candidateItems.length, equals(1));
      final item = normalized.candidateItems.first;
      expect(item.isVerifiedInCatalog, isFalse);
      expect(item.matchedCatalogFoodId, isNull);
      expect(item.estimatedCalories, equals(250.0));
      expect(item.proteinGrams, equals(10.0));
      expect(normalized.totalCalories, equals(250.0));
    });
  });
}

