// ============================================================================
// AQI STATE NOTIFIER (RIVERPOD 2.X)
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/aqi_service.dart';
import '../domain/aqi_models.dart';
import '../domain/aqi_workout_advisory.dart';

class AqiState {
  final String selectedCity;
  final AqiReading? currentReading;
  final AqiWorkoutAdvisory? currentAdvisory;
  final bool isLoading;
  final String? error;

  const AqiState({
    this.selectedCity = AqiService.defaultCity,
    this.currentReading,
    this.currentAdvisory,
    this.isLoading = false,
    this.error,
  });

  bool get isOutdoorSafe => currentReading?.isOutdoorSafe ?? true;

  AqiState copyWith({
    String? selectedCity,
    AqiReading? currentReading,
    AqiWorkoutAdvisory? currentAdvisory,
    bool? isLoading,
    String? error,
  }) {
    return AqiState(
      selectedCity: selectedCity ?? this.selectedCity,
      currentReading: currentReading ?? this.currentReading,
      currentAdvisory: currentAdvisory ?? this.currentAdvisory,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class AqiStateNotifier extends StateNotifier<AqiState> {
  final AqiService _service;

  AqiStateNotifier(this._service) : super(const AqiState()) {
    loadAqi();
  }

  Future<void> loadAqi({String? city, bool forceRefresh = false}) async {
    final targetCity = city ?? state.selectedCity;
    state = state.copyWith(isLoading: true, error: null, selectedCity: targetCity);

    try {
      final reading = await _service.getAqi(city: targetCity, forceRefresh: forceRefresh);
      final advisory = AqiWorkoutAdvisory.generateAdvisory(reading);

      state = state.copyWith(
        currentReading: reading,
        currentAdvisory: advisory,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch AQI data: $e',
        isLoading: false,
      );
    }
  }

  Future<void> selectCity(String city) async {
    if (city == state.selectedCity && state.currentReading != null) return;
    await loadAqi(city: city);
  }

  Future<void> refresh() async {
    await loadAqi(city: state.selectedCity, forceRefresh: true);
  }
}

final aqiStateNotifierProvider = StateNotifierProvider<AqiStateNotifier, AqiState>((ref) {
  final service = ref.watch(aqiServiceProvider);
  return AqiStateNotifier(service);
});

