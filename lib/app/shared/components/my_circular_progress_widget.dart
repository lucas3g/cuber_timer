import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class MyCircularProgressWidget extends StatelessWidget {
  final Color? color;
  const MyCircularProgressWidget({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Lottie.asset(
        'assets/images/cube_loading.json',
      ),
    );
  }
}
