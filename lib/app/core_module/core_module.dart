import 'package:flutter_modular/flutter_modular.dart';

import 'services/shared_preferences/local_storage_interface.dart';
import 'services/shared_preferences/shared_preferences_service.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    //LOCAL STORAGE
    i.add<ILocalStorage>(SharedPreferencesService.new);
  }
}
