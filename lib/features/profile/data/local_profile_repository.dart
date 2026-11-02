import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class LocalProfileRepository implements ProfileRepository {
  final Map<String, UserProfile> _storage = {};

  LocalProfileRepository([Map<String, UserProfile>? initialData]) {
    if (initialData != null) {
      _storage.addAll(initialData);
    }
  }

  @override
  Future<Result<UserProfile>> getProfile(String userId) async {
    final profile = _storage[userId];
    if (profile == null) {
      return const Result.failure(
        ValidationFailure(message: 'User profile not found.'),
      );
    }
    return Result.success(profile);
  }

  @override
  Future<Result<void>> saveProfile(UserProfile profile) async {
    if (!profile.hasValidBiometrics) {
      return const Result.failure(
        ValidationFailure(message: 'Invalid biometric parameters provided.'),
      );
    }
    _storage[profile.userId] = profile;
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteProfile(String userId) async {
    _storage.remove(userId);
    return const Result.success(null);
  }

  void clear() {
    _storage.clear();
  }
}

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return LocalProfileRepository();
});

