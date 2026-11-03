import '../../health/domain/sleep_record.dart';

enum ReadinessTier {
  peak,
  optimal,
  moderate,
  recovery,
}

class ReadinessFactor {
  final String name;
  final int score; // 0 to 100
  final double weight; // 0.0 to 1.0
  final String summary;
  final bool isMissing;

  const ReadinessFactor({
    required this.name,
    required this.score,
    required this.weight,
    required this.summary,
    this.isMissing = false,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'score': score,
        'weight': weight,
        'summary': summary,
        'isMissing': isMissing,
      };

  factory ReadinessFactor.fromJson(Map<String, dynamic> json) =>
      ReadinessFactor(
        name: json['name'] as String,
        score: (json['score'] as num).toInt(),
        weight: (json['weight'] as num).toDouble(),
        summary: json['summary'] as String,
        isMissing: json['isMissing'] as bool? ?? false,
      );
}

class DailyReadinessScore {
  final int score; // 0 to 100
  final ReadinessTier tier;
  final String headline;
  final String explanation;
  final List<ReadinessFactor> factors;
  final String statutoryDisclaimer;
  final DateTime calculatedAt;

  const DailyReadinessScore({
    required this.score,
    required this.tier,
    required this.headline,
    required this.explanation,
    required this.factors,
    required this.statutoryDisclaimer,
    required this.calculatedAt,
  });

  static const String defaultDisclaimer =
      'Wellness indicator only. Not intended to diagnose, cure, or treat any medical condition.';

  Map<String, dynamic> toJson() => {
        'score': score,
        'tier': tier.name,
        'headline': headline,
        'explanation': explanation,
        'factors': factors.map((f) => f.toJson()).toList(),
        'statutoryDisclaimer': statutoryDisclaimer,
        'calculatedAt': calculatedAt.toIso8601String(),
      };

  factory DailyReadinessScore.fromJson(Map<String, dynamic> json) =>
      DailyReadinessScore(
        score: (json['score'] as num).toInt(),
        tier: ReadinessTier.values.byName(json['tier'] as String),
        headline: json['headline'] as String,
        explanation: json['explanation'] as String,
        factors: (json['factors'] as List<dynamic>)
            .map((f) => ReadinessFactor.fromJson(f as Map<String, dynamic>))
            .toList(),
        statutoryDisclaimer: json['statutoryDisclaimer'] as String,
        calculatedAt: DateTime.parse(json['calculatedAt'] as String),
      );
}

enum DipActionCategory {
  hydration,
  nutrition,
  movement,
  recovery,
  mindset,
}

class DipMicroAction {
  final String id;
  final String title;
  final String description;
  final DipActionCategory category;
  final double priority; // 0.0 to 100.0
  final String? actionRoute;
  final String actionLabel;
  final bool isDismissible;
  final String? culturalContext;
  final bool isCompleted;

  const DipMicroAction({
    required this.id,
    required this.title,
    required this.description,
    required this.category,
    required this.priority,
    this.actionRoute,
    this.actionLabel = 'Action',
    this.isDismissible = true,
    this.culturalContext,
    this.isCompleted = false,
  });

  DipMicroAction copyWith({
    String? id,
    String? title,
    String? description,
    DipActionCategory? category,
    double? priority,
    String? actionRoute,
    String? actionLabel,
    bool? isDismissible,
    String? culturalContext,
    bool? isCompleted,
  }) {
    return DipMicroAction(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      category: category ?? this.category,
      priority: priority ?? this.priority,
      actionRoute: actionRoute ?? this.actionRoute,
      actionLabel: actionLabel ?? this.actionLabel,
      isDismissible: isDismissible ?? this.isDismissible,
      culturalContext: culturalContext ?? this.culturalContext,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'category': category.name,
        'priority': priority,
        'actionRoute': actionRoute,
        'actionLabel': actionLabel,
        'isDismissible': isDismissible,
        'culturalContext': culturalContext,
        'isCompleted': isCompleted,
      };

  factory DipMicroAction.fromJson(Map<String, dynamic> json) => DipMicroAction(
        id: json['id'] as String,
        title: json['title'] as String,
        description: json['description'] as String,
        category: DipActionCategory.values.byName(json['category'] as String),
        priority: (json['priority'] as num).toDouble(),
        actionRoute: json['actionRoute'] as String?,
        actionLabel: json['actionLabel'] as String? ?? 'Action',
        isDismissible: json['isDismissible'] as bool? ?? true,
        culturalContext: json['culturalContext'] as String?,
        isCompleted: json['isCompleted'] as bool? ?? false,
      );
}

class DipFocusSignal {
  final String title;
  final String subtitle;
  final String badge;

  const DipFocusSignal({
    required this.title,
    required this.subtitle,
    required this.badge,
  });

  Map<String, dynamic> toJson() => {
        'title': title,
        'subtitle': subtitle,
        'badge': badge,
      };

  factory DipFocusSignal.fromJson(Map<String, dynamic> json) => DipFocusSignal(
        title: json['title'] as String,
        subtitle: json['subtitle'] as String,
        badge: json['badge'] as String,
      );
}

class DipSummaryMetrics {
  final int todaySteps;
  final int stepGoal;
  final double consumedCalories;
  final double targetCalories;
  final int? sleepMinutes;
  final int consumedWaterMl;
  final int targetWaterMl;

  const DipSummaryMetrics({
    required this.todaySteps,
    this.stepGoal = 10000,
    required this.consumedCalories,
    this.targetCalories = 2000,
    this.sleepMinutes,
    required this.consumedWaterMl,
    this.targetWaterMl = 3000,
  });

  Map<String, dynamic> toJson() => {
        'todaySteps': todaySteps,
        'stepGoal': stepGoal,
        'consumedCalories': consumedCalories,
        'targetCalories': targetCalories,
        'sleepMinutes': sleepMinutes,
        'consumedWaterMl': consumedWaterMl,
        'targetWaterMl': targetWaterMl,
      };

  factory DipSummaryMetrics.fromJson(Map<String, dynamic> json) =>
      DipSummaryMetrics(
        todaySteps: (json['todaySteps'] as num).toInt(),
        stepGoal: (json['stepGoal'] as num?)?.toInt() ?? 10000,
        consumedCalories: (json['consumedCalories'] as num).toDouble(),
        targetCalories: (json['targetCalories'] as num?)?.toDouble() ?? 2000,
        sleepMinutes: (json['sleepMinutes'] as num?)?.toInt(),
        consumedWaterMl: (json['consumedWaterMl'] as num).toInt(),
        targetWaterMl: (json['targetWaterMl'] as num?)?.toInt() ?? 3000,
      );
}

class DailyIntelligencePackage {
  final DateTime date;
  final DailyReadinessScore readinessScore;
  final DipFocusSignal primaryFocus;
  final List<DipMicroAction> topActions;
  final DipSummaryMetrics summaryMetrics;

  const DailyIntelligencePackage({
    required this.date,
    required this.readinessScore,
    required this.primaryFocus,
    required this.topActions,
    required this.summaryMetrics,
  });

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'readinessScore': readinessScore.toJson(),
        'primaryFocus': primaryFocus.toJson(),
        'topActions': topActions.map((a) => a.toJson()).toList(),
        'summaryMetrics': summaryMetrics.toJson(),
      };

  factory DailyIntelligencePackage.fromJson(Map<String, dynamic> json) =>
      DailyIntelligencePackage(
        date: DateTime.parse(json['date'] as String),
        readinessScore: DailyReadinessScore.fromJson(
            json['readinessScore'] as Map<String, dynamic>),
        primaryFocus: DipFocusSignal.fromJson(
            json['primaryFocus'] as Map<String, dynamic>),
        topActions: (json['topActions'] as List<dynamic>)
            .map((a) => DipMicroAction.fromJson(a as Map<String, dynamic>))
            .toList(),
        summaryMetrics: DipSummaryMetrics.fromJson(
            json['summaryMetrics'] as Map<String, dynamic>),
      );
}

class DipContextInput {
  final String userId;
  final DateTime timestamp;
  final SleepRecord? sleep;
  final int todaySteps;
  final int stepGoal;
  final double? restingHeartRate;
  final double acuteWorkload; // e.g. rolling 7-day volume
  final double chronicWorkload; // e.g. 28-day weekly average volume
  final double consumedCalories;
  final double targetCalories;
  final int consumedWaterMl;
  final int targetWaterMl;
  final DateTime? recentMealTimestamp;
  final double? recentMealCalories;
  final int todayWorkoutsCount;

  const DipContextInput({
    required this.userId,
    required this.timestamp,
    this.sleep,
    this.todaySteps = 0,
    this.stepGoal = 10000,
    this.restingHeartRate,
    this.acuteWorkload = 0.0,
    this.chronicWorkload = 0.0,
    this.consumedCalories = 0.0,
    this.targetCalories = 2000.0,
    this.consumedWaterMl = 0,
    this.targetWaterMl = 3000,
    this.recentMealTimestamp,
    this.recentMealCalories,
    this.todayWorkoutsCount = 0,
  });
}

