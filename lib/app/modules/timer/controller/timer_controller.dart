import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'timer_controller.g.dart';

class TimerController = _TimerControllerBase with _$TimerController;

abstract class _TimerControllerBase with Store implements Disposable {
  @computed
  List<String> get listScrambles => [
        "R2 F D2 F2 L F2 B' U B2 R F2 R F2 R U2 F2 U2 L2 B2 U'",
        "D2 B2 U B L U' D L F' U2 L' F2 L B2 R2 U2 R' U2 R U2 D2",
        "L2 R2 B' L2 D2 B D2 F D2 L2 D2 R' F U' F' D' U' R' B2 F",
        "U' B U' B2 D2 R2 U' B2 R2 B2 R2 D L2 B2 F' L U R D' B2 U2",
        "D U2 R' U2 F2 R U2 R B2 L' B2 R' F2 D B' F' D' B2 F' D R2",
        "R F' R2 U' B' R2 D R' U2 R2 L2 B' U2 B L2 F' R2 B' L2 B2",
        "U' F2 U' B2 D B2 L2 D' R2 F2 L' B' U L2 B D' B' F' L' F'",
      ];

  @computed
  String get randomScramble {
    final random = Random();

    return listScrambles[random.nextInt(listScrambles.length)];
  }

  final timer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  final timerFifty = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: 15000,
  );

  @observable
  late StreamSubscription subFifty = _listenFiftySecondRemains();

  @observable
  Color textColor = Colors.white;

  @observable
  Timer colorChangeTimer = Timer(const Duration(milliseconds: 500), () {});

  @override
  void dispose() {
    subFifty.cancel();
    colorChangeTimer.cancel();

    dispose();
  }

  @action
  void toggleTimer() {
    if (timer.isRunning) {
      timer.onStopTimer();
    } else {
      timerFifty.onStopTimer();
      timer.onStartTimer();
    }
  }

  @action
  void startTimerCountDown() {
    timerFifty.onStartTimer();
  }

  @computed
  Stream<int> get getTimer => timer.rawTime;

  @computed
  Stream<int> get getTimerFifty => timerFifty.secondTime;

  @action
  StreamSubscription _listenFiftySecondRemains() {
    return timerFifty.secondTime.listen((time) {
      if (time == 0) {
        timer.onStartTimer();
      }
    });
  }

  @action
  void startTimerColor() {
    colorChangeTimer = Timer(const Duration(milliseconds: 500), () {
      changeColor(Colors.green);
    });
  }

  @action
  void changeColor(Color color) {
    textColor = color;
  }

  @action
  void resetColor() {
    textColor = Colors.white;
    colorChangeTimer.cancel();
  }
}
