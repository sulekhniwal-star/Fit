import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/features/ai/data/ai_gateway_client.dart';
import 'package:fitkarma/features/ai/domain/ai_meal_analyzer_service.dart';
import 'package:fitkarma/features/ai/domain/ai_models.dart';
import 'package:fitkarma/features/ai/domain/indian_food_matcher.dart';
import 'package:fitkarma/features/ai/presentation/ai_meal_confirmation_card.dart';
import 'package:fitkarma/features/ai/presentation/ai_meal_text_logger_sheet.dart';
import 'package:fitkarma/features/ai/presentation/photo_food_logger_screen.dart';
import 'package:fitkarma/features/nutrition/data/drift_food_catalog_repository.dart';
import 'package:fitkarma/features/nutrition/data/drift_meal_log_repository.dart';
import 'package:fitkarma/features/nutrition/domain/food_log_entry.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';

void main() {
  group('AI Meal Logging Presentation & UX Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftMealLogRepository mealRepo;
    late DriftFoodCatalogRepository catalogRepo;
    late IndianFoodMatcher foodMatcher;
    late MockAiGatewayClient mockGateway;
    late AiMealAnalyzerService analyzerService;

    setUp(() async {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      mealRepo = DriftMealLogRepository(db, outbox);
      catalogRepo = DriftFoodCatalogRepository(db);
      await catalogRepo.ensureSeeded();

      foodMatcher = IndianFoodMatcher(catalogRepo);
      mockGateway = MockAiGatewayClient();
      analyzerService = AiMealAnalyzerService(
        gatewayClient: mockGateway,
        foodMatcher: foodMatcher,
      );
    });

    tearDown(() async {
      await db.close();
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          outboxQueueProvider.overrideWithValue(outbox),
          mealLogRepositoryProvider.overrideWithValue(mealRepo),
          aiGatewayClientProvider.overrideWithValue(mockGateway),
          indianFoodMatcherProvider.overrideWithValue(foodMatcher),
          aiMealAnalyzerServiceProvider.overrideWithValue(analyzerService),
        ],
        child: MaterialApp(
          home: Scaffold(body: child),
        ),
      );
    }

    testWidgets('Scenario 1: Text Meal Analysis and Confirmation Flow', (tester) async {
      bool mealLoggedCallbackTriggered = false;

      await tester.pumpWidget(
        createTestApp(
          AiMealTextLoggerSheet(
            onMealLogged: () {
              mealLoggedCallbackTriggered = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify sheet elements
      expect(find.text('AI Meal Description'), findsOneWidget);
      expect(find.text('Analyze Meal'), findsOneWidget);
      expect(find.byType(TextField), findsOneWidget);

      // Enter meal text
      await tester.enterText(find.byType(TextField), '2 rotis and 1 bowl dal');
      await tester.pump();

      // Tap Analyze Meal
      await tester.tap(find.text('Analyze Meal'));
      await tester.pump(); // Start loading
      await tester.pumpAndSettle(); // Finish mock response & catalog normalization

      // Confirmation Card should now be visible
      expect(find.text('AI Meal Estimation'), findsOneWidget);
      expect(find.textContaining('Roti'), findsWidgets);
      expect(find.textContaining('Dal'), findsWidgets);
      expect(find.text('Confirm & Log Meal'), findsOneWidget);

      // Verify statutory disclaimer is present
      expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

      // Tap portion increment button on first candidate item (increase roti)
      final addIcons = find.byIcon(Icons.add_circle_outline_rounded);
      expect(addIcons, findsWidgets);
      await tester.tap(addIcons.first);
      await tester.pumpAndSettle();

      // Scroll to Confirm & Log Meal and tap
      final confirmBtn = find.text('Confirm & Log Meal');
      await tester.ensureVisible(confirmBtn);
      await tester.pumpAndSettle();
      await tester.tap(confirmBtn);
      await tester.pumpAndSettle();

      expect(mealLoggedCallbackTriggered, isTrue);

      // Verify meal entries were inserted into Drift database
      final todayLogs = await mealRepo.getForDay('user_default', DateTime.now());
      expect(todayLogs.isSuccess, isTrue);
      expect(todayLogs.dataOrNull!.length, greaterThanOrEqualTo(2));
      expect(
        todayLogs.dataOrNull!.any((log) => log.foodName.contains('Roti')),
        isTrue,
      );
    });

    testWidgets('Scenario 2: Photo Food Flow with DPDP Privacy Banner', (tester) async {
      await tester.pumpWidget(
        createTestApp(
          const PhotoFoodLoggerScreen(),
        ),
      );
      await tester.pumpAndSettle();

      // 1. Assert DPDP 2023 compliance notice is rendered prominently
      expect(find.textContaining('DPDP Act 2023 Compliant'), findsOneWidget);
      expect(find.textContaining('Zero permanent cloud image storage'), findsOneWidget);

      // 2. Select sample photo
      expect(find.text('Capture Thali'), findsOneWidget);
      await tester.tap(find.text('Capture Thali'));
      await tester.pumpAndSettle();

      expect(find.text('Standard Indian Thali'), findsOneWidget);
      expect(find.text('Analyze Photo with AI'), findsOneWidget);

      // 3. Analyze Photo
      await tester.tap(find.text('Analyze Photo with AI'));
      await tester.pump();
      await tester.pumpAndSettle();

      // 4. Assert candidate results render with confidence badges
      expect(find.text('AI Meal Estimation'), findsOneWidget);
      expect(find.text('Confirm & Log Meal'), findsOneWidget);

      // 5. Confirm meal
      final photoConfirmBtn = find.text('Confirm & Log Meal');
      await tester.ensureVisible(photoConfirmBtn);
      await tester.pumpAndSettle();
      await tester.tap(photoConfirmBtn);
      await tester.pumpAndSettle();

      // Verify records written to Drift
      final logs = await mealRepo.getForDay('user_default', DateTime.now());
      expect(logs.isSuccess, isTrue);
      expect(logs.dataOrNull!.isNotEmpty, isTrue);
    });

    testWidgets('Scenario 3: Manual Fallback invokes fallback callback', (tester) async {
      bool manualFallbackTriggered = false;

      const lowConfidenceResult = AiMealAnalysisResult(
        summary: 'Unknown Curry',
        candidateItems: [
          AiCandidateItem(
            foodName: 'Mystery Gravy',
            quantity: 1.0,
            unit: PortionUnit.mediumKatori,
            estimatedCalories: 200.0,
            proteinGrams: 5.0,
            carbsGrams: 20.0,
            fatGrams: 10.0,
            confidence: 0.40,
            isVerifiedInCatalog: false,
          ),
        ],
        totalCalories: 200.0,
        totalProtein: 5.0,
        totalCarbs: 20.0,
        totalFat: 10.0,
        overallConfidence: AiConfidenceLevel.low,
        uncertaintyReasons: ['Item could not be matched with high certainty'],
        coaching: AiHinglishInsight(
          headline: 'Needs Verification',
          hinglishText: 'Item catalog mein confirm karein.',
        ),
      );

      await tester.pumpWidget(
        createTestApp(
          AiMealConfirmationCard(
            initialResult: lowConfidenceResult,
            onManualFallback: () {
              manualFallbackTriggered = true;
            },
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify low confidence badge & uncertainty reason
      expect(find.text('Low Confidence (Verify Items)'), findsOneWidget);
      expect(find.textContaining('could not be matched'), findsOneWidget);

      // Tap Search Manually
      expect(find.text('Search Manually'), findsOneWidget);
      await tester.tap(find.text('Search Manually'));
      await tester.pumpAndSettle();

      expect(manualFallbackTriggered, isTrue);
    });

    testWidgets('Scenario 4: Statutory Non-Medical Disclaimer Guardrail Verification', (tester) async {
      const result = AiMealAnalysisResult(
        summary: 'Poha and Chai',
        candidateItems: [
          AiCandidateItem(
            foodName: 'Poha',
            quantity: 1.0,
            unit: PortionUnit.mediumKatori,
            estimatedCalories: 250.0,
            proteinGrams: 4.0,
            carbsGrams: 45.0,
            fatGrams: 6.0,
            confidence: 0.90,
          ),
        ],
        totalCalories: 250.0,
        totalProtein: 4.0,
        totalCarbs: 45.0,
        totalFat: 6.0,
        overallConfidence: AiConfidenceLevel.high,
        uncertaintyReasons: [],
        coaching: AiHinglishInsight(
          headline: 'Light Breakfast',
          hinglishText: 'Good energy start!',
        ),
        statutoryDisclaimer:
            'Nutritional values are approximate AI estimations, not clinical or medical advice.',
      );

      await tester.pumpWidget(
        createTestApp(
          const AiMealConfirmationCard(initialResult: result),
        ),
      );
      await tester.pumpAndSettle();

      // Statutory disclaimer must be rendered prominently
      expect(
        find.text('Nutritional values are approximate AI estimations, not clinical or medical advice.'),
        findsOneWidget,
      );
    });
  });
}
