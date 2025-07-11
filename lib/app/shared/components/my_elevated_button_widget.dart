import 'package:flutter/material.dart';

import '../../core/constants/constants.dart';

class MyElevatedButtonWidget extends StatefulWidget {
  final Widget label;
  final IconData? icon;
  final Function()? onPressed;
  final double? height;
  final double? width;
  final Color? backgroundColor;

  const MyElevatedButtonWidget({
    Key? key,
    required this.label,
    this.icon,
    required this.onPressed,
    this.height = 40,
    this.width,
    this.backgroundColor,
  }) : super(key: key);

  @override
  State<MyElevatedButtonWidget> createState() => _MyElevatedButtonWidgetState();
}

class _MyElevatedButtonWidgetState extends State<MyElevatedButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height,
      width: widget.width,
      child: ElevatedButton(
        onPressed: widget.onPressed,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          backgroundColor:
              widget.backgroundColor ?? context.myTheme.primaryContainer,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: widget.label,
      ),
    );
  }
}
