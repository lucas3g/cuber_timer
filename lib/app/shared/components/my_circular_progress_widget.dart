import 'package:flutter/material.dart';

import '../../core_module/constants/constants.dart';

class MyCircularProgressWidget extends StatelessWidget {
  final Color? color;
  const MyCircularProgressWidget({
    Key? key,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 25,
        height: 25,
        child: CircularProgressIndicator(
          color: color ?? context.myTheme.onBackground,
        ),
      ),
    );
  }
}
