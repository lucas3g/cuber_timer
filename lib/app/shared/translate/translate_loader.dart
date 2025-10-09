part of 'translate.dart';

class TranslateLoader {
  final String dictId;
  final String basePath;
  final Locale? locale;

  TranslateLoader({
    required this.basePath,
    this.locale,
    this.dictId = 'default',
  });

  TranslateLoader copyWith({String? dictId, String? basePath, Locale? locale}) {
    return TranslateLoader(
      dictId: dictId ?? this.dictId,
      basePath: basePath ?? this.basePath,
      locale: locale ?? this.locale,
    );
  }

  Future<Map<String, dynamic>> load() async {
    final Locale locale = this.locale ?? PlatformDispatcher.instance.locale;

    if (!await _fileExistsFromAssets('$basePath/${locale.toString()}.yaml')) {
      final String yamlString = await rootBundle.loadString(
        '$basePath/en_US.yaml',
      );

      final dynamic yaml = loadYaml(yamlString);

      return Map<String, dynamic>.from(_getModifiableNode(yaml));
    } else {
      final String yamlString = await rootBundle.loadString(
        '$basePath/${locale.toString()}.yaml',
      );

      final dynamic yaml = loadYaml(yamlString);

      return Map<String, dynamic>.from(_getModifiableNode(yaml));
    }
  }

  static dynamic _getModifiableNode(dynamic node) {
    if (node is Map) {
      return Map<dynamic, dynamic>.of(
        node.map(
          (dynamic key, dynamic value) => MapEntry<dynamic, dynamic>(
            key.toString(),
            _getModifiableNode(value),
          ),
        ),
      );
    }

    return node;
  }

  Future<bool> _fileExistsFromAssets(String path) async {
    try {
      await rootBundle.loadString(path);
      return true;
    } catch (_) {
      return false;
    }
  }
}
