import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'core/config/app_config.dart';
import 'core/localization/app_localizations.dart';
import 'core/localization/locale_provider.dart';
import 'core/providers/app_providers.dart';
import 'core/services/supabase_service.dart';
import 'features/auth/presentation/auth_state_notifier.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final config = AppConfig.fromEnvironment();
  final supabaseService = SupabaseService();

  // Initialize Supabase if a non-placeholder remote URL is configured
  if (!config.supabaseUrl.contains('localhost') && config.supabaseAnonKey != 'mock-anon-key') {
    try {
      await supabaseService.initialize(config);
    } catch (_) {
      // Gracefully continue in offline mode if network is initially unavailable
    }
  }

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
        supabaseServiceProvider.overrideWithValue(supabaseService),
      ],
      child: const FitKarmaApp(),
    ),
  );
}

class FitKarmaApp extends ConsumerWidget {
  const FitKarmaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(appConfigProvider);
    final router = ref.watch(appRouterProvider);
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: config.isDevelopment,
      routerConfig: router,
      locale: currentLocale,
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizationsDelegate(),
        DefaultMaterialLocalizations.delegate,
        DefaultWidgetsLocalizations.delegate,
      ],
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Color(0xFF16191E),
        ),
        useMaterial3: true,
      ),
    );
  }
}
