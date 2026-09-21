import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class HighlightsSummaryScreen extends ConsumerStatefulWidget {
  const HighlightsSummaryScreen({super.key});

  @override
  ConsumerState<HighlightsSummaryScreen> createState() => _HighlightsSummaryScreenState();
}

class _HighlightsSummaryScreenState extends ConsumerState<HighlightsSummaryScreen> {
  String _selectedColor = 'all';
  String _searchQuery = '';
  List<Map<String, dynamic>> _highlights = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadHighlights();
  }

  Future<void> _loadHighlights() async {
    final db = ref.read(databaseProvider);
    final allHighlights = await (db.select(db.highlights)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    final allBooks = await (db.select(db.books)).get();
    final bookMap = {for (final b in allBooks) b.id: b.title};

    final allChapters = await (db.select(db.chapters)).get();
    final chapterMap = {for (final c in allChapters) c.id: c.title};

    final results = allHighlights.map((h) => {
      'highlight': h,
      'bookTitle': bookMap[h.bookId] ?? 'Unknown',
      'chapterTitle': chapterMap[h.chapterId] ?? 'Unknown',
    }).toList();

    setState(() {
      _highlights = results;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    return _highlights.where((item) {
      final h = item['highlight'] as Highlight;
      if (_selectedColor != 'all' && h.color != _selectedColor) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchText = '${h.startAnchor} ${h.note ?? ''} ${item['bookTitle']} ${item['chapterTitle']}'.toLowerCase();
        if (!matchText.contains(query)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final colorGroups = _colorGroupCounts();

    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Highlight (${_highlights.length})'),
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                // Search bar
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 4),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Cari highlight...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                // Color filter chips
                SizedBox(
                  height: 42,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: [
                      _colorChip('all', 'Semua', Colors.grey, _highlights.length),
                      _colorChip('yellow', 'Kuning', Colors.yellow.shade700, colorGroups['yellow'] ?? 0),
                      _colorChip('green', 'Hijau', Colors.green, colorGroups['green'] ?? 0),
                      _colorChip('blue', 'Biru', Colors.blue, colorGroups['blue'] ?? 0),
                      _colorChip('pink', 'Merah Muda', Colors.pink, colorGroups['pink'] ?? 0),
                    ],
                  ),
                ),
                const SizedBox(height: 4),
                // List
                Expanded(
                  child: filtered.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.highlight_rounded, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text('Tidak ada highlight', style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _buildHighlightTile(filtered[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _colorChip(String color, String label, Color chipColor, int count) {
    final selected = _selectedColor == color;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: FilterChip(
        label: Text('$label ($count)', style: TextStyle(fontSize: 12, color: selected ? Colors.white : null)),
        selected: selected,
        selectedColor: chipColor,
        backgroundColor: chipColor.withOpacity(0.1),
        onSelected: (_) => setState(() => _selectedColor = color),
        visualDensity: VisualDensity.compact,
      ),
    );
  }

  Map<String, int> _colorGroupCounts() {
    final map = <String, int>{};
    for (final item in _highlights) {
      final h = item['highlight'] as Highlight;
      map[h.color] = (map[h.color] ?? 0) + 1;
    }
    return map;
  }

  Widget _buildHighlightTile(Map<String, dynamic> item) {
    final h = item['highlight'] as Highlight;
    final bookTitle = item['bookTitle'] as String;
    final chapterTitle = item['chapterTitle'] as String;
    final color = _colorFromName(h.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Color bar + book/chapter info
            Row(
              children: [
                Container(width: 4, height: 40, decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(2))),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(bookTitle, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600), maxLines: 1, overflow: TextOverflow.ellipsis),
                      Text(chapterTitle, style: TextStyle(fontSize: 10, color: Colors.grey.shade600), maxLines: 1, overflow: TextOverflow.ellipsis),
                    ],
                  ),
                ),
                Text(_formatDate(h.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
            const SizedBox(height: 8),
            // Highlight text
            Text(
              h.startAnchor,
              style: const TextStyle(fontSize: 13, fontStyle: FontStyle.italic),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
            if (h.note != null && h.note!.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                children: [
                  Icon(Icons.note_rounded, size: 14, color: Colors.grey.shade500),
                  const SizedBox(width: 4),
                  Expanded(
                    child: Text(h.note!, style: TextStyle(fontSize: 12, color: Colors.grey.shade700)),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _colorFromName(String name) {
    switch (name) {
      case 'yellow': return Colors.yellow.shade700;
      case 'green': return Colors.green;
      case 'blue': return Colors.blue;
      case 'pink': return Colors.pink;
      default: return Colors.grey;
    }
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
