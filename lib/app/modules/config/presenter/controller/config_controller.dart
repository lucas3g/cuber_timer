import 'package:cuber_timer/app/shared/services/app_review_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../services/subscription_service.dart';
import '../../../core/constants/constants.dart';
import 'config_states.dart';

part 'config_controller.g.dart'; // Código gerado pelo MobX

@Singleton()
class ConfigController = _ConfigControllerBase with _$ConfigController;

abstract class _ConfigControllerBase with Store {
  final ISubscriptionService subscriptionService;
  final IAppReviewService appReviewService;

  _ConfigControllerBase(this.subscriptionService, this.appReviewService);

  @observable
  ConfigStates state = ConfigInitialState();

  @observable
  bool isPremium = false;

  @observable
  bool isRewardActive = false;

  @computed
  bool get adsDisabled => isPremium || isRewardActive;

  @action
  Future<void> checkAdFreeStatus() async {
    isRewardActive = await appReviewService.isRewardActive();
  }

  @action
  Future<void> fetchSubscriptions() async {
    final subs = await subscriptionService.getUserSubscriptions();
    isPremium = subs.contains(weeklyPlanId) ||
        subs.contains(monthlyPlanId) ||
        subs.contains(annualPlanId);
  }
}
