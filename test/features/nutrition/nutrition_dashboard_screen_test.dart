import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/features/nutrition/data/drift_meal_log_repository.dart';
import 'package:fitkarma/features/nutrition/domain/food_log_entry.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';
import 'package:fitkarma/features/nutrition/presentation/nutrition_dashboard_screen.dart';
import 'package:fitkarma/features/nutrition/presentation/recipe_splitter_sheet.dart';

void main() {
  group('NutritionDashboardScreen Widget Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftMealLogRepository mealRepo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      mealRepo = DriftMealLogRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    Widget createScreen({String userId = 'test_user'}) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          outboxQueueProvider.overrideWithValue(outbox),
          mealLogRepositoryProvider.overrideWithValue(mealRepo),
        ],
        child: MaterialApp(
          home: NutritionDashboardScreen(userId: userId),
        ),
      );
    }

    testWidgets('renders all nutrition dashboard sections and meal slots', (tester) async {
      final now = DateTime.now();

      // Seed initial breakfast item
      await mealRepo.saveLocal(FoodLogEntry(
        id: 'meal_1',
        userId: 'test_user',
        loggedAt: now,
        mealSlot: MealSlot.breakfast,
        foodName: 'Poha with Sev',
        portionQuantity: 1.0,
        portionUnit: PortionUnit.mediumKatori,
        calories: 270.0,
        proteinGrams: 5.0,
        carbsGrams: 48.0,
        fatGrams: 6.8,
        fiberGrams: 3.2,
      ));

      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header
      expect(find.text('FitKarma Nutrition'), findsOneWidget);

      // Macro Goal Card
      expect(find.text('Daily Energy & Macros'), findsOneWidget);
      expect(find.text('270'), findsOneWidget);
      expect(find.text('/ 2000 kcal'), findsOneWidget);

      // Dynamic TDEE
      expect(find.text('Dynamic TDEE'), findsOneWidget);
      expect(find.text('Energy Balance'), findsOneWidget);

      // Meal Slots
      expect(find.text('Breakfast'), findsOneWidget);
      expect(find.text('Poha with Sev'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Snacks & Evening'), findsOneWidget);

      // Family Recipe Splitter Card
      expect(find.text('Family Recipe Splitter'), findsOneWidget);
      expect(find.text('Split Pot'), findsOneWidget);
    });

    testWidgets('tapping Split Pot opens RecipeSplitterSheet and logs split portion', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final splitPotBtn = find.text('Split Pot');
      expect(splitPotBtn, findsOneWidget);

      await tester.ensureVisible(splitPotBtn);
      await tester.tap(splitPotBtn);
      await tester.pumpAndSettle();

      expect(find.byType(RecipeSplitterSheet), findsOneWidget);
      expect(find.text('How much of the pot did you eat?'), findsOneWidget);

      // Tap 50% chip
      final chip50 = find.text('50% pot');
      expect(chip50, findsOneWidget);
      await tester.tap(chip50);
      await tester.pumpAndSettle();

      // Tap Log Split Portion
      final logBtn = find.text('Log Split Portion');
      expect(logBtn, findsOneWidget);
      await tester.tap(logBtn);
      await tester.pumpAndSettle();

      // Sheet dismissed and dashboard updated
      expect(find.byType(RecipeSplitterSheet), findsNothing);
      expect(find.textContaining('50% pot'), findsOneWidget);
    });
  });
}

