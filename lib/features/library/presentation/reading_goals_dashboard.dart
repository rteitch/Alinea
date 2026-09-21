import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class ReadingGoalsDashboard extends ConsumerStatefulWidget {
  const ReadingGoalsDashboard({super.key});

  @override
  ConsumerState<ReadingGoalsDashboard> createState() => _ReadingGoalsDashboardState();
}

class _ReadingGoalsDashboardState extends ConsumerState<ReadingGoalsDashboard> {
  bool _loading = true;
  int _globalGoalMinutes = 0;
  int _todayTotalMinutes = 0;
  List<Map<String, dynamic>> _bookGoals = [];

  @override
  void initState() {
    super.initState();
    _loadGoals();
  }

  Future<void> _loadGoals() async {
    final db = ref.read(databaseProvider);
    final settings = ref.read(appSettingsProvider);
    final globalGoal = settings.dailyGoalMinutes;

    // Get all sessions today across all books
    final allSessions = await db.getAllReadingSessions();
    final now = DateTime.now();
    final todayStart = DateTime(now.year, now.month, now.day);

    int todayTotal = 0;
    for (final s in allSessions) {
      if (s.startedAt.isAfter(todayStart)) {
        todayTotal += s.durationSeconds ~/ 60;
      }
    }

    // Get per-book goals
    final allBooks = await (db.select(db.books)).get();
    final bookGoals = <Map<String, dynamic>>[];

    for (final book in allBooks) {
      if (book.readingStatus == 'archived') continue;
      final setting = await db.getBookSetting(book.id);
      final bookGoal = setting?.dailyGoalMinutes ?? 0;
      if (bookGoal <= 0) continue;

      int bookTodayMinutes = 0;
      for (final s in allSessions) {
        if (s.bookId == book.id && s.startedAt.isAfter(todayStart)) {
          bookTodayMinutes += s.durationSeconds ~/ 60;
        }
      }

      bookGoals.add({
        'book': book,
        'goal': bookGoal,
        'current': bookTodayMinutes,
        'progress': bookGoal > 0 ? (bookTodayMinutes / bookGoal).clamp(0.0, 1.0) : 0.0,
      });
    }

    setState(() {
      _globalGoalMinutes = globalGoal;
      _todayTotalMinutes = todayTotal;
      _bookGoals = bookGoals;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final globalProgress = _globalGoalMinutes > 0
        ? (_todayTotalMinutes / _globalGoalMinutes).clamp(0.0, 1.0)
        : 0.0;
    final globalMet = _globalGoalMinutes > 0 && _todayTotalMinutes >= _globalGoalMinutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Target Membaca'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Global goal ring
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        children: [
                          const Text('Target Harian Global', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: 160,
                            height: 160,
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Background ring
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircularProgressIndicator(
                                    value: 1.0,
                                    strokeWidth: 12,
                                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                                  ),
                                ),
                                // Progress ring
                                SizedBox(
                                  width: 160,
                                  height: 160,
                                  child: CircularProgressIndicator(
                                    value: globalProgress,
                                    strokeWidth: 12,
                                    color: globalMet ? Colors.green : Theme.of(context).colorScheme.primary,
                                    strokeCap: StrokeCap.round,
                                  ),
                                ),
                                Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      globalMet ? Icons.check_circle_rounded : Icons.track_changes_rounded,
                                      color: globalMet ? Colors.green : Theme.of(context).colorScheme.primary,
                                      size: 28,
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      '$_todayTotalMinutes',
                                      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                    ),
                                    Text(
                                      '/ $_globalGoalMinutes m',
                                      style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          if (_globalGoalMinutes == 0)
                            Text(
                              'Atas target di Pengaturan',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            )
                          else if (globalMet)
                            Text(
                              'Tercapai! ${_todayTotalMinutes - _globalGoalMinutes} menit bonus',
                              style: const TextStyle(fontSize: 13, color: Colors.green, fontWeight: FontWeight.w600),
                            )
                          else
                            Text(
                              '${_globalGoalMinutes - _todayTotalMinutes} menit lagi untuk mencapai target',
                              style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                            ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Per-book goals
                  if (_bookGoals.isNotEmpty) ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.menu_book_rounded, size: 18),
                                const SizedBox(width: 8),
                                Text(
                                  'Target per Buku (${_bookGoals.length})',
                                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            ..._bookGoals.map((item) => _buildBookGoalTile(item)),
                          ],
                        ),
                      ),
                    ),
                  ] else ...[
                    Card(
                      child: Padding(
                        padding: const EdgeInsets.all(24),
                        child: Column(
                          children: [
                            Icon(Icons.track_changes_rounded, size: 48, color: Colors.grey.shade300),
                            const SizedBox(height: 12),
                            Text('Belum ada target per buku', style: TextStyle(color: Colors.grey.shade600)),
                            const SizedBox(height: 4),
                            Text(
                              'Atas target di halaman statistik buku',
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
    );
  }

  Widget _buildBookGoalTile(Map<String, dynamic> item) {
    final book = item['book'] as Book;
    final goal = item['goal'] as int;
    final current = item['current'] as int;
    final progress = item['progress'] as double;
    final met = current >= goal;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  book.title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Text(
                '$current / $goal m',
                style: TextStyle(
                  fontSize: 12,
                  color: met ? Colors.green : Colors.grey.shade600,
                  fontWeight: FontWeight.w600,
                ),
              ),
              if (met) ...[
                const SizedBox(width: 4),
                Icon(Icons.check_circle_rounded, size: 14, color: Colors.green),
              ],
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
              color: met ? Colors.green : Theme.of(context).colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }
}
