import 'package:flutter/foundation.dart';
import 'app_language.dart';

/// App-wide holder for the currently selected [AppLanguage].
///
/// Deliberately not a state-management package — this is a small
/// ChangeNotifier singleton. Screens can read the current value
/// directly (`AppLanguageController.instance.language`) since it's
/// a plain in-memory value that persists across navigation for the
/// lifetime of the app session.
class AppLanguageController extends ChangeNotifier {
  AppLanguageController._internal();
  static final AppLanguageController instance = AppLanguageController._internal();

  AppLanguage _language = AppLanguage.english;

  AppLanguage get language => _language;

  void setLanguage(AppLanguage language) {
    if (_language == language) return;
    _language = language;
    notifyListeners();
  }
}