import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/services/tts_service.dart';
import '../core/storage/database.dart';
import '../core/storage/settings_repository.dart';
import '../features/bookmarks/data/bookmark_repository.dart';
import '../features/glossary/data/glossary_repository.dart';
import '../features/highlights/data/highlight_repository.dart';
import '../features/library/data/book_repository.dart';
import '../features/translation/data/providers/byok_provider.dart';
import '../features/translation/data/providers/foss_cloud_provider.dart';
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

// Audio & TTS
final ttsServiceProvider = Provider<TtsService>((ref) {
  final service = TtsService();
  ref.onDispose(() => service.dispose());
  return service;
});

// Settings & Preferences
final settingsRepositoryProvider = Provider<SettingsRepository>((ref) {
  return SettingsRepository();
});

class SettingsNotifier extends StateNotifier<AppSettings> {
  final SettingsRepository repo;

  SettingsNotifier(this.repo) : super(const AppSettings()) {
    load();
  }

  Future<void> load() async {
    state = await repo.loadSettings();
  }

  Future<void> save(AppSettings newSettings) async {
    state = newSettings;
    await repo.saveSettings(newSettings);
  }
}

final appSettingsProvider = StateNotifierProvider<SettingsNotifier, AppSettings>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return SettingsNotifier(repo);
});

final fossCloudProvider = Provider<TranslationProvider>((ref) {
  return FossCloudProvider();
});

// Translation Engine Provider (dynamically synced with app settings)
final activeTranslationProvider = Provider<TranslationProvider>((ref) {
  final settings = ref.watch(appSettingsProvider);
  if (settings.activeProviderId == 'byok') {
    return BringYourOwnKeyProvider(
      providerType: 'deepl',
      apiKey: settings.byokKey,
      customEndpoint: settings.byokEndpoint,
    );
  }
  if (settings.activeProviderId == 'libretranslate') {
    return LibreTranslateProvider(baseUrl: settings.gatewayUrl);
  }
  return ref.watch(fossCloudProvider);
});

final translationCoordinatorProvider = Provider<TranslationCoordinator>((ref) {
  final cacheRepo = ref.watch(translationCacheRepositoryProvider);
  final glossaryRepo = ref.watch(glossaryRepositoryProvider);
  final provider = ref.watch(activeTranslationProvider);
  final fallback = ref.watch(fossCloudProvider);
  return TranslationCoordinator(
    cacheRepo: cacheRepo,
    glossaryRepo: glossaryRepo,
    activeProvider: provider,
    fallbackProvider: fallback,
  );
});

// Preferences State
final readingThemeModeProvider = StateProvider<ReadingThemeMode>((ref) {
  return ReadingThemeMode.light;
});

final targetLanguageProvider = Provider<String>((ref) {
  return ref.watch(appSettingsProvider).targetLanguage;
});

final autoDetectLanguageProvider = Provider<bool>((ref) {
  return ref.watch(appSettingsProvider).autoDetectLanguage;
});

final detectionLanguagesProvider = Provider<List<String>>((ref) {
  return ref.watch(appSettingsProvider).detectionLanguages;
});

final libraryFilterProvider = StateProvider<String>((ref) {
  return 'all'; // 'all', 'in_progress', 'finished', 'favorite'
});

// Book Settings (per-book reader preferences)
final bookSettingsProvider = FutureProvider.family<BookSetting?, int>((ref, bookId) async {
  final db = ref.watch(databaseProvider);
  return db.getBookSetting(bookId);
});

