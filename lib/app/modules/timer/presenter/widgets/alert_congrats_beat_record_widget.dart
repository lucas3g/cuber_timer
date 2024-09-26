import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertCongratsBeatRecordWidget extends StatelessWidget {
  const AlertCongratsBeatRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myTheme.surface,
      titleTextStyle: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Center(
            child: Text(
              'Woouu',
              style: context.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const Divider(),
          Lottie.asset('assets/images/congrats.json', width: 200),
          Text(
            context.translate.timerPage.textBeatRecord,
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
                  label: Text(context.translate.timerPage.textButtonBeatRecord),
                  onPressed: () {
                    Navigator.of(context).pop('dialog');
                  },
                ),
              ),
            ],
          )
        ],
      ),
    );
  }
}
