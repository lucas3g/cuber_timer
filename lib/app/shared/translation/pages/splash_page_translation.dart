import 'package:cuber_timer/app/shared/translation/helper/i18_helper.dart';
import 'package:flutter/material.dart';

class SplashPageTranslation {
  final BuildContext context;

  SplashPageTranslation(this.context);

  String translate(String key) {
    return I18nHelper().translate(context, 'splash_page.$key');
  }

  String get title => translate('title');
}
