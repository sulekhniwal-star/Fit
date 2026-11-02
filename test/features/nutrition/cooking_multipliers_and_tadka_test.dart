import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/nutrition/data/drift_cooking_repository.dart';
import 'package:fitkarma/features/nutrition/domain/cooking_multiplier.dart';
import 'package:fitkarma/features/nutrition/domain/food_item.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';
import 'package:fitkarma/features/nutrition/domain/tadka_model.dart';
import 'package:fitkarma/features/nutrition/presentation/tadka_slider_widget.dart';

void main() {
  group('Cooking Yield Multipliers Tests', () {
    test('CookingMultiplierEngine computes expansion and shrinkage weights', () {
      // Rice expansion (x2.8)
      final cookedRice = CookingMultiplierEngine.calculateCookedWeight(100.0, 2.8);
      expect(cookedRice, equals(280.0));

      final rawEquivalent = CookingMultiplierEngine.calculateRawWeight(280.0, 2.8);
      expect(rawEquivalent, equals(100.0));

      // Chicken shrinkage (x0.75)
      final cookedChicken = CookingMultiplierEngine.calculateCookedWeight(200.0, 0.75);
      expect(cookedChicken, equals(150.0));

      // Invalid / zero weights
      expect(CookingMultiplierEngine.calculateCookedWeight(0.0, 2.8), equals(0.0));
      expect(CookingMultiplierEngine.calculateRawWeight(-50.0, 2.8), equals(0.0));
    });

    test('CookingMultiplierEngine converts nutrient densities per 100g accurately', () {
      const rawRiceValues = NutritionValues(
        calories: 360.0,
        proteinGrams: 8.0,
        carbsGrams: 78.0,
        fatGrams: 0.6,
        fiberGrams: 1.2,
      );

      // Cooked rice density (diluted by water absorption x2.8)
      final cookedDensity = CookingMultiplierEngine.convertNutritionDensity(
        baseValues: rawRiceValues,
        sourceState: CookingState.raw,
        targetState: CookingState.cooked,
        yieldFactor: 2.8,
      );

      expect(cookedDensity.calories, closeTo(128.6, 0.5));
      expect(cookedDensity.proteinGrams, closeTo(2.9, 0.2));

      // Reversible conversion back to raw
      final rawRecomputed = CookingMultiplierEngine.convertNutritionDensity(
        baseValues: cookedDensity,
        sourceState: CookingState.cooked,
        targetState: CookingState.raw,
        yieldFactor: 2.8,
      );
      expect(rawRecomputed.calories, closeTo(360.0, 1.0));
    });

    test('DriftCookingRepository seeds and retrieves versioned multipliers', () async {
      final db = AppDatabase.memory();
      final repo = DriftCookingRepository(db);

      await repo.ensureSeeded();
      final all = await repo.getAllMultipliers();
      expect(all.isSuccess, isTrue);
      expect(all.dataOrNull!.length, greaterThanOrEqualTo(5));

      final riceMult = await repo.getMultiplier(FoodCategory.riceGrains);
      expect(riceMult.isSuccess, isTrue);
      expect(riceMult.dataOrNull?.yieldFactor, equals(2.8));

      final dalMult = await repo.getMultiplier(FoodCategory.dalsPulses);
      expect(dalMult.isSuccess, isTrue);
      expect(dalMult.dataOrNull?.yieldFactor, equals(3.0));

      // Unconfigured fallback
      final fallback = await repo.getMultiplier(FoodCategory.condimentsChutneys);
      expect(fallback.isSuccess, isTrue);
      expect(fallback.dataOrNull?.yieldFactor, equals(1.0));

      await db.close();
    });
  });

  group('Tadka / Tempering Fat Model Tests', () {
    test('calculates correct calories and grams across all levels for oil and ghee', () {
      const noneTadka = TadkaModel(level: TadkaLevel.none);
      expect(noneTadka.additionalFatGrams, equals(0.0));
      expect(noneTadka.additionalCalories, equals(0.0));

      const lowTadka = TadkaModel(level: TadkaLevel.low, fatSource: TadkaFatSource.oil);
      expect(lowTadka.additionalFatGrams, equals(5.0));
      expect(lowTadka.additionalCalories, equals(45.0));

      const mediumTadka = TadkaModel(level: TadkaLevel.medium, fatSource: TadkaFatSource.ghee);
      expect(mediumTadka.additionalFatGrams, equals(10.0));
      expect(mediumTadka.additionalCalories, equals(90.0));

      const highTadka = TadkaModel(level: TadkaLevel.high, fatSource: TadkaFatSource.oil);
      expect(highTadka.additionalFatGrams, equals(15.0));
      expect(highTadka.additionalCalories, equals(135.0));
    });

    test('calculates butter calorie density accurately', () {
      const butterTadka = TadkaModel(level: TadkaLevel.medium, fatSource: TadkaFatSource.butter);
      expect(butterTadka.additionalFatGrams, equals(10.0));
      expect(butterTadka.additionalCalories, equals(72.0)); // 10g * 7.2
    });

    test('contains estimate notice and serializes to JSON', () {
      expect(TadkaModel.estimateNotice, contains('estimated calculation'));

      const model = TadkaModel(level: TadkaLevel.medium, fatSource: TadkaFatSource.ghee);
      final json = model.toJson();
      expect(json['level'], equals('medium'));
      expect(json['fat_source'], equals('ghee'));
      expect(json['is_estimate'], isTrue);

      final revived = TadkaModel.fromJson(json);
      expect(revived.level, equals(TadkaLevel.medium));
      expect(revived.fatSource, equals(TadkaFatSource.ghee));
    });
  });

  group('TadkaSliderWidget Tests', () {
    testWidgets('renders initial state and updates on level tap', (tester) async {
      TadkaModel? changedModel;

      await tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: TadkaSliderWidget(
            initialTadka: const TadkaModel(level: TadkaLevel.none),
            onChanged: (val) => changedModel = val,
          ),
        ),
      ));

      expect(find.text('Tadka / Tempering Fat'), findsOneWidget);
      expect(find.text('Estimate'), findsOneWidget);
      expect(find.text('No added tempering fat'), findsOneWidget);

      // Tap Medium level
      final mediumBtn = find.byKey(const Key('tadka_level_medium'));
      expect(mediumBtn, findsOneWidget);

      await tester.tap(mediumBtn);
      await tester.pumpAndSettle();

      expect(changedModel, isNotNull);
      expect(changedModel!.level, equals(TadkaLevel.medium));
      expect(find.text('+90 kcal (+10g fat)'), findsOneWidget);
    });
  });
}
