import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

class TimerController extends ChangeNotifier implements Disposable {
  final ValueNotifier<bool> isRunningTimer = ValueNotifier(false);
  final ValueNotifier<bool> isRunningCountDown = ValueNotifier(false);

  late StreamSubscription subFifty;

  TimerController() {
    subFifty = _listenFiftySecondRemains();
  }

  @override
  void dispose() {
    subFifty.cancel();

    super.dispose();
  }

  final timer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final timerFifty = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: 15000,
  );

  void toggleTimer() {
    if (isRunningTimer.value) {
      isRunningTimer.value = false;
      timer.onStopTimer();
    } else {
      isRunningTimer.value = true;
      timer.onStartTimer();
    }

    notifyListeners();
  }

  void startTimerCountDown() {
    isRunningCountDown.value = true;
    timerFifty.onStartTimer();

    notifyListeners();
  }

  Stream<int> getTimer() {
    return timer.rawTime;
  }

  Stream<int> getTimerFifty() {
    return timerFifty.secondTime;
  }

  StreamSubscription _listenFiftySecondRemains() {
    return timerFifty.secondTime.listen((time) {
      if (time == 0) {
        isRunningTimer.value = true;
        timer.onStartTimer();
      }
    });
  }
}
