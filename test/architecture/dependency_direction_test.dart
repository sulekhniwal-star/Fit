import 'dart:io';

import 'package:fitkarma/app/fitkarma_app.dart';
import 'package:fitkarma/core/config/app_config.dart';
import 'package:fitkarma/core/providers/app_providers.dart';
import 'package:fitkarma/shared/presentation/widgets/bento_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Architectural Dependency Direction Rules', () {
    List<File> listDartFiles(Directory dir) {
      return dir
          .listSync(recursive: true)
          .whereType<File>()
          .where((f) => f.path.endsWith('.dart'))
          .toList();
    }

    test('Rule: lib/core must never import from features/ or shared/', () {
      final coreDir = Directory('lib/core');
      final coreFiles = listDartFiles(coreDir);
      expect(coreFiles, isNotEmpty);

      for (final file in coreFiles) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('import ')) {
            expect(
              trimmed.contains('/features/'),
              isFalse,
              reason:
                  'File ${file.path} violates architecture: core imports features in "$line"',
            );
            expect(
              trimmed.contains('/shared/'),
              isFalse,
              reason:
                  'File ${file.path} violates architecture: core imports shared in "$line"',
            );
          }
        }
      }
    });

    test('Rule: lib/shared must never import from features/', () {
      final sharedDir = Directory('lib/shared');
      final sharedFiles = listDartFiles(sharedDir);
      expect(sharedFiles, isNotEmpty);

      for (final file in sharedFiles) {
        final content = file.readAsStringSync();
        final lines = content.split('\n');

        for (final line in lines) {
          final trimmed = line.trim();
          if (trimmed.startsWith('import ')) {
            expect(
              trimmed.contains('/features/'),
              isFalse,
              reason:
                  'File ${file.path} violates architecture: shared imports features in "$line"',
            );
          }
        }
      }
    });

    test('All architectural root directories exist', () {
      expect(Directory('lib/app').existsSync(), isTrue);
      expect(Directory('lib/core').existsSync(), isTrue);
      expect(Directory('lib/shared').existsSync(), isTrue);
      expect(Directory('lib/features').existsSync(), isTrue);

      final expectedFeatures = [
        'auth',
        'profile',
        'dashboard',
        'nutrition',
        'health_tracking',
        'family',
        'payments',
        'data_vault',
      ];

      for (final feature in expectedFeatures) {
        expect(
          Directory('lib/features/$feature').existsSync(),
          isTrue,
          reason: 'Feature directory lib/features/$feature must exist',
        );
      }
    });
  });

  group('Shared Widgets & App Smoke Test', () {
    testWidgets('BentoCard renders child and responds to tap', (
      WidgetTester tester,
    ) async {
      var tapped = false;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BentoCard(
              onTap: () => tapped = true,
              child: const Text('Bento Content'),
            ),
          ),
        ),
      );

      expect(find.text('Bento Content'), findsOneWidget);
      await tester.tap(find.byType(BentoCard));
      await tester.pump();

      expect(tapped, isTrue);
    });

    testWidgets('FitKarmaApp mounts with dark theme scaffold', (
      WidgetTester tester,
    ) async {
      const config = AppConfig(
        environment: AppEnvironment.development,
        supabaseUrl: 'https://placeholder.supabase.co',
        supabaseAnonKey: 'placeholder-anon-key',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [appConfigProvider.overrideWithValue(config)],
          child: const FitKarmaApp(),
        ),
      );
      expect(find.text('FitKarma'), findsOneWidget);
    });
  });
}
