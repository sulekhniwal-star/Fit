import 'package:drift/drift.dart';

class LocalUserProfiles extends Table {
  TextColumn get userId => text()();
  TextColumn get displayName => text()();
  IntColumn get age => integer()();
  TextColumn get biologicalSex => text()();
  RealColumn get heightCm => real()();
  RealColumn get weightKg => real()();
  RealColumn get targetWeightKg => real().nullable()();
  TextColumn get activityLevel => text()();
  TextColumn get dietaryIdentity => text()();
  TextColumn get healthGoal => text()();
  TextColumn get languageCode => text().withDefault(const Constant('en'))();
  TextColumn get doshaProfileJson => text().nullable()();
  BoolColumn get hasAcceptedDpdpConsent => boolean().withDefault(const Constant(false))();
  DateTimeColumn get updatedAt => dateTime()();

  @override
  Set<Column> get primaryKey => {userId};
}

