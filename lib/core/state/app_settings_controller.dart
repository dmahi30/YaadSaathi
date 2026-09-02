import 'package:flutter/material.dart';

/// Holds app-wide accessibility/preference state. A single global instance
/// (see [appSettings] below) is read by MaterialApp to scale text across
/// every screen, and by the Settings screen to show/edit current values.
/// No provider/riverpod dependency needed — ChangeNotifier + ListenableBuilder
/// is enough for this scope.
class AppSettingsController extends ChangeNotifier {
  String _textSizeLabel = 'Medium';
  String _displayLabel = 'Normal';
  String _voiceSpeedLabel = 'Normal Speed';
  String _languageLabel = 'English (Automatic)';

  String get textSizeLabel => _textSizeLabel;
  String get displayLabel => _displayLabel;
  String get voiceSpeedLabel => _voiceSpeedLabel;
  String get languageLabel => _languageLabel;

  /// True when the user has selected High Contrast in Display settings.
  /// Read by MaterialApp to switch its whole theme, not just this screen.
  bool get isHighContrast => _displayLabel == 'High Contrast';

  /// Used by MaterialApp's MediaQuery override to scale every Text widget
  /// in the app at once.
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

  void setDisplay(String label) {
    _displayLabel = label;
    notifyListeners();
  }

  void setVoiceSpeed(String label) {
    _voiceSpeedLabel = label;
    notifyListeners();
  }

  void setLanguage(String label) {
    _languageLabel = label;
    notifyListeners();
  }
}

/// Single shared instance used across the whole app.
final appSettings = AppSettingsController();