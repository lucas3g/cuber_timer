import 'package:flutter/material.dart';

import '../../modules/all_records_by_group/presenter/all_records_by_group_page.dart';
import '../../modules/config/presenter/config_page.dart';
import '../../modules/home/presenter/home_page.dart';
import '../../modules/splash/presenter/splash_page.dart';
import '../../modules/timer/presenter/timer_page.dart';
import '../domain/entities/named_routes.dart';
import 'domain/entities/custom_transition.dart';
import 'presenter/custom_page_builder.dart';

class CustomNavigator {
  CustomNavigator({required this.generateAnimation});

  final CustomTransition Function(RouteSettings) generateAnimation;

  Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final Map<String, WidgetBuilder> appRoutes = <String, WidgetBuilder>{
      NamedRoutes.splash.route: (BuildContext context) => const SplashPage(),
      NamedRoutes.home.route: (BuildContext context) => const HomePage(),
      NamedRoutes.timer.route: (BuildContext context) => const TimerPage(),
      NamedRoutes.config.route: (BuildContext context) => const ConfigPage(),
      NamedRoutes.allRecordsByGroup.route: (BuildContext context) =>
          const AllRecordsByGroupPage(),
    };

    final WidgetBuilder? builder = appRoutes[settings.name];

    if (builder != null) {
      final CustomTransition customTransition = generateAnimation(settings);

      return CustomPageRouteBuilder(
        pageBuilder: (
          BuildContext context,
          Animation<double> animation,
          Animation<double> secondaryAnimation,
        ) {
          return builder(context);
        },
        customTransition: customTransition,
        settings: settings,
      );
    }

    return null;
  }
}
