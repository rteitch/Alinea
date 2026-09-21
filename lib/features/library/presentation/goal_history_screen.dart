import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:drift/drift.dart' show OrderingTerm;
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class GoalHistoryScreen extends ConsumerStatefulWidget {
  const GoalHistoryScreen({super.key});

  @override
  ConsumerState<GoalHistoryScreen> createState() => _GoalHistoryScreenState();
}

class _GoalHistoryScreenState extends ConsumerState<GoalHistoryScreen> {
  DateTime _selectedMonth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final settings = ref.watch(appSettingsProvider);
    final goalMinutes = settings.dailyGoalMinutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Target Harian'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: () {
              setState(() {
                _selectedMonth = DateTime(_selectedMonth.year, _selectedMonth.month - 1);
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Center(
              child: Text(
                '${_monthName(_selectedMonth.month)} ${_selectedMonth.year}',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: () {
              final now = DateTime.now();
              final nextMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1);
              if (nextMonth.isBefore(DateTime(now.year, now.month + 1))) {
                setState(() {
                  _selectedMonth = nextMonth;
                });
              }
            },
          ),
        ],
      ),
      body: FutureBuilder<Map<DateTime, int>>(
        future: _getDailyMinutes(db),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final dailyMinutes = snapshot.data ?? {};
          final daysInMonth = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0).day;
          final today = DateTime.now();

          // Calculate stats for this month
          int daysCompleted = 0;
          int totalMinutesRead = 0;
          for (int day = 1; day <= daysInMonth; day++) {
            final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
            if (date.isAfter(today)) break;
            final minutes = dailyMinutes[date] ?? 0;
            totalMinutesRead += minutes;
            if (minutes >= goalMinutes) daysCompleted++;
          }

          return Column(
            children: [
              // Month summary
              Card(
                margin: const EdgeInsets.all(16),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _summaryItem(context, Icons.check_circle_rounded, '$daysCompleted', 'Hari Capai Target', Colors.green),
                      _summaryItem(context, Icons.access_time_rounded, '$totalMinutesRead', 'Total Menit', Colors.blue),
                      _summaryItem(context, Icons.local_fire_department_rounded, '${(totalMinutesRead / 60).toStringAsFixed(1)}j', 'Total Jam', Colors.orange),
                    ],
                  ),
                ),
              ),

              // Calendar grid
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: ['S', 'S', 'R', 'K', 'J', 'S', 'M'].map((d) {
                    return Expanded(
                      child: Center(
                        child: Text(d, style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600)),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 8),

              // Day grid
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 7,
                      mainAxisSpacing: 4,
                      crossAxisSpacing: 4,
                    ),
                    itemCount: _getFirstDayOffset(_selectedMonth) + daysInMonth,
                    itemBuilder: (context, index) {
                      if (index < _getFirstDayOffset(_selectedMonth)) {
                        return const SizedBox.shrink();
                      }
                      final day = index - _getFirstDayOffset(_selectedMonth) + 1;
                      final date = DateTime(_selectedMonth.year, _selectedMonth.month, day);
                      final isFuture = date.isAfter(today);
                      final minutes = dailyMinutes[date] ?? 0;
                      final goalReached = minutes >= goalMinutes;
                      final isToday = date.year == today.year && date.month == today.month && date.day == today.day;

                      Color bgColor;
                      Color textColor;
                      if (isFuture) {
                        bgColor = Colors.grey.shade100;
                        textColor = Colors.grey.shade400;
                      } else if (goalReached) {
                        bgColor = Colors.green.shade100;
                        textColor = Colors.green.shade800;
                      } else if (minutes > 0) {
                        bgColor = Colors.blue.shade50;
                        textColor = Colors.blue.shade700;
                      } else {
                        bgColor = Colors.grey.shade50;
                        textColor = Colors.grey.shade600;
                      }

                      return Container(
                        decoration: BoxDecoration(
                          color: bgColor,
                          borderRadius: BorderRadius.circular(8),
                          border: isToday ? Border.all(color: Theme.of(context).colorScheme.primary, width: 2) : null,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text('$day', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: textColor)),
                            if (minutes > 0 && !isFuture)
                              Text(
                                '${minutes}m',
                                style: TextStyle(fontSize: 9, color: textColor.withAlpha(180)),
                              ),
                            if (goalReached && !isFuture)
                              Icon(Icons.check_rounded, size: 10, color: Colors.green.shade700),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Legend
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _legendItem(Colors.green.shade100, 'Target tercapai'),
                    const SizedBox(width: 16),
                    _legendItem(Colors.blue.shade50, 'Membaca < target'),
                    const SizedBox(width: 16),
                    _legendItem(Colors.grey.shade100, 'Tidak membaca'),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _summaryItem(BuildContext context, IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _legendItem(Color color, String label) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
        ),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 11)),
      ],
    );
  }

  Future<Map<DateTime, int>> _getDailyMinutes(AppDatabase db) async {
    // Load all sessions and filter in Dart (avoids Drift column type issues)
    final allSessions = await (db.select(db.readingSessions)
          ..orderBy([(t) => OrderingTerm.desc(t.startedAt)]))
        .get();

    final firstDay = DateTime(_selectedMonth.year, _selectedMonth.month, 1);
    final lastDay = DateTime(_selectedMonth.year, _selectedMonth.month + 1, 0, 23, 59, 59);

    final Map<DateTime, int> dailyMinutes = {};
    for (final session in allSessions) {
      if (session.startedAt.isBefore(firstDay) || session.startedAt.isAfter(lastDay)) continue;
      final date = DateTime(session.startedAt.year, session.startedAt.month, session.startedAt.day);
      final minutes = session.durationSeconds ~/ 60;
      dailyMinutes[date] = (dailyMinutes[date] ?? 0) + minutes;
    }
    return dailyMinutes;
  }

  int _getFirstDayOffset(DateTime month) {
    final firstDay = DateTime(month.year, month.month, 1);
    // Monday = 0, Sunday = 6
    return (firstDay.weekday - 1) % 7;
  }

  String _monthName(int month) {
    const names = ['', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni', 'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'];
    return names[month];
  }
}
