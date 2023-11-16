import 'package:cuber_timer/app/shared/translation/pages/home_page_translation.dart';
import 'package:cuber_timer/app/shared/translation/pages/splash_page_translation.dart';
import 'package:cuber_timer/app/shared/translation/pages/timer_page_translation.dart';
import 'package:flutter/material.dart';

class AppTranslation {
  final BuildContext context;

  AppTranslation(this.context);

  SplashPageTranslation get splashPage => SplashPageTranslation(context);
  HomePageTranslation get homePage => HomePageTranslation(context);
  TimerPageTranslation get timerPage => TimerPageTranslation(context);
}
