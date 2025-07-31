import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

import 'subscription_service.dart';

@Injectable(as: ISubscriptionService)
class SubscriptionServiceImp implements ISubscriptionService {
  @override
  Future<List<String>> getUserSubscriptions() async {
    final available = await InAppPurchase.instance.isAvailable();
    if (!available) return [];

    await InAppPurchase.instance.restorePurchases();

    final response = await InAppPurchase.instance.restorePurchases();
    final activeSubscriptions = <String>[];
    for (final purchase in response.pastPurchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        activeSubscriptions.add(purchase.productID);
      }
    }
    return activeSubscriptions;
  }
}
