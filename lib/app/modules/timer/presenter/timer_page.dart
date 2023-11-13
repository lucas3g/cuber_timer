import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_controller.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final timerController = TimerController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Timer'),
      ),
      body: GestureDetector(
        onTap: timerController.toggleTimer,
        child: Container(
          color: Colors.transparent,
          width: context.screenWidth,
          height: context.screenHeight,
          child: StreamBuilder(
            stream: timerController.getTimer(),
            builder: (context, snap) {
              if (snap.hasData) {
                final data = snap.data!;

                final time = StopWatchTimer.getDisplayTime(data, hours: false);

                return Center(
                  child: Text(
                    time,
                    style: context.textTheme.bodyLarge
                        ?.copyWith(fontWeight: FontWeight.bold, fontSize: 50),
                  ),
                );
              }

              return const Text('00:00.0');
            },
          ),
        ),
      ),
    );
  }
}
