import 'dart:math';

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
  final pageController = PageController();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      final random = Random();

      pageController
          .jumpToPage(random.nextInt(timerController.listScrambles.length));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Novo Timer'),
      ),
      body: GestureDetector(
        onTap: () {
          timerController.toggleTimer();
        },
        onLongPress: () {
          timerController.startTimerColor();
          timerController.changeColor(Colors.yellow);
          timerController.startTimerCountDown();
        },
        onLongPressEnd: (details) {
          timerController.colorChangeTimer.cancel();

          if (timerController.textColor == Colors.green) {
            timerController.toggleTimer();
          }

          timerController.resetColor();

          setState(() {});
        },
        child: Container(
          padding: const EdgeInsets.all(12),
          color: Colors.transparent,
          width: context.screenWidth,
          height: context.screenHeight,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              StreamBuilder<int>(
                stream: timerController.getTimerFifty,
                builder: (context, snap) {
                  if (snap.hasData) {
                    final data = snap.data!;

                    return Visibility(
                      visible: !timerController.timer.isRunning,
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
                                GestureDetector(
                                  onTap: () {
                                    if (pageController.page! < 6) {
                                      pageController.nextPage(
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.ease);
                                    } else {
                                      pageController.previousPage(
                                          duration: const Duration(seconds: 1),
                                          curve: Curves.ease);
                                    }
                                  },
                                  child: SizedBox(
                                    height: 50,
                                    width: context.screenWidth,
                                    child: PageView(
                                      controller: pageController,
                                      children: timerController.listScrambles
                                          .map((e) => Text(e))
                                          .toList(),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              data.toString(),
                              style: context.textTheme.bodyLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 50,
                                color: timerController.textColor,
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
                stream: timerController.getTimer,
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
}
