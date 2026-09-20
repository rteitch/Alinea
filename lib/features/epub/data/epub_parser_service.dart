import 'dart:convert';
import 'dart:typed_data';
import 'package:archive/archive.dart';
import 'package:xml/xml.dart';
import 'package:path/path.dart' as p;
import '../../../core/errors/failures.dart';

class EpubBookMetadata {
  final String title;
  final String? subtitle;
  final String? author;
  final String? publisher;
  final String? sourceLanguage;
  final String? isbn;
  final String epubVersion;

  const EpubBookMetadata({
    required this.title,
    this.subtitle,
    this.author,
    this.publisher,
    this.sourceLanguage,
    this.isbn,
    this.epubVersion = '2.0',
  });
}

class EpubTocItem {
  final String id;
  final String title;
  final String href;
  final int order;
  final List<EpubTocItem> children;

  const EpubTocItem({
    required this.id,
    required this.title,
    required this.href,
    required this.order,
    this.children = const [],
  });
}

class EpubChapterItem {
  final String id;
  final int spineIndex;
  final int? tocOrder;
  final String href;
  final String? title;
  final int wordCount;
  final String content;
  final int? parentSpineIndex;

  const EpubChapterItem({
    required this.id,
    required this.spineIndex,
    this.tocOrder,
    required this.href,
    this.title,
    required this.wordCount,
    required this.content,
    this.parentSpineIndex,
  });
}

class ParsedEpub {
  final EpubBookMetadata metadata;
  final List<EpubChapterItem> chapters;
  final List<EpubTocItem> toc;
  final Uint8List? coverBytes;

  const ParsedEpub({
    required this.metadata,
    required this.chapters,
    required this.toc,
    this.coverBytes,
  });
}

/// Robust EPUB 2.0 & 3.0 parser compliant with ISTQB edge cases and standard EPUB specs.
class EpubParserService {
  ParsedEpub parse(Uint8List bytes) {
    if (bytes.isEmpty) {
      throw const EpubParseException('EPUB file is empty (0 bytes)');
    }

    Archive archive;
    try {
      archive = ZipDecoder().decodeBytes(bytes, verify: true);
    } catch (e) {
      throw EpubParseException('Failed to decode EPUB zip archive: $e');
    }

    // 1. Locate META-INF/container.xml
    final containerFile = archive.findFile('META-INF/container.xml');
    if (containerFile == null) {
      throw const EpubParseException('Invalid EPUB: META-INF/container.xml missing');
    }

    final containerXml = XmlDocument.parse(utf8.decode(containerFile.content as List<int>));
    final rootfileElement = containerXml.findAllElements('rootfile').firstOrNull;
    if (rootfileElement == null) {
      throw const EpubParseException('Invalid container.xml: <rootfile> tag not found');
    }

    final opfPath = rootfileElement.getAttribute('full-path');
    if (opfPath == null || opfPath.isEmpty) {
      throw const EpubParseException('Invalid container.xml: full-path attribute missing');
    }

    // 2. Locate and parse OPF file
    final opfFile = archive.findFile(opfPath);
    if (opfFile == null) {
      throw EpubParseException('OPF package document not found at $opfPath');
    }

    final opfDir = p.dirname(opfPath);
    final opfXml = XmlDocument.parse(utf8.decode(opfFile.content as List<int>));
    final packageElement = opfXml.findAllElements('package').firstOrNull;
    final epubVersion = packageElement?.getAttribute('version') ?? '2.0';

    // 3. Extract metadata
    final metadataElement = opfXml.findAllElements('metadata').firstOrNull;
    if (metadataElement == null) {
      throw const EpubParseException('Invalid OPF: <metadata> element not found');
    }

    final title = metadataElement.findAllElements('dc:title').firstOrNull?.innerText.trim() ??
        metadataElement.findAllElements('title').firstOrNull?.innerText.trim() ??
        'Untitled Document';
    final author = metadataElement.findAllElements('dc:creator').firstOrNull?.innerText.trim() ??
        metadataElement.findAllElements('creator').firstOrNull?.innerText.trim();
    final publisher = metadataElement.findAllElements('dc:publisher').firstOrNull?.innerText.trim() ??
        metadataElement.findAllElements('publisher').firstOrNull?.innerText.trim();
    final language = metadataElement.findAllElements('dc:language').firstOrNull?.innerText.trim() ??
        metadataElement.findAllElements('language').firstOrNull?.innerText.trim();
    final isbn = metadataElement.findAllElements('dc:identifier').firstOrNull?.innerText.trim() ??
        metadataElement.findAllElements('identifier').firstOrNull?.innerText.trim();

    final metadata = EpubBookMetadata(
      title: title,
      author: author,
      publisher: publisher,
      sourceLanguage: language,
      isbn: isbn,
      epubVersion: epubVersion,
    );

    // 4. Extract manifest items
    final manifestElement = opfXml.findAllElements('manifest').firstOrNull;
    if (manifestElement == null) {
      throw const EpubParseException('Invalid OPF: <manifest> element missing');
    }

    final manifestMap = <String, ({String href, String mediaType, String? properties})>{};
    String? coverHref;

    for (final item in manifestElement.findAllElements('item')) {
      final id = item.getAttribute('id');
      final href = item.getAttribute('href');
      final mediaType = item.getAttribute('media-type') ?? '';
      final properties = item.getAttribute('properties');

      if (id != null && href != null) {
        manifestMap[id] = (href: href, mediaType: mediaType, properties: properties);

        // Detect cover image
        final lowerId = id.toLowerCase();
        final lowerProps = properties?.toLowerCase() ?? '';
        if (lowerProps.contains('cover-image') || lowerId == 'cover' || lowerId == 'cover-image') {
          coverHref = href;
        }
      }
    }

    // Cover fallback from <meta name="cover" content="..."/>
    if (coverHref == null) {
      for (final meta in metadataElement.findAllElements('meta')) {
        if (meta.getAttribute('name')?.toLowerCase() == 'cover') {
          final coverId = meta.getAttribute('content');
          if (coverId != null && manifestMap.containsKey(coverId)) {
            coverHref = manifestMap[coverId]!.href;
            break;
          }
        }
      }
    }

    // Extract cover bytes
    Uint8List? coverBytes;
    if (coverHref != null) {
      final resolvedCoverPath = _resolvePath(opfDir, coverHref);
      final coverFile = archive.findFile(resolvedCoverPath);
      if (coverFile != null) {
        coverBytes = Uint8List.fromList(coverFile.content as List<int>);
      }
    }

    // 5. Extract spine items
    final spineElement = opfXml.findAllElements('spine').firstOrNull;
    if (spineElement == null) {
      throw const EpubParseException('Invalid OPF: <spine> element missing');
    }

    final spineItems = spineElement.findAllElements('itemref').toList();
    if (spineItems.isEmpty) {
      throw const EpubParseException('Invalid OPF: <spine> contains no itemref elements');
    }

    // 6. Extract Table of Contents (NCX or NAV)
    final tocId = spineElement.getAttribute('toc');
    final tocList = <EpubTocItem>[];
    String? ncxPath;
    if (tocId != null && manifestMap.containsKey(tocId)) {
      ncxPath = _resolvePath(opfDir, manifestMap[tocId]!.href);
    } else {
      // Find any item with ncx in media-type
      for (final entry in manifestMap.entries) {
        if (entry.value.mediaType.contains('ncx')) {
          ncxPath = _resolvePath(opfDir, entry.value.href);
          break;
        }
      }
    }

    if (ncxPath != null) {
      final ncxFile = archive.findFile(ncxPath);
      if (ncxFile != null) {
        try {
          final ncxXml = XmlDocument.parse(utf8.decode(ncxFile.content as List<int>));
          final navMap = ncxXml.findAllElements('navMap').firstOrNull;
          if (navMap != null) {
            tocList.addAll(_parseNavPoints(navMap.children.whereType<XmlElement>()));
          }
        } catch (_) {
          // Graceful fallback if NCX is malformed
        }
      }
    }

    // 6b. EPUB 3 Navigation Document (nav.xhtml) support
    if (tocList.isEmpty) {
      // Look for nav.xhtml in manifest (properties="nav")
      for (final entry in manifestMap.entries) {
        if (entry.value.properties?.contains('nav') == true) {
          final navPath = _resolvePath(opfDir, entry.value.href);
          final navFile = archive.findFile(navPath);
          if (navFile != null) {
            try {
              final navHtml = utf8.decode(navFile.content as List<int>);
              final navDoc = XmlDocument.parse(navHtml);
              // Find <nav epub:type="toc"> or <nav> element
              final navElements = navDoc.findAllElements('nav');
              for (final nav in navElements) {
                final epubType = nav.getAttribute('epub:type') ?? '';
                if (epubType.contains('toc') || navElements.length == 1) {
                  // Parse the nested <ol> list
                  final olElements = nav.findAllElements('ol');
                  if (olElements.isNotEmpty) {
                    tocList.addAll(_parseNavOlElements(olElements.first));
                  }
                  break;
                }
              }
            } catch (_) {
              // Graceful fallback if nav.xhtml is malformed
            }
          }
          break;
        }
      }
    }

    // 7. Parse chapters according to spine sequence
    final chapters = <EpubChapterItem>[];
    final tocHrefMap = <String, int>{};
    void populateTocMap(List<EpubTocItem> items) {
      for (final item in items) {
        final cleanHref = item.href.split('#').first;
        tocHrefMap[cleanHref] = item.order;
        populateTocMap(item.children);
      }
    }
    populateTocMap(tocList);

    for (var i = 0; i < spineItems.length; i++) {
      final idref = spineItems[i].getAttribute('idref');
      if (idref == null || !manifestMap.containsKey(idref)) continue;

      final itemInfo = manifestMap[idref]!;
      final resolvedPath = _resolvePath(opfDir, itemInfo.href);
      final chapterFile = archive.findFile(resolvedPath);

      String rawContent = '';
      if (chapterFile != null) {
        try {
          rawContent = utf8.decode(chapterFile.content as List<int>);
        } catch (_) {
          rawContent = latin1.decode(chapterFile.content as List<int>);
        }
      }

      final chapterTitle = _extractChapterTitle(rawContent) ?? 'Chapter ${i + 1}';
      final wordCount = _calculateWordCount(rawContent);
      final cleanHref = itemInfo.href.split('#').first;

      chapters.add(
        EpubChapterItem(
          id: idref,
          spineIndex: i,
          tocOrder: tocHrefMap[cleanHref],
          href: itemInfo.href,
          title: chapterTitle,
          wordCount: wordCount,
          content: rawContent,
        ),
      );
    }

    return ParsedEpub(
      metadata: metadata,
      chapters: chapters,
      toc: tocList,
      coverBytes: coverBytes,
    );
  }

  List<EpubTocItem> _parseNavPoints(Iterable<XmlElement> elements, [int depth = 0]) {
    final result = <EpubTocItem>[];
    var counter = 1;
    for (final element in elements) {
      if (element.name.local == 'navPoint') {
        final id = element.getAttribute('id') ?? 'nav-$depth-$counter';
        final playOrderStr = element.getAttribute('playOrder');
        final order = int.tryParse(playOrderStr ?? '') ?? (counter + depth * 100);
        final label = element.findAllElements('text').firstOrNull?.innerText.trim() ?? 'Untitled Section';
        final contentSrc = element.findAllElements('content').firstOrNull?.getAttribute('src') ?? '';

        final childPoints = _parseNavPoints(element.children.whereType<XmlElement>(), depth + 1);

        result.add(
          EpubTocItem(
            id: id,
            title: label,
            href: contentSrc,
            order: order,
            children: childPoints,
          ),
        );
        counter++;
      }
    }
    return result;
  }

  /// Parse EPUB 3 navigation document (nav.xhtml) <ol> structure
  List<EpubTocItem> _parseNavOlElements(XmlElement olElement, [int depth = 0]) {
    final result = <EpubTocItem>[];
    var counter = 1;
    
    for (final li in olElement.children.whereType<XmlElement>()) {
      if (li.name.local != 'li') continue;
      
      final aElement = li.findAllElements('a').firstOrNull;
      final spanElement = li.findAllElements('span').firstOrNull;
      
      final label = aElement?.innerText.trim() ?? spanElement?.innerText.trim() ?? 'Untitled Section';
      final href = aElement?.getAttribute('href') ?? '';
      
      // Parse nested <ol> for sub-chapters
      final nestedOl = li.findAllElements('ol').firstOrNull;
      final children = nestedOl != null ? _parseNavOlElements(nestedOl, depth + 1) : <EpubTocItem>[];
      
      result.add(
        EpubTocItem(
          id: 'nav-$depth-$counter',
          title: label,
          href: href,
          order: counter + depth * 100,
          children: children,
        ),
      );
      counter++;
    }
    
    return result;
  }

  String? _extractChapterTitle(String html) {
    if (html.isEmpty) return null;
    try {
      final doc = XmlDocument.parse(html);
      final h1 = doc.findAllElements('h1').firstOrNull?.innerText.trim();
      if (h1 != null && h1.isNotEmpty) return h1;
      final h2 = doc.findAllElements('h2').firstOrNull?.innerText.trim();
      if (h2 != null && h2.isNotEmpty) return h2;
      final title = doc.findAllElements('title').firstOrNull?.innerText.trim();
      if (title != null && title.isNotEmpty) return title;
    } catch (_) {
      // Fallback regex if HTML is not strict XML
      final match = RegExp(r'<h[1-2][^>]*>(.*?)</h[1-2]>', caseSensitive: false).firstMatch(html);
      if (match != null) {
        return match.group(1)?.replaceAll(RegExp(r'<[^>]*>'), '').trim();
      }
    }
    return null;
  }

  int _calculateWordCount(String html) {
    if (html.isEmpty) return 0;
    final plainText = html.replaceAll(RegExp(r'<[^>]*>'), ' ').replaceAll(RegExp(r'\s+'), ' ').trim();
    if (plainText.isEmpty) return 0;
    return plainText.split(' ').where((w) => w.isNotEmpty).length;
  }

  String _resolvePath(String baseDir, String relativePath) {
    if (baseDir.isEmpty || baseDir == '.') return relativePath.replaceAll('\\', '/');
    final combined = p.posix.normalize(p.posix.join(baseDir, relativePath));
    return combined;
  }
}
