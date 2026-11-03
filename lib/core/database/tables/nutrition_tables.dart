import 'package:drift/drift.dart';

class FoodCatalogEntriesTable extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  TextColumn get hindiName => text().withDefault(const Constant(''))();
  TextColumn get category => text()();
  RealColumn get caloriesPer100g => real()();
  RealColumn get proteinPer100g => real()();
  RealColumn get carbsPer100g => real()();
  RealColumn get fatPer100g => real()();
  RealColumn get fiberPer100g => real().withDefault(const Constant(0.0))();
  BoolColumn get isVegetarian => boolean().withDefault(const Constant(true))();
  BoolColumn get isEgg => boolean().withDefault(const Constant(false))();
  BoolColumn get isVegan => boolean().withDefault(const Constant(false))();
  TextColumn get cuisineRegion => text().withDefault(const Constant('Pan-Indian'))();
  TextColumn get defaultPortionUnit => text().withDefault(const Constant('mediumKatori'))();
  RealColumn get basePortionGrams => real().withDefault(const Constant(100.0))();
  TextColumn get provenance => text().withDefault(const Constant('ICMR-NIN 2024 / IFCT Standard'))();

  @override
  Set<Column> get primaryKey => {id};
}

class CookingMultipliersTable extends Table {
  TextColumn get id => text()();
  TextColumn get foodCategory => text()();
  RealColumn get yieldFactor => real()();
  RealColumn get waterAbsorptionPct => real().withDefault(const Constant(0.0))();
  IntColumn get version => integer().withDefault(const Constant(1))();
  TextColumn get notes => text().nullable()();

  @override
  Set<Column> get primaryKey => {id};
}

class MealLogsTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get loggedAt => dateTime()();
  TextColumn get mealSlot => text()(); // breakfast, lunch, dinner, snack
  TextColumn get foodName => text()();
  RealColumn get portionQuantity => real()();
  TextColumn get portionUnit => text()();
  TextColumn get cookingState => text().withDefault(const Constant('cooked'))();
  TextColumn get tadkaLevel => text().withDefault(const Constant('none'))();
  TextColumn get tadkaFatSource => text().withDefault(const Constant('oil'))();
  RealColumn get calories => real()();
  RealColumn get proteinGrams => real()();
  RealColumn get carbsGrams => real()();
  RealColumn get fatGrams => real()();
  RealColumn get fiberGrams => real().withDefault(const Constant(0.0))();

  @override
  Set<Column> get primaryKey => {id};
}

class RecipesTable extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  TextColumn get ingredientsJson => text()();
  RealColumn get totalYieldGramsOrKatoris => real()();
  RealColumn get totalCalories => real()();
  RealColumn get totalProtein => real()();
  RealColumn get totalCarbs => real()();
  RealColumn get totalFat => real()();
  RealColumn get totalFiber => real().withDefault(const Constant(0.0))();
  DateTimeColumn get createdAt => dateTime()();

  @override
  Set<Column> get primaryKey => {id};
}

