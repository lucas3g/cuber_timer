import 'package:cuber_timer/app/di/dependency_injection.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_controller.dart';
import 'package:cuber_timer/app/modules/config/presenter/controller/config_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';

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

    autorun((_) async {
      if (configController.state is AdRemovalCanceledState ||
          configController.state is AdRemovalFailureState) {
        await Future.delayed(const Duration(seconds: 1));
        configController.state = ConfigInitialState();
      }
    });
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
          builder: (_) {
            final state = configController.state;

            // Loading State
            if (state is AdRemovalInProgressState) {
              return const Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircularProgressIndicator(),
                    SizedBox(height: 16),
                    Text('Processando sua compra, por favor aguarde...')
                  ],
                ),
              );
            }

            // Success State
            if (state is AdRemovalSuccessState) {
              return _buildConfigOptions(
                context,
                configController.isAdRemoved,
                'Anúncios removidos com sucesso!',
              );
            }

            // Error State
            if (state is AdRemovalFailureState) {
              return _buildErrorMessage(context, state.errorMessage);
            }

            // Canceled State
            if (state is AdRemovalCanceledState) {
              return _buildErrorMessage(
                  context, 'Compra cancelada. Tente novamente.');
            }

            // Default (Initial) State
            return _buildConfigOptions(
                context, configController.isAdRemoved, '');
          },
        ),
      ),
    );
  }

  // Função para construir as opções de configuração
  Widget _buildConfigOptions(
      BuildContext context, bool adsRemoved, String message) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (message.isNotEmpty) ...[
          Text(
            message,
            style: const TextStyle(color: Colors.green, fontSize: 16),
          ),
          const SizedBox(height: 16),
        ],
        ListTile(
          title: const Text('Remover Anúncios'),
          subtitle: Text(adsRemoved ? 'Anúncios removidos' : 'Anúncios ativos'),
          trailing: adsRemoved
              ? const Icon(Icons.check_circle, color: Colors.green)
              : ElevatedButton(
                  onPressed: configController.state is AdRemovalInProgressState
                      ? null // Desabilita o botão se estiver processando
                      : () async {
                          await configController.removeAds();
                        },
                  child: const Text('Remover'),
                ),
        ),
      ],
    );
  }

  // Função para exibir mensagens de erro
  Widget _buildErrorMessage(BuildContext context, String errorMessage) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error, color: Colors.red, size: 40),
          const SizedBox(height: 16),
          Text(
            errorMessage,
            style: const TextStyle(fontSize: 16, color: Colors.red),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
