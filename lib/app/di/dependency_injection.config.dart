// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i7;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

import '../core/data/clients/local_database/isar_service.dart' as _i12;
import '../core/data/clients/local_database/local_database.dart' as _i11;
import '../core/data/clients/shared_preferences/local_storage_interface.dart'
    as _i5;
import '../core/data/clients/shared_preferences/shared_preferences_service.dart'
    as _i6;
import '../modules/config/presenter/controller/config_controller.dart' as _i9;
import '../modules/config/presenter/services/in_app_purcashe_service.dart'
    as _i3;
import '../modules/config/presenter/services/in_app_purcashe_service_imp.dart'
    as _i4;
import '../modules/home/presenter/controller/record_controller.dart' as _i13;
import '../modules/timer/controller/count_down_controller.dart' as _i15;
import '../modules/timer/controller/timer_controller.dart' as _i14;
import '../shared/services/app_review_service.dart' as _i10;
import 'dependency_injection.dart' as _i16;

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
    gh.factory<_i3.IInAppPurchaseService>(() => _i4.InAppPurchaseServiceImp());
    gh.factory<_i5.ILocalStorage>(() => _i6.SharedPreferencesService());
    gh.factory<_i7.Isar>(() => registerModule.isar);
    await gh.factoryAsync<_i8.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i9.ConfigController>(
        () => _i9.ConfigController(gh<_i3.IInAppPurchaseService>()));
    gh.factory<_i10.IAppReviewService>(
        () => _i10.AppReviewService(gh<_i5.ILocalStorage>()));
    gh.factory<_i11.ILocalDatabase>(() => _i12.IsarService(gh<_i7.Isar>()));
    gh.singleton<_i13.RecordController>(
        () => _i13.RecordController(localDatabase: gh<_i11.ILocalDatabase>()));
    gh.factory<_i14.TimerController>(() => _i14.TimerController(
          localDatabase: gh<_i11.ILocalDatabase>(),
          recordController: gh<_i13.RecordController>(),
          appReviewService: gh<_i10.IAppReviewService>(),
        ));
    gh.factory<_i15.CountDownController>(() =>
        _i15.CountDownController(timerController: gh<_i14.TimerController>()));
    return this;
  }
}

class _$RegisterModule extends _i16.RegisterModule {}
