import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

import '../../../shared/stores/app_store.dart';
import '../../../utils/global_context.dart';

class ThemeModeController {
  static ThemeMode get themeMode => GlobalContext.navigatorKey.currentContext!
      .watch<AppStore>((store) => store.themeMode)
      .themeMode
      .value;
  static AppStore get appStore => GlobalContext.navigatorKey.currentContext!
      .watch<AppStore>((store) => store.themeMode);
}
