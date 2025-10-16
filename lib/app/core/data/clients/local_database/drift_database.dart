import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'drift_database.g.dart';

class Records extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get timer => integer()();
  TextColumn get group => text().withDefault(const Constant('Old Records'))();
  DateTimeColumn get createdAt => dateTime()();
}

@DriftDatabase(tables: [Records])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  // Get all records sorted by timer
  Future<List<Record>> getAllRecords() async {
    return (select(records)..orderBy([(t) => OrderingTerm.asc(t.timer)]))
        .get();
  }

  // Get records filtered by group
  Future<List<Record>> getRecordsByGroup(String groupName) async {
    return (select(records)
          ..where((tbl) => tbl.group.contains(groupName))
          ..orderBy([(t) => OrderingTerm.asc(t.timer)]))
        .get();
  }

  // Insert or update a record
  Future<int> insertRecord(RecordsCompanion record) async {
    return into(records).insert(record);
  }

  // Delete a record by id
  Future<bool> deleteRecord(int id) async {
    return (delete(records)..where((tbl) => tbl.id.equals(id))).go().then(
          (value) => value > 0,
        );
  }

  // Delete all records
  Future<bool> deleteAllRecords() async {
    return delete(records).go().then((value) => value > 0);
  }

  // Get records with createdAt less than a specific date
  Future<List<Record>> getRecordsCreatedBefore(DateTime date) async {
    return (select(records)..where((tbl) => tbl.createdAt.isSmallerThanValue(date)))
        .get();
  }

  // Update a record
  Future<bool> updateRecord(Record record) async {
    return update(records).replace(record);
  }

  // Get total count of all records
  Future<int> getTotalRecordsCount() async {
    final count = countAll();
    final query = selectOnly(records)..addColumns([count]);
    final result = await query.getSingle();
    return result.read(count) ?? 0;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'cuber_timer.sqlite'));
    return NativeDatabase(file);
  });
}
