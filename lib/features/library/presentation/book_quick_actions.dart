import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';
import '../../reader/presentation/reading_stats_screen.dart';
import '../../reader/presentation/reader_screen.dart';
import 'library_screen.dart';

class BookQuickActions {
  static Future<void> show(
    BuildContext context,
    WidgetRef ref,
    Book book,
  ) async {
    final db = ref.read(databaseProvider);
    final setting = await db.getBookSetting(book.id);
    final sessions = await db.getReadingSessions(book.id);
    final totalSeconds = sessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final hours = totalSeconds ~/ 3600;
    final minutes = (totalSeconds % 3600) ~/ 60;

    if (!context.mounted) return;

    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(top: 12, bottom: 16),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Book header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                children: [
                  Icon(Icons.book_rounded, color: Theme.of(context).colorScheme.primary, size: 24),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          book.title,
                          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          '$hours jam $minutes menit dibaca',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const Divider(height: 24),

            // Actions
            ListTile(
              leading: const Icon(Icons.play_arrow_rounded),
              title: const Text('Lanjutkan Membaca'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ReaderScreen(bookId: book.id)),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_rounded),
              title: const Text('Statistik'),
              onTap: () {
                Navigator.pop(ctx);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ReadingStatsScreen(bookId: book.id, bookTitle: book.title),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(
                book.isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                color: book.isFavorite ? Colors.red : null,
              ),
              title: Text(book.isFavorite ? 'Hapus dari Favorit' : 'Tambah ke Favorit'),
              onTap: () async {
                final repo = ref.read(bookRepositoryProvider);
                await repo.toggleFavorite(book.id);
                ref.invalidate(booksListProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            ListTile(
              leading: Icon(
                book.isArchived ? Icons.unarchive_rounded : Icons.archive_rounded,
              ),
              title: Text(book.isArchived ? 'Pulihkan Buku' : 'Arsipkan Buku'),
              onTap: () async {
                final repo = ref.read(bookRepositoryProvider);
                if (book.isArchived) {
                  await repo.restoreBook(book.id);
                } else {
                  await repo.archiveBook(book.id);
                }
                ref.invalidate(booksListProvider);
                if (ctx.mounted) Navigator.pop(ctx);
              },
            ),
            const Divider(height: 1),
            ListTile(
              leading: Icon(Icons.archive_rounded, color: Colors.red.shade400),
              title: Text('Arsipkan Buku', style: TextStyle(color: Colors.red.shade400)),
              onTap: () async {
                final confirmed = await showDialog<bool>(
                  context: ctx,
                  builder: (dCtx) => AlertDialog(
                    title: const Text('Arsipkan Buku?'),
                    content: Text(' "${book.title}" akan diarsipkan dan tidak tampil di perpustakaan utama.'),
                    actions: [
                      TextButton(onPressed: () => Navigator.pop(dCtx, false), child: const Text('Batal')),
                      TextButton(
                        onPressed: () => Navigator.pop(dCtx, true),
                        child: Text('Arsipkan', style: TextStyle(color: Colors.red.shade400)),
                      ),
                    ],
                  ),
                );
                if (confirmed == true) {
                  final repo = ref.read(bookRepositoryProvider);
                  await repo.archiveBook(book.id);
                  ref.invalidate(booksListProvider);
                  if (ctx.mounted) Navigator.pop(ctx);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
