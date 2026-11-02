import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/core/sync/conflict/conflict_resolution.dart';
import 'package:fitkarma/core/sync/presentation/conflict_resolution_dialog.dart';

void main() {
  group('ConflictResolver Logic Tests', () {
    const resolver = ConflictResolver();
    final conflict = ConflictData<String>(
      entityType: 'user_profile',
      entityId: 'u1',
      clientVersion: 'Local Rahul (weight: 72kg)',
      serverVersion: 'Server Rahul (weight: 70kg)',
      clientTimestamp: DateTime(2026, 11, 2, 10, 0),
      serverTimestamp: DateTime(2026, 11, 2, 10, 5),
    );

    test('resolves keepClient to clientVersion', () {
      final result = resolver.resolve(
        conflict: conflict,
        choice: ConflictResolutionChoice.keepClient,
      );
      expect(result, equals('Local Rahul (weight: 72kg)'));
    });

    test('resolves keepServer to serverVersion', () {
      final result = resolver.resolve(
        conflict: conflict,
        choice: ConflictResolutionChoice.keepServer,
      );
      expect(result, equals('Server Rahul (weight: 70kg)'));
    });

    test('resolves merge using custom strategy', () {
      final result = resolver.resolve(
        conflict: conflict,
        choice: ConflictResolutionChoice.merge,
        customMergeStrategy: (client, server) => '$client + $server',
      );
      expect(result, equals('Local Rahul (weight: 72kg) + Server Rahul (weight: 70kg)'));
    });
  });

  group('ConflictResolutionDialog Widget Tests', () {
    testWidgets('renders conflict dialog and selects keepClient', (tester) async {
      final conflict = ConflictData<String>(
        entityType: 'user_profile',
        entityId: 'u1',
        clientVersion: 'Local weight: 75kg',
        serverVersion: 'Server weight: 73kg',
        clientTimestamp: DateTime.now(),
        serverTimestamp: DateTime.now(),
      );

      ConflictResolutionChoice? selectedChoice;

      await tester.pumpWidget(
        MaterialApp(
          home: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showDialog<void>(
                    context: context,
                    builder: (context) => ConflictResolutionDialog<String>(
                      conflict: conflict,
                      onResolved: (choice) => selectedChoice = choice,
                    ),
                  );
                },
                child: const Text('Open Dialog'),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('Open Dialog'));
      await tester.pumpAndSettle();

      expect(find.text('Data Conflict Detected'), findsOneWidget);
      expect(find.text('Local weight: 75kg'), findsOneWidget);
      expect(find.text('Server weight: 73kg'), findsOneWidget);

      await tester.tap(find.byKey(const Key('keep_client_button')));
      await tester.pumpAndSettle();

      expect(selectedChoice, equals(ConflictResolutionChoice.keepClient));
    });
  });
}
