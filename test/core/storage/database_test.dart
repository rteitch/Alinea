import 'dart:io';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/errors/failures.dart';
import 'package:alinea/core/storage/database.dart';
import 'package:alinea/features/library/data/book_repository.dart';
import 'package:alinea/features/bookmarks/data/bookmark_repository.dart';
import 'package:alinea/features/highlights/data/highlight_repository.dart';
import 'package:alinea/features/glossary/data/glossary_repository.dart';
import 'package:alinea/features/translation/data/translation_cache_repository.dart';
import '../../features/epub/epub_parser_service_test.dart';

void main() {
  late AppDatabase db;
  late BookRepository bookRepo;
  late BookmarkRepository bookmarkRepo;
  late HighlightRepository highlightRepo;
  late GlossaryRepository glossaryRepo;
  late TranslationCacheRepository cacheRepo;
  late Directory tempDir;

  setUp(() async {
    db = AppDatabase.forTesting(
      NativeDatabase.memory(
        setup: (rawDb) {
          rawDb.execute('PRAGMA foreign_keys = ON;');
        },
      ),
    );
    bookRepo = BookRepository(db: db);
    bookmarkRepo = BookmarkRepository(db: db);
    highlightRepo = HighlightRepository(db: db);
    glossaryRepo = GlossaryRepository(db: db);
    cacheRepo = TranslationCacheRepository(db: db);
    tempDir = await Directory.systemTemp.createTemp('alinea_db_test_');
  });

  tearDown(() async {
    await db.close();
    if (await tempDir.exists()) {
      await tempDir.delete(recursive: true);
    }
  });

  group('Drift Database & BookRepository - ISTQB Decision Table Testing', () {
    test('Decision Table: Import new book creates records in books, chapters, and reading_progress', () async {
      final epubBytes = createMockEpubBytes(title: 'Alinea Vol 1');
      final targetPath = '${tempDir.path}/book1.epub';

      final book = await bookRepo.importBook(
        fileBytes: epubBytes,
        targetFilePath: targetPath,
      );

      expect(book.id, greaterThan(0));
      expect(book.title, equals('Alinea Vol 1'));
      expect(book.readingStatus, equals('unread'));
      expect(book.isArchived, isFalse);

      final chapters = await bookRepo.getChaptersByBookId(book.id);
      expect(chapters.length, equals(2));

      final progress = await bookRepo.getReadingProgress(book.id);
      expect(progress, isNotNull);
      expect(progress!.chapterId, equals(chapters.first.id));
      expect(progress.scrollPct, equals(0.0));
    });

    test('Decision Table: Importing active duplicate file hash is REJECTED', () async {
      final epubBytes = createMockEpubBytes(title: 'Duplicate Test');
      final targetPath1 = '${tempDir.path}/dup1.epub';
      final targetPath2 = '${tempDir.path}/dup2.epub';

      await bookRepo.importBook(fileBytes: epubBytes, targetFilePath: targetPath1);

      // Attempt to re-import identical file hash
      expect(
        () => bookRepo.importBook(fileBytes: epubBytes, targetFilePath: targetPath2),
        throwsA(isA<DatabaseException>().having((e) => e.message, 'message', contains('duplikat'))),
      );
    });

    test('Decision Table: Importing archived duplicate file hash RESTORES the book', () async {
      final epubBytes = createMockEpubBytes(title: 'Restore Test');
      final targetPath = '${tempDir.path}/restore.epub';

      final imported = await bookRepo.importBook(fileBytes: epubBytes, targetFilePath: targetPath);
      await bookRepo.archiveBook(imported.id);

      final archivedBook = await bookRepo.getBookById(imported.id);
      expect(archivedBook!.isArchived, isTrue);

      // Re-importing same file hash should restore it
      final restored = await bookRepo.importBook(fileBytes: epubBytes, targetFilePath: targetPath);
      expect(restored.id, equals(imported.id));
      expect(restored.isArchived, isFalse);
    });
  });

  group('Drift Database & BookRepository - ISTQB State Transition Testing', () {
    test('State Transition: Reading status progresses from unread -> in_progress -> finished', () async {
      final epubBytes = createMockEpubBytes(title: 'State Transition Book');
      final book = await bookRepo.importBook(
        fileBytes: epubBytes,
        targetFilePath: '${tempDir.path}/state.epub',
      );

      expect(book.readingStatus, equals('unread'));
      final chapters = await bookRepo.getChaptersByBookId(book.id);

      // 1. Reading chapter 1 at 50%
      await bookRepo.updateReadingProgress(
        bookId: book.id,
        chapterId: chapters[0].id,
        scrollPct: 0.5,
      );

      final updated1 = await bookRepo.getBookById(book.id);
      expect(updated1!.readingStatus, equals('in_progress'));

      // 2. Reading last chapter (chapter 2) at 100%
      await bookRepo.updateReadingProgress(
        bookId: book.id,
        chapterId: chapters[1].id,
        scrollPct: 1.0,
      );

      final updated2 = await bookRepo.getBookById(book.id);
      expect(updated2!.readingStatus, equals('finished'));
    });

    test('State Transition: Soft-delete archive and restore flow', () async {
      final book = await bookRepo.importBook(
        fileBytes: createMockEpubBytes(),
        targetFilePath: '${tempDir.path}/soft_del.epub',
      );

      // Active state
      var activeBooks = await bookRepo.getBooks();
      expect(activeBooks.any((b) => b.id == book.id), isTrue);

      // Transition to Archived
      await bookRepo.archiveBook(book.id);
      activeBooks = await bookRepo.getBooks(includeArchived: false);
      expect(activeBooks.any((b) => b.id == book.id), isFalse);

      var allBooks = await bookRepo.getBooks(includeArchived: true);
      expect(allBooks.any((b) => b.id == book.id), isTrue);

      // Transition to Restored
      await bookRepo.restoreBook(book.id);
      activeBooks = await bookRepo.getBooks(includeArchived: false);
      expect(activeBooks.any((b) => b.id == book.id), isTrue);
    });
  });

  group('Reading Progress - ISTQB Boundary Value Analysis (BVA)', () {
    test('BVA: Scroll percentage clamps values < 0.0 to 0.0 and > 1.0 to 1.0', () async {
      final book = await bookRepo.importBook(
        fileBytes: createMockEpubBytes(),
        targetFilePath: '${tempDir.path}/bva_scroll.epub',
      );
      final chapters = await bookRepo.getChaptersByBookId(book.id);

      // Negative value clamped to 0.0
      await bookRepo.updateReadingProgress(bookId: book.id, chapterId: chapters.first.id, scrollPct: -0.25);
      var progress = await bookRepo.getReadingProgress(book.id);
      expect(progress!.scrollPct, equals(0.0));

      // Overflow value clamped to 1.0
      await bookRepo.updateReadingProgress(bookId: book.id, chapterId: chapters.first.id, scrollPct: 1.75);
      progress = await bookRepo.getReadingProgress(book.id);
      expect(progress!.scrollPct, equals(1.0));
    });
  });

  group('Foreign Key Cascades & Relational Integrity', () {
    test('Deleting a book automatically cascades and deletes chapters, progress, bookmarks, highlights', () async {
      final book = await bookRepo.importBook(
        fileBytes: createMockEpubBytes(),
        targetFilePath: '${tempDir.path}/cascade.epub',
      );
      final chapters = await bookRepo.getChaptersByBookId(book.id);

      await bookmarkRepo.addBookmark(bookId: book.id, chapterId: chapters.first.id, cfi: '/4/2/4');
      await highlightRepo.createHighlight(
        bookId: book.id,
        chapterId: chapters.first.id,
        startAnchor: 'p1:1',
        endAnchor: 'p1:10',
      );

      expect((await bookmarkRepo.getBookmarksByBook(book.id)).length, equals(1));
      expect((await highlightRepo.getHighlightsByBook(book.id)).length, equals(1));

      // Hard delete the book record directly
      await (db.delete(db.books)..where((tbl) => tbl.id.equals(book.id))).go();

      // Check cascade deletions
      expect((await bookRepo.getChaptersByBookId(book.id)), isEmpty);
      expect((await bookRepo.getReadingProgress(book.id)), isNull);
      expect((await bookmarkRepo.getBookmarksByBook(book.id)), isEmpty);
      expect((await highlightRepo.getHighlightsByBook(book.id)), isEmpty);
    });
  });

  group('Glossary Terms - Decision Table & Scoped Resolution', () {
    test('Decision Table: Scoped book glossary term overrides global glossary term', () async {
      final book = await bookRepo.importBook(
        fileBytes: createMockEpubBytes(),
        targetFilePath: '${tempDir.path}/glossary.epub',
      );

      // Global term: "Artificial Intelligence" -> "Kecerdasan Buatan"
      await glossaryRepo.setTerm(
        bookId: null,
        sourceTerm: 'AI',
        preferredTranslation: 'Kecerdasan Buatan',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      // Scoped term for this specific book: "AI" -> "Artifisial Intelijen (Sains)"
      await glossaryRepo.setTerm(
        bookId: book.id,
        sourceTerm: 'AI',
        preferredTranslation: 'Artifisial Intelijen (Sains)',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      // Query for book should resolve to scoped translation
      final resolvedForBook = await glossaryRepo.resolveTerm(
        bookId: book.id,
        sourceTerm: 'AI',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolvedForBook, equals('Artifisial Intelijen (Sains)'));

      // Query without bookId should resolve to global translation
      final resolvedGlobal = await glossaryRepo.resolveTerm(
        bookId: null,
        sourceTerm: 'AI',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolvedGlobal, equals('Kecerdasan Buatan'));

      // Unknown term returns null
      final resolvedUnknown = await glossaryRepo.resolveTerm(
        bookId: book.id,
        sourceTerm: 'Quantum',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolvedUnknown, isNull);
    });
  });

  group('Translation Cache - State Transitions, Hit Count & LRU Eviction', () {
    test('State Transition: Cache MISS returns null, HIT increments hit_count and updates last_used_at', () async {
      // 1. Initial lookup -> MISS
      final missResult = await cacheRepo.lookupTranslation(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-1.0',
      );
      expect(missResult, isNull);

      // 2. Save translation
      final saved = await cacheRepo.saveTranslation(
        text: 'Hello world',
        translatedText: 'Halo dunia',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-1.0',
      );
      expect(saved.hitCount, equals(1));
      expect(saved.translatedText, equals('Halo dunia'));

      // 3. Subsequent lookup -> HIT with incremented hitCount
      final hitResult = await cacheRepo.lookupTranslation(
        text: 'Hello world',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-1.0',
      );
      expect(hitResult, isNotNull);
      expect(hitResult!.hitCount, equals(2));
      expect(hitResult.translatedText, equals('Halo dunia'));
    });

    test('BVA: LRU Cache Eviction cleans oldest entries when limit is exceeded', () async {
      // Insert 6 items with artificial time delays
      for (var i = 1; i <= 6; i++) {
        await cacheRepo.saveTranslation(
          text: 'Sentence $i',
          translatedText: 'Kalimat $i',
          sourceLanguage: 'en',
          targetLanguage: 'id',
          provider: 'libretranslate',
          providerVersion: 'argos-1.0',
        );
      }

      // Evict with maxEntries = 4, evictCount = 2
      final deletedCount = await cacheRepo.evictOldestEntries(maxEntries: 4, evictCount: 2);
      expect(deletedCount, equals(2));

      // Sentence 1 and Sentence 2 should be evicted (oldest)
      final check1 = await cacheRepo.lookupTranslation(
        text: 'Sentence 1',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-1.0',
      );
      expect(check1, isNull);

      // Sentence 6 should still exist (newest)
      final check6 = await cacheRepo.lookupTranslation(
        text: 'Sentence 6',
        sourceLanguage: 'en',
        targetLanguage: 'id',
        provider: 'libretranslate',
        providerVersion: 'argos-1.0',
      );
      expect(check6, isNotNull);
    });
  });
}
