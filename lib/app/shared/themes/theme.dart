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
    foregroundColor: lightColorSchemePapagaio.background,
    iconTheme: IconThemeData(
      color: lightColorSchemePapagaio.background,
    ),
  ),
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => lightColorSchemePapagaio.background,
      ),
      backgroundColor: MaterialStateProperty.resolveWith(
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
  dialogTheme: const DialogTheme(
    backgroundColor: Colors.transparent,
    surfaceTintColor: Colors.transparent,
  ),
  scaffoldBackgroundColor: darkColorSchemePapagaio.scrim,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ButtonStyle(
      foregroundColor: MaterialStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.onBackground,
      ),
      backgroundColor: MaterialStateProperty.resolveWith(
        (states) => darkColorSchemePapagaio.onPrimary,
      ),
    ),
  ),
);
