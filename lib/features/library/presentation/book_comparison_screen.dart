import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class BookComparisonScreen extends ConsumerStatefulWidget {
  const BookComparisonScreen({super.key});

  @override
  ConsumerState<BookComparisonScreen> createState() => _BookComparisonScreenState();
}

class _BookComparisonScreenState extends ConsumerState<BookComparisonScreen> {
  String _sortBy = 'time'; // time, sessions, words
  List<Map<String, dynamic>> _bookStats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = ref.read(databaseProvider);
    final allBooks = await (db.select(db.books)).get();
    final stats = <Map<String, dynamic>>[];

    for (final book in allBooks) {
      final bookStats = await db.getReadingStats(book.id);
      final totalSeconds = bookStats['totalSeconds'] ?? 0;
      stats.add({
        'book': book,
        'hours': totalSeconds / 3600,
        'minutes': totalSeconds ~/ 60,
        'sessions': bookStats['totalSessions'] ?? 0,
        'chapters': bookStats['totalChapters'] ?? 0,
        'words': bookStats['totalWordsTranslated'] ?? 0,
      });
    }

    stats.sort((a, b) => b['hours'].compareTo(a['hours']));

    setState(() {
      _bookStats = stats;
      _loading = false;
    });
  }

  void _sortStats() {
    setState(() {
      switch (_sortBy) {
        case 'time':
          _bookStats.sort((a, b) => b['hours'].compareTo(a['hours']));
          break;
        case 'sessions':
          _bookStats.sort((a, b) => b['sessions'].compareTo(a['sessions']));
          break;
        case 'words':
          _bookStats.sort((a, b) => b['words'].compareTo(a['words']));
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final maxHours = _bookStats.isNotEmpty
        ? _bookStats.map((s) => s['hours'] as double).reduce((a, b) => a > b ? a : b)
        : 1.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Perbandingan Buku'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort_rounded),
            onSelected: (value) {
              _sortBy = value;
              _sortStats();
            },
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'time', child: Text('Waktu Membaca')),
              const PopupMenuItem(value: 'sessions', child: Text('Jumlah Sesi')),
              const PopupMenuItem(value: 'words', child: Text('Kata Diterjemahkan')),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookStats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.library_books_rounded, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Belum ada buku di perpustakaan', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _bookStats.length,
                  itemBuilder: (context, index) {
                    final stat = _bookStats[index];
                    final book = stat['book'] as Book;
                    final ratio = maxHours > 0 ? (stat['hours'] / maxHours).clamp(0.0, 1.0) : 0.0;

                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
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
                                      if (book.author != null && book.author!.isNotEmpty)
                                        Text(
                                          book.author!,
                                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                    ],
                                  ),
                                ),
                                if (book.readingStatus == 'finished')
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: Colors.green.shade100,
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      'Selesai',
                                      style: TextStyle(fontSize: 10, color: Colors.green.shade700),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            // Bar chart
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: ratio,
                                minHeight: 10,
                                backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                color: _getBarColor(stat['hours'] as double),
                              ),
                            ),
                            const SizedBox(height: 12),
                            // Stats row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _statItem(Icons.access_time_rounded, '${stat['hours'].toStringAsFixed(1)}', 'jam', Colors.blue),
                                _statItem(Icons.play_circle_outline_rounded, '${stat['sessions']}', 'sesi', Colors.purple),
                                _statItem(Icons.translate_rounded, '${stat['words']}', 'kata', Colors.teal),
                                _statItem(Icons.chrome_reader_mode_rounded, '${stat['chapters']}', 'bab', Colors.orange),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 16),
        const SizedBox(height: 2),
        Text(value, style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
      ],
    );
  }

  Color _getBarColor(double hours) {
    if (hours >= 10) return Colors.green;
    if (hours >= 5) return Colors.blue;
    if (hours >= 1) return Colors.orange;
    return Colors.grey;
  }
}
