import 'package:flutter/material.dart';

enum AppLanguage {
  portuguese(Locale('pt', 'BR')),
  english(Locale('en', 'US'));

  final Locale locale;

  const AppLanguage(this.locale);

  static AppLanguage fromString(String value) {
    switch (value) {
      case 'pt_BR':
        return AppLanguage.portuguese;
      case 'en_US':
        return AppLanguage.english;
      default:
        return AppLanguage.english;
    }
  }
}
