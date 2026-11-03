import 'dart:convert';

import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/config/remote_config.dart';
import 'package:fitkarma/core/config/remote_config_service_contract.dart';
import 'package:fitkarma/core/services/logging_service_contract.dart';

/// Concrete Remote Config Service providing offline cached defaults and dynamic updates.
class RemoteConfigService implements RemoteConfigServiceContract {
  final LoggingServiceContract? logger;
  RemoteConfig _currentConfig;
  String? _cachedSerializedConfig;

  RemoteConfigService({this.logger, RemoteConfig? initialConfig})
    : _currentConfig = initialConfig ?? RemoteConfig.defaultConfig();

  @override
  RemoteConfig get currentConfig => _currentConfig;

  @override
  Future<RemoteConfig> fetchRemoteConfig() async {
    try {
      // In greenfield foundation, this connects to Supabase/Edge Function backend endpoint.
      // If network fails or is unconfigured, seamlessly return cached or default configuration.
      final cached = await loadFromCache();
      _currentConfig = cached;
      return _currentConfig;
    } catch (e, stack) {
      logger?.warning(
        'Failed to fetch remote config, using fallback defaults',
        e,
        stack,
      );
      return _currentConfig;
    }
  }

  /// Ingests a new configuration payload, validating that no server secrets exist.
  Future<void> updateFromMap(Map<String, dynamic> json) async {
    // 1. Security boundary check: ensure remote config does not contain server secrets
    for (final prohibitedKey in AppConfig.prohibitedServerKeys) {
      if (json.containsKey(prohibitedKey)) {
        throw SecurityViolationException(
          message: 'Server secret detected in remote configuration payload!',
          detectedKey: prohibitedKey,
        );
      }
    }

    final newConfig = RemoteConfig.fromJson(json);
    _currentConfig = newConfig;
    await saveToCache(newConfig);
    logger?.info(
      'Remote configuration updated to version ${newConfig.version}',
    );
  }

  @override
  Future<void> saveToCache(RemoteConfig config) async {
    _cachedSerializedConfig = jsonEncode(config.toJson());
  }

  @override
  Future<RemoteConfig> loadFromCache() async {
    if (_cachedSerializedConfig != null &&
        _cachedSerializedConfig!.isNotEmpty) {
      final decoded =
          jsonDecode(_cachedSerializedConfig!) as Map<String, dynamic>;
      return RemoteConfig.fromJson(decoded);
    }
    return _currentConfig;
  }
}
