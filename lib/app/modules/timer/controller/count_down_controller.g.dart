// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'count_down_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$CountDownController on CountDownControllerBase, Store {
  Computed<Stream<int>>? _$getCountDownTimerComputed;

  @override
  Stream<int> get getCountDownTimer => (_$getCountDownTimerComputed ??=
          Computed<Stream<int>>(() => super.getCountDownTimer,
              name: 'CountDownControllerBase.getCountDownTimer'))
      .value;

  late final _$subFiftyAtom =
      Atom(name: 'CountDownControllerBase.subFifty', context: context);

  @override
  StreamSubscription<dynamic> get subFifty {
    _$subFiftyAtom.reportRead();
    return super.subFifty;
  }

  bool _subFiftyIsInitialized = false;

  @override
  set subFifty(StreamSubscription<dynamic> value) {
    _$subFiftyAtom
        .reportWrite(value, _subFiftyIsInitialized ? super.subFifty : null, () {
      super.subFifty = value;
      _subFiftyIsInitialized = true;
    });
  }

  late final _$CountDownControllerBaseActionController =
      ActionController(name: 'CountDownControllerBase', context: context);

  @override
  void startTimerCountDown() {
    final _$actionInfo = _$CountDownControllerBaseActionController.startAction(
        name: 'CountDownControllerBase.startTimerCountDown');
    try {
      return super.startTimerCountDown();
    } finally {
      _$CountDownControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void stopTimerCountDown() {
    final _$actionInfo = _$CountDownControllerBaseActionController.startAction(
        name: 'CountDownControllerBase.stopTimerCountDown');
    try {
      return super.stopTimerCountDown();
    } finally {
      _$CountDownControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  void resetTimerCountDown() {
    final _$actionInfo = _$CountDownControllerBaseActionController.startAction(
        name: 'CountDownControllerBase.resetTimerCountDown');
    try {
      return super.resetTimerCountDown();
    } finally {
      _$CountDownControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  StreamSubscription<int> _listenFiftySecondRemains() {
    final _$actionInfo = _$CountDownControllerBaseActionController.startAction(
        name: 'CountDownControllerBase._listenFiftySecondRemains');
    try {
      return super._listenFiftySecondRemains();
    } finally {
      _$CountDownControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
subFifty: ${subFifty},
getCountDownTimer: ${getCountDownTimer}
    ''';
  }
}
