import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class BookshelfMagazineView extends ConsumerWidget {
  final List<Book> books;

  const BookshelfMagazineView({super.key, required this.books});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: books.length,
      itemBuilder: (context, index) {
        final book = books[index];
        return _MagazineBookCard(book: book, db: db);
      },
    );
  }
}

class _MagazineBookCard extends StatefulWidget {
  final Book book;
  final AppDatabase db;

  const _MagazineBookCard({required this.book, required this.db});

  @override
  State<_MagazineBookCard> createState() => _MagazineBookCardState();
}

class _MagazineBookCardState extends State<_MagazineBookCard> {
  int _totalSeconds = 0;
  int _totalSessions = 0;
  int _totalChapters = 0;
  int _todayMinutes = 0;
  double _progress = 0.0;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await widget.db.getReadingStats(widget.book.id);
    final sessions = await widget.db.getReadingSessions(widget.book.id);

    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    int todayMin = 0;
    for (final s in sessions) {
      if (s.startedAt.isAfter(todayStart)) {
        todayMin += s.durationSeconds ~/ 60;
      }
    }

    // Get reading progress
    final progressQuery = widget.db.select(widget.db.readingProgress)
      ..where((t) => t.bookId.equals(widget.book.id));
    final progressList = await progressQuery.get();
    final progress = progressList.isNotEmpty ? progressList.first.scrollPct : 0.0;

    setState(() {
      _totalSeconds = stats['totalSeconds'] ?? 0;
      _totalSessions = stats['totalSessions'] ?? 0;
      _totalChapters = stats['totalChapters'] ?? 0;
      _todayMinutes = todayMin;
      _progress = progress;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hours = _totalSeconds ~/ 3600;
    final minutes = (_totalSeconds % 3600) ~/ 60;
    final timeStr = hours > 0 ? '${hours}j ${minutes}m' : '$minutes m';

    final statusColor = widget.book.readingStatus == 'finished'
        ? Colors.green
        : widget.book.readingStatus == 'in_progress'
            ? Colors.blue
            : Colors.grey;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header with gradient
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.primaryContainer,
                  theme.colorScheme.primaryContainer.withOpacity(0.6),
                ],
              ),
            ),
            child: Row(
              children: [
                // Cover
                if (widget.book.coverPath != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.asset(
                      widget.book.coverPath!,
                      width: 48,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        width: 48,
                        height: 64,
                        decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                        child: Icon(Icons.book_rounded, color: theme.colorScheme.primary),
                      ),
                    ),
                  )
                else
                  Container(
                    width: 48,
                    height: 64,
                    decoration: BoxDecoration(color: theme.colorScheme.primary.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                    child: Icon(Icons.book_rounded, color: theme.colorScheme.primary),
                  ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.book.title,
                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      if (widget.book.author != null && widget.book.author!.isNotEmpty)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            widget.book.author!,
                            style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                    ],
                  ),
                ),
                // Status badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    widget.book.readingStatus == 'finished' ? 'Selesai' :
                    widget.book.readingStatus == 'in_progress' ? 'Dibaca' : 'Baru',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w600, color: statusColor),
                  ),
                ),
              ],
            ),
          ),

          // Progress bar
          if (_progress > 0)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: Row(
                children: [
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: _progress,
                        minHeight: 6,
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text('${(_progress * 100).round()}%', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                ],
              ),
            ),

          // Stats row
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _inlineStat(Icons.access_time_rounded, timeStr, Colors.blue),
                _inlineStat(Icons.play_circle_outline_rounded, '$_totalSessions sesi', Colors.purple),
                _inlineStat(Icons.chrome_reader_mode_rounded, '$_totalChapters bab', Colors.green),
                if (_todayMinutes > 0)
                  _inlineStat(Icons.today_rounded, '$_todayMinutes m hari ini', Colors.orange),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _inlineStat(IconData icon, String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: color),
        const SizedBox(width: 3),
        Text(text, style: TextStyle(fontSize: 11, color: Colors.grey.shade700)),
      ],
    );
  }
}
