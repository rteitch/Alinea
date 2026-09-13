import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';
import '../../../core/storage/database.dart';

class HighlightRepository {
  final AppDatabase db;
  final Uuid uuid;

  HighlightRepository({
    required this.db,
    Uuid? uuid,
  }) : uuid = uuid ?? const Uuid();

  Future<Highlight> createHighlight({
    required int bookId,
    required int chapterId,
    required String startAnchor,
    required String endAnchor,
    String color = 'yellow',
    String? note,
    int? translationUnitId,
  }) async {
    final now = DateTime.now();
    final companion = HighlightsCompanion.insert(
      uuid: uuid.v4(),
      bookId: bookId,
      chapterId: chapterId,
      startAnchor: startAnchor,
      endAnchor: endAnchor,
      color: Value(color),
      note: Value(note),
      translationUnitId: Value(translationUnitId),
      createdAt: now,
    );

    final id = await db.into(db.highlights).insert(companion);
    return await (db.select(db.highlights)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  Future<void> updateHighlight(
    int id, {
    String? color,
    String? note,
  }) async {
    await (db.update(db.highlights)..where((tbl) => tbl.id.equals(id))).write(
      HighlightsCompanion(
        color: color != null ? Value(color) : const Value.absent(),
        note: note != null ? Value(note) : const Value.absent(),
      ),
    );
  }

  Future<int> deleteHighlight(int id) async {
    return await (db.delete(db.highlights)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future<List<Highlight>> getHighlightsByBook(int bookId) async {
    return await (db.select(db.highlights)
          ..where((tbl) => tbl.bookId.equals(bookId))
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();
  }

  Future<List<Highlight>> getHighlightsByChapter(int chapterId) async {
    return await (db.select(db.highlights)
          ..where((tbl) => tbl.chapterId.equals(chapterId))
          ..orderBy([(t) => OrderingTerm.asc(t.startAnchor)]))
        .get();
  }
}
