import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'color_schemes.g.dart';

final lightThemeApp = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: lightColorSchemePapagaio,
  appBarTheme: AppBarTheme(
    backgroundColor: lightColorSchemePapagaio.onPrimaryContainer,
    centerTitle: true,
    foregroundColor: lightColorSchemePapagaio.surface,
    iconTheme: IconThemeData(
      color: lightColorSchemePapagaio.surface,
    ),
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => lightColorSchemePapagaio.surface,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => lightColorSchemePapagaio.onPrimaryContainer,
      ),
    ),
  ),
);

final darkThemeApp = ThemeData(
  useMaterial3: true,
  fontFamily: GoogleFonts.roboto().fontFamily,
  colorScheme: darkColorSchemePapagaio,
  appBarTheme: AppBarTheme(
    backgroundColor: darkColorSchemePapagaio.onPrimary,
    centerTitle: true,
  ),
  dialogTheme: const DialogThemeData(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  scaffoldBackgroundColor: darkColorSchemePapagaio.scrim,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: WidgetStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.onSurface,
      ),
      backgroundColor: WidgetStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.onPrimary,
      ),
    ),
  ),
);
