import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/features/brain/data/dip_repository.dart';
import 'package:fitkarma/features/brain/domain/dip_models.dart';
import 'package:fitkarma/features/brain/presentation/home_dashboard_screen.dart';

void main() {
  group('HomeDashboardScreen Widget & Scenario Tests', () {
    late AppDatabase db;
    final now = DateTime(2026, 11, 3, 10, 0);

    setUp(() {
      db = AppDatabase.memory();
    });

    tearDown(() async {
      await db.close();
    });

    Widget createTestApp(DailyIntelligencePackage dip) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          dailyIntelligencePackageProvider.overrideWith((ref) async => dip),
        ],
        child: const MaterialApp(
          home: HomeDashboardScreen(initialUserId: 'test_widget_user'),
        ),
      );
    }

    testWidgets('Scenario 1: Morning Boot renders greeting, Peak readiness card, priorities and quick log bar',
        (tester) async {
      final dip = DailyIntelligencePackage(
        date: now,
        readinessScore: DailyReadinessScore(
          score: 88,
          tier: ReadinessTier.peak,
          headline: 'Peak Recovery State',
          explanation: 'Your body is fully restored and primed for high intensity.',
          factors: const [
            ReadinessFactor(
              name: 'Sleep',
              score: 95,
              weight: 0.35,
              summary: '8.0 hrs recorded',
            ),
            ReadinessFactor(
              name: 'Vitals (RHR)',
              score: 90,
              weight: 0.25,
              summary: '60 bpm resting HR',
            ),
          ],
          statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
          calculatedAt: now,
        ),
        primaryFocus: const DipFocusSignal(
          title: 'Prime Progressive Overload Day',
          subtitle: 'Push compound lifts today',
          badge: 'HIGH READINESS',
        ),
        topActions: const [
          DipMicroAction(
            id: 'action_cold_start',
            title: 'Morning Check-In & Hydration',
            description: 'Start your morning with a glass of water.',
            category: DipActionCategory.mindset,
            priority: 85.0,
            actionLabel: 'Log First Habit',
            actionRoute: '/dashboard',
          ),
        ],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 1200,
          consumedCalories: 350.0,
          consumedWaterMl: 500,
        ),
      );

      await tester.pumpWidget(createTestApp(dip));
      await tester.pumpAndSettle();

      expect(find.textContaining('Namaste'), findsOneWidget);
      expect(find.text('DAILY READINESS'), findsOneWidget);
      expect(find.text('PEAK'), findsOneWidget);
      expect(find.text('88'), findsOneWidget);
      expect(find.text('Peak Recovery State'), findsOneWidget);
      expect(find.text('TODAY\'S PRIORITIES'), findsOneWidget);
      expect(find.text('Morning Check-In & Hydration'), findsOneWidget);
      expect(find.text('QUICK LOGGING'), findsOneWidget);
      expect(find.text('+250ml'), findsOneWidget);
      expect(find.text('Steps'), findsOneWidget);
      expect(find.text('Calories'), findsOneWidget);
    });

    testWidgets('Scenario 2: Post-Meal Afternoon renders Shatapawali walk recommendation and cultural tag',
        (tester) async {
      final dip = DailyIntelligencePackage(
        date: now,
        readinessScore: DailyReadinessScore(
          score: 75,
          tier: ReadinessTier.optimal,
          headline: 'Balanced Readiness',
          explanation: 'Good recovery state.',
          factors: const [],
          statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
          calculatedAt: now,
        ),
        primaryFocus: const DipFocusSignal(
          title: 'Post-Meal Digestive Stroll',
          subtitle: 'A short walk balances blood sugar',
          badge: 'MOVEMENT',
        ),
        topActions: const [
          DipMicroAction(
            id: 'action_shatapawali',
            title: 'Take a 10-Minute Shatapawali Walk',
            description: 'A gentle 100-step stroll after your meal aids digestion.',
            category: DipActionCategory.movement,
            priority: 80.0,
            actionLabel: 'Start Walk',
            actionRoute: '/workouts',
            culturalContext: 'Indian Shatapawali post-meal strolling tradition',
          ),
        ],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 3400,
          consumedCalories: 720.0,
          consumedWaterMl: 1000,
        ),
      );

      await tester.pumpWidget(createTestApp(dip));
      await tester.pumpAndSettle();

      expect(find.text('Take a 10-Minute Shatapawali Walk'), findsOneWidget);
      expect(find.text('Traditional'), findsOneWidget);
      expect(find.text('Start Walk'), findsOneWidget);
    });

    testWidgets('Scenario 3: High Fatigue / Strain renders Recovery Mode banner and restorative advice',
        (tester) async {
      final dip = DailyIntelligencePackage(
        date: now,
        readinessScore: DailyReadinessScore(
          score: 42,
          tier: ReadinessTier.recovery,
          headline: 'Recovery Priority',
          explanation: 'Significant accumulated strain detected.',
          factors: const [],
          statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
          calculatedAt: now,
        ),
        primaryFocus: const DipFocusSignal(
          title: 'Focus on Recovery',
          subtitle: 'Muscular restoration & sleep hygiene are your priorities today.',
          badge: 'RECOVERY MODE',
        ),
        topActions: const [
          DipMicroAction(
            id: 'action_high_fatigue_recovery',
            title: 'Active Recovery & Gentle Asana',
            description: 'Favor mobility drills and gentle stretching.',
            category: DipActionCategory.recovery,
            priority: 92.0,
            actionLabel: 'Rest & Stretch',
            actionRoute: '/workouts',
          ),
        ],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 2100,
          consumedCalories: 1400.0,
          consumedWaterMl: 1200,
        ),
      );

      await tester.pumpWidget(createTestApp(dip));
      await tester.pumpAndSettle();

      expect(find.text('RECOVERY'), findsNWidgets(2));
      expect(find.text('42'), findsOneWidget);
      expect(find.text('Active Recovery & Gentle Asana'), findsOneWidget);
      expect(find.text('Rest & Stretch'), findsOneWidget);
    });

    testWidgets('Scenario 4: Dismissing an action removes it from the active priority list',
        (tester) async {
      final dip = DailyIntelligencePackage(
        date: now,
        readinessScore: DailyReadinessScore(
          score: 80,
          tier: ReadinessTier.optimal,
          headline: 'Balanced Readiness',
          explanation: 'Good recovery state.',
          factors: const [],
          statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
          calculatedAt: now,
        ),
        primaryFocus: const DipFocusSignal(
          title: 'Hydration Target',
          subtitle: 'Keep hydrating',
          badge: 'HYDRATION',
        ),
        topActions: const [
          DipMicroAction(
            id: 'action_dismiss_test',
            title: 'Drink 500ml Water Now',
            description: 'Mid-day hydration boost.',
            category: DipActionCategory.hydration,
            priority: 75.0,
            actionLabel: 'Drink',
            isDismissible: true,
          ),
        ],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 4000,
          consumedCalories: 600.0,
          consumedWaterMl: 800,
        ),
      );

      await tester.pumpWidget(createTestApp(dip));
      await tester.pumpAndSettle();

      expect(find.text('Drink 500ml Water Now'), findsOneWidget);

      // Tap dismiss icon
      await tester.tap(find.byKey(const Key('dismiss_action_dismiss_test')));
      await tester.pumpAndSettle();

      expect(find.text('Drink 500ml Water Now'), findsNothing);
    });

    testWidgets('Scenario 5: Tapping +250ml Water on QuickLogActionBar adds entry and shows SnackBar',
        (tester) async {
      final dip = DailyIntelligencePackage(
        date: now,
        readinessScore: DailyReadinessScore(
          score: 80,
          tier: ReadinessTier.optimal,
          headline: 'Balanced Readiness',
          explanation: 'Good recovery state.',
          factors: const [],
          statutoryDisclaimer: DailyReadinessScore.defaultDisclaimer,
          calculatedAt: now,
        ),
        primaryFocus: const DipFocusSignal(
          title: 'Stay Active',
          subtitle: 'Keep going',
          badge: 'MOVEMENT',
        ),
        topActions: const [],
        summaryMetrics: const DipSummaryMetrics(
          todaySteps: 3000,
          consumedCalories: 500.0,
          consumedWaterMl: 600,
        ),
      );

      await tester.pumpWidget(createTestApp(dip));
      await tester.pumpAndSettle();

      // Tap quick water button
      await tester.tap(find.byKey(const Key('quick_log_water_btn')));
      await tester.pump(); // Start SnackBar animation

      expect(find.text('Added 250ml water'), findsOneWidget);
    });
  });
}
