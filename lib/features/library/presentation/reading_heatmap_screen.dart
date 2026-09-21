import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class ReadingHeatMapScreen extends ConsumerStatefulWidget {
  const ReadingHeatMapScreen({super.key});

  @override
  ConsumerState<ReadingHeatMapScreen> createState() => _ReadingHeatMapScreenState();
}

class _ReadingHeatMapScreenState extends ConsumerState<ReadingHeatMapScreen> {
  Map<DateTime, int> _dailyMinutes = {};
  bool _loading = true;
  int _selectedYear = DateTime.now().year;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final db = ref.read(databaseProvider);
    final sessions = await db.getAllReadingSessions();

    final Map<DateTime, int> dailyMinutes = {};
    for (final session in sessions) {
      final date = DateTime(session.startedAt.year, session.startedAt.month, session.startedAt.day);
      final minutes = session.durationSeconds ~/ 60;
      dailyMinutes[date] = (dailyMinutes[date] ?? 0) + minutes;
    }

    setState(() {
      _dailyMinutes = dailyMinutes;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();
    final totalDaysInYear = DateTime(_selectedYear + 1, 1, 1).difference(DateTime(_selectedYear, 1, 1)).inDays;

    // Calculate stats for selected year
    int totalMinutes = 0;
    int activeDays = 0;
    int maxMinutes = 0;
    for (final entry in _dailyMinutes.entries) {
      if (entry.key.year == _selectedYear) {
        totalMinutes += entry.value;
        activeDays++;
        if (entry.value > maxMinutes) maxMinutes = entry.value;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Peta Membaca'),
        actions: [
          IconButton(
            icon: const Icon(Icons.chevron_left_rounded),
            onPressed: _selectedYear > 2020 ? () => setState(() => _selectedYear--) : null,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Text(
                '$_selectedYear',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right_rounded),
            onPressed: _selectedYear < now.year ? () => setState(() => _selectedYear++) : null,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Stats summary
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _yearStat(Icons.access_time_rounded, '${(totalMinutes / 60).toStringAsFixed(1)}', 'jam', Colors.blue),
                          _yearStat(Icons.calendar_today_rounded, '$activeDays', 'hari aktif', Colors.green),
                          _yearStat(Icons.local_fire_department_rounded, '$maxMinutes', 'menit (max)', Colors.orange),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Month labels
                  _buildMonthLabels(),
                  const SizedBox(height: 4),

                  // Heat map grid
                  _buildHeatMapGrid(theme, totalDaysInYear),

                  const SizedBox(height: 20),

                  // Legend
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('Kurang', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                      const SizedBox(width: 4),
                      ...List.generate(5, (i) => Container(
                        width: 14,
                        height: 14,
                        margin: const EdgeInsets.symmetric(horizontal: 1),
                        decoration: BoxDecoration(
                          color: _getIntensityColor(i, 0),
                          borderRadius: BorderRadius.circular(2),
                        ),
                      )),
                      const SizedBox(width: 4),
                      Text('Lebih', style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Month breakdown
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Ringkasan Bulanan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                          const SizedBox(height: 12),
                          ..._buildMonthBreakdown(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _yearStat(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildMonthLabels() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'Mei', 'Jun', 'Jul', 'Agu', 'Sep', 'Okt', 'Nov', 'Des'];
    final firstDay = DateTime(_selectedYear, 1, 1);
    final startWeekday = firstDay.weekday % 7; // 0=Sun

    // Calculate approximate column positions
    return Padding(
      padding: const EdgeInsets.only(left: 28),
      child: Row(
        children: List.generate(53, (weekIndex) {
          final dayOfWeek = weekIndex == 0 ? 0 : 0; // simplified
          return const SizedBox(width: 14);
        }),
      ),
    );
  }

  Widget _buildHeatMapGrid(ThemeData theme, int totalDaysInYear) {
    final firstDay = DateTime(_selectedYear, 1, 1);
    final startWeekday = firstDay.weekday % 7; // 0=Sun, 1=Mon, ...
    final weeks = (totalDaysInYear + startWeekday + 6) ~/ 7;

    final dayLabels = ['Min', 'Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab'];

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day labels
        Column(
          children: List.generate(7, (i) => SizedBox(
            height: 14,
            width: 24,
            child: i % 2 == 1
                ? Text(
                    dayLabels[i],
                    style: TextStyle(fontSize: 9, color: Colors.grey.shade600),
                    textAlign: TextAlign.right,
                  )
                : const SizedBox(),
          )),
        ),
        const SizedBox(width: 4),
        // Grid
        Expanded(
          child: Wrap(
            spacing: 2,
            runSpacing: 2,
            children: List.generate(totalDaysInYear, (dayIndex) {
              final date = DateTime(_selectedYear, 1, 1 + dayIndex);
              final dateKey = DateTime(date.year, date.month, date.day);
              final minutes = _dailyMinutes[dateKey] ?? 0;
              final intensity = _getIntensityLevel(minutes);

              return Tooltip(
                message: '${date.day}/${date.month}: ${minutes}m',
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: _getIntensityColor(intensity, 0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }

  List<Widget> _buildMonthBreakdown() {
    final monthNames = [
      'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember'
    ];

    final List<Widget> widgets = [];
    for (int m = 1; m <= 12; m++) {
      int monthMinutes = 0;
      int monthDays = 0;
      for (final entry in _dailyMinutes.entries) {
        if (entry.key.year == _selectedYear && entry.key.month == m) {
          monthMinutes += entry.value;
          monthDays++;
        }
      }
      if (monthMinutes == 0) continue;

      widgets.add(
        Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 80,
                child: Text(
                  monthNames[m - 1].substring(0, 3),
                  style: const TextStyle(fontSize: 12),
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: monthMinutes / 3600, // scale by hours
                    minHeight: 14,
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                    color: _getBarColor(monthMinutes),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 55,
                child: Text(
                  '${(monthMinutes / 60).toStringAsFixed(1)}j',
                  style: TextStyle(fontSize: 11, color: Colors.grey.shade700),
                  textAlign: TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      );
    }
    return widgets;
  }

  int _getIntensityLevel(int minutes) {
    if (minutes == 0) return 0;
    if (minutes < 15) return 1;
    if (minutes < 30) return 2;
    if (minutes < 60) return 3;
    return 4;
  }

  Color _getIntensityColor(int level, int _) {
    switch (level) {
      case 0: return Colors.grey.shade200;
      case 1: return Colors.green.shade100;
      case 2: return Colors.green.shade300;
      case 3: return Colors.green.shade600;
      case 4: return Colors.green.shade900;
      default: return Colors.grey.shade200;
    }
  }

  Color _getBarColor(int minutes) {
    if (minutes >= 120) return Colors.green;
    if (minutes >= 60) return Colors.blue;
    if (minutes >= 30) return Colors.orange;
    return Colors.grey;
  }
}
