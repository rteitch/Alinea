import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/storage/database.dart';
import 'translation_overlay.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int bookId;

  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentChapterIndex = 0;
  List<Chapter> _chapters = [];
  Book? _book;
  bool _isLoading = true;
  double _fontSize = 16.0;

  String _currentChapterContent = '';

  @override
  void initState() {
    super.initState();
    _loadBookAndProgress();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _loadBookAndProgress() async {
    final bookRepo = ref.read(bookRepositoryProvider);
    final book = await bookRepo.getBookById(widget.bookId);
    final chapters = await bookRepo.getChaptersByBookId(widget.bookId);
    final progress = await bookRepo.getReadingProgress(widget.bookId);

    if (mounted) {
      setState(() {
        _book = book;
        _chapters = chapters;
        if (progress != null && chapters.isNotEmpty) {
          final idx = chapters.indexWhere((c) => c.id == progress.chapterId);
          _currentChapterIndex = idx >= 0 ? idx : 0;
        }
      });
      await _loadCurrentChapterContent();
    }
  }

  Future<void> _loadCurrentChapterContent() async {
    if (_chapters.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    final currentChapter = _chapters[_currentChapterIndex];
    final bookRepo = ref.read(bookRepositoryProvider);
    final content = await bookRepo.getChapterContent(widget.bookId, currentChapter.id);
    if (mounted) {
      setState(() {
        _currentChapterContent = content;
        _isLoading = false;
      });
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || _chapters.isEmpty) return;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    final pct = maxScroll > 0 ? (currentScroll / maxScroll).clamp(0.0, 1.0) : 0.0;

    final currentChapter = _chapters[_currentChapterIndex];
    final bookRepo = ref.read(bookRepositoryProvider);
    bookRepo.updateReadingProgress(
      bookId: widget.bookId,
      chapterId: currentChapter.id,
      scrollPct: pct,
    );
  }

  Future<void> _goToChapter(int index) async {
    if (index < 0 || index >= _chapters.length) return;
    setState(() {
      _currentChapterIndex = index;
    });
    if (_scrollController.hasClients) {
      _scrollController.jumpTo(0);
    }
    final bookRepo = ref.read(bookRepositoryProvider);
    await bookRepo.updateReadingProgress(
      bookId: widget.bookId,
      chapterId: _chapters[index].id,
      scrollPct: 0.0,
    );
    await _loadCurrentChapterContent();
  }

  void _handleTranslateSelection(String selectedText) {
    final clean = selectedText.trim();
    if (clean.isEmpty) return;

    final targetLang = ref.read(targetLanguageProvider);
    final sourceLang = _book?.sourceLanguage ?? 'en';

    TranslationOverlay.show(
      context,
      bookId: widget.bookId,
      selectedText: clean,
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );
  }

  void _showReadingSettings() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            final activeTheme = ref.watch(readingThemeModeProvider);
            return Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Pengaturan Membaca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  const SizedBox(height: 16),
                  // Font size slider
                  Row(
                    children: [
                      const Text('A', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Slider(
                          value: _fontSize,
                          min: 12,
                          max: 28,
                          divisions: 8,
                          label: '${_fontSize.toInt()}sp',
                          onChanged: (val) {
                            setSheetState(() => _fontSize = val);
                            setState(() => _fontSize = val);
                          },
                        ),
                      ),
                      const Text('A', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text('Pilihan Tema:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  // Theme buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildThemeCircle('Light', Colors.white, Colors.black, ReadingThemeMode.light, activeTheme),
                      _buildThemeCircle('Sepia', const Color(0xFFF7F1E3), const Color(0xFF4A3B32), ReadingThemeMode.sepia, activeTheme),
                      _buildThemeCircle('Dark', const Color(0xFF1E1E24), Colors.white, ReadingThemeMode.dark, activeTheme),
                      _buildThemeCircle('AMOLED', Colors.black, Colors.white, ReadingThemeMode.amoled, activeTheme),
                    ],
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildThemeCircle(String label, Color bg, Color border, ReadingThemeMode mode, ReadingThemeMode current) {
    final isSelected = mode == current;
    return GestureDetector(
      onTap: () => ref.read(readingThemeModeProvider.notifier).state = mode,
      child: Column(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: bg,
              shape: BoxShape.circle,
              border: Border.all(
                color: isSelected ? Colors.blue : border,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected ? const Icon(Icons.check, size: 20, color: Colors.blue) : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_chapters.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: Text(_book?.title ?? 'Alinea Reader')),
        body: const Center(child: Text('Tidak ada bab yang ditemukan dalam buku ini.')),
      );
    }

    final currentChapter = _chapters[_currentChapterIndex];

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _book?.title ?? '',
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}',
              style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Tambah Bookmark',
            onPressed: () async {
              final bookmarkRepo = ref.read(bookmarkRepositoryProvider);
              await bookmarkRepo.addBookmark(
                bookId: widget.bookId,
                chapterId: currentChapter.id,
                cfi: '/chapter/$_currentChapterIndex',
                label: currentChapter.title,
              );
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Penanda halaman disimpan.')),
                );
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: 'Pengaturan Teks & Tema',
            onPressed: _showReadingSettings,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  const Text('Daftar Isi (TOC)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
                  const SizedBox(height: 4),
                  Text(_book?.title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13)),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: _chapters.length,
                itemBuilder: (ctx, idx) {
                  final ch = _chapters[idx];
                  final isCurrent = idx == _currentChapterIndex;
                  return ListTile(
                    selected: isCurrent,
                    selectedTileColor: Theme.of(context).colorScheme.primaryContainer.withAlpha(80),
                    leading: CircleAvatar(
                      radius: 14,
                      backgroundColor: isCurrent ? Theme.of(context).colorScheme.primary : Colors.grey.shade300,
                      child: Text(
                        '${idx + 1}',
                        style: TextStyle(
                          fontSize: 11,
                          color: isCurrent ? Colors.white : Colors.black87,
                        ),
                      ),
                    ),
                    title: Text(
                      ch.title ?? 'Bab ${idx + 1}',
                      style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal),
                    ),
                    subtitle: ch.wordCount != null ? Text('${ch.wordCount} kata', style: const TextStyle(fontSize: 11)) : null,
                    onTap: () {
                      Navigator.pop(context);
                      _goToChapter(idx);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: SelectionArea(
        contextMenuBuilder: (context, selectableRegionState) {
          // ignore: deprecated_member_use
          final text = selectableRegionState.textEditingValue.text;
          return AdaptiveTextSelectionToolbar.buttonItems(
            anchors: selectableRegionState.contextMenuAnchors,
            buttonItems: [
              ContextMenuButtonItem(
                label: 'Terjemahkan (Alinea)',
                onPressed: () {
                  selectableRegionState.hideToolbar();
                  _handleTranslateSelection(text);
                },
              ),
              ...selectableRegionState.contextMenuButtonItems,
            ],
          );
        },
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (currentChapter.title != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20.0),
                  child: Text(
                    currentChapter.title!,
                    style: TextStyle(
                      fontSize: _fontSize + 6,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.2,
                    ),
                  ),
                ),
              // Clean text content with paragraph styling
              Text(
                _cleanHtmlToReadableText(_currentChapterContent),
                style: TextStyle(
                  fontSize: _fontSize,
                  height: 1.65,
                  letterSpacing: 0.15,
                ),
              ),
              const SizedBox(height: 60),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Container(
        height: 56,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(20),
              blurRadius: 4,
              offset: const Offset(0, -1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              icon: const Icon(Icons.chevron_left),
              tooltip: 'Bab Sebelumnya',
              onPressed: _currentChapterIndex > 0 ? () => _goToChapter(_currentChapterIndex - 1) : null,
            ),
            Text(
              'Bab ${_currentChapterIndex + 1} dari ${_chapters.length}',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
            IconButton(
              icon: const Icon(Icons.chevron_right),
              tooltip: 'Bab Berikutnya',
              onPressed: _currentChapterIndex < _chapters.length - 1 ? () => _goToChapter(_currentChapterIndex + 1) : null,
            ),
          ],
        ),
      ),
    );
  }

  String _cleanHtmlToReadableText(String html) {
    if (html.isEmpty) return 'Bab ini tidak memiliki konten teks.';
    return html
        .replaceAll(RegExp(r'<style[^>]*>[\s\S]*?</style>', caseSensitive: false), '')
        .replaceAll(RegExp(r'<script[^>]*>[\s\S]*?</script>', caseSensitive: false), '')
        .replaceAll(RegExp(r'</p>|</div>|<br\s*/?>', caseSensitive: false), '\n\n')
        .replaceAll(RegExp(r'<[^>]*>'), '')
        .replaceAll(RegExp(r'&nbsp;', caseSensitive: false), ' ')
        .replaceAll(RegExp(r'&amp;', caseSensitive: false), '&')
        .replaceAll(RegExp(r'&lt;', caseSensitive: false), '<')
        .replaceAll(RegExp(r'&gt;', caseSensitive: false), '>')
        .replaceAll(RegExp(r'&quot;', caseSensitive: false), '"')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();
  }
}
