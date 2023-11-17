import 'package:cuber_timer/app/core_module/core_module.dart';
import 'package:cuber_timer/app/modules/home/home_module.dart';
import 'package:cuber_timer/app/modules/timer/controller/count_down_controller.dart';
import 'package:cuber_timer/app/modules/timer/controller/timer_controller.dart';
import 'package:cuber_timer/app/modules/timer/presenter/timer_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimerModule extends Module {
  @override
  List<Module> get imports => [CoreModule(), HomeModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<TimerController>(TimerController.new);
    i.addSingleton<CountDownController>(CountDownController.new);
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const TimerPage(),
    );
  }
}
