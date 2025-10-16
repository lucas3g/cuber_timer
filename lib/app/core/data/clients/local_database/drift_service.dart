import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';

import 'drift_database.dart';
import 'helpers/tables.dart';
import 'local_database.dart';
import 'params/local_database_params.dart';

@Injectable(as: ILocalDatabase)
class DriftService implements ILocalDatabase {
  final AppDatabase db;

  DriftService(this.db);

  @override
  Future get({required GetDataParams params}) async {
    late dynamic result;

    if (params.table == Tables.records) {
      if (params.filter != null) {
        result = await db.getRecordsByGroup(params.filter!);
      } else {
        result = await db.getAllRecords();
      }
    }

    return result;
  }

  @override
  Future<bool> updateOrInsert({required UpdateOrInsertDataParams params}) async {
    late bool result = false;

    if (params.table == Tables.records) {
      final record = RecordsCompanion(
        timer: Value(params.data['timer'] as int),
        group: Value(params.data['group'] as String),
        createdAt: Value(DateTime.now()),
      );

      final id = await db.insertRecord(record);
      result = id > 0;
    }

    return result;
  }

  @override
  Future<bool> remove({required RemoveDataParams params}) async {
    late bool result = false;

    if (params.table == Tables.records) {
      if (params.id != null) {
        result = await db.deleteRecord(params.id!);
      } else {
        result = await db.deleteAllRecords();
      }
    }

    return result;
  }

  @override
  Future<int> count({required CountDataParams params}) async {
    late int result = 0;

    if (params.table == Tables.records) {
      result = await db.getTotalRecordsCount();
    }

    return result;
  }
}
