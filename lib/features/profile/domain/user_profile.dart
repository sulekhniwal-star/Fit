import 'dosha_calculator.dart';

enum BiologicalSex {
  male,
  female,
  other,
}

enum ActivityLevel {
  sedentary,
  lightlyActive,
  moderatelyActive,
  veryActive,
}

enum DietaryIdentity {
  vegetarian,
  eggetarian,
  nonVegetarian,
  jain,
  vegan,
}

enum HealthGoal {
  weightLoss,
  muscleGain,
  maintenance,
  metabolicWellness,
}

class UserProfile {
  final String userId;
  final String displayName;
  final int age;
  final BiologicalSex biologicalSex;
  final double heightCm;
  final double weightKg;
  final double? targetWeightKg;
  final ActivityLevel activityLevel;
  final DietaryIdentity dietaryIdentity;
  final HealthGoal healthGoal;
  final String languageCode;
  final DoshaProfile? doshaProfile;
  final bool hasAcceptedDpdpConsent;
  final DateTime updatedAt;

  const UserProfile({
    required this.userId,
    required this.displayName,
    required this.age,
    required this.biologicalSex,
    required this.heightCm,
    required this.weightKg,
    this.targetWeightKg,
    required this.activityLevel,
    required this.dietaryIdentity,
    required this.healthGoal,
    this.languageCode = 'en',
    this.doshaProfile,
    required this.hasAcceptedDpdpConsent,
    required this.updatedAt,
  });

  /// True if all biometrics conform to realistic physiological limits.
  bool get hasValidBiometrics {
    return age >= 1 &&
        age <= 120 &&
        heightCm >= 50.0 &&
        heightCm <= 300.0 &&
        weightKg >= 20.0 &&
        weightKg <= 400.0 &&
        (targetWeightKg == null || (targetWeightKg! >= 20.0 && targetWeightKg! <= 400.0));
  }

  /// Calculates Body Mass Index (BMI).
  double get bmi {
    final heightInMeters = heightCm / 100.0;
    if (heightInMeters <= 0) return 0.0;
    return weightKg / (heightInMeters * heightInMeters);
  }

  UserProfile copyWith({
    String? userId,
    String? displayName,
    int? age,
    BiologicalSex? biologicalSex,
    double? heightCm,
    double? weightKg,
    double? targetWeightKg,
    ActivityLevel? activityLevel,
    DietaryIdentity? dietaryIdentity,
    HealthGoal? healthGoal,
    String? languageCode,
    DoshaProfile? doshaProfile,
    bool? hasAcceptedDpdpConsent,
    DateTime? updatedAt,
  }) {
    return UserProfile(
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      age: age ?? this.age,
      biologicalSex: biologicalSex ?? this.biologicalSex,
      heightCm: heightCm ?? this.heightCm,
      weightKg: weightKg ?? this.weightKg,
      targetWeightKg: targetWeightKg ?? this.targetWeightKg,
      activityLevel: activityLevel ?? this.activityLevel,
      dietaryIdentity: dietaryIdentity ?? this.dietaryIdentity,
      healthGoal: healthGoal ?? this.healthGoal,
      languageCode: languageCode ?? this.languageCode,
      doshaProfile: doshaProfile ?? this.doshaProfile,
      hasAcceptedDpdpConsent: hasAcceptedDpdpConsent ?? this.hasAcceptedDpdpConsent,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => {
        'user_id': userId,
        'display_name': displayName,
        'age': age,
        'biological_sex': biologicalSex.name,
        'height_cm': heightCm,
        'weight_kg': weightKg,
        if (targetWeightKg != null) 'target_weight_kg': targetWeightKg,
        'activity_level': activityLevel.name,
        'dietary_identity': dietaryIdentity.name,
        'health_goal': healthGoal.name,
        'language_code': languageCode,
        if (doshaProfile != null) 'dosha_profile': doshaProfile!.toJson(),
        'has_accepted_dpdp_consent': hasAcceptedDpdpConsent,
        'updated_at': updatedAt.toIso8601String(),
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      userId: json['user_id'] as String,
      displayName: json['display_name'] as String? ?? 'User',
      age: json['age'] as int? ?? 25,
      biologicalSex: BiologicalSex.values.firstWhere(
        (s) => s.name == json['biological_sex'],
        orElse: () => BiologicalSex.male,
      ),
      heightCm: (json['height_cm'] as num?)?.toDouble() ?? 170.0,
      weightKg: (json['weight_kg'] as num?)?.toDouble() ?? 70.0,
      targetWeightKg: (json['target_weight_kg'] as num?)?.toDouble(),
      activityLevel: ActivityLevel.values.firstWhere(
        (a) => a.name == json['activity_level'],
        orElse: () => ActivityLevel.moderatelyActive,
      ),
      dietaryIdentity: DietaryIdentity.values.firstWhere(
        (d) => d.name == json['dietary_identity'],
        orElse: () => DietaryIdentity.vegetarian,
      ),
      healthGoal: HealthGoal.values.firstWhere(
        (g) => g.name == json['health_goal'],
        orElse: () => HealthGoal.maintenance,
      ),
      languageCode: json['language_code'] as String? ?? 'en',
      doshaProfile: json['dosha_profile'] != null
          ? DoshaProfile.fromJson(json['dosha_profile'] as Map<String, dynamic>)
          : null,
      hasAcceptedDpdpConsent: json['has_accepted_dpdp_consent'] as bool? ?? false,
      updatedAt: DateTime.tryParse(json['updated_at'] as String? ?? '') ?? DateTime.now(),
    );
  }
}
