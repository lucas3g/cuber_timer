import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class AlertCongratsBeatRecordWidget extends StatelessWidget {
  const AlertCongratsBeatRecordWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: context.myTheme.background,
      title: const Center(child: Text('Woouu')),
      titleTextStyle: context.textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset('assets/images/congrats.json', width: 200),
          Text(
            'Você bateu o seu record, parabéns!!!',
            textAlign: TextAlign.center,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: [
        Row(
          children: [
            Expanded(
              child: MyElevatedButtonWidget(
                label: const Text('Thank you'),
                onPressed: () {
                  Navigator.of(context).pop('dialog');
                },
              ),
            ),
          ],
        )
      ],
    );
  }
}
