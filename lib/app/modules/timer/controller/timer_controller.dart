import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerController extends ChangeNotifier {
  final ValueNotifier<bool> isRunningTimer = ValueNotifier(false);
  final ValueNotifier<bool> isRunningCountDown = ValueNotifier(false);

  final timer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final timerFifty = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: 15000,
  );

  void toggleTimer() {
    // if (!isRunningCountDown.value) {
    //   startTimerCountDown();
    // } else {
    if (isRunningTimer.value) {
      timer.onStopTimer();
      isRunningTimer.value = false;
    } else {
      timer.onStartTimer();
      isRunningTimer.value = true;
      // }
    }

    notifyListeners();
  }

  void startTimerCountDown() {
    timerFifty.onStartTimer();
    isRunningCountDown.value = true;

    notifyListeners();
  }

  Stream<int> getTimer() {
    return timer.rawTime;
  }

  Stream getTimerFifty() {
    return timerFifty.secondTime;
  }
}
