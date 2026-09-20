import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_tts/flutter_tts.dart';
import '../../../app/providers.dart';
import '../../settings/presentation/settings_screen.dart';


class TranslationOverlay extends ConsumerStatefulWidget {
  final int bookId;
  final String selectedText;
  final String sourceLanguage;
  final String targetLanguage;

  const TranslationOverlay({
    super.key,
    required this.bookId,
    required this.selectedText,
    required this.sourceLanguage,
    required this.targetLanguage,
  });

  static Future<void> show(
    BuildContext context, {
    required int bookId,
    required String selectedText,
    required String sourceLanguage,
    required String targetLanguage,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => TranslationOverlay(
        bookId: bookId,
        selectedText: selectedText,
        sourceLanguage: sourceLanguage,
        targetLanguage: targetLanguage,
      ),
    );
  }

  @override
  ConsumerState<TranslationOverlay> createState() => _TranslationOverlayState();
}

class _TranslationOverlayState extends ConsumerState<TranslationOverlay> {
  bool _isLoading = true;
  String? _translatedText;
  String? _errorMessage;
  bool _isFromCache = false;
  bool _isSpeaking = false;
  String _ttsError = '';
  String _style = 'natural'; // 'natural', 'literal', 'academic'
  late String _activeTargetLang;
  int _translationRequestId = 0; // For cancelling overlapping translations

  // Own a private TTS instance so it doesn't conflict with the reader's TTS
  final FlutterTts _tts = FlutterTts();

  @override
  void initState() {
    super.initState();
    _activeTargetLang = widget.targetLanguage;
    _initTts();
    _performTranslation();
  }

  void _initTts() {
    _tts.setStartHandler(() {
      if (mounted) setState(() { _isSpeaking = true; _ttsError = ''; });
    });
    _tts.setCompletionHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setCancelHandler(() {
      if (mounted) setState(() => _isSpeaking = false);
    });
    _tts.setErrorHandler((msg) {
      if (mounted) {
        setState(() {
          _isSpeaking = false;
          _ttsError = 'TTS Error: $msg';
        });
      }
    });
  }

  @override
  void dispose() {
    _translationRequestId++; // Cancel any ongoing translation
    _tts.stop();
    super.dispose();
  }

  Future<void> _performTranslation() async {
    // Cancel any previous translation
    final requestId = ++_translationRequestId;
    
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final coordinator = ref.read(translationCoordinatorProvider);
      final result = await coordinator.translateText(
        bookId: widget.bookId,
        text: widget.selectedText,
        sourceLanguage: widget.sourceLanguage,
        targetLanguage: _activeTargetLang,
        style: _style,
      );

      // Check if this request was cancelled
      if (requestId != _translationRequestId) return;
      
      if (mounted) {
        setState(() {
          _translatedText = result.translatedText;
          _isFromCache = result.isFromCache;
          _isLoading = false;
        });
      }
    } catch (e) {
      // Check if this request was cancelled
      if (requestId != _translationRequestId) return;
      
      if (mounted) {
        // Strip exception class prefix for clean display
        String rawMsg = e.toString();
        rawMsg = rawMsg
            .replaceAll(RegExp(r'^TranslationException:\s*'), '')
            .replaceAll(RegExp(r'^Exception:\s*'), '')
            .trim();

        // If it still contains raw Dio debug text, replace with friendly message
        final bool isDioDebugText = rawMsg.contains('RequestOptions') ||
            rawMsg.contains('validateStatus') ||
            rawMsg.contains('status code of') ||
            rawMsg.contains('developer.mozilla.org');
        final String cleanMsg = isDioDebugText
            ? 'Koneksi ke mesin terjemahan gagal (HTTP error). Coba lagi atau ganti mesin di Pengaturan.'
            : (rawMsg.isEmpty ? 'Terjemahan gagal. Coba lagi.' : rawMsg);

        setState(() {
          _errorMessage = cleanMsg;
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _handleSaveToGlossary() async {
    if (_translatedText == null) return;

    final controller = TextEditingController(text: _translatedText);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Kunci Terjemahan (Glosarium)'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Teks Asal:'),
            Text(widget.selectedText, style: const TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(
              controller: controller,
              decoration: const InputDecoration(
                labelText: 'Terjemahan Pilihan untuk Buku Ini',
                border: OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx, false), child: const Text('Batal')),
          FilledButton(onPressed: () => Navigator.pop(ctx, true), child: const Text('Simpan')),
        ],
      ),
    );

    if (confirmed == true && mounted) {
      final glossaryRepo = ref.read(glossaryRepositoryProvider);
      await glossaryRepo.setTerm(
        bookId: widget.bookId,
        sourceTerm: widget.selectedText.trim(),
        preferredTranslation: controller.text.trim(),
        sourceLanguage: widget.sourceLanguage,
        targetLanguage: _activeTargetLang,
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Istilah glosarium disimpan untuk buku ini.')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeProvider = ref.watch(activeTranslationProvider);

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 20,
      ),
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.75,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Drag handle
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).dividerColor,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Header with FOSS Badge
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.translate, size: 20, color: Theme.of(context).colorScheme.primary),
                  const SizedBox(width: 8),
                  Text(
                    'Terjemahan Alinea',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              // FOSS Badge (PRD Section 6.1)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: activeProvider.isFoss ? Theme.of(context).colorScheme.primaryContainer : Theme.of(context).colorScheme.secondaryContainer,
                  border: Border.all(
                    color: activeProvider.isFoss ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      activeProvider.isFoss ? Icons.verified_user_outlined : Icons.info_outline,
                      size: 13,
                      color: activeProvider.isFoss ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activeProvider.isFoss ? '100% FOSS (\$0)' : 'BYOK Pihak Ketiga',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: activeProvider.isFoss ? Theme.of(context).colorScheme.primary : Theme.of(context).colorScheme.secondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 20),

          // Translation Style Selector (PRD Section 6.1)
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Text(
                  'Gaya Terjemahan:',
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Theme.of(context).colorScheme.onSurfaceVariant),
                ),
                const SizedBox(width: 8),
                ChoiceChip(
                  label: const Text('Alami (Natural)', style: TextStyle(fontSize: 11)),
                  selected: _style == 'natural',
                  onSelected: (selected) {
                    if (selected && _style != 'natural') {
                      setState(() => _style = 'natural');
                      _performTranslation();
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Harfiah (Literal)', style: TextStyle(fontSize: 11)),
                  selected: _style == 'literal',
                  onSelected: (selected) {
                    if (selected && _style != 'literal') {
                      setState(() => _style = 'literal');
                      _performTranslation();
                    }
                  },
                ),
                const SizedBox(width: 6),
                ChoiceChip(
                  label: const Text('Akademis', style: TextStyle(fontSize: 11)),
                  selected: _style == 'academic',
                  onSelected: (selected) {
                    if (selected && _style != 'academic') {
                      setState(() => _style = 'academic');
                      _performTranslation();
                    }
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),

          // Content section
          Flexible(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Original Text Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.surfaceContainerHighest.withAlpha(80),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Teks Asli (${widget.sourceLanguage.toUpperCase()}):',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Theme.of(context).colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: 4),
                        SelectableText(
                          widget.selectedText,
                          style: const TextStyle(fontSize: 14, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Translated Text Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.primaryContainer.withAlpha(50),
                      border: Border.all(
                        color: Theme.of(context).colorScheme.primary.withAlpha(60),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Hasil Terjemahan (${_activeTargetLang.toUpperCase()}):',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            if (_isFromCache)
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.primaryContainer,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Cache Lokal (< 200ms)',
                                  style: TextStyle(fontSize: 9, color: Theme.of(context).colorScheme.primary),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        if (_isLoading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16.0),
                            child: Center(
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  SizedBox(
                                    width: 16,
                                    height: 16,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  ),
                                  SizedBox(width: 12),
                                  Text('Menerjemahkan secara instan...', style: TextStyle(fontSize: 13)),
                                ],
                              ),
                            ),
                          )
                        else if (_errorMessage != null)
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                _errorMessage!,
                                style: TextStyle(color: Theme.of(context).colorScheme.error, fontSize: 13),
                              ),
                              const SizedBox(height: 6),
                              Row(
                                children: [
                                  TextButton.icon(
                                    onPressed: _performTranslation,
                                    icon: const Icon(Icons.refresh, size: 16),
                                    label: const Text('Coba Lagi'),
                                  ),
                                  const SizedBox(width: 8),
                                  TextButton.icon(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(builder: (_) => const SettingsScreen()),
                                      );
                                    },
                                    icon: const Icon(Icons.settings_outlined, size: 16),
                                    label: const Text('Atur Gateway'),
                                  ),
                                ],
                              ),
                            ],
                          )
                        else if (_translatedText == null || _translatedText!.trim().isEmpty)
                          Container(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.info_outline, size: 16, color: Theme.of(context).colorScheme.onSurfaceVariant),
                                const SizedBox(width: 8),
                                Text(
                                  'Tidak ada terjemahan tersedia',
                                  style: TextStyle(
                                    fontSize: 13,
                                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          SelectableText(
                            _translatedText!,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              height: 1.45,
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),

          // Bottom Action Buttons
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_ttsError.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(bottom: 6),
                  child: Text(
                    '⚠️ $_ttsError',
                    style: TextStyle(fontSize: 11, color: Theme.of(context).colorScheme.error),
                  ),
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      OutlinedButton.icon(
                        icon: Icon(
                          _isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                          size: 16,
                          color: _isSpeaking ? Theme.of(context).colorScheme.error : null,
                        ),
                        label: Text(_isSpeaking ? 'Berhenti' : 'Dengarkan'),
                        onPressed: _translatedText != null
                            ? () async {
                                if (_isSpeaking) {
                                  await _tts.stop();
                                  if (mounted) setState(() { _isSpeaking = false; });
                                } else {
                                  if (mounted) setState(() { _ttsError = ''; });
                                  // Map language code to locale
                                  final localeMap = {
                                    'id': 'id-ID', 'en': 'en-US', 'ja': 'ja-JP',
                                    'zh': 'zh-CN', 'de': 'de-DE', 'fr': 'fr-FR',
                                    'es': 'es-ES', 'ar': 'ar-SA',
                                  };
                                  final locale = localeMap[_activeTargetLang] ?? 'id-ID';
                                  try {
                                    await _tts.setLanguage(locale);
                                    await _tts.setSpeechRate(0.5);
                                    await _tts.setPitch(1.0);
                                    await _tts.speak(_translatedText!);
                                  } catch (e) {
                                    if (mounted) {
                                      setState(() {
                                        _isSpeaking = false;
                                        _ttsError = 'Tidak bisa memutar suara. Pastikan TTS bahasa tersedia di perangkat.';
                                      });
                                    }
                                  }
                                }
                              }
                            : null,
                      ),
                      const SizedBox(width: 8),
                      OutlinedButton.icon(
                        icon: const Icon(Icons.copy, size: 16),
                        label: const Text('Salin'),
                        onPressed: _translatedText != null
                            ? () {
                                Clipboard.setData(ClipboardData(text: _translatedText!));
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Terjemahan disalin ke clipboard.'),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            : null,
                      ),
                    ],
                  ),
                  FilledButton.tonalIcon(
                    icon: const Icon(Icons.bookmark_add_outlined, size: 16),
                    label: const Text('Glosarium'),
                    onPressed: _translatedText != null ? _handleSaveToGlossary : null,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
