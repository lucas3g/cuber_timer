// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:flutter/material.dart';

class CardScrambleWidget extends StatefulWidget {
  final String scramble;

  const CardScrambleWidget({super.key, required this.scramble});

  @override
  State<CardScrambleWidget> createState() => _CardScrambleWidgetState();
}

class _CardScrambleWidgetState extends State<CardScrambleWidget> {
  final ValueNotifier<bool> _isSelected = ValueNotifier(false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _isSelected.value = !_isSelected.value;
      },
      child: ListenableBuilder(
        listenable: _isSelected,
        builder: (context, snapshot) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: BoxDecoration(
              color: _isSelected.value
                  ? context.colorScheme.primaryContainer
                  : const Color(0xFF151818),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              widget.scramble,
              style: context.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 20,
              ),
            ),
          );
        },
      ),
    );
  }
}
