import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';
import 'goal_history_screen.dart';
import 'achievements_screen.dart';

class ReadingInsightsScreen extends ConsumerStatefulWidget {
  const ReadingInsightsScreen({super.key});

  @override
  ConsumerState<ReadingInsightsScreen> createState() => _ReadingInsightsScreenState();
}

class _ReadingInsightsScreenState extends ConsumerState<ReadingInsightsScreen> {
  bool _loading = true;
  int _totalReadingSeconds = 0;
  int _totalSessions = 0;
  int _totalWordsTranslated = 0;
  int _totalWordsRead = 0;
  int _totalBooks = 0;
  int _finishedBooks = 0;
  int _streak = 0;
  int _todayMinutes = 0;
  int _thisWeekMinutes = 0;
  double _avgWpm = 0;
  int _totalHighlights = 0;
  int _totalBookmarks = 0;
  int _totalGlossaryTerms = 0;
  List<Map<String, dynamic>> _recentSessions = [];

  @override
  void initState() {
    super.initState();
    _loadInsights();
  }

  Future<void> _loadInsights() async {
    final db = ref.read(databaseProvider);

    final allSessions = await db.getAllReadingSessions();
    final allBooks = await (db.select(db.books)).get();
    final allHighlights = await (db.select(db.highlights)).get();
    final allBookmarks = await (db.select(db.bookmarks)).get();
    final allGlossary = await (db.select(db.glossaryTerms)).get();
    final streak = await db.getReadingStreak();

    int totalSeconds = 0;
    int totalWords = 0;
    int totalWordsRead = 0;
    int todayMin = 0;
    int weekMin = 0;
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);
    final weekStart = todayStart.subtract(Duration(days: todayStart.weekday - 1));

    for (final s in allSessions) {
      totalSeconds += s.durationSeconds;
      totalWords += s.wordsTranslated;
      totalWordsRead += s.wordsRead;
      if (s.startedAt.isAfter(todayStart)) {
        todayMin += s.durationSeconds ~/ 60;
      }
      if (s.startedAt.isAfter(weekStart)) {
        weekMin += s.durationSeconds ~/ 60;
      }
    }

    // Average WPM from sessions with wordsRead > 0
    final wpmSessions = allSessions.where((s) => s.durationSeconds > 0 && s.wordsRead > 0).toList();
    double avgWpm = 0;
    if (wpmSessions.isNotEmpty) {
      int totalWpmWords = 0;
      int totalWpmSeconds = 0;
      for (final s in wpmSessions) {
        totalWpmWords += s.wordsRead;
        totalWpmSeconds += s.durationSeconds;
      }
      if (totalWpmSeconds > 0) {
        avgWpm = totalWpmWords / (totalWpmSeconds / 60);
      }
    }

    final finishedBooks = allBooks.where((b) => b.readingStatus == 'finished').length;

    // Recent sessions (last 5)
    final recentSessions = allSessions.take(5).map((s) {
      final book = allBooks.where((b) => b.id == s.bookId).firstOrNull;
      return {
        'session': s,
        'bookTitle': book?.title ?? 'Unknown',
      };
    }).toList();

    setState(() {
      _totalReadingSeconds = totalSeconds;
      _totalSessions = allSessions.length;
      _totalWordsTranslated = totalWords;
      _totalWordsRead = totalWordsRead;
      _totalBooks = allBooks.length;
      _finishedBooks = finishedBooks;
      _streak = streak;
      _todayMinutes = todayMin;
      _thisWeekMinutes = weekMin;
      _avgWpm = avgWpm;
      _totalHighlights = allHighlights.length;
      _totalBookmarks = allBookmarks.length;
      _totalGlossaryTerms = allGlossary.length;
      _recentSessions = recentSessions;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final hours = _totalReadingSeconds ~/ 3600;
    final minutes = (_totalReadingSeconds % 3600) ~/ 60;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ringkasan Membaca'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : RefreshIndicator(
              onRefresh: _loadInsights,
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Today's summary card
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _heroStat(Icons.local_fire_department_rounded, '$_streak', 'Hari', Colors.orange),
                              _heroStat(Icons.today_rounded, '$_todayMinutes', 'Menit Hari Ini', Colors.blue),
                              _heroStat(Icons.speed_rounded, _avgWpm.toStringAsFixed(0), 'WPM', Colors.purple),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Weekly goal
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Progres Minggu Ini', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('$_thisWeekMinutes menit', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                                    Text('Total minggu ini', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                              ),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: _streak > 0 ? Colors.green.shade50 : Colors.grey.shade100,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: Text(
                                  _streak > 0 ? '$_streak hari streak!' : 'Mulai streak hari ini',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: _streak > 0 ? Colors.green.shade700 : Colors.grey.shade600,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Stats grid
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Statistik Total', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Expanded(child: _statTile(Icons.access_time_rounded, '${hours}j ${minutes}m', 'Waktu', Colors.blue)),
                              Expanded(child: _statTile(Icons.play_circle_outline_rounded, '$_totalSessions', 'Sesi', Colors.purple)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _statTile(Icons.menu_book_rounded, '$_finishedBooks/$_totalBooks', 'Buku Selesai', Colors.green)),
                              Expanded(child: _statTile(Icons.translate_rounded, '$_totalWordsTranslated', 'Kata', Colors.orange)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _statTile(Icons.highlight_rounded, '$_totalHighlights', 'Highlight', Colors.teal)),
                              Expanded(child: _statTile(Icons.bookmark_rounded, '$_totalBookmarks', 'Bookmark', Colors.indigo)),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              Expanded(child: _statTile(Icons.school_rounded, '$_totalGlossaryTerms', 'Kosakata', Colors.amber)),
                              Expanded(child: _statTile(Icons.chrome_reader_mode_rounded, '$_totalWordsRead', 'Kata Dibaca', Colors.brown)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Recent activity
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Aktivitas Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 8),
                          if (_recentSessions.isEmpty)
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: Center(
                                child: Text('Belum ada aktivitas', style: TextStyle(color: Colors.grey.shade500)),
                              ),
                            )
                          else
                            ..._recentSessions.map((item) {
                              final s = item['session'] as ReadingSession;
                              final bookTitle = item['bookTitle'] as String;
                              final dur = s.durationSeconds ~/ 60;
                              return Padding(
                                padding: const EdgeInsets.symmetric(vertical: 4),
                                child: Row(
                                  children: [
                                    Icon(Icons.play_circle_outline_rounded, size: 16, color: Colors.grey.shade400),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(bookTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                                          Text(_formatDate(s.startedAt), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                                        ],
                                      ),
                                    ),
                                    Text('$dur menit', style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                                  ],
                                ),
                              );
                            }),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Quick links
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.emoji_events_rounded),
                          title: const Text('Pencapaian'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AchievementsScreen())),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.local_fire_department_rounded),
                          title: const Text('Riwayat Target'),
                          trailing: const Icon(Icons.chevron_right_rounded),
                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const GoalHistoryScreen())),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _heroStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 6),
        Text(value, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _statTile(IconData icon, String value, String label, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 18),
          const SizedBox(height: 4),
          Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: Colors.grey.shade600)),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m lalu';
    if (diff.inHours < 24) return '${diff.inHours}j lalu';
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}';
  }
}
