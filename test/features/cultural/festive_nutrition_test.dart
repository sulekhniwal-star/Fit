import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/domain/festive_balance_calculator.dart';
import 'package:fitkarma/features/cultural/domain/festive_food.dart';

void main() {
  group('Festive Nutrition & Feast Balance Tests', () {
    test('all festive foods in catalog have positive macros and authentic cultural notes', () {
      expect(FestiveFood.catalog, isNotEmpty);

      for (final food in FestiveFood.catalog) {
        expect(food.name, isNotEmpty);
        expect(food.hindiName, isNotEmpty);
        expect(food.calories, greaterThan(50.0));
        expect(food.portionGrams, greaterThan(10.0));
        expect(food.proteinGrams, greaterThanOrEqualTo(0.0));
        expect(food.carbsGrams, greaterThan(0.0));
        expect(food.fatGrams, greaterThanOrEqualTo(0.0));
        expect(food.culturalNote, isNotEmpty);
      }
    });

    test('specific iconic festive sweets have calibrated nutritional accuracy', () {
      final kajuKatli = FestiveFood.catalog.firstWhere((f) => f.id == 'food_kaju_katli');
      expect(kajuKatli.portionGrams, 20.0);
      expect(kajuKatli.calories, closeTo(95.0, 1.0));

      final besanLaddoo = FestiveFood.catalog.firstWhere((f) => f.id == 'food_besan_laddoo');
      expect(besanLaddoo.calories, closeTo(220.0, 1.0));
      expect(besanLaddoo.fatGrams, greaterThan(10.0));

      final modak = FestiveFood.catalog.firstWhere((f) => f.id == 'food_modak');
      expect(modak.calories, lessThan(150.0));
    });

    test('FestiveBalanceCalculator distributes calories safely without punitive extreme deficits', () {
      final plan = FestiveBalanceCalculator.calculatePlan(
        estimatedFeastCalories: 600,
        redistributionDays: 3,
      );

      expect(plan.estimatedFeastCalories, 600);
      expect(plan.redistributionDays, 3);
      expect(plan.dailyCalorieAdjustment, 200.0); // 200 kcal/day adjustment over 3 days
      expect(plan.preFeastGuidelines, isNotEmpty);
      expect(plan.postFeastRecoveryTips.any((t) => t.contains('Shatapawali')), isTrue);
      expect(plan.shameFreeAffirmation, contains('gratitude'));
    });
  });
}

