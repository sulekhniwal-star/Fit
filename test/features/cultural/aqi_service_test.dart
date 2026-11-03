import 'package:flutter_test/flutter_test.dart';
import 'package:fitkarma/features/cultural/data/aqi_service.dart';
import 'package:fitkarma/features/cultural/domain/aqi_models.dart';

class FailingAqiProvider implements AqiDataProvider {
  @override
  Future<AqiReading> getAqiForCity(String city) async {
    throw Exception('Network connection timed out');
  }
}

void main() {
  group('AQI Service & Caching Tests', () {
    test('MockCpcbAqiProvider returns realistic CPCB data for Indian cities', () async {
      final provider = MockCpcbAqiProvider();

      final delhi = await provider.getAqiForCity('Delhi NCR');
      expect(delhi.aqi, 285);
      expect(delhi.category, CpcbAqiCategory.poor);

      final bengaluru = await provider.getAqiForCity('Bengaluru');
      expect(bengaluru.aqi, 68);
      expect(bengaluru.category, CpcbAqiCategory.satisfactory);

      final unknown = await provider.getAqiForCity('SmallTown');
      expect(unknown.aqi, 120);
    });

    test('AqiService caches readings and returns cached value on subsequent calls', () async {
      final service = AqiService(MockCpcbAqiProvider());

      final reading1 = await service.getAqi(city: 'Mumbai');
      expect(reading1.aqi, 135);

      final cached = service.getCachedEntry('Mumbai');
      expect(cached, isNotNull);
      expect(cached!.isExpired, isFalse);

      final reading2 = await service.getAqi(city: 'Mumbai');
      expect(identical(reading1, reading2), isTrue);
    });

    test('AqiService falls back gracefully to stale or default data when provider fails', () async {
      final failingService = AqiService(FailingAqiProvider());

      final fallback = await failingService.getAqi(city: 'Jaipur');
      expect(fallback.isStale, isTrue);
      expect(fallback.city, 'Jaipur');
      expect(fallback.source, contains('Offline Fallback'));
    });
  });
}
