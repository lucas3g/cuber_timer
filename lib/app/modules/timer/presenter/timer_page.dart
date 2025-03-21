import 'dart:io';

import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/count_down_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_states.dart';
import 'package:cuber_timer/app/modules/timer/presenter/widgets/alert_congrats_beat_record_widget.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  final timerController = getIt<TimerController>();
  final countDownController = getIt<CountDownController>();
  final ConfigController configController = getIt<ConfigController>();
  final pageController = PageController();
  int pageIndex = 0;

  bool terminated = false;

  @override
  void initState() {
    super.initState();

    autorun(
      (_) {
        final state = timerController.state;

        if (state is BeatRecordTimerState) {
          showDialog(
            context: context,
            builder: (_) => const AlertCongratsBeatRecordWidget(),
          );
        }
      },
    );

    if (!Platform.isWindows) {
      initBannerAd();
    }
  }

  late BannerAd myBanner;
  bool isAdLoaded = false;

  initBannerAd() async {
    myBanner = BannerAd(
      adUnitId: bannerID,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {
            isAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    await myBanner.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.translate.timerPage.titleAppBar),
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
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                if (!Platform.isWindows && !configController.isAdRemoved) ...[
                  isAdLoaded
                      ? SizedBox(
                          height: myBanner.size.height.toDouble(),
                          width: myBanner.size.width.toDouble(),
                          child: AdWidget(ad: myBanner),
                        )
                      : const SizedBox(),
                  const SizedBox(height: 10),
                ],
                Expanded(
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          context.translate.timerPage
                                              .titleScrambles,
                                          style: context.textTheme.bodyLarge
                                              ?.copyWith(
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
                                                  duration: const Duration(
                                                      seconds: 1),
                                                  curve: Curves.ease,
                                                );

                                                pageIndex++;
                                              } else {
                                                await pageController
                                                    .previousPage(
                                                  duration: const Duration(
                                                      seconds: 1),
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
                                                        textAlign:
                                                            TextAlign.justify,
                                                      ),
                                                    )
                                                    .toList(),
                                              ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          context.translate.timerPage
                                              .textHowToChangeScramble,
                                          style: context.textTheme.bodySmall,
                                        ),
                                      ],
                                    ),
                                    Text(
                                      data.toString(),
                                      style:
                                          context.textTheme.bodyLarge?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 50,
                                        color: timerController.textColor,
                                      ),
                                    ),
                                    Text(
                                      context
                                          .translate.timerPage.textHelpToUseApp,
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

                            final time = StopWatchTimer.getDisplayTime(data,
                                hours: false);

                            return Column(
                              children: [
                                Visibility(
                                  visible: data > 0,
                                  child: Center(
                                    child: Text(
                                      time,
                                      style: context.textTheme.bodyLarge
                                          ?.copyWith(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 50),
                                    ),
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      data > 0 && (state is StopTimerState),
                                  child: MyElevatedButtonWidget(
                                    label: Text(
                                      context.translate.timerPage
                                          .textButtonNewStopwatch,
                                    ),
                                    onPressed: () {
                                      timerController.resetTimer();
                                      countDownController.resetTimerCountDown();
                                      terminated = false;
                                      setState(() {});
                                    },
                                  ),
                                ),
                                Visibility(
                                  visible:
                                      data > 0 && (state is StartTimerState),
                                  child: Center(
                                    child: Text(
                                      context.translate.timerPage
                                          .textHelpToStopTimer,
                                      style: context.textTheme.bodyLarge,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          }

                          return const Text('00:00.0');
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
