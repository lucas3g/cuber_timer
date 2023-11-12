// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/core_module/services/theme_mode/theme_mode_controller.dart';
import 'package:flutter/material.dart';

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
          backgroundColor: widget.backgroundColor ??
              (ThemeModeController.themeMode == ThemeMode.dark
                  ? context.myTheme.primaryContainer
                  : context.myTheme.surfaceTint),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        child: widget.label,
      ),
    );
  }
}
