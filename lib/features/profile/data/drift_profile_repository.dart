import 'dart:convert';
import 'package:drift/drift.dart';
import '../../../core/database/app_database.dart';
import '../../../core/errors/failures.dart';
import '../../../core/errors/result.dart';
import '../../../core/sync/models/outbox_mutation.dart';
import '../../../core/sync/outbox_queue.dart';
import '../../../core/sync/syncable_repository.dart';
import '../domain/dosha_calculator.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class DriftProfileRepository extends SyncableRepository<UserProfile, String>
    implements ProfileRepository {
  final AppDatabase _db;

  DriftProfileRepository(this._db, OutboxQueue outboxQueue) : super(outboxQueue);

  @override
  String get entityType => 'user_profiles';

  @override
  Future<Result<UserProfile>> getProfile(String userId) => getLocal(userId);

  @override
  Future<Result<void>> saveProfile(UserProfile profile) => saveLocal(profile);

  @override
  Future<Result<void>> deleteProfile(String userId) => deleteLocal(userId);

  @override
  Future<Result<UserProfile>> getLocal(String id) async {
    final row = await (_db.select(_db.localUserProfiles)
          ..where((tbl) => tbl.userId.equals(id)))
        .getSingleOrNull();

    if (row == null) {
      return const Result.failure(
        ValidationFailure(message: 'User profile not found.'),
      );
    }

    return Result.success(_fromRow(row));
  }

  @override
  Future<Result<void>> saveLocal(UserProfile profile) async {
    if (!profile.hasValidBiometrics) {
      return const Result.failure(
        ValidationFailure(message: 'Invalid biometric parameters provided.'),
      );
    }

    await _db.into(_db.localUserProfiles).insertOnConflictUpdate(
          LocalUserProfilesCompanion.insert(
            userId: profile.userId,
            displayName: profile.displayName,
            age: profile.age,
            biologicalSex: profile.biologicalSex.name,
            heightCm: profile.heightCm,
            weightKg: profile.weightKg,
            targetWeightKg: Value(profile.targetWeightKg),
            activityLevel: profile.activityLevel.name,
            dietaryIdentity: profile.dietaryIdentity.name,
            healthGoal: profile.healthGoal.name,
            languageCode: Value(profile.languageCode),
            doshaProfileJson: Value(
              profile.doshaProfile != null ? jsonEncode(profile.doshaProfile!.toJson()) : null,
            ),
            hasAcceptedDpdpConsent: Value(profile.hasAcceptedDpdpConsent),
            updatedAt: profile.updatedAt,
          ),
        );

    // Enqueue outbox mutation
    final idempotencyKey =
        'profile_${profile.userId}_${profile.updatedAt.millisecondsSinceEpoch}';
    final mutation = SyncMutation(
      id: 'mut_prof_${profile.userId}',
      entityType: entityType,
      operation: OutboxOperation.update,
      payload: profile.toJson(),
      idempotencyKey: idempotencyKey,
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> deleteLocal(String id) async {
    await (_db.delete(_db.localUserProfiles)..where((tbl) => tbl.userId.equals(id))).go();

    final mutation = SyncMutation(
      id: 'mut_prof_del_$id',
      entityType: entityType,
      operation: OutboxOperation.delete,
      payload: {'user_id': id},
      idempotencyKey: 'profile_del_${id}_${DateTime.now().millisecondsSinceEpoch}',
      createdAt: DateTime.now(),
    );

    await outboxQueue.enqueue(mutation);
    return const Result.success(null);
  }

  @override
  Future<Result<void>> pushRemote(SyncMutation mutation) async {
    // In production, delegates to Supabase client table upsert.
    return const Result.success(null);
  }

  @override
  Future<Result<int>> pullRemote(DateTime since) async {
    // In production, queries Supabase table where updated_at > since.
    return const Result.success(0);
  }

  UserProfile _fromRow(LocalUserProfile row) {
    DoshaProfile? dosha;
    if (row.doshaProfileJson != null) {
      dosha = DoshaProfile.fromJson(
        jsonDecode(row.doshaProfileJson!) as Map<String, dynamic>,
      );
    }

    return UserProfile(
      userId: row.userId,
      displayName: row.displayName,
      age: row.age,
      biologicalSex: BiologicalSex.values.firstWhere(
        (s) => s.name == row.biologicalSex,
        orElse: () => BiologicalSex.male,
      ),
      heightCm: row.heightCm,
      weightKg: row.weightKg,
      targetWeightKg: row.targetWeightKg,
      activityLevel: ActivityLevel.values.firstWhere(
        (a) => a.name == row.activityLevel,
        orElse: () => ActivityLevel.moderatelyActive,
      ),
      dietaryIdentity: DietaryIdentity.values.firstWhere(
        (d) => d.name == row.dietaryIdentity,
        orElse: () => DietaryIdentity.vegetarian,
      ),
      healthGoal: HealthGoal.values.firstWhere(
        (g) => g.name == row.healthGoal,
        orElse: () => HealthGoal.maintenance,
      ),
      languageCode: row.languageCode,
      doshaProfile: dosha,
      hasAcceptedDpdpConsent: row.hasAcceptedDpdpConsent,
      updatedAt: row.updatedAt,
    );
  }
}
