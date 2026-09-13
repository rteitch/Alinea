import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import '../../../app/providers.dart';
import '../../../core/errors/failures.dart';
import '../../../core/storage/database.dart';
import '../../reader/presentation/reader_screen.dart';
import '../../settings/presentation/settings_screen.dart';

final booksListProvider = FutureProvider.autoDispose<List<Book>>((ref) async {
  final repo = ref.watch(bookRepositoryProvider);
  final filter = ref.watch(libraryFilterProvider);

  switch (filter) {
    case 'in_progress':
      return await repo.getBooks(readingStatus: 'in_progress');
    case 'finished':
      return await repo.getBooks(readingStatus: 'finished');
    case 'favorite':
      return await repo.getBooks(isFavorite: true);
    default:
      return await repo.getBooks();
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
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'Alinea',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  letterSpacing: 0.5,
                ),
              ),
            ),
            const SizedBox(width: 8),
            Text(
              'Library',
              style: TextStyle(
                fontSize: 18,
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
        actions: [
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
                    hintText: 'Cari judul atau penulis...',
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
                    _buildFilterChip('Semua', 'all', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip('Sedang Dibaca', 'in_progress', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip('Selesai', 'finished', currentFilter),
                    const SizedBox(width: 8),
                    _buildFilterChip('Favorit', 'favorite', currentFilter),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: _isImporting
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Sedang memproses & memvalidasi file EPUB...'),
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

                return GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.65,
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
                    );
                  },
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
        label: const Text('Import EPUB'),
      ),
    );
  }

  Widget _buildFilterChip(String label, String value, String currentFilter) {
    final isSelected = currentFilter == value;
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) {
        ref.read(libraryFilterProvider.notifier).state = value;
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.menu_book_outlined, size: 72, color: Colors.grey.shade400),
          const SizedBox(height: 16),
          Text(
            'Perpustakaan Masih Kosong',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Klik tombol "Import EPUB" di bawah untuk menambahkan buku pertama Anda.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 14, color: Colors.grey.shade500),
          ),
        ],
      ),
    );
  }
}

class _BookCard extends ConsumerWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavoriteToggle;
  final VoidCallback onArchive;

  const _BookCard({
    required this.book,
    required this.onTap,
    required this.onFavoriteToggle,
    required this.onArchive,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final progressAsync = ref.watch(
      FutureProvider.autoDispose<ReadingProgressData?>((r) {
        return r.watch(bookRepositoryProvider).getReadingProgress(book.id);
      }),
    );

    return InkWell(
      onTap: onTap,
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        progressAsync.when(
                          data: (progress) {
                            final pct = progress?.scrollPct ?? 0.0;
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                LinearProgressIndicator(
                                  value: pct,
                                  minHeight: 4,
                                  borderRadius: BorderRadius.circular(2),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      _statusLabel(book.readingStatus),
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w500,
                                        color: _statusColor(book.readingStatus),
                                      ),
                                    ),
                                    Text(
                                      '${(pct * 100).toInt()}%',
                                      style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                                    ),
                                  ],
                                ),
                              ],
                            );
                          },
                          loading: () => const LinearProgressIndicator(minHeight: 4),
                          error: (_, _) => const SizedBox(),
                        ),
                      ],
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
