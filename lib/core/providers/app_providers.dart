import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../config/app_config.dart';

/// Application configuration provider.
///
/// In production, overridden at root ProviderScope.
/// In tests, overridden inside ProviderContainer.
final appConfigProvider = Provider<AppConfig>((ref) {
  throw UnimplementedError('appConfigProvider must be initialized via ProviderScope overrides');
});
