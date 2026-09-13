import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/storage/database.dart';
import 'package:alinea/features/bookmarks/data/bookmark_repository.dart';
import 'package:alinea/features/highlights/data/highlight_repository.dart';

void main() {
  late AppDatabase db;
  late BookmarkRepository bookmarkRepo;
  late HighlightRepository highlightRepo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    bookmarkRepo = BookmarkRepository(db: db);
    highlightRepo = HighlightRepository(db: db);

    final now = DateTime.now();
    await db.into(db.books).insert(
      BooksCompanion.insert(
        id: const Value(1),
        uuid: 'book-1-uuid',
        fileHash: 'hash-1',
        title: 'Test Book',
        filePath: '/data/test.epub',
        addedAt: now,
        updatedAt: now,
      ),
    );
    await db.into(db.chapters).insert(
      ChaptersCompanion.insert(
        id: const Value(1),
        uuid: 'chapter-1-uuid',
        bookId: 1,
        spineIndex: 0,
        href: 'ch01.xhtml',
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('BookmarkRepository - State & CRUD Tests', () {
    test('Add bookmark and retrieve by book ID', () async {
      final bm = await bookmarkRepo.addBookmark(
        bookId: 1,
        chapterId: 1,
        cfi: '/chapter/0',
        label: 'Bab 1 Penanda',
      );

      expect(bm.id, isNotNull);
      expect(bm.label, 'Bab 1 Penanda');

      final list = await bookmarkRepo.getBookmarksByBook(1);
      expect(list.length, 1);
      expect(list.first.cfi, '/chapter/0');
    });

    test('Delete bookmark removes from database', () async {
      final bm = await bookmarkRepo.addBookmark(
        bookId: 1,
        chapterId: 1,
        cfi: '/chapter/0',
      );

      final count = await bookmarkRepo.deleteBookmark(bm.id);
      expect(count, 1);

      final list = await bookmarkRepo.getBookmarksByBook(1);
      expect(list, isEmpty);
    });
  });

  group('HighlightRepository - State & CRUD Tests', () {
    test('Create highlight and retrieve by book and chapter', () async {
      final hl = await highlightRepo.createHighlight(
        bookId: 1,
        chapterId: 1,
        startAnchor: 'Alinea adalah paragraf.',
        endAnchor: 'Alinea adalah paragraf.',
        color: 'yellow',
        note: 'Penting untuk diingat',
      );

      expect(hl.id, isNotNull);
      expect(hl.color, 'yellow');
      expect(hl.note, 'Penting untuk diingat');

      final byBook = await highlightRepo.getHighlightsByBook(1);
      expect(byBook.length, 1);

      final byChapter = await highlightRepo.getHighlightsByChapter(1);
      expect(byChapter.length, 1);
    });

    test('Update highlight color and note', () async {
      final hl = await highlightRepo.createHighlight(
        bookId: 1,
        chapterId: 1,
        startAnchor: 'Teks awal',
        endAnchor: 'Teks akhir',
        color: 'green',
      );

      await highlightRepo.updateHighlight(hl.id, color: 'pink', note: 'Catatan baru');

      final updated = await highlightRepo.getHighlightsByBook(1);
      expect(updated.first.color, 'pink');
      expect(updated.first.note, 'Catatan baru');
    });

    test('Delete highlight removes record', () async {
      final hl = await highlightRepo.createHighlight(
        bookId: 1,
        chapterId: 1,
        startAnchor: 'Teks',
        endAnchor: 'Teks',
      );

      final count = await highlightRepo.deleteHighlight(hl.id);
      expect(count, 1);

      final remaining = await highlightRepo.getHighlightsByBook(1);
      expect(remaining, isEmpty);
    });
  });
}
