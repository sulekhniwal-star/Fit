import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/providers/app_providers.dart';
import '../../nutrition/data/drift_food_catalog_repository.dart';
import '../../nutrition/domain/portion_unit.dart';
import '../domain/ai_models.dart';
import '../domain/indian_food_matcher.dart';

abstract class AiGatewayClient {
  Future<Result<AiMealAnalysisResult>> analyzeMealText(String prompt);
  Future<Result<AiMealAnalysisResult>> analyzeMealPhoto(Uint8List imageBytes);
  Future<Result<AiHinglishInsight>> getHinglishCoaching({
    required String context,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  });
}

class SupabaseAiGatewayClient implements AiGatewayClient {
  final FunctionsClient _functions;

  SupabaseAiGatewayClient({
    required String functionUrl,
    required String anonKey,
    String? authToken,
    FunctionsClient? functions,
  }) : _functions = functions ??
            FunctionsClient(
              '$functionUrl/functions/v1',
              {
                'apikey': anonKey,
                if (authToken != null) 'Authorization': 'Bearer $authToken',
              },
            );

  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealText(String prompt) async {
    return _callGateway({
      'task_type': 'meal_text_analysis',
      'prompt': prompt,
    });
  }

  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealPhoto(Uint8List imageBytes) async {
    final base64Image = base64Encode(imageBytes);
    return _callGateway({
      'task_type': 'meal_photo_analysis',
      'image_base64': base64Image,
    });
  }

  @override
  Future<Result<AiHinglishInsight>> getHinglishCoaching({
    required String context,
    required double calories,
    required double protein,
    required double carbs,
    required double fat,
  }) async {
    try {
      final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';
      final response = await _functions.invoke(
        'ai-gateway',
        headers: {'x-request-id': requestId},
        body: {
          'request_id': requestId,
          'payload': {
            'task_type': 'hinglish_coaching',
            'context': context,
            'macros': {
              'calories': calories,
              'protein': protein,
              'carbs': carbs,
              'fat': fat,
            },
          },
        },
      );

      final dynamic data = response.data;
      if (response.status == 200 && data is Map<String, dynamic> && data['data'] != null) {
        final payload = data['data'] as Map<String, dynamic>;
        return Result.success(AiHinglishInsight.fromJson(payload));
      }

      if (data is Map<String, dynamic>) {
        final errorObj = data['error'] as Map<String, dynamic>?;
        final msg = errorObj?['message'] as String? ?? 'Coaching unavailable';
        return Result.failure(ExternalServiceFailure(message: msg));
      }
      return const Result.failure(ExternalServiceFailure(message: 'Coaching unavailable'));
    } catch (e) {
      return Result.failure(ExternalServiceFailure(message: 'Failed to contact AI Gateway: $e'));
    }
  }

  Future<Result<AiMealAnalysisResult>> _callGateway(
    Map<String, dynamic> payload,
  ) async {
    try {
      final requestId = 'req_${DateTime.now().millisecondsSinceEpoch}';
      final response = await _functions.invoke(
        'ai-gateway',
        headers: {'x-request-id': requestId},
        body: {
          'request_id': requestId,
          'payload': payload,
        },
      );

      final dynamic data = response.data;
      if (response.status == 200 && data is Map<String, dynamic> && data['data'] != null) {
        final resData = data['data'] as Map<String, dynamic>;
        return Result.success(AiMealAnalysisResult.fromGatewayJson(resData));
      }

      if (data is Map<String, dynamic>) {
        final errorObj = data['error'] as Map<String, dynamic>?;
        final code = errorObj?['code'] as String? ?? 'FK-4001';
        final msg = errorObj?['message'] as String? ?? 'AI analysis failed';

        if (code == 'FK-4001') {
          return Result.failure(AIFailure(message: msg));
        }
        return Result.failure(ExternalServiceFailure(message: '[$code] $msg'));
      }
      return const Result.failure(AIFailure(message: 'AI analysis failed'));
    } catch (e) {
      return Result.failure(ExternalServiceFailure(message: 'AI Gateway connection failed: $e'));
    }
  }
}

class MockAiGatewayClient implements AiGatewayClient {
  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealText(String prompt) async {
    final lower = prompt.toLowerCase();
    final items = <AiCandidateItem>[];

    if (lower.contains('roti') || lower.contains('phulka') || lower.contains('chapati')) {
      items.add(
        const AiCandidateItem(
          foodName: 'Phulka / Roti',
          quantity: 2.0,
          unit: PortionUnit.piece,
          estimatedCalories: 160.0,
          proteinGrams: 6.0,
          carbsGrams: 32.0,
          fatGrams: 1.0,
          confidence: 0.95,
        ),
      );
    }

    if (lower.contains('dal') || lower.contains('daal')) {
      items.add(
        const AiCandidateItem(
          foodName: 'Dal Tadka',
          quantity: 1.0,
          unit: PortionUnit.mediumKatori,
          estimatedCalories: 180.0,
          proteinGrams: 9.0,
          carbsGrams: 22.0,
          fatGrams: 6.0,
          confidence: 0.92,
        ),
      );
    }

    if (lower.contains('paneer')) {
      items.add(
        const AiCandidateItem(
          foodName: 'Paneer Bhurji',
          quantity: 0.5,
          unit: PortionUnit.mediumKatori,
          estimatedCalories: 190.0,
          proteinGrams: 11.0,
          carbsGrams: 4.0,
          fatGrams: 14.0,
          confidence: 0.90,
        ),
      );
    }

    if (items.isEmpty) {
      items.add(
        const AiCandidateItem(
          foodName: 'Mixed Indian Thali',
          quantity: 1.0,
          unit: PortionUnit.mediumKatori,
          estimatedCalories: 350.0,
          proteinGrams: 10.0,
          carbsGrams: 55.0,
          fatGrams: 10.0,
          confidence: 0.80,
        ),
      );
    }

    final totalCal = items.fold<double>(0.0, (s, i) => s + (i.estimatedCalories * i.quantity));
    final totalP = items.fold<double>(0.0, (s, i) => s + (i.proteinGrams * i.quantity));
    final totalC = items.fold<double>(0.0, (s, i) => s + (i.carbsGrams * i.quantity));
    final totalF = items.fold<double>(0.0, (s, i) => s + (i.fatGrams * i.quantity));

    return Result.success(
      AiMealAnalysisResult(
        summary: 'Estimated ${items.length} items from input: "$prompt"',
        candidateItems: items,
        totalCalories: totalCal,
        totalProtein: totalP,
        totalCarbs: totalC,
        totalFat: totalF,
        overallConfidence: AiConfidenceLevel.high,
        uncertaintyReasons: const [
          'Tadka oil estimated using standard homestyle average',
        ],
        coaching: const AiHinglishInsight(
          headline: 'Badhiya Meal!',
          hinglishText: 'Aapka meal well-balanced hai! Portions confirm karke log karein.',
        ),
      ),
    );
  }

  @override
  Future<Result<AiMealAnalysisResult>> analyzeMealPhoto(Uint8List imageBytes) async {
    const items = [
      AiCandidateItem(
        foodName: 'Phulka / Roti',
        quantity: 2.0,
        unit: PortionUnit.piece,
        estimatedCalories: 160.0,
        proteinGrams: 6.0,
        carbsGrams: 32.0,
        fatGrams: 1.0,
        confidence: 0.94,
      ),
      AiCandidateItem(
        foodName: 'Dal Tadka',
        quantity: 1.0,
        unit: PortionUnit.smallKatori,
        estimatedCalories: 150.0,
        proteinGrams: 7.5,
        carbsGrams: 18.0,
        fatGrams: 5.0,
        confidence: 0.90,
      ),
      AiCandidateItem(
        foodName: 'Aloo Gobi Sabzi',
        quantity: 1.0,
        unit: PortionUnit.mediumKatori,
        estimatedCalories: 140.0,
        proteinGrams: 3.5,
        carbsGrams: 18.0,
        fatGrams: 6.0,
        confidence: 0.86,
      ),
    ];

    final totalCal = items.fold<double>(0.0, (s, i) => s + (i.estimatedCalories * i.quantity));
    final totalP = items.fold<double>(0.0, (s, i) => s + (i.proteinGrams * i.quantity));
    final totalC = items.fold<double>(0.0, (s, i) => s + (i.carbsGrams * i.quantity));
    final totalF = items.fold<double>(0.0, (s, i) => s + (i.fatGrams * i.quantity));

    return Result.success(
      AiMealAnalysisResult(
        summary: 'Detected Indian Thali with Roti, Dal, and Aloo Gobi',
        candidateItems: items,
        totalCalories: totalCal,
        totalProtein: totalP,
        totalCarbs: totalC,
        totalFat: totalF,
        overallConfidence: AiConfidenceLevel.high,
        uncertaintyReasons: const [
          'Depth perception on katori depth is approximate from single photo angle',
        ],
        coaching: const AiHinglishInsight(
          headline: 'Authentic Indian Thali',
          hinglishText: 'Thali mein portions bilkul balanced dikh rahe hain!',
        ),
      ),
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
    return const Result.success(
      AiHinglishInsight(
        headline: 'Daily Nutrition Coaching',
        hinglishText:
            'Aapka meal log ready hai! Protein requirement pura karne ke liye dinner mein dahi ya paneer shamil karein.',
      ),
    );
  }
}

// --- RIVERPOD PROVIDERS ---

final aiGatewayClientProvider = Provider<AiGatewayClient>((ref) {
  final config = ref.watch(appConfigProvider);
  if (config.isDevelopment || config.supabaseUrl.contains('localhost')) {
    return MockAiGatewayClient();
  }
  return SupabaseAiGatewayClient(
    functionUrl: config.supabaseUrl,
    anonKey: config.supabaseAnonKey,
  );
});

final indianFoodMatcherProvider = Provider<IndianFoodMatcher>((ref) {
  final db = ref.watch(appDatabaseProvider);
  return IndianFoodMatcher(DriftFoodCatalogRepository(db));
});

