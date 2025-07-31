import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

import 'subscription_service.dart';

@Injectable(as: ISubscriptionService)
class SubscriptionServiceImp implements ISubscriptionService {
  @override
  Future<List<String>> getUserSubscriptions() async {
    final iap = InAppPurchase.instance;

    final available = await iap.isAvailable();
    if (!available) return [];

    await iap.restorePurchases();

    final response = await iap.queryPastPurchases();

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
