// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/core_module/services/theme_mode/theme_mode_controller.dart';
import 'package:cuber_timer/app/shared/stores/app_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_modular/flutter_modular.dart';

class MyInputWidget extends StatelessWidget {
  final FocusNode? focusNode;
  final TextInputType keyboardType;
  final String? hintText;
  final String label;
  final bool obscureText;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final int? maxLines;
  final int? maxLength;
  final int? minLines;
  final List<TextInputFormatter>? inputFormaters;
  final Function(String?)? onFieldSubmitted;
  final Function(String)? onChanged;
  final TextCapitalization textCapitalization;
  final Function()? onTap;
  final void Function()? onEditingComplete;
  final bool readOnly;
  final bool expands;
  final TextInputAction? textInputAction;
  final TextAlignVertical? textAlignVertical;
  final String? Function(String?)? validator;
  final String? value;
  final TextEditingController? controller;
  final Color? color;

  const MyInputWidget({
    Key? key,
    this.focusNode,
    this.keyboardType = TextInputType.text,
    this.hintText,
    required this.label,
    this.obscureText = false,
    this.suffixIcon,
    this.prefixIcon,
    this.maxLines,
    this.maxLength,
    this.minLines,
    this.inputFormaters,
    this.onFieldSubmitted,
    this.onChanged,
    this.textCapitalization = TextCapitalization.sentences,
    this.onTap,
    this.onEditingComplete,
    this.readOnly = false,
    this.expands = false,
    this.textInputAction,
    this.textAlignVertical = TextAlignVertical.center,
    this.validator,
    this.value,
    this.controller,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final appStore = context.watch<AppStore>(
      (store) => store.themeMode,
    );

    Color returnBorderColor() {
      return appStore.themeMode.value == ThemeMode.dark
          ? context.myTheme.onBackground
          : context.myTheme.background;
    }

    return TextFormField(
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      initialValue: value,
      textAlignVertical: textAlignVertical!,
      expands: expands,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onEditingComplete: onEditingComplete,
      textCapitalization: textCapitalization,
      textInputAction: textInputAction,
      validator: validator,
      focusNode: focusNode,
      keyboardType: keyboardType,
      onChanged: onChanged,
      onTap: onTap,
      obscureText: obscureText,
      inputFormatters: inputFormaters,
      onFieldSubmitted: onFieldSubmitted,
      maxLength: maxLength,
      style: TextStyle(
          color: color ??
              (ThemeModeController.themeMode == ThemeMode.dark
                  ? context.myTheme.onBackground
                  : context.myTheme.background)),
      decoration: InputDecoration(
        errorStyle: context.textTheme.bodySmall?.copyWith(
          color: color ??
              (ThemeModeController.themeMode == ThemeMode.dark
                  ? context.myTheme.onBackground
                  : context.myTheme.background),
        ),
        counterText: '',
        hintText: hintText,
        hintStyle: context.textTheme.bodyLarge?.copyWith(
          color: color?.withOpacity(0.7) ??
              (ThemeModeController.themeMode == ThemeMode.dark
                  ? context.myTheme.onBackground.withOpacity(0.7)
                  : context.myTheme.background.withOpacity(0.7)),
        ),
        label: Text(
          label,
          style: context.textTheme.bodyLarge?.copyWith(
            color: color ??
                (ThemeModeController.themeMode == ThemeMode.dark
                    ? context.myTheme.onBackground
                    : context.myTheme.background),
          ),
        ),
        suffixIcon: suffixIcon,
        prefixIcon: prefixIcon,
        filled: true,
        isDense: true,
        fillColor: Colors.transparent,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color ?? returnBorderColor(),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color ?? returnBorderColor(),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(
            color: color ?? returnBorderColor(),
          ),
        ),
      ),
    );
  }
}
