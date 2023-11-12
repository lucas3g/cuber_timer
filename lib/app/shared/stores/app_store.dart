import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../core_module/services/theme_mode/theme_mode_service.dart';

class AppStore {
  final IThemeMode _service;

  AppStore(this._service) {
    init();
  }

  final themeMode = ValueNotifier(ThemeMode.dark);

  Future changeThemeMode() async {
    final mode = await _service.getThemeMode() == ThemeMode.dark.name
        ? ThemeMode.light
        : ThemeMode.dark;

    themeMode.value = mode;

    saveThemeMode();

    if (!Modular.to.path.contains('home')) {
      //Change color of statusbar icons
      SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness:
              mode == ThemeMode.dark ? Brightness.light : Brightness.dark,
        ),
      );
    }
  }

  void init() async {
    final themeModeLocal = await _service.getThemeMode();

    themeMode.value = _getThemeModeByName(themeModeLocal);
  }

  Future saveThemeMode() async {
    await _service.saveThemeMode(themeMode.value.name);
  }

  ThemeMode _getThemeModeByName(String name) {
    return ThemeMode.values.firstWhere((mode) => mode.name.contains(name));
  }
}
