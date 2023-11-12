import 'package:cuber_timer/app/modules/timer/presenter/timer_page.dart';
import 'package:flutter_modular/flutter_modular.dart';

class TimerModule extends Module {
  @override
  void routes(r) {
    r.child(
      '/',
      child: (context) => const TimerPage(),
    );
  }
}
