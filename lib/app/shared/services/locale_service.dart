import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

import '../../core/data/clients/shared_preferences/adapters/shared_params.dart';
import '../../core/data/clients/shared_preferences/local_storage_interface.dart';
import '../../core/domain/entities/app_language.dart';
import '../translate/translate.dart';

@singleton
class LocaleService extends ChangeNotifier {
  final ILocalStorage _localStorage;
  static const String _localeKey = 'app_locale';

  Locale? _currentLocale;

  LocaleService(this._localStorage);

  Locale get currentLocale => _currentLocale ?? _getSystemLocale();

  Future<void> init() async {
    final String? savedLocale = await _localStorage.getData(_localeKey);

    if (savedLocale != null) {
      final AppLanguage language = AppLanguage.fromString(savedLocale);
      _currentLocale = language.locale;
      await I18nTranslate.refresh(_currentLocale!);
    } else {
      // Usar o idioma do sistema se não houver preferência salva
      _currentLocale = _getSystemLocale();
      await I18nTranslate.refresh(_currentLocale!);
    }

    notifyListeners();
  }

  Locale _getSystemLocale() {
    final systemLocale = ui.PlatformDispatcher.instance.locale;

    // Verificar se o idioma do sistema é suportado
    if (systemLocale.languageCode == 'pt') {
      return AppLanguage.portuguese.locale;
    } else if (systemLocale.languageCode == 'en') {
      return AppLanguage.english.locale;
    }

    // Fallback para inglês se o idioma do sistema não for suportado
    return AppLanguage.english.locale;
  }

  Future<void> changeLocale(Locale newLocale) async {
    if (_currentLocale == newLocale) return;

    _currentLocale = newLocale;

    // Salvar preferência
    final String localeString =
        '${newLocale.languageCode}_${newLocale.countryCode}';
    await _localStorage.setData(
      params: SharedParams(key: _localeKey, value: localeString),
    );

    // Atualizar dicionário de traduções
    await I18nTranslate.refresh(newLocale);

    notifyListeners();
  }

  AppLanguage get currentLanguage {
    if (_currentLocale == AppLanguage.portuguese.locale) {
      return AppLanguage.portuguese;
    }
    return AppLanguage.english;
  }
}
