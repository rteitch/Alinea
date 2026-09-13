class TranslationResult {
  final String originalText;
  final String translatedText;
  final String sourceLanguage;
  final String targetLanguage;
  final String providerId;
  final String providerVersion;
  final bool isFromCache;
  final String style;

  const TranslationResult({
    required this.originalText,
    required this.translatedText,
    required this.sourceLanguage,
    required this.targetLanguage,
    required this.providerId,
    required this.providerVersion,
    this.isFromCache = false,
    this.style = 'natural',
  });
}

class LanguageDetectionResult {
  final String detectedLanguage;
  final double confidence;

  const LanguageDetectionResult({
    required this.detectedLanguage,
    required this.confidence,
  });
}

/// Abstract translation provider defined in PRD Section 6.1.
abstract class TranslationProvider {
  String get id;
  String get name;
  String get versionTag;
  bool get isFoss;
  bool get requiresNetwork;

  Future<TranslationResult> translate({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    String style = 'natural',
  });

  Future<LanguageDetectionResult> detectLanguage(String text);
}
