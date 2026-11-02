import 'package:fitkarma/shared/widgets/app_scaffold.dart';
import 'package:fitkarma/shared/widgets/offline_banner.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AppScaffold Tests (TASK 012)', () {
    testWidgets('AppScaffold shows offline banner when isOffline is true', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            isOffline: true,
            offlineMessage: 'Custom Offline Banner',
            body: Center(child: Text('Scaffold Content')),
          ),
        ),
      );

      expect(find.byType(OfflineBanner), findsOneWidget);
      expect(find.text('Custom Offline Banner'), findsOneWidget);
      expect(find.text('Scaffold Content'), findsOneWidget);
    });

    testWidgets('AppScaffold hides offline banner when isOffline is false', (WidgetTester tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: AppScaffold(
            isOffline: false,
            body: Center(child: Text('Scaffold Content')),
          ),
        ),
      );

      expect(find.byType(OfflineBanner), findsNothing);
      expect(find.text('Scaffold Content'), findsOneWidget);
    });
  });
}

