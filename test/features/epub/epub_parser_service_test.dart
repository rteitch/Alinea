import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/errors/failures.dart';
import 'package:alinea/features/epub/data/epub_parser_service.dart';

Uint8List createMockEpubBytes({
  String title = 'Test EPUB Title',
  String? author = 'Test Author',
  String? language = 'en',
  String version = '2.0',
  bool includeContainer = true,
  bool includeOpf = true,
  bool includeSpine = true,
  bool includeCover = true,
  bool includeNestedToc = true,
  String? customChapterHtml,
}) {
  final archive = Archive();

  if (includeContainer) {
    const containerXml = '''<?xml version="1.0" encoding="UTF-8"?>
<container version="1.0" xmlns="urn:oasis:names:tc:opendocument:xmlns:container">
  <rootfiles>
    <rootfile full-path="OEBPS/content.opf" media-type="application/oebps-package+xml"/>
  </rootfiles>
</container>''';
    archive.addFile(ArchiveFile('META-INF/container.xml', containerXml.length, utf8.encode(containerXml)));
  }

  if (includeOpf) {
    final spineXml = includeSpine
        ? '''<spine toc="ncx">
      <itemref idref="ch1"/>
      <itemref idref="ch2"/>
    </spine>'''
        : '';

    final opfXml = '''<?xml version="1.0" encoding="utf-8"?>
<package xmlns="http://www.idpf.org/2007/opf" version="$version" unique-identifier="BookId">
  <metadata xmlns:dc="http://purl.org/dc/elements/1.1/">
    <dc:title>$title</dc:title>
    ${author != null ? '<dc:creator>$author</dc:creator>' : ''}
    ${language != null ? '<dc:language>$language</dc:language>' : ''}
    <dc:identifier id="BookId">urn:uuid:12345</dc:identifier>
    ${includeCover ? '<meta name="cover" content="cover-image"/>' : ''}
  </metadata>
  <manifest>
    <item id="ncx" href="toc.ncx" media-type="application/x-dtbncx+xml"/>
    <item id="ch1" href="chapter1.xhtml" media-type="application/xhtml+xml"/>
    <item id="ch2" href="chapter2.xhtml" media-type="application/xhtml+xml"/>
    ${includeCover ? '<item id="cover-image" href="images/cover.jpg" media-type="image/jpeg" properties="cover-image"/>' : ''}
  </manifest>
  $spineXml
</package>''';
    archive.addFile(ArchiveFile('OEBPS/content.opf', opfXml.length, utf8.encode(opfXml)));
  }

  if (includeNestedToc) {
    const ncxXml = '''<?xml version="1.0" encoding="UTF-8"?>
<ncx xmlns="http://www.daisy.org/z3986/2005/ncx/" version="2005-1">
  <navMap>
    <navPoint id="np1" playOrder="1">
      <navLabel><text>Part 1: The Beginning</text></navLabel>
      <content src="chapter1.xhtml"/>
      <navPoint id="np1-1" playOrder="2">
        <navLabel><text>Section 1.1: Foundations</text></navLabel>
        <content src="chapter1.xhtml#sec1"/>
      </navPoint>
    </navPoint>
    <navPoint id="np2" playOrder="3">
      <navLabel><text>Part 2: Climax</text></navLabel>
      <content src="chapter2.xhtml"/>
    </navPoint>
  </navMap>
</ncx>''';
    archive.addFile(ArchiveFile('OEBPS/toc.ncx', ncxXml.length, utf8.encode(ncxXml)));
  }

  final ch1Html = customChapterHtml ?? '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html>
  <head><title>Chapter One</title></head>
  <body>
    <h1>Chapter One</h1>
    <p>This is the first paragraph of the test book.</p>
    <p>Second paragraph with more interesting words.</p>
  </body>
</html>''';
  archive.addFile(ArchiveFile('OEBPS/chapter1.xhtml', ch1Html.length, utf8.encode(ch1Html)));

  const ch2Html = '''<?xml version="1.0" encoding="utf-8"?>
<!DOCTYPE html>
<html>
  <head><title>Chapter Two</title></head>
  <body>
    <h2>The Journey Continues</h2>
    <p>Another paragraph here.</p>
  </body>
</html>''';
  archive.addFile(ArchiveFile('OEBPS/chapter2.xhtml', ch2Html.length, utf8.encode(ch2Html)));

  if (includeCover) {
    final fakeJpg = Uint8List.fromList([0xFF, 0xD8, 0xFF, 0xE0, 0x00, 0x10, 0x4A, 0x46, 0x49, 0x46]);
    archive.addFile(ArchiveFile('OEBPS/images/cover.jpg', fakeJpg.length, fakeJpg));
  }

  final encoded = ZipEncoder().encode(archive);
  return Uint8List.fromList(encoded!);
}

void main() {
  late EpubParserService parser;

  setUp(() {
    parser = EpubParserService();
  });

  group('EpubParserService - ISTQB Equivalence Partitioning (EP)', () {
    test('EP Partition: Invalid Empty byte input throws EpubParseException', () {
      expect(
        () => parser.parse(Uint8List(0)),
        throwsA(isA<EpubParseException>().having((e) => e.message, 'message', contains('empty'))),
      );
    });

    test('EP Partition: Non-ZIP corrupted byte input throws EpubParseException', () {
      final corruptBytes = Uint8List.fromList([1, 2, 3, 4, 5, 6, 7, 8]);
      expect(
        () => parser.parse(corruptBytes),
        throwsA(isA<EpubParseException>().having((e) => e.message, 'message', contains('Failed to decode'))),
      );
    });

    test('EP Partition: Missing META-INF/container.xml throws EpubParseException', () {
      final bytes = createMockEpubBytes(includeContainer: false);
      expect(
        () => parser.parse(bytes),
        throwsA(isA<EpubParseException>().having((e) => e.message, 'message', contains('container.xml missing'))),
      );
    });

    test('EP Partition: Missing OPF file throws EpubParseException', () {
      final bytes = createMockEpubBytes(includeOpf: false);
      expect(
        () => parser.parse(bytes),
        throwsA(isA<EpubParseException>().having((e) => e.message, 'message', contains('package document not found'))),
      );
    });

    test('EP Partition: Missing spine in OPF throws EpubParseException', () {
      final bytes = createMockEpubBytes(includeSpine: false);
      expect(
        () => parser.parse(bytes),
        throwsA(isA<EpubParseException>().having((e) => e.message, 'message', contains('spine'))),
      );
    });

    test('EP Partition: Valid EPUB 2.0 parses metadata, chapters, cover, and TOC correctly', () {
      final bytes = createMockEpubBytes(
        title: 'Alinea Masterpiece',
        author: 'Pramoedya Ananta Toer',
        language: 'id',
      );

      final parsed = parser.parse(bytes);

      expect(parsed.metadata.title, equals('Alinea Masterpiece'));
      expect(parsed.metadata.author, equals('Pramoedya Ananta Toer'));
      expect(parsed.metadata.sourceLanguage, equals('id'));
      expect(parsed.metadata.epubVersion, equals('2.0'));
      expect(parsed.chapters.length, equals(2));
      expect(parsed.chapters[0].title, equals('Chapter One'));
      expect(parsed.chapters[0].wordCount, greaterThan(0));
      expect(parsed.coverBytes, isNotNull);
      expect(parsed.toc.length, equals(2));
    });
  });

  group('EpubParserService - ISTQB Boundary Value Analysis (BVA)', () {
    test('BVA: Nested TOC hierarchy (Depth 0, 1, and child nodes)', () {
      final bytes = createMockEpubBytes(includeNestedToc: true);
      final parsed = parser.parse(bytes);

      expect(parsed.toc.length, equals(2)); // np1 and np2
      final part1 = parsed.toc.first;
      expect(part1.title, equals('Part 1: The Beginning'));
      expect(part1.order, equals(1));
      expect(part1.children.length, equals(1));

      final section1 = part1.children.first;
      expect(section1.title, equals('Section 1.1: Foundations'));
      expect(section1.order, equals(2));
      expect(section1.children, isEmpty);
    });

    test('BVA: Word count calculation (0 words, 1 word, and complex HTML tags)', () {
      final emptyChapterEpub = createMockEpubBytes(
        customChapterHtml: '<html><body></body></html>',
      );
      final parsedEmpty = parser.parse(emptyChapterEpub);
      expect(parsedEmpty.chapters.first.wordCount, equals(0));

      final singleWordEpub = createMockEpubBytes(
        customChapterHtml: '<html><body><p>Solitary</p></body></html>',
      );
      final parsedSingle = parser.parse(singleWordEpub);
      expect(parsedSingle.chapters.first.wordCount, equals(1));
    });
  });

  group('EpubParserService - Edge Cases & Robustness', () {
    test('Edge Case: EPUB with no cover image handles null gracefully', () {
      final bytes = createMockEpubBytes(includeCover: false);
      final parsed = parser.parse(bytes);

      expect(parsed.coverBytes, isNull);
    });

    test('Edge Case: Chapter HTML title extracted from <h2> or <title> if <h1> is missing', () {
      final parsed = parser.parse(createMockEpubBytes());
      // Chapter 2 has <h2>The Journey Continues</h2>
      expect(parsed.chapters[1].title, equals('The Journey Continues'));
    });

    test('Edge Case: Malformed HTML content inside chapter parses gracefully', () {
      const malformedHtml = '<div><p>Unclosed paragraph<br><span>Broken';
      final bytes = createMockEpubBytes(customChapterHtml: malformedHtml);
      final parsed = parser.parse(bytes);

      expect(parsed.chapters.first.content, equals(malformedHtml));
      expect(parsed.chapters.first.wordCount, greaterThan(0));
    });
  });
}
