// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfigController on _ConfigControllerBase, Store {
  late final _$stateAtom =
      Atom(name: '_ConfigControllerBase.state', context: context);

  @override
  ConfigStates get state {
    _$stateAtom.reportRead();
    return super.state;
  }

  @override
  set state(ConfigStates value) {
    _$stateAtom.reportWrite(value, super.state, () {
      super.state = value;
    });
  }

  late final _$isAdRemovedAtom =
      Atom(name: '_ConfigControllerBase.isAdRemoved', context: context);

  @override
  bool get isAdRemoved {
    _$isAdRemovedAtom.reportRead();
    return super.isAdRemoved;
  }

  @override
  set isAdRemoved(bool value) {
    _$isAdRemovedAtom.reportWrite(value, super.isAdRemoved, () {
      super.isAdRemoved = value;
    });
  }

  late final _$removeAdsAsyncAction =
      AsyncAction('_ConfigControllerBase.removeAds', context: context);

  @override
  Future<void> removeAds() {
    return _$removeAdsAsyncAction.run(() => super.removeAds());
  }

  @override
  String toString() {
    return '''
state: ${state},
isAdRemoved: ${isAdRemoved}
    ''';
  }
}
