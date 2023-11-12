import 'package:cuber_timer/app/shared/themes/theme.dart';
import 'package:flutter/material.dart';

class ThemeByApp {
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  ThemeByApp({
    required this.lightTheme,
    required this.darkTheme,
  });

  static ThemeByApp get theme {
    return ThemeByApp(
      lightTheme: lightThemeApp,
      darkTheme: darkThemeApp,
    );
  }
}

final lightTheme = ThemeByApp.theme.lightTheme;

final darkTheme = ThemeByApp.theme.darkTheme;
