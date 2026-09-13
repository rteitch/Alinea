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
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 1;

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
    beforeOpen: (details) async {
      await customStatement('PRAGMA foreign_keys = ON;');
    },
  );
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
