// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i1;
import 'package:injectable/injectable.dart' as _i2;
import 'package:isar/isar.dart' as _i6;
import 'package:shared_preferences/shared_preferences.dart' as _i8;

import '../core/data/clients/local_database/isar_service.dart' as _i11;
import '../core/data/clients/local_database/local_database.dart' as _i10;
import '../core/data/clients/shared_preferences/local_storage_interface.dart'
    as _i4;
import '../core/data/clients/shared_preferences/shared_preferences_service.dart'
    as _i5;
import '../modules/config/presenter/controller/config_controller.dart' as _i14;
import '../modules/config/presenter/services/purchase_service.dart' as _i7;
import '../modules/home/presenter/controller/record_controller.dart' as _i12;
import '../modules/timer/controller/count_down_controller.dart' as _i15;
import '../modules/timer/controller/timer_controller.dart' as _i13;
import '../shared/services/ad_service.dart' as _i3;
import '../shared/services/app_review_service.dart' as _i9;
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
    gh.singleton<_i3.IAdService>(() => _i3.AdService());
    gh.factory<_i4.ILocalStorage>(() => _i5.SharedPreferencesService());
    gh.factory<_i6.Isar>(() => registerModule.isar);
    gh.singleton<_i7.PurchaseService>(() => _i7.PurchaseService());
    await gh.factoryAsync<_i8.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.factory<_i9.IAppReviewService>(
        () => _i9.AppReviewService(gh<_i4.ILocalStorage>()));
    gh.factory<_i10.ILocalDatabase>(() => _i11.IsarService(gh<_i6.Isar>()));
    gh.singleton<_i12.RecordController>(
        () => _i12.RecordController(localDatabase: gh<_i10.ILocalDatabase>()));
    gh.factory<_i13.TimerController>(() => _i13.TimerController(
          localDatabase: gh<_i10.ILocalDatabase>(),
          recordController: gh<_i12.RecordController>(),
          appReviewService: gh<_i9.IAppReviewService>(),
        ));
    gh.singleton<_i14.ConfigController>(
        () => _i14.ConfigController(
              gh<_i7.PurchaseService>(),
            ));
    gh.factory<_i15.CountDownController>(() =>
        _i15.CountDownController(timerController: gh<_i13.TimerController>()));
    return this;
  }
}

class _$RegisterModule extends _i16.RegisterModule {}
