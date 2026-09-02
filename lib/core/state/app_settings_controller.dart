import 'package:flutter/material.dart';

/// Holds app-wide accessibility and preference state.
class AppSettingsController extends ChangeNotifier {
  String _textSizeLabel = 'Medium';
  String _displayLabel = 'Normal';
  String _voiceSpeedLabel = 'Normal Speed';
  String _languageLabel = 'English (Automatic)';

  String get textSizeLabel => _textSizeLabel;
  String get displayLabel => _displayLabel;
  String get voiceSpeedLabel => _voiceSpeedLabel;
  String get languageLabel => _languageLabel;

  // ---------------- TEXT SIZE ----------------

  bool get isHighContrast => _displayLabel == 'High Contrast';

  double get textScaleFactor {
    switch (_textSizeLabel) {
      case 'Small':
        return 0.9;
      case 'Large':
        return 1.2;
      case 'Extra Large':
        return 1.4;
      case 'Medium':
      default:
        return 1.0;
    }
  }

  void setTextSize(String label) {
    _textSizeLabel = label;
    notifyListeners();
  }

  // ---------------- DISPLAY ----------------

  void setDisplay(String label) {
    _displayLabel = label;
    notifyListeners();
  }

  // ---------------- VOICE ----------------

  /// Flutter TTS speech rate.
  double get speechRate {
    switch (_voiceSpeedLabel) {
      case 'Slow':
        return 0.35;
      case 'Fast':
        return 0.70;
      case 'Normal Speed':
      default:
        return 0.50;
    }
  }

  void setVoiceSpeed(String label) {
    _voiceSpeedLabel = label;
    notifyListeners();
  }

  // ---------------- LANGUAGE ----------------

  void setLanguage(String label) {
    _languageLabel = label;
    notifyListeners();
  }
}

/// Single shared instance used across the whole app.
final appSettings = AppSettingsController();