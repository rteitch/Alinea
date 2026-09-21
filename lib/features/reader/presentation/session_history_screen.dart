import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class SessionHistoryScreen extends ConsumerWidget {
  final int bookId;
  final String bookTitle;

  const SessionHistoryScreen({
    super.key,
    required this.bookId,
    required this.bookTitle,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text('Riwayat Sesi — $bookTitle'),
      ),
      body: FutureBuilder<List<ReadingSession>>(
        future: (db.select(db.readingSessions)
              ..where((t) => t.bookId.equals(bookId))
              ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final sessions = snapshot.data ?? [];

          if (sessions.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.history_rounded, size: 64, color: Colors.grey.shade300),
                  const SizedBox(height: 12),
                  Text('Belum ada riwayat sesi.', style: TextStyle(color: Colors.grey.shade600)),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: sessions.length,
            itemBuilder: (context, index) {
              final session = sessions[index];
              final duration = session.durationSeconds;
              final hours = duration ~/ 3600;
              final minutes = (duration % 3600) ~/ 60;
              final secs = duration % 60;

              String durationStr;
              if (hours > 0) {
                durationStr = '${hours}j ${minutes}m ${secs}s';
              } else if (minutes > 0) {
                durationStr = '${minutes}m ${secs}s';
              } else {
                durationStr = '${secs}s';
              }

              final dateStr = DateFormat('dd MMM yyyy, HH:mm').format(session.startedAt);
              final wpm = duration > 0 ? ((session.wordsRead / duration) * 60).toStringAsFixed(0) : '0';

              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dateStr, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: Theme.of(context).colorScheme.primaryContainer,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(durationStr, style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onPrimaryContainer)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _statChip(context, Icons.chrome_reader_mode_rounded, '${session.chaptersRead} bab', Colors.green),
                          const SizedBox(width: 8),
                          _statChip(context, Icons.translate_rounded, '${session.wordsTranslated} kata', Colors.orange),
                          const SizedBox(width: 8),
                          _statChip(context, Icons.speed_rounded, '$wpm wpm', Colors.blue),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _statChip(BuildContext context, IconData icon, String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: color.withAlpha(30),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: color),
          const SizedBox(width: 3),
          Text(text, style: TextStyle(fontSize: 11, color: color)),
        ],
      ),
    );
  }
}
