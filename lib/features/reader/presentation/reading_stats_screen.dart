import 'dart:convert';
import 'dart:io';

import 'package:csv/csv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';
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

              // Per-book daily goal
              _PerBookGoalCard(bookId: bookId, db: db),

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

class _PerBookGoalCard extends StatefulWidget {
  final int bookId;
  final AppDatabase db;

  const _PerBookGoalCard({required this.bookId, required this.db});

  @override
  State<_PerBookGoalCard> createState() => _PerBookGoalCardState();
}

class _PerBookGoalCardState extends State<_PerBookGoalCard> {
  int _goalMinutes = 0;
  int _todayMinutes = 0;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final setting = await widget.db.getBookSetting(widget.bookId);
    final goal = setting?.dailyGoalMinutes ?? 0;

    final sessions = await widget.db.getReadingSessions(widget.bookId);
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    int todayMin = 0;
    for (final s in sessions) {
      if (s.startedAt.isAfter(todayStart)) {
        todayMin += s.durationSeconds ~/ 60;
      }
    }

    setState(() {
      _goalMinutes = goal;
      _todayMinutes = todayMin;
    });
  }

  @override
  Widget build(BuildContext context) {
    final progress = _goalMinutes > 0 ? (_todayMinutes / _goalMinutes).clamp(0.0, 1.0) : 0.0;
    final goalMet = _goalMinutes > 0 && _todayMinutes >= _goalMinutes;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  goalMet ? Icons.check_circle_rounded : Icons.track_changes_rounded,
                  size: 16,
                  color: goalMet ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(width: 6),
                Text('Target Harian Buku Ini', style: TextStyle(fontWeight: FontWeight.bold)),
                const Spacer(),
                if (_goalMinutes > 0)
                  IconButton(
                    icon: const Icon(Icons.edit_rounded, size: 16),
                    onPressed: _editGoal,
                    visualDensity: VisualDensity.compact,
                    tooltip: 'Ubah Target',
                  ),
              ],
            ),
            const SizedBox(height: 8),
            if (_goalMinutes == 0)
              TextButton.icon(
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Atas Target Membaca', style: TextStyle(fontSize: 13)),
                onPressed: _editGoal,
              )
            else ...[
              Row(
                children: [
                  Text(
                    '$_todayMinutes / $_goalMinutes menit hari ini',
                    style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
                  ),
                  const Spacer(),
                  if (goalMet)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                      child: Text('Tercapai!', style: TextStyle(fontSize: 11, color: Colors.green.shade700)),
                    )
                  else
                    Text(
                      '${((1 - progress) * _goalMinutes).round()} menit lagi',
                      style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
                    ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 8,
                  backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                  color: goalMet ? Colors.green : Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  void _editGoal() async {
    final controller = TextEditingController(text: _goalMinutes > 0 ? '$_goalMinutes' : '');
    final result = await showDialog<int>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Target Membaca Harian'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Target menit membaca per hari untuk buku ini', style: TextStyle(fontSize: 13, color: Colors.grey.shade600)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Menit',
                suffixText: 'menit/hari',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              children: [15, 30, 45, 60, 90, 120].map((m) => ActionChip(
                label: Text('${m}m'),
                onPressed: () {
                  controller.text = '$m';
                },
              )).toList(),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              final val = int.tryParse(controller.text);
              Navigator.pop(ctx, val);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );

    if (result != null) {
      await widget.db.upsertBookSetting(bookId: widget.bookId, dailyGoalMinutes: result);
      _load();
    }
  }
}
