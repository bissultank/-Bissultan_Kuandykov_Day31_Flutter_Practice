import 'package:dio/dio.dart';

class RuTranslator {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://translate.googleapis.com',
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ),
  );

  final Map<String, String> _cache = {};

  Future<String> translateToRu(String text) =>
      translate(text, targetLanguage: 'ru');

  Future<String> translate(
    String text, {
    required String targetLanguage,
  }) async {
    final normalized = text.trim();
    if (normalized.isEmpty) return text;
    if (targetLanguage == 'ru' && _looksRussian(normalized)) return text;

    final cacheKey = '$targetLanguage::$normalized';
    final cached = _cache[cacheKey];
    if (cached != null) return cached;

    try {
      final response = await _dio.get<dynamic>(
        '/translate_a/single',
        queryParameters: {
          'client': 'gtx',
          'sl': 'auto',
          'tl': targetLanguage,
          'dt': 't',
          'q': normalized,
        },
      );

      final translated = _extractTranslatedText(response.data);
      if (translated.isNotEmpty) {
        _cache[cacheKey] = translated;
        return translated;
      }
    } catch (_) {
      // Fallback: return original if translation is unavailable.
    }

    return text;
  }

  bool _looksRussian(String text) => RegExp(r'[А-Яа-яЁё]').hasMatch(text);

  String _extractTranslatedText(dynamic data) {
    if (data is! List || data.isEmpty) return '';
    final segments = data.first;
    if (segments is! List) return '';

    final buffer = StringBuffer();
    for (final segment in segments) {
      if (segment is List && segment.isNotEmpty && segment.first is String) {
        buffer.write(segment.first as String);
      }
    }
    return buffer.toString().trim();
  }
}
