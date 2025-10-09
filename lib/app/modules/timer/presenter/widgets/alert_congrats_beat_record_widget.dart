import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

import '../../../../core/constants/constants.dart';
import '../../../../shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';

class AlertCongratsBeatRecordWidget extends StatelessWidget {
  const AlertCongratsBeatRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.colorScheme.surface,
      titleTextStyle: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              translate('timer_page.alert_title_congrats'),
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Lottie.asset('assets/images/congrats.json', width: 200),
          Text(
            translate('timer_page.text_beat_record'),
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: MyElevatedButtonWidget(
                  label: Text(translate('timer_page.text_button_beat_record')),
                  onPressed: () {
                    Navigator.of(context).pop('dialog');
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
