import 'package:cuber_timer/app/shared/translation/helper/i18_helper.dart';
import 'package:flutter/material.dart';

class ConfigPageTranslation {
  final BuildContext context;

  ConfigPageTranslation(this.context);

  String translate(String key) {
    return I18nHelper().translate(context, 'config_page.$key');
  }

  String get buttonStart => translate('button_start');
  String get textLoading => translate('text_loading');
  String get listEmpty => translate('list_empty');
  String get titleList => translate('title_list');
  String get titleAvg => translate('title_avg');
  String get best => translate('best');
  String get avg5 => translate('avg_5');
  String get avg12 => translate('avg_12');
}
