// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_states.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/components/my_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class HomePage extends StatefulWidget {
  final RecordController recordController;
  const HomePage({
    Key? key,
    required this.recordController,
  }) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future getAllRecords() async {
    await widget.recordController.getAllRecords();
  }

  @override
  void initState() {
    super.initState();

    getAllRecords();

    autorun((_) {
      final state = widget.recordController.state;

      if (state is ErrorRecordState) {
        MySnackBar(
          title: 'Opss...',
          message: state.message,
          type: TypeSnack.error,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Observer(builder: (context) {
            final state = widget.recordController.state;

            if (state is! SuccessGetListRecordState) {
              return const MyCircularProgressWidget();
            }

            final records = state.records;

            return Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    border: Border.symmetric(
                      horizontal: BorderSide(
                        color: context.myTheme.onBackground,
                      ),
                    ),
                  ),
                  child: Text(
                    'List of Highscore',
                    style: context.textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListView.separated(
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    final record = records[index];

                    final timer = StopWatchTimer.getDisplayTime(
                      record.timer,
                      hours: false,
                    );

                    if (index == 0) {
                      return Text(
                        '${index + 1} - $timer',
                        style: context.textTheme.bodyLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      );
                    }

                    if (index == 1) {
                      return Text(
                        '${index + 1} - $timer',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.green,
                        ),
                      );
                    }

                    if (index == 2) {
                      return Text(
                        '${index + 1} - $timer',
                        style: context.textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.blue,
                        ),
                      );
                    }

                    return Text('${index + 1} - $timer');
                  },
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 10),
                  itemCount: records.length,
                ),
                Divider(
                  color: context.myTheme.onBackground,
                ),
              ],
            );
          }),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyElevatedButtonWidget(
              width: context.screenWidth * .4,
              label: const Text('New Stopwatch'),
              onPressed: () async {
                await Modular.to.pushNamed('./timer/');
                await getAllRecords();
              },
            ),
          ],
        ),
      ),
    );
  }
}
