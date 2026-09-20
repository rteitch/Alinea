import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class ReadingStatsScreen extends ConsumerWidget {
  final int bookId;
  final String bookTitle;

  const ReadingStatsScreen({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Statistik Membaca'),
      ),
      body: FutureBuilder<Map<String, int>>(
        future: db.getReadingStats(bookId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};
          final totalSeconds = stats['totalSeconds'] ?? 0;
          final totalSessions = stats['totalSessions'] ?? 0;
          final totalChapters = stats['totalChapters'] ?? 0;
          final totalWords = stats['totalWordsTranslated'] ?? 0;

          final hours = totalSeconds ~/ 3600;
          final minutes = (totalSeconds % 3600) ~/ 60;
          final timeStr = hours > 0 ? '${hours}j ${minutes}m' : '$minutes menit';

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // Book info
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Icon(Icons.book_rounded, size: 40, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              bookTitle,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '$totalSessions sesi membaca',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Stats grid
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, Icons.access_time_rounded, 'Waktu Total', timeStr, Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, Icons.chrome_reader_mode_rounded, 'Bab Dibaca', '$totalChapters', Colors.green)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, Icons.translate_rounded, 'Kata Diterjemahkan', '$totalWords', Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, Icons.fiber_manual_record_rounded, 'Sesi Membaca', '$totalSessions', Colors.purple)),
                ],
              ),
              const SizedBox(height: 24),

              // Average session time
              if (totalSessions > 0)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Rata-rata per Sesi', style: TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 8),
                        Text(
                          '${(totalSeconds / totalSessions / 60).round()} menit',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, IconData icon, String label, String value, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
