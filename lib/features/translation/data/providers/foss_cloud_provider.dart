import 'dart:async';
import 'package:dio/dio.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/translation_provider.dart';

/// Free open-source cloud translation provider using MyMemory API.
/// 100% Free ($0 marginal cost), no API key needed, operates directly on mobile networks.
class FossCloudProvider implements TranslationProvider {
  final Dio dio;

  FossCloudProvider({Dio? dio})
      : dio = dio ??
            Dio(
              BaseOptions(
                connectTimeout: const Duration(seconds: 8),
                receiveTimeout: const Duration(seconds: 10),
                headers: {
                  'User-Agent': 'AlineaReader/1.0 (Android; FOSS)',
                },
              ),
            );

  @override
  String get id => 'foss_cloud';

  @override
  String get name => 'Alinea FOSS Cloud';

  @override
  String get versionTag => 'mymemory-v1';

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
      // If text is short, translate in a single call
      if (trimmed.length <= 450) {
        final translated = await _fetchChunk(trimmed, sourceLanguage, targetLanguage);
        return TranslationResult(
          originalText: text,
          translatedText: translated,
          sourceLanguage: sourceLanguage,
          targetLanguage: targetLanguage,
          providerId: id,
          providerVersion: versionTag,
          isFromCache: false,
          style: style,
        );
      }

      // If text is long, split by sentences to respect 500-char API limit
      final sentences = _splitSentences(trimmed);
      final results = <String>[];
      for (final s in sentences) {
        if (s.trim().isEmpty) continue;
        final res = await _fetchChunk(s.trim(), sourceLanguage, targetLanguage);
        results.add(res);
      }

      final combined = results.join(' ');
      return TranslationResult(
        originalText: text,
        translatedText: combined,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        providerId: id,
        providerVersion: versionTag,
        isFromCache: false,
        style: style,
      );
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout ||
          e.type == DioExceptionType.sendTimeout) {
        throw const TranslationException(
          'Koneksi internet timeout saat menghubungi server translasi.',
          statusCode: 504,
          isRetryable: true,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        throw const TranslationException(
          'Tidak dapat terhubung ke internet. Pastikan perangkat Anda terhubung ke jaringan.',
          statusCode: 503,
          isRetryable: true,
        );
      } else {
        throw TranslationException(
          'Layanan translasi cloud sementara tidak dapat diakses (${e.response?.statusCode ?? 'Network error'}).',
          statusCode: e.response?.statusCode,
          isRetryable: true,
        );
      }
    } catch (e) {
      if (e is TranslationException) rethrow;
      throw TranslationException('Terjadi kendala saat menerjemahkan: $e');
    }
  }

  Future<String> _fetchChunk(String chunk, String sourceLang, String targetLang) async {
    final langPair = '$sourceLang|$targetLang';
    final response = await dio.get(
      'https://api.mymemory.translated.net/get',
      queryParameters: {
        'q': chunk,
        'langpair': langPair,
      },
    );

    if (response.statusCode == 200 && response.data != null) {
      final data = response.data;
      if (data is Map && data.containsKey('responseData')) {
        final responseData = data['responseData'];
        if (responseData is Map && responseData.containsKey('translatedText')) {
          return _unescapeHtml(responseData['translatedText'].toString());
        }
      }
      return chunk;
    } else {
      throw TranslationException(
        'Server cloud mengembalikan status ${response.statusCode}',
        statusCode: response.statusCode,
      );
    }
  }

  List<String> _splitSentences(String text) {
    final pattern = RegExp(r'(?<=[.!?])\s+');
    final parts = text.split(pattern);
    final chunks = <String>[];
    var current = StringBuffer();

    for (final p in parts) {
      if (current.length + p.length > 400 && current.isNotEmpty) {
        chunks.add(current.toString().trim());
        current = StringBuffer();
      }
      if (current.isNotEmpty) current.write(' ');
      current.write(p);
    }

    if (current.isNotEmpty) {
      chunks.add(current.toString().trim());
    }

    return chunks.isNotEmpty ? chunks : [text];
  }

  String _unescapeHtml(String input) {
    return input
        .replaceAll('&quot;', '"')
        .replaceAll('&#39;', "'")
        .replaceAll('&amp;', '&')
        .replaceAll('&lt;', '<')
        .replaceAll('&gt;', '>')
        .replaceAll('&nbsp;', ' ');
  }

  @override
  Future<LanguageDetectionResult> detectLanguage(String text) async {
    return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 0.9);
  }
}
