import 'package:cuber_timer/app/core_module/services/local_database/isar_service.dart';
import 'package:cuber_timer/app/core_module/services/local_database/local_database.dart';
import 'package:flutter_modular/flutter_modular.dart';

import 'services/shared_preferences/local_storage_interface.dart';
import 'services/shared_preferences/shared_preferences_service.dart';

class CoreModule extends Module {
  @override
  void exportedBinds(Injector i) {
    //LOCAL STORAGE
    i.add<ILocalStorage>(SharedPreferencesService.new);

    //LOCAL DATABASE
    i.add<ILocalDatabase>(IsarService.new);
  }
}
