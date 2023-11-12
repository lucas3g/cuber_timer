import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  bool isRunningTimer = false;
  bool isRunningCountDown = false;
  int time = 0;

  final _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final _stopWatchTimerCountDown = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: 15000,
  );

  void toggleTimer() {
    if (!isRunningCountDown) {
      startTimerCountDown();
    } else {
      setState(() {
        if (isRunningTimer) {
          _stopWatchTimer.onStopTimer();
          isRunningTimer = false;
        } else {
          _stopWatchTimer.onStartTimer();
          isRunningTimer = true;
        }
      });
    }
  }

  void startTimerCountDown() {
    setState(() {
      _stopWatchTimerCountDown.onStartTimer();
      isRunningCountDown = true;
    });
  }

  @override
  void initState() {
    super.initState();

    _stopWatchTimerCountDown.secondTime.listen((value) {
      if (value == 0 && isRunningCountDown) {
        toggleTimer();
      }
    });

    _stopWatchTimer.rawTime.listen((value) {
      time = value;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Timer'),
      ),
      body: GestureDetector(
        onTap: toggleTimer,
        child: Container(
          color: Colors.transparent,
          width: context.screenWidth,
          height: context.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Visibility(
                visible: !isRunningTimer && time == 0,
                child: StreamBuilder<int>(
                  stream: _stopWatchTimerCountDown.secondTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final value = snap.data;

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            value.toString(),
                            style: const TextStyle(
                                fontSize: 30,
                                fontFamily: 'Helvetica',
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Visibility(
                visible: time > 0,
                child: StreamBuilder<int>(
                  stream: _stopWatchTimer.rawTime,
                  initialData: 0,
                  builder: (context, snap) {
                    final displayTime =
                        StopWatchTimer.getDisplayTime(time, hours: false);

                    return Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: Text(
                            displayTime,
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'Helvetica',
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
              Visibility(
                visible: !isRunningTimer && time > 0,
                child: MyElevatedButtonWidget(
                  label: const Text('Recomeçar'),
                  onPressed: () {
                    _stopWatchTimer.onResetTimer();
                    _stopWatchTimerCountDown.onResetTimer();
                    isRunningCountDown = false;
                    isRunningTimer = false;
                    setState(() {});
                  },
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
