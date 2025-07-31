import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../../di/dependency_injection.dart';
import 'controller/config_controller.dart';

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
        title: const Text('Configurações'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Observer(
          builder: (_) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (configController.isPremium)
                const Padding(
                  padding: EdgeInsets.only(bottom: 20),
                  child: Text(
                    'Você é Premium. Obrigado por apoiar!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              _buildPlanCard('Plano Semanal', '200,00', onTap: () {}),
              _buildPlanCard('Plano Mensal', '350,00', onTap: () {}),
              _buildPlanCard('Plano Anual', '500,00', onTap: () {}),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPlanCard(String title, String price, {required VoidCallback onTap}) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('R\$ $price de 350,00'),
        trailing: ElevatedButton(
          onPressed: onTap,
          child: const Text('Assinar'),
        ),
      ),
    );
  }
}
