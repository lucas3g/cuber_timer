import 'package:cuber_timer/app/shared/translation/helper/i18_helper.dart';
import 'package:flutter/material.dart';

class TimerPageTranslation {
  final BuildContext context;

  TimerPageTranslation(this.context);

  String translate(String key) {
    return I18nHelper().translate(context, 'timer_page.$key');
  }

  String get titleAppBar => translate('title_appbar');
  String get titleScrambles => translate('title_scrambles');
  String get textHelpToUseApp => translate('text_help_to_use_app');
  String get textButtonNewStopwatch => translate('text_button_new_stop_watch');
  String get textBeatRecord => translate('text_beat_record');
  String get textButtonBeatRecord => translate('text_button_beat_record');
}
