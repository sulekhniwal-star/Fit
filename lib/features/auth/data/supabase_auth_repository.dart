import 'dart:async';
import 'package:supabase_flutter/supabase_flutter.dart' hide AuthUser;
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/auth_user.dart';
import '../domain/auth_repository.dart';

class SupabaseAuthRepository implements AuthRepository {
  final SupabaseClient _client;

  SupabaseAuthRepository(this._client);

  String _formatIndianPhone(String phoneNumber) {
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length == 10) {
      return '+91$cleaned';
    } else if (cleaned.length == 12 && cleaned.startsWith('91')) {
      return '+$cleaned';
    }
    return phoneNumber;
  }

  @override
  Future<Result<void>> sendPhoneOtp(String phoneNumber) async {
    try {
      final formatted = _formatIndianPhone(phoneNumber);
      await _client.auth.signInWithOtp(phone: formatted);
      return const Result.success(null);
    } on AuthException catch (e) {
      return Result.failure(
        AuthFailure(message: e.message, code: 'FK-1001'),
      );
    } catch (e) {
      return Result.failure(
        AuthFailure(message: e.toString(), code: 'FK-1001'),
      );
    }
  }

  @override
  Future<Result<AuthUser>> verifyPhoneOtp(String phoneNumber, String token) async {
    try {
      final formatted = _formatIndianPhone(phoneNumber);
      final response = await _client.auth.verifyOTP(
        phone: formatted,
        token: token,
        type: OtpType.sms,
      );

      final user = response.user;
      if (user == null) {
        return const Result.failure(
          AuthFailure(message: 'Authentication failed: No user returned.', code: 'FK-1001'),
        );
      }

      return Result.success(
        AuthUser(
          id: user.id,
          phone: user.phone,
          email: user.email,
          createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
        ),
      );
    } on AuthException catch (e) {
      return Result.failure(
        AuthFailure(message: e.message, code: 'FK-1001'),
      );
    } catch (e) {
      return Result.failure(
        AuthFailure(message: e.toString(), code: 'FK-1001'),
      );
    }
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    try {
      final success = await _client.auth.signInWithOAuth(OAuthProvider.google);
      if (!success) {
        return const Result.failure(
          AuthFailure(message: 'Google Sign-In was cancelled or failed.', code: 'FK-1001'),
        );
      }
      final user = _client.auth.currentUser;
      if (user == null) {
        return const Result.failure(
          AuthFailure(message: 'Session establishment pending.', code: 'FK-1001'),
        );
      }
      return Result.success(
        AuthUser(
          id: user.id,
          phone: user.phone,
          email: user.email,
          createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
        ),
      );
    } on AuthException catch (e) {
      return Result.failure(
        AuthFailure(message: e.message, code: 'FK-1001'),
      );
    } catch (e) {
      return Result.failure(
        AuthFailure(message: e.toString(), code: 'FK-1001'),
      );
    }
  }

  @override
  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  @override
  Stream<AuthUser?> get authStateChanges {
    return _client.auth.onAuthStateChange.map((event) {
      final user = event.session?.user;
      if (user == null) return null;
      return AuthUser(
        id: user.id,
        phone: user.phone,
        email: user.email,
        createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
      );
    });
  }

  @override
  AuthUser? get currentUser {
    final user = _client.auth.currentUser;
    if (user == null) return null;
    return AuthUser(
      id: user.id,
      phone: user.phone,
      email: user.email,
      createdAt: DateTime.tryParse(user.createdAt) ?? DateTime.now(),
    );
  }
}

/// In-memory mock auth repository for unit and widget testing without network dependencies.
class MockAuthRepository implements AuthRepository {
  AuthUser? _currentUser;
  final StreamController<AuthUser?> _controller = StreamController<AuthUser?>.broadcast();
  DateTime? _lastOtpSentTime;
  static const int resendCooldownSeconds = 60;

  MockAuthRepository({AuthUser? initialUser}) : _currentUser = initialUser;

  @override
  AuthUser? get currentUser => _currentUser;

  @override
  Stream<AuthUser?> get authStateChanges => _controller.stream;

  @override
  Future<Result<void>> sendPhoneOtp(String phoneNumber) async {
    final cleaned = phoneNumber.replaceAll(RegExp(r'\D'), '');
    if (cleaned.length != 10 && !phoneNumber.startsWith('+91')) {
      return const Result.failure(
        ValidationFailure(message: 'Please enter a valid 10-digit Indian mobile number.'),
      );
    }

    if (_lastOtpSentTime != null) {
      final elapsed = DateTime.now().difference(_lastOtpSentTime!).inSeconds;
      if (elapsed < resendCooldownSeconds) {
        return Result.failure(
          RateLimitFailure(
            message: 'Please wait ${resendCooldownSeconds - elapsed}s before requesting a new OTP.',
            retryAfterSeconds: resendCooldownSeconds - elapsed,
          ),
        );
      }
    }

    _lastOtpSentTime = DateTime.now();
    return const Result.success(null);
  }

  @override
  Future<Result<AuthUser>> verifyPhoneOtp(String phoneNumber, String token) async {
    if (token != '123456') {
      return const Result.failure(
        AuthFailure(message: 'Invalid or expired OTP token.', code: 'FK-1001'),
      );
    }

    final user = AuthUser(
      id: 'mock-user-id-${phoneNumber.replaceAll(RegExp(r'\D'), '')}',
      phone: phoneNumber.startsWith('+91') ? phoneNumber : '+91$phoneNumber',
      createdAt: DateTime.now(),
    );

    _currentUser = user;
    _controller.add(user);
    return Result.success(user);
  }

  @override
  Future<Result<AuthUser>> signInWithGoogle() async {
    final user = AuthUser(
      id: 'mock-google-user-id',
      email: 'user@fitkarma.in',
      createdAt: DateTime.now(),
    );
    _currentUser = user;
    _controller.add(user);
    return Result.success(user);
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}
