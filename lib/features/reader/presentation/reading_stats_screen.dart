import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/providers.dart';
import '../../../l10n/app_localizations.dart';
import 'session_history_screen.dart';

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
        title: Text(AppLocalizations.of(context)!.statistics),
        actions: [
          // Export button
          IconButton(
            icon: const Icon(Icons.ios_share_rounded, size: 20),
            tooltip: AppLocalizations.of(context)!.exportStats,
            onPressed: () => _exportStats(context, ref),
          ),
          // Session history button
          IconButton(
            icon: const Icon(Icons.history_rounded, size: 20),
            tooltip: 'Riwayat Sesi',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => SessionHistoryScreen(
                    bookId: bookId,
                    bookTitle: bookTitle,
                  ),
                ),
              );
            },
          ),
        ],
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
                  Expanded(child: _buildStatCard(context, Icons.access_time_rounded, AppLocalizations.of(context)!.totalTime, timeStr, Colors.blue)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, Icons.chrome_reader_mode_rounded, AppLocalizations.of(context)!.chaptersRead, '$totalChapters', Colors.green)),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(child: _buildStatCard(context, Icons.translate_rounded, AppLocalizations.of(context)!.wordsTranslated, '$totalWords', Colors.orange)),
                  const SizedBox(width: 12),
                  Expanded(child: _buildStatCard(context, Icons.fiber_manual_record_rounded, AppLocalizations.of(context)!.totalSessions, '$totalSessions', Colors.purple)),
                ],
              ),
              const SizedBox(height: 24),

              // Reading speed (WPM)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.speed_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 6),
                          Text('Kecepatan Membaca', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      FutureBuilder<double>(
                        future: db.getAverageWpm(bookId),
                        builder: (context, snapshot) {
                          final wpm = snapshot.data ?? 0;
                          return Text(
                            '${wpm.toStringAsFixed(0)} kata/menit',
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
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
                        Text(AppLocalizations.of(context)!.avgPerSession, style: TextStyle(fontWeight: FontWeight.bold)),
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

              const SizedBox(height: 16),

              // Export options
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(AppLocalizations.of(context)!.exportStats, style: TextStyle(fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _exportAsCSV(context, ref),
                              icon: const Icon(Icons.table_chart_rounded, size: 16),
                              label: const Text('CSV'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => _exportAsJSON(context, ref),
                              icon: const Icon(Icons.code_rounded, size: 16),
                              label: const Text('JSON'),
                            ),
                          ),
                        ],
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

  Future<void> _exportStats(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final sessions = await db.getReadingSessions(bookId);

    final rows = <List<String>>[
      ['Tanggal', 'Durasi (detik)', 'Bab Dibaca', 'Kata Diterjemahkan'],
      for (final s in sessions)
        [
          s.startedAt.toIso8601String(),
          '${s.durationSeconds}',
          '${s.chaptersRead}',
          '${s.wordsTranslated}',
        ],
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final jsonStr = jsonEncode({
      'book': bookTitle,
      'bookId': bookId,
      'exportedAt': DateTime.now().toIso8601String(),
      'sessions': sessions
          .map((s) => {
                'startedAt': s.startedAt.toIso8601String(),
                'endedAt': s.endedAt?.toIso8601String(),
                'durationSeconds': s.durationSeconds,
                'chaptersRead': s.chaptersRead,
                'wordsTranslated': s.wordsTranslated,
              })
          .toList(),
    });

    final dir = await getApplicationDocumentsDirectory();
    final csvFile = File('${dir.path}/stats_${bookId}.csv');
    final jsonFile = File('${dir.path}/stats_${bookId}.json');
    await csvFile.writeAsString(csv);
    await jsonFile.writeAsString(jsonStr);

    if (context.mounted) {
      await Share.shareXFiles(
        [XFile(csvFile.path), XFile(jsonFile.path)],
        text: 'Statistik membaca: $bookTitle',
      );
    }
  }

  Future<void> _exportAsCSV(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final sessions = await db.getReadingSessions(bookId);

    final rows = <List<String>>[
      ['Tanggal', 'Durasi (detik)', 'Bab Dibaca', 'Kata Diterjemahkan'],
      for (final s in sessions)
        [
          s.startedAt.toIso8601String(),
          '${s.durationSeconds}',
          '${s.chaptersRead}',
          '${s.wordsTranslated}',
        ],
    ];

    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/stats_${bookId}.csv');
    await file.writeAsString(csv);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('CSV tersimpan: ${file.path}')),
      );
    }
  }

  Future<void> _exportAsJSON(BuildContext context, WidgetRef ref) async {
    final db = ref.read(databaseProvider);
    final sessions = await db.getReadingSessions(bookId);

    final jsonStr = jsonEncode({
      'book': bookTitle,
      'bookId': bookId,
      'exportedAt': DateTime.now().toIso8601String(),
      'sessions': sessions
          .map((s) => {
                'startedAt': s.startedAt.toIso8601String(),
                'endedAt': s.endedAt?.toIso8601String(),
                'durationSeconds': s.durationSeconds,
                'chaptersRead': s.chaptersRead,
                'wordsTranslated': s.wordsTranslated,
              })
          .toList(),
    });

    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/stats_${bookId}.json');
    await file.writeAsString(jsonStr);

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('JSON tersimpan: ${file.path}')),
      );
    }
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
