// ============================================================================
// PRIVACY-PRESERVING AQI DATA SERVICE & CACHING ENGINE
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../domain/aqi_models.dart';

abstract class AqiDataProvider {
  Future<AqiReading> getAqiForCity(String city);
}

class MockCpcbAqiProvider implements AqiDataProvider {
  static const Map<String, int> cityBaselineAqi = {
    'Delhi NCR': 285,
    'Mumbai': 135,
    'Bengaluru': 68,
    'Kolkata': 240,
    'Chennai': 72,
    'Hyderabad': 118,
    'Pune': 85,
    'Ahmedabad': 165,
    'Lucknow': 320,
    'Jaipur': 155,
    'Patna': 345,
    'Chandigarh': 92,
    'Kochi': 45,
    'Dehradun': 88,
    'Bhopal': 125,
  };

  @override
  Future<AqiReading> getAqiForCity(String city) async {
    final aqi = cityBaselineAqi[city] ?? 120;
    final band = CpcbAqiBand.fromAqi(aqi);

    return AqiReading(
      aqi: aqi,
      category: band.category,
      pm25: aqi * 0.55,
      pm10: aqi * 0.85,
      city: city,
      stationName: '$city Central CPCB Station',
      recordedAt: DateTime.now(),
      isStale: false,
      source: 'CPCB National Air Quality Index (NAQI)',
    );
  }
}

class CachedAqiEntry {
  final AqiReading reading;
  final DateTime cachedAt;

  const CachedAqiEntry({required this.reading, required this.cachedAt});

  bool get isExpired {
    final diff = DateTime.now().difference(cachedAt);
    return diff > const Duration(hours: 2);
  }
}

class AqiService {
  final AqiDataProvider _provider;
  final Map<String, CachedAqiEntry> _cache = {};

  static const List<String> supportedIndianCities = [
    'Delhi NCR',
    'Mumbai',
    'Bengaluru',
    'Kolkata',
    'Chennai',
    'Hyderabad',
    'Pune',
    'Ahmedabad',
    'Lucknow',
    'Jaipur',
    'Patna',
    'Chandigarh',
    'Kochi',
    'Dehradun',
    'Bhopal',
  ];

  static const String defaultCity = 'Delhi NCR';

  AqiService([AqiDataProvider? provider]) : _provider = provider ?? MockCpcbAqiProvider();

  Future<AqiReading> getAqi({String? city, bool forceRefresh = false}) async {
    final targetCity = city ?? defaultCity;

    if (!forceRefresh && _cache.containsKey(targetCity)) {
      final cached = _cache[targetCity]!;
      if (!cached.isExpired) {
        return cached.reading;
      }
    }

    try {
      final freshReading = await _provider.getAqiForCity(targetCity);
      _cache[targetCity] = CachedAqiEntry(reading: freshReading, cachedAt: DateTime.now());
      return freshReading;
    } catch (_) {
      // Fallback to stale cached reading if available
      if (_cache.containsKey(targetCity)) {
        return _cache[targetCity]!.reading.copyWith(isStale: true);
      }

      // Safe offline fallback
      final fallbackBand = CpcbAqiBand.fromAqi(150);
      return AqiReading(
        aqi: 150,
        category: fallbackBand.category,
        city: targetCity,
        recordedAt: DateTime.now(),
        isStale: true,
        source: 'Offline Fallback Estimate',
      );
    }
  }

  void clearCache() {
    _cache.clear();
  }

  CachedAqiEntry? getCachedEntry(String city) => _cache[city];
}

final aqiServiceProvider = Provider<AqiService>((ref) {
  return AqiService();
});
