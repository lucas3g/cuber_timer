import 'dart:async';
import 'dart:io';

import 'package:cuber_timer/app/core/domain/entities/app_global.dart';
import 'package:cuber_timer/app/core/domain/entities/subscription_plan.dart';
import 'package:cuber_timer/app/modules/subscriptions/domain/entities/purchase_state.dart';
import 'package:flutter/foundation.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:injectable/injectable.dart';

@singleton
class PurchaseService extends ChangeNotifier {
  final InAppPurchase _iap = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  final StreamController<PurchaseState> controller =
      StreamController<PurchaseState>.broadcast();

  final Map<SubscriptionPlan, String> _prices = {};

  static final Map<SubscriptionPlan, String> _productIds = {
    SubscriptionPlan.weekly: Platform.isAndroid
        ? 'weekly_plan'
        : 'weekly_plan_cubetimer',
    SubscriptionPlan.monthly: Platform.isAndroid
        ? 'monthly_plan'
        : 'monthly_plan_cubetimer',
    SubscriptionPlan.annual: Platform.isAndroid
        ? 'annual_plan'
        : 'annual_plan_cubetimer',
  };

  static String idForPlan(SubscriptionPlan plan) => _productIds[plan]!;

  Stream<PurchaseState> get stream => controller.stream;

  String priceFor(SubscriptionPlan plan) => _prices[plan] ?? '';

  double rawPriceFor(SubscriptionPlan plan) {
    final price = _prices[plan];
    if (price == null || price.isEmpty) return 0.0;
    final cleaned = price.replaceAll(RegExp(r'[^0-9.,]'), '');
    final normalized = cleaned.replaceAll(',', '.');
    return double.tryParse(normalized) ?? 0.0;
  }

  Future<void> init() async {
    final bool available = await _iap.isAvailable();
    if (!available) return;
    _subscription = _iap.purchaseStream.listen(
      _onPurchaseUpdated,
      onError: (error) {
        controller.add(PurchaseState.error);
      },
    );
    await _iap.restorePurchases();
    await _loadPrices();
  }

  void _onPurchaseUpdated(List<PurchaseDetails> purchases) {
    for (final purchase in purchases) {
      final isNewPurchase = purchase.status == PurchaseStatus.purchased;
      final isRestored = purchase.status == PurchaseStatus.restored;

      if (isNewPurchase || isRestored) {
        SubscriptionPlan? plan;

        if (purchase.productID == idForPlan(SubscriptionPlan.weekly)) {
          plan = SubscriptionPlan.weekly;
        } else if (purchase.productID == idForPlan(SubscriptionPlan.monthly)) {
          plan = SubscriptionPlan.monthly;
        } else if (purchase.productID == idForPlan(SubscriptionPlan.annual)) {
          plan = SubscriptionPlan.annual;
        }

        if (plan != null) {
          AppGlobal.instance.setPlan(plan);
          notifyListeners();

          // Só emite success para compras novas, restored para compras restauradas
          controller.add(isNewPurchase ? PurchaseState.success : PurchaseState.restored);
        }
      }

      if (purchase.status == PurchaseStatus.error) {
        controller.add(PurchaseState.error);
      }
      if (purchase.status == PurchaseStatus.canceled) {
        controller.add(PurchaseState.canceled);
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
      controller.add(PurchaseState.loading);
      final id = idForPlan(plan);
      final response = await _iap.queryProductDetails({id});
      if (response.productDetails.isEmpty) {
        controller.add(PurchaseState.error);
        return;
      }
      final param = PurchaseParam(
        productDetails: response.productDetails.first,
      );
      await _iap.buyNonConsumable(purchaseParam: param);
    } catch (_) {
      controller.add(PurchaseState.error);
    }
  }

  bool get isPremium => AppGlobal.instance.isPremium;

  @override
  void dispose() {
    _subscription.cancel();
    controller.close();

    super.dispose();
  }
}
