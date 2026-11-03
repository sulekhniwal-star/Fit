enum AppEnvironment {
  development,
  staging,
  production,
}

class AppConfig {
  final AppEnvironment environment;
  final String supabaseUrl;
  final String supabaseAnonKey;
  final String? sentryDsn;

  const AppConfig({
    required this.environment,
    required this.supabaseUrl,
    required this.supabaseAnonKey,
    this.sentryDsn,
  });

  bool get isDevelopment => environment == AppEnvironment.development;
  bool get isProduction => environment == AppEnvironment.production;

  factory AppConfig.development({
    String supabaseUrl = 'https://localhost:54321',
    String supabaseAnonKey = 'mock-anon-key',
    String? sentryDsn,
  }) {
    return AppConfig(
      environment: AppEnvironment.development,
      supabaseUrl: supabaseUrl,
      supabaseAnonKey: supabaseAnonKey,
      sentryDsn: sentryDsn,
    );
  }

  factory AppConfig.fromEnvironment() {
    const envStr = String.fromEnvironment('APP_ENV', defaultValue: 'development');
    final environment = AppEnvironment.values.firstWhere(
      (e) => e.name == envStr,
      orElse: () => AppEnvironment.development,
    );
    const url = String.fromEnvironment('SUPABASE_URL', defaultValue: 'https://localhost:54321');
    const anonKey = String.fromEnvironment('SUPABASE_ANON_KEY', defaultValue: 'mock-anon-key');
    const sentry = String.fromEnvironment('SENTRY_DSN', defaultValue: '');

    return AppConfig(
      environment: environment,
      supabaseUrl: url,
      supabaseAnonKey: anonKey,
      sentryDsn: sentry.isNotEmpty ? sentry : null,
    );
  }
}
