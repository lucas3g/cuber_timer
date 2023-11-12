import 'package:cuber_timer/app/core_module/constants/constants.dart';
import 'package:cuber_timer/app/shared/components/my_elevated_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(
        child: Text('Cuber Home'),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            MyElevatedButtonWidget(
              width: context.screenWidth * .4,
              label: const Text('Começar'),
              onPressed: () {
                Modular.to.pushNamed('./timer/');
              },
            ),
          ],
        ),
      ),
    );
  }
}
