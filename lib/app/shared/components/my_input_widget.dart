import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../core/constants/constants.dart';

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
    Color returnBorderColor() {
      return context.myTheme.onSurface;
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
      style: TextStyle(color: color ?? context.myTheme.onSurface),
      decoration: InputDecoration(
        errorStyle: context.textTheme.bodySmall?.copyWith(
          color: color ?? context.myTheme.onSurface,
        ),
        counterText: '',
        hintText: hintText,
        hintStyle: context.textTheme.bodyLarge?.copyWith(
          color: color?.withOpacity(0.7) ??
              context.myTheme.onSurface.withOpacity(0.7),
        ),
        label: Text(
          label,
          style: context.textTheme.bodyLarge?.copyWith(
            color: color ?? context.myTheme.onSurface,
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
