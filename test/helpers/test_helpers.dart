import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

/// Test Helpers and Widget Pump Utilities for FitKarma.
extension WidgetTesterX on WidgetTester {
  /// Pumps a widget wrapped in MaterialApp with dark theme baseline.
  Future<void> pumpFitKarmaWidget(Widget widget) async {
    await pumpWidget(MaterialApp(theme: ThemeData.dark(), home: widget));
  }
}
