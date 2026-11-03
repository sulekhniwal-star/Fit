import 'package:fitkarma/core/config/remote_config.dart';

/// Contract boundary for remote configuration fetching, caching, and evaluation.
abstract interface class RemoteConfigServiceContract {
  Future<RemoteConfig> fetchRemoteConfig();
  RemoteConfig get currentConfig;
  Future<void> saveToCache(RemoteConfig config);
  Future<RemoteConfig> loadFromCache();
}
