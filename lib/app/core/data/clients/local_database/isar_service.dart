import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import 'helpers/tables.dart';
import 'local_database.dart';
import 'params/local_database_params.dart';
import 'schemas/record.dart';

@Injectable(as: ILocalDatabase)
class IsarService implements ILocalDatabase {
  final Isar db;

  IsarService(this.db);

  @override
  Future get({required GetDataParams params}) async {
    late dynamic result;

    final isar = db;

    if (params.table == Tables.records) {
      if (params.filter != null) {
        result = await isar.recordEntitys
            .filter()
            .groupContains(params.filter!)
            .sortByTimer()
            .findAll();
      } else {
        result = await isar.recordEntitys.where().sortByTimer().findAll();
      }
    }

    return result;
  }

  @override
  Future<bool> updateOrInsert(
      {required UpdateOrInsertDataParams params}) async {
    late bool result = false;

    final isar = db;

    await isar.writeTxn(() async {
      if (params.table == Tables.records) {
        final record = RecordEntity(
          timer: params.data['timer'],
          group: params.data['group'],
          createdAt: DateTime.now(),
        );

        result = await isar.recordEntitys.put(record) > 0;
      }
    });

    return result;
  }

  @override
  Future<bool> remove({required RemoveDataParams params}) async {
    late bool result = false;

    final isar = db;

    await isar.writeTxn(() async {
      if (params.table == Tables.records) {
        if (params.id != null) {
          result = await isar.recordEntitys.delete(params.id!);
        } else {
          result = await isar.recordEntitys.where().deleteAll() > 0;
        }
      }
    });

    return result;
  }
}
