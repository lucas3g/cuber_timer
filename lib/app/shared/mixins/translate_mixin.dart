part of '../translate/translate.dart';

mixin I18nTranslateMixin {
  final String _base = '';
  final String _dictId = 'default';

  void setBaseTranslate({required String base, String? dictId}) {
    _base.replaceRange(0, base.length, base);
    _dictId.replaceRange(0, _dictId.length, dictId ?? 'default');
  }

  String translate(
    String key, {
    bool useBaseTranslate = true,
    Map<String, String>? params,
  }) {
    final String base = _base.isNotEmpty ? '$_base.' : '';
    return I18nTranslate.instance.translate(
      '${useBaseTranslate ? base : ''}$key',
      dictId: _dictId,
      params: params,
    );
  }
}
