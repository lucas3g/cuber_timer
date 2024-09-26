import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/schemas/record.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class CardRecordWidget extends StatefulWidget {
  final RecordController recordController;
  final int index;
  final RecordEntity recordEntity;
  final Color colorText;
  final double fontSize;

  const CardRecordWidget({
    Key? key,
    required this.recordController,
    required this.index,
    required this.recordEntity,
    required this.colorText,
    required this.fontSize,
  }) : super(key: key);

  @override
  State<CardRecordWidget> createState() => _CardRecordWidgetState();
}

class _CardRecordWidgetState extends State<CardRecordWidget> {
  late bool confirmDelete = false;

  _deleteRecord() async {
    if (confirmDelete) {
      // Certifique-se de que o widget ainda está montado antes de chamar deleteRecord
      if (mounted) {
        widget.recordController.deleteRecord(widget.recordEntity);
      }
    } else {
      // Confirme a exclusão
      if (mounted) {
        setState(() {
          confirmDelete = true;
        });

        await Future.delayed(const Duration(seconds: 2));

        // Certifique-se de que o widget ainda está montado antes de chamar setState
        if (mounted) {
          setState(() {
            confirmDelete = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final timer = StopWatchTimer.getDisplayTime(
      widget.recordEntity.timer,
      hours: false,
    );

    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(
        '${widget.index + 1} - $timer',
        style: context.textTheme.bodyLarge?.copyWith(
          fontWeight: FontWeight.bold,
          color: widget.colorText,
          fontSize: widget.fontSize,
        ),
      ),
      trailing: IconButton(
        onPressed: () {
          _deleteRecord();
        },
        icon: Icon(
          confirmDelete ? Icons.done : Icons.delete_rounded,
        ),
      ),
    );
  }
}
