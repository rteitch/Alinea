// ignore_for_file: deprecated_member_use
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../app/theme/app_theme.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/storage/database.dart';
import '../../glossary/presentation/glossary_screen.dart';
import '../../translation/presentation/translation_history_screen.dart';
import 'reading_stats_screen.dart';
import 'translation_overlay.dart';

class ReaderScreen extends ConsumerStatefulWidget {
  final int bookId;

  const ReaderScreen({super.key, required this.bookId});

  @override
  ConsumerState<ReaderScreen> createState() => _ReaderScreenState();
}

class _ReaderScreenState extends ConsumerState<ReaderScreen> {
  // Added quick theme toggle state
  ReadingThemeMode _currentTheme = ReadingThemeMode.light;
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  int _currentChapterIndex = 0;
  List<Chapter> _chapters = [];
  Book? _book;
  bool _isLoading = true;
  double _fontSize = 16.0;
  String _currentChapterContent = '';

  // Pagination state
  int _currentPageIndex = 0;
  List<String> _pages = [];
  bool _isPaginationMode = true; // Toggle between scroll and pagination mode

  // Audio / TTS state
  bool _isAudioBarVisible = false;
  bool _isAudioPlaying = false;
  double _speechRate = 0.5;

  // Font family state
  String _fontFamily = 'default';

  // Reading timer state
  int? _currentSessionId;
  Timer? _readingTimer;
  int _elapsedSeconds = 0;

  // Bookmarks & Highlights
  List<Bookmark> _bookmarks = [];
  List<Highlight> _highlights = [];
  int _drawerTabIndex = 0; // 0: TOC, 1: Bookmarks, 2: Highlights
  bool _showTranslationTip = true;

  // Inline Page Translation
  bool _isPageTranslated = false;
  bool _isTranslatingPage = false;
  double _translationProgress = 0.0; // 0.0 to 1.0
  String _translatedPageText = '';
  bool _pageTranslationCancelled = false;

  @override
  void initState() {
    super.initState();
    _loadBookAndProgress();
    _scrollController.addListener(_onScroll);
    // Start reading session timer
    _startReadingSession();
  }

  @override
  void dispose() {
    _readingTimer?.cancel();
    _endReadingSession();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _pageController.dispose();
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  Future<void> _startReadingSession() async {
    try {
      final db = ref.read(databaseProvider);
      _currentSessionId = await db.startReadingSession(widget.bookId);
      _readingTimer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) {
          setState(() => _elapsedSeconds++);
        }
      });
    } catch (e) {
      debugPrint('[ReaderScreen] Failed to start reading session: $e');
    }
  }

  Future<void> _endReadingSession() async {
    if (_currentSessionId == null) return;
    try {
      final db = ref.read(databaseProvider);
      await db.endReadingSession(
        _currentSessionId!,
        chaptersRead: _currentChapterIndex + 1,
        wordsTranslated: 0,
      );
    } catch (e) {
      debugPrint('[ReaderScreen] Failed to end reading session: $e');
    }
  }

  String _formatElapsed(int totalSeconds) {
    final h = totalSeconds ~/ 3600;
    final m = (totalSeconds % 3600) ~/ 60;
    final s = totalSeconds % 60;
    if (h > 0) return '${h}j ${m.toString().padLeft(2, '0')}m';
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  Future<void> _loadBookAndProgress() async {
    try {
      final bookRepo = ref.read(bookRepositoryProvider);
      final book = await bookRepo.getBookById(widget.bookId);
      final chapters = await bookRepo.getChaptersByBookId(widget.bookId);
      final progress = await bookRepo.getReadingProgress(widget.bookId);

      // Load per-book settings
      final db = ref.read(databaseProvider);
      final bookSettings = await db.getBookSetting(widget.bookId);

      if (mounted) {
        setState(() {
          _book = book;
          _chapters = chapters;
          if (progress != null && chapters.isNotEmpty) {
            final idx = chapters.indexWhere((c) => c.id == progress.chapterId);
            _currentChapterIndex = idx >= 0 ? idx : 0;
          }
          // Apply per-book settings
          if (bookSettings != null) {
            _fontSize = bookSettings.fontSize;
            _isPageTranslated = bookSettings.isTranslationEnabled;
            _currentPageIndex = bookSettings.lastPageIndex;
            _fontFamily = bookSettings.fontFamily;
            // Restore per-book theme
            _currentTheme = ReadingThemeMode.values.firstWhere(
              (t) => t.name == bookSettings.readingTheme,
              orElse: () => ref.read(readingThemeModeProvider),
            );
            ref.read(readingThemeModeProvider.notifier).state = _currentTheme;
          }
        });
        await _loadCurrentChapterContent();
        await _loadBookmarks();
        await _loadHighlights();

        // Restore scroll position after content is loaded
        if (bookSettings != null && mounted) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (bookSettings.lastScrollOffset > 0 && _scrollController.hasClients) {
              _scrollController.jumpTo(bookSettings.lastScrollOffset);
            }
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Gagal memuat buku: $e')),
        );
      }
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

  Future<void> _saveBookSettings({
    double? fontSize,
    String? readingTheme,
    bool? isTranslationEnabled,
    String? translationStyle,
    String? fontFamily,
    int? lastPageIndex,
    double? lastScrollOffset,
  }) async {
    try {
      final db = ref.read(databaseProvider);
      await db.upsertBookSetting(
        bookId: widget.bookId,
        fontSize: fontSize,
        readingTheme: readingTheme,
        isTranslationEnabled: isTranslationEnabled,
        translationStyle: translationStyle,
        fontFamily: fontFamily,
        lastPageIndex: lastPageIndex,
        lastScrollOffset: lastScrollOffset,
      );
    } catch (e) {
      debugPrint('[ReaderScreen] Failed to save book settings: $e');
    }
  }

  Future<void> _loadCurrentChapterContent() async {
    if (_chapters.isEmpty) {
      if (mounted) setState(() => _isLoading = false);
      return;
    }
    // Cancel any ongoing page translation
    _pageTranslationCancelled = true;

    final currentChapter = _chapters[_currentChapterIndex];
    final bookRepo = ref.read(bookRepositoryProvider);
    final content = await bookRepo.getChapterContent(widget.bookId, currentChapter.id);
    if (mounted) {
      setState(() {
        _currentChapterContent = content;
        _isLoading = false;
        // Reset page translation state for new chapter
        _isPageTranslated = false;
        _isTranslatingPage = false;
        _translatedPageText = '';
        _translationProgress = 0.0;
        _pageTranslationCancelled = false;
        // Split content into pages for pagination
        _pages = _splitContentIntoPages(content);
        _currentPageIndex = 0;
      });
      // Jump to first page
      if (_pageController.hasClients) {
        _pageController.jumpToPage(0);
      }
    }
  }

  /// Split chapter content into page-sized chunks for pagination mode
  /// Each page aims for ~800 characters (approximately 150-200 words)
  List<String> _splitContentIntoPages(String htmlContent) {
    if (htmlContent.isEmpty) return ['Bab ini tidak memiliki konten teks.'];
    
    final cleanText = _cleanHtmlToReadableText(htmlContent);
    if (cleanText.isEmpty) return ['Bab ini tidak memiliki konten teks.'];
    
    // Split by paragraphs (double newlines)
    final paragraphs = cleanText
        .split(RegExp(r'\n\n+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();
    
    if (paragraphs.isEmpty) return [cleanText];
    
    // If total text is short enough for one page, return as-is
    if (cleanText.length <= 800) {
      return [cleanText];
    }
    
    // Build pages by grouping paragraphs up to ~800 chars per page
    final pages = <String>[];
    final currentPage = StringBuffer();
    const maxCharsPerPage = 800;
    
    for (final paragraph in paragraphs) {
      // If adding this paragraph would exceed limit, start new page
      if (currentPage.isNotEmpty && 
          (currentPage.length + paragraph.length + 2) > maxCharsPerPage) {
        pages.add(currentPage.toString().trim());
        currentPage.clear();
      }
      
      if (currentPage.isNotEmpty) {
        currentPage.write('\n\n');
      }
      currentPage.write(paragraph);
    }
    
    // Add the last page
    if (currentPage.isNotEmpty) {
      pages.add(currentPage.toString().trim());
    }
    
    return pages.isNotEmpty ? pages : [cleanText];
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

    // Save exact scroll offset for restoration
    _saveBookSettings(lastScrollOffset: currentScroll);
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
      if (!mounted) return;
      setState(() => _isAudioPlaying = false);
    } else {
      final cleanText = _isPageTranslated && _translatedPageText.isNotEmpty
          ? _translatedPageText
          : _cleanHtmlToReadableText(_currentChapterContent);
      if (cleanText.isEmpty || cleanText == 'Bab ini tidak memiliki konten teks.') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Bab ini tidak memiliki teks untuk dibacakan.')),
        );
        return;
      }
      final audioLang = _isPageTranslated ? 'id' : (_book?.sourceLanguage ?? 'en');
      setState(() {
        _isAudioBarVisible = true;
        _isAudioPlaying = true;
      });
      try {
        await tts.speak(
          cleanText,
          language: audioLang,
          rate: _speechRate,
        );
      } catch (e) {
        if (mounted) {
          setState(() {
            _isAudioPlaying = false;
            _isAudioBarVisible = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Gagal memutar audio: $e')),
          );
        }
      }
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
      final cleanText = _isPageTranslated && _translatedPageText.isNotEmpty
          ? _translatedPageText
          : _cleanHtmlToReadableText(_currentChapterContent);
      final audioLang = _isPageTranslated ? 'id' : (_book?.sourceLanguage ?? 'en');
      tts.speak(
        cleanText,
        language: audioLang,
        rate: _speechRate,
      );
    }
  }

  // --- Bookmarks & Highlights Actions ---
  Future<void> _addCurrentBookmark() async {
    if (_chapters.isEmpty) return;
    final currentChapter = _chapters[_currentChapterIndex];
    
    // Show note input dialog
    final noteController = TextEditingController();
    final result = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tambah Penanda'),
        content: TextField(
          controller: noteController,
          decoration: const InputDecoration(
            labelText: 'Catatan (opsional)',
            hintText: 'Tulis catatan untuk bookmark ini...',
            border: OutlineInputBorder(),
          ),
          maxLines: 3,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, noteController.text),
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
    
    final note = result?.isNotEmpty == true ? result : null;
    
    final bookmarkRepo = ref.read(bookmarkRepositoryProvider);
    await bookmarkRepo.addBookmark(
      bookId: widget.bookId,
      chapterId: currentChapter.id,
      cfi: '/chapter/$_currentChapterIndex',
      label: currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}',
      note: note,
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
                                Icon(Icons.bookmark_border_rounded, size: 48, color: Theme.of(context).colorScheme.onSurface.withAlpha(80)),
                                const SizedBox(height: 8),
                                Text('Belum ada penanda halaman.', style: TextStyle(fontSize: 13, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text('Disimpan pada $dateStr', style: const TextStyle(fontSize: 11)),
                                    if (bm.note != null && bm.note!.isNotEmpty)
                                      Padding(
                                        padding: const EdgeInsets.only(top: 2),
                                        child: Text(
                                          bm.note!,
                                          style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                  ],
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.delete_outline, size: 18, color: Theme.of(context).colorScheme.error),
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
                      color: Theme.of(context).colorScheme.surfaceContainerHighest,
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
            color: isSelected ? Theme.of(context).colorScheme.onSurface : Colors.transparent,
            width: isSelected ? 3 : 1,
          ),
        ),
        child: isSelected ? Icon(Icons.check, size: 20, color: Theme.of(context).colorScheme.onSurface) : null,
      ),
    );
  }

  void _handleTranslateSelection(String selectedText) {
    final clean = selectedText.trim();
    if (clean.isEmpty) return;

    final targetLang = ref.read(targetLanguageProvider);
    final autoDetect = ref.read(autoDetectLanguageProvider);
    final detectionLangs = ref.read(detectionLanguagesProvider);
    // When auto-detect is enabled, use first language in list as primary
    final sourceLang = autoDetect
        ? (detectionLangs.isNotEmpty ? detectionLangs.first : '')
        : (_book?.sourceLanguage ?? 'en');

    TranslationOverlay.show(
      context,
      bookId: widget.bookId,
      selectedText: clean,
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );
  }

  void _handleTranslateChapter() {
    final cleanText = _cleanHtmlToReadableText(_currentChapterContent);
    if (cleanText.isEmpty) return;
    final targetLang = ref.read(targetLanguageProvider);
    final autoDetect = ref.read(autoDetectLanguageProvider);
    final detectionLangs = ref.read(detectionLanguagesProvider);
    // When auto-detect is enabled, use first language in list as primary
    final sourceLang = autoDetect
        ? (detectionLangs.isNotEmpty ? detectionLangs.first : '')
        : (_book?.sourceLanguage ?? 'en');

    // Pass full chapter text - providers handle chunking internally
    // (FossCloudProvider splits by 500-char chunks, LibreTranslate handles full text)
    TranslationOverlay.show(
      context,
      bookId: widget.bookId,
      selectedText: cleanText,
      sourceLanguage: sourceLang,
      targetLanguage: targetLang,
    );
  }

  /// Translates the entire current chapter inline (paragraph by paragraph).
  Future<void> _translatePageInline() async {
    if (_isTranslatingPage) {
      // Cancel ongoing translation and revert to original
      setState(() {
        _pageTranslationCancelled = true;
        _isTranslatingPage = false;
        _isPageTranslated = false;
        _translationProgress = 0.0;
        _translatedPageText = '';
      });
      _saveBookSettings(isTranslationEnabled: false);
      return;
    }

    if (_isPageTranslated) {
      // Toggle back to original text
      setState(() {
        _isPageTranslated = false;
        _translatedPageText = '';
      });
      _saveBookSettings(isTranslationEnabled: false);
      return;
    }

    // Start translating
    final rawText = _cleanHtmlToReadableText(_currentChapterContent);
    if (rawText.isEmpty || rawText == 'Bab ini tidak memiliki konten teks.') return;

    final targetLang = ref.read(targetLanguageProvider);
    final autoDetect = ref.read(autoDetectLanguageProvider);
    final detectionLangs = ref.read(detectionLanguagesProvider);
    // When auto-detect is enabled, use first language in list as primary
    final sourceLang = autoDetect
        ? (detectionLangs.isNotEmpty ? detectionLangs.first : '')
        : (_book?.sourceLanguage ?? 'en');
    final coordinator = ref.read(translationCoordinatorProvider);

    // Split into paragraphs (non-empty)
    final paragraphs = rawText
        .split(RegExp(r'\n\n+'))
        .map((p) => p.trim())
        .where((p) => p.isNotEmpty)
        .toList();

    if (paragraphs.isEmpty) return;

    setState(() {
      _isTranslatingPage = true;
      _isPageTranslated = false;
      _pageTranslationCancelled = false;
      _translationProgress = 0.0;
      _translatedPageText = '';
    });

    final translatedParagraphs = <String>[];
    int totalFailures = 0;
    String? firstErrorMessage;

    const batchSize = 3;
    for (int i = 0; i < paragraphs.length; i += batchSize) {
      // Check cancellation BEFORE starting next batch
      if (_pageTranslationCancelled || !mounted) break;

      final batch = paragraphs.skip(i).take(batchSize).toList();
      final batchFutures = batch.map((p) async {
        // Check cancellation INSIDE each future to abort early
        if (_pageTranslationCancelled) return null;
        
        try {
          final result = await coordinator.translateText(
            bookId: widget.bookId,
            text: p,
            sourceLanguage: sourceLang,
            targetLanguage: targetLang,
          );
          // Check again after await completes
          if (_pageTranslationCancelled) return null;
          return result.translatedText;
        } catch (e) {
          // Capture the first error message for user feedback
          if (!_pageTranslationCancelled && firstErrorMessage == null) {
            String rawMsg = e.toString();
            rawMsg = rawMsg
                .replaceAll(RegExp(r'^TranslationException:\s*'), '')
                .replaceAll(RegExp(r'^Exception:\s*'), '')
                .trim();
            firstErrorMessage = rawMsg.isNotEmpty ? rawMsg : 'Gagal menerjemahkan.';
            debugPrint('Translation error for paragraph: $firstErrorMessage');
          }
          return null; // Return null to indicate failure
        }
      }).toList();

      final batchResults = await Future.wait(batchFutures);
      
      // Filter out cancelled/failed results and track failures
      final batchSuccesses = <String>[];
      final batchFailures = <int>[];
      for (int j = 0; j < batchResults.length; j++) {
        if (batchResults[j] == null) {
          // Either cancelled or failed - skip this paragraph
          if (!_pageTranslationCancelled) {
            batchFailures.add(i + j);
          }
        } else {
          batchSuccesses.add(batchResults[j]!);
        }
      }
      
      translatedParagraphs.addAll(batchSuccesses);
      totalFailures += batchFailures.length;

      // Circuit breaker: if first batch entirely fails, stop immediately
      // Don't waste time hammering a failing server
      if (batchSuccesses.isEmpty && batchFailures.isNotEmpty && i == 0) {
        debugPrint('[Translation] Circuit breaker: first batch failed, aborting remaining ${paragraphs.length - batchSize} paragraphs');
        // Add remaining paragraphs as untranslated
        for (var k = batchSize; k < paragraphs.length; k++) {
          translatedParagraphs.add('[Gagal menerjemahkan] ${paragraphs[k]}');
          totalFailures++;
        }
        break;
      }

      // If there were failures (not due to cancellation), add original text as fallback
      if (batchFailures.isNotEmpty && !_pageTranslationCancelled) {
        for (final failIdx in batchFailures) {
          if (failIdx < paragraphs.length) {
            translatedParagraphs.add('[Gagal menerjemahkan] ${paragraphs[failIdx]}');
          }
        }
      }

      if (mounted && !_pageTranslationCancelled) {
        setState(() {
          _translationProgress = translatedParagraphs.length / paragraphs.length;
          _translatedPageText = translatedParagraphs.join('\n\n');
          _isPageTranslated = true;
        });
        _saveBookSettings(isTranslationEnabled: true);
      }
    }

    if (mounted && !_pageTranslationCancelled) {
      setState(() {
        _isTranslatingPage = false;
        _isPageTranslated = true;
        _translationProgress = 1.0;
        _translatedPageText = translatedParagraphs.join('\n\n');
      });
      _saveBookSettings(isTranslationEnabled: true);
      
      // Show feedback if there were failures — include actual error message
      if (totalFailures > 0 && mounted) {
        final errorMsg = firstErrorMessage ?? 'Gagal menerjemahkan.';
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('$totalFailures paragraf gagal: $errorMsg'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  ReadingThemeMode _nextTheme(ReadingThemeMode current) {
    switch (current) {
      case ReadingThemeMode.light:
        return ReadingThemeMode.sepia;
      case ReadingThemeMode.sepia:
        return ReadingThemeMode.dark;
      case ReadingThemeMode.dark:
        return ReadingThemeMode.amoled;
      case ReadingThemeMode.amoled:
        return ReadingThemeMode.light;
      case ReadingThemeMode.system:
        return ReadingThemeMode.light;
    }
  }

  IconData _getThemeIcon(ReadingThemeMode theme) {
    switch (theme) {
      case ReadingThemeMode.light:
        return Icons.light_mode_rounded;
      case ReadingThemeMode.sepia:
        return Icons.wb_sunny_rounded;
      case ReadingThemeMode.dark:
        return Icons.dark_mode_rounded;
      case ReadingThemeMode.amoled:
        return Icons.brightness_1_rounded;
      case ReadingThemeMode.system:
        return Icons.brightness_auto_rounded;
    }
  }

  String _getThemeName(ReadingThemeMode theme) {
    switch (theme) {
      case ReadingThemeMode.light:
        return 'Light';
      case ReadingThemeMode.sepia:
        return 'Sepia';
      case ReadingThemeMode.dark:
        return 'Dark';
      case ReadingThemeMode.amoled:
        return 'AMOLED';
      case ReadingThemeMode.system:
        return 'Sistem';
    }
  }

  void _showSearchInBook() {
    final searchController = TextEditingController();
    List<Map<String, dynamic>> results = [];

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setSheetState) {
            return DraggableScrollableSheet(
              initialChildSize: 0.6,
              minChildSize: 0.3,
              maxChildSize: 0.9,
              expand: false,
              builder: (context, scrollController) {
                return Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Handle
                      Container(
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Title
                      const Row(
                        children: [
                          Icon(Icons.search_rounded),
                          SizedBox(width: 8),
                          Text('Cari dalam Buku', style: TextStyle(fontWeight: FontWeight.bold)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Search field
                      TextField(
                        controller: searchController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Masukkan kata kunci...',
                          prefixIcon: const Icon(Icons.search, size: 20),
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.clear, size: 18),
                            onPressed: () {
                              searchController.clear();
                              setSheetState(() => results = []);
                            },
                          ),
                          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        onSubmitted: (query) async {
                          if (query.trim().isEmpty) return;
                          final searchResults = <Map<String, dynamic>>[];
                          final bookRepo = ref.read(bookRepositoryProvider);
                          for (int i = 0; i < _chapters.length; i++) {
                            final chapter = _chapters[i];
                            try {
                              final htmlContent = await bookRepo.getChapterContent(widget.bookId, chapter.id);
                              // Strip HTML tags for text search
                              final plainText = htmlContent
                                  .replaceAll(RegExp(r'<[^>]*>'), '')
                                  .toLowerCase();
                              final queryLower = query.toLowerCase();
                              if (plainText.contains(queryLower)) {
                                // Find the context around the match
                                final idx = plainText.indexOf(queryLower);
                                final start = (idx - 30).clamp(0, plainText.length);
                                final end = (idx + query.length + 30).clamp(0, plainText.length);
                                final snippet = '...${plainText.substring(start, end)}...';
                                searchResults.add({
                                  'chapterIndex': i,
                                  'chapterTitle': chapter.title ?? 'Bab ${i + 1}',
                                  'snippet': snippet,
                                });
                              }
                            } catch (_) {
                              // Skip chapters that fail to load
                            }
                          }
                          setSheetState(() => results = searchResults);
                        },
                      ),
                      const SizedBox(height: 12),
                      // Results count
                      if (results.isNotEmpty)
                        Text(
                          '${results.length} hasil ditemukan',
                          style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                        ),
                      const SizedBox(height: 8),
                      // Results list
                      Expanded(
                        child: results.isEmpty
                            ? Center(
                                child: Text(
                                  'Ketik kata kunci untuk mencari',
                                  style: TextStyle(color: Colors.grey.shade400),
                                ),
                              )
                            : ListView.separated(
                                controller: scrollController,
                                itemCount: results.length,
                                separatorBuilder: (_, __) => const Divider(height: 1),
                                itemBuilder: (context, idx) {
                                  final r = results[idx];
                                  return ListTile(
                                    leading: CircleAvatar(
                                      radius: 16,
                                      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
                                      child: Icon(Icons.menu_book_rounded, size: 16, color: Theme.of(context).colorScheme.secondary),
                                    ),
                                    title: Text(
                                      r['chapterTitle'],
                                      style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                                    ),
                                    subtitle: Text(
                                      r['snippet'],
                                      style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    onTap: () {
                                      Navigator.pop(ctx);
                                      // Navigate to the chapter
                                      setState(() {
                                        _currentChapterIndex = r['chapterIndex'];
                                      });
                                      _loadCurrentChapterContent();
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
      },
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
                            _saveBookSettings(fontSize: val);
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
                  // Font Family Selection
                  const Text('Jenis Huruf:', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13)),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      _buildFontChip('Default', 'default'),
                      _buildFontChip('Serif', 'serif'),
                      _buildFontChip('Sans-Serif', 'sans'),
                      _buildFontChip('Monospace', 'mono'),
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
                color: isSelected ? Theme.of(context).colorScheme.primary : border,
                width: isSelected ? 3 : 1,
              ),
            ),
            child: isSelected ? Icon(Icons.check, size: 20, color: Theme.of(context).colorScheme.onPrimary) : null,
          ),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 11)),
        ],
      ),
    );
  }

  Widget _buildFontChip(String label, String value) {
    final isSelected = _fontFamily == value;
    return FilterChip(
      label: Text(label, style: TextStyle(fontSize: 12, fontFamily: _getFontFamily(value))),
      selected: isSelected,
      onSelected: (_) {
        setState(() => _fontFamily = value);
        _saveBookSettings(fontFamily: value);
      },
    );
  }

  String _getFontFamily(String value) {
    switch (value) {
      case 'serif':
        return 'serif';
      case 'sans':
        return 'sans-serif';
      case 'mono':
        return 'monospace';
      default:
        return '';
    }
  }

  Widget _buildHighlightedContent(String text, TextStyle baseStyle) {
    if (_chapters.isEmpty) return SelectableText(text, style: baseStyle);
    final currentChapter = _chapters[_currentChapterIndex];
    final chapterHighlights = _highlights.where((h) => h.chapterId == currentChapter.id).toList();

    if (chapterHighlights.isEmpty) {
      return SelectableText(text, style: baseStyle);
    }

    // Sort highlights by length descending to match longer phrases first
    final sortedHls = List<Highlight>.from(chapterHighlights)
      ..sort((a, b) => b.endAnchor.length.compareTo(a.endAnchor.length));

    try {
      final patterns = sortedHls.map((h) => RegExp.escape(h.endAnchor)).join('|');
      final regExp = RegExp(patterns);
      final matches = regExp.allMatches(text);

      if (matches.isEmpty) {
        return SelectableText(text, style: baseStyle);
      }

      final spans = <TextSpan>[];
      int lastEnd = 0;

      for (final match in matches) {
        if (match.start > lastEnd) {
          spans.add(TextSpan(text: text.substring(lastEnd, match.start), style: baseStyle));
        }

        final matchedText = text.substring(match.start, match.end);
        final matchingHl = sortedHls.firstWhere(
          (h) => h.endAnchor == matchedText,
          orElse: () => sortedHls.first,
        );

        Color hlColor;
        switch (matchingHl.color) {
          case 'green':
            hlColor = const Color(0xFFA5D6A7).withValues(alpha: 0.65);
            break;
          case 'blue':
            hlColor = const Color(0xFF90CAF9).withValues(alpha: 0.65);
            break;
          case 'pink':
            hlColor = const Color(0xFFF48FB1).withValues(alpha: 0.65);
            break;
          default:
            hlColor = const Color(0xFFFFF59D).withValues(alpha: 0.85);
        }

        spans.add(TextSpan(
          text: matchedText,
          style: baseStyle.copyWith(backgroundColor: hlColor),
        ));

        lastEnd = match.end;
      }

      if (lastEnd < text.length) {
        spans.add(TextSpan(text: text.substring(lastEnd), style: baseStyle));
      }

      return SelectableText.rich(
        TextSpan(children: spans),
      );
    } catch (_) {
      return SelectableText(text, style: baseStyle);
    }
  }

  Future<void> _handleExportNotes() async {
    final now = DateTime.now();
    final glossaryRepo = ref.read(glossaryRepositoryProvider);
    final terms = await glossaryRepo.getTerms(bookId: widget.bookId);

    final sb = StringBuffer();
    sb.writeln('# Alinea Reader — Catatan & Sorotan');
    sb.writeln('**Buku:** ${_book?.title ?? ""}');
    if (_book?.author != null) sb.writeln('**Penulis:** ${_book!.author}');
    sb.writeln('**Tanggal Ekspor:** ${now.day}/${now.month}/${now.year}');
    sb.writeln('\n---\n');

    sb.writeln('## 🎨 Sorotan Teks & Catatan (${_highlights.length})');
    if (_highlights.isEmpty) {
      sb.writeln('_Tidak ada teks yang disorot._\n');
    } else {
      for (final hl in _highlights) {
        final ch = _chapters.where((c) => c.id == hl.chapterId).firstOrNull;
        final chTitle = ch?.title ?? 'Bab';
        sb.writeln('> "${hl.endAnchor}"');
        sb.writeln('- **Bab:** $chTitle | **Warna:** ${hl.color}');
        if (hl.note != null && hl.note!.isNotEmpty) {
          sb.writeln('- **Catatan:** ${hl.note}');
        }
        sb.writeln('');
      }
    }

    sb.writeln('## 🔖 Penanda Halaman / Bookmarks (${_bookmarks.length})');
    if (_bookmarks.isEmpty) {
      sb.writeln('_Tidak ada penanda halaman._\n');
    } else {
      for (final bm in _bookmarks) {
        final ch = _chapters.where((c) => c.id == bm.chapterId).firstOrNull;
        sb.writeln('- ${bm.label ?? ch?.title ?? "Bab"} (${bm.createdAt.day}/${bm.createdAt.month}/${bm.createdAt.year})');
      }
      sb.writeln('');
    }

    sb.writeln('## 📖 Glosarium Istilah Buku Ini (${terms.length})');
    if (terms.isEmpty) {
      sb.writeln('_Belum ada istilah khusus._\n');
    } else {
      for (final t in terms) {
        sb.writeln('- **${t.sourceTerm}** → ${t.preferredTranslation} (${t.sourceLanguage.toUpperCase()} → ${t.targetLanguage.toUpperCase()})');
      }
      sb.writeln('');
    }

    final exportText = sb.toString();

    if (!mounted) return;
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(20),
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.description_rounded, color: Theme.of(context).colorScheme.tertiary),
                    SizedBox(width: 8),
                    Text('Ekspor Catatan & Glosarium', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                  ],
                ),
                IconButton(icon: const Icon(Icons.close), onPressed: () => Navigator.pop(ctx)),
              ],
            ),
            const Divider(),
            Expanded(
              child: SingleChildScrollView(
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: SelectableText(
                    exportText,
                    style: const TextStyle(fontFamily: 'monospace', fontSize: 12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 14),
            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                icon: const Icon(Icons.copy_rounded),
                label: const Text('Salin Semua Catatan (Markdown) ke Clipboard'),
                onPressed: () {
                  Clipboard.setData(ClipboardData(text: exportText));
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Seluruh catatan dan glosarium berhasil disalin ke clipboard!'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text(
                'Membuka buku & memuat bab...',
                style: TextStyle(fontSize: 14, color: Theme.of(context).colorScheme.onSurfaceVariant),
              ),
            ],
          ),
        ),
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
              style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              currentChapter.title ?? 'Bab ${_currentChapterIndex + 1}',
              style: TextStyle(
                fontSize: 11,
                color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            if (_elapsedSeconds > 0)
              Text(
                '⏱ ${_formatElapsed(_elapsedSeconds)}',
                style: TextStyle(
                  fontSize: 10,
                  color: Theme.of(context).colorScheme.tertiary,
                ),
              ),
          ],
        ),
        actions: [
          // Quick Theme Toggle
          IconButton(
            icon: Icon(_getThemeIcon(_currentTheme), size: 20),
            tooltip: 'Ganti Tema (${_getThemeName(_currentTheme)})',
            onPressed: () {
              setState(() {
                _currentTheme = _nextTheme(_currentTheme);
              });
              ref.read(readingThemeModeProvider.notifier).state = _currentTheme;
              ref.read(appSettingsProvider.notifier).save(
                    ref.read(appSettingsProvider).copyWith(readingTheme: _currentTheme.name),
                  );
              // Persist per-book setting
              if (_book?.id != null) {
                final bookId = _book!.id;
                ref.read(databaseProvider).upsertBookSetting(
                      bookId: bookId,
                      readingTheme: _currentTheme.name,
                    );
              }
            },
          ),
          // Reading Stats
          IconButton(
            icon: const Icon(Icons.bar_chart_rounded, size: 20),
            tooltip: 'Statistik Membaca',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ReadingStatsScreen(
                    bookId: widget.bookId,
                    bookTitle: _book?.title ?? '',
                  ),
                ),
              );
            },
          ),
          // Search in Book
          IconButton(
            icon: const Icon(Icons.search_rounded, size: 20),
            tooltip: 'Cari dalam Buku',
            onPressed: _showSearchInBook,
          ),
          // Inline Page Translation Toggle (Terjemahkan Langsung Halaman Ini)
          IconButton(
            icon: _isTranslatingPage
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : Icon(
                    _isPageTranslated ? Icons.translate_rounded : Icons.g_translate_rounded,
                    color: _isPageTranslated ? Theme.of(context).colorScheme.primary : null,
                  ),
            tooltip: _isPageTranslated ? 'Kembali ke Teks Asli' : 'Terjemahkan Langsung Halaman Ini',
            onPressed: _translatePageInline,
          ),
          // Chapter TTS Narration button
          IconButton(
            icon: Icon(
              _isAudioPlaying ? Icons.stop_circle_rounded : Icons.headphones_rounded,
              color: _isAudioPlaying ? Theme.of(context).colorScheme.tertiary : null,
            ),
            tooltip: _isAudioPlaying ? 'Hentikan Narasi Suara' : 'Dengarkan Bab Ini (TTS)',
            onPressed: _toggleAudioNarration,
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
          // Overflow Menu for Secondary Actions
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert_rounded),
            tooltip: 'Opsi Tambahan',
            onSelected: (val) {
              switch (val) {
                case 'translate_inline':
                  _translatePageInline();
                  break;
                case 'translate':
                  _handleTranslateChapter();
                  break;
                case 'bookmarks':
                  _showBookmarksSheet();
                  break;
                case 'toggle_pagination':
                  setState(() => _isPaginationMode = !_isPaginationMode);
                  break;
                case 'export':
                  _handleExportNotes();
                  break;
              }
            },
            itemBuilder: (ctx) => [
              PopupMenuItem(
                value: 'translate_inline',
                child: Row(
                  children: [
                    Icon(
                      _isPageTranslated ? Icons.undo_rounded : Icons.translate_rounded,
                      size: 18,
color: _isPageTranslated ? Theme.of(context).colorScheme.primary : null,
                    ),
                    const SizedBox(width: 10),
                    Text(_isPageTranslated ? 'Tampilkan Teks Asli' : 'Terjemahkan Langsung Halaman'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'translate',
                child: Row(
                  children: [
                    Icon(Icons.open_in_new_rounded, size: 18),
                    SizedBox(width: 10),
                    Text('Buka Panel Terjemahan'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'bookmarks',
                child: Row(
                  children: [
                    const Icon(Icons.collections_bookmark_outlined, size: 18),
                    const SizedBox(width: 10),
                    const Text('Daftar Penanda Halaman'),
                  ],
                ),
              ),
              PopupMenuItem(
                value: 'toggle_pagination',
                child: Row(
                  children: [
                    Icon(
                      _isPaginationMode ? Icons.view_stream_rounded : Icons.view_carousel_rounded,
                      size: 18,
                    ),
                    const SizedBox(width: 10),
                    Text(_isPaginationMode ? 'Mode Gulir (Scroll)' : 'Mode Halaman (Paginate)'),
                  ],
                ),
              ),
              const PopupMenuItem(
                value: 'export',
                child: Row(
                  children: [
                    Icon(Icons.share_outlined, size: 18),
                    SizedBox(width: 10),
                    Text('Ekspor Catatan & Glosarium'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      drawer: Drawer(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(16, MediaQuery.of(context).padding.top + 16, 16, 16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(8),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withAlpha(40),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Image.asset('assets/images/logo.png', width: 26, height: 26, fit: BoxFit.cover),
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'Navigasi Pembaca',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                          color: Theme.of(context).colorScheme.onPrimary,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _book?.title ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Theme.of(context).colorScheme.onPrimary.withAlpha(220),
                    ),
                  ),
                ],
              ),
            ),

            // Tab navigation for Drawer
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: SegmentedButton<int>(
                style: SegmentedButton.styleFrom(
                  selectedBackgroundColor: Theme.of(context).colorScheme.primary,
                  selectedForegroundColor: Theme.of(context).colorScheme.onPrimary,
                  foregroundColor: Theme.of(context).colorScheme.onSurface,
                  side: BorderSide(color: Theme.of(context).colorScheme.outline.withAlpha(120)),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                segments: [
                  const ButtonSegment(value: 0, label: Text('Daftar Isi', style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600))),
                  ButtonSegment(value: 1, label: Text('Bookmark (${_bookmarks.length})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600))),
                  ButtonSegment(value: 2, label: Text('Sorotan (${_highlights.length})', style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.w600))),
                ],
                selected: {_drawerTabIndex},
                onSelectionChanged: (set) => setState(() => _drawerTabIndex = set.first),
              ),
            ),
            Divider(height: 8, color: Theme.of(context).colorScheme.outlineVariant.withAlpha(80)),

            // Drawer content based on selected tab
            Expanded(
              child: _buildDrawerContent(),
            ),

            // Drawer Footer: Glosarium Link
            SafeArea(
              top: false,
              child: Container(
                decoration: BoxDecoration(
                  border: Border(top: BorderSide(color: Theme.of(context).colorScheme.outlineVariant.withAlpha(120))),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.history_edu_rounded, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Riwayat Terjemahan & Kosakata', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Catatan kata yang pernah diterjemahkan', style: TextStyle(fontSize: 10)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const TranslationHistoryScreen()),
                        );
                      },
                    ),
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.auto_stories_rounded, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Glosarium Istilah Buku Ini', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Kunci terjemahan khusus buku ini', style: TextStyle(fontSize: 10)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
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
                    ListTile(
                      dense: true,
                      leading: Icon(Icons.share_outlined, color: Theme.of(context).colorScheme.primary),
                      title: const Text('Ekspor Catatan & Glosarium', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                      subtitle: const Text('Simpan ke format Markdown / Teks', style: TextStyle(fontSize: 10)),
                      trailing: const Icon(Icons.chevron_right, size: 16),
                      onTap: () {
                        Navigator.pop(context);
                        _handleExportNotes();
                      },
                    ),
                  ],
                ),
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
            child: _isPaginationMode
                ? _buildPaginationView()
                : _buildScrollView(),
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
                        tooltip: _isAudioPlaying ? 'Jeda Narasi' : 'Putar Narasi',
                        onPressed: _toggleAudioNarration,
                      ),
                      // Close
                      IconButton(
                        icon: const Icon(Icons.close_rounded, size: 18),
                        tooltip: 'Hentikan Narasi',
                        onPressed: _stopAudioNarration,
                      ),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
      bottomNavigationBar: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Chapter progress bar
          LinearProgressIndicator(
            value: _chapters.isEmpty ? 0 : (_currentChapterIndex + 1) / _chapters.length,
            minHeight: 2.5,
            backgroundColor: Theme.of(context).colorScheme.surfaceContainerHighest,
            color: Theme.of(context).colorScheme.primary,
          ),
          Container(
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
        child: _isPaginationMode
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Previous page button
                  IconButton(
                    icon: const Icon(Icons.chevron_left),
                    tooltip: 'Halaman Sebelumnya',
                    onPressed: _currentPageIndex > 0
                        ? () => _pageController.previousPage(
                              duration: const Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            )
                        : null,
                  ),
                  // Page indicator + Chapter info
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Hal ${_currentPageIndex + 1}/${_pages.length}',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
                        ),
                        Text(
                          'Bab ${_currentChapterIndex + 1}/${_chapters.length}',
                          style: TextStyle(
                            fontSize: 10,
                            color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
                          ),
                        ),
                      ],
                    ),
                  ),
                  // Next page / Next chapter button
                  if (_currentPageIndex < _pages.length - 1)
                    IconButton(
                      icon: const Icon(Icons.chevron_right),
                      tooltip: 'Halaman Berikutnya',
                      onPressed: () => _pageController.nextPage(
                            duration: const Duration(milliseconds: 300),
                            curve: Curves.easeInOut,
                          ),
                    )
                  else
                    IconButton(
                      icon: const Icon(Icons.skip_next_rounded),
                      tooltip: 'Bab Berikutnya',
                      onPressed: _currentChapterIndex < _chapters.length - 1
                          ? () => _goToChapter(_currentChapterIndex + 1)
                          : null,
                    ),
                ],
              )
            : Row(
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
        ],
      ),
    );
  }

  /// Build the pagination view using PageView
  Widget _buildPaginationView() {
    final currentChapter = _chapters[_currentChapterIndex];
    
    return Column(
      children: [
        // Translation status bars (same as scroll view)
        if (_showTranslationTip)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withAlpha(18),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(50),
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.touch_app_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '💡 Tahan & seleksi teks untuk menerjemahkan atau memberi sorotan.',
                    style: TextStyle(
                      fontSize: 12,
                      height: 1.35,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                    ),
                  ),
                ),
                InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => setState(() => _showTranslationTip = false),
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Icon(Icons.close, size: 16, color: Theme.of(context).colorScheme.onSurface.withAlpha(140)),
                  ),
                ),
              ],
            ),
          ),
        if (_isTranslatingPage)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer.withAlpha(90),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: Theme.of(context).colorScheme.primary.withAlpha(60),
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const SizedBox(
                          width: 14,
                          height: 14,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Menerjemahkan halaman... (${(_translationProgress * 100).toInt()}%)',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                    InkWell(
                      onTap: _translatePageInline,
                      child: Text(
                        'Batal',
                        style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: _translationProgress > 0 ? _translationProgress : null,
                    minHeight: 4,
                  ),
                ),
              ],
            ),
          ),
        if (_isPageTranslated && !_isTranslatingPage)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primaryContainer,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha(80)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.check_circle_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                    const SizedBox(width: 8),
                    Text(
                      'Teks Diterjemahkan',
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                    ),
                  ],
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    minimumSize: Size.zero,
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  icon: const Icon(Icons.undo_rounded, size: 14),
                  label: const Text('Teks Asli', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                  onPressed: _translatePageInline,
                ),
              ],
            ),
          ),
        // Chapter title (only on first page)
        if (_currentPageIndex == 0 && currentChapter.title != null)
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
            child: Text(
              currentChapter.title!,
              style: TextStyle(
                fontSize: _fontSize + 6,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ),
        // PageView for paginated content
        Expanded(
          child: PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) {
              setState(() => _currentPageIndex = index);
              // Update reading progress based on page position
              final pct = _pages.length > 1 ? index / (_pages.length - 1) : 0.0;
              final bookRepo = ref.read(bookRepositoryProvider);
              bookRepo.updateReadingProgress(
                bookId: widget.bookId,
                chapterId: currentChapter.id,
                scrollPct: pct.clamp(0.0, 1.0),
              );
            },
            itemBuilder: (context, pageIndex) {
              final pageContent = _isPageTranslated && _translatedPageText.isNotEmpty
                  ? _getTranslatedPageContent(pageIndex)
                  : _pages[pageIndex];
              
              return SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                child: _buildHighlightedContent(
                  pageContent,
                  TextStyle(
                    fontSize: _fontSize,
                    height: 1.65,
                    letterSpacing: 0.15,
                  ),
                ),
              );
            },
          ),
        ),
        // Page indicator
        Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Text(
            'Halaman ${_currentPageIndex + 1} dari ${_pages.length}',
            style: TextStyle(
              fontSize: 12,
              color: Theme.of(context).colorScheme.onSurface.withAlpha(150),
            ),
          ),
        ),
      ],
    );
  }

  /// Build the traditional scroll view
  Widget _buildScrollView() {
    final currentChapter = _chapters[_currentChapterIndex];
    
    return SingleChildScrollView(
      controller: _scrollController,
      padding: EdgeInsets.fromLTRB(20, 16, 20, _isAudioBarVisible ? 90 : 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (_showTranslationTip)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary.withAlpha(18),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(50),
                ),
              ),
              child: Row(
                children: [
                  Icon(Icons.touch_app_rounded, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      '💡 Tahan & seleksi teks mana saja untuk menerjemahkan (Alinea) atau memberi sorotan warna.',
                      style: TextStyle(
                        fontSize: 12,
                        height: 1.35,
                        color: Theme.of(context).colorScheme.onSurface.withAlpha(200),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(12),
                    onTap: () => setState(() => _showTranslationTip = false),
                    child: Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: Icon(Icons.close, size: 16, color: Theme.of(context).colorScheme.onSurface.withAlpha(140)),
                    ),
                  ),
                ],
              ),
            ),
          if (_isTranslatingPage)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer.withAlpha(90),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withAlpha(60),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const SizedBox(
                            width: 14,
                            height: 14,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Menerjemahkan halaman... (${(_translationProgress * 100).toInt()}%)',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      InkWell(
                        onTap: _translatePageInline,
                        child: Text(
                          'Batal',
                          style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.error, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: _translationProgress > 0 ? _translationProgress : null,
                      minHeight: 4,
                    ),
                  ),
                ],
              ),
            ),
          if (_isPageTranslated && !_isTranslatingPage)
            Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Theme.of(context).colorScheme.primary.withAlpha(80)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.check_circle_rounded, size: 18, color: Theme.of(context).colorScheme.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Teks Diterjemahkan ke Bahasa Indonesia',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.primary),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      minimumSize: Size.zero,
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    icon: const Icon(Icons.undo_rounded, size: 14),
                    label: const Text('Teks Asli', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                    onPressed: _translatePageInline,
                  ),
                ],
              ),
            ),
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
          _buildHighlightedContent(
            _isPageTranslated && _translatedPageText.isNotEmpty
                ? _translatedPageText
                : _cleanHtmlToReadableText(_currentChapterContent),
            TextStyle(
              fontSize: _fontSize,
              height: 1.65,
              letterSpacing: 0.15,
            ),
          ),
          const SizedBox(height: 60),
        ],
      ),
    );
  }

  /// Get translated content for a specific page
  String _getTranslatedPageContent(int pageIndex) {
    if (pageIndex < 0 || pageIndex >= _pages.length) return '';
    
    // If translation covers all pages, return the translated page
    final allTranslatedParagraphs = _translatedPageText.split('\n\n');
    
    // Calculate which paragraphs belong to this page
    int startIdx = 0;
    for (int i = 0; i < pageIndex; i++) {
      startIdx += _pages[i].split('\n\n').length;
    }
    
    final pageCount = _pages[pageIndex].split('\n\n').length;
    final pageTranslated = allTranslatedParagraphs.skip(startIdx).take(pageCount).join('\n\n');
    
    return pageTranslated.isNotEmpty ? pageTranslated : _pages[pageIndex];
  }

  Widget _buildDrawerContent() {
    if (_drawerTabIndex == 0) {
      // TOC (Daftar Isi)
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 6),
        itemCount: _chapters.length,
        itemBuilder: (ctx, idx) {
          final ch = _chapters[idx];
          final isCurrent = idx == _currentChapterIndex;
          return ListTile(
            selected: isCurrent,
            selectedTileColor: Theme.of(context).colorScheme.primary.withAlpha(25),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
            leading: CircleAvatar(
              radius: 14,
              backgroundColor: isCurrent ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.outline.withAlpha(50),
              child: Text(
                '${idx + 1}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isCurrent ? Theme.of(context).colorScheme.onPrimary : Theme.of(context).colorScheme.onSurface,
                ),
              ),
            ),
            title: Text(
              ch.title ?? 'Bab ${idx + 1}',
              style: TextStyle(
                fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                fontSize: 13,
                color: isCurrent ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.onSurface,
              ),
            ),
            subtitle: ch.wordCount != null
                ? Text(
                    '${ch.wordCount} kata',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).colorScheme.onSurface.withAlpha(160),
                    ),
                  )
                : null,
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
        return Center(
          child: Text('Belum ada penanda halaman.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
            leading: Icon(Icons.bookmark_rounded, color: Theme.of(context).colorScheme.tertiary),
            title: Text(bm.label ?? chapter.title ?? 'Bab ${chIdx + 1}',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
            subtitle: Text('Bab ${chIdx + 1}', style: const TextStyle(fontSize: 11)),
            trailing: IconButton(
              icon: Icon(Icons.delete_outline, size: 16, color: Theme.of(context).colorScheme.error),
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
        return Center(
          child: Text('Belum ada teks yang disorot.', style: TextStyle(fontSize: 12, color: Theme.of(context).colorScheme.onSurfaceVariant)),
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
              icon: Icon(Icons.delete_outline, size: 16, color: Theme.of(context).colorScheme.error),
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
