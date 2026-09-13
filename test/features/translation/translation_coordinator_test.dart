import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/errors/failures.dart';
import 'package:alinea/core/storage/database.dart';
import 'package:alinea/features/glossary/data/glossary_repository.dart';
import 'package:alinea/features/translation/data/translation_cache_repository.dart';
import 'package:alinea/features/translation/domain/translation_coordinator.dart';
import 'package:alinea/features/translation/domain/translation_provider.dart';

class MockTranslationProvider implements TranslationProvider {
  @override
  final String id;
  @override
  final String name;
  @override
  final String versionTag;
  @override
  final bool isFoss;
  @override
  final bool requiresNetwork;

  int callCount = 0;
  bool shouldThrow = false;
  String Function(String)? responseModifier;

  MockTranslationProvider({
    this.id = 'libretranslate',
    this.name = 'Mock LibreTranslate',
    this.versionTag = 'argos-v1',
    this.isFoss = true,
    this.requiresNetwork = true,
  });

  @override
  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    String style = 'natural',
  }) async {
    callCount++;
    if (shouldThrow) {
      throw const TranslationException(
        'Server translation offline atau timeout',
        statusCode: 503,
        isRetryable: true,
      );
    }
    final translated = responseModifier != null ? responseModifier!(text) : 'Translated: $text';
    return TranslationResult(
      originalText: text,
      translatedText: translated,
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      providerId: id,
      providerVersion: versionTag,
      style: style,
    );
  }

  @override
  Future<LanguageDetectionResult> detectLanguage(String text) async {
    return const LanguageDetectionResult(detectedLanguage: 'en', confidence: 0.95);
  }
}

void main() {
  late AppDatabase db;
  late TranslationCacheRepository cacheRepo;
  late GlossaryRepository glossaryRepo;
  late MockTranslationProvider mockProvider;
  late TranslationCoordinator coordinator;

  setUp(() {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) => rawDb.execute('PRAGMA foreign_keys = ON;'),
      ),
    );
    cacheRepo = TranslationCacheRepository(db: db);
    glossaryRepo = GlossaryRepository(db: db);
    mockProvider = MockTranslationProvider();
    coordinator = TranslationCoordinator(
      cacheRepo: cacheRepo,
      glossaryRepo: glossaryRepo,
      activeProvider: mockProvider,
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('TranslationCoordinator - ISTQB Decision Table Testing', () {
    test('Rule 1: Glossary HIT returns instant translation without querying cache or provider', () async {
      await glossaryRepo.setTerm(
        sourceTerm: 'EPUB',
        preferredTranslation: 'Format Buku Elektronik',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      final result = await coordinator.translateText(
        text: 'EPUB',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(result.translatedText, equals('Format Buku Elektronik'));
      expect(result.providerId, equals('glossary'));
      expect(result.isFromCache, isTrue);
      expect(mockProvider.callCount, equals(0)); // Provider was never called
    });

    test('Rule 2: Local Cache HIT returns stored result without calling remote provider', () async {
      // Seed cache
      await cacheRepo.saveTranslation(
        text: 'Good morning',
        translatedText: 'Selamat pagi',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-v1',
      );

      final result = await coordinator.translateText(
        text: 'Good morning',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(result.translatedText, equals('Selamat pagi'));
      expect(result.isFromCache, isTrue);
      expect(mockProvider.callCount, equals(0)); // Remote provider skipped
    });

    test('Rule 3: Local Cache MISS calls provider and stores result into cache', () async {
      final result = await coordinator.translateText(
        text: 'Quantum Computing',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(result.translatedText, equals('Translated: Quantum Computing'));
      expect(result.isFromCache, isFalse);
      expect(mockProvider.callCount, equals(1));

      // Subsequent query should now HIT cache
      final cachedResult = await coordinator.translateText(
        text: 'Quantum Computing',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(cachedResult.isFromCache, isTrue);
      expect(mockProvider.callCount, equals(1)); // Still 1, didn't call provider again
    });

    test('Rule 4: Provider Failure throws TranslationException gracefully', () async {
      mockProvider.shouldThrow = true;

      expect(
        () => coordinator.translateText(
          text: 'Unreachable server text',
          sourceLanguage: 'en',
          targetLanguage: 'id',
        ),
        throwsA(isA<TranslationException>().having((e) => e.statusCode, 'statusCode', equals(503))),
      );
    });
  });

  group('TranslationCoordinator - ISTQB Equivalence Partitioning & Edge Cases', () {
    test('EP: Empty or whitespace-only text returns identity without provider call', () async {
      final result = await coordinator.translateText(
        text: '   \t\n  ',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(result.translatedText.trim(), isEmpty);
      expect(mockProvider.callCount, equals(0));
    });

    test('Transparansi FOSS: Default provider has isFoss == true', () {
      expect(coordinator.activeProvider.isFoss, isTrue);
      expect(coordinator.activeProvider.id, equals('libretranslate'));
    });

    test('State Transition: Provider switching dynamically to custom BYOK', () async {
      final byok = MockTranslationProvider(
        id: 'byok_deepl',
        name: 'DeepL BYOK',
        isFoss: false,
        versionTag: 'v2',
      );

      coordinator.setProvider(byok);
      expect(coordinator.activeProvider.id, equals('byok_deepl'));
      expect(coordinator.activeProvider.isFoss, isFalse);

      await coordinator.translateText(
        text: 'Switching test',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      expect(byok.callCount, equals(1));
      expect(mockProvider.callCount, equals(0));
    });
  });
}
