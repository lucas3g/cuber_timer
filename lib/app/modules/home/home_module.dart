import 'package:cuber_timer/app/core_module/core_module.dart';
import 'package:cuber_timer/app/modules/home/presenter/controller/record_controller.dart';
import 'package:cuber_timer/app/modules/home/presenter/home_page.dart';
import 'package:cuber_timer/app/modules/timer/timer_module.dart';
import 'package:flutter_modular/flutter_modular.dart';

class HomeModule extends Module {
  @override
  List<Module> get imports => [CoreModule()];

  @override
  void binds(Injector i) {
    i.addSingleton<RecordController>(
        () => RecordController(localDatabase: i()));
  }

  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) =>
          HomePage(recordController: Modular.get<RecordController>()),
    );

    r.module('/timer', module: TimerModule());
  }
}
