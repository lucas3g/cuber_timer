import 'dart:async';

import 'package:cuber_timer/app/modules/config/presenter/services/purchase_service.dart';
import 'package:cuber_timer/app/shared/services/app_review_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../../../../core/domain/entities/subscription_plan.dart';
import '../../domain/entities/purchase_state.dart';
import 'config_states.dart';

part 'config_controller.g.dart'; // Código gerado pelo MobX

@Singleton()
class ConfigController = _ConfigControllerBase with _$ConfigController;

abstract class _ConfigControllerBase with Store {
  final PurchaseService purchaseService;
  final IAppReviewService appReviewService;

  late final StreamSubscription<PurchaseState> _purchaseSubscription;

  _ConfigControllerBase(this.purchaseService, this.appReviewService) {
    _purchaseSubscription =
        purchaseService.stream.listen(_onPurchaseStateChanged);
  }

  @observable
  ConfigStates state = ConfigInitialState();

  @observable
  bool isPremium = false;

  @observable
  bool isRewardActive = false;

  @computed
  bool get adsDisabled => isPremium || isRewardActive;

  String priceFor(SubscriptionPlan plan) => purchaseService.priceFor(plan);

  Future<void> buyPlan(SubscriptionPlan plan) => purchaseService.buy(plan);

  @action
  Future<void> checkAdFreeStatus() async {
    isRewardActive = await appReviewService.isRewardActive();
  }

  @action
  Future<void> fetchSubscriptions() async {
    await purchaseService.init();
    isPremium = purchaseService.isPremium;
  }

  void _onPurchaseStateChanged(PurchaseState state) {
    if (state == PurchaseState.success) {
      isPremium = purchaseService.isPremium;
    }
  }

  void dispose() {
    _purchaseSubscription.cancel();
  }
}
