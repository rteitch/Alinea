import 'package:drift/drift.dart' hide isNull, isNotNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:alinea/core/storage/database.dart';
import 'package:alinea/features/glossary/data/glossary_repository.dart';

void main() {
  late AppDatabase db;
  late GlossaryRepository repo;

  setUp(() async {
    db = AppDatabase.forTesting(NativeDatabase.memory());
    repo = GlossaryRepository(db: db);

    final now = DateTime.now();
    await db.into(db.books).insert(
      BooksCompanion.insert(
        id: const Value(42),
        uuid: 'uuid-42',
        title: 'Book 42',
        filePath: '/test/42.epub',
        fileHash: 'hash-42',
        addedAt: now,
        updatedAt: now,
      ),
    );
    await db.into(db.books).insert(
      BooksCompanion.insert(
        id: const Value(99),
        uuid: 'uuid-99',
        title: 'Book 99',
        filePath: '/test/99.epub',
        fileHash: 'hash-99',
        addedAt: now,
        updatedAt: now,
      ),
    );
  });

  tearDown(() async {
    await db.close();
  });

  group('GlossaryRepository - ISTQB Decision Table & Scoping Tests', () {
    test('Decision Table Rule 1: Book-scoped match takes precedence over global match', () async {
      // Setup global term
      await repo.setTerm(
        sourceTerm: 'AI',
        preferredTranslation: 'Kecerdasan Buatan (Global)',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      // Setup scoped term for book 42
      await repo.setTerm(
        bookId: 42,
        sourceTerm: 'AI',
        preferredTranslation: 'Kecerdasan Artifisial (Buku 42)',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      // Resolve for book 42 -> should return scoped translation
      final resolvedFor42 = await repo.resolveTerm(
        bookId: 42,
        sourceTerm: 'AI',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolvedFor42, 'Kecerdasan Artifisial (Buku 42)');

      // Resolve for another book 99 -> should fall back to global translation
      final resolvedFor99 = await repo.resolveTerm(
        bookId: 99,
        sourceTerm: 'AI',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolvedFor99, 'Kecerdasan Buatan (Global)');
    });

    test('Decision Table Rule 2: Global term works when no scoped term exists', () async {
      await repo.setTerm(
        sourceTerm: 'Cloud',
        preferredTranslation: 'Komputasi Awan',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      final resolved = await repo.resolveTerm(
        bookId: 42,
        sourceTerm: 'Cloud',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolved, 'Komputasi Awan');
    });

    test('Decision Table Rule 3: Unknown term returns null', () async {
      final resolved = await repo.resolveTerm(
        bookId: 42,
        sourceTerm: 'Quantum',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );
      expect(resolved, isNull);
    });

    test('CRUD: Update existing term updates preferred translation without duplicate row', () async {
      await repo.setTerm(
        sourceTerm: 'Database',
        preferredTranslation: 'Basis Data',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      // Update
      await repo.setTerm(
        sourceTerm: 'Database',
        preferredTranslation: 'Pangkalan Data',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      final terms = await repo.getTerms();
      expect(terms.length, 1);
      expect(terms.first.preferredTranslation, 'Pangkalan Data');
    });

    test('CRUD: Delete term removes from database', () async {
      final term = await repo.setTerm(
        sourceTerm: 'Bug',
        preferredTranslation: 'Kutu Perangkat Lunak',
        sourceLanguage: 'en',
        targetLanguage: 'id',
      );

      final deletedCount = await repo.deleteTerm(term.id);
      expect(deletedCount, 1);

      final terms = await repo.getTerms();
      expect(terms, isEmpty);
    });
  });
}
