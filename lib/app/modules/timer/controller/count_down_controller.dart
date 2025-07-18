import 'dart:async';

import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'timer_controller.dart';

part 'count_down_controller.g.dart';

@Injectable()
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
  StreamSubscription<int> _listenFiftySecondRemains() {
    return countDownTimer.secondTime.listen((time) {
      print('tempo $time');

      if (time == 0) {
        stopTimerCountDown();
        timerController.toggleTimer();
      }
    });
  }

  @observable
  late StreamSubscription subFifty = _listenFiftySecondRemains();
}
