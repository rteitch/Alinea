import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/errors/failures.dart';
import '../../../core/storage/database.dart';
import '../../reader/presentation/reading_goal_card.dart';
import '../../reader/presentation/reader_screen.dart';
import '../../settings/presentation/settings_screen.dart';
import 'cover_gallery_screen.dart';
import '../../../l10n/app_localizations.dart';
import 'collection_dialog.dart';
import 'reading_challenge_screen.dart';
import 'achievements_screen.dart';
import 'book_comparison_screen.dart';
import 'reading_heatmap_screen.dart';
import 'highlights_summary_screen.dart';
import 'bookmarks_summary_screen.dart';
import 'reading_pace_screen.dart';
import 'reading_distribution_screen.dart';
import 'bookshelf_magazine_view.dart';
import 'vocabulary_builder_screen.dart';
import 'reading_goals_dashboard.dart';
import 'book_quick_actions.dart';

final collectionFilterProvider = StateProvider<int?>((ref) => null);

final booksListProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  final repo = ref.watch(bookRepositoryProvider);
  final filter = ref.watch(libraryFilterProvider);
  final sortBy = ref.watch(librarySortProvider);
  final collectionId = ref.watch(collectionFilterProvider);

  // If a collection filter is active, use it
  if (collectionId != null) {
    return await ref.watch(databaseProvider).getBooksInCollection(collectionId);
  }

  switch (filter) {
    case 'in_progress':
      return await repo.getBooks(readingStatus: 'in_progress', sortBy: sortBy);
    case 'finished':
      return await repo.getBooks(readingStatus: 'finished', sortBy: sortBy);
    case 'favorite':
      return await repo.getBooks(isFavorite: true, sortBy: sortBy);
    default:
      return await repo.getBooks(sortBy: sortBy);
  }
});

class LibraryScreen extends ConsumerStatefulWidget {
  const LibraryScreen({super.key});

  @override
  ConsumerState<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends ConsumerState<LibraryScreen> {
  bool _isImporting = false;
  String _searchQuery = '';
  String _viewMode = 'grid'; // 'grid', 'list', 'magazine'

  Future<void> _handleImportEpub() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['epub'],
        withData: true,
      );

      if (result == null || result.files.isEmpty) return;

      final pickedFile = result.files.first;
      var fileBytes = pickedFile.bytes;

      if (fileBytes == null && pickedFile.path != null) {
        final f = File(pickedFile.path!);
        if (await f.exists()) {
          fileBytes = await f.readAsBytes();
        }
      }

      if (fileBytes == null) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Gagal membaca data file EPUB.')),
          );
        }
        return;
      }

      setState(() => _isImporting = true);

      final appDir = await getApplicationDocumentsDirectory();
      final targetPath = '${appDir.path}/books/${pickedFile.name}';

      final repo = ref.read(bookRepositoryProvider);
      final book = await repo.importBook(
        fileBytes: fileBytes,
        targetFilePath: targetPath,
      );

      if (mounted) {
        ref.invalidate(booksListProvider);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Berhasil mengimpor: "${book.title}"'),
            backgroundColor: Colors.green.shade700,
          ),
        );
      }
    } on DatabaseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.message),
            backgroundColor: Colors.amber.shade900,
          ),
        );
      }
    } on EpubParseException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Format EPUB tidak valid: ${e.message}'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Kesalahan import: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isImporting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final booksAsync = ref.watch(booksListProvider);
    final currentFilter = ref.watch(libraryFilterProvider);

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: Image.asset(
                'assets/images/logo.png',
                width: 32,
                height: 32,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              AppLocalizations.of(context)!.appTitle,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: Theme.of(context).colorScheme.onSurface,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                AppLocalizations.of(context)!.appTagline,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  letterSpacing: 0.8,
                ),
              ),
            ),
            const SizedBox(width: 6),
            // Reading streak badge
            _buildStreakBadge(context),
          ],
        ),
        actions: [
          // App-wide theme toggle
          Consumer(
            builder: (context, ref, _) {
              final currentTheme = ref.watch(readingThemeModeProvider);
              return IconButton(
                icon: Icon(_getAppThemeIcon(currentTheme)),
                tooltip: 'Mode Tema (${_getAppThemeName(currentTheme)})',
                onPressed: () {
                  final next = _nextAppTheme(currentTheme);
                  ref.read(readingThemeModeProvider.notifier).state = next;
                  ref.read(appSettingsProvider.notifier).save(
                        ref.read(appSettingsProvider).copyWith(readingTheme: next.name),
                      );
                },
              );
            },
          ),
          // Reading Features menu
          PopupMenuButton<String>(
            icon: const Icon(Icons.insights_rounded, size: 22),
            tooltip: 'Fitur Membaca',
            onSelected: (value) {
              switch (value) {
                case 'challenges':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingChallengeScreen()));
                  break;
                case 'achievements':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen()));
                  break;
                case 'comparison':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BookComparisonScreen()));
                  break;
                case 'heatmap':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingHeatMapScreen()));
                  break;
                case 'highlights_summary':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const HighlightsSummaryScreen()));
                  break;
                case 'bookmarks_summary':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const BookmarksSummaryScreen()));
                  break;
                case 'pace':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingPaceScreen()));
                  break;
                case 'distribution':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingDistributionScreen()));
                  break;
                case 'vocabulary':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const VocabularyBuilderScreen()));
                  break;
                case 'goals':
                  Navigator.push(context, MaterialPageRoute(builder: (_) => const ReadingGoalsDashboard()));
                  break;
              }
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'challenges', child: ListTile(leading: Icon(Icons.emoji_events_rounded), title: Text('Tantangan Membaca'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'achievements', child: ListTile(leading: Icon(Icons.workspace_premium_rounded), title: Text('Pencapaian'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'comparison', child: ListTile(leading: Icon(Icons.bar_chart_rounded), title: Text('Perbandingan Buku'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'heatmap', child: ListTile(leading: Icon(Icons.local_fire_department_rounded), title: Text('Peta Membaca'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'highlights_summary', child: ListTile(leading: Icon(Icons.highlight_rounded), title: Text('Semua Highlight'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'bookmarks_summary', child: ListTile(leading: Icon(Icons.bookmark_rounded), title: Text('Semua Bookmark'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'pace', child: ListTile(leading: Icon(Icons.speed_rounded), title: Text('Kecepatan Membaca'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'distribution', child: ListTile(leading: Icon(Icons.pie_chart_rounded), title: Text('Distribusi Membaca'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuDivider(),
              const PopupMenuItem(value: 'vocabulary', child: ListTile(leading: Icon(Icons.school_rounded), title: Text('Kosakata'), dense: true, contentPadding: EdgeInsets.zero)),
              const PopupMenuItem(value: 'goals', child: ListTile(leading: Icon(Icons.track_changes_rounded), title: Text('Target Membaca'), dense: true, contentPadding: EdgeInsets.zero)),
            ],
          ),
          // View toggle
          IconButton(
            icon: Icon(_viewMode == 'grid' ? Icons.view_list_rounded : _viewMode == 'list' ? Icons.view_module_rounded : Icons.grid_view_rounded),
            tooltip: _viewMode == 'grid' ? 'Tampilan List' : _viewMode == 'list' ? 'Tampilan Magazine' : 'Tampilan Grid',
            onPressed: () {
              setState(() {
                _viewMode = _viewMode == 'grid' ? 'list' : _viewMode == 'list' ? 'magazine' : 'grid';
              });
            },
          ),
          // Sort dropdown
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            tooltip: 'Urutkan',
            onSelected: (value) {
              ref.read(librarySortProvider.notifier).state = value;
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'date_added', child: Text('Tanggal Ditambahkan')),
              const PopupMenuItem(value: 'title', child: Text('Judul (A-Z)')),
              const PopupMenuItem(value: 'author', child: Text('Penulis (A-Z)')),
              const PopupMenuItem(value: 'last_opened', child: Text('Terakhir Dibuka')),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Pengaturan & Transparansi FOSS',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsScreen()),
              );
            },
              ),
              // Collection chips
              Consumer(
                builder: (context, ref, _) {
                  final db = ref.watch(databaseProvider);
                  return FutureBuilder<List<Collection>>(
                    future: db.getAllCollections(),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData || snapshot.data!.isEmpty) return const SizedBox.shrink();
                      final colls = snapshot.data!;
                      final currentCollFilter = ref.watch(collectionFilterProvider);
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                        child: Row(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: const Text('+ Koleksi', style: TextStyle(fontSize: 12)),
                                onSelected: (_) async {
                                  final result = await showDialog<bool>(
                                    context: context,
                                    builder: (_) => const CreateCollectionDialog(),
                                  );
                                  if (result == true) setState(() {});
                                },
                                visualDensity: VisualDensity.compact,
                              ),
                            ),
                            ...colls.map((col) => Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: FilterChip(
                                label: Text(col.name, style: const TextStyle(fontSize: 12)),
                                selected: currentCollFilter == col.id,
                                onSelected: (selected) {
                                  ref.read(collectionFilterProvider.notifier).state =
                                      selected ? col.id : null;
                                },
                                onDeleted: currentCollFilter == col.id ? () async {
                                  await db.deleteCollection(col.id);
                                  ref.read(collectionFilterProvider.notifier).state = null;
                                  setState(() {});
                                } : null,
                                visualDensity: VisualDensity.compact,
                              ),
                            )),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(105),
          child: Column(
            children: [
              // Search input
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.searchHint,
                    prefixIcon: const Icon(Icons.search, size: 20),
                    isDense: true,
                    contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide(color: Colors.grey.shade300),
                    ),
                    filled: true,
                    fillColor: Theme.of(context).colorScheme.surface,
                  ),
                  onChanged: (val) => setState(() => _searchQuery = val.toLowerCase()),
                ),
              ),
              // Filter chips
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                child: Row(
                  children: [
                    _buildFilterChip(AppLocalizations.of(context)!.filterAll, 'all', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip(AppLocalizations.of(context)!.filterReading, 'in_progress', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip(AppLocalizations.of(context)!.filterFinished, 'finished', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip(AppLocalizations.of(context)!.filterFavorite, 'favorite', currentFilter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
       body: _isImporting
           ? Center(
               child: Column(
                 mainAxisSize: MainAxisSize.min,
                 children: [
                   CircularProgressIndicator(),
                   SizedBox(height: 16),
                    Text(AppLocalizations.of(context)!.importing),
                 ],
               ),
             )
           : booksAsync.when(
               data: (books) {
                 final filtered = books.where((b) {
                   if (_searchQuery.isEmpty) return true;
                   final titleMatch = b.title.toLowerCase().contains(_searchQuery);
                   final authorMatch = (b.author ?? '').toLowerCase().contains(_searchQuery);
                   return titleMatch || authorMatch;
                 }).toList();

                 if (filtered.isEmpty) {
                   return _buildEmptyState();
                 }

                  if (_viewMode == 'list') {
                    return Column(
                      children: [
                        const ReadingGoalCard(),
                        Expanded(
                          child: ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: filtered.length,
                            itemBuilder: (context, index) {
                              final book = filtered[index];
                              return _BookListTile(
                                book: book,
                                onTap: () async {
                                  await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ReaderScreen(bookId: book.id),
                                    ),
                                  );
                                  ref.invalidate(booksListProvider);
                                },
                                onFavoriteToggle: () async {
                                  final repo = ref.read(bookRepositoryProvider);
                                  await repo.toggleFavorite(book.id);
                                  ref.invalidate(booksListProvider);
                                },
                              );
                            },
                          ),
                        ),
                      ],
                    );
                  }

                  if (_viewMode == 'magazine') {
                    return Column(
                      children: [
                        const ReadingGoalCard(),
                        Expanded(
                          child: BookshelfMagazineView(books: filtered),
                        ),
                      ],
                    );
                  }

                  return Column(
                    children: [
                      const ReadingGoalCard(),
                      Expanded(
                        child: GridView.builder(
                          padding: const EdgeInsets.all(16),
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 0.58,
                            crossAxisSpacing: 14,
                            mainAxisSpacing: 14,
                          ),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) {
                            final book = filtered[index];
                            return _BookCard(
                              book: book,
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ReaderScreen(bookId: book.id),
                                  ),
                                );
                                ref.invalidate(booksListProvider);
                              },
                              onFavoriteToggle: () async {
                                final repo = ref.read(bookRepositoryProvider);
                                await repo.toggleFavorite(book.id);
                                ref.invalidate(booksListProvider);
                              },
                              onArchive: () async {
                                final repo = ref.read(bookRepositoryProvider);
                                await repo.archiveBook(book.id);
                                ref.invalidate(booksListProvider);
                                if (context.mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('Buku telah diarsipkan.')),
                                  );
                                }
                              },
                              onCoverTap: () {
                                final booksWithCovers = filtered.where(
                                  (b) => b.coverPath != null && File(b.coverPath!).existsSync(),
                                ).toList();
                                final coverIndex = booksWithCovers.indexWhere((b) => b.id == book.id);
                                if (coverIndex >= 0) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => CoverGalleryScreen(
                                        books: booksWithCovers,
                                        initialIndex: coverIndex,
                                      ),
                                    ),
                                  );
                                }
                              },
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
               error: (err, stack) => Center(
                 child: Text('Terjadi kesalahan memuat perpustakaan: $err'),
               ),
             ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _handleImportEpub,
        icon: const Icon(Icons.add),
        label: Text(AppLocalizations.of(context)!.importEpub),
      ),
    );
  }

  Widget _buildStreakBadge(BuildContext context) {
    final db = ref.watch(databaseProvider);
    return FutureBuilder<int>(
      future: db.getReadingStreak(),
      builder: (context, snapshot) {
        final streak = snapshot.data ?? 0;
        if (streak == 0) return const SizedBox.shrink();
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.orange.shade300),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('🔥', style: TextStyle(fontSize: 10)),
              const SizedBox(width: 2),
              Text(
                '$streak hari',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange.shade800,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  ReadingThemeMode _nextAppTheme(ReadingThemeMode current) {
    switch (current) {
      case ReadingThemeMode.system:
        return ReadingThemeMode.light;
      case ReadingThemeMode.light:
        return ReadingThemeMode.dark;
      case ReadingThemeMode.dark:
        return ReadingThemeMode.sepia;
      case ReadingThemeMode.sepia:
        return ReadingThemeMode.amoled;
      case ReadingThemeMode.amoled:
        return ReadingThemeMode.system;
    }
  }

  IconData _getAppThemeIcon(ReadingThemeMode theme) {
    switch (theme) {
      case ReadingThemeMode.system:
        return Icons.brightness_auto_rounded;
      case ReadingThemeMode.light:
        return Icons.light_mode_rounded;
      case ReadingThemeMode.sepia:
        return Icons.wb_sunny_rounded;
      case ReadingThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ReadingThemeMode.amoled:
        return Icons.brightness_1_rounded;
    }
  }

  String _getAppThemeName(ReadingThemeMode theme) {
    switch (theme) {
      case ReadingThemeMode.system:
        return 'Sistem';
      case ReadingThemeMode.light:
        return 'Terang';
      case ReadingThemeMode.sepia:
        return 'Sepia';
      case ReadingThemeMode.dark:
        return 'Gelap';
      case ReadingThemeMode.amoled:
        return 'AMOLED';
    }
  }

  Widget _buildFilterChip(String label, String value, String currentFilter) {
    final isSelected = currentFilter == value;
    final theme = Theme.of(context);
    return FilterChip(
      label: Text(
        label,
        style: TextStyle(
          fontSize: 12,
          fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          color: isSelected ? theme.colorScheme.onPrimary : theme.colorScheme.onSurface,
        ),
      ),
      selected: isSelected,
      selectedColor: theme.colorScheme.primary,
      checkmarkColor: theme.colorScheme.onPrimary,
      backgroundColor: theme.colorScheme.surface,
      side: BorderSide(
        color: isSelected ? theme.colorScheme.primary : theme.colorScheme.outline.withAlpha(80),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      onSelected: (_) {
        ref.read(libraryFilterProvider.notifier).state = value;
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 36),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(3),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
                    blurRadius: 24,
                    spreadRadius: 4,
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(40),
                child: Image.asset(
                  'assets/images/logo.png',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Perpustakaan Masih Kosong',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Tambahkan buku digital (EPUB) untuk mulai membaca dengan fitur auto-terjemahan instan.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13.5, color: Colors.grey.shade600, height: 1.4),
            ),
            const SizedBox(height: 20),
            FilledButton.icon(
              onPressed: _handleImportEpub,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Impor Buku EPUB'),
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BookCard extends ConsumerWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onArchive;
  final VoidCallback? onCoverTap;

  const _BookCard({
    required this.book,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onArchive,
    this.onCoverTap,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(
      FutureProvider.autoDispose<double>((r) {
        return r.watch(bookRepositoryProvider).getOverallProgressPct(book.id);
      }),
    );

    return InkWell(
      onTap: onTap,
      onLongPress: () => BookQuickActions.show(context, ref, book),
      borderRadius: BorderRadius.circular(12),
      child: Card(
        elevation: 2,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Cover Image or Stylized Placeholder
            Expanded(
              flex: 4,
              child: GestureDetector(
                onTap: onCoverTap,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    if (book.coverPath != null && File(book.coverPath!).existsSync())
                      Image.file(File(book.coverPath!), fit: BoxFit.cover)
                    else
                      Container(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        padding: const EdgeInsets.all(12),
                        alignment: Alignment.center,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.auto_stories_rounded,
                              size: 36,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                            const SizedBox(height: 6),
                            Text(
                              book.title,
                              maxLines: 2,
                              textAlign: TextAlign.center,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                                color: Theme.of(context).colorScheme.onPrimaryContainer,
                              ),
                            ),
                          ],
                        ),
                      ),
                    // Favorite Star Badge
                    Positioned(
                      top: 6,
                      right: 6,
                      child: CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.black.withAlpha(100),
                        child: IconButton(
                          iconSize: 16,
                          padding: EdgeInsets.zero,
                          icon: Icon(
                            book.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                            color: book.isFavorite ? Colors.amber : Colors.white,
                          ),
                          onPressed: onFavoriteToggle,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Metadata & Progress
            Expanded(
              flex: 3,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                        ),
                        if (book.author != null)
                          Text(
                            book.author!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                          ),
                      ],
                    ),
                    progressAsync.when(
                      data: (pct) {
                        final pctInt = (pct * 100).toInt();
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  _statusLabel(book.readingStatus),
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: _statusColor(book.readingStatus),
                                  ),
                                ),
                                Text(
                                  '$pctInt% selesai',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Theme.of(context).colorScheme.primary,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(3),
                              child: LinearProgressIndicator(
                                value: pct.clamp(0.0, 1.0),
                                minHeight: 4.5,
                                backgroundColor: Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox(height: 20),
                      error: (_, _) => const SizedBox(),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'in_progress':
        return 'Sedang Baca';
      case 'finished':
        return 'Selesai';
      default:
        return 'Belum Dibaca';
    }
  }

  Color _statusColor(String status) {
    switch (status) {
      case 'in_progress':
        return Colors.blue.shade700;
      case 'finished':
        return Colors.green.shade700;
      default:
        return Colors.grey.shade600;
    }
  }
}

class _BookListTile extends ConsumerWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;

  const _BookListTile({
    required this.book,
    required this.onTap,
    required this.onFavoriteToggle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(
      FutureProvider.autoDispose<double>((r) {
        return r.watch(bookRepositoryProvider).getOverallProgressPct(book.id);
      }),
    );

    return Card(
      margin: const EdgeInsets.only(bottom: 10),
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              // Cover thumbnail
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: SizedBox(
                  width: 50,
                  height: 70,
                  child: book.coverPath != null && File(book.coverPath!).existsSync()
                      ? Image.file(File(book.coverPath!), fit: BoxFit.cover)
                      : Container(
                          color: Theme.of(context).colorScheme.primaryContainer,
                          child: Icon(
                            Icons.auto_stories_rounded,
                            size: 24,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              // Book info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                    ),
                    if (book.author != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        book.author!,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
                    ],
                    const SizedBox(height: 6),
                    progressAsync.when(
                      data: (pct) {
                        final pctInt = (pct * 100).toInt();
                        return Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(3),
                                child: LinearProgressIndicator(
                                  value: pct.clamp(0.0, 1.0),
                                  minHeight: 4,
                                  backgroundColor: Theme.of(context).colorScheme.outlineVariant.withAlpha(90),
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '$pctInt%',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                          ],
                        );
                      },
                      loading: () => const SizedBox(height: 16),
                      error: (_, _) => const SizedBox(),
                    ),
                  ],
                ),
              ),
              // Favorite button
              IconButton(
                icon: Icon(
                  book.isFavorite ? Icons.star_rounded : Icons.star_outline_rounded,
                  color: book.isFavorite ? Colors.amber : Colors.grey.shade400,
                  size: 22,
                ),
                onPressed: onFavoriteToggle,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
