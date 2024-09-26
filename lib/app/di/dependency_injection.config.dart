// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i5;
import 'package:shared_preferences/shared_preferences.dart' as _i6;

import '../core/data/clients/local_database/isar_service.dart' as _i8;
import '../core/data/clients/local_database/local_database.dart' as _i7;
import '../core/data/clients/shared_preferences/local_storage_interface.dart'
    as _i3;
import '../core/data/clients/shared_preferences/shared_preferences_service.dart'
    as _i4;
import '../modules/home/presenter/controller/record_controller.dart' as _i9;
import '../modules/timer/controller/count_down_controller.dart' as _i11;
import '../modules/timer/controller/timer_controller.dart' as _i10;
import 'dependency_injection.dart' as _i12;

extension GetItInjectableX on _i1.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  Future<_i1.GetIt> init({
    String? environment,
    _i2.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i2.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    final registerModule = _$RegisterModule();
    gh.factory<_i3.ILocalStorage>(() => _i4.SharedPreferencesService());
    gh.factory<_i5.Isar>(() => registerModule.isar);
    await gh.factoryAsync<_i6.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i7.ILocalDatabase>(() => _i8.IsarService(gh<_i5.Isar>()));
    gh.singleton<_i9.RecordController>(
        () => _i9.RecordController(localDatabase: gh<_i7.ILocalDatabase>()));
    gh.factory<_i10.TimerController>(() => _i10.TimerController(
          localDatabase: gh<_i7.ILocalDatabase>(),
          recordController: gh<_i9.RecordController>(),
        ));
    gh.factory<_i11.CountDownController>(() =>
        _i11.CountDownController(timerController: gh<_i10.TimerController>()));
    return this;
  }
}

class _$RegisterModule extends _i12.RegisterModule {}
