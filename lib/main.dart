import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return MaterialApp(
      title: 'FitKarma',
      debugShowCheckedModeBanner: config.isDevelopment,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0D0F12),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF22C55E),
          surface: Color(0xFF16191E),
        ),
        useMaterial3: true,
      ),
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'FitKarma Health OS',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Env: ${config.environment.name}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
