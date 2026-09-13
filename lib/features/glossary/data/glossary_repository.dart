import 'package:drift/drift.dart';
import '../../../core/storage/database.dart';

class GlossaryRepository {
  final AppDatabase db;

  GlossaryRepository({required this.db});

  /// Adds or updates a glossary term.
  /// If bookId is null, it applies globally. If bookId is set, it is scoped to that book.
  Future<GlossaryTerm> setTerm({
    int? bookId,
    required String sourceTerm,
    required String preferredTranslation,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    final now = DateTime.now();

    // Check if matching term exists to handle upsert
    final existingQuery = db.select(db.glossaryTerms)
      ..where((tbl) {
        final baseFilter = tbl.sourceTerm.equals(sourceTerm) &
            tbl.sourceLanguage.equals(sourceLanguage) &
            tbl.targetLanguage.equals(targetLanguage);
        if (bookId != null) {
          return baseFilter & tbl.bookId.equals(bookId);
        } else {
          return baseFilter & tbl.bookId.isNull();
        }
      });

    final existing = await existingQuery.getSingleOrNull();

    if (existing != null) {
      await (db.update(db.glossaryTerms)..where((tbl) => tbl.id.equals(existing.id))).write(
        GlossaryTermsCompanion(
          preferredTranslation: Value(preferredTranslation),
          updatedAt: Value(now),
        ),
      );
      return (await (db.select(db.glossaryTerms)..where((tbl) => tbl.id.equals(existing.id))).getSingle());
    } else {
      final companion = GlossaryTermsCompanion.insert(
        bookId: Value(bookId),
        sourceTerm: sourceTerm,
        preferredTranslation: preferredTranslation,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
        createdAt: now,
        updatedAt: now,
      );
      final id = await db.into(db.glossaryTerms).insert(companion);
      return (await (db.select(db.glossaryTerms)..where((tbl) => tbl.id.equals(id))).getSingle());
    }
  }

  /// Decision Table Resolution:
  /// Rule 1: Book-specific match exists? -> Return scoped translation.
  /// Rule 2: Global match exists? -> Return global translation.
  /// Rule 3: None exists -> Return null.
  Future<String?> resolveTerm({
    int? bookId,
    required String sourceTerm,
    required String sourceLanguage,
    required String targetLanguage,
  }) async {
    // 1. Scoped check
    if (bookId != null) {
      final scoped = await (db.select(db.glossaryTerms)
            ..where((tbl) =>
                tbl.bookId.equals(bookId) &
                tbl.sourceTerm.equals(sourceTerm) &
                tbl.sourceLanguage.equals(sourceLanguage) &
                tbl.targetLanguage.equals(targetLanguage)))
          .getSingleOrNull();
      if (scoped != null) return scoped.preferredTranslation;
    }

    // 2. Global check
    final global = await (db.select(db.glossaryTerms)
          ..where((tbl) =>
              tbl.bookId.isNull() &
              tbl.sourceTerm.equals(sourceTerm) &
              tbl.sourceLanguage.equals(sourceLanguage) &
              tbl.targetLanguage.equals(targetLanguage)))
        .getSingleOrNull();

    return global?.preferredTranslation;
  }

  Future<List<GlossaryTerm>> getTerms({int? bookId}) async {
    final query = db.select(db.glossaryTerms);
    if (bookId != null) {
      query.where((tbl) => tbl.bookId.equals(bookId) | tbl.bookId.isNull());
    }
    query.orderBy([(t) => OrderingTerm.asc(t.sourceTerm)]);
    return await query.get();
  }

  Future<int> deleteTerm(int id) async {
    return await (db.delete(db.glossaryTerms)..where((tbl) => tbl.id.equals(id))).go();
  }
}
