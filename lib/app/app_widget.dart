import 'package:bot_toast/bot_toast.dart';
import 'package:cuber_timer/app/shared/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'shared/stores/app_store.dart';
import 'utils/global_context.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    Modular.setNavigatorKey(GlobalContext.navigatorKey);

    Modular.setObservers([
      BotToastNavigatorObserver(),
    ]);

    final appStore = context.watch<AppStore>(
      (store) => store.themeMode,
    );

    return MaterialApp.router(
      title: 'Cube Time',
      debugShowCheckedModeBanner: false,
      themeMode: appStore.themeMode.value,
      theme: lightThemeApp,
      darkTheme: darkThemeApp,
      routerConfig: Modular.routerConfig,
      builder: (context, child) {
        BotToastInit()(context, child);
        FlutterI18n.rootAppBuilder();

        return child!;
      },
      localizationsDelegates: [
        FlutterI18nDelegate(
          translationLoader: FileTranslationLoader(
            basePath: 'assets/i18n',
            useCountryCode: true,
            fallbackFile: 'en_US',
            decodeStrategies: [YamlDecodeStrategy()],
          ),
          missingTranslationHandler: (key, locale) {},
        ),
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [Locale('en', 'US'), Locale('pt', 'BR')],
      //locale: , //Deixar nulo ai o flutter pega o locale do sistema
    );
  }
}
