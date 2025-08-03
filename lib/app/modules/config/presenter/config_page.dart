import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../core/domain/entities/subscription_plan.dart';
import '../../../di/dependency_injection.dart';
import 'controller/config_controller.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final ConfigController configController = getIt<ConfigController>();

  @override
  void initState() {
    super.initState();
    configController.fetchSubscriptions();
    configController.checkAdFreeStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(translate('config_page.title_appbar')),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (configController.isPremium)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    translate('config_page.premium_message'),
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              _buildPlanCard(
                translate('config_page.plan_weekly'),
                configController.priceFor(SubscriptionPlan.weekly),
                onTap: () => configController.buyPlan(SubscriptionPlan.weekly),
              ),
              _buildPlanCard(
                translate('config_page.plan_monthly'),
                configController.priceFor(SubscriptionPlan.monthly),
                onTap: () => configController.buyPlan(SubscriptionPlan.monthly),
              ),
              _buildPlanCard(
                translate('config_page.plan_annual'),
                configController.priceFor(SubscriptionPlan.annual),
                onTap: () => configController.buyPlan(SubscriptionPlan.annual),
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
