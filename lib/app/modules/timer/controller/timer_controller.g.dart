// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timer_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimerController on _TimerControllerBase, Store {
  Computed<List<String>>? _$listScramblesComputed;

  @override
  List<String> get listScrambles => (_$listScramblesComputed ??=
          Computed<List<String>>(() => super.listScrambles,
              name: '_TimerControllerBase.listScrambles'))
      .value;
  Computed<String>? _$randomScrambleComputed;

  @override
  String get randomScramble =>
      (_$randomScrambleComputed ??= Computed<String>(() => super.randomScramble,
              name: '_TimerControllerBase.randomScramble'))
          .value;
  Computed<Stream<int>>? _$getTimerComputed;

  @override
  Stream<int> get getTimer =>
      (_$getTimerComputed ??= Computed<Stream<int>>(() => super.getTimer,
              name: '_TimerControllerBase.getTimer'))
          .value;
  Computed<Stream<int>>? _$getTimerFiftyComputed;

  @override
  Stream<int> get getTimerFifty => (_$getTimerFiftyComputed ??=
          Computed<Stream<int>>(() => super.getTimerFifty,
              name: '_TimerControllerBase.getTimerFifty'))
      .value;

  late final _$subFiftyAtom =
      Atom(name: '_TimerControllerBase.subFifty', context: context);

  @override
  StreamSubscription<dynamic> get subFifty {
    _$subFiftyAtom.reportRead();
    return super.subFifty;
  }

  @override
  set subFifty(StreamSubscription<dynamic> value) {
    _$subFiftyAtom.reportWrite(value, super.subFifty, () {
      super.subFifty = value;
    });
  }

  late final _$textColorAtom =
      Atom(name: '_TimerControllerBase.textColor', context: context);

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
      Atom(name: '_TimerControllerBase.colorChangeTimer', context: context);

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

  late final _$_TimerControllerBaseActionController =
      ActionController(name: '_TimerControllerBase', context: context);

  @override
  void toggleTimer() {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase.toggleTimer');
    try {
      return super.toggleTimer();
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimerCountDown() {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase.startTimerCountDown');
    try {
      return super.startTimerCountDown();
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  StreamSubscription<dynamic> _listenFiftySecondRemains() {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase._listenFiftySecondRemains');
    try {
      return super._listenFiftySecondRemains();
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void startTimerColor() {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase.startTimerColor');
    try {
      return super.startTimerColor();
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void changeColor(Color color) {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase.changeColor');
    try {
      return super.changeColor(color);
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetColor() {
    final _$actionInfo = _$_TimerControllerBaseActionController.startAction(
        name: '_TimerControllerBase.resetColor');
    try {
      return super.resetColor();
    } finally {
      _$_TimerControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
subFifty: ${subFifty},
textColor: ${textColor},
colorChangeTimer: ${colorChangeTimer},
listScrambles: ${listScrambles},
randomScramble: ${randomScramble},
getTimer: ${getTimer},
getTimerFifty: ${getTimerFifty}
    ''';
  }
}
