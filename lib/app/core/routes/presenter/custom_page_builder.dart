import 'package:flutter/material.dart';

import '../domain/entities/custom_transition.dart';
import '../domain/entities/custom_transition_type.dart';

class CustomPageRouteBuilder extends PageRouteBuilder<Widget> {
  final CustomTransition customTransition;
  @override
  final RouteSettings settings;

  CustomPageRouteBuilder({
    required Widget Function(
      BuildContext,
      Animation<double>,
      Animation<double>,
    ) pageBuilder,
    required this.customTransition,
    required this.settings,
  }) : super(
          settings: settings,
          pageBuilder: pageBuilder,
          transitionDuration: customTransition.duration,
          transitionsBuilder: (BuildContext context,
              Animation<double> animation,
              Animation<double> secondaryAnimation,
              Widget child) {
            switch (customTransition.transitionType) {
              case CustomTransitionType.slide:
                return SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(1.0, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                );
              case CustomTransitionType.fade:
                return FadeTransition(
                  opacity: animation,
                  child: child,
                );

              default:
                return child;
            }
          },
        );
}
