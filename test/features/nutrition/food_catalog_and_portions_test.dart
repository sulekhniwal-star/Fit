import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/nutrition/data/drift_food_catalog_repository.dart';
import 'package:fitkarma/features/nutrition/data/food_catalog_seed.dart';
import 'package:fitkarma/features/nutrition/domain/food_item.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';

void main() {
  group('Indian Portion Unit & PortionCalculator Tests', () {
    const phulka = FoodItem(
      id: 'f_roti',
      name: 'Phulka Roti',
      hindiName: 'फुल्का',
      category: FoodCategory.rotiBreads,
      caloriesPer100g: 265.0,
      proteinPer100g: 9.0,
      carbsPer100g: 55.0,
      fatPer100g: 2.5,
      defaultPortionUnit: PortionUnit.roti,
      basePortionGrams: 40.0,
    );

    const dal = FoodItem(
      id: 'f_dal',
      name: 'Toor Dal Tadka',
      hindiName: 'तूर दाल',
      category: FoodCategory.dalsPulses,
      caloriesPer100g: 105.0,
      proteinPer100g: 5.8,
      carbsPer100g: 14.5,
      fatPer100g: 2.8,
      defaultPortionUnit: PortionUnit.mediumKatori,
      basePortionGrams: 200.0,
    );

    const rice = FoodItem(
      id: 'f_rice',
      name: 'Steamed Rice',
      hindiName: 'चावल',
      category: FoodCategory.riceGrains,
      caloriesPer100g: 130.0,
      proteinPer100g: 2.7,
      carbsPer100g: 28.0,
      fatPer100g: 0.3,
      defaultPortionUnit: PortionUnit.mediumKatori,
      basePortionGrams: 160.0,
    );

    const chaas = FoodItem(
      id: 'f_chaas',
      name: 'Salted Chaas',
      hindiName: 'छाछ',
      category: FoodCategory.dairyBeverages,
      caloriesPer100g: 30.0,
      proteinPer100g: 1.5,
      carbsPer100g: 2.2,
      fatPer100g: 1.6,
      defaultPortionUnit: PortionUnit.glass,
      basePortionGrams: 250.0,
    );

    test('calculates roti count to grams and accurate calories', () {
      final gramsFor2Rotis = PortionCalculator.calculateGrams(phulka, PortionUnit.roti, 2.0);
      expect(gramsFor2Rotis, equals(80.0));

      final nutrition = phulka.calculateForPortion(PortionUnit.roti, 2.0);
      expect(nutrition.calories, equals(212.0)); // 265 * 0.8 = 212
      expect(nutrition.proteinGrams, equals(7.2)); // 9 * 0.8 = 7.2
    });

    test('calculates katori densities across dal vs rice correctly', () {
      // 1 medium katori (200ml) of dal (~1.05 density -> 210g)
      final dalGrams = PortionCalculator.calculateGrams(dal, PortionUnit.mediumKatori, 1.0);
      expect(dalGrams, equals(210.0));

      // 1 medium katori (200ml) of cooked rice (~0.80 density -> 160g)
      final riceGrams = PortionCalculator.calculateGrams(rice, PortionUnit.mediumKatori, 1.0);
      expect(riceGrams, equals(160.0));

      // Small katori (150ml) of dal (150 * 1.05 = 157.5g)
      final smallDalGrams = PortionCalculator.calculateGrams(dal, PortionUnit.smallKatori, 1.0);
      expect(smallDalGrams, equals(157.5));
    });

    test('calculates glass portions for chaas/buttermilk', () {
      final glassGrams = PortionCalculator.calculateGrams(chaas, PortionUnit.glass, 1.0);
      expect(glassGrams, closeTo(252.5, 0.5));

      final nutrition = chaas.calculateForPortion(PortionUnit.glass, 1.0);
      expect(nutrition.calories, closeTo(75.8, 1.0));
    });

    test('returns zero for non-positive portion quantities', () {
      expect(PortionCalculator.calculateGrams(phulka, PortionUnit.roti, 0), equals(0.0));
      expect(PortionCalculator.calculateGrams(phulka, PortionUnit.roti, -2), equals(0.0));

      final zeroNutrition = phulka.calculateForPortion(PortionUnit.roti, -1);
      expect(zeroNutrition.calories, equals(0.0));
    });
  });

  group('FoodItem Model Tests', () {
    test('validates acceptable macro limits', () {
      const valid = FoodItem(
        id: 'v1',
        name: 'Idli',
        hindiName: 'इडली',
        category: FoodCategory.southIndian,
        caloriesPer100g: 135.0,
        proteinPer100g: 4.5,
        carbsPer100g: 28.0,
        fatPer100g: 0.5,
      );
      expect(valid.isValid, isTrue);

      const invalidCal = FoodItem(
        id: 'i1',
        name: 'Bad',
        hindiName: 'खराब',
        category: FoodCategory.snacksStreetFood,
        caloriesPer100g: -50.0,
        proteinPer100g: 2.0,
        carbsPer100g: 10.0,
        fatPer100g: 1.0,
      );
      expect(invalidCal.isValid, isFalse);
    });

    test('serializes and deserializes accurately with json', () {
      final item = FoodCatalogSeed.curatedItems.first;
      final json = item.toJson();
      final revived = FoodItem.fromJson(json);

      expect(revived.id, equals(item.id));
      expect(revived.name, equals(item.name));
      expect(revived.hindiName, equals(item.hindiName));
      expect(revived.caloriesPer100g, equals(item.caloriesPer100g));
      expect(revived.category, equals(item.category));
    });
  });

  group('DriftFoodCatalogRepository Integration Tests', () {
    late AppDatabase db;
    late DriftFoodCatalogRepository repo;

    setUp(() {
      db = AppDatabase.memory();
      repo = DriftFoodCatalogRepository(db);
    });

    tearDown(() async {
      await db.close();
    });

    test('seeds 500+ Indian regional dishes into local database', () async {
      await repo.ensureSeeded();
      final count = await repo.getItemCount();
      expect(count, greaterThanOrEqualTo(500));
    });

    test('searches dishes using English and Hindi terms', () async {
      final dalResults = await repo.search('dal');
      expect(dalResults.isSuccess, isTrue);
      expect(dalResults.dataOrNull!.isNotEmpty, isTrue);

      final hindiResults = await repo.search('फुल्का');
      expect(hindiResults.isSuccess, isTrue);
      expect(hindiResults.dataOrNull!.any((i) => i.id == 'food_roti_phulka'), isTrue);
    });

    test('filters search results by category', () async {
      final southIndian = await repo.search('', category: FoodCategory.southIndian);
      expect(southIndian.isSuccess, isTrue);
      expect(southIndian.dataOrNull!.every((i) => i.category == FoodCategory.southIndian), isTrue);
    });

    test('retrieves single food item by id', () async {
      final res = await repo.getById('food_paneer_raw');
      expect(res.isSuccess, isTrue);
      expect(res.dataOrNull?.name, contains('Paneer'));
      expect(res.dataOrNull?.proteinPer100g, equals(18.5));
    });
  });
}

