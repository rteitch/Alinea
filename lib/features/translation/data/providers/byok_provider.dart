import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/translation_provider.dart';

/// Power user Bring-Your-Own-Key provider (DeepL / Google / Custom Endpoint)
class BringYourOwnKeyProvider implements TranslationProvider {
  final Dio dio;
  final String providerType; // 'deepl' | 'openai_compatible'
  final String apiKey;
  final String customEndpoint;

  BringYourOwnKeyProvider({
    Dio? dio,
    required this.providerType,
    required this.apiKey,
    required this.customEndpoint,
  }) : dio = dio ?? Dio();

  @override
  String get id => 'byok_$providerType';

  @override
  String get name => 'BYOK (${providerType.toUpperCase()})';

  @override
  String get versionTag => 'byok-v1';

  @override
  bool get isFoss => false;

  @override
  bool get requiresNetwork => true;

  @override
  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    String style = 'natural',
  }) async {
    if (apiKey.isEmpty) {
      throw const TranslationException('API key belum dikonfigurasi untuk provider BYOK.');
    }

    try {
      final response = await dio.post(
        customEndpoint,
        options: Options(headers: {'Authorization': 'Bearer $apiKey'}),
        data: {
          'text': [text],
          'source_lang': sourceLanguage.toUpperCase(),
          'target_lang': targetLanguage.toUpperCase(),
        },
      );

      final result = response.data?['translations']?[0]?['text'] ?? text;
      return TranslationResult(
        originalText: text,
        translatedText: result.toString(),
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        providerId: id,
        providerVersion: versionTag,
        style: style,
      );
    } catch (e) {
      throw TranslationException('Gagal menghubungi vendor pihak ketiga BYOK: $e');
    }
  }

  @override
  Future<LanguageDetectionResult> detectLanguage(String text) async {
    return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 1.0);
  }
}
