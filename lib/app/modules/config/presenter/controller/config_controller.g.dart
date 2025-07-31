// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$ConfigController on _ConfigControllerBase, Store {
  Computed<bool>? _$adsDisabledComputed;

  @override
  bool get adsDisabled =>
      (_$adsDisabledComputed ??= Computed<bool>(() => super.adsDisabled,
              name: '_ConfigControllerBase.adsDisabled'))
          .value;

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

  late final _$isPremiumAtom =
      Atom(name: '_ConfigControllerBase.isPremium', context: context);

  @override
  bool get isPremium {
    _$isPremiumAtom.reportRead();
    return super.isPremium;
  }

  @override
  set isPremium(bool value) {
    _$isPremiumAtom.reportWrite(value, super.isPremium, () {
      super.isPremium = value;
    });
  }

  late final _$isRewardActiveAtom =
      Atom(name: '_ConfigControllerBase.isRewardActive', context: context);

  @override
  bool get isRewardActive {
    _$isRewardActiveAtom.reportRead();
    return super.isRewardActive;
  }

  @override
  set isRewardActive(bool value) {
    _$isRewardActiveAtom.reportWrite(value, super.isRewardActive, () {
      super.isRewardActive = value;
    });
  }

  late final _$checkAdFreeStatusAsyncAction =
      AsyncAction('_ConfigControllerBase.checkAdFreeStatus', context: context);

  @override
  Future<void> checkAdFreeStatus() {
    return _$checkAdFreeStatusAsyncAction.run(() => super.checkAdFreeStatus());
  }

  late final _$fetchSubscriptionsAsyncAction =
      AsyncAction('_ConfigControllerBase.fetchSubscriptions', context: context);

  @override
  Future<void> fetchSubscriptions() {
    return _$fetchSubscriptionsAsyncAction
        .run(() => super.fetchSubscriptions());
  }

  @override
  String toString() {
    return '''
state: ${state},
isPremium: ${isPremium},
isRewardActive: ${isRewardActive},
adsDisabled: ${adsDisabled}
    ''';
  }
}
