import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/database/app_database.dart';
import 'package:fitkarma/core/errors/failures.dart';
import 'package:fitkarma/core/errors/result.dart';
import 'package:fitkarma/features/ai/data/ai_gateway_client.dart';
import 'package:fitkarma/features/ai/domain/ai_meal_analyzer_service.dart';
import 'package:fitkarma/features/ai/domain/ai_models.dart';
import 'package:fitkarma/features/ai/domain/indian_food_matcher.dart';
import 'package:fitkarma/features/nutrition/data/drift_food_catalog_repository.dart';
import 'package:fitkarma/features/nutrition/domain/portion_unit.dart';

class FailingAiGatewayClient implements AiGatewayClient {
  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealText(String prompt) async {
    return const Result.failure(
      ExternalServiceFailure(message: 'Groq API rate limit exceeded. Retry shortly.'),
    );
  }

  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealPhoto(Uint8List imageBytes) async {
    return const Result.failure(
      ExternalServiceFailure(message: 'Vision model processing failed.'),
    );
  }

  @override
  Future<Result<AiHinglishInsight>> getHinglishCoaching({
    required String context,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    return const Result.failure(
      ExternalServiceFailure(message: 'Coaching unavailable.'),
    );
  }
}

void main() {
  group('AiMealAnalyzerService Unit & Pipeline Tests', () {
    late AppDatabase db;
    late DriftFoodCatalogRepository repo;
    late IndianFoodMatcher matcher;
    late AiMealAnalyzerService service;

    setUp(() async {
      db = AppDatabase.memory();
      repo = DriftFoodCatalogRepository(db);
      await repo.ensureSeeded();
      matcher = IndianFoodMatcher(repo);
      service = AiMealAnalyzerService(
        gatewayClient: MockAiGatewayClient(),
        foodMatcher: matcher,
      );
    });

    tearDown(() async {
      await db.close();
    });

    test('analyzes text meal and returns normalized candidate items', () async {
      final res = await service.analyzeTextMeal('2 rotis with paneer bhurji');

      expect(res.isSuccess, isTrue);
      final data = res.dataOrNull!;
      expect(data.candidateItems.isNotEmpty, isTrue);
      expect(data.candidateItems.first.isVerifiedInCatalog, isTrue);
      expect(data.totalCalories, greaterThan(0));
      expect(data.statutoryDisclaimer, contains('Not clinical'));
      expect(data.coaching.hinglishText, isNotEmpty);
    });

    test('rejects empty text prompt with validation failure', () async {
      final res = await service.analyzeTextMeal('   ');

      expect(res.isFailure, isTrue);
      expect(res.failureOrNull, isA<ValidationFailure>());
      expect(res.failureOrNull?.message, contains('Please describe'));
    });

    test('analyzes photo meal and returns normalized items', () async {
      final dummyBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6]);
      final res = await service.analyzePhotoMeal(dummyBytes);

      expect(res.isSuccess, isTrue);
      final data = res.dataOrNull!;
      expect(data.candidateItems.isNotEmpty, isTrue);
      expect(data.totalCalories, greaterThan(0));
    });

    test('rejects empty photo bytes with validation failure', () async {
      final res = await service.analyzePhotoMeal(Uint8List(0));

      expect(res.isFailure, isTrue);
      expect(res.failureOrNull, isA<ValidationFailure>());
      expect(res.failureOrNull?.message, contains('empty'));
    });

    test('propagates gateway server failure correctly', () async {
      final failingService = AiMealAnalyzerService(
        gatewayClient: FailingAiGatewayClient(),
        foodMatcher: matcher,
      );

      final res = await failingService.analyzeTextMeal('dal chawal');
      expect(res.isFailure, isTrue);
      expect(res.failureOrNull?.message, contains('Groq API rate limit'));
    });

    test('MockAiGatewayClient returns coaching insight', () async {
      final client = MockAiGatewayClient();
      final res = await client.getHinglishCoaching(
        context: 'lunch',
        calories: 500,
        protein: 20,
        carbs: 60,
        fat: 15,
      );

      expect(res.isSuccess, isTrue);
      final coaching = res.dataOrNull!;
      expect(coaching.headline, isNotEmpty);
      expect(coaching.hinglishText, contains('Protein'));
    });
  });

  group('AiDomain Models Tests', () {
    test('AiConfidenceLevel fromScore mapping', () {
      expect(AiConfidenceLevel.fromScore(0.95), equals(AiConfidenceLevel.high));
      expect(AiConfidenceLevel.fromScore(0.85), equals(AiConfidenceLevel.high));
      expect(AiConfidenceLevel.fromScore(0.70), equals(AiConfidenceLevel.medium));
      expect(AiConfidenceLevel.fromScore(0.50), equals(AiConfidenceLevel.low));

      expect(AiConfidenceLevel.high.label, contains('High'));
      expect(AiConfidenceLevel.medium.label, contains('Moderate'));
      expect(AiConfidenceLevel.low.label, contains('Low'));
    });

    test('AiCandidateItem toJson and fromJson round-trip', () {
      const item = AiCandidateItem(
        foodName: 'Moong Dal Khichdi',
        quantity: 1.5,
        unit: PortionUnit.mediumKatori,
        estimatedCalories: 280.0,
        proteinGrams: 9.5,
        carbsGrams: 45.0,
        fatGrams: 5.5,
        confidence: 0.88,
        isVerifiedInCatalog: true,
        matchedCatalogFoodId: 'khichdi_01',
      );

      final json = item.toJson();
      final revived = AiCandidateItem.fromJson(json);

      expect(revived.foodName, equals(item.foodName));
      expect(revived.quantity, equals(item.quantity));
      expect(revived.unit, equals(PortionUnit.mediumKatori));
      expect(revived.estimatedCalories, equals(item.estimatedCalories));
      expect(revived.isVerifiedInCatalog, isTrue);
      expect(revived.matchedCatalogFoodId, equals('khichdi_01'));
    });

    test('AiMealAnalysisResult.fromGatewayJson parses Edge Function payload', () {
      final edgeFunctionJson = {
        'summary': '2 Idli with Sambhar',
        'confidence_overall': 0.92,
        'uncertainty_reasons': <String>[],
        'items': [
          {
            'food_name': 'Steamed Idli',
            'quantity': 2.0,
            'unit': 'piece',
            'estimated_calories': 65.0,
            'protein_g': 2.0,
            'carbs_g': 14.0,
            'fat_g': 0.2,
            'confidence': 0.95,
          },
          {
            'food_name': 'Vegetable Sambhar',
            'quantity': 1.0,
            'unit': 'medium_katori',
            'estimated_calories': 120.0,
            'protein_g': 4.0,
            'carbs_g': 18.0,
            'fat_g': 3.0,
            'confidence': 0.89,
          }
        ],
        'hinglish_insight': 'Great breakfast choice with low fat!',
        'statutory_disclaimer': 'Nutritional estimate only. Not clinical or medical guidance.',
      };

      final parsed = AiMealAnalysisResult.fromGatewayJson(edgeFunctionJson);

      expect(parsed.summary, equals('2 Idli with Sambhar'));
      expect(parsed.candidateItems.length, equals(2));
      // 2 * 65 + 1 * 120 = 250
      expect(parsed.totalCalories, equals(250.0));
      expect(parsed.overallConfidence, equals(AiConfidenceLevel.high));
      expect(parsed.coaching.hinglishText, contains('Great breakfast'));
      expect(parsed.statutoryDisclaimer, contains('Not clinical'));
    });
  });
}

