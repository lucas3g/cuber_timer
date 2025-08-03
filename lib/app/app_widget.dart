import 'package:bot_toast/bot_toast.dart';
import 'package:cuber_timer/app/core/domain/entities/app_language.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/domain/entities/named_routes.dart';
import 'core/routes/app_routes.dart';
import 'core/routes/domain/entities/custom_transition.dart';
import 'core/routes/domain/entities/custom_transition_type.dart';
import 'shared/themes/theme.dart';
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

        return child!;
      },
      supportedLocales: <Locale>[
        AppLanguage.portuguese.locale,
        AppLanguage.english.locale,
      ],
      localizationsDelegates: const <LocalizationsDelegate<Object>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
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
