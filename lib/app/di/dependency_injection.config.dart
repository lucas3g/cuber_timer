// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format width=80

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;
import 'package:shared_preferences/shared_preferences.dart' as _i460;

import '../core/data/clients/local_database/drift_database.dart' as _i538;
import '../core/data/clients/local_database/drift_service.dart' as _i13;
import '../core/data/clients/local_database/local_database.dart' as _i654;
import '../core/data/clients/shared_preferences/local_storage_interface.dart'
    as _i237;
import '../core/data/clients/shared_preferences/shared_preferences_service.dart'
    as _i745;
import '../modules/config/presenter/services/purchase_service.dart' as _i429;
import '../modules/dashboard/presenter/controller/dashboard_controller.dart'
    as _i652;
import '../modules/home/presenter/controller/record_controller.dart' as _i529;
import '../modules/timer/controller/count_down_controller.dart' as _i192;
import '../modules/timer/controller/timer_controller.dart' as _i53;
import '../shared/services/ad_service.dart' as _i658;
import '../shared/services/app_review_service.dart' as _i901;
import 'dependency_injection.dart' as _i9;

extension GetItInjectableX on _i174.GetIt {
  // initializes the registration of main-scope dependencies inside of GetIt
  Future<_i174.GetIt> init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) async {
    final gh = _i526.GetItHelper(this, environment, environmentFilter);
    final registerModule = _$RegisterModule();
    await gh.factoryAsync<_i460.SharedPreferences>(
      () => registerModule.prefs,
      preResolve: true,
    );
    gh.singleton<_i429.PurchaseService>(() => _i429.PurchaseService());
    gh.lazySingleton<_i538.AppDatabase>(() => registerModule.database);
    gh.singleton<_i658.IAdService>(() => _i658.AdService());
    gh.factory<_i237.ILocalStorage>(() => _i745.SharedPreferencesService());
    gh.factory<_i901.IAppReviewService>(
      () => _i901.AppReviewService(gh<_i237.ILocalStorage>()),
    );
    gh.factory<_i654.ILocalDatabase>(
      () => _i13.DriftService(gh<_i538.AppDatabase>()),
    );
    gh.singleton<_i652.DashboardController>(
      () =>
          _i652.DashboardController(localDatabase: gh<_i654.ILocalDatabase>()),
    );
    gh.singleton<_i529.RecordController>(
      () => _i529.RecordController(localDatabase: gh<_i654.ILocalDatabase>()),
    );
    gh.factory<_i53.TimerController>(
      () => _i53.TimerController(
        localDatabase: gh<_i654.ILocalDatabase>(),
        recordController: gh<_i529.RecordController>(),
        appReviewService: gh<_i901.IAppReviewService>(),
      ),
    );
    gh.factory<_i192.CountDownController>(
      () => _i192.CountDownController(
        timerController: gh<_i53.TimerController>(),
      ),
    );
    return this;
  }
}

class _$RegisterModule extends _i9.RegisterModule {}
