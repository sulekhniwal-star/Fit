import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/core/sync/sync_coordinator.dart';
import 'package:fitkarma/features/health/data/drift_body_metrics_repository.dart';
import 'package:fitkarma/features/health/data/drift_health_repositories.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/health/domain/body_metric.dart';
import 'package:fitkarma/features/health/domain/habit_entry.dart';
import 'package:fitkarma/features/health/domain/health_primitives.dart';
import 'package:fitkarma/features/health/domain/medication_entry.dart';
import 'package:fitkarma/features/health/domain/step_record.dart';
import 'package:fitkarma/features/health/domain/vital_record.dart';
import 'package:fitkarma/features/health/presentation/health_dashboard_screen.dart';
import 'package:fitkarma/features/health/presentation/weight_logger_sheet.dart';

void main() {
  group('HealthDashboardScreen Widget Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftBodyMetricsRepository bodyMetricsRepo;
    late DriftStepRepository stepRepo;
    late DriftSleepRepository sleepRepo;
    late DriftWaterRepository waterRepo;
    late DriftMoodRepository moodRepo;
    late DriftVitalsRepository vitalsRepo;
    late DriftMedicationRepository medRepo;
    late DriftHabitsRepository habitsRepo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      bodyMetricsRepo = DriftBodyMetricsRepository(db, outbox);
      stepRepo = DriftStepRepository(db, outbox);
      sleepRepo = DriftSleepRepository(db, outbox);
      waterRepo = DriftWaterRepository(db, outbox);
      moodRepo = DriftMoodRepository(db, outbox);
      vitalsRepo = DriftVitalsRepository(db, outbox);
      medRepo = DriftMedicationRepository(db, outbox);
      habitsRepo = DriftHabitsRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    Widget createScreen({String userId = 'test_user'}) {
      return ProviderScope(
        overrides: [
          appDatabaseProvider.overrideWithValue(db),
          outboxQueueProvider.overrideWithValue(outbox),
          bodyMetricsRepositoryProvider.overrideWithValue(bodyMetricsRepo),
          stepRepositoryProvider.overrideWithValue(stepRepo),
          sleepRepositoryProvider.overrideWithValue(sleepRepo),
          waterRepositoryProvider.overrideWithValue(waterRepo),
          moodRepositoryProvider.overrideWithValue(moodRepo),
          vitalsRepositoryProvider.overrideWithValue(vitalsRepo),
          medicationRepositoryProvider.overrideWithValue(medRepo),
          habitsRepositoryProvider.overrideWithValue(habitsRepo),
        ],
        child: MaterialApp(
          home: HealthDashboardScreen(userId: userId),
        ),
      );
    }

    testWidgets('renders all core dashboard sections and disclaimer', (tester) async {
      final now = DateTime.now();

      // Seed initial data
      await bodyMetricsRepo.saveLocal(BodyMetricEntry(
        id: 'w1',
        userId: 'test_user',
        metricType: BodyMetricType.weight,
        value: 72.5,
        unit: HealthUnit.kg,
        recordedAt: now,
      ));

      await stepRepo.saveLocal(StepRecord(
        id: 's1',
        userId: 'test_user',
        date: now,
        stepCount: 8450,
      ));

      await vitalsRepo.saveLocal(VitalRecord(
        id: 'v1',
        userId: 'test_user',
        recordedAt: now,
        vitalType: VitalType.bloodPressure,
        systolic: 120,
        diastolic: 80,
      ));

      await medRepo.saveLocal(MedicationEntry(
        id: 'm1',
        userId: 'test_user',
        name: 'Ashwagandha',
        dosage: '250mg',
        timeOfDay: MedicationTimeOfDay.night,
        scheduledDate: now,
      ));

      await habitsRepo.saveLocal(const HabitEntry(
        id: 'h1',
        userId: 'test_user',
        title: 'Morning Surya Namaskar',
        currentStreak: 5,
        bestStreak: 10,
      ));

      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Header
      expect(find.text('FitKarma'), findsOneWidget);
      expect(find.text('Namaste'), findsOneWidget);

      // Metrics
      expect(find.text('72.5'), findsOneWidget);
      expect(find.text('8450'), findsOneWidget);
      expect(find.text('Log Weight'), findsOneWidget);

      // Quick log cards
      expect(find.text('Hydration'), findsOneWidget);
      expect(find.text('Daily Mood'), findsOneWidget);

      // Vitals & Meds & Habits
      expect(find.text('120/80'), findsOneWidget);
      expect(find.text('Ashwagandha (250mg)'), findsOneWidget);
      expect(find.text('Morning Surya Namaskar'), findsOneWidget);
      expect(find.text('🔥 5d streak'), findsOneWidget);

      // Non-medical disclaimer
      expect(find.text(VitalRecord.nonMedicalDisclaimer), findsOneWidget);
    });

    testWidgets('tapping Log Weight opens WeightLoggerSheet bottom sheet', (tester) async {
      await tester.pumpWidget(createScreen());
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final logWeightBtn = find.text('Log Weight');
      expect(logWeightBtn, findsOneWidget);

      await tester.tap(logWeightBtn);
      await tester.pumpAndSettle();

      expect(find.byType(WeightLoggerSheet), findsOneWidget);
      expect(find.text('Log Body Weight'), findsOneWidget);
    });
  });
}
