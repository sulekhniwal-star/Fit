import '../../../core/errors/result.dart';
import 'user_profile.dart';

abstract class ProfileRepository {
  /// Retrieves user profile by userId.
  Future<Result<UserProfile>> getProfile(String userId);

  /// Saves or updates the user's profile.
  Future<Result<void>> saveProfile(UserProfile profile);

  /// Permanently removes profile data (DPDP Act erasure compliance).
  Future<Result<void>> deleteProfile(String userId);
}
