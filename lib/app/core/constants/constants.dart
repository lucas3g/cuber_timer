import 'dart:io';

import 'package:flutter/material.dart';

import '../../shared/translation/app_translation.dart';

const bannerTopID = 'ca-app-pub-1898798427054986/5130180395';
const bannerBottomID = 'ca-app-pub-1898798427054986/2075237603';
const bannerTimerPage = 'ca-app-pub-1898798427054986/2399489477';
const intersticialID = 'ca-app-pub-1898798427054986/4998867194';
const bannerIDAllRecords = 'ca-app-pub-1898798427054986/2492942529';
const bannerIDAllRecordsBottom = 'ca-app-pub-1898798427054986/5498379813';
const bannerdIdListScrambles = 'ca-app-pub-1898798427054986/2882775019';
const adRemovalProductId = 'ad_removal';

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
