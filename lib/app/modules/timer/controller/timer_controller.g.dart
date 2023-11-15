// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimerController on TimerControllerBase, Store {
  Computed<List<String>>? _$listScramblesComputed;

  @override
  List<String> get listScrambles => (_$listScramblesComputed ??=
          Computed<List<String>>(() => super.listScrambles,
              name: 'TimerControllerBase.listScrambles'))
      .value;
  Computed<String>? _$randomScrambleComputed;

  @override
  String get randomScramble =>
      (_$randomScrambleComputed ??= Computed<String>(() => super.randomScramble,
              name: 'TimerControllerBase.randomScramble'))
          .value;
  Computed<Stream<int>>? _$getTimerComputed;

  @override
  Stream<int> get getTimer =>
      (_$getTimerComputed ??= Computed<Stream<int>>(() => super.getTimer,
              name: 'TimerControllerBase.getTimer'))
          .value;

  late final _$stateAtom =
      Atom(name: 'TimerControllerBase.state', context: context);

  @override
  TimerStates get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(TimerStates value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$textColorAtom =
      Atom(name: 'TimerControllerBase.textColor', context: context);

  @override
  Color get textColor {
    _$textColorAtom.reportRead();
    return super.textColor;
  }

  @override
  set textColor(Color value) {
    _$textColorAtom.reportWrite(value, super.textColor, () {
      super.textColor = value;
    });
  }

  late final _$colorChangeTimerAtom =
      Atom(name: 'TimerControllerBase.colorChangeTimer', context: context);

  @override
  Timer get colorChangeTimer {
    _$colorChangeTimerAtom.reportRead();
    return super.colorChangeTimer;
  }

  @override
  set colorChangeTimer(Timer value) {
    _$colorChangeTimerAtom.reportWrite(value, super.colorChangeTimer, () {
      super.colorChangeTimer = value;
    });
  }

  late final _$TimerControllerBaseActionController =
      ActionController(name: 'TimerControllerBase', context: context);

  @override
  TimerStates emit(TimerStates newState) {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.emit');
    try {
      return super.emit(newState);
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void toggleTimer() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.toggleTimer');
    try {
      return super.toggleTimer();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopTimer() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.stopTimer');
    try {
      return super.stopTimer();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetTimer() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.resetTimer');
    try {
      return super.resetTimer();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimerColor() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.startTimerColor');
    try {
      return super.startTimerColor();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeColor(Color color) {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.changeColor');
    try {
      return super.changeColor(color);
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetColor() {
    final _$actionInfo = _$TimerControllerBaseActionController.startAction(
        name: 'TimerControllerBase.resetColor');
    try {
      return super.resetColor();
    } finally {
      _$TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state},
textColor: ${textColor},
colorChangeTimer: ${colorChangeTimer},
listScrambles: ${listScrambles},
randomScramble: ${randomScramble},
getTimer: ${getTimer}
    ''';
  }
}
