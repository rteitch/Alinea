import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class ReadingDistributionScreen extends ConsumerStatefulWidget {
  const ReadingDistributionScreen({super.key});

  @override
  ConsumerState<ReadingDistributionScreen> createState() => _ReadingDistributionScreenState();
}

class _ReadingDistributionScreenState extends ConsumerState<ReadingDistributionScreen> {
  List<Map<String, dynamic>> _bookStats = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final db = ref.read(databaseProvider);
    final allBooks = await (db.select(db.books)).get();
    final stats = <Map<String, dynamic>>[];

    for (final book in allBooks) {
      final bookStats = await db.getReadingStats(book.id);
      final totalSeconds = bookStats['totalSeconds'] ?? 0;
      if (totalSeconds > 0) {
        stats.add({
          'book': book,
          'hours': totalSeconds / 3600,
          'minutes': totalSeconds ~/ 60,
          'seconds': totalSeconds,
        });
      }
    }

    stats.sort((a, b) => b['seconds'].compareTo(a['seconds']));
    final totalSecondsAll = stats.fold<int>(0, (sum, s) => sum + (s['seconds'] as int));

    // Add percentage
    for (final stat in stats) {
      stat['percentage'] = totalSecondsAll > 0
          ? ((stat['seconds'] as int) / totalSecondsAll * 100)
          : 0.0;
    }

    setState(() {
      _bookStats = stats;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final totalHours = _bookStats.fold<double>(0, (sum, s) => sum + (s['hours'] as double));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Distribusi Membaca'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : _bookStats.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.pie_chart_rounded, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Belum ada data membaca', style: TextStyle(color: Colors.grey.shade600)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Pie chart
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            children: [
                              Text(
                                'Total: ${totalHours.toStringAsFixed(1)} jam',
                                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 20),
                              SizedBox(
                                width: 220,
                                height: 220,
                                child: CustomPaint(
                                  painter: _PieChartPainter(_bookStats),
                                  child: Center(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          '${_bookStats.length}',
                                          style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                                        ),
                                        Text(
                                          'buku',
                                          style: TextStyle(fontSize: 13, color: Colors.grey.shade600),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Legend & breakdown
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Rincian', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 12),
                              ..._bookStats.asMap().entries.map((entry) {
                                final i = entry.key;
                                final stat = entry.value;
                                final book = stat['book'] as Book;
                                final colors = [
                                  Colors.blue, Colors.green, Colors.orange, Colors.purple,
                                  Colors.teal, Colors.red, Colors.amber, Colors.indigo,
                                  Colors.pink, Colors.cyan,
                                ];
                                final color = colors[i % colors.length];
                                final pct = stat['percentage'] as double;
                                final hrs = stat['hours'] as double;

                                return Padding(
                                  padding: const EdgeInsets.only(bottom: 10),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 12,
                                        height: 12,
                                        decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
                                      ),
                                      const SizedBox(width: 10),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              book.title,
                                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                            Text(
                                              '${hrs.toStringAsFixed(1)} jam (${pct.toStringAsFixed(1)}%)',
                                              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                            ),
                                          ],
                                        ),
                                      ),
                                      // Mini bar
                                      SizedBox(
                                        width: 80,
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(3),
                                          child: LinearProgressIndicator(
                                            value: pct / 100,
                                            minHeight: 8,
                                            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
                                            color: color,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                );
                              }),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}

class _PieChartPainter extends CustomPainter {
  final List<Map<String, dynamic>> data;

  _PieChartPainter(this.data);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 8;
    final colors = [
      Colors.blue, Colors.green, Colors.orange, Colors.purple,
      Colors.teal, Colors.red, Colors.amber, Colors.indigo,
      Colors.pink, Colors.cyan,
    ];

    double startAngle = -3.14159 / 2; // Start from top

    for (int i = 0; i < data.length; i++) {
      final pct = data[i]['percentage'] as double;
      final sweepAngle = (pct / 100) * 2 * 3.14159;
      final color = colors[i % colors.length];

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweepAngle,
        true,
        paint,
      );

      startAngle += sweepAngle;
    }

    // Draw center circle for donut effect
    final centerPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, radius * 0.45, centerPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
