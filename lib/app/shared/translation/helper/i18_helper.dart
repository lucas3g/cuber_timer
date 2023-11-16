import 'package:flutter/material.dart';
import 'package:flutter_i18n/flutter_i18n.dart';

class I18nHelper {
  String translate(
    BuildContext context,
    String key, {
    Map<String, String>? params,
  }) {
    if (params != null) {
      return FlutterI18n.translate(context, key, translationParams: params)
          .replaceAll('#n', '\n');
    } else {
      return FlutterI18n.translate(context, key, fallbackKey: key)
          .replaceAll('#n', '\n');
    }
  }
}
