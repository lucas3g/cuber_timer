// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:math';

import 'package:cuber_timer/app/core/data/clients/local_database/helpers/tables.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/local_database.dart';
import 'package:cuber_timer/app/core/data/clients/local_database/params/local_database_params.dart';
import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_states.dart';
import 'package:cuber_timer/app/shared/services/app_review_service.dart';
import 'package:cuber_timer/app/shared/utils/cube_types_list.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

part 'timer_controller.g.dart';

@Injectable()
class TimerController = TimerControllerBase with _$TimerController;

abstract class TimerControllerBase with Store {
  final ILocalDatabase localDatabase;
  final RecordController recordController;
  final IAppReviewService appReviewService;

  TimerControllerBase({
    required this.localDatabase,
    required this.recordController,
    required this.appReviewService,
  });

  @observable
  TimerStates state = StopTimerState();

  @observable
  Color textColor = Colors.white;

  @observable
  String group = "3x3";

  @computed
  List<String> get listScrambles => CubeTypesList.cubeScrambles[group] ?? [];

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

    final bestTimer = recordController.bestTime(group);

    if (bestTimer > 0) {
      if (timer.rawTime.value < bestTimer) {
        emit(BeatRecordTimerState());
        await Future.delayed(const Duration(microseconds: 100));
        emit(StopTimerState());
      }
    }

    await saveTimerLocalDatabase();

    await recordController.getAllRecords();

    await appReviewService.askReviewApp();
  }

  Future saveTimerLocalDatabase() async {
    // Check if user is premium
    final isPremium = AppGlobal.instance.isPremium;

    // If not premium, check record count limit
    if (!isPremium) {
      final totalRecords = await localDatabase.count(
        params: CountDataParams(table: Tables.records),
      );

      // If user has 50 or more records, show limit dialog
      if (totalRecords >= 50) {
        emit(RecordLimitReachedState());
        await Future.delayed(const Duration(milliseconds: 100));
        emit(StopTimerState());
        return;
      }
    }

    // Save the record
    final params = UpdateOrInsertDataParams(
        table: Tables.records,
        data: {'timer': timer.rawTime.value, 'group': group});

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
