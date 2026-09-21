import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class ReadingChallengeScreen extends ConsumerStatefulWidget {
  const ReadingChallengeScreen({super.key});

  @override
  ConsumerState<ReadingChallengeScreen> createState() => _ReadingChallengeScreenState();
}

class _ReadingChallengeScreenState extends ConsumerState<ReadingChallengeScreen> {
  @override
  Widget build(BuildContext context) {
    final db = ref.watch(databaseProvider);
    final settings = ref.watch(appSettingsProvider);
    final goalMinutes = settings.dailyGoalMinutes;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tantangan Membaca'),
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _getChallengeStats(db, goalMinutes),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          final stats = snapshot.data ?? {};
          final streak = stats['streak'] ?? 0;
          final thisWeekMinutes = stats['thisWeekMinutes'] ?? 0;
          final daysCompletedThisWeek = stats['daysCompletedThisWeek'] ?? 0;
          final weeklyGoalMinutes = goalMinutes * 7;
          final weeklyProgress = weeklyGoalMinutes > 0
              ? (thisWeekMinutes / weeklyGoalMinutes).clamp(0.0, 1.0)
              : 0.0;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                // Streak card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        Icon(
                          Icons.local_fire_department_rounded,
                          size: 48,
                          color: streak > 0 ? Colors.orange : Colors.grey.shade400,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$streak',
                          style: TextStyle(
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                            color: streak > 0 ? Colors.orange : Colors.grey.shade400,
                          ),
                        ),
                        Text(
                          'Hari Berturut-turut',
                          style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Weekly progress card
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Progres Mingguan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            _weekStat(Icons.access_time_rounded, '$thisWeekMinutes', 'menit', Colors.blue),
                            _weekStat(Icons.check_circle_rounded, '$daysCompletedThisWeek', 'hari', Colors.green),
                            _weekStat(Icons.speed_rounded, '${(thisWeekMinutes / 7).toStringAsFixed(0)}', 'rata-rata', Colors.purple),
                          ],
                        ),
                        const SizedBox(height: 16),
                        LinearProgressIndicator(
                          value: weeklyProgress,
                          minHeight: 10,
                          borderRadius: BorderRadius.circular(5),
                          backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                          color: weeklyProgress >= 1.0 ? Colors.green : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '$thisWeekMinutes / $weeklyGoalMinutes menit minggu ini',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Week day dots
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('7 Hari Terakhir', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                        const SizedBox(height: 16),
                        FutureBuilder<Map<DateTime, int>>(
                          future: _getWeekDailyMinutes(db),
                          builder: (context, weekSnapshot) {
                            final dailyMinutes = weekSnapshot.data ?? {};
                            final today = DateTime.now();
                            final dayNames = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];

                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: List.generate(7, (i) {
                                final date = today.subtract(Duration(days: 6 - i));
                                final dateKey = DateTime(date.year, date.month, date.day);
                                final minutes = dailyMinutes[dateKey] ?? 0;
                                final goalMet = minutes >= goalMinutes;
                                final hasRead = minutes > 0;

                                Color bgColor;
                                if (goalMet) {
                                  bgColor = Colors.green;
                                } else if (hasRead) {
                                  bgColor = Colors.blue.shade300;
                                } else {
                                  bgColor = Colors.grey.shade200;
                                }

                                return Column(
                                  children: [
                                    Text(
                                      dayNames[(date.weekday - 1) % 7],
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                    ),
                                    const SizedBox(height: 6),
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: hasRead
                                            ? Text(
                                                '${minutes}m',
                                                style: TextStyle(
                                                  fontSize: 10,
                                                  color: goalMet || hasRead ? Colors.white : Colors.grey.shade600,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              )
                                            : Icon(Icons.close_rounded, size: 14, color: Colors.grey.shade400),
                                      ),
                                    ),
                                  ],
                                );
                              }),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // Motivational message
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      children: [
                        Icon(Icons.emoji_events_rounded, color: Colors.amber, size: 28),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            _getMotivationalMessage(streak, daysCompletedThisWeek),
                            style: const TextStyle(fontSize: 13),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _weekStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  String _getMotivationalMessage(int streak, int weekDays) {
    if (streak >= 30) return 'Luar biasa! Anda adalah pembaca sejati! 30+ hari berturut-turut!';
    if (streak >= 14) return 'Hebat! Dua minggu berturut-turut! Teruskan semangat membaca!';
    if (streak >= 7) return 'Satu minggu penuh! Konsistensi adalah kunci!';

    if (weekDays >= 5) return 'Minggu yang produktif! 5 hari membaca dalam seminggu.';
    if (weekDays >= 3) return 'Bagus! Anda sudah membaca 3 hari minggu ini.';
    if (weekDays >= 1) return 'Mulai yang baik! Pertahankan kebiasaan membaca.';
    return 'Ayo mulai membaca hari ini! Setiap halaman adalah kemajuan.';
  }

  Future<Map<String, dynamic>> _getChallengeStats(AppDatabase db, int goalMinutes) async {
    final streak = await db.getReadingStreak();
    final now = DateTime.now();

    // Calculate this week's stats (Monday to Sunday)
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final weekStartDay = DateTime(weekStart.year, weekStart.month, weekStart.day);

    final sessions = await db.getAllReadingSessions(); // 0 = all books
    int thisWeekMinutes = 0;
    int daysCompletedThisWeek = 0;
    final Set<String> completedDays = {};

    for (final session in sessions) {
      if (session.startedAt.isBefore(weekStartDay)) continue;
      final minutes = session.durationSeconds ~/ 60;
      thisWeekMinutes += minutes;
      final dayKey = '${session.startedAt.year}-${session.startedAt.month}-${session.startedAt.day}';
      if (minutes >= goalMinutes) {
        completedDays.add(dayKey);
      }
    }
    daysCompletedThisWeek = completedDays.length;

    return {
      'streak': streak,
      'thisWeekMinutes': thisWeekMinutes,
      'daysCompletedThisWeek': daysCompletedThisWeek,
    };
  }

  Future<Map<DateTime, int>> _getWeekDailyMinutes(AppDatabase db) async {
    final sessions = await db.getAllReadingSessions();
    final today = DateTime.now();
    final weekAgo = today.subtract(const Duration(days: 6));

    final Map<DateTime, int> dailyMinutes = {};
    for (final session in sessions) {
      if (session.startedAt.isBefore(DateTime(weekAgo.year, weekAgo.month, weekAgo.day))) continue;
      final date = DateTime(session.startedAt.year, session.startedAt.month, session.startedAt.day);
      final minutes = session.durationSeconds ~/ 60;
      dailyMinutes[date] = (dailyMinutes[date] ?? 0) + minutes;
    }
    return dailyMinutes;
  }
}
