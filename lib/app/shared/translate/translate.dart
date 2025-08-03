import 'dart:ui';

import 'package:flutter/services.dart';
import 'package:yaml/yaml.dart';

part '../mixins/translate_mixin.dart';
part 'translate_loader.dart';

class I18nTranslate {
  static final Map<String, dynamic> _dictionary = <String, dynamic>{};
  static late I18nTranslate _instance;

  static I18nTranslate get instance => _instance;
  static late TranslateLoader _loader;

  I18nTranslate._internal(Map<String, dynamic> dict) {
    _dictionary.addAll(dict);
  }

  static Future<void> create({required TranslateLoader loader}) async {
    _loader = loader;
    final Map<String, dynamic> decodedMap = await loader.load();

    final Map<String, dynamic> dict = <String, dynamic>{
      loader.dictId: decodedMap,
    };

    if (_dictionary.entries.isEmpty) {
      _instance = I18nTranslate._internal(dict);
    } else {
      _dictionary.addAll(dict);
    }
  }

  static Future<void> refresh(Locale locale) async {
    final TranslateLoader newLoader = _loader.copyWith(locale: locale);
    final Map<String, dynamic> decodedMap = await newLoader.load();
    final Map<String, dynamic> dict = <String, dynamic>{
      newLoader.dictId: decodedMap,
    };

    _dictionary.remove(newLoader.dictId);
    _dictionary.addAll(dict);
  }

  String _applyParams(String value, Map<String, String>? params) {
    if (params == null) {
      return value;
    }

    String result = value;
    for (final MapEntry<String, String> param in params.entries) {
      result = result.replaceAll('{${param.key}}', param.value);
    }

    return result;
  }

  String translate(
    String key, {
    String dictId = 'default',
    Map<String, String>? params,
  }) {
    final List<String> parts = key.split('.');

    if (parts.length == 1) {
      if (_dictionary[dictId] == null) {
        return key;
      }

      return (_dictionary[dictId][key] ?? key).replaceAll('\\n', '\n');
    }

    Map<String, dynamic> node = _dictionary[dictId] ?? <String, dynamic>{};
    if (node.entries.isEmpty) {
      return key;
    }

    for (int i = 0; i <= parts.length - 2; i++) {
      if (node[parts[i]] != null) {
        node = Map<String, dynamic>.from(node[parts[i]]);
      }
    }

    final String value = (node[parts.last] ?? key).replaceAll('\\n', '\n');
    return _applyParams(value, params);
  }
}

String translate(
  String key, {
  Map<String, String>? params,
  String dictId = 'default',
}) {
  return I18nTranslate.instance.translate(
    key,
    dictId: dictId,
    params: params,
  );
}
