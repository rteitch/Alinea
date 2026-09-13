import '../../../core/errors/failures.dart';
import '../../glossary/data/glossary_repository.dart';
import '../data/translation_cache_repository.dart';
import 'translation_provider.dart';

class TranslationCoordinator {
  final TranslationCacheRepository cacheRepo;
  final GlossaryRepository glossaryRepo;
  TranslationProvider activeProvider;

  TranslationCoordinator({
    required this.cacheRepo,
    required this.glossaryRepo,
    required this.activeProvider,
  });

  void setProvider(TranslationProvider provider) {
    activeProvider = provider;
  }

  /// Complete end-to-end translation pipeline (PRD Section 5.1 & 6.5):
  /// 1. Check Glossary (book-scoped > global) -> Instant HIT
  /// 2. Check Local Drift Cache -> Instant HIT (< 200ms)
  /// 3. Call active provider (LibreTranslate default) -> Remote inference
  /// 4. Save result in local cache
  Future<TranslationResult> translateText({
    int? bookId,
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
        providerId: activeProvider.id,
        providerVersion: activeProvider.versionTag,
        style: style,
      );
    }

    // 1. Glossary Lookup (ISTQB Decision Table: Book-specific > Global)
    final glossaryMatch = await glossaryRepo.resolveTerm(
      bookId: bookId,
      sourceTerm: trimmed,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
    );

    if (glossaryMatch != null) {
      return TranslationResult(
        originalText: text,
        translatedText: glossaryMatch,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        providerId: 'glossary',
        providerVersion: 'v1',
        isFromCache: true,
        style: style,
      );
    }

    // 2. Local Cache Lookup (Drift SQLite)
    final cached = await cacheRepo.lookupTranslation(
      text: trimmed,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      provider: activeProvider.id,
      providerVersion: activeProvider.versionTag,
      style: style,
    );

    if (cached != null) {
      return TranslationResult(
        originalText: text,
        translatedText: cached.translatedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        providerId: cached.provider,
        providerVersion: cached.providerVersion,
        isFromCache: true,
        style: cached.style,
      );
    }

    // 3. Provider Inference (LibreTranslate default)
    try {
      final result = await activeProvider.translate(
        text: trimmed,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        style: style,
      );

      // 4. Save to Local Cache
      await cacheRepo.saveTranslation(
        text: trimmed,
        translatedText: result.translatedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        provider: result.providerId,
        providerVersion: result.providerVersion,
        style: style,
      );

      return result;
    } catch (e) {
      if (e is TranslationException) rethrow;
      throw TranslationException('Gagal menerjemahkan teks: $e');
    }
  }

  Future<String> detectLanguage(String text) async {
    try {
      final res = await activeProvider.detectLanguage(text);
      return res.detectedLanguage;
    } catch (_) {
      return 'en';
    }
  }
}
