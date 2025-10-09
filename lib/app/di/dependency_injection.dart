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

  // Lista de todos os tipos de cubo suportados
  const cubeTypes = [
    '2x2',
    '3x3',
    '4x4',
    '5x5',
    '6x6',
    '7x7',
    'Megaminx',
    'Pyraminx',
    'Square-1',
    'Clock',
    'Skewb',
  ];

  // Para cada tipo de cubo, criar vários tempos de exemplo
  for (final cubeType in cubeTypes) {
    final existing = await db.getRecordsByGroup(cubeType);

    if (existing.isEmpty) {
      // Gerar tempos variados para cada tipo de cubo
      final sampleTimers = _generateSampleTimesForCube(cubeType);

      for (final time in sampleTimers) {
        final record = RecordsCompanion(
          timer: Value(time),
          group: Value(cubeType),
          createdAt: Value(DateTime.now().subtract(
            Duration(minutes: sampleTimers.indexOf(time)),
          )),
        );

        await db.insertRecord(record);
      }
    }
  }

  // Também criar alguns registros com o grupo "Old Records" para compatibilidade
  final oldRecords = await db.getRecordsByGroup('Old Records');
  if (oldRecords.isEmpty) {
    const sampleTimers = <int>[1000, 2000, 3000, 4000, 5000];

    for (final time in sampleTimers) {
      final record = RecordsCompanion(
        timer: Value(time),
        group: const Value('Old Records'),
        createdAt: Value(DateTime.now().subtract(
          Duration(hours: sampleTimers.indexOf(time)),
        )),
      );

      await db.insertRecord(record);
    }
  }
}

// Gera tempos de exemplo baseados no tipo de cubo
List<int> _generateSampleTimesForCube(String cubeType) {
  switch (cubeType) {
    case '2x2':
      return [1500, 2200, 2800, 3100, 3500, 4000, 4500, 5000, 5500, 6000];
    case '3x3':
      return [8000, 9500, 10200, 11000, 12500, 13000, 14500, 15000, 16000, 17500];
    case '4x4':
      return [35000, 38000, 42000, 45000, 48000, 51000, 55000, 58000, 62000, 65000];
    case '5x5':
      return [70000, 75000, 80000, 85000, 90000, 95000, 100000, 105000, 110000, 115000];
    case '6x6':
      return [120000, 130000, 140000, 150000, 160000, 170000, 180000, 190000, 200000, 210000];
    case '7x7':
      return [180000, 195000, 210000, 225000, 240000, 255000, 270000, 285000, 300000, 315000];
    case 'Megaminx':
      return [60000, 65000, 70000, 75000, 80000, 85000, 90000, 95000, 100000, 105000];
    case 'Pyraminx':
      return [3000, 4000, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500];
    case 'Square-1':
      return [15000, 18000, 20000, 22000, 25000, 28000, 30000, 32000, 35000, 38000];
    case 'Clock':
      return [5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000, 13000, 14000];
    case 'Skewb':
      return [4000, 5000, 6000, 7000, 8000, 9000, 10000, 11000, 12000, 13000];
    default:
      return [5000, 10000, 15000, 20000, 25000];
  }
}

void _initAppGlobal() {
  AppGlobal();

  if (kDebugMode) {
    // AppGlobal.instance.setPlan(SubscriptionPlan.annual);
  }
}
