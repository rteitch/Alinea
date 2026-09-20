import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  TtsState _state = TtsState.stopped;
  int _currentSpeakId = 0;

  TtsState get state => _state;
  bool get isPlaying => _state == TtsState.playing;

  void Function(TtsState state)? onStateChanged;

  TtsService() {
    _initTts();
  }

  void _initTts() {
    _flutterTts.awaitSpeakCompletion(true);

    _flutterTts.setStartHandler(() {
      _state = TtsState.playing;
      onStateChanged?.call(_state);
    });

    _flutterTts.setCompletionHandler(() {
      // Update state when TTS engine finishes speaking
      if (_state == TtsState.playing) {
        _state = TtsState.stopped;
        onStateChanged?.call(_state);
      }
    });

    _flutterTts.setPauseHandler(() {
      _state = TtsState.paused;
      onStateChanged?.call(_state);
    });

    _flutterTts.setContinueHandler(() {
      _state = TtsState.playing;
      onStateChanged?.call(_state);
    });

    _flutterTts.setErrorHandler((msg) {
      _state = TtsState.stopped;
      onStateChanged?.call(_state);
    });
  }

  /// Maps standard language codes (e.g. 'id', 'en') to TTS locales
  String _mapLanguageCode(String lang) {
    final clean = lang.toLowerCase().trim();
    if (clean.contains('-') || clean.contains('_')) {
      return clean.replaceAll('_', '-');
    }
    switch (clean) {
      case 'id':
        return 'id-ID';
      case 'en':
        return 'en-US';
      case 'ja':
        return 'ja-JP';
      case 'zh':
        return 'zh-CN';
      case 'de':
        return 'de-DE';
      case 'fr':
        return 'fr-FR';
      case 'es':
        return 'es-ES';
      case 'ar':
        return 'ar-SA';
      default:
        return 'en-US';
    }
  }

  List<String> _splitTextIntoChunks(String text, {int maxChunkLength = 1500}) {
    if (text.length <= maxChunkLength) return [text];

    final paragraphs = text.split(RegExp(r'\n+'));
    final chunks = <String>[];
    var currentChunk = '';

    for (final p in paragraphs) {
      final trimmedP = p.trim();
      if (trimmedP.isEmpty) continue;

      if ((currentChunk.length + trimmedP.length + 1) <= maxChunkLength) {
        currentChunk = currentChunk.isEmpty ? trimmedP : '$currentChunk\n$trimmedP';
      } else {
        if (currentChunk.isNotEmpty) {
          chunks.add(currentChunk);
          currentChunk = '';
        }
        if (trimmedP.length <= maxChunkLength) {
          currentChunk = trimmedP;
        } else {
          final sentences = trimmedP.split(RegExp(r'(?<=[.!?])\s+'));
          for (final s in sentences) {
            if ((currentChunk.length + s.length + 1) <= maxChunkLength) {
              currentChunk = currentChunk.isEmpty ? s : '$currentChunk $s';
            } else {
              if (currentChunk.isNotEmpty) chunks.add(currentChunk);
              currentChunk = s;
            }
          }
        }
      }
    }
    if (currentChunk.isNotEmpty) {
      chunks.add(currentChunk);
    }
    return chunks;
  }

  Future<void> speak(String text, {String? language, double rate = 0.5}) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    final speakId = ++_currentSpeakId;

    try {
      if (language != null) {
        final locale = _mapLanguageCode(language);
        await _flutterTts.setLanguage(locale);
      }
      await _flutterTts.setSpeechRate(rate);
      await _flutterTts.setPitch(1.0);

      _state = TtsState.playing;
      onStateChanged?.call(_state);

      final chunks = _splitTextIntoChunks(cleanText);
      for (final chunk in chunks) {
        if (_currentSpeakId != speakId || _state != TtsState.playing) {
          break;
        }
        await _flutterTts.speak(chunk);
      }

      if (_currentSpeakId == speakId && _state == TtsState.playing) {
        _state = TtsState.stopped;
        onStateChanged?.call(_state);
      }
    } catch (_) {
      _state = TtsState.stopped;
      onStateChanged?.call(_state);
    }
  }

  Future<void> pause() async {
    _currentSpeakId++;
    _state = TtsState.paused;
    await _flutterTts.pause();
    onStateChanged?.call(_state);
  }

  Future<void> stop() async {
    _currentSpeakId++;
    _state = TtsState.stopped;
    await _flutterTts.stop();
    onStateChanged?.call(_state);
  }

  void dispose() {
    _currentSpeakId++;
    _state = TtsState.stopped;
    onStateChanged?.call(_state);
    _flutterTts.stop();
  }
}
