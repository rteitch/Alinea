import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/providers.dart';
import '../../settings/presentation/settings_screen.dart';

import '../../../core/services/tts_service.dart';

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
  String _style = 'natural'; // 'natural', 'literal', 'academic'
  late String _activeTargetLang;

  @override
  void initState() {
    super.initState();
    _activeTargetLang = widget.targetLanguage;
    _performTranslation();
  }

  @override
  void dispose() {
    ref.read(ttsServiceProvider).stop();
    super.dispose();
  }

  Future<void> _performTranslation() async {
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

      if (mounted) {
        setState(() {
          _translatedText = result.translatedText;
          _isFromCache = result.isFromCache;
          _isLoading = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = e.toString();
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
                color: Colors.grey.shade300,
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
                  const Icon(Icons.translate, size: 20, color: Color(0xFF2C5E8A)),
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
                  color: activeProvider.isFoss ? Colors.green.shade50 : Colors.amber.shade50,
                  border: Border.all(
                    color: activeProvider.isFoss ? Colors.green.shade400 : Colors.amber.shade400,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      activeProvider.isFoss ? Icons.verified_user_outlined : Icons.info_outline,
                      size: 13,
                      color: activeProvider.isFoss ? Colors.green.shade800 : Colors.amber.shade900,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      activeProvider.isFoss ? '100% FOSS (\$0)' : 'BYOK Pihak Ketiga',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: activeProvider.isFoss ? Colors.green.shade800 : Colors.amber.shade900,
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
                  style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.grey.shade700),
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
                            color: Colors.grey.shade600,
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
                                  color: Colors.blue.shade50,
                                  borderRadius: BorderRadius.circular(4),
                                ),
                                child: Text(
                                  'Cache Lokal (< 200ms)',
                                  style: TextStyle(fontSize: 9, color: Colors.blue.shade900),
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
                                style: TextStyle(color: Colors.red.shade700, fontSize: 13),
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
                        else
                          SelectableText(
                            _translatedText ?? '',
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  OutlinedButton.icon(
                    icon: Icon(
                      _isSpeaking ? Icons.stop_circle_rounded : Icons.volume_up_rounded,
                      size: 16,
                      color: _isSpeaking ? Colors.red : null,
                    ),
                    label: Text(_isSpeaking ? 'Berhenti' : 'Dengarkan'),
                    onPressed: _translatedText != null
                        ? () async {
                            final tts = ref.read(ttsServiceProvider);
                            if (_isSpeaking) {
                              await tts.stop();
                              setState(() => _isSpeaking = false);
                            } else {
                              setState(() => _isSpeaking = true);
                              tts.onStateChanged = (state) {
                                if (mounted) {
                                  setState(() => _isSpeaking = state == TtsState.playing);
                                }
                              };
                              await tts.speak(_translatedText!, language: _activeTargetLang);
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
    );
  }
}
