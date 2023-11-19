import 'dart:io';

import 'package:cuber_timer/app/shared/translation/app_translation.dart';
import 'package:flutter/material.dart';

const bannerID = 'ca-app-pub-1898798427054986/5130180395';
const intersticialID = 'ca-app-pub-1898798427054986/4998867194';

const double kPadding = 20;

extension ContextExtensions on BuildContext {
  ColorScheme get myTheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

  AppTranslation get translate => AppTranslation(this);

  void closeKeyboard() => FocusScope.of(this).unfocus();

  Size get sizeAppbar {
    final height = AppBar().preferredSize.height;

    return Size(
      screenWidth,
      height +
          (Platform.isWindows
              ? 75
              : Platform.isIOS
                  ? 50
                  : 70),
    );
  }
}
