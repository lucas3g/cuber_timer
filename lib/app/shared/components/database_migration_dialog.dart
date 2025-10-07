import 'dart:async';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';
import 'package:flutter/material.dart';

class DatabaseMigrationDialog extends StatefulWidget {
  const DatabaseMigrationDialog({super.key});

  @override
  State<DatabaseMigrationDialog> createState() =>
      _DatabaseMigrationDialogState();
}

class _DatabaseMigrationDialogState extends State<DatabaseMigrationDialog> {
  int _secondsRemaining = 3;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: context.myTheme.surface,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              translate('database_migration.title'),
              style: context.textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
                color: context.myTheme.error,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 20),
            Container(
              constraints: const BoxConstraints(maxHeight: 400),
              child: SingleChildScrollView(
                child: Text(
                  translate('database_migration.message'),
                  style: context.textTheme.bodyMedium?.copyWith(
                    color: context.myTheme.onSurface,
                    height: 1.5,
                  ),
                  textAlign: TextAlign.justify,
                ),
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _secondsRemaining == 0
                    ? () => Navigator.of(context).pop()
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: context.myTheme.primary,
                  disabledBackgroundColor:
                      context.myTheme.onSurface.withOpacity(0.3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  _secondsRemaining > 0
                      ? '${translate('database_migration.button_close')} ($_secondsRemaining)'
                      : translate('database_migration.button_close'),
                  style: context.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: _secondsRemaining == 0
                        ? context.myTheme.onPrimary
                        : context.myTheme.onSurface.withOpacity(0.5),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
