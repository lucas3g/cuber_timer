import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/modules/timer/controller/count_down_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_states.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:cuber_timer/app/shared/translation/i18_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final timerController = Modular.get<TimerController>();
  final countDownController = Modular.get<CountDownController>();
  final pageController = PageController();
  int pageIndex = 0;

  bool terminated = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate('timer_page.title_appbar')),
      ),
      body: Observer(builder: (context) {
        final state = timerController.state;

        return GestureDetector(
          onTap: () async {
            if (timerController.timer.isRunning) {
              terminated = true;
              setState(() {});
              await timerController.stopTimer();
            }
          },
          onLongPress: () {
            timerController.startTimerColor();
            timerController.changeColor(Colors.yellow);
            countDownController.startTimerCountDown();
          },
          onLongPressEnd: (details) {
            if (!terminated) {
              timerController.colorChangeTimer.cancel();

              if (timerController.textColor == Colors.green) {
                countDownController.stopTimerCountDown();
                timerController.toggleTimer();
              }

              timerController.resetColor();
            }
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
                  stream: countDownController.getCountDownTimer,
                  builder: (context, snap) {
                    if (snap.hasData) {
                      final data = snap.data!;

                      return Visibility(
                        visible: (state is StopTimerState) && !terminated,
                        child: Expanded(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    context.translate(
                                        'timer_page.title_scrambles'),
                                    style:
                                        context.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Ink(
                                    child: InkWell(
                                      onTap: () async {
                                        if (pageIndex <
                                            timerController
                                                .listScrambles.length) {
                                          await pageController.nextPage(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease,
                                          );

                                          pageIndex++;
                                        } else {
                                          await pageController.previousPage(
                                            duration:
                                                const Duration(seconds: 1),
                                            curve: Curves.ease,
                                          );

                                          if (pageController.page == 0) {
                                            pageIndex = 0;
                                          }
                                        }
                                      },
                                      child: SizedBox(
                                        height: 60,
                                        width: context.screenWidth,
                                        child: PageView(
                                          controller: pageController,
                                          children: timerController
                                              .listScrambles
                                              .map(
                                                (e) => Text(
                                                  e,
                                                  style: context
                                                      .textTheme.bodyLarge
                                                      ?.copyWith(
                                                    fontSize: 20,
                                                  ),
                                                  textAlign: TextAlign.justify,
                                                ),
                                              )
                                              .toList(),
                                        ),
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
                              Text(
                                context.translate(
                                    'timer_page.text_help_to_use_app'),
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

                      return Column(
                        children: [
                          Visibility(
                            visible: data > 0,
                            child: Center(
                              child: Text(
                                time,
                                style: context.textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold, fontSize: 50),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: data > 0 && (state is StopTimerState),
                            child: MyElevatedButtonWidget(
                              label: Text(context.translate(
                                  'timer_page.text_button_new_stop_watch')),
                              onPressed: () {
                                timerController.resetTimer();
                                countDownController.resetTimerCountDown();
                                terminated = false;
                                setState(() {});
                              },
                            ),
                          )
                        ],
                      );
                    }

                    return const Text('00:00.0');
                  },
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
