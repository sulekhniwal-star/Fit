import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/data/festival_calendar_source.dart';
import 'package:fitkarma/features/cultural/domain/festival_models.dart';

class CustomTestCalendar implements FestivalCalendarSource {
  final FestivalEvent customFestival;

  CustomTestCalendar(this.customFestival);

  @override
  Future<List<FestivalEvent>> getUpcomingFestivals({DateTime? fromDate, int daysLookahead = 30}) async {
    return [customFestival];
  }

  @override
  Future<FestivalEvent?> getActiveFestival({DateTime? forDate}) async {
    return customFestival;
  }
}

void main() {
  group('Festival Calendar Source Tests', () {
    test('StaticIndianFestivalCalendar returns Diwali when date falls in early November', () async {
      final calendar = StaticIndianFestivalCalendar();
      final diwaliDate = DateTime(2026, 11, 2);

      final active = await calendar.getActiveFestival(forDate: diwaliDate);
      expect(active, isNotNull);
      expect(active!.name, contains('Diwali'));
      expect(active.hindiName, contains('दीपावली'));
      expect(active.traditionalFoods, isNotEmpty);
      expect(active.balanceTips, isNotEmpty);
    });

    test('StaticIndianFestivalCalendar returns Holi when date is early March', () async {
      final calendar = StaticIndianFestivalCalendar();
      final holiDate = DateTime(2026, 3, 3);

      final active = await calendar.getActiveFestival(forDate: holiDate);
      expect(active, isNotNull);
      expect(active!.name, contains('Holi'));
    });

    test('Upcoming festivals lookahead retrieves events within specified window', () async {
      final calendar = StaticIndianFestivalCalendar();
      final date = DateTime(2026, 10, 1);

      final upcoming = await calendar.getUpcomingFestivals(fromDate: date, daysLookahead: 35);
      expect(upcoming, isNotEmpty);
      expect(upcoming.any((f) => f.id == 'fest_navratri_sharad'), isTrue);
    });

    test('Replaceable calendar abstraction: can substitute custom calendar source', () async {
      final testEvent = FestivalEvent(
        id: 'fest_custom_harvest',
        name: 'Regional Harvest Feast',
        hindiName: 'फसल उत्सव',
        startDate: DateTime(2026, 5, 1),
        endDate: DateTime(2026, 5, 2),
        description: 'Local harvest thanksgiving',
        culturalGreeting: 'Happy Harvest!',
        hindiCulturalGreeting: 'शुभ फसल उत्सव!',
        traditionalFoods: const [],
        balanceTips: const ['Hydrate well'],
      );

      final customSource = CustomTestCalendar(testEvent);
      final active = await customSource.getActiveFestival(forDate: DateTime(2026, 5, 1));

      expect(active, isNotNull);
      expect(active!.id, 'fest_custom_harvest');
      expect(active.name, 'Regional Harvest Feast');
    });
  });
}

