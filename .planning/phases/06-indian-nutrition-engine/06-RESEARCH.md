# Phase 6 Research: Indian Nutrition Engine

## 1. Technical Architecture & Data Strategy

### 1.1 Indian Food Catalog Seed & Storage
- **Requirement**: NUTR-01 (500+ Indian regional food items)
- **Data Source Priority**: Official ICMR-NIN (Indian Council of Medical Research / National Institute of Nutrition) standard nutritional values per 100g raw/cooked.
- **Drift Representation**:
  - `FoodCatalogEntriesTable`: `id`, `name`, `hindi_name`, `category`, `calories_per_100g`, `protein_per_100g`, `carbs_per_100g`, `fat_per_100g`, `fiber_per_100g`, `is_vegetarian`, `is_egg`, `is_vegan`, `cuisine_region`, `provenance`, `is_system`.
  - Stored inside SQLCipher-encrypted SQLite, loaded at first boot via seed asset/builder, queried via fast indexing on name and category.

### 1.2 Indian Household Portion Sizing Math
- **Standard Densities & Volumes**:
  - 1 Standard Katori (Medium) = ~200 ml volume
    - Dal/Sambar density ~1.05 g/ml -> ~210g
    - Sabzi with gravy ~1.0 g/ml -> ~200g
    - Dry sabzi ~0.85 g/ml -> ~170g
    - Steamed Rice ~0.8 g/ml -> ~160g cooked (~55g raw equivalent)
    - Curd/Raita ~1.02 g/ml -> ~204g
  - 1 Small Katori = ~150 ml (0.75x medium)
  - 1 Large Katori = ~250 ml (1.25x medium)
  - 1 Glass = ~250 ml (Chaach/Buttermilk ~250g, Lassi ~280g, Chai/Coffee ~150-200ml)
  - 1 Standard Roti (6-inch whole wheat phulka, ~30g raw atta) = ~100 kcal, 3g protein, 20g carbs, 0.5g fat (without ghee).
  - 1 Idli (~40g) = ~50 kcal, 2g protein, 10g carbs, 0.2g fat.

### 1.3 Raw vs. Cooked Yield Multipliers
- **Mathematical Relationship**:
  $$\text{Cooked Weight} = \text{Raw Weight} \times \text{Yield Factor}$$
  $$\text{Nutritional Density per 100g Cooked} = \frac{\text{Nutritional Density per 100g Raw}}{\text{Yield Factor}}$$
- **Yield Multiplier Benchmarks**:
  - Raw Basmati / Sona Masoori Rice: Yield Factor ~2.80 (100g raw -> 280g cooked)
  - Raw Yellow Moong / Toor Dal: Yield Factor ~3.00 (100g raw -> 300g cooked dal)
  - Raw Rajma / Chole: Yield Factor ~2.40 (100g raw soaked & boiled -> 240g cooked)
  - Raw Chicken Breast: Yield Factor ~0.75 (100g raw -> 75g cooked)
  - Raw Paneer: Yield Factor ~1.00 (negligible moisture loss)
  - Raw Leafy Greens (Palak): Yield Factor ~0.50 (100g raw -> 50g cooked)

### 1.4 Tadka / Tempering Fat Calculator
- Indian cooking fat sources:
  - Vegetable Oil / Mustard Oil / Peanut Oil: 1g fat = 9 kcal (1 tsp ~ 4.5g fat = ~40.5 kcal)
  - Pure Desi Ghee: 1g fat = 9 kcal (1 tsp ~ 5.0g fat = ~45 kcal)
  - Butter / Makhan: 1g butter = ~7.2 kcal (~81% fat)
- **Tadka Preset Levels**:
  - `None`: 0g extra fat, +0 kcal
  - `Low`: 1 tsp (~5g fat, ~45 kcal)
  - `Medium`: 2 tsp (~10g fat, ~90 kcal)
  - `High`: 1 tbsp (~15g fat, ~135 kcal)
- **User Disclosure**: Marked clearly as an *"Estimate"* to prevent false precision.

### 1.5 Family Recipe Splitter Algorithm
- **Inputs**:
  - List of ingredients with quantities and raw/cooked states
  - Total prepared batch yield $Y_{total}$ (in grams or total katoris)
  - Consumed fraction $F_{consumed} \in (0, 1.0]$ (e.g. 0.25 for 25% or $K_{eaten} / K_{total}$)
- **Formula**:
  $$\text{Meal Nutrients} = F_{consumed} \times \sum_{i} \text{Nutrient}(Ingredient_i)$$
- **Precision**: Deterministic decimal arithmetic with rounding to 1 decimal place.

### 1.6 Dynamic TDEE Engine
- Baseline BMR computed via revised Mifflin-St Jeor equation calibrated for Indian population:
  - Male: $10 \times \text{weight (kg)} + 6.25 \times \text{height (cm)} - 5 \times \text{age} + 5$
  - Female: $10 \times \text{weight (kg)} + 6.25 \times \text{height (cm)} - 5 \times \text{age} - 161$
- Adaptive adjustment over time:
  $$\Delta \text{Weight Weekly (kg)} \times 7700\text{ kcal} / 7 = \text{Daily Energy Surplus/Deficit}$$
  $$\text{Empirical TDEE} = \text{Average Daily Intake} - \text{Daily Energy Surplus/Deficit}$$
- Dampened exponential smoothing prevents erratic day-to-day jumps.

---

## 2. Threat Model (ASVS L1)
- **Sensitive Dietary Patterns**: Food logs can reflect fasting protocols (Navratri, Ramadan, Ekadashi), medical diets (diabetic, low-sodium), or cultural traditions. Must be encrypted at rest with SQLCipher.
- **Nutritional Claims**: Do not prescribe rigid medical diets; all goals are user-configurable with explicit disclaimers.

