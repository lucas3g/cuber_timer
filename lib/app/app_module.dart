import 'package:cuber_timer/app/modules/home/home_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'core_module/core_module.dart';
import 'core_module/services/theme_mode/theme_mode_service.dart';
import 'modules/splash/splash_module.dart';
import 'shared/stores/app_store.dart';

class AppModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(i) {
    //STORES
    i.addSingleton<AppStore>(AppStore.new);

    //THEME MODE
    i.addSingleton<IThemeMode>(ThemeModeService.new);
  }

  @override
  void routes(r) {
    r.module('/', module: SplashModule());

    r.module(
      '/home',
      module: HomeModule(),
      transition: TransitionType.noTransition,
    );
  }
}
