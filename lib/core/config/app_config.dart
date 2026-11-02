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
}

