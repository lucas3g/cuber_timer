import 'package:bot_toast/bot_toast.dart';
import 'package:cuber_timer/app/core/domain/entities/named_routes.dart';
import 'package:cuber_timer/app/core/routes/app_routes.dart';
import 'package:cuber_timer/app/core/routes/domain/entities/custom_transition.dart';
import 'package:cuber_timer/app/core/routes/domain/entities/custom_transition_type.dart';
import 'package:cuber_timer/app/shared/themes/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';
import 'package:flutter_i18n/loaders/decoders/yaml_decode_strategy.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'shared/utils/global_context.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({Key? key}) : super(key: key);

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cube Timer',
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalContext.navigatorKey,
      theme: lightThemeApp,
      darkTheme: darkThemeApp,
      themeMode: ThemeMode.dark,
      navigatorObservers: [
        BotToastNavigatorObserver(),
      ],
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
      initialRoute: NamedRoutes.splash.route,
      onGenerateRoute: CustomNavigator(
        generateAnimation: _generateAnimation,
      ).onGenerateRoute,
    );
  }

  CustomTransition _generateAnimation(RouteSettings settings) {
    return CustomTransition(
      transitionType: CustomTransitionType.fade,
      duration: const Duration(milliseconds: 200),
    );
  }
}
