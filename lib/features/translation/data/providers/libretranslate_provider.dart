import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/translation_provider.dart';

class LibreTranslateProvider implements TranslationProvider {
  final Dio dio;
  final String baseUrl;
  final String? apiKey;

  LibreTranslateProvider({
    Dio? dio,
    this.baseUrl = 'http://localhost:8000/v1',
    this.apiKey,
  }) : dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 10),
              ),
            );

  @override
  String get id => 'libretranslate';

  @override
  String get name => 'LibreTranslate (Self-Hosted)';

  @override
  String get versionTag => 'argos-v1.9';

  @override
  bool get isFoss => true;

  @override
  bool get requiresNetwork => true;

  @override
  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    String style = 'natural',
  }) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return TranslationResult(
        originalText: text,
        translatedText: text,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        providerId: id,
        providerVersion: versionTag,
        style: style,
      );
    }

    try {
      final response = await dio.post(
        '$baseUrl/translate',
        data: {
          'q': trimmed,
          'source': sourceLanguage,
          'target': targetLanguage,
          'format': 'text',
          'style': style,
          if (apiKey != null && apiKey!.isNotEmpty) 'api_key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        final translatedText = (data is Map && data.containsKey('translatedText'))
            ? data['translatedText'].toString()
            : data.toString();

        return TranslationResult(
          originalText: text,
          translatedText: translatedText,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          providerId: id,
          providerVersion: versionTag,
          isFromCache: false,
          style: style,
        );
      } else {
        throw TranslationException(
          'Server translation mengembalikan respons tidak terduga (${response.statusCode})',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const TranslationException(
          'Koneksi ke server translasi timeout. Silakan periksa jaringan Anda atau coba lagi.',
          statusCode: 504,
          isRetryable: true,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const TranslationException(
          'Server translasi self-hosted tidak dapat dijangkau. Pastikan server aktif.',
          statusCode: 503,
          isRetryable: true,
        );
      } else {
        final code = e.response?.statusCode;
        final msg = e.response?.data?['error'] ?? e.message ?? 'Kesalahan jaringan saat translasi';
        throw TranslationException(
          'Gagal menerjemahkan teks: $msg',
          statusCode: code,
          isRetryable: code == 429 || (code != null && code >= 500),
        );
      }
    } catch (e) {
      if (e is TranslationException) rethrow;
      throw TranslationException('Terjadi kesalahan tak terduga saat translasi: $e');
    }
  }

  @override
  Future<LanguageDetectionResult> detectLanguage(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) {
      return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 1.0);
    }

    try {
      final response = await dio.post(
        '$baseUrl/detect-language',
        data: {
          'q': trimmed,
          if (apiKey != null && apiKey!.isNotEmpty) 'api_key': apiKey,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        final data = response.data;
        if (data is List && data.isNotEmpty) {
          final first = data.first;
          return LanguageDetectionResult(
            detectedLanguage: first['language'] ?? 'en',
            confidence: (first['confidence'] as num?)?.toDouble() ?? 0.5,
          );
        } else if (data is Map) {
          return LanguageDetectionResult(
            detectedLanguage: data['language'] ?? 'en',
            confidence: (data['confidence'] as num?)?.toDouble() ?? 0.5,
          );
        }
      }
      return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 0.5);
    } catch (_) {
      // Fallback default
      return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 0.5);
    }
  }
}
