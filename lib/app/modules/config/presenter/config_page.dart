import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_controller.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class ConfigPage extends StatefulWidget {
  const ConfigPage({super.key});

  @override
  State<ConfigPage> createState() => _ConfigPageState();
}

class _ConfigPageState extends State<ConfigPage> {
  final ConfigController configController = getIt<ConfigController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Configurações'),
      ),
      body: Observer(
        builder: (_) {
          final state = configController.state;

          if (state is AdRemovalSuccessState) {
            return _buildConfigOptions(context, configController.isAdRemoved);
          }

          if (state is AdRemovalFailureState) {
            return Center(
              child: Text(state.errorMessage),
            );
          }

          return _buildConfigOptions(context, configController.isAdRemoved);
        },
      ),
    );
  }

  Widget _buildConfigOptions(BuildContext context, bool adsRemoved) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: const Text('Remover Anúncios'),
            subtitle:
                Text(adsRemoved ? 'Anúncios removidos' : 'Anúncios ativos'),
            trailing: adsRemoved
                ? const Icon(Icons.check_circle, color: Colors.green)
                : ElevatedButton(
                    onPressed: () async {
                      await configController.removeAds();
                    },
                    child: const Text('Remover'),
                  ),
          ),
        ],
      ),
    );
  }
}
