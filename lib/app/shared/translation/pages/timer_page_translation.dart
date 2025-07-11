import 'package:flutter/material.dart';

import '../helper/i18_helper.dart';

class TimerPageTranslation {
  final BuildContext context;

  TimerPageTranslation(this.context);

  String translate(String key) {
    return I18nHelper().translate(context, 'timer_page.$key');
  }

  String get titleAppBar => translate('title_appbar');
  String get titleScrambles => translate('title_scrambles');
  String get textHelpToUseApp => translate('text_help_to_use_app');
  String get textHelpToStopTimer => translate('text_help_to_stop_timer');
  String get textButtonNewStopwatch => translate('text_button_new_stop_watch');
  String get textBeatRecord => translate('text_beat_record');
  String get textButtonBeatRecord => translate('text_button_beat_record');
  String get textHowToChangeScramble =>
      translate('text_description_how_to_change_scrambles');
  String get textDescriptionLabelGroup =>
      translate('text_description_label_group');
  String get titleAppBarMoreRecords => translate('title_appbar_more_records');
  String get textGroupByModel => translate('textGroupByModel');
  String get textGroupByModelLoading => translate('textGroupByModelLoading');
  String get textButtonListScrambles => translate('textButtonListScrambles');
  String get titleAppbarScramblesList => translate('titleAppbarScramblesList');
  String get textDescriptionScrambleSelected =>
      translate('textDescriptionScrambleSelected');
}
