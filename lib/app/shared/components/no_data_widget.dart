// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class NoDataWidget extends StatelessWidget {
  final String text;
  final Widget? child;
  const NoDataWidget({
    Key? key,
    required this.text,
    this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Lottie.asset(
            'assets/images/nodata.json',
            width: context.screenWidth * .3,
          ),
          Text(
            text,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          if (child != null) child!,
        ],
      ),
    );
  }
}
