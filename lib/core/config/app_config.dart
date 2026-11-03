/// FitKarma Core Configuration and Security Boundary
///
/// Ensures strict separation between public client variables and server-only secrets.
/// Throws [SecurityViolationException] if any prohibited secret is detected.
library;

enum AppEnvironment {
  development,
  staging,
  production;

  static AppEnvironment fromString(String? value) {
    switch (value?.toLowerCase().trim()) {
      case 'production':
      case 'prod':
        return AppEnvironment.production;
      case 'staging':
      case 'stage':
        return AppEnvironment.staging;
      case 'development':
      case 'dev':
      default:
        return AppEnvironment.development;
    }
  }
}

/// Thrown when a privileged server secret is detected in the client configuration.
class SecurityViolationException implements Exception {
  final String message;
  final String detectedKey;

  const SecurityViolationException({
    required this.message,
    required this.detectedKey,
  });

  @override
  String toString() =>
      'SecurityViolationException: $message (Key: $detectedKey)';
}

/// Configuration container for the FitKarma client application.
class AppConfig {
  final AppEnvironment environment;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String? sentryDsn;
  final bool enableAnalytics;

  const AppConfig({
    required this.environment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.sentryDsn,
    this.enableAnalytics = false,
  });

  /// Known server-only secret keys that MUST NEVER be bundled or passed into the client.
  static const List<String> prohibitedServerKeys = [
    'SUPABASE_SERVICE_ROLE_KEY',
    'RAZORPAY_KEY_SECRET',
    'RAZORPAY_WEBHOOK_SECRET',
    'GROQ_API_KEY',
    'WHATSAPP_ACCESS_TOKEN',
    'WHATSAPP_WEBHOOK_VERIFY_TOKEN',
  ];

  /// Creates an [AppConfig] instance from a configuration map (e.g. from .env or map),
  /// validating that no server secrets are present.
  factory AppConfig.fromMap(Map<String, String> map) {
    // 1. Secret boundary check: Reject any prohibited server secret
    for (final prohibitedKey in prohibitedServerKeys) {
      final value = map[prohibitedKey];
      if (value != null && value.trim().isNotEmpty) {
        throw SecurityViolationException(
          message:
              'Server secret detected in client configuration! '
              'This is a severe security violation.',
          detectedKey: prohibitedKey,
        );
      }
    }

    final envString = map['APP_ENV'] ?? 'development';
    final environment = AppEnvironment.fromString(envString);

    final supabaseUrl = map['SUPABASE_URL']?.trim() ?? '';
    if (supabaseUrl.isEmpty) {
      throw ArgumentError('SUPABASE_URL must not be empty.');
    }

    final supabaseAnonKey = map['SUPABASE_ANON_KEY']?.trim() ?? '';
    if (supabaseAnonKey.isEmpty) {
      throw ArgumentError('SUPABASE_ANON_KEY must not be empty.');
    }

    final sentryDsn = map['SENTRY_DSN']?.trim();
    final enableAnalytics = map['ENABLE_ANALYTICS']?.toLowerCase() == 'true';

    return AppConfig(
      environment: environment,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      sentryDsn: (sentryDsn != null && sentryDsn.isNotEmpty) ? sentryDsn : null,
      enableAnalytics: enableAnalytics,
    );
  }

  /// Creates an [AppConfig] instance using compile-time environment variables (`--dart-define`).
  factory AppConfig.fromEnvironment() {
    const env = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    const supabaseUrl = String.fromEnvironment('SUPABASE_URL');
    const supabaseAnonKey = String.fromEnvironment('SUPABASE_ANON_KEY');
    const sentryDsn = String.fromEnvironment('SENTRY_DSN');
    const enableAnalytics = bool.fromEnvironment(
      'ENABLE_ANALYTICS',
      defaultValue: false,
    );

    // Verify compile-time checks for prohibited keys
    const serviceRole = String.fromEnvironment('SUPABASE_SERVICE_ROLE_KEY');
    if (serviceRole.isNotEmpty) {
      throw const SecurityViolationException(
        message: 'SUPABASE_SERVICE_ROLE_KEY injected into client binary via --dart-define!',
        detectedKey: 'SUPABASE_SERVICE_ROLE_KEY',
      );
    }

    const razorpaySecret = String.fromEnvironment('RAZORPAY_KEY_SECRET');
    if (razorpaySecret.isNotEmpty) {
      throw const SecurityViolationException(
        message: 'RAZORPAY_KEY_SECRET injected into client binary via --dart-define!',
        detectedKey: 'RAZORPAY_KEY_SECRET',
      );
    }

    return AppConfig(
      environment: AppEnvironment.fromString(env),
      supabaseUrl: supabaseUrl.isNotEmpty
          ? supabaseUrl
          : 'https://placeholder.supabase.co',
      supabaseAnonKey: supabaseAnonKey.isNotEmpty
          ? supabaseAnonKey
          : 'placeholder-anon-key',
      sentryDsn: sentryDsn.isNotEmpty ? sentryDsn : null,
      enableAnalytics: enableAnalytics,
    );
  }

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isStaging => environment == AppEnvironment.staging;
  bool get isProduction => environment == AppEnvironment.production;
}
