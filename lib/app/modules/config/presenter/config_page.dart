import 'package:flutter/material.dart';
import '../../../core/domain/entities/subscription_plan.dart';
import '../../../di/dependency_injection.dart';
import 'services/purchase_service.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final PurchaseService purchaseService = getIt<PurchaseService>();

  @override
  void initState() {
    super.initState();
    purchaseService.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('config_page.title_appbar')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: AnimatedBuilder(
          animation: purchaseService,
          builder: (_, __) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (purchaseService.isPremium)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    translate('config_page.premium_message'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              _buildPlanCard(
                translate('config_page.plan_weekly'),
                purchaseService.priceFor(SubscriptionPlan.weekly),
                onTap: () => purchaseService.buy(SubscriptionPlan.weekly),
              ),
              _buildPlanCard(
                translate('config_page.plan_monthly'),
                purchaseService.priceFor(SubscriptionPlan.monthly),
                onTap: () => purchaseService.buy(SubscriptionPlan.monthly),
              ),
              _buildPlanCard(
                translate('config_page.plan_annual'),
                purchaseService.priceFor(SubscriptionPlan.annual),
                onTap: () => purchaseService.buy(SubscriptionPlan.annual),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String price,
      {required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(price),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: Text(translate('config_page.button_subscribe')),
        ),
      ),
    );
  }
}
