import 'package:fitkarma/app/bootstrap.dart';
import 'package:fitkarma/app/fitkarma_app.dart';
import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/core/providers/app_state_observer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  await bootstrap();
  final config = AppConfig.fromEnvironment();

  runApp(
    ProviderScope(
      observers: const [AppProviderObserver()],
      overrides: [appConfigProvider.overrideWithValue(config)],
      child: const FitKarmaApp(),
    ),
  );
}
