// ignore_for_file: deprecated_member_use
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../../core/services/tts_service.dart';
import '../../../core/storage/database.dart';
import '../../glossary/presentation/glossary_screen.dart';

class TranslationHistoryScreen extends ConsumerStatefulWidget {
  const TranslationHistoryScreen({super.key});

  @override
  ConsumerState<TranslationHistoryScreen> createState() => _TranslationHistoryScreenState();
}

class _TranslationHistoryScreenState extends ConsumerState<TranslationHistoryScreen> {
  List<TranslationCacheData> _history = [];
  bool _isLoading = true;
  String _searchQuery = '';
  int? _speakingId;

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  @override
  void dispose() {
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  Future<void> _loadHistory() async {
    setState(() => _isLoading = true);
    final repo = ref.read(translationCacheRepositoryProvider);
    final list = await repo.getHistory(query: _searchQuery);
    if (mounted) {
      setState(() {
        _history = list;
        _isLoading = false;
      });
    }
  }

  Future<void> _handleDelete(TranslationCacheData item) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Catatan Terjemahan?'),
        content: const Text('Entri ini akan dihapus dari riwayat dan cache lokal.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(
            style: FilledButton.styleFrom(backgroundColor: Colors.red),
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      final repo = ref.read(translationCacheRepositoryProvider);
      await repo.deleteEntry(item.id);
      await _loadHistory();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Entri terjemahan dihapus.')),
        );
      }
    }
  }

  Future<void> _handleSaveToGlossary(TranslationCacheData item) async {
    final sourceText = item.sourceText ?? item.sourceTextHash;
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kunci ke Glosarium'),
        content: Text('Simpan istilah "$sourceText" dengan terjemahan "${item.translatedText}" ke glosarium global?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simpan')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final glossaryRepo = ref.read(glossaryRepositoryProvider);
      await glossaryRepo.setTerm(
        sourceTerm: sourceText,
        preferredTranslation: item.translatedText,
        sourceLanguage: item.sourceLanguage,
        targetLanguage: item.targetLanguage,
      );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Istilah berhasil ditambahkan ke glosarium.')),
        );
      }
    }
  }

  Future<void> _handleSpeak(TranslationCacheData item) async {
    final tts = ref.read(ttsServiceProvider);
    if (_speakingId == item.id) {
      await tts.stop();
      setState(() => _speakingId = null);
    } else {
      setState(() => _speakingId = item.id);
      tts.onStateChanged = (state) {
        if (mounted && state != TtsState.playing) {
          setState(() => _speakingId = null);
        }
      };
      await tts.speak(item.translatedText, language: item.targetLanguage);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Riwayat Terjemahan & Kosakata', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Text('${_history.length} entri tersimpan di cache lokal',
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600)),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_stories_rounded),
            tooltip: 'Glosarium',
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const GlossaryScreen()),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Cari kata atau hasil terjemahan...',
                prefixIcon: const Icon(Icons.search, size: 20),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              onChanged: (val) {
                _searchQuery = val;
                _loadHistory();
              },
            ),
          ),

          // List of History items
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _history.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.history_edu_rounded, size: 64, color: Colors.grey.shade400),
                            const SizedBox(height: 12),
                            const Text(
                              'Belum Ada Riwayat Terjemahan',
                              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Kata dan kalimat yang Anda terjemahkan saat membaca buku\notomatis tersimpan di sini sebagai catatan belajar.',
                              textAlign: TextAlign.center,
                              style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 4, 16, 24),
                        itemCount: _history.length,
                        itemBuilder: (context, index) {
                          final item = _history[index];
                          final isSpeakingThis = _speakingId == item.id;
                          final dateStr = '${item.lastUsedAt.day}/${item.lastUsedAt.month}/${item.lastUsedAt.year}';
                          final sourceText = item.sourceText ?? 'Teks Asli';

                          return Card(
                            margin: const EdgeInsets.only(bottom: 12),
                            elevation: 1,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Header: Language Pair & Hit Count
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(
                                          color: theme.colorScheme.primaryContainer,
                                          borderRadius: BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          '${item.sourceLanguage.toUpperCase()} → ${item.targetLanguage.toUpperCase()}',
                                          style: TextStyle(
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                            color: theme.colorScheme.onPrimaryContainer,
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                            decoration: BoxDecoration(
                                              color: Colors.green.shade50,
                                              borderRadius: BorderRadius.circular(4),
                                            ),
                                            child: Text(
                                              '${item.hitCount}x dipakai',
                                              style: TextStyle(fontSize: 10, color: Colors.green.shade900),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(dateStr, style: TextStyle(fontSize: 10, color: Colors.grey.shade500)),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),

                                  // Source Text
                                  Text(
                                    sourceText,
                                    style: TextStyle(
                                      fontSize: 13,
                                      color: Colors.grey.shade800,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 6),

                                  // Translated Text
                                  Container(
                                    width: double.infinity,
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: theme.colorScheme.surfaceContainerHighest.withAlpha(60),
                                      borderRadius: BorderRadius.circular(8),
                                      border: Border.all(color: Colors.grey.shade200),
                                    ),
                                    child: Text(
                                      item.translatedText,
                                      style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold,
                                        color: theme.colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 10),

                                  // Actions
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      IconButton(
                                        icon: Icon(
                                          isSpeakingThis ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                                          size: 18,
                                          color: isSpeakingThis ? Colors.red : null,
                                        ),
                                        tooltip: 'Dengarkan',
                                        onPressed: () => _handleSpeak(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.copy_rounded, size: 18),
                                        tooltip: 'Salin',
                                        onPressed: () {
                                          Clipboard.setData(ClipboardData(text: item.translatedText));
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Terjemahan disalin ke clipboard.'),
                                              behavior: SnackBarBehavior.floating,
                                            ),
                                          );
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.bookmark_add_outlined, size: 18),
                                        tooltip: 'Kunci ke Glosarium',
                                        onPressed: () => _handleSaveToGlossary(item),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline, size: 18, color: Colors.red),
                                        tooltip: 'Hapus',
                                        onPressed: () => _handleDelete(item),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
