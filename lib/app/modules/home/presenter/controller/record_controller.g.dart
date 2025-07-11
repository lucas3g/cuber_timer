// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'record_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RecordController on RecordControllerBase, Store {
  late final _$stateAtom =
      Atom(name: 'RecordControllerBase.state', context: context);

  @override
  RecordStates get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(RecordStates value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$getAllRecordsAsyncAction =
      AsyncAction('RecordControllerBase.getAllRecords', context: context);

  @override
  Future<dynamic> getAllRecords() {
    return _$getAllRecordsAsyncAction.run(() => super.getAllRecords());
  }

  late final _$getFiveRecordsByGroupAsyncAction = AsyncAction(
      'RecordControllerBase.getFiveRecordsByGroup',
      context: context);

  @override
  Future<dynamic> getFiveRecordsByGroup() {
    return _$getFiveRecordsByGroupAsyncAction
        .run(() => super.getFiveRecordsByGroup());
  }

  late final _$deleteRecordAsyncAction =
      AsyncAction('RecordControllerBase.deleteRecord', context: context);

  @override
  Future<dynamic> deleteRecord(RecordEntity record) {
    return _$deleteRecordAsyncAction.run(() => super.deleteRecord(record));
  }

  late final _$getAllRecordsByGroupAsyncAction = AsyncAction(
      'RecordControllerBase.getAllRecordsByGroup',
      context: context);

  @override
  Future<void> getAllRecordsByGroup(String group) {
    return _$getAllRecordsByGroupAsyncAction
        .run(() => super.getAllRecordsByGroup(group));
  }

  late final _$RecordControllerBaseActionController =
      ActionController(name: 'RecordControllerBase', context: context);

  @override
  RecordStates emit(RecordStates newState) {
    final _$actionInfo = _$RecordControllerBaseActionController.startAction(
        name: 'RecordControllerBase.emit');
    try {
      return super.emit(newState);
    } finally {
      _$RecordControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int bestTime(String group) {
    final _$actionInfo = _$RecordControllerBaseActionController.startAction(
        name: 'RecordControllerBase.bestTime');
    try {
      return super.bestTime(group);
    } finally {
      _$RecordControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int avgFive(String group) {
    final _$actionInfo = _$RecordControllerBaseActionController.startAction(
        name: 'RecordControllerBase.avgFive');
    try {
      return super.avgFive(group);
    } finally {
      _$RecordControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  int avgTwelve(String group) {
    final _$actionInfo = _$RecordControllerBaseActionController.startAction(
        name: 'RecordControllerBase.avgTwelve');
    try {
      return super.avgTwelve(group);
    } finally {
      _$RecordControllerBaseActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
state: ${state}
    ''';
  }
}
