enum MuscleGroup {
  chest,
  back,
  shoulders,
  biceps,
  triceps,
  coreAbs,
  quadriceps,
  hamstrings,
  calves,
  glutes,
  fullBody;

  String get displayName {
    switch (this) {
      case MuscleGroup.chest:
        return 'Chest';
      case MuscleGroup.back:
        return 'Back & Lats';
      case MuscleGroup.shoulders:
        return 'Shoulders & Delts';
      case MuscleGroup.biceps:
        return 'Biceps';
      case MuscleGroup.triceps:
        return 'Triceps';
      case MuscleGroup.coreAbs:
        return 'Core & Abs';
      case MuscleGroup.quadriceps:
        return 'Quadriceps';
      case MuscleGroup.hamstrings:
        return 'Hamstrings';
      case MuscleGroup.calves:
        return 'Calves';
      case MuscleGroup.glutes:
        return 'Glutes';
      case MuscleGroup.fullBody:
        return 'Full Body';
    }
  }
}

enum EquipmentType {
  bodyweight,
  dumbbells,
  barbell,
  kettlebell,
  resistanceBands,
  cableMachine,
  yogaMat,
  cardioMachine;

  String get displayName {
    switch (this) {
      case EquipmentType.bodyweight:
        return 'Bodyweight';
      case EquipmentType.dumbbells:
        return 'Dumbbells';
      case EquipmentType.barbell:
        return 'Barbell';
      case EquipmentType.kettlebell:
        return 'Kettlebell';
      case EquipmentType.resistanceBands:
        return 'Resistance Bands';
      case EquipmentType.cableMachine:
        return 'Cable Machine';
      case EquipmentType.yogaMat:
        return 'Yoga Mat';
      case EquipmentType.cardioMachine:
        return 'Cardio Machine';
    }
  }
}

enum WorkoutType {
  strength,
  cardio,
  yoga,
  hiit,
  mobilityFlexibility,
  custom;

  String get displayName {
    switch (this) {
      case WorkoutType.strength:
        return 'Strength & Hypertrophy';
      case WorkoutType.cardio:
        return 'Cardio & Endurance';
      case WorkoutType.yoga:
        return 'Yoga & Asanas';
      case WorkoutType.hiit:
        return 'HIIT & Conditioning';
      case WorkoutType.mobilityFlexibility:
        return 'Mobility & Stretching';
      case WorkoutType.custom:
        return 'Custom';
    }
  }
}

enum ExerciseDifficulty {
  beginner,
  intermediate,
  advanced;

  String get displayName {
    switch (this) {
      case ExerciseDifficulty.beginner:
        return 'Beginner';
      case ExerciseDifficulty.intermediate:
        return 'Intermediate';
      case ExerciseDifficulty.advanced:
        return 'Advanced';
    }
  }
}

class Exercise {
  final String id;
  final String name;
  final String hindiName;
  final MuscleGroup primaryMuscle;
  final List<MuscleGroup> secondaryMuscles;
  final EquipmentType equipment;
  final WorkoutType workoutType;
  final ExerciseDifficulty difficulty;
  final String instructions;
  final bool isHomeFriendly;
  final bool isSystem;

  const Exercise({
    required this.id,
    required this.name,
    this.hindiName = '',
    required this.primaryMuscle,
    this.secondaryMuscles = const [],
    required this.equipment,
    required this.workoutType,
    this.difficulty = ExerciseDifficulty.beginner,
    this.instructions = '',
    this.isHomeFriendly = true,
    this.isSystem = true,
  });

  bool get isValid => id.isNotEmpty && name.isNotEmpty;

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'hindi_name': hindiName,
        'primary_muscle': primaryMuscle.name,
        'secondary_muscles': secondaryMuscles.map((m) => m.name).toList(),
        'equipment': equipment.name,
        'workout_type': workoutType.name,
        'difficulty': difficulty.name,
        'instructions': instructions,
        'is_home_friendly': isHomeFriendly,
        'is_system': isSystem,
      };

  factory Exercise.fromJson(Map<String, dynamic> json) {
    final rawSec = json['secondary_muscles'] as List<dynamic>? ?? [];
    return Exercise(
      id: json['id'] as String,
      name: json['name'] as String,
      hindiName: json['hindi_name'] as String? ?? '',
      primaryMuscle: MuscleGroup.values.firstWhere(
        (m) => m.name == json['primary_muscle'],
        orElse: () => MuscleGroup.fullBody,
      ),
      secondaryMuscles: rawSec
          .map((m) => MuscleGroup.values.firstWhere(
                (v) => v.name == m,
                orElse: () => MuscleGroup.coreAbs,
              ))
          .toList(),
      equipment: EquipmentType.values.firstWhere(
        (e) => e.name == json['equipment'],
        orElse: () => EquipmentType.bodyweight,
      ),
      workoutType: WorkoutType.values.firstWhere(
        (w) => w.name == json['workout_type'],
        orElse: () => WorkoutType.strength,
      ),
      difficulty: ExerciseDifficulty.values.firstWhere(
        (d) => d.name == json['difficulty'],
        orElse: () => ExerciseDifficulty.beginner,
      ),
      instructions: json['instructions'] as String? ?? '',
      isHomeFriendly: json['is_home_friendly'] as bool? ?? true,
      isSystem: json['is_system'] as bool? ?? true,
    );
  }
}

