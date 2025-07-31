import 'dart:async';

import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/core/domain/entities/subscription_plan.dart';
import 'package:cuber_timer/app/modules/config/domain/entities/purchase_state.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

@singleton
class PurchaseService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final StreamController<PurchaseState> _controller =
      StreamController<PurchaseState>.broadcast();

  final Map<SubscriptionPlan, String> _prices = {};

  static const Map<SubscriptionPlan, String> _productIds = {
    SubscriptionPlan.weekly: 'weekly_plan',
    SubscriptionPlan.monthly: 'monthly_plan',
    SubscriptionPlan.annual: 'annual_plan',
  };

  static String idForPlan(SubscriptionPlan plan) => _productIds[plan]!;

  Stream<PurchaseState> get stream => _controller.stream;

  String priceFor(SubscriptionPlan plan) => _prices[plan] ?? '';

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    _subscription = _iap.purchaseStream.listen(_onPurchaseUpdated);
    await _iap.restorePurchases();
    await _loadPrices();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      if (purchase.status == PurchaseStatus.purchased ||
          purchase.status == PurchaseStatus.restored) {
        if (purchase.productID == idForPlan(SubscriptionPlan.weekly)) {
          AppGlobal.instance.setPlan(SubscriptionPlan.weekly);
          notifyListeners();
          _controller.add(PurchaseState.success);
        } else if (purchase.productID == idForPlan(SubscriptionPlan.monthly)) {
          AppGlobal.instance.setPlan(SubscriptionPlan.monthly);
          notifyListeners();
          _controller.add(PurchaseState.success);
        } else if (purchase.productID == idForPlan(SubscriptionPlan.annual)) {
          AppGlobal.instance.setPlan(SubscriptionPlan.annual);
          notifyListeners();
          _controller.add(PurchaseState.success);
        }
      }
      if (purchase.status == PurchaseStatus.error) {
        _controller.add(PurchaseState.error);
      }
      if (purchase.status == PurchaseStatus.canceled) {
        _controller.add(PurchaseState.canceled);
      }
    }
  }

  Future<void> _loadPrices() async {
    try {
      final response = await _iap.queryProductDetails(
        _productIds.values.toSet(),
      );
      for (final product in response.productDetails) {
        final plan = _productIds.entries
            .firstWhere((entry) => entry.value == product.id)
            .key;
        _prices[plan] = product.price;
      }
      notifyListeners();
    } catch (_) {
      // ignore errors
    }
  }

  Future<void> buy(SubscriptionPlan plan) async {
    try {
      _controller.add(PurchaseState.loading);
      final id = idForPlan(plan);
      final response = await _iap.queryProductDetails({id});
      if (response.productDetails.isEmpty) {
        _controller.add(PurchaseState.error);
        return;
      }
      final param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (_) {
      _controller.add(PurchaseState.error);
    }
  }

  bool get isPremium => AppGlobal.instance.isPremium;

  @override
  void dispose() {
    _subscription.cancel();
    _controller.close();

    super.dispose();
  }
}
