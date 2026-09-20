import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/database.dart';

class BookmarkRepository {
  final AppDatabase db;
  final Uuid uuid;

  BookmarkRepository({
    required this.db,
    Uuid? uuid,
  }) : uuid = uuid ?? const Uuid();

  Future<Bookmark> addBookmark({
    required int bookId,
    required int chapterId,
    required String cfi,
    String? label,
    String? note,
  }) async {
    final now = DateTime.now();
    final companion = BookmarksCompanion.insert(
      uuid: uuid.v4(),
      bookId: bookId,
      chapterId: chapterId,
      cfi: cfi,
      label: Value(label),
      note: Value(note),
      createdAt: now,
    );

    final id = await db.into(db.bookmarks).insert(companion);
    return await (db.select(db.bookmarks)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<int> deleteBookmark(int bookmarkId) async {
    return await (db.delete(db.bookmarks)..where((tbl) => tbl.id.equals(bookmarkId))).go();
  }

  Future<List<Bookmark>> getBookmarksByBook(int bookId) async {
    return await (db.select(db.bookmarks)
          ..where((tbl) => tbl.bookId.equals(bookId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }
}
