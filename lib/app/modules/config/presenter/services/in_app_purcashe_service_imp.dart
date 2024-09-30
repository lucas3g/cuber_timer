import 'dart:async';

import 'package:cuber_timer/app/modules/config/presenter/services/in_app_purcashe_service.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: IInAppPurchaseService)
class InAppPurchaseServiceImp implements IInAppPurchaseService {
  final _adRemovalProductId = 'ad_removal';

  @override
  Future<bool> buyAdRemoval() async {
    final bool available = await InAppPurchase.instance.isAvailable();

    if (!available) {
      throw Exception('Loja não disponível');
    }

    Set<String> productIds = <String>{_adRemovalProductId};
    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(productIds);

    if (response.notFoundIDs.isNotEmpty) {
      throw Exception('Erro ao buscar produto');
    }

    final List<ProductDetails> products = response.productDetails;

    if (products.isNotEmpty) {
      final ProductDetails productDetails = products.first;

      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: productDetails);

      return await InAppPurchase.instance
          .buyNonConsumable(purchaseParam: purchaseParam);
    }

    return false;
  }

  @override
  Future<bool> checkAdRemovalStatus() async {
    final Completer<bool> completer = Completer<bool>();

    try {
      // Restaura as compras
      await InAppPurchase.instance.restorePurchases();

      // Escuta o stream de atualizações de compras
      final Stream<List<PurchaseDetails>> purchaseUpdates =
          InAppPurchase.instance.purchaseStream;

      // Aguarda a primeira atualização de compras
      purchaseUpdates.listen((purchaseDetailsList) {
        // Verifica se a compra de remoção de anúncios está na lista
        for (var purchase in purchaseDetailsList) {
          if (purchase.status == PurchaseStatus.purchased ||
              purchase.status == PurchaseStatus.restored) {
            if (purchase.productID == _adRemovalProductId) {
              completer.complete(true);
              return;
            }
          }
        }
        // Completa com false se não encontrou a compra
        completer.complete(false);
      });

      // Retorna o resultado da verificação
      return await completer.future;
    } catch (e) {
      return false; // Em caso de erro, retorna false
    }
  }
}
