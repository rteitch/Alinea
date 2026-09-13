import 'dart:io';
import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/errors/failures.dart';
import '../../../core/storage/database.dart';
import '../../../core/utils/hashing.dart';
import '../../epub/data/epub_parser_service.dart';

class BookRepository {
  final AppDatabase db;
  final EpubParserService parser;
  final Uuid uuid;

  BookRepository({
    required this.db,
    EpubParserService? parser,
    Uuid? uuid,
  })  : parser = parser ?? EpubParserService(),
        uuid = uuid ?? const Uuid();

  /// Imports an EPUB file into the library with duplicate hash checking & soft-delete restore.
  Future<Book> importBook({
    required Uint8List fileBytes,
    required String targetFilePath,
    String? customCoverPath,
  }) async {
    final fileHash = AppHashing.computeFileHash(fileBytes);

    // Decision Table: Check if fileHash exists in database
    final existingBook = await (db.select(db.books)..where((tbl) => tbl.fileHash.equals(fileHash))).getSingleOrNull();

    if (existingBook != null) {
      if (existingBook.isArchived) {
        // State transition: restore soft-deleted book
        await (db.update(db.books)..where((tbl) => tbl.id.equals(existingBook.id))).write(
          BooksCompanion(
            isArchived: const Value(false),
            updatedAt: Value(DateTime.now()),
          ),
        );
        return (await (db.select(db.books)..where((tbl) => tbl.id.equals(existingBook.id))).getSingle());
      } else {
        throw const DatabaseException('Buku ini sudah ada di perpustakaan Anda (duplikat file terdeteksi).');
      }
    }

    // Parse EPUB metadata & chapters
    final parsed = parser.parse(fileBytes);

    // Ensure target file is saved
    final file = File(targetFilePath);
    await file.parent.create(recursive: true);
    await file.writeAsBytes(fileBytes);

    // Save cover if available
    String? coverPath = customCoverPath;
    if (coverPath == null && parsed.coverBytes != null) {
      final coverFile = File('$targetFilePath.cover.jpg');
      await coverFile.writeAsBytes(parsed.coverBytes!);
      coverPath = coverFile.path;
    }

    final now = DateTime.now();
    final bookCompanion = BooksCompanion(
      uuid: Value(uuid.v4()),
      title: Value(parsed.metadata.title),
      subtitle: Value(parsed.metadata.subtitle),
      author: Value(parsed.metadata.author),
      publisher: Value(parsed.metadata.publisher),
      sourceLanguage: Value(parsed.metadata.sourceLanguage),
      isbn: Value(parsed.metadata.isbn),
      epubVersion: Value(parsed.metadata.epubVersion),
      filePath: Value(targetFilePath),
      fileHash: Value(fileHash),
      fileSizeBytes: Value(fileBytes.length),
      coverPath: Value(coverPath),
      readingStatus: const Value('unread'),
      isFavorite: const Value(false),
      isArchived: const Value(false),
      addedAt: Value(now),
      updatedAt: Value(now),
    );

    return await db.transaction(() async {
      final bookId = await db.into(db.books).insert(bookCompanion);

      // Insert chapters
      final chapterEntities = <Chapter>[];
      for (final ch in parsed.chapters) {
        final chapterId = await db.into(db.chapters).insert(
          ChaptersCompanion(
            uuid: Value(uuid.v4()),
            bookId: Value(bookId),
            spineIndex: Value(ch.spineIndex),
            tocOrder: Value(ch.tocOrder),
            href: Value(ch.href),
            title: Value(ch.title),
            wordCount: Value(ch.wordCount),
          ),
        );
        final insertedChapter = await (db.select(db.chapters)..where((c) => c.id.equals(chapterId))).getSingle();
        chapterEntities.add(insertedChapter);
      }

      // Initialize reading progress at chapter 1 if chapters exist
      if (chapterEntities.isNotEmpty) {
        await db.into(db.readingProgress).insert(
          ReadingProgressCompanion(
            bookId: Value(bookId),
            chapterId: Value(chapterEntities.first.id),
            scrollPct: const Value(0.0),
            updatedAt: Value(now),
          ),
        );
      }

      return await (db.select(db.books)..where((b) => b.id.equals(bookId))).getSingle();
    });
  }

  /// Get active books with optional filter
  Future<List<Book>> getBooks({
    String? readingStatus,
    bool? isFavorite,
    bool includeArchived = false,
  }) async {
    final query = db.select(db.books);

    if (!includeArchived) {
      query.where((tbl) => tbl.isArchived.equals(false));
    }
    if (readingStatus != null) {
      query.where((tbl) => tbl.readingStatus.equals(readingStatus));
    }
    if (isFavorite != null) {
      query.where((tbl) => tbl.isFavorite.equals(isFavorite));
    }

    query.orderBy([(t) => OrderingTerm.desc(t.addedAt)]);
    return await query.get();
  }

  Future<Book?> getBookById(int id) async {
    return await (db.select(db.books)..where((tbl) => tbl.id.equals(id))).getSingleOrNull();
  }

  Future<List<Chapter>> getChaptersByBookId(int bookId) async {
    return await (db.select(db.chapters)
          ..where((tbl) => tbl.bookId.equals(bookId))
          ..orderBy([(t) => OrderingTerm.asc(t.spineIndex)]))
        .get();
  }

  Future<String> getChapterContent(int bookId, int chapterId) async {
    final book = await getBookById(bookId);
    final chapter = await (db.select(db.chapters)..where((tbl) => tbl.id.equals(chapterId))).getSingleOrNull();
    if (book == null || chapter == null) return '';
    final file = File(book.filePath);
    if (!await file.exists()) return '';
    final bytes = await file.readAsBytes();
    final parsed = parser.parse(bytes);
    final found = parsed.chapters.where((c) => c.href == chapter.href).firstOrNull;
    return found?.content ?? '';
  }

  Future<ReadingProgressData?> getReadingProgress(int bookId) async {
    return await (db.select(db.readingProgress)..where((tbl) => tbl.bookId.equals(bookId))).getSingleOrNull();
  }

  /// State Transition: update reading progress and automatically update book's reading_status
  Future<void> updateReadingProgress({
    required int bookId,
    required int chapterId,
    String? cfi,
    required double scrollPct,
  }) async {
    // Boundary Value Analysis: clamp scroll percentage between 0.0 and 1.0
    final clampedPct = scrollPct.clamp(0.0, 1.0);
    final now = DateTime.now();

    await db.transaction(() async {
      await (db.update(db.readingProgress)..where((tbl) => tbl.bookId.equals(bookId))).write(
        ReadingProgressCompanion(
          chapterId: Value(chapterId),
          cfi: Value(cfi),
          scrollPct: Value(clampedPct),
          updatedAt: Value(now),
        ),
      );

      // Transition reading_status
      String newStatus = 'in_progress';
      if (clampedPct >= 1.0) {
        // Check if this is the last chapter
        final chapters = await getChaptersByBookId(bookId);
        if (chapters.isNotEmpty && chapters.last.id == chapterId) {
          newStatus = 'finished';
        }
      }

      await (db.update(db.books)..where((tbl) => tbl.id.equals(bookId))).write(
        BooksCompanion(
          readingStatus: Value(newStatus),
          lastOpenedAt: Value(now),
          updatedAt: Value(now),
        ),
      );
    });
  }

  /// Soft-delete (archive)
  Future<void> archiveBook(int bookId) async {
    await (db.update(db.books)..where((tbl) => tbl.id.equals(bookId))).write(
      BooksCompanion(
        isArchived: const Value(true),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Restore archived book
  Future<void> restoreBook(int bookId) async {
    await (db.update(db.books)..where((tbl) => tbl.id.equals(bookId))).write(
      BooksCompanion(
        isArchived: const Value(false),
        updatedAt: Value(DateTime.now()),
      ),
    );
  }

  /// Toggle favorite status
  Future<bool> toggleFavorite(int bookId) async {
    final book = await getBookById(bookId);
    if (book == null) throw const DatabaseException('Buku tidak ditemukan');
    final newFav = !book.isFavorite;
    await (db.update(db.books)..where((tbl) => tbl.id.equals(bookId))).write(
      BooksCompanion(
        isFavorite: Value(newFav),
        updatedAt: Value(DateTime.now()),
      ),
    );
    return newFav;
  }

  /// Calculates overall reading progress percentage [0.0 - 1.0]
  Future<double> getOverallProgressPct(int bookId) async {
    final progress = await getReadingProgress(bookId);
    if (progress == null) return 0.0;
    final chapters = await getChaptersByBookId(bookId);
    if (chapters.isEmpty) return 0.0;
    final chapterIdx = chapters.indexWhere((c) => c.id == progress.chapterId);
    if (chapterIdx < 0) return 0.0;
    final totalChapters = chapters.length;
    return ((chapterIdx + progress.scrollPct) / totalChapters).clamp(0.0, 1.0);
  }
}
