// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:cuber_timer/app/modules/timer/controller/timer_controller.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'count_down_controller.g.dart';

class CountDownController = CountDownControllerBase with _$CountDownController;

abstract class CountDownControllerBase with Store {
  final TimerController timerController;

  CountDownControllerBase({
    required this.timerController,
  });

  final countDownTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: 15000,
  );

  @computed
  Stream<int> get getCountDownTimer => countDownTimer.secondTime;

  @action
  void startTimerCountDown() {
    countDownTimer.onStartTimer();
  }

  @action
  void stopTimerCountDown() {
    countDownTimer.onStopTimer();
  }

  @action
  void resetTimerCountDown() {
    countDownTimer.onResetTimer();
  }

  @action
  StreamSubscription _listenFiftySecondRemains() {
    return countDownTimer.secondTime.listen((time) {
      if (time == 0) {
        stopTimerCountDown();
        timerController.toggleTimer();
      }
    });
  }

  @observable
  late StreamSubscription subFifty = _listenFiftySecondRemains();
}
