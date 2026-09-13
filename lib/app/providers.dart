import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/storage/database.dart';
import '../features/bookmarks/data/bookmark_repository.dart';
import '../features/glossary/data/glossary_repository.dart';
import '../features/highlights/data/highlight_repository.dart';
import '../features/library/data/book_repository.dart';
import '../features/translation/data/providers/libretranslate_provider.dart';
import '../features/translation/data/translation_cache_repository.dart';
import '../features/translation/domain/translation_coordinator.dart';
import '../features/translation/domain/translation_provider.dart';
import 'theme/app_theme.dart';

// Database & Core Repositories
final databaseProvider = Provider<AppDatabase>((ref) {
  final db = AppDatabase();
  ref.onDispose(() => db.close());
  return db;
});

final bookRepositoryProvider = Provider<BookRepository>((ref) {
  return BookRepository(db: ref.watch(databaseProvider));
});

final bookmarkRepositoryProvider = Provider<BookmarkRepository>((ref) {
  return BookmarkRepository(db: ref.watch(databaseProvider));
});

final highlightRepositoryProvider = Provider<HighlightRepository>((ref) {
  return HighlightRepository(db: ref.watch(databaseProvider));
});

final glossaryRepositoryProvider = Provider<GlossaryRepository>((ref) {
  return GlossaryRepository(db: ref.watch(databaseProvider));
});

final translationCacheRepositoryProvider = Provider<TranslationCacheRepository>((ref) {
  return TranslationCacheRepository(db: ref.watch(databaseProvider));
});

// Translation Engine Provider
final activeTranslationProvider = StateProvider<TranslationProvider>((ref) {
  return LibreTranslateProvider();
});

final translationCoordinatorProvider = Provider<TranslationCoordinator>((ref) {
  final cacheRepo = ref.watch(translationCacheRepositoryProvider);
  final glossaryRepo = ref.watch(glossaryRepositoryProvider);
  final provider = ref.watch(activeTranslationProvider);
  return TranslationCoordinator(
    cacheRepo: cacheRepo,
    glossaryRepo: glossaryRepo,
    activeProvider: provider,
  );
});

// Preferences State
final readingThemeModeProvider = StateProvider<ReadingThemeMode>((ref) {
  return ReadingThemeMode.light;
});

final targetLanguageProvider = StateProvider<String>((ref) {
  return 'id'; // Default Bahasa Indonesia
});

final libraryFilterProvider = StateProvider<String>((ref) {
  return 'all'; // 'all', 'in_progress', 'finished', 'favorite'
});
