// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:cuber_timer/app/core_module/services/local_database/helpers/tables.dart';
import 'package:cuber_timer/app/core_module/services/local_database/local_database.dart';
import 'package:cuber_timer/app/core_module/services/local_database/params/local_database_params.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'timer_controller.g.dart';

class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store implements Disposable {
  final ILocalDatabase localDatabase;
  final RecordController recordController;

  TimerControllerBase({
    required this.localDatabase,
    required this.recordController,
  });

  @observable
  TimerStates state = StopTimerState();

  @observable
  Color textColor = Colors.white;

  @computed
  List<String> get listScrambles => [
        "R2 F D2 F2 L F2 B' U B2 R F2 R F2 R U2 F2 U2 L2 B2 U'",
        "D2 B2 U B L U' D L F' U2 L' F2 L B2 R2 U2 R' U2 R U2 D2",
        "L2 R2 B' L2 D2 B D2 F D2 L2 D2 R' F U' F' D' U' R' B2 F",
        "U' B U' B2 D2 R2 U' B2 R2 B2 R2 D L2 B2 F' L U R D' B2 U2",
        "D U2 R' U2 F2 R U2 R B2 L' B2 R' F2 D B' F' D' B2 F' D R2",
        "R F' R2 U' B' R2 D R' U2 R2 L2 B' U2 B L2 F' R2 B' L2 B2",
        "U' F2 U' B2 D B2 L2 D' R2 F2 L' B' U L2 B D' B' F' L' F'",
        "F2 D' R2 F2 D' U2 R2 D2 B2 L2 B2 L2 R B2 R D2 U B' D2 U",
        "L2 F2 D2 L2 B2 R B2 R' B2 U2 B2 F D' R2 B2 F2 R' D' B L'",
        "R B L2 F' U' D' R B2 D2 F' R2 B' R2 F L2 D2 F' R F",
        "D2 F R2 B L2 B D2 B L2 D2 F L2 D' L B D' F' D2 L2 B' U",
        "B L2 R2 D2 F2 D F2 R2 D2 U R2 F' R D' L2 B' L U' R U'",
        "D L' B2 R2 L' B' U' R D' F2 U2 F L2 D2 B D2 F' L2 B' D2",
        "D' R F' B2 D2 R U B' R2 L2 B2 R2 B R2 D2 R2 F L U",
      ];

  @computed
  String get randomScramble {
    final random = Random();

    return listScrambles[random.nextInt(listScrambles.length)];
  }

  final timer = StopWatchTimer(
    mode: StopWatchMode.countUp,
  );

  @observable
  Timer colorChangeTimer = Timer(const Duration(milliseconds: 500), () {});

  @override
  void dispose() {
    colorChangeTimer.cancel();

    dispose();
  }

  @action
  TimerStates emit(TimerStates newState) {
    return state = newState;
  }

  @action
  void toggleTimer() {
    if (timer.isRunning) {
      emit(StopTimerState());
      timer.onStopTimer();
    } else {
      emit(StartTimerState());
      timer.onStartTimer();
    }
  }

  @action
  Future stopTimer() async {
    emit(StopTimerState());
    timer.onStopTimer();

    final bestTimer = recordController.bestTime;

    if (bestTimer > 0) {
      if (timer.rawTime.value < bestTimer) {
        emit(BeatRecordTimerState());
        await Future.delayed(const Duration(microseconds: 100));
        emit(StopTimerState());
      }
    }

    await saveTimerLocalDatabase();
  }

  Future saveTimerLocalDatabase() async {
    final params = UpdateOrInsertDataParams(
        table: Tables.records, data: {'timer': timer.rawTime.value});

    await localDatabase.updateOrInsert(params: params);
  }

  @action
  void resetTimer() {
    emit(StopTimerState());
    timer.onResetTimer();
  }

  @computed
  Stream<int> get getTimer => timer.rawTime;

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
