import 'package:injectable/injectable.dart';
import 'package:mobx/mobx.dart';

import '../services/in_app_purcashe_service.dart';
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
