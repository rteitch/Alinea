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

    final normSource = _normalizeLang(sourceLanguage);
    final normTarget = _normalizeLang(targetLanguage);

    try {
      // If text is short, translate in a single call
      if (trimmed.length <= 450) {
        final translated = await _fetchChunk(trimmed, normSource, normTarget);
        return TranslationResult(
          originalText: text,
          translatedText: translated,
          sourceLanguage: normSource,
          targetLanguage: normTarget,
          providerId: id,
          providerVersion: versionTag,
          isFromCache: false,
          style: style,
        );
      }

      // If text is long, split by sentences to respect 500-char API limit
      // Translate in batches of 3 to avoid overwhelming the device/network
      final sentences = _splitSentences(trimmed);
      final results = <String>[];
      
      const batchSize = 3;
      for (var i = 0; i < sentences.length; i += batchSize) {
        final batch = sentences.skip(i).take(batchSize).where((s) => s.trim().isNotEmpty).toList();
        if (batch.isEmpty) continue;
        
        final batchResults = await Future.wait(
          batch.map((s) => _fetchChunk(s.trim(), normSource, normTarget)),
        );
        results.addAll(batchResults);
      }

      final combined = results.join(' ');
      return TranslationResult(
        originalText: text,
        translatedText: combined,
        sourceLanguage: normSource,
        targetLanguage: normTarget,
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
    // Improved sentence splitting that handles:
    // - Abbreviations (Mr., Mrs., Dr., etc.)
    // - Numbers (3.14, 1.5, etc.)
    // - Ellipsis (...)
    // - Multiple punctuation (!?, etc.)
    
    // First, protect common patterns that shouldn't be split
    var protectedText = text;
    final protectionPatterns = [
      RegExp(r'Mr\.', caseSensitive: false),
      RegExp(r'Mrs\.', caseSensitive: false),
      RegExp(r'Ms\.', caseSensitive: false),
      RegExp(r'Dr\.', caseSensitive: false),
      RegExp(r'Prof\.', caseSensitive: false),
      RegExp(r'Sr\.', caseSensitive: false),
      RegExp(r'Jr\.', caseSensitive: false),
      RegExp(r'\d+\.\d+'), // Numbers like 3.14
      RegExp(r'\.{3}'), // Ellipsis
    ];
    
    // Replace protected patterns with placeholders
    final placeholders = <String, String>{};
    var counter = 0;
    
    // First, collect ALL matches across all patterns
    final allMatches = <_MatchInfo>[];
    for (final pattern in protectionPatterns) {
      for (final match in pattern.allMatches(protectedText)) {
        allMatches.add(_MatchInfo(match.start, match.end, match.group(0)!));
      }
    }
    
    // Sort by position (descending) to replace from end to start
    allMatches.sort((a, b) => b.start.compareTo(a.start));
    
    // Replace from end to start to preserve positions
    for (final matchInfo in allMatches) {
      final placeholder = '\x00${counter++}\x00';
      placeholders[placeholder] = matchInfo.text;
      protectedText = protectedText.replaceRange(matchInfo.start, matchInfo.end, placeholder);
    }
    
    // Split on sentence boundaries
    final pattern = RegExp(r'(?<=[.!?])\s+');
    final parts = protectedText.split(pattern);
    
    // Restore protected patterns
    final restoredParts = <String>[];
    for (var part in parts) {
      for (final entry in placeholders.entries) {
        part = part.replaceAll(entry.key, entry.value);
      }
      restoredParts.add(part);
    }
    
    // Now chunk the sentences into groups of ~400 chars
    final chunks = <String>[];
    var current = StringBuffer();
    
    for (final p in restoredParts) {
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

  String _normalizeLang(String lang) {
    final clean = lang.trim().toLowerCase();
    // Handle undefined/undetermined language codes
    if (clean.isEmpty || clean == 'und' || clean == 'mis' || clean == 'zxx' || clean == 'mul') return 'en';
    const iso3To2 = {
      'eng': 'en',
      'ind': 'id',
      'fra': 'fr',
      'fre': 'fr',
      'deu': 'de',
      'ger': 'de',
      'spa': 'es',
      'zho': 'zh',
      'chi': 'zh',
      'jpn': 'ja',
      'ara': 'ar',
      'kor': 'ko',
    };
    if (iso3To2.containsKey(clean)) return iso3To2[clean]!;
    final base = clean.replaceAll('_', '-').split('-').first;
    return iso3To2[base] ?? base;
  }

  @override
  Future<LanguageDetectionResult> detectLanguage(String text) async {
    return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 0.9);
  }
}

/// Helper class to store match position information
class _MatchInfo {
  final int start;
  final int end;
  final String text;
  
  const _MatchInfo(this.start, this.end, this.text);
}
