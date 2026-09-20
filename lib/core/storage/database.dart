import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;

part 'database.g.dart';

// =========================================================
// 1. BOOKS
// =========================================================
class Books extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  TextColumn get title => text()();
  TextColumn get subtitle => text().nullable()();
  TextColumn get author => text().nullable()();
  TextColumn get publisher => text().nullable()();
  TextColumn get sourceLanguage => text().nullable()();
  TextColumn get isbn => text().nullable()();
  TextColumn get epubVersion => text().nullable()();
  TextColumn get filePath => text()();
  TextColumn get fileHash => text().unique()();
  IntColumn get fileSizeBytes => integer().nullable()();
  TextColumn get coverPath => text().nullable()();
  TextColumn get readingStatus => text().withDefault(const Constant('unread'))();
  BoolColumn get isFavorite => boolean().withDefault(const Constant(false))();
  BoolColumn get isArchived => boolean().withDefault(const Constant(false))();
  DateTimeColumn get addedAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  DateTimeColumn get lastOpenedAt => dateTime().nullable()();
}

// =========================================================
// 2. CHAPTERS
// =========================================================
class Chapters extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId => integer().customConstraint('NOT NULL REFERENCES books(id) ON DELETE CASCADE')();
  IntColumn get parentChapterId => integer().nullable().customConstraint('REFERENCES chapters(id) ON DELETE SET NULL')();
  IntColumn get spineIndex => integer()();
  IntColumn get tocOrder => integer().nullable()();
  TextColumn get href => text()();
  TextColumn get title => text().nullable()();
  IntColumn get wordCount => integer().nullable()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {bookId, spineIndex}
  ];
}

// =========================================================
// 3. READING PROGRESS
// =========================================================
class ReadingProgress extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().customConstraint('NOT NULL UNIQUE REFERENCES books(id) ON DELETE CASCADE')();
  IntColumn get chapterId => integer().customConstraint('NOT NULL REFERENCES chapters(id) ON DELETE CASCADE')();
  TextColumn get cfi => text().nullable()();
  RealColumn get scrollPct => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime()();
}

// =========================================================
// 4. BOOKMARKS
// =========================================================
class Bookmarks extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId => integer().customConstraint('NOT NULL REFERENCES books(id) ON DELETE CASCADE')();
  IntColumn get chapterId => integer().customConstraint('NOT NULL REFERENCES chapters(id) ON DELETE CASCADE')();
  TextColumn get cfi => text()();
  TextColumn get label => text().nullable()();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// =========================================================
// 5. HIGHLIGHTS
// =========================================================
class Highlights extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get uuid => text().unique()();
  IntColumn get bookId => integer().customConstraint('NOT NULL REFERENCES books(id) ON DELETE CASCADE')();
  IntColumn get chapterId => integer().customConstraint('NOT NULL REFERENCES chapters(id) ON DELETE CASCADE')();
  IntColumn get translationUnitId => integer().nullable().customConstraint('REFERENCES translation_units(id) ON DELETE SET NULL')();
  TextColumn get startAnchor => text()();
  TextColumn get endAnchor => text()();
  TextColumn get color => text().withDefault(const Constant('yellow'))();
  TextColumn get note => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
}

// =========================================================
// 6. TRANSLATION UNITS
// =========================================================
class TranslationUnits extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get chapterId => integer().customConstraint('NOT NULL REFERENCES chapters(id) ON DELETE CASCADE')();
  TextColumn get nodePath => text()();
  IntColumn get sequenceIndex => integer()();
  TextColumn get sourceTextHash => text()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {chapterId, nodePath}
  ];
}

// =========================================================
// 7. TRANSLATION CACHE
// =========================================================
class TranslationCache extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get sourceLanguage => text()();
  TextColumn get targetLanguage => text()();
  TextColumn get sourceText => text().nullable()();
  TextColumn get sourceTextHash => text()();
  TextColumn get translatedText => text()();
  TextColumn get provider => text()();
  TextColumn get providerVersion => text()();
  TextColumn get style => text().withDefault(const Constant('natural'))();
  IntColumn get hitCount => integer().withDefault(const Constant(1))();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get lastUsedAt => dateTime()();

  @override
  List<Set<Column>> get uniqueKeys => [
    {sourceTextHash, sourceLanguage, targetLanguage, provider, providerVersion, style}
  ];
}

// =========================================================
// 8. GLOSSARY TERMS
// =========================================================
class GlossaryTerms extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().nullable().customConstraint('REFERENCES books(id) ON DELETE CASCADE')();
  TextColumn get sourceTerm => text()();
  TextColumn get preferredTranslation => text()();
  TextColumn get sourceLanguage => text()();
  TextColumn get targetLanguage => text()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
}

// =========================================================
// 9. BOOK SETTINGS (Per-book reader preferences)
// =========================================================
class BookSettings extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().customConstraint('NOT NULL UNIQUE REFERENCES books(id) ON DELETE CASCADE')();
  RealColumn get fontSize => real().withDefault(const Constant(16.0))();
  TextColumn get readingTheme => text().withDefault(const Constant('light'))();
  BoolColumn get isTranslationEnabled => boolean().withDefault(const Constant(false))();
  TextColumn get translationStyle => text().withDefault(const Constant('natural'))();
  IntColumn get lastPageIndex => integer().withDefault(const Constant(0))();
  RealColumn get lastScrollOffset => real().withDefault(const Constant(0.0))();
  DateTimeColumn get updatedAt => dateTime()();
}

// =========================================================
// 9. READING SESSIONS (Time tracking)
// =========================================================
class ReadingSessions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get bookId => integer().customConstraint('NOT NULL REFERENCES books(id) ON DELETE CASCADE')();
  DateTimeColumn get startedAt => dateTime()();
  DateTimeColumn get endedAt => dateTime().nullable()();
  IntColumn get durationSeconds => integer().withDefault(const Constant(0))();
  IntColumn get chaptersRead => integer().withDefault(const Constant(0))();
  IntColumn get wordsTranslated => integer().withDefault(const Constant(0))();
}

// =========================================================
// DATABASE CLASS
// =========================================================
@DriftDatabase(tables: [
  Books,
  Chapters,
  ReadingProgress,
  Bookmarks,
  Highlights,
  TranslationUnits,
  TranslationCache,
  GlossaryTerms,
  BookSettings,
  ReadingSessions,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 4;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (m) async {
      await m.createAll();
      // PRD Section 9.2: Unique indexes for scoped vs global glossary terms
      await customStatement('''
        CREATE UNIQUE INDEX IF NOT EXISTS ux_glossary_scoped
        ON glossary_terms (book_id, source_term, source_language, target_language)
        WHERE book_id IS NOT NULL;
      ''');
      await customStatement('''
        CREATE UNIQUE INDEX IF NOT EXISTS ux_glossary_global
        ON glossary_terms (source_term, source_language, target_language)
        WHERE book_id IS NULL;
      ''');
      // Foreign keys enforcement
      await customStatement('PRAGMA foreign_keys = ON;');
    },
    onUpgrade: (m, from, to) async {
      // Schema v1 → v2: Add book_settings table
      if (from < 2) {
        await m.createTable(bookSettings);
      }
      // Schema v2 → v3: Add reading_sessions table
      if (from < 3) {
        await m.createTable(readingSessions);
      }
      // Schema v3 → v4: Add note column to bookmarks
      if (from < 4) {
        await m.addColumn(bookmarks, bookmarks.note);
      }
    },
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );

  // ========== BOOK SETTINGS CRUD ==========

  Future<BookSetting?> getBookSetting(int bookId) async {
    final query = select(bookSettings)..where((t) => t.bookId.equals(bookId));
    return query.getSingleOrNull();
  }

  Future<int> upsertBookSetting({
    required int bookId,
    double? fontSize,
    String? readingTheme,
    bool? isTranslationEnabled,
    String? translationStyle,
    int? lastPageIndex,
    double? lastScrollOffset,
  }) async {
    final existing = await getBookSetting(bookId);
    final now = DateTime.now();

    if (existing != null) {
      // Update existing
      final updateQuery = update(bookSettings)..where((t) => t.bookId.equals(bookId));
      return updateQuery.write(
        BookSettingsCompanion(
          fontSize: fontSize != null ? Value(fontSize) : const Value.absent(),
          readingTheme: readingTheme != null ? Value(readingTheme) : const Value.absent(),
          isTranslationEnabled: isTranslationEnabled != null ? Value(isTranslationEnabled) : const Value.absent(),
          translationStyle: translationStyle != null ? Value(translationStyle) : const Value.absent(),
          lastPageIndex: lastPageIndex != null ? Value(lastPageIndex) : const Value.absent(),
          lastScrollOffset: lastScrollOffset != null ? Value(lastScrollOffset) : const Value.absent(),
          updatedAt: Value(now),
        ),
      );
    } else {
      // Insert new
      return into(bookSettings).insert(
        BookSettingsCompanion.insert(
          bookId: bookId,
          fontSize: Value(fontSize ?? 16.0),
          readingTheme: Value(readingTheme ?? 'light'),
          isTranslationEnabled: Value(isTranslationEnabled ?? false),
          translationStyle: Value(translationStyle ?? 'natural'),
          lastPageIndex: Value(lastPageIndex ?? 0),
          lastScrollOffset: Value(lastScrollOffset ?? 0.0),
          updatedAt: now,
        ),
      );
    }
  }

  // ========== READING SESSIONS ==========

  Future<int> startReadingSession(int bookId) async {
    return into(readingSessions).insert(
      ReadingSessionsCompanion.insert(
        bookId: bookId,
        startedAt: DateTime.now(),
      ),
    );
  }

  Future<void> endReadingSession(int sessionId, {int chaptersRead = 0, int wordsTranslated = 0}) async {
    final session = await (select(readingSessions)..where((t) => t.id.equals(sessionId))).getSingleOrNull();
    if (session == null) return;

    final duration = DateTime.now().difference(session.startedAt).inSeconds;
    await (update(readingSessions)..where((t) => t.id.equals(sessionId))).write(
      ReadingSessionsCompanion(
        endedAt: Value(DateTime.now()),
        durationSeconds: Value(duration),
        chaptersRead: Value(chaptersRead),
        wordsTranslated: Value(wordsTranslated),
      ),
    );
  }

  Future<List<ReadingSession>> getReadingSessions(int bookId) async {
    return (select(readingSessions)
          ..where((t) => t.bookId.equals(bookId))
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();
  }

  Future<int> getTotalReadingTimeSeconds(int bookId) async {
    final sessions = await getReadingSessions(bookId);
    return sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
  }

  Future<Map<String, int>> getReadingStats(int bookId) async {
    final sessions = await getReadingSessions(bookId);
    final totalSeconds = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final totalChapters = sessions.fold<int>(0, (sum, s) => sum + s.chaptersRead);
    final totalWords = sessions.fold<int>(0, (sum, s) => sum + s.wordsTranslated);
    return {
      'totalSeconds': totalSeconds,
      'totalSessions': sessions.length,
      'totalChapters': totalChapters,
      'totalWordsTranslated': totalWords,
    };
  }

  /// Calculate reading streak across all books
  Future<int> getReadingStreak() async {
    final sessions = await select(readingSessions).get();
    if (sessions.isEmpty) return 0;

    // Get unique dates (just the date part)
    final dates = sessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .toList()
      ..sort((a, b) => b.compareTo(a)); // desc

    if (dates.isEmpty) return 0;

    // Check if today or yesterday has a session
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);
    final yesterdayDate = todayDate.subtract(const Duration(days: 1));

    if (!dates.contains(todayDate) && !dates.contains(yesterdayDate)) {
      return 0; // Streak broken
    }

    int streak = 1;
    for (int i = 0; i < dates.length - 1; i++) {
      final diff = dates[i].difference(dates[i + 1]).inDays;
      if (diff == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'alinea.sqlite'));
    return NativeDatabase.createInBackground(
      file,
      setup: (rawDb) {
        rawDb.execute('PRAGMA foreign_keys = ON;');
      },
    );
  });
}
