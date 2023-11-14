import 'dart:async';

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
  Color textColor = Colors.white;
  late Timer colorChangeTimer;

  @override
  void initState() {
    super.initState();
    colorChangeTimer = Timer(const Duration(milliseconds: 500), () {
      _changeColor(Colors.white);
    });
  }

  @override
  void dispose() {
    colorChangeTimer.cancel(); // Cancela o timer ao descartar o widget
    super.dispose();
  }

  void _startTimer() {
    colorChangeTimer = Timer(const Duration(milliseconds: 500), () {
      _changeColor(Colors.green);
    });
  }

  void _changeColor(Color color) {
    setState(() {
      textColor = color;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Timer'),
      ),
      body: GestureDetector(
        onTap: timerController.timer.onStopTimer,
        onLongPress: () {
          _startTimer();
          _changeColor(Colors.yellow);
          timerController.startTimerCountDown();
        },
        onLongPressEnd: (details) {
          colorChangeTimer.cancel();

          if (textColor == Colors.green) {
            timerController.toggleTimer();
          }

          _resetColor();
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.transparent,
          width: context.screenWidth,
          height: context.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<Object>(
                stream: timerController.getTimerFifty(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    final data = snap.data!;

                    return Visibility(
                      visible: !timerController.isRunningTimer.value,
                      child: Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                Text(
                                  'Embaralhamentos',
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  "R2 R L D B2 L2 F' L' R' ",
                                  style: context.textTheme.bodyLarge?.copyWith(
                                    fontSize: 20,
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data.toString(),
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: textColor,
                              ),
                            ),
                            const Text(
                              'Segure pressionado até o tempo ficar verde para liberar o contador.',
                              textAlign: TextAlign.center,
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return const Text('15');
                },
              ),
              StreamBuilder(
                stream: timerController.getTimer(),
                builder: (context, snap) {
                  if (snap.hasData) {
                    final data = snap.data!;

                    final time =
                        StopWatchTimer.getDisplayTime(data, hours: false);

                    return Visibility(
                      visible: data > 0,
                      child: Center(
                        child: Text(
                          time,
                          style: context.textTheme.bodyLarge?.copyWith(
                              fontWeight: FontWeight.bold, fontSize: 50),
                        ),
                      ),
                    );
                  }

                  return const Text('00:00.0');
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _resetColor() {
    setState(() {
      textColor = Colors.white; // Retorna para branco ao soltar
      colorChangeTimer
          .cancel(); // Cancela o timer para evitar transição para verde
    });
  }
}
