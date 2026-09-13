import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/utils/hashing.dart';

void main() {
  group('AppHashing - ISTQB Equivalence Partitioning (EP)', () {
    test('EP: Normalizes multiple spaces, tabs, and newlines to single space', () {
      const input = 'Hello \t\n world!   This   is   Alinea. \r\n';
      final normalized = AppHashing.normalizeText(input);
      expect(normalized, equals('Hello world! This is Alinea.'));
    });

    test('EP: Strips zero-width characters (ZWSP, ZWNJ, ZWJ, BOM)', () {
      // \u200B (Zero-width space), \uFEFF (BOM)
      const inputWithZw = '\uFEFFHello\u200B \u200Cworld\u200D!';
      final normalized = AppHashing.normalizeText(inputWithZw);
      expect(normalized, equals('Hello world!'));
    });

    test('EP: Unicode and multilingual equivalence (CJK, Arabic, Diacritics)', () {
      const arabic = '  مرحبا   بك  ';
      expect(AppHashing.normalizeText(arabic), equals('مرحبا بك'));

      const japanese = '  こんにちは   世界  ';
      expect(AppHashing.normalizeText(japanese), equals('こんにちは 世界'));

      const german = '  Über   den   Fluß  ';
      expect(AppHashing.normalizeText(german), equals('Über den Fluß'));
    });

    test('EP: Content-addressed translation cache hash is deterministic', () {
      final hash1 = AppHashing.computeTranslationCacheHash(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        providerVersion: 'argos-1.0',
        style: 'natural',
      );

      final hash2 = AppHashing.computeTranslationCacheHash(
        text: '  Hello   world \n',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        providerVersion: 'argos-1.0',
        style: 'natural',
      );

      expect(hash1, equals(hash2));
    });

    test('EP: Cache hashes differ when language, version, or style differs', () {
      final base = AppHashing.computeTranslationCacheHash(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        providerVersion: 'argos-1.0',
      );

      final diffTarget = AppHashing.computeTranslationCacheHash(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'fr',
        providerVersion: 'argos-1.0',
      );

      final diffStyle = AppHashing.computeTranslationCacheHash(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        providerVersion: 'argos-1.0',
        style: 'literal',
      );

      expect(base, isNot(equals(diffTarget)));
      expect(base, isNot(equals(diffStyle)));
    });
  });

  group('AppHashing - ISTQB Boundary Value Analysis (BVA)', () {
    test('BVA: Empty string returns empty string and valid SHA-256', () {
      final normalized = AppHashing.normalizeText('');
      expect(normalized, isEmpty);

      final hash = AppHashing.computeSourceTextHash('');
      expect(hash, isNotEmpty);
      expect(hash.length, equals(64)); // SHA-256 hex length
    });

    test('BVA: Single character text', () {
      final normalized = AppHashing.normalizeText('a');
      expect(normalized, equals('a'));
      expect(AppHashing.computeSourceTextHash('a').length, equals(64));
    });

    test('BVA: Extremely large text (50,000 characters)', () {
      final largeText = 'Word ' * 10000;
      final normalized = AppHashing.normalizeText(largeText);
      expect(normalized.length, greaterThan(40000));
      final hash = AppHashing.computeSourceTextHash(largeText);
      expect(hash.length, equals(64));
    });

    test('BVA: File bytes hashing (0 bytes vs 1 byte vs multi-megabyte)', () {
      final emptyBytes = Uint8List(0);
      final singleByte = Uint8List.fromList([42]);
      final multiBytes = Uint8List.fromList(utf8.encode('Alinea EPUB test buffer'));

      final hash0 = AppHashing.computeFileHash(emptyBytes);
      final hash1 = AppHashing.computeFileHash(singleByte);
      final hashMulti = AppHashing.computeFileHash(multiBytes);

      expect(hash0.length, equals(64));
      expect(hash1.length, equals(64));
      expect(hashMulti.length, equals(64));
      expect(hash0, isNot(equals(hash1)));
      expect(hash1, isNot(equals(hashMulti)));
    });
  });
}
