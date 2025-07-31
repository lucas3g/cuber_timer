import 'dart:async';
import 'dart:io';

import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../modules/config/presenter/services/purchase_service.dart';

import '../core/data/clients/local_database/schemas/record.dart';
import 'dependency_injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  await _initIsar();

  await getIt.init();

  await getIt<PurchaseService>().init();

  await _checkRecordsWithoutGroupAndSetGroupDefault();
  await _insertDebugRecords();
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

  final records = await isar.recordEntitys
      .where()
      .filter()
      .createdAtLessThan(DateTime(2010))
      .findAll();

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

Future<void> _insertDebugRecords() async {
  if (!kDebugMode) return;

  final isar = getIt<Isar>();

  final existing = await isar.recordEntitys
      .where()
      .filter()
      .groupContains('Old Records')
      .findAll();

  if (existing.isEmpty) {
    const sampleTimers = <int>[1000, 2000, 3000];

    for (final time in sampleTimers) {
      final record = RecordEntity(
        timer: time,
        group: 'Old Records',
        createdAt: DateTime.now(),
      );

      await isar.writeTxn(() async {
        await isar.recordEntitys.put(record);
      });
    }
  }
}

void _initAppGlobal() {
  AppGlobal();

  // if (kDebugMode) {
  //   AppGlobal.instance.setPlan(SubscriptionPlan.annual);
  // }
}
