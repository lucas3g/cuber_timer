import 'package:cuber_timer/app/core_module/services/local_database/schemas/record.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import 'helpers/tables.dart';
import 'local_database.dart';
import 'params/local_database_params.dart';

class IsarService implements ILocalDatabase, Disposable {
  late Future<Isar> db;

  IsarService() {
    db = _init();
  }

  Future<Isar> _init() async {
    final dir = await getApplicationDocumentsDirectory();

    if (Isar.instanceNames.isEmpty) {
      return await Isar.open([RecordEntitySchema],
          inspector: true, directory: dir.path);
    }

    return Future.value(Isar.getInstance());
  }

  @override
  Future get({required GetDataParams params}) async {
    late dynamic result;

    final isar = await db;

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

    final isar = await db;

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

    final isar = await db;

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

  @override
  void dispose() async {
    final isar = await db;

    await isar.close();
  }
}
