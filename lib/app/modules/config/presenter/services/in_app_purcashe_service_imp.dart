import 'dart:async';

import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

import '../../../../core/constants/constants.dart';
import 'in_app_purcashe_service.dart';

@Injectable(as: IInAppPurchaseService)
class InAppPurchaseServiceImp implements IInAppPurchaseService {
  final _purchaseStatusController = StreamController<String>.broadcast();

  @override
  Stream<String> get purchaseStatusStream => _purchaseStatusController.stream;

  @override
  Future<void> buyAdRemoval() async {
    final bool available = await InAppPurchase.instance.isAvailable();

    if (!available) {
      _purchaseStatusController.add('Loja não disponível');
      return;
    }

    Set<String> productIds = <String>{adRemovalProductId};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      _purchaseStatusController.add('Produto não encontrado');
      return;
    }

    final List<ProductDetails> products = response.productDetails;

    if (products.isNotEmpty) {
      final ProductDetails productDetails = products.first;
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      // Inicia o processo de compra
      final bool result = await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: purchaseParam);

      if (!result) {
        _purchaseStatusController.add('Erro ao iniciar compra');
        return;
      }

      // Escuta o stream de compras para atualizar status em tempo real
      InAppPurchase.instance.purchaseStream.listen((purchaseDetailsList) {
        for (var purchase in purchaseDetailsList) {
          if (purchase.productID == adRemovalProductId) {
            if (purchase.status == PurchaseStatus.purchased) {
              _purchaseStatusController.add('Compra concluída com sucesso');
              return;
            } else if (purchase.status == PurchaseStatus.error) {
              _purchaseStatusController.add('Erro na compra');
              return;
            }
          }
          if (purchase.status == PurchaseStatus.canceled) {
            _purchaseStatusController.add('Compra cancelada');
            return;
          }
        }
      }, onError: (error) {
        _purchaseStatusController.add('Erro desconhecido: $error');
      });
    } else {
      _purchaseStatusController.add('Produto não encontrado');
    }
  }
}
