import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'app/router/app_router.dart';
import 'core/config/app_config.dart';
import 'core/providers/app_providers.dart';

void main() {
  final config = AppConfig.development();

  runApp(
    ProviderScope(
      overrides: [
        appConfigProvider.overrideWithValue(config),
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

    return MaterialApp.router(
      title: 'FitKarma',
      debugShowCheckedModeBanner: config.isDevelopment,
      routerConfig: router,
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

