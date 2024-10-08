import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';

import 'helpers/tables.dart';
import 'local_database.dart';
import 'params/local_database_params.dart';

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
        // result =
        //     await isar.records.filter().placaContains(params.filter!).findFirst();
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
        final record = RecordEntity(timer: params.data['timer']);

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
