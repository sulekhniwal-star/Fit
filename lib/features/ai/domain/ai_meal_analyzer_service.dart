import 'dart:typed_data';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../data/ai_gateway_client.dart';
import 'ai_models.dart';
import 'indian_food_matcher.dart';

class AiMealAnalyzerService {
  final AiGatewayClient gatewayClient;
  final IndianFoodMatcher foodMatcher;

  const AiMealAnalyzerService({
    required this.gatewayClient,
    required this.foodMatcher,
  });

  /// Analyzes natural text (English, Hindi, or Hinglish) and matches to verified Indian foods.
  Future<Result<AiMealAnalysisResult>> analyzeTextMeal(String prompt) async {
    if (prompt.trim().isEmpty) {
      return const Result.failure(
        ValidationFailure(message: 'Please describe what you ate.'),
      );
    }

    final rawRes = await gatewayClient.analyzeMealText(prompt);
    if (rawRes.isFailure) {
      return Result.failure(rawRes.failureOrNull!);
    }

    final rawResult = rawRes.dataOrNull!;
    final normalized = await foodMatcher.matchAndNormalize(rawResult);
    return Result.success(normalized);
  }

  /// Analyzes an uploaded food photo and matches detected dishes against the catalog.
  Future<Result<AiMealAnalysisResult>> analyzePhotoMeal(Uint8List imageBytes) async {
    if (imageBytes.isEmpty) {
      return const Result.failure(
        ValidationFailure(message: 'Photo bytes cannot be empty.'),
      );
    }

    final rawRes = await gatewayClient.analyzeMealPhoto(imageBytes);
    if (rawRes.isFailure) {
      return Result.failure(rawRes.failureOrNull!);
    }

    final rawResult = rawRes.dataOrNull!;
    final normalized = await foodMatcher.matchAndNormalize(rawResult);
    return Result.success(normalized);
  }
}

// --- RIVERPOD PROVIDER ---

final aiMealAnalyzerServiceProvider = Provider<AiMealAnalyzerService>((ref) {
  final client = ref.watch(aiGatewayClientProvider);
  final matcher = ref.watch(indianFoodMatcherProvider);

  return AiMealAnalyzerService(
    gatewayClient: client,
    foodMatcher: matcher,
  );
});

