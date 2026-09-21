import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class ReadingGoalCard extends ConsumerWidget {
  const ReadingGoalCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final db = ref.watch(databaseProvider);
    final settings = ref.watch(appSettingsProvider);
    final goalMinutes = settings.dailyGoalMinutes;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Target Harian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                Text(
                  '$goalMinutes menit/hari',
                  style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.primary),
                ),
              ],
            ),
            const SizedBox(height: 12),
            FutureBuilder<int>(
              future: db.getTodayReadingMinutes(),
              builder: (context, snapshot) {
                final readMinutes = snapshot.data ?? 0;
                final progress = goalMinutes > 0 ? (readMinutes / goalMinutes).clamp(0.0, 1.0) : 0.0;
                final isComplete = readMinutes >= goalMinutes;

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isComplete ? Icons.check_circle_rounded : Icons.access_time_rounded,
                          size: 16,
                          color: isComplete ? Colors.green : Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$readMinutes / $goalMinutes menit hari ini',
                          style: const TextStyle(fontSize: 12),
                        ),
                        if (isComplete)
                          Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Text(
                              'Selesai!',
                              style: TextStyle(fontSize: 12, color: Colors.green.shade600, fontWeight: FontWeight.bold),
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 6,
                      borderRadius: BorderRadius.circular(3),
                      backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                      color: isComplete ? Colors.green : Theme.of(context).colorScheme.primary,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}