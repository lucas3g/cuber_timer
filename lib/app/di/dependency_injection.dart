import 'dart:async';
import 'dart:io';

import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:cuber_timer/app/di/dependency_injection.config.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await _initIsar();

  await getIt.init();

  await _checkRecordsWithoutGroupAndSetGroupDefault();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  Isar get isar => Isar.getInstance()!;
}

Future<void> _initIsar() async {
  final Directory dir = await getApplicationDocumentsDirectory();

  await Isar.open(
    <CollectionSchema<dynamic>>[
      RecordEntitySchema,
    ],
    directory: dir.path,
  );
}

Future<void> _checkRecordsWithoutGroupAndSetGroupDefault() async {
  final isar = getIt<Isar>();

  final records =
      await isar.recordEntitys.where().filter().groupIsEmpty().findAll();

  if (records.isNotEmpty) {
    for (final record in records) {
      record.group = 'Old Records';
      record.createdAt = DateTime.now();

      await isar.writeTxn(() async {
        await isar.recordEntitys.put(record);
      });
    }
  }
}
