import 'package:cuber_timer/app/core/constants/constants.dart';
import 'package:cuber_timer/app/core/domain/entities/named_routes.dart';
import 'package:cuber_timer/app/shared/components/my_circular_progress_widget.dart';
import 'package:flutter/material.dart';

class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage> {
  Future _init() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      await Navigator.pushNamed(context, NamedRoutes.home.route);
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
