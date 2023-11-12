import 'package:cuber_timer/app/modules/home/presenter/home_page.dart';
import 'package:cuber_timer/app/modules/timer/timer_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const HomePage(),
    );

    r.module('/timer', module: TimerModule());
  }
}