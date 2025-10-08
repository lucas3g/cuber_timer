import 'dart:async';

import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/shared/services/ad_service.dart';
import 'package:drift/drift.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../core/data/clients/local_database/drift_database.dart';
import '../modules/subscriptions/services/purchase_service.dart';
import 'dependency_injection.config.dart';

final GetIt getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  _initAppGlobal();

  await getIt.init();

  await getIt<IAdService>().init();

  await getIt<PurchaseService>().init();

  await _checkRecordsWithoutGroupAndSetGroupDefault();
  await _insertDebugRecords();
}

@module
abstract class RegisterModule {
  @preResolve
  Future<SharedPreferences> get prefs => SharedPreferences.getInstance();

  @lazySingleton
  AppDatabase get database => AppDatabase();
}

Future<void> _checkRecordsWithoutGroupAndSetGroupDefault() async {
  final db = getIt<AppDatabase>();

  final records = await db.getRecordsCreatedBefore(DateTime(2010));

  if (records.isNotEmpty) {
    for (final record in records) {
      final updatedRecord = record.copyWith(
        group: 'Old Records',
        createdAt: DateTime.now(),
      );

      await db.updateRecord(updatedRecord);
    }
  }
}

Future<void> _insertDebugRecords() async {
  if (!kDebugMode) return;

  final db = getIt<AppDatabase>();

  final existing = await db.getRecordsByGroup('Old Records');

  if (existing.isEmpty) {
    const sampleTimers = <int>[1000, 2000, 3000];

    for (final time in sampleTimers) {
      final record = RecordsCompanion(
        timer: Value(time),
        group: const Value('Old Records'),
        createdAt: Value(DateTime.now()),
      );

      await db.insertRecord(record);
    }
  }
}

void _initAppGlobal() {
  AppGlobal();

  if (kDebugMode) {
    // AppGlobal.instance.setPlan(SubscriptionPlan.annual);
  }
}
