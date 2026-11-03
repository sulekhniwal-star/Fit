import 'package:flutter/widgets.dart';

/// Pre-run initialization hook for services, environment, and error tracking.
Future<void> bootstrap() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Future initialization (Sentry, Riverpod container, Drift local database) wires here.
}
