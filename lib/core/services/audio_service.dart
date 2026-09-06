import 'package:flutter_tts/flutter_tts.dart';

import '../localization/app_language.dart';
import '../localization/app_language_controller.dart';
import '../state/app_settings_controller.dart';

class AudioService {
  AudioService._internal();

  static final AudioService _instance =
      AudioService._internal();

  factory AudioService() => _instance;

  final FlutterTts _tts = FlutterTts();

  bool _initialized = false;

  String _languageCode(AppLanguage language) {
    switch (language) {
      case AppLanguage.english:
        return 'en-IN';

      case AppLanguage.hindi:
        return 'hi-IN';

      case AppLanguage.marathi:
        return 'mr-IN';

      case AppLanguage.bengali:
        return 'bn-IN';

      case AppLanguage.assamese:
        return 'as-IN';
    }
  }

  Future<void> _ensureInit() async {
    if (_initialized) return;

    await _tts.setLanguage(
      _languageCode(
        AppLanguageController.instance.language,
      ),
    );

    await _tts.setSpeechRate(
      appSettings.speechRate,
    );

    await _tts.setPitch(1.0);

    _initialized = true;
  }

  Future<void> speak(String text) async {
    if (text.trim().isEmpty) return;

    await _ensureInit();

    final language =
        AppLanguageController.instance.language;

    // Re-apply language every time so changing
    // language immediately affects speech.
    await _tts.setLanguage(
      _languageCode(language),
    );

    await _tts.setSpeechRate(
      appSettings.speechRate,
    );

    await _tts.stop();
    await _tts.speak(text);
  }

  Future<void> stop() async {
    await _tts.stop();
  }
}