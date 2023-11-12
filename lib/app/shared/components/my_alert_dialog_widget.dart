import 'package:flutter/material.dart';

import '../../core_module/constants/constants.dart';

class MyAlertDialogWidget extends StatefulWidget {
  final String title;
  final String content;
  final String? subContent;
  final Widget? okButton;
  final Widget? cancelButton;

  const MyAlertDialogWidget({
    Key? key,
    required this.title,
    required this.content,
    this.subContent,
    this.okButton,
    this.cancelButton,
  }) : super(key: key);

  @override
  State<MyAlertDialogWidget> createState() => _MyAlertDialogWidgetState();
}

class _MyAlertDialogWidgetState extends State<MyAlertDialogWidget> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      elevation: 8,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.title,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          const Divider(),
          Text(
            widget.content,
            textAlign: TextAlign.center,
            style: context.textTheme.titleMedium!.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            widget.subContent ?? '',
          ),
          const Divider(),
          Row(
            children: [
              Expanded(
                child: widget.cancelButton ?? const SizedBox(),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: widget.okButton ?? const SizedBox(),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
