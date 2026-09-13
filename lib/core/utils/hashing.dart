import 'dart:convert';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';

/// Utilities for computing stable SHA-256 hashes used across Alinea.
class AppHashing {
  AppHashing._();

  /// Computes SHA-256 hexadecimal hash from raw bytes (used for EPUB file deduplication).
  static String computeFileHash(Uint8List bytes) {
    return sha256.convert(bytes).toString();
  }

  /// Normalizes text for consistent translation cache keys:
  /// - Trims leading and trailing whitespaces
  /// - Replaces multiple whitespace and newline sequences with single spaces
  /// - Strips zero-width characters (\u200B, \u200C, \u200D, \uFEFF)
  static String normalizeText(String text) {
    return text
        .replaceAll(RegExp(r'[\u200B-\u200D\uFEFF]'), '')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  /// Generates the deterministic SHA-256 hash for translation cache lookup
  /// Formula: hash(source_language + ':' + target_language + ':' + normalized_text + ':' + provider_version + ':' + style)
  static String computeTranslationCacheHash({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    required String providerVersion,
    String style = 'natural',
  }) {
    final normalized = normalizeText(text);
    final key = '$sourceLanguage:$targetLanguage:$normalized:$providerVersion:$style';
    return sha256.convert(utf8.encode(key)).toString();
  }

  /// Computes text-only SHA-256 hash for TranslationUnits (source_text_hash)
  static String computeSourceTextHash(String text) {
    final normalized = normalizeText(text);
    return sha256.convert(utf8.encode(normalized)).toString();
  }
}
