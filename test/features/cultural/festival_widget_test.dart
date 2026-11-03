import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/data/festival_calendar_source.dart';
import 'package:fitkarma/features/cultural/domain/festival_models.dart';
import 'package:fitkarma/features/cultural/domain/festive_food.dart';
import 'package:fitkarma/features/cultural/presentation/festival_banner_card.dart';
import 'package:fitkarma/features/cultural/presentation/festival_detail_sheet.dart';
import 'package:fitkarma/features/cultural/presentation/festival_state_notifier.dart';

class MockActiveFestivalCalendar implements FestivalCalendarSource {
  final FestivalEvent activeEvent;

  MockActiveFestivalCalendar(this.activeEvent);

  @override
  Future<List<FestivalEvent>> getUpcomingFestivals({DateTime? fromDate, int daysLookahead = 30}) async {
    return [activeEvent];
  }

  @override
  Future<FestivalEvent?> getActiveFestival({DateTime? forDate}) async {
    return activeEvent;
  }
}

void main() {
  group('Festival UI & Widget Tests', () {
    late FestivalEvent sampleDiwali;
    late MockActiveFestivalCalendar calendar;

    setUp(() {
      sampleDiwali = FestivalEvent(
        id: 'fest_test_diwali',
        name: 'Diwali (Deepavali)',
        hindiName: 'दीपावली (दिवाली)',
        startDate: DateTime.now().subtract(const Duration(days: 1)),
        endDate: DateTime.now().add(const Duration(days: 2)),
        description: 'Festival of lights celebrating joy and health.',
        culturalGreeting: 'Happy Diwali! Wishing you and your family health and joy.',
        hindiCulturalGreeting: 'शुभ दीपावली! आप सभी को सुख और सेहत की शुभकामनाएं।',
        traditionalFoods: [
          FestiveFood.catalog.firstWhere((f) => f.id == 'food_besan_laddoo'),
        ],
        balanceTips: const ['Enjoy in moderation', 'Stay hydrated'],
      );
      calendar = MockActiveFestivalCalendar(sampleDiwali);
    });

    Widget createTestApp(Widget child) {
      return ProviderScope(
        overrides: [
          festivalCalendarSourceProvider.overrideWithValue(calendar),
        ],
        child: MaterialApp(home: Scaffold(body: child)),
      );
    }

    testWidgets('FestivalBannerCard renders active festival greeting and opens detail sheet', (tester) async {
      await tester.pumpWidget(createTestApp(const FestivalBannerCard()));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('Diwali (Deepavali)'), findsOneWidget);
      expect(find.text('Festival Mode'), findsOneWidget);
      expect(find.text('Happy Diwali! Wishing you and your family health and joy.'), findsOneWidget);

      // Tap Feast Planner
      final plannerBtn = find.text('Feast Planner & Delicacies');
      expect(plannerBtn, findsOneWidget);
      await tester.tap(plannerBtn);
      await tester.pumpAndSettle();

      expect(find.byType(FestivalDetailSheet), findsOneWidget);
      expect(find.text('Traditional Festive Delicacies:'), findsOneWidget);
      expect(find.text('Besan Laddoo'), findsOneWidget);
      expect(find.text('Shame-Free Feast Balance Plan:'), findsOneWidget);
    });

    testWidgets('Muting festival hides the banner card (respects voluntary participation)', (tester) async {
      final notifier = FestivalStateNotifier(calendar);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            festivalStateNotifierProvider.overrideWith((ref) => notifier),
          ],
          child: const MaterialApp(home: Scaffold(body: FestivalBannerCard())),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Initially visible
      expect(find.text('Diwali (Deepavali)'), findsOneWidget);

      // Mute the festival
      notifier.toggleMuteFestival('fest_test_diwali');
      await tester.pump();

      // Now hidden
      expect(find.text('Diwali (Deepavali)'), findsNothing);
    });
  });
}

