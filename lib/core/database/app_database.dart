import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'tables/activity_and_wellness_tables.dart';
import 'tables/body_metrics_table.dart';
import 'tables/outbox_table.dart';
import 'tables/user_profiles_table.dart';
import 'tables/vitals_and_habits_tables.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  OutboxMutations,
  LocalUserProfiles,
  BodyMetricEntriesTable,
  StepRecordsTable,
  SleepRecordsTable,
  WaterLogsTable,
  MoodLogsTable,
  VitalRecordsTable,
  MedicationEntriesTable,
  HabitEntriesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  factory AppDatabase.memory() {
    return AppDatabase(NativeDatabase.memory());
  }

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        // Safe schema evolution pathways for subsequent phases
      },
    );
  }

  static QueryExecutor _openConnection({String? encryptionKey}) {
    return LazyDatabase(() async {
      final dbFolder = await getApplicationDocumentsDirectory();
      final file = File(p.join(dbFolder.path, 'fitkarma_encrypted.sqlite'));
      return NativeDatabase.createInBackground(
        file,
        setup: (rawDb) {
          if (encryptionKey != null && encryptionKey.isNotEmpty) {
            rawDb.execute("PRAGMA key = '$encryptionKey';");
          }
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      );
    });
  }
}

final appDatabaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});
