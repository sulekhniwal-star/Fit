// ============================================================================
// FESTIVAL STATE NOTIFIER & PARTICIPATION MANAGER (RIVERPOD 2.X)
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../data/festival_calendar_source.dart';
import '../domain/festival_models.dart';

class FestivalState {
  final FestivalEvent? activeFestival;
  final List<FestivalEvent> upcomingFestivals;
  final Set<String> mutedFestivalIds;
  final bool isLoading;
  final String? error;

  const FestivalState({
    this.activeFestival,
    this.upcomingFestivals = const [],
    this.mutedFestivalIds = const {},
    this.isLoading = false,
    this.error,
  });

  bool get hasActiveFestival =>
      activeFestival != null && !mutedFestivalIds.contains(activeFestival!.id);

  FestivalState copyWith({
    FestivalEvent? activeFestival,
    bool clearActiveFestival = false,
    List<FestivalEvent>? upcomingFestivals,
    Set<String>? mutedFestivalIds,
    bool? isLoading,
    String? error,
  }) {
    return FestivalState(
      activeFestival: clearActiveFestival ? null : (activeFestival ?? this.activeFestival),
      upcomingFestivals: upcomingFestivals ?? this.upcomingFestivals,
      mutedFestivalIds: mutedFestivalIds ?? this.mutedFestivalIds,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FestivalStateNotifier extends StateNotifier<FestivalState> {
  final FestivalCalendarSource _calendarSource;

  FestivalStateNotifier(this._calendarSource) : super(const FestivalState()) {
    loadFestivals();
  }

  Future<void> loadFestivals({DateTime? forDate}) async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      final active = await _calendarSource.getActiveFestival(forDate: forDate);
      final upcoming = await _calendarSource.getUpcomingFestivals(fromDate: forDate);

      state = state.copyWith(
        activeFestival: active,
        clearActiveFestival: active == null,
        upcomingFestivals: upcoming,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to load festivals: $e',
        isLoading: false,
      );
    }
  }

  void toggleMuteFestival(String festivalId) {
    final updatedMuted = Set<String>.from(state.mutedFestivalIds);
    if (updatedMuted.contains(festivalId)) {
      updatedMuted.remove(festivalId);
    } else {
      updatedMuted.add(festivalId);
    }
    state = state.copyWith(mutedFestivalIds: updatedMuted);
  }

  bool isMuted(String festivalId) => state.mutedFestivalIds.contains(festivalId);
}

final festivalStateNotifierProvider = StateNotifierProvider<FestivalStateNotifier, FestivalState>((ref) {
  final source = ref.watch(festivalCalendarSourceProvider);
  return FestivalStateNotifier(source);
});

