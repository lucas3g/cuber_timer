import 'package:flutter/material.dart';

import 'pages/home_page_translation.dart';
import 'pages/splash_page_translation.dart';
import 'pages/timer_page_translation.dart';

class AppTranslation {
  final BuildContext context;

  AppTranslation(this.context);

  SplashPageTranslation get splashPage => SplashPageTranslation(context);
  HomePageTranslation get homePage => HomePageTranslation(context);
  TimerPageTranslation get timerPage => TimerPageTranslation(context);
}
