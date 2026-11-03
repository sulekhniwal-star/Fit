import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test Helpers and Widget Pump Utilities for FitKarma.
extension WidgetTesterX on WidgetTester {
  /// Pumps a widget wrapped in ProviderScope and MaterialApp with dark theme baseline.
  Future<void> pumpFitKarmaWidget(
    Widget widget, {
    List<Override> overrides = const [],
    AppConfig? config,
  }) async {
    final effectiveConfig = config ?? AppConfig.fromEnvironment();

    await pumpWidget(
      ProviderScope(
        overrides: [
          appConfigProvider.overrideWithValue(effectiveConfig),
          ...overrides,
        ],
        child: MaterialApp(theme: ThemeData.dark(), home: widget),
      ),
    );
  }
}
