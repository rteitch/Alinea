import 'package:drift/drift.dart';
import '../../../core/storage/database.dart';
import '../../../core/utils/hashing.dart';

class TranslationCacheRepository {
  final AppDatabase db;

  TranslationCacheRepository({required this.db});

  /// Look up cached translation using deterministic content hash.
  /// If HIT: updates hit_count (+1) and last_used_at timestamp.
  /// If MISS: returns null.
  Future<TranslationCacheData?> lookupTranslation({
    required String text,
    required String sourceLanguage,
    required String targetLanguage,
    required String provider,
    required String providerVersion,
    String style = 'natural',
  }) async {
    final sourceHash = AppHashing.computeSourceTextHash(text);
    final now = DateTime.now();

    final query = db.select(db.translationCache)
      ..where((tbl) =>
          tbl.sourceTextHash.equals(sourceHash) &
          tbl.sourceLanguage.equals(sourceLanguage) &
          tbl.targetLanguage.equals(targetLanguage) &
          tbl.provider.equals(provider) &
          tbl.providerVersion.equals(providerVersion) &
          tbl.style.equals(style));

    final cached = await query.getSingleOrNull();
    if (cached != null) {
      // ISTQB State Transition: HIT -> increment hit_count & update last_used_at
      await (db.update(db.translationCache)..where((tbl) => tbl.id.equals(cached.id))).write(
        TranslationCacheCompanion(
          hitCount: Value(cached.hitCount + 1),
          lastUsedAt: Value(now),
        ),
      );
      return (await (db.select(db.translationCache)..where((tbl) => tbl.id.equals(cached.id))).getSingle());
    }

    return null;
  }

  /// Saves a translation result into the local content-addressed cache.
  Future<TranslationCacheData> saveTranslation({
    required String text,
    required String translatedText,
    required String sourceLanguage,
    required String targetLanguage,
    required String provider,
    required String providerVersion,
    String style = 'natural',
  }) async {
    final sourceHash = AppHashing.computeSourceTextHash(text);
    final now = DateTime.now();

    final companion = TranslationCacheCompanion.insert(
      sourceLanguage: sourceLanguage,
      targetLanguage: targetLanguage,
      sourceText: Value(text),
      sourceTextHash: sourceHash,
      translatedText: translatedText,
      provider: provider,
      providerVersion: providerVersion,
      style: Value(style),
      hitCount: const Value(1),
      createdAt: now,
      lastUsedAt: now,
    );

    // Upsert into cache
    final id = await db.into(db.translationCache).insertOnConflictUpdate(companion);
    return await (db.select(db.translationCache)..where((tbl) => tbl.id.equals(id))).getSingle();
  }

  /// LRU Eviction: Deletes the least recently used cache entries if total count exceeds maxEntries.
  Future<int> evictOldestEntries({int maxEntries = 5000, int evictCount = 500}) async {
    final countExp = db.translationCache.id.count();
    final query = db.selectOnly(db.translationCache)..addColumns([countExp]);
    final totalCount = await query.map((row) => row.read(countExp)).getSingle() ?? 0;

    if (totalCount > maxEntries) {
      final oldestRows = await (db.select(db.translationCache)
            ..orderBy([(t) => OrderingTerm.asc(t.lastUsedAt)])
            ..limit(evictCount))
          .get();

      final idsToDelete = oldestRows.map((e) => e.id).toList();
      return await (db.delete(db.translationCache)..where((tbl) => tbl.id.isIn(idsToDelete))).go();
    }
    return 0;
  }

  Future<List<TranslationCacheData>> getHistory({String? query}) async {
    final selectQuery = db.select(db.translationCache);
    if (query != null && query.trim().isNotEmpty) {
      final q = query.trim().toLowerCase();
      selectQuery.where((tbl) =>
          tbl.translatedText.like('%$q%') |
          tbl.sourceText.like('%$q%') |
          tbl.sourceLanguage.equals(q) |
          tbl.targetLanguage.equals(q));
    }
    selectQuery.orderBy([(t) => OrderingTerm.desc(t.lastUsedAt)]);
    return await selectQuery.get();
  }

  Future<int> deleteEntry(int id) async {
    return await (db.delete(db.translationCache)..where((tbl) => tbl.id.equals(id))).go();
  }
}
