import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/sync/outbox_queue.dart';
import 'package:fitkarma/features/health/data/drift_vitals_repositories.dart';
import 'package:fitkarma/features/health/domain/habit_entry.dart';
import 'package:fitkarma/features/health/domain/medication_entry.dart';
import 'package:fitkarma/features/health/domain/vital_record.dart';

void main() {
  group('VitalRecord Domain Tests', () {
    test('validates acceptable physiological blood pressure limits', () {
      final validBp = VitalRecord(
        id: 'v1',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 120,
        diastolic: 80,
      );
      expect(validBp.isValid, isTrue);

      final invalidBpLow = VitalRecord(
        id: 'v2',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 40, // Below 60
        diastolic: 80,
      );
      expect(invalidBpLow.isValid, isFalse);

      final invalidBpHigh = VitalRecord(
        id: 'v3',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 270, // Above 260
        diastolic: 80,
      );
      expect(invalidBpHigh.isValid, isFalse);
    });

    test('validates blood glucose ranges and flags elevated readings', () {
      final normalFasting = VitalRecord(
        id: 'g1',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodGlucose,
        glucoseMgDl: 95.0,
        contextTag: 'fasting',
      );
      expect(normalFasting.isValid, isTrue);
      expect(normalFasting.isElevatedReading, isFalse);

      final highFasting = VitalRecord(
        id: 'g2',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodGlucose,
        glucoseMgDl: 130.0,
        contextTag: 'fasting',
      );
      expect(highFasting.isValid, isTrue);
      expect(highFasting.isElevatedReading, isTrue);

      final elevatedBp = VitalRecord(
        id: 'bp_elevated',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 140,
        diastolic: 90,
      );
      expect(elevatedBp.isElevatedReading, isTrue);
    });

    test('contains non-medical statutory disclaimer', () {
      expect(VitalRecord.nonMedicalDisclaimer, contains('not constitute medical diagnosis'));
      final record = VitalRecord(
        id: 'v_json',
        userId: 'u1',
        recordedAt: DateTime.parse('2026-11-03T10:00:00.000Z'),
        vitalType: VitalType.bloodPressure,
        systolic: 120,
        diastolic: 80,
      );
      final json = record.toJson();
      expect(json['disclaimer'], equals(VitalRecord.nonMedicalDisclaimer));
    });
  });

  group('MedicationEntry Domain Tests', () {
    test('updates adherence status cleanly via copyWith', () {
      final med = MedicationEntry(
        id: 'm1',
        userId: 'u1',
        name: 'Metformin',
        dosage: '500mg',
        timeOfDay: MedicationTimeOfDay.morning,
        scheduledDate: DateTime.now(),
      );
      expect(med.status, equals(MedicationStatus.scheduled));

      final takenMed = med.copyWith(status: MedicationStatus.taken);
      expect(takenMed.status, equals(MedicationStatus.taken));
      expect(takenMed.name, equals('Metformin'));

      final skippedMed = med.copyWith(status: MedicationStatus.skipped);
      expect(skippedMed.status, equals(MedicationStatus.skipped));
    });
  });

  group('HabitEntry Domain Tests', () {
    test('non-punitive streak tracking calculates consecutive days and resets cleanly', () {
      final day1 = DateTime(2026, 11, 1, 9, 0);
      final day2 = DateTime(2026, 11, 2, 8, 30);
      final day4 = DateTime(2026, 11, 4, 10, 0);

      var habit = const HabitEntry(
        id: 'h1',
        userId: 'u1',
        title: 'Morning Yoga',
      );

      // First check-in
      habit = habit.checkIn(day1);
      expect(habit.currentStreak, equals(1));
      expect(habit.bestStreak, equals(1));

      // Same day check-in does not change streak
      habit = habit.checkIn(DateTime(2026, 11, 1, 18, 0));
      expect(habit.currentStreak, equals(1));

      // Next consecutive day check-in increments streak
      habit = habit.checkIn(day2);
      expect(habit.currentStreak, equals(2));
      expect(habit.bestStreak, equals(2));

      // Missed day 3 -> check-in on day 4 resets streak to 1 gently, preserving bestStreak
      habit = habit.checkIn(day4);
      expect(habit.currentStreak, equals(1));
      expect(habit.bestStreak, equals(2));
    });
  });

  group('Drift Repositories Tests', () {
    late AppDatabase db;
    late OutboxQueue outbox;
    late DriftVitalsRepository vitalsRepo;
    late DriftMedicationRepository medRepo;
    late DriftHabitsRepository habitsRepo;

    setUp(() {
      db = AppDatabase.memory();
      outbox = OutboxQueue(db);
      vitalsRepo = DriftVitalsRepository(db, outbox);
      medRepo = DriftMedicationRepository(db, outbox);
      habitsRepo = DriftHabitsRepository(db, outbox);
    });

    tearDown(() async {
      await db.close();
    });

    test('DriftVitalsRepository rejects physiologically invalid records and accepts valid ones', () async {
      final invalidRecord = VitalRecord(
        id: 'v_invalid',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 20, // Invalid
        diastolic: 80,
      );
      final failRes = await vitalsRepo.saveLocal(invalidRecord);
      expect(failRes.isFailure, isTrue);

      final validRecord = VitalRecord(
        id: 'v_valid',
        userId: 'u1',
        recordedAt: DateTime.now(),
        vitalType: VitalType.bloodPressure,
        systolic: 120,
        diastolic: 80,
        pulse: 72,
      );
      final saveRes = await vitalsRepo.saveLocal(validRecord);
      expect(saveRes.isSuccess, isTrue);

      final fetchRes = await vitalsRepo.getLocal('v_valid');
      expect(fetchRes.isSuccess, isTrue);
      expect(fetchRes.dataOrNull?.systolic, equals(120));
      expect(fetchRes.dataOrNull?.pulse, equals(72));

      final queued = await outbox.fetchPending(limit: 5);
      expect(queued.any((m) => m.id == 'mut_vital_v_valid'), isTrue);
    });

    test('DriftMedicationRepository saves and queries medication schedule for day', () async {
      final today = DateTime.now();
      final med = MedicationEntry(
        id: 'med_1',
        userId: 'u1',
        name: 'Thyroxine',
        dosage: '50mcg',
        timeOfDay: MedicationTimeOfDay.morning,
        scheduledDate: today,
      );

      final saveRes = await medRepo.saveLocal(med);
      expect(saveRes.isSuccess, isTrue);

      final listRes = await medRepo.getForDay('u1', today);
      expect(listRes.isSuccess, isTrue);
      expect(listRes.dataOrNull?.length, equals(1));
      expect(listRes.dataOrNull?.first.name, equals('Thyroxine'));

      final queued = await outbox.fetchPending(limit: 5);
      expect(queued.any((m) => m.id == 'mut_med_med_1'), isTrue);
    });

    test('DriftHabitsRepository saves and retrieves habits with outbox enqueue', () async {
      const habit = HabitEntry(
        id: 'habit_1',
        userId: 'u1',
        title: 'Pranayama',
        targetDays: 7,
        currentStreak: 3,
        bestStreak: 5,
      );

      final saveRes = await habitsRepo.saveLocal(habit);
      expect(saveRes.isSuccess, isTrue);

      final allHabits = await habitsRepo.getAll('u1');
      expect(allHabits.isSuccess, isTrue);
      expect(allHabits.dataOrNull?.length, equals(1));
      expect(allHabits.dataOrNull?.first.title, equals('Pranayama'));

      final queued = await outbox.fetchPending(limit: 5);
      expect(queued.any((m) => m.id == 'mut_habit_habit_1'), isTrue);
    });
  });
}
