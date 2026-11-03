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

void main() {
  group('WhatsApp AI Logging & Sync Integration Tests', () {
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

    Widget createScreen({String userId = 'user_whatsapp_test'}) {
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

    testWidgets('renders WhatsApp AI Logger active banner and info dialog', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify WhatsApp AI Logger banner is present with Active badge
      expect(find.text('WhatsApp AI Logger'), findsOneWidget);
      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Send voice notes or text in Hindi/English to log in 5s.'), findsOneWidget);

      // Tap Info button
      final infoBtn = find.text('Info');
      expect(infoBtn, findsOneWidget);
      await tester.tap(infoBtn);
      await tester.pumpAndSettle();

      // Verify Dialog opens with DPDP Act 2023 compliance explanation
      expect(find.text('WhatsApp AI Logging'), findsWidgets);
      expect(find.textContaining('DPDP Act 2023 compliant'), findsOneWidget);
      expect(find.textContaining('Tap "Confirm & Log"'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text('Got it'), findsNothing);
    });

    testWidgets('reflects meals committed via WhatsApp webhook in Drift and updates dashboard totals', (tester) async {
      const testUserId = 'user_whatsapp_test';
      final now = DateTime.now();

      // Simulate Drift storage reflecting a meal committed via WhatsApp interactive button
      // (as inserted into public.food_logs by WhatsAppCommitHandler)
      await mealRepo.saveLocal(FoodLogEntry(
        id: 'wa_meal_roti',
        userId: testUserId,
        loggedAt: now,
        mealSlot: MealSlot.dinner,
        foodName: 'Roti (Chapati)',
        portionQuantity: 2.0,
        portionUnit: PortionUnit.piece,
        calories: 208.0,
        proteinGrams: 6.2,
        carbsGrams: 35.0,
        fatGrams: 0.8,
        fiberGrams: 5.0,
      ));

      await mealRepo.saveLocal(FoodLogEntry(
        id: 'wa_meal_dal',
        userId: testUserId,
        loggedAt: now,
        mealSlot: MealSlot.dinner,
        foodName: 'Dal Tadka',
        portionQuantity: 1.0,
        portionUnit: PortionUnit.mediumKatori,
        calories: 140.0,
        proteinGrams: 7.2,
        carbsGrams: 18.0,
        fatGrams: 4.5,
        fiberGrams: 4.0,
      ));

      await tester.pumpWidget(createScreen(userId: testUserId));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Total calories: 208 + 140 = 348 kcal
      expect(find.text('348'), findsOneWidget);
      expect(find.text('/ 2000 kcal'), findsOneWidget);

      // Dinner slot shows the WhatsApp committed dishes
      expect(find.text('Dinner'), findsOneWidget);
      expect(find.text('Roti (Chapati)'), findsOneWidget);
      expect(find.text('Dal Tadka'), findsOneWidget);

      // Verify repository totals match
      final totals = await mealRepo.getDailyMacroTotals(testUserId, now);
      totals.when(
        onSuccess: (val) {
          expect(val.calories, closeTo(348.0, 0.1));
          expect(val.proteinGrams, closeTo(13.4, 0.1));
          expect(val.carbsGrams, closeTo(53.0, 0.1));
          expect(val.fatGrams, closeTo(5.3, 0.1));
        },
        onFailure: (f) => fail('Failed to fetch totals: $f'),
      );
    });
  });
}

