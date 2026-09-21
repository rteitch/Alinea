import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class Achievement {
  final String id;
  final String title;
  final String description;
  final IconData icon;
  final bool unlocked;
  final double progress;
  final String? unlockedDate;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.unlocked,
    this.progress = 1.0,
    this.unlockedDate,
  });
}

class AchievementsScreen extends ConsumerStatefulWidget {
  const AchievementsScreen({super.key});

  @override
  ConsumerState<AchievementsScreen> createState() => _AchievementsScreenState();
}

class _AchievementsScreenState extends ConsumerState<AchievementsScreen> {
  List<Achievement> _achievements = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadAchievements();
  }

  Future<void> _loadAchievements() async {
    final db = ref.read(databaseProvider);

    final allSessions = await db.getAllReadingSessions();
    final allBooks = await (db.select(db.books)).get();
    final allHighlights = await (db.select(db.highlights)).get();
    final allBookmarks = await (db.select(db.bookmarks)).get();
    final streak = await db.getReadingStreak();

    final totalSeconds = allSessions.fold<int>(0, (sum, s) => sum + s.durationSeconds);
    final totalMinutes = totalSeconds ~/ 60;
    final totalHours = totalSeconds ~/ 3600;
    final totalWordsTranslated = allSessions.fold<int>(0, (sum, s) => sum + s.wordsTranslated);
    final totalSessions = allSessions.length;

    // Count finished books
    final finishedBooks = allBooks.where((b) => b.readingStatus == 'finished').length;

    // Count books with highlights
    final booksWithHighlights = allHighlights.map((h) => h.bookId).toSet().length;

    // Count unique reading days
    final uniqueDays = allSessions
        .map((s) => DateTime(s.startedAt.year, s.startedAt.month, s.startedAt.day))
        .toSet()
        .length;

    final now = DateTime.now();

    final achievements = <Achievement>[
      // Reading Time milestones
      Achievement(
        id: 'first_hour',
        title: 'Pembaca Pemula',
        description: 'Membaca selama 1 jam total',
        icon: Icons.access_time_rounded,
        unlocked: totalMinutes >= 60,
        progress: (totalMinutes / 60).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'ten_hours',
        title: 'Pembaca Setia',
        description: 'Membaca selama 10 jam total',
        icon: Icons.timer_rounded,
        unlocked: totalHours >= 10,
        progress: (totalHours / 10).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'fifty_hours',
        title: 'Maraton Membaca',
        description: 'Membaca selama 50 jam total',
        icon: Icons.speed_rounded,
        unlocked: totalHours >= 50,
        progress: (totalHours / 50).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'hundred_hours',
        title: 'Legenda Membaca',
        description: 'Membaca selama 100 jam total',
        icon: Icons.emoji_events_rounded,
        unlocked: totalHours >= 100,
        progress: (totalHours / 100).clamp(0.0, 1.0),
      ),

      // Streak milestones
      Achievement(
        id: 'streak_3',
        title: 'Konsisten 3 Hari',
        description: 'Membaca 3 hari berturut-turut',
        icon: Icons.local_fire_department_rounded,
        unlocked: streak >= 3,
        progress: (streak / 3).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_7',
        title: 'Seminggu Penuh',
        description: 'Membaca 7 hari berturut-turut',
        icon: Icons.whatshot_rounded,
        unlocked: streak >= 7,
        progress: (streak / 7).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'streak_30',
        title: 'Dedikasi Sebulan',
        description: 'Membaca 30 hari berturut-turut',
        icon: Icons.workspace_premium_rounded,
        unlocked: streak >= 30,
        progress: (streak / 30).clamp(0.0, 1.0),
      ),

      // Book milestones
      Achievement(
        id: 'first_book',
        title: 'Buku Pertama',
        description: 'Menyelesaikan buku pertama',
        icon: Icons.menu_book_rounded,
        unlocked: finishedBooks >= 1,
        progress: (finishedBooks / 1).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'five_books',
        title: 'Kolektor Buku',
        description: 'Menyelesaikan 5 buku',
        icon: Icons.library_books_rounded,
        unlocked: finishedBooks >= 5,
        progress: (finishedBooks / 5).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'ten_books',
        title: 'Perpustakaan Hidup',
        description: 'Menyelesaikan 10 buku',
        icon: Icons.local_library_rounded,
        unlocked: finishedBooks >= 10,
        progress: (finishedBooks / 10).clamp(0.0, 1.0),
      ),

      // Library size
      Achievement(
        id: 'library_5',
        title: 'Koleksi Awal',
        description: 'Memiliki 5 buku di perpustakaan',
        icon: Icons.book_rounded,
        unlocked: allBooks.length >= 5,
        progress: (allBooks.length / 5).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'library_20',
        title: 'Perpustakaan Pribadi',
        description: 'Memiliki 20 buku di perpustakaan',
        icon: Icons.auto_stories_rounded,
        unlocked: allBooks.length >= 20,
        progress: (allBooks.length / 20).clamp(0.0, 1.0),
      ),

      // Sessions
      Achievement(
        id: 'sessions_10',
        title: 'Rutin Membaca',
        description: '10 sesi membaca',
        icon: Icons.play_circle_outline_rounded,
        unlocked: totalSessions >= 10,
        progress: (totalSessions / 10).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'sessions_100',
        title: 'Mesin Membaca',
        description: '100 sesi membaca',
        icon: Icons.all_inclusive_rounded,
        unlocked: totalSessions >= 100,
        progress: (totalSessions / 100).clamp(0.0, 1.0),
      ),

      // Translation
      Achievement(
        id: 'translate_100',
        title: 'Penerjemah Pemula',
        description: 'Menerjemahkan 100 kata',
        icon: Icons.translate_rounded,
        unlocked: totalWordsTranslated >= 100,
        progress: (totalWordsTranslated / 100).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'translate_1000',
        title: 'Penerjemah Ahli',
        description: 'Menerjemahkan 1000 kata',
        icon: Icons.g_translate_rounded,
        unlocked: totalWordsTranslated >= 1000,
        progress: (totalWordsTranslated / 1000).clamp(0.0, 1.0),
      ),

      // Highlights
      Achievement(
        id: 'highlight_10',
        title: 'Penanda Kutipan',
        description: 'Membuat 10 highlight',
        icon: Icons.highlight_rounded,
        unlocked: allHighlights.length >= 10,
        progress: (allHighlights.length / 10).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'highlight_50',
        title: 'Kolektor Kutipan',
        description: 'Membuat 50 highlight',
        icon: Icons.palette_rounded,
        unlocked: allHighlights.length >= 50,
        progress: (allHighlights.length / 50).clamp(0.0, 1.0),
      ),

      // Bookmarks
      Achievement(
        id: 'bookmark_10',
        title: 'Penanda Halaman',
        description: 'Membuat 10 bookmark',
        icon: Icons.bookmark_rounded,
        unlocked: allBookmarks.length >= 10,
        progress: (allBookmarks.length / 10).clamp(0.0, 1.0),
      ),

      // Diversity
      Achievement(
        id: 'diverse_3',
        title: 'Pembaca Multitopic',
        description: 'Membuat highlight di 3 buku berbeda',
        icon: Icons.category_rounded,
        unlocked: booksWithHighlights >= 3,
        progress: (booksWithHighlights / 3).clamp(0.0, 1.0),
      ),

      // Day count
      Achievement(
        id: 'days_30',
        title: 'Sebulan Membaca',
        description: 'Membaca di 30 hari berbeda',
        icon: Icons.calendar_month_rounded,
        unlocked: uniqueDays >= 30,
        progress: (uniqueDays / 30).clamp(0.0, 1.0),
      ),
      Achievement(
        id: 'days_100',
        title: 'Seratus Hari',
        description: 'Membaca di 100 hari berbeda',
        icon: Icons.date_range_rounded,
        unlocked: uniqueDays >= 100,
        progress: (uniqueDays / 100).clamp(0.0, 1.0),
      ),
    ];

    setState(() {
      _achievements = achievements;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final unlockedCount = _achievements.where((a) => a.unlocked).length;
    final totalCount = _achievements.length;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Pencapaian'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        unlockedCount == totalCount ? Icons.emoji_events : Icons.emoji_events_outlined,
                        size: 48,
                        color: unlockedCount == totalCount ? Colors.amber : Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        '$unlockedCount / $totalCount',
                        style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Pencapaian Terbuka',
                        style: TextStyle(color: Colors.grey.shade600),
                      ),
                      const SizedBox(height: 12),
                      LinearProgressIndicator(
                        value: totalCount > 0 ? unlockedCount / totalCount : 0,
                        minHeight: 8,
                        borderRadius: BorderRadius.circular(4),
                        backgroundColor: theme.colorScheme.surfaceContainerHighest,
                        color: Colors.amber,
                      ),
                    ],
                  ),
                ),
                const Divider(height: 1),
                // Achievement list
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    itemCount: _achievements.length,
                    itemBuilder: (context, index) {
                      final a = _achievements[index];
                      return _buildAchievementTile(a);
                    },
                  ),
                ),
              ],
            ),
    );
  }

  Widget _buildAchievementTile(Achievement a) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: Opacity(
        opacity: a.unlocked ? 1.0 : 0.5,
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: a.unlocked ? Colors.amber.shade100 : Colors.grey.shade200,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    a.icon,
                    color: a.unlocked ? Colors.amber.shade700 : Colors.grey,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        a.title,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: a.unlocked ? null : Colors.grey,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        a.description,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      if (!a.unlocked) ...[
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: a.progress,
                                  minHeight: 6,
                                  backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  color: Colors.amber,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '${(a.progress * 100).toInt()}%',
                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
                if (a.unlocked)
                  Icon(Icons.check_circle_rounded, color: Colors.green, size: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
