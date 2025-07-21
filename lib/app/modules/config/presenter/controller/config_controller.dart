import 'package:cuber_timer/app/shared/services/app_review_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../services/in_app_purcashe_service.dart';
import 'config_states.dart';

part 'config_controller.g.dart'; // Código gerado pelo MobX

@Singleton()
class ConfigController = _ConfigControllerBase with _$ConfigController;

abstract class _ConfigControllerBase with Store {
  final IInAppPurchaseService inAppPurchaseService;
  final IAppReviewService appReviewService;

  _ConfigControllerBase(this.inAppPurchaseService, this.appReviewService);

  @observable
  ConfigStates state = ConfigInitialState();

  @observable
  bool isAdRemoved = false;

  @observable
  bool isRewardActive = false;

  @computed
  bool get adsDisabled => isAdRemoved || isRewardActive;

  @action
  Future<void> checkAdFreeStatus() async {
    isRewardActive = await appReviewService.isRewardActive();
  }

  @action
  Future<void> removeAds() async {
    try {
      state = AdRemovalInProgressState();

      // Chama o método de compra e escuta o status via stream
      inAppPurchaseService.purchaseStatusStream.listen((status) {
        if (status == 'Compra concluída com sucesso') {
          state = AdRemovalSuccessState();
          isAdRemoved = true;
        } else if (status == 'Compra cancelada') {
          state = AdRemovalCanceledState();
          isAdRemoved = false;
        } else if (status.contains('Erro')) {
          state = AdRemovalFailureState(status);
          isAdRemoved = false;
        }
      });

      // Inicia o processo de compra
      await inAppPurchaseService.buyAdRemoval();
    } catch (error) {
      state = AdRemovalFailureState(error.toString());
      isAdRemoved = false;
    }
  }
}
