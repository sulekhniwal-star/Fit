import 'package:supabase_flutter/supabase_flutter.dart';
import '../config/app_config.dart';

/// Service managing Supabase client initialization and lifecycle.
class SupabaseService {
  SupabaseClient? _client;

  SupabaseService([this._client]);

  /// True if Supabase client is initialized and ready for operations.
  bool get isInitialized => _client != null;

  /// Returns the underlying [SupabaseClient]. Throws [StateError] if uninitialized.
  SupabaseClient get client {
    final active = _client;
    if (active == null) {
      throw StateError('SupabaseService has not been initialized. Call initialize() first.');
    }
    return active;
  }

  /// Initializes Supabase using the provided [AppConfig].
  Future<void> initialize(AppConfig config) async {
    if (_client != null) return;

    final instance = await Supabase.initialize(
      url: config.supabaseUrl,
      anonKey: config.supabaseAnonKey, // ignore: deprecated_member_use
      authOptions: const FlutterAuthClientOptions(
        authFlowType: AuthFlowType.pkce,
      ),
    );
    _client = instance.client;
  }
}

