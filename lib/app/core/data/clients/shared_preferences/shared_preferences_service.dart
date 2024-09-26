import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'adapters/shared_params.dart';
import 'local_storage_interface.dart';

@Injectable(as: ILocalStorage)
class SharedPreferencesService implements ILocalStorage {
  @override
  Future<dynamic> getData(String key) async {
    final preferences = await SharedPreferences.getInstance();

    final result = preferences.get(key);

    if (result != null) {
      return result;
    }

    return null;
  }

  @override
  Future<bool> setData({required SharedParams params}) async {
    final preferences = await SharedPreferences.getInstance();

    switch (params.value.runtimeType) {
      case String:
        return await preferences.setString(params.key, params.value);
      case int:
        return await preferences.setInt(params.key, params.value);
      case bool:
        return await preferences.setBool(params.key, params.value);
      case double:
        return await preferences.setDouble(params.key, params.value);
      case const (List<String>):
        return await preferences.setStringList(params.key, params.value);
    }
    return false;
  }

  @override
  Future<bool> removeData(String key) async {
    final preferences = await SharedPreferences.getInstance();

    return await preferences.remove(key);
  }
}

class SharedPreferencesException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  SharedPreferencesException(
    this.message, {
    this.stackTrace,
  });
}
