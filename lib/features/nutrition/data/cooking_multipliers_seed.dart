import '../domain/cooking_multiplier.dart';
import '../domain/food_item.dart';

class CookingMultipliersSeed {
  const CookingMultipliersSeed();

  static List<CookingYieldMultiplier> get standardMultipliers => const [
        CookingYieldMultiplier(
          id: 'mult_rice_grains',
          foodCategory: FoodCategory.riceGrains,
          yieldFactor: 2.80, // 100g raw rice absorbs water -> ~280g cooked
          waterAbsorptionPct: 180.0,
          version: 1,
          notes: 'Standard Basmati / Sona Masoori boiled yield (ICMR-NIN benchmark)',
        ),
        CookingYieldMultiplier(
          id: 'mult_dals_pulses',
          foodCategory: FoodCategory.dalsPulses,
          yieldFactor: 3.00, // 100g dry dal -> ~300g cooked dal
          waterAbsorptionPct: 200.0,
          version: 1,
          notes: 'Yellow toor / moong / masoor dal standard pressure-cooked yield',
        ),
        CookingYieldMultiplier(
          id: 'mult_legumes_chana_rajma',
          foodCategory: FoodCategory.dalsPulses,
          yieldFactor: 2.40, // 100g soaked/boiled chickpeas/rajma -> ~240g
          waterAbsorptionPct: 140.0,
          version: 1,
          notes: 'Chickpea (Chole) & Kidney Bean (Rajma) soaked & boiled yield',
        ),
        CookingYieldMultiplier(
          id: 'mult_meat_poultry',
          foodCategory: FoodCategory.meatPoultrySeafood,
          yieldFactor: 0.75, // 100g raw chicken breast -> ~75g cooked (water loss)
          waterAbsorptionPct: -25.0,
          version: 1,
          notes: 'Moisture loss during grilling or pan cooking',
        ),
        CookingYieldMultiplier(
          id: 'mult_leafy_greens',
          foodCategory: FoodCategory.sabzisCurries,
          yieldFactor: 0.50, // 100g raw spinach -> ~50g wilted/cooked
          waterAbsorptionPct: -50.0,
          version: 1,
          notes: 'Leafy greens volume reduction and moisture evaporation',
        ),
        CookingYieldMultiplier(
          id: 'mult_fresh_paneer',
          foodCategory: FoodCategory.dairyBeverages,
          yieldFactor: 1.00, // 100g paneer -> ~100g cooked (negligible moisture loss)
          waterAbsorptionPct: 0.0,
          version: 1,
          notes: 'Fresh cottage cheese retains mass during light frying or simmering',
        ),
        CookingYieldMultiplier(
          id: 'mult_roti_breads',
          foodCategory: FoodCategory.rotiBreads,
          yieldFactor: 1.35, // 30g raw atta + 10g water -> ~40g cooked phulka
          waterAbsorptionPct: 35.0,
          version: 1,
          notes: 'Atta to dough to puffed phulka yield',
        ),
      ];
}

