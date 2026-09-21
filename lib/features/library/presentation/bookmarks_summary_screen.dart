import 'package:flutter/material.dart';
import 'package:drift/drift.dart' hide Column;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/storage/database.dart';

class BookmarksSummaryScreen extends ConsumerStatefulWidget {
  const BookmarksSummaryScreen({super.key});

  @override
  ConsumerState<BookmarksSummaryScreen> createState() => _BookmarksSummaryScreenState();
}

class _BookmarksSummaryScreenState extends ConsumerState<BookmarksSummaryScreen> {
  String _searchQuery = '';
  bool _showWithNotesOnly = false;
  List<Map<String, dynamic>> _bookmarks = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final db = ref.read(databaseProvider);
    final allBookmarks = await (db.select(db.bookmarks)
          ..orderBy([(t) => OrderingTerm.desc(t.createdAt)]))
        .get();

    final allBooks = await (db.select(db.books)).get();
    final bookMap = {for (final b in allBooks) b.id: b.title};

    final allChapters = await (db.select(db.chapters)).get();
    final chapterMap = {for (final c in allChapters) c.id: c.title};

    final results = allBookmarks.map((b) => {
      'bookmark': b,
      'bookTitle': bookMap[b.bookId] ?? 'Unknown',
      'chapterTitle': chapterMap[b.chapterId] ?? 'Unknown',
    }).toList();

    setState(() {
      _bookmarks = results;
      _loading = false;
    });
  }

  List<Map<String, dynamic>> get _filtered {
    return _bookmarks.where((item) {
      final b = item['bookmark'] as Bookmark;
      if (_showWithNotesOnly && (b.note == null || b.note!.isEmpty)) return false;
      if (_searchQuery.isNotEmpty) {
        final query = _searchQuery.toLowerCase();
        final matchText = '${b.label ?? ''} ${b.note ?? ''} ${item['bookTitle']} ${item['chapterTitle']}'.toLowerCase();
        if (!matchText.contains(query)) return false;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final filtered = _filtered;
    final withNotes = _bookmarks.where((item) {
      final b = item['bookmark'] as Bookmark;
      return b.note != null && b.note!.isNotEmpty;
    }).length;

    return Scaffold(
      appBar: AppBar(
        title: Text('Semua Bookmark (${_bookmarks.length})'),
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
                      hintText: 'Cari bookmark...',
                      prefixIcon: const Icon(Icons.search_rounded, size: 20),
                      isDense: true,
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    onChanged: (v) => setState(() => _searchQuery = v),
                  ),
                ),
                // Filter chips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  child: Row(
                    children: [
                      FilterChip(
                        label: Text('Dengan Catatan ($withNotes)', style: TextStyle(fontSize: 12)),
                        selected: _showWithNotesOnly,
                        onSelected: (v) => setState(() => _showWithNotesOnly = v),
                        visualDensity: VisualDensity.compact,
                      ),
                      const Spacer(),
                      Text(
                        '${filtered.length} dari ${_bookmarks.length}',
                        style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                      ),
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
                              Icon(Icons.bookmark_rounded, size: 48, color: Colors.grey.shade300),
                              const SizedBox(height: 12),
                              Text('Tidak ada bookmark', style: TextStyle(color: Colors.grey.shade600)),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: filtered.length,
                          itemBuilder: (context, index) => _buildBookmarkTile(filtered[index]),
                        ),
                ),
              ],
            ),
    );
  }

  Widget _buildBookmarkTile(Map<String, dynamic> item) {
    final b = item['bookmark'] as Bookmark;
    final bookTitle = item['bookTitle'] as String;
    final chapterTitle = item['chapterTitle'] as String;
    final hasNote = b.note != null && b.note!.isNotEmpty;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.bookmark_rounded, size: 20, color: Colors.blue.shade600),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        b.label ?? 'Bookmark',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '$bookTitle — $chapterTitle',
                        style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Text(_formatDate(b.createdAt), style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
              ],
            ),
            if (hasNote) ...[
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  b.note!,
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime dt) {
    return '${dt.day.toString().padLeft(2, '0')}/${dt.month.toString().padLeft(2, '0')}/${dt.year}';
  }
}
