import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

import 'app/app_widget.dart';
import 'app/di/dependency_injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await configureDependencies();

  await I18nTranslate.create(loader: TranslateLoader(basePath: 'assets/i18n'));

  runApp(const AppWidget());
}
