// ============================================================================
// FASTING STATE NOTIFIER (RIVERPOD 2.X)
// ============================================================================

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/presentation/auth_state_notifier.dart';
import '../data/drift_fasting_repository.dart';
import '../domain/fasting_protocol.dart';
import '../domain/fasting_session.dart';

class FastingState {
  final FastingSession? activeSession;
  final bool isLoading;
  final String? error;

  const FastingState({
    this.activeSession,
    this.isLoading = false,
    this.error,
  });

  bool get isFastingActive => activeSession != null && activeSession!.isActive;

  /// Suppresses irrelevant "You haven't logged food" reminders during active fasting
  bool get shouldSuppressMealReminders => isFastingActive;

  /// Suppresses water drinking alerts only if the fast is Nirjala/dry (Karwa Chauth/Roza)
  bool get shouldSuppressHydrationReminders => isFastingActive && activeSession!.isWaterless;

  FastingState copyWith({
    FastingSession? activeSession,
    bool clearActiveSession = false,
    bool? isLoading,
    String? error,
  }) {
    return FastingState(
      activeSession: clearActiveSession ? null : (activeSession ?? this.activeSession),
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

class FastingStateNotifier extends StateNotifier<FastingState> {
  final DriftFastingRepository _repository;
  final String _userId;

  FastingStateNotifier(this._repository, this._userId) : super(const FastingState()) {
    _loadActiveSession();
  }

  Future<void> _loadActiveSession() async {
    state = state.copyWith(isLoading: true);
    final result = await _repository.getActiveSession(_userId);
    result.when(
      onSuccess: (session) {
        state = state.copyWith(activeSession: session, isLoading: false);
      },
      onFailure: (f) {
        state = state.copyWith(error: f.message, isLoading: false);
      },
    );
  }

  Future<bool> startFast({
    required FastingProtocolType protocolType,
    DateTime? startTime,
    int? customHours,
    bool? isWaterless,
    String? notes,
  }) async {
    state = state.copyWith(isLoading: true, error: null);

    final protocol = FastingProtocol.fromType(protocolType);
    final start = startTime ?? DateTime.now();
    final durationHours = customHours ?? protocol.defaultFastHours;
    final plannedEnd = start.add(Duration(hours: durationHours));
    final waterless = isWaterless ?? protocol.isWaterless;

    final session = FastingSession(
      id: 'fast_${DateTime.now().millisecondsSinceEpoch}',
      userId: _userId,
      protocolType: protocolType,
      startTime: start,
      plannedEndTime: plannedEnd,
      isWaterless: waterless,
      hydrationRemindersEnabled: !waterless,
      notes: notes,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    final result = await _repository.startSession(session);
    return result.when(
      onSuccess: (started) {
        state = state.copyWith(activeSession: started, isLoading: false);
        return true;
      },
      onFailure: (f) {
        state = state.copyWith(error: f.message, isLoading: false);
        return false;
      },
    );
  }

  Future<FastingSession?> endFast({DateTime? endTime}) async {
    final current = state.activeSession;
    if (current == null) return null;

    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.completeSession(current.id, endTime: endTime);
    return result.when(
      onSuccess: (completed) {
        state = state.copyWith(clearActiveSession: true, isLoading: false);
        return completed;
      },
      onFailure: (f) {
        state = state.copyWith(error: f.message, isLoading: false);
        return null;
      },
    );
  }

  Future<bool> cancelFast() async {
    final current = state.activeSession;
    if (current == null) return false;

    state = state.copyWith(isLoading: true, error: null);
    final result = await _repository.cancelSession(current.id);
    return result.when(
      onSuccess: (_) {
        state = state.copyWith(clearActiveSession: true, isLoading: false);
        return true;
      },
      onFailure: (f) {
        state = state.copyWith(error: f.message, isLoading: false);
        return false;
      },
    );
  }
}

final fastingStateNotifierProvider = StateNotifierProvider<FastingStateNotifier, FastingState>((ref) {
  final repo = ref.watch(fastingRepositoryProvider);
  final authState = ref.watch(authStateNotifierProvider);
  final userId = authState is AuthAuthenticated ? authState.user.id : 'default_user';
  return FastingStateNotifier(repo, userId);
});

