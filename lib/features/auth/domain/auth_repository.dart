import '../../../core/errors/result.dart';
import 'auth_user.dart';

abstract class AuthRepository {
  /// Sends a one-time password to the specified 10-digit Indian phone number (+91).
  Future<Result<void>> sendPhoneOtp(String phoneNumber);

  /// Verifies a 6-digit OTP token for the specified phone number.
  Future<Result<AuthUser>> verifyPhoneOtp(String phoneNumber, String token);

  /// Initiates Google OAuth sign-in flow.
  Future<Result<AuthUser>> signInWithGoogle();

  /// Terminates the current session and purges local credentials.
  Future<void> signOut();

  /// Real-time stream of authentication state changes.
  Stream<AuthUser?> get authStateChanges;

  /// Returns the currently authenticated user, or null if unauthenticated.
  AuthUser? get currentUser;
}

