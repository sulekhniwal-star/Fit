import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/services/supabase_service.dart';
import '../data/supabase_auth_repository.dart';
import '../domain/auth_repository.dart';
import '../domain/auth_user.dart';

sealed class AuthState {
  const AuthState();
}

class AuthUnauthenticated extends AuthState {
  const AuthUnauthenticated();
}

class AuthOtpSent extends AuthState {
  final String phoneNumber;
  final int resendCooldownSeconds;

  const AuthOtpSent({
    required this.phoneNumber,
    this.resendCooldownSeconds = 60,
  });
}

class AuthAuthenticating extends AuthState {
  const AuthAuthenticating();
}

class AuthAuthenticated extends AuthState {
  final AuthUser user;
  const AuthAuthenticated(this.user);
}

class AuthErrorState extends AuthState {
  final Failure failure;
  const AuthErrorState(this.failure);
}

/// Provider for the Supabase service instance.
final supabaseServiceProvider = Provider<SupabaseService>((ref) {
  return SupabaseService();
});

/// Auth repository provider (can be overridden with [MockAuthRepository] in tests).
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final service = ref.watch(supabaseServiceProvider);
  if (!service.isInitialized) {
    // Fall back to MockAuthRepository if Supabase hasn't been initialized
    return MockAuthRepository();
  }
  return SupabaseAuthRepository(service.client);
});

class AuthStateNotifier extends StateNotifier<AuthState> {
  final AuthRepository _repository;
  StreamSubscription<AuthUser?>? _subscription;

  AuthStateNotifier(this._repository) : super(const AuthUnauthenticated()) {
    final current = _repository.currentUser;
    if (current != null) {
      state = AuthAuthenticated(current);
    }

    _subscription = _repository.authStateChanges.listen((user) {
      if (user != null) {
        state = AuthAuthenticated(user);
      } else {
        state = const AuthUnauthenticated();
      }
    });
  }

  Future<void> sendOtp(String phoneNumber) async {
    state = const AuthAuthenticating();
    final result = await _repository.sendPhoneOtp(phoneNumber);
    result.when(
      onSuccess: (_) {
        state = AuthOtpSent(phoneNumber: phoneNumber);
      },
      onFailure: (failure) {
        state = AuthErrorState(failure);
      },
    );
  }

  Future<void> verifyOtp(String phoneNumber, String token) async {
    state = const AuthAuthenticating();
    final result = await _repository.verifyPhoneOtp(phoneNumber, token);
    result.when(
      onSuccess: (user) {
        state = AuthAuthenticated(user);
      },
      onFailure: (failure) {
        state = AuthErrorState(failure);
      },
    );
  }

  Future<void> signInWithGoogle() async {
    state = const AuthAuthenticating();
    final result = await _repository.signInWithGoogle();
    result.when(
      onSuccess: (user) {
        state = AuthAuthenticated(user);
      },
      onFailure: (failure) {
        state = AuthErrorState(failure);
      },
    );
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AuthUnauthenticated();
  }

  void resetError() {
    if (state is AuthErrorState) {
      state = const AuthUnauthenticated();
    }
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }
}

final authStateNotifierProvider = StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final repository = ref.watch(authRepositoryProvider);
  return AuthStateNotifier(repository);
});

