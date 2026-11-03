import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/nutrition/data/drift_meal_log_repository.dart';
import 'package:fitkarma/features/nutrition/domain/dynamic_tdee_calculator.dart';
import 'package:fitkarma/features/nutrition/domain/family_recipe.dart';
import 'package:fitkarma/features/nutrition/domain/food_log_entry.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';

void main() {
  group('Family Recipe Splitter Domain Tests', () {
    final recipe = FamilyRecipe(
      id: 'rec_1',
      userId: 'u1',
      name: 'Maa ki Dal Pot',
      totalYieldGramsOrKatoris: 4.0, // 4 katoris
      createdAt: DateTime.now(),
      ingredients: const [
        RecipeIngredient(
          foodName: 'Black Urad Dal',
          quantity: 200.0,
          unit: PortionUnit.gram,
          nutrition: NutritionValues(
            calories: 700.0,
            proteinGrams: 48.0,
            carbsGrams: 120.0,
            fatGrams: 3.0,
            fiberGrams: 20.0,
          ),
        ),
        RecipeIngredient(
          foodName: 'Desi Ghee Tadka',
          quantity: 2.0,
          unit: PortionUnit.tablespoon,
          nutrition: NutritionValues(
            calories: 270.0,
            proteinGrams: 0.0,
            carbsGrams: 0.0,
            fatGrams: 30.0,
            fiberGrams: 0.0,
          ),
        ),
      ],
    );

    test('calculates cumulative batch pot nutrition', () {
      final total = recipe.totalNutrition;
      expect(total.calories, equals(970.0));
      expect(total.proteinGrams, equals(48.0));
      expect(total.fatGrams, equals(33.0));
    });

    test('splits portion by percentage accurately', () {
      // 0%
      final zero = recipe.splitByPercentage(0.0);
      expect(zero.calories, equals(0.0));

      // 25% (quarter of pot)
      final quarter = recipe.splitByPercentage(25.0);
      expect(quarter.calories, equals(242.5));
      expect(quarter.proteinGrams, equals(12.0));
      expect(quarter.fatGrams, equals(8.3));

      // 50% (half of pot)
      final half = recipe.splitByPercentage(50.0);
      expect(half.calories, equals(485.0));

      // 100%
      final full = recipe.splitByPercentage(100.0);
      expect(full.calories, equals(970.0));
    });

    test('splits portion by katoris consumed', () {
      // 1 katori out of 4 total katoris = 25%
      final oneKatori = recipe.splitByKatoris(1.0);
      expect(oneKatori.calories, equals(242.5));

      // 2 katoris out of 4 total katoris = 50%
      final twoKatoris = recipe.splitByKatoris(2.0);
      expect(twoKatoris.calories, equals(485.0));
    });
  });

  group('Dynamic TDEE Calculator Tests', () {
    const calc = DynamicTdeeCalculator();

    test('computes Mifflin-St Jeor BMR for male and female', () {
      // 70kg, 175cm, 30yo male
      // BMR = 10*70 + 6.25*175 - 5*30 + 5 = 700 + 1093.75 - 150 + 5 = 1648.75
      final maleBmr = calc.calculateBmr(weightKg: 70.0, heightCm: 175.0, age: 30, isMale: true);
      expect(maleBmr, closeTo(1648.75, 1.0));

      // 60kg, 162cm, 28yo female
      // BMR = 10*60 + 6.25*162 - 5*28 - 161 = 600 + 1012.5 - 140 - 161 = 1311.5
      final femaleBmr = calc.calculateBmr(weightKg: 60.0, heightCm: 162.0, age: 28, isMale: false);
      expect(femaleBmr, closeTo(1311.5, 1.0));
    });

    test('calibrates activity multiplier from daily step count', () {
      expect(calc.calculateActivityMultiplier(3000), equals(1.20)); // Sedentary
      expect(calc.calculateActivityMultiplier(6000), equals(1.375)); // Lightly active
      expect(calc.calculateActivityMultiplier(8500), equals(1.55)); // Moderately active
      expect(calc.calculateActivityMultiplier(12000), equals(1.725)); // Highly active
    });

    test('dynamically adapts TDEE when weight trend and intake history exist', () {
      final res = calc.calculate(
        weightKg: 70.0,
        heightCm: 175.0,
        age: 30,
        isMale: true,
        dailySteps: 8500,
        weeklyWeightChangeKg: -0.5, // Lost 0.5 kg in a week (deficit of ~550 kcal/day)
        averageDailyIntakeKcal: 2000.0,
      );

      // Baseline TDEE = ~1649 * 1.55 = ~2556
      // Empirical TDEE = 2000 - (-0.5 * 7700 / 7) = 2000 - (-550) = 2550
      expect(res.estimatedTdee, closeTo(2550.0, 50.0));
      expect(res.confidenceLevel, equals('high'));
    });

    test('applies user override when specified', () {
      final res = calc.calculate(
        weightKg: 70.0,
        heightCm: 175.0,
        age: 30,
        isMale: true,
        dailySteps: 6000,
        userOverrideTdee: 2200.0,
      );
      expect(res.estimatedTdee, equals(2200.0));
      expect(res.isUserOverride, isTrue);
    });
  });

  group('DriftMealLogRepository Integration Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftMealLogRepository repo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      repo = DriftMealLogRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('saves food log entry, enqueues outbox mutation, and aggregates daily totals', () async {
      final today = DateTime.now();

      final breakfast = FoodLogEntry(
        id: 'log_bf',
        userId: 'u1',
        loggedAt: today,
        mealSlot: MealSlot.breakfast,
        foodName: 'Poha with Sev',
        portionQuantity: 1.0,
        portionUnit: PortionUnit.mediumKatori,
        calories: 270.0,
        proteinGrams: 5.0,
        carbsGrams: 48.0,
        fatGrams: 6.8,
        fiberGrams: 3.2,
      );

      final lunch = FoodLogEntry(
        id: 'log_lunch',
        userId: 'u1',
        loggedAt: today,
        mealSlot: MealSlot.lunch,
        foodName: 'Toor Dal Tadka + 2 Rotis',
        portionQuantity: 1.0,
        portionUnit: PortionUnit.serving,
        calories: 422.0,
        proteinGrams: 18.8,
        carbsGrams: 69.5,
        fatGrams: 8.1,
        fiberGrams: 10.5,
      );

      await repo.saveLocal(breakfast);
      await repo.saveLocal(lunch);

      final entriesResult = await repo.getForDay('u1', today);
      expect(entriesResult.isSuccess, isTrue);
      expect(entriesResult.dataOrNull?.length, equals(2));

      final totalsResult = await repo.getDailyMacroTotals('u1', today);
      expect(totalsResult.isSuccess, isTrue);
      final totals = totalsResult.dataOrNull!;
      expect(totals.calories, equals(692.0)); // 270 + 422
      expect(totals.proteinGrams, equals(23.8)); // 5.0 + 18.8

      final queued = await outbox.fetchPending(limit: 5);
      expect(queued.any((m) => m.id == 'mut_meal_log_bf'), isTrue);
      expect(queued.any((m) => m.id == 'mut_meal_log_lunch'), isTrue);
    });

    test('saves and retrieves family recipes', () async {
      final recipe = FamilyRecipe(
        id: 'fam_rec_1',
        userId: 'u1',
        name: 'Rajma Masala Pot',
        totalYieldGramsOrKatoris: 5.0,
        createdAt: DateTime.now(),
        ingredients: const [
          RecipeIngredient(
            foodName: 'Boiled Rajma',
            quantity: 300.0,
            unit: PortionUnit.gram,
            nutrition: NutritionValues(
              calories: 390.0,
              proteinGrams: 24.0,
              carbsGrams: 66.0,
              fatGrams: 1.5,
              fiberGrams: 18.0,
            ),
          ),
        ],
      );

      final saveRes = await repo.saveRecipe(recipe);
      expect(saveRes.isSuccess, isTrue);

      final listRes = await repo.getAllRecipes('u1');
      expect(listRes.isSuccess, isTrue);
      expect(listRes.dataOrNull?.length, equals(1));
      expect(listRes.dataOrNull?.first.name, equals('Rajma Masala Pot'));
    });
  });
}
