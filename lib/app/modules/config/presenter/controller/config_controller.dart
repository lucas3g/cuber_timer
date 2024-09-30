import 'package:cuber_timer/app/modules/config/presenter/services/in_app_purcashe_service.dart';
import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import 'config_states.dart';

part 'config_controller.g.dart'; // Código gerado pelo MobX

@Singleton()
class ConfigController = _ConfigControllerBase with _$ConfigController;

abstract class _ConfigControllerBase with Store {
  final IInAppPurchaseService inAppPurchaseService;

  _ConfigControllerBase(this.inAppPurchaseService);

  @observable
  ConfigStates state = ConfigInitialState();

  @observable
  bool isAdRemoved = false;

  @action
  Future<void> removeAds() async {
    state = AdRemovalInProgressState();

    try {
      final result = await inAppPurchaseService.buyAdRemoval();

      if (result) {
        state = AdRemovalSuccessState();
        isAdRemoved = true;
      } else {
        state = AdRemovalFailureState("Falha ao remover anúncios.");
        isAdRemoved = false;
      }
    } on Exception catch (error) {
      state = AdRemovalFailureState(error.toString());
      isAdRemoved = false;
    }
  }

  // Função para verificar se os anúncios foram removidos anteriormente
  @action
  Future<void> checkAdRemovalStatus() async {
    try {
      final result = await inAppPurchaseService.checkAdRemovalStatus();

      if (result) {
        state = AdRemovalSuccessState();
        isAdRemoved = true;
      } else {
        state = ConfigInitialState();
        isAdRemoved = false;
      }
    } catch (error) {
      state = AdRemovalFailureState(error.toString());
      isAdRemoved = false;
    }
  }
}
