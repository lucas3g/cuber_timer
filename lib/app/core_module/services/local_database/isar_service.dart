import 'package:cuber_timer/app/core_module/services/local_database/schemas/record.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'helpers/tables.dart';
import 'local_database.dart';
import 'params/local_database_params.dart';

class IsarService implements ILocalDatabase {
  Future<Isar> _init() async {
    final dir = await getApplicationDocumentsDirectory();

    return await Isar.open(
      [RecordSchema],
      directory: dir.path,
    );
  }

  @override
  Future get({required GetDataParams params}) async {
    late dynamic result;

    final isar = await _init();

    if (params.table == Tables.records) {
      if (params.filter != null) {
        // result =
        //     await isar.records.filter().placaContains(params.filter!).findFirst();
      } else {
        result = await isar.records.where().findAll();
      }
    }

    await isar.close();

    return result;
  }

  @override
  Future<bool> updateOrInsert(
      {required UpdateOrInsertDataParams params}) async {
    late bool result = false;

    final isar = await _init();

    await isar.writeTxn(() async {
      if (params.table == Tables.records) {
        final record = Record(timer: params.data['timer']);

        result = await isar.records.put(record) > 0;
      }
    });

    await isar.close();

    return result;
  }

  @override
  Future<bool> remove({required RemoveDataParams params}) async {
    late bool result = false;

    final isar = await _init();

    await isar.writeTxn(() async {
      if (params.table == Tables.records) {
        if (params.id != null) {
          result = await isar.records.delete(params.id!);
        } else {
          result = await isar.records.where().deleteAll() > 0;
        }
      }
    });

    await isar.close();

    return result;
  }
}
