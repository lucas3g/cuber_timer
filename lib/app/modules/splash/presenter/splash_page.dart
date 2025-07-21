import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';

import '../../../core/constants/constants.dart';
import '../../../core/domain/entities/named_routes.dart';
import '../../../di/dependency_injection.dart';
import '../../../shared/components/my_circular_progress_widget.dart';
import '../../config/presenter/controller/config_controller.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  final ConfigController configController = getIt<ConfigController>();

  Future _init() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      await Navigator.pushNamedAndRemoveUntil(
          context, NamedRoutes.home.route, (route) => false);
    }
  }

  Future _restorePurchases() async {
    await InAppPurchase.instance.restorePurchases();
  }

  @override
  void initState() {
    _restorePurchases();

    super.initState();

    InAppPurchase.instance.purchaseStream.listen((purchaseDetailsList) {
      for (var purchase in purchaseDetailsList) {
        if (purchase.status == PurchaseStatus.purchased ||
            purchase.status == PurchaseStatus.restored) {
          if (purchase.productID == adRemovalProductId) {
            configController.isAdRemoved = true;

            return;
          }
        }
      }
      // Completa com false se não encontrou a compra
      configController.isAdRemoved = false;
    });

    configController.checkAdFreeStatus();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.translate.splashPage.title,
            style: context.textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 25,
            ),
          ),
          const MyCircularProgressWidget(),
        ],
      ),
    );
  }
}
