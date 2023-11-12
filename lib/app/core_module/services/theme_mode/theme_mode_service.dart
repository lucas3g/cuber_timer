import '../shared_preferences/adapters/shared_params.dart';
import '../shared_preferences/local_storage_interface.dart';

abstract class IThemeMode {
  Future<String> getThemeMode();
  Future saveThemeMode(String themeModeName);
}

class ThemeModeService implements IThemeMode {
  final ILocalStorage localStorage;

  ThemeModeService({
    required this.localStorage,
  });

  @override
  Future<String> getThemeMode() async {
    return await localStorage.getData('theme_mode') ?? 'dark';
  }

  @override
  Future saveThemeMode(String themeModeName) async {
    await localStorage.setData(
      params: SharedParams(key: 'theme_mode', value: themeModeName),
    );
  }
}
