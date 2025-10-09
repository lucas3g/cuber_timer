import 'dart:io';

import 'package:flutter/material.dart';

const bannerTopID = 'ca-app-pub-1898798427054986/5130180395';
const bannerBottomID = 'ca-app-pub-1898798427054986/2075237603';
const bannerTimerPage = 'ca-app-pub-1898798427054986/2399489477';
const intersticialID = 'ca-app-pub-1898798427054986/4998867194';
const bannerIDAllRecords = 'ca-app-pub-1898798427054986/2492942529';
const bannerIDAllRecordsBottom = 'ca-app-pub-1898798427054986/5498379813';
const bannerdIdListScrambles = 'ca-app-pub-1898798427054986/2882775019';

const bannerTopIdiOS = 'ca-app-pub-1898798427054986/8561925764';
const bannerBottomIdiOS = 'ca-app-pub-1898798427054986/1693265085';
const bannerTimerPageIdiOS = 'ca-app-pub-1898798427054986/6626059386';
const intersticialIdiOS = 'ca-app-pub-1898798427054986/6482557331';
const bannerIDAllRecordsIOS = 'ca-app-pub-1898798427054986/5440938406';
const bannerIDAllRecordsBottomIOS = 'ca-app-pub-1898798427054986/8266444111';
const bannerdIdListScramblesIOS = 'ca-app-pub-1898798427054986/4127856736';

const double kPadding = 20;

extension ContextExtensions on BuildContext {
  ColorScheme get colorScheme => Theme.of(this).colorScheme;
  TextTheme get textTheme => Theme.of(this).textTheme;
  Brightness get brightness => Theme.of(this).brightness;

  double get screenHeight => MediaQuery.of(this).size.height;
  double get screenWidth => MediaQuery.of(this).size.width;

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
