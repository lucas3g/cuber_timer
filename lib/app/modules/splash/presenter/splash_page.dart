import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'package:cuber_timer/app/shared/translate/translate.dart';

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

  @override
  void initState() {
    super.initState();

    _init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            translate('splash_page.title'),
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
