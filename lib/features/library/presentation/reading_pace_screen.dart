import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';

class ReadingPaceScreen extends ConsumerStatefulWidget {
  const ReadingPaceScreen({super.key});

  @override
  ConsumerState<ReadingPaceScreen> createState() => _ReadingPaceScreenState();
}

class _ReadingPaceScreenState extends ConsumerState<ReadingPaceScreen> {
  List<Map<String, dynamic>> _sessions = [];
  bool _loading = true;
  String _timeRange = 'all'; // all, 30d, 7d

  @override
  void initState() {
    super.initState();
    _loadSessions();
  }

  Future<void> _loadSessions() async {
    final db = ref.read(databaseProvider);
    final allSessions = await db.getAllReadingSessions();

    final allBooks = await (db.select(db.books)).get();
    final bookMap = {for (final b in allBooks) b.id: b.title};

    final sessionData = allSessions.where((s) => s.durationSeconds > 0 && s.wordsRead > 0).map((s) {
      final wpm = (s.wordsRead / (s.durationSeconds / 60)).round();
      return {
        'session': s,
        'bookTitle': bookMap[s.bookId] ?? 'Unknown',
        'wpm': wpm,
      };
    }).toList();

    setState(() {
      _sessions = sessionData;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    if (_timeRange == 'all') return _sessions;
    final cutoff = _timeRange == '30d'
        ? DateTime.now().subtract(const Duration(days: 30))
        : DateTime.now().subtract(const Duration(days: 7));
    return _sessions.where((item) {
      final s = item['session'];
      return s.startedAt.isAfter(cutoff);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final avgWpm = filtered.isNotEmpty
        ? (filtered.map((s) => s['wpm'] as int).reduce((a, b) => a + b) / filtered.length).round()
        : 0;
    final maxWpm = filtered.isNotEmpty
        ? filtered.map((s) => s['wpm'] as int).reduce((a, b) => a > b ? a : b)
        : 0;
    final minWpm = filtered.isNotEmpty
        ? filtered.map((s) => s['wpm'] as int).reduce((a, b) => a < b ? a : b)
        : 0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Kecepatan Membaca'),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.date_range_rounded),
            onSelected: (v) => setState(() => _timeRange = v),
            itemBuilder: (context) => [
              const PopupMenuItem(value: 'all', child: Text('Semua Waktu')),
              const PopupMenuItem(value: '30d', child: Text('30 Hari Terakhir')),
              const PopupMenuItem(value: '7d', child: Text('7 Hari Terakhir')),
            ],
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : filtered.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.speed_rounded, size: 64, color: Colors.grey.shade300),
                      const SizedBox(height: 16),
                      Text('Belum ada data kecepatan', style: TextStyle(color: Colors.grey.shade600)),
                      const SizedBox(height: 4),
                      Text('Mulai membaca untuk melacak WPM', style: TextStyle(fontSize: 12, color: Colors.grey.shade500)),
                    ],
                  ),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Summary stats
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Ringkasan', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 12),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  _statItem(Icons.speed_rounded, '$avgWpm', 'Rata-rata', Colors.blue),
                                  _statItem(Icons.trending_up_rounded, '$maxWpm', 'Tertinggi', Colors.green),
                                  _statItem(Icons.trending_down_rounded, '$minWpm', 'Terendah', Colors.orange),
                                  _statItem(Icons.play_circle_outline_rounded, '${filtered.length}', 'Sesi', Colors.purple),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // WPM bar chart (last 20 sessions)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Grafik WPM (Sesi Terakhir ${filtered.length > 20 ? 20 : filtered.length})',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                              ),
                              const SizedBox(height: 16),
                              _buildBarChart(filtered, avgWpm),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // Session list
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Riwayat Sesi', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                              const SizedBox(height: 8),
                              ...filtered.take(30).map((item) => _buildSessionTile(item, avgWpm)),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _statItem(IconData icon, String value, String label, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 20),
        const SizedBox(height: 4),
        Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
      ],
    );
  }

  Widget _buildBarChart(List<Map<String, dynamic>> data, int avgWpm) {
    final recent = data.reversed.take(20).toList();
    final maxVal = recent.map((s) => s['wpm'] as int).reduce((a, b) => a > b ? a : b);
    if (maxVal == 0) return const SizedBox();

    return SizedBox(
      height: 120,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: List.generate(recent.length, (i) {
          final wpm = recent[i]['wpm'] as int;
          final ratio = wpm / maxVal;
          final isAboveAvg = wpm >= avgWpm;

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 1),
              child: Tooltip(
                message: '${recent[i]['bookTitle']}\n$wpm WPM\n${_formatDate((recent[i]['session']).startedAt)}',
                child: Container(
                  decoration: BoxDecoration(
                    color: isAboveAvg ? Colors.blue : Colors.blue.shade200,
                    borderRadius: BorderRadius.circular(3),
                  ),
                  height: (100 * ratio).clamp(4.0, 100.0),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildSessionTile(Map<String, dynamic> item, int avgWpm) {
    final s = item['session'];
    final wpm = item['wpm'] as int;
    final bookTitle = item['bookTitle'] as String;
    final diff = wpm - avgWpm;
    final diffStr = diff >= 0 ? '+$diff' : '$diff';
    final diffColor = diff >= 0 ? Colors.green : Colors.red;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(bookTitle, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(_formatDate(s.startedAt), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              '${wpm} WPM',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: wpm >= avgWpm ? Colors.blue : Colors.grey.shade700),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            width: 45,
            child: Text(
              diffStr,
              style: TextStyle(fontSize: 11, color: diffColor),
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
