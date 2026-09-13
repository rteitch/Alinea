// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/storage/database.dart';
import '../../glossary/presentation/glossary_screen.dart';
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

  // Audio / TTS state
  bool _isAudioBarVisible = false;
  bool _isAudioPlaying = false;
  double _speechRate = 0.5;

  // Bookmarks & Highlights
  List<Bookmark> _bookmarks = [];
  List<Highlight> _highlights = [];
  int _drawerTabIndex = 0; // 0: TOC, 1: Bookmarks, 2: Highlights

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
    ref.read(ttsServiceProvider).stop();
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
      await _loadBookmarks();
      await _loadHighlights();
    }
  }

  Future<void> _loadBookmarks() async {
    final repo = ref.read(bookmarkRepositoryProvider);
    final list = await repo.getBookmarksByBook(widget.bookId);
    if (mounted) {
      setState(() => _bookmarks = list);
    }
  }

  Future<void> _loadHighlights() async {
    final repo = ref.read(highlightRepositoryProvider);
    final list = await repo.getHighlightsByBook(widget.bookId);
    if (mounted) {
      setState(() => _highlights = list);
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

    if (_isAudioPlaying) {
      await ref.read(ttsServiceProvider).stop();
      setState(() {
        _isAudioPlaying = false;
        _isAudioBarVisible = false;
      });
    }

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

  // --- TTS Audio Narration ---
  Future<void> _toggleAudioNarration() async {
    final tts = ref.read(ttsServiceProvider);
    tts.onStateChanged = (state) {
      if (mounted) {
        setState(() => _isAudioPlaying = state == TtsState.playing);
      }
    };

    if (_isAudioPlaying) {
      await tts.pause();
      setState(() => _isAudioPlaying = false);
    } else {
      final cleanText = _cleanHtmlToReadableText(_currentChapterContent);
      if (cleanText.isEmpty || cleanText == 'Bab ini tidak memiliki konten teks.') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bab ini tidak memiliki teks untuk dibacakan.')),
        );
        return;
      }
      setState(() {
        _isAudioBarVisible = true;
        _isAudioPlaying = true;
      });
      await tts.speak(
        cleanText,
        language: _book?.sourceLanguage ?? 'en',
        rate: _speechRate,
      );
    }
  }

  Future<void> _stopAudioNarration() async {
    await ref.read(ttsServiceProvider).stop();
    if (mounted) {
      setState(() {
        _isAudioPlaying = false;
        _isAudioBarVisible = false;
      });
    }
  }

  void _cycleSpeechRate() {
    double nextRate;
    if (_speechRate == 0.5) {
      nextRate = 0.75;
    } else if (_speechRate == 0.75) {
      nextRate = 1.0;
    } else if (_speechRate == 1.0) {
      nextRate = 1.25;
    } else if (_speechRate == 1.25) {
      nextRate = 1.5;
    } else {
      nextRate = 0.5;
    }
    setState(() => _speechRate = nextRate);

    if (_isAudioPlaying) {
      final tts = ref.read(ttsServiceProvider);
      tts.speak(
        _cleanHtmlToReadableText(_currentChapterContent),
        language: _book?.sourceLanguage ?? 'en',
        rate: _speechRate,
      );
    }
  }

  // --- Bookmarks & Highlights Actions ---
  Future<void> _addCurrentBookmark() async {
    if (_chapters.isEmpty) return;
    final currentChapter = _chapters[_currentChapterIndex];
    final bookmarkRepo = ref.read(bookmarkRepositoryProvider);
    await bookmarkRepo.addBookmark(
      bookId: widget.bookId,
      chapterId: currentChapter.id,
      cfi: '/chapter/$_currentChapterIndex',
      label: currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}',
    );
    await _loadBookmarks();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Penanda halaman disimpan untuk: ${currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}'}'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  void _showBookmarksSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.7,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.collections_bookmark_rounded, color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 8),
                          Text(
                            'Penanda Halaman (${_bookmarks.length})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.bookmark_add_rounded),
                        tooltip: 'Tambah Bookmark Bab Ini',
                        onPressed: () async {
                          await _addCurrentBookmark();
                          setSheetState(() {});
                        },
                      ),
                    ],
                  ),
                  const Divider(),
                  Expanded(
                    child: _bookmarks.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.bookmark_border_rounded, size: 48, color: Colors.grey.shade400),
                                const SizedBox(height: 8),
                                const Text('Belum ada penanda halaman.', style: TextStyle(fontSize: 13, color: Colors.grey)),
                              ],
                            ),
                          )
                        : ListView.separated(
                            itemCount: _bookmarks.length,
                            separatorBuilder: (context, index) => const Divider(height: 1),
                            itemBuilder: (context, idx) {
                              final bm = _bookmarks[idx];
                              final chapter = _chapters.firstWhere(
                                (c) => c.id == bm.chapterId,
                                orElse: () => _chapters.first,
                              );
                              final chapterIndex = _chapters.indexOf(chapter);
                              final dateStr = '${bm.createdAt.day}/${bm.createdAt.month}/${bm.createdAt.year}';

                              return ListTile(
                                leading: CircleAvatar(
                                  radius: 16,
                                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                                  child: Icon(Icons.bookmark_rounded, size: 16, color: Theme.of(context).colorScheme.primary),
                                ),
                                title: Text(bm.label ?? chapter.title ?? 'Bab ${chapterIndex + 1}',
                                    style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                                subtitle: Text('Disimpan pada $dateStr', style: const TextStyle(fontSize: 11)),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                  tooltip: 'Hapus',
                                  onPressed: () async {
                                    await ref.read(bookmarkRepositoryProvider).deleteBookmark(bm.id);
                                    await _loadBookmarks();
                                    setSheetState(() {});
                                  },
                                ),
                                onTap: () {
                                  Navigator.pop(ctx);
                                  if (chapterIndex >= 0) {
                                    _goToChapter(chapterIndex);
                                  }
                                },
                              );
                            },
                          ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Future<void> _handleHighlightSelection(String text) async {
    if (text.trim().isEmpty || _chapters.isEmpty) return;
    final currentChapter = _chapters[_currentChapterIndex];
    final noteController = TextEditingController();
    String selectedColor = 'yellow';

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            title: const Text('Beri Sorotan Teks', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '"$text"',
                      maxLines: 4,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Pilih Warna Sorotan:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildColorChoice('yellow', const Color(0xFFFFF176), selectedColor, (c) => setDialogState(() => selectedColor = c)),
                      _buildColorChoice('green', const Color(0xFFA5D6A7), selectedColor, (c) => setDialogState(() => selectedColor = c)),
                      _buildColorChoice('blue', const Color(0xFF90CAF9), selectedColor, (c) => setDialogState(() => selectedColor = c)),
                      _buildColorChoice('pink', const Color(0xFFF48FB1), selectedColor, (c) => setDialogState(() => selectedColor = c)),
                    ],
                  ),
                  const SizedBox(height: 14),
                  TextField(
                    controller: noteController,
                    decoration: InputDecoration(
                      labelText: 'Catatan (Opsional)',
                      hintText: 'Tulis ide atau catatan pribadi...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text('Simpan Sorotan'),
              ),
            ],
          );
        },
      ),
    );

    if (confirmed == true && mounted) {
      final repo = ref.read(highlightRepositoryProvider);
      await repo.createHighlight(
        bookId: widget.bookId,
        chapterId: currentChapter.id,
        startAnchor: text.length > 50 ? text.substring(0, 50) : text,
        endAnchor: text,
        color: selectedColor,
        note: noteController.text.trim().isNotEmpty ? noteController.text.trim() : null,
      );
      await _loadHighlights();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sorotan teks berhasil disimpan.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Widget _buildColorChoice(String colorKey, Color color, String currentKey, Function(String) onSelect) {
    final isSelected = colorKey == currentKey;
    return GestureDetector(
      onTap: () => onSelect(colorKey),
      child: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? Colors.black87 : Colors.transparent,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected ? const Icon(Icons.check, size: 20, color: Colors.black87) : null,
      ),
    );
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
          // Chapter TTS Narration button
          IconButton(
            icon: Icon(
              _isAudioPlaying ? Icons.stop_circle_rounded : Icons.headphones_rounded,
              color: _isAudioPlaying ? Colors.amber.shade700 : null,
            ),
            tooltip: _isAudioPlaying ? 'Hentikan Narasi Suara' : 'Dengarkan Bab Ini (TTS)',
            onPressed: _toggleAudioNarration,
          ),
          // View Bookmarks Sheet
          IconButton(
            icon: const Icon(Icons.collections_bookmark_outlined),
            tooltip: 'Daftar Bookmark',
            onPressed: _showBookmarksSheet,
          ),
          // Quick Add Bookmark
          IconButton(
            icon: const Icon(Icons.bookmark_add_outlined),
            tooltip: 'Tambah Bookmark Bab Ini',
            onPressed: _addCurrentBookmark,
          ),
          // Reading Theme & Size Settings
          IconButton(
            icon: const Icon(Icons.format_size),
            tooltip: 'Pengaturan Teks & Tema',
            onPressed: _showReadingSettings,
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).colorScheme.primaryContainer),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Image.asset('assets/images/logo.png', width: 28, height: 28, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 8),
                      const Text('Navigasi Pembaca', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(_book?.title ?? '', maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 12)),
                ],
              ),
            ),

            // Tab navigation for Drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              child: SegmentedButton<int>(
                segments: [
                  const ButtonSegment(value: 0, label: Text('Daftar Isi', style: TextStyle(fontSize: 10))),
                  ButtonSegment(value: 1, label: Text('Bookmark (${_bookmarks.length})', style: const TextStyle(fontSize: 10))),
                  ButtonSegment(value: 2, label: Text('Sorotan (${_highlights.length})', style: const TextStyle(fontSize: 10))),
                ],
                selected: {_drawerTabIndex},
                onSelectionChanged: (set) => setState(() => _drawerTabIndex = set.first),
              ),
            ),
            const Divider(height: 8),

            // Drawer content based on selected tab
            Expanded(
              child: _buildDrawerContent(),
            ),

            // Drawer Footer: Glosarium Link
            Container(
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade300)),
              ),
              child: ListTile(
                leading: const Icon(Icons.auto_stories_rounded, color: Colors.teal),
                title: const Text('Glosarium Istilah Buku Ini', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold)),
                subtitle: const Text('Kunci terjemahan khusus buku ini', style: TextStyle(fontSize: 11)),
                trailing: const Icon(Icons.chevron_right),
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => GlossaryScreen(
                        bookId: widget.bookId,
                        bookTitle: _book?.title,
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          SelectionArea(
            contextMenuBuilder: (context, selectableRegionState) {
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
                  ContextMenuButtonItem(
                    label: 'Beri Sorotan (Highlight)',
                    onPressed: () {
                      selectableRegionState.hideToolbar();
                      _handleHighlightSelection(text);
                    },
                  ),
                  ...selectableRegionState.contextMenuButtonItems,
                ],
              );
            },
            child: SingleChildScrollView(
              controller: _scrollController,
              padding: EdgeInsets.fromLTRB(20, 16, 20, _isAudioBarVisible ? 90 : 32),
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

          // Floating Audio Player Bar
          if (_isAudioBarVisible)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: Material(
                elevation: 6,
                borderRadius: BorderRadius.circular(16),
                color: Theme.of(context).colorScheme.primaryContainer,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  child: Row(
                    children: [
                      Icon(
                        _isAudioPlaying ? Icons.volume_up_rounded : Icons.pause_circle_rounded,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              _isAudioPlaying ? 'Memutar Narasi Bab...' : 'Narasi Dijeda',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            Text(
                              currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ),
                      // Speed toggle
                      TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          minimumSize: const Size(36, 32),
                        ),
                        onPressed: _cycleSpeechRate,
                        child: Text('${_speechRate}x', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      ),
                      // Play/Pause
                      IconButton(
                        icon: Icon(_isAudioPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded),
                        onPressed: _toggleAudioNarration,
                      ),
                      // Close
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        onPressed: _stopAudioNarration,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
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

  Widget _buildDrawerContent() {
    if (_drawerTabIndex == 0) {
      // TOC (Daftar Isi)
      return ListView.builder(
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
              style: TextStyle(fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal, fontSize: 13),
            ),
            subtitle: ch.wordCount != null ? Text('${ch.wordCount} kata', style: const TextStyle(fontSize: 11)) : null,
            onTap: () {
              Navigator.pop(context);
              _goToChapter(idx);
            },
          );
        },
      );
    } else if (_drawerTabIndex == 1) {
      // Bookmarks
      if (_bookmarks.isEmpty) {
        return const Center(
          child: Text('Belum ada penanda halaman.', style: TextStyle(fontSize: 12, color: Colors.grey)),
        );
      }
      return ListView.separated(
        itemCount: _bookmarks.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (ctx, idx) {
          final bm = _bookmarks[idx];
          final chapter = _chapters.firstWhere(
            (c) => c.id == bm.chapterId,
            orElse: () => _chapters.first,
          );
          final chIdx = _chapters.indexOf(chapter);
          return ListTile(
            dense: true,
            leading: const Icon(Icons.bookmark_rounded, color: Colors.amber),
            title: Text(bm.label ?? chapter.title ?? 'Bab ${chIdx + 1}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Bab ${chIdx + 1}', style: const TextStyle(fontSize: 11)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
              onPressed: () async {
                await ref.read(bookmarkRepositoryProvider).deleteBookmark(bm.id);
                await _loadBookmarks();
              },
            ),
            onTap: () {
              Navigator.pop(context);
              if (chIdx >= 0) _goToChapter(chIdx);
            },
          );
        },
      );
    } else {
      // Highlights
      if (_highlights.isEmpty) {
        return const Center(
          child: Text('Belum ada teks yang disorot.', style: TextStyle(fontSize: 12, color: Colors.grey)),
        );
      }
      return ListView.separated(
        itemCount: _highlights.length,
        separatorBuilder: (context, index) => const Divider(height: 1),
        itemBuilder: (ctx, idx) {
          final hl = _highlights[idx];
          final chapter = _chapters.firstWhere(
            (c) => c.id == hl.chapterId,
            orElse: () => _chapters.first,
          );
          final chIdx = _chapters.indexOf(chapter);

          Color hlColor = Colors.yellow;
          if (hl.color == 'green') hlColor = Colors.greenAccent;
          if (hl.color == 'blue') hlColor = Colors.lightBlueAccent;
          if (hl.color == 'pink') hlColor = Colors.pinkAccent;

          return ListTile(
            dense: true,
            leading: Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(color: hlColor, shape: BoxShape.circle),
            ),
            title: Text(
              '"${hl.endAnchor}"',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
            ),
            subtitle: hl.note != null
                ? Text('Catatan: ${hl.note}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w500))
                : Text('Bab ${chIdx + 1}', style: const TextStyle(fontSize: 11)),
            trailing: IconButton(
              icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
              onPressed: () async {
                await ref.read(highlightRepositoryProvider).deleteHighlight(hl.id);
                await _loadHighlights();
              },
            ),
            onTap: () {
              Navigator.pop(context);
              if (chIdx >= 0) _goToChapter(chIdx);
            },
          );
        },
      );
    }
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
