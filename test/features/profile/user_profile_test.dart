import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/errors/failures.dart';
import 'package:fitkarma/features/profile/data/local_profile_repository.dart';
import 'package:fitkarma/features/profile/domain/dosha_calculator.dart';
import 'package:fitkarma/features/profile/domain/user_profile.dart';

void main() {
  group('UserProfile Entity Tests', () {
    test('validates biometric boundaries accurately', () {
      final validProfile = UserProfile(
        userId: 'u1',
        displayName: 'Rahul',
        age: 28,
        biologicalSex: BiologicalSex.male,
        heightCm: 175.0,
        weightKg: 72.0,
        targetWeightKg: 70.0,
        activityLevel: ActivityLevel.moderatelyActive,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      expect(validProfile.hasValidBiometrics, isTrue);

      final invalidHeightProfile = validProfile.copyWith(heightCm: 45.0);
      expect(invalidHeightProfile.hasValidBiometrics, isFalse);

      final invalidWeightProfile = validProfile.copyWith(weightKg: 15.0);
      expect(invalidWeightProfile.hasValidBiometrics, isFalse);

      final invalidAgeProfile = validProfile.copyWith(age: 0);
      expect(invalidAgeProfile.hasValidBiometrics, isFalse);
    });

    test('calculates BMI accurately', () {
      final profile = UserProfile(
        userId: 'u1',
        displayName: 'Aarav',
        age: 30,
        biologicalSex: BiologicalSex.male,
        heightCm: 180.0,
        weightKg: 81.0,
        activityLevel: ActivityLevel.moderatelyActive,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      // BMI = 81 / (1.8 * 1.8) = 81 / 3.24 = 25.0
      expect(profile.bmi, closeTo(25.0, 0.01));
    });
  });

  group('DoshaCalculator Tests', () {
    const calculator = DoshaCalculator();

    test('determines dominant Pitta when pitta score is highest', () {
      final profile = calculator.calculate(
        vataPoints: 4,
        pittaPoints: 9,
        kaphaPoints: 2,
      );

      expect(profile.primaryDosha, equals(DoshaType.pitta));
      expect(DoshaProfile.nonMedicalDisclaimer, contains('traditional lifestyle and wellness'));
    });

    test('determines dominant Vata when vata score is highest', () {
      final profile = calculator.calculate(
        vataPoints: 8,
        pittaPoints: 3,
        kaphaPoints: 1,
      );

      expect(profile.primaryDosha, equals(DoshaType.vata));
    });

    test('determines Tri-Doshic when all scores are equal', () {
      final profile = calculator.calculate(
        vataPoints: 5,
        pittaPoints: 5,
        kaphaPoints: 5,
      );

      expect(profile.primaryDosha, equals(DoshaType.triDoshic));
    });
  });

  group('LocalProfileRepository Tests', () {
    late LocalProfileRepository repository;

    setUp(() {
      repository = LocalProfileRepository();
    });

    test('saves and retrieves user profile successfully', () async {
      final profile = UserProfile(
        userId: 'u123',
        displayName: 'Priya',
        age: 26,
        biologicalSex: BiologicalSex.female,
        heightCm: 165.0,
        weightKg: 58.0,
        activityLevel: ActivityLevel.lightlyActive,
        dietaryIdentity: DietaryIdentity.eggetarian,
        healthGoal: HealthGoal.weightLoss,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      final saveResult = await repository.saveProfile(profile);
      expect(saveResult.isSuccess, isTrue);

      final getResult = await repository.getProfile('u123');
      expect(getResult.isSuccess, isTrue);
      getResult.when(
        onSuccess: (saved) {
          expect(saved.displayName, equals('Priya'));
          expect(saved.heightCm, equals(165.0));
        },
        onFailure: (_) => fail('Expected success'),
      );
    });

    test('rejects profile with invalid biometric boundaries', () async {
      final invalidProfile = UserProfile(
        userId: 'u124',
        displayName: 'Invalid',
        age: -5,
        biologicalSex: BiologicalSex.male,
        heightCm: 10.0,
        weightKg: 5.0,
        activityLevel: ActivityLevel.sedentary,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      final result = await repository.saveProfile(invalidProfile);
      expect(result.isFailure, isTrue);
      result.when(
        onSuccess: (_) => fail('Expected failure'),
        onFailure: (failure) {
          expect(failure, isA<ValidationFailure>());
        },
      );
    });

    test('deleteProfile removes profile from storage', () async {
      final profile = UserProfile(
        userId: 'u125',
        displayName: 'Test',
        age: 30,
        biologicalSex: BiologicalSex.male,
        heightCm: 170.0,
        weightKg: 70.0,
        activityLevel: ActivityLevel.moderatelyActive,
        dietaryIdentity: DietaryIdentity.vegetarian,
        healthGoal: HealthGoal.maintenance,
        hasAcceptedDpdpConsent: true,
        updatedAt: DateTime.now(),
      );

      await repository.saveProfile(profile);
      final deleteResult = await repository.deleteProfile('u125');
      expect(deleteResult.isSuccess, isTrue);

      final getResult = await repository.getProfile('u125');
      expect(getResult.isFailure, isTrue);
    });
  });
}
