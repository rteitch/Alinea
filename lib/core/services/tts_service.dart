import 'package:flutter_tts/flutter_tts.dart';

enum TtsState { playing, stopped, paused }

class TtsService {
  final FlutterTts _flutterTts = FlutterTts();
  TtsState _state = TtsState.stopped;

  TtsState get state => _state;
  bool get isPlaying => _state == TtsState.playing;

  void Function(TtsState state)? onStateChanged;

  TtsService() {
    _initTts();
  }

  void _initTts() {
    _flutterTts.setStartHandler(() {
      _state = TtsState.playing;
      onStateChanged?.call(_state);
    });

    _flutterTts.setCompletionHandler(() {
      _state = TtsState.stopped;
      onStateChanged?.call(_state);
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
    switch (lang.toLowerCase()) {
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
        return 'id-ID';
    }
  }

  Future<void> speak(String text, {String? language, double rate = 0.5}) async {
    final cleanText = text.trim();
    if (cleanText.isEmpty) return;

    if (language != null) {
      final locale = _mapLanguageCode(language);
      await _flutterTts.setLanguage(locale);
    }
    await _flutterTts.setSpeechRate(rate);
    await _flutterTts.setPitch(1.0);

    _state = TtsState.playing;
    onStateChanged?.call(_state);
    await _flutterTts.speak(cleanText);
  }

  Future<void> pause() async {
    await _flutterTts.pause();
    _state = TtsState.paused;
    onStateChanged?.call(_state);
  }

  Future<void> stop() async {
    await _flutterTts.stop();
    _state = TtsState.stopped;
    onStateChanged?.call(_state);
  }

  void dispose() {
    _flutterTts.stop();
  }
}
