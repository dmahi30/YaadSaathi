enum AppLanguage {
  english,
  hindi,
  marathi,
  bengali,
  assamese,
}

/// Language codes and native display names for [AppLanguage].
extension AppLanguageCode on AppLanguage {
  String get code {
    switch (this) {
      case AppLanguage.english:
        return 'en';
      case AppLanguage.hindi:
        return 'hi';
      case AppLanguage.marathi:
        return 'mr';
      case AppLanguage.bengali:
        return 'bn';
      case AppLanguage.assamese:
        return 'as';
    }
  }

  String get nativeName {
    switch (this) {
      case AppLanguage.english:
        return 'English';
      case AppLanguage.hindi:
        return 'हिंदी';
      case AppLanguage.marathi:
        return 'मराठी';
      case AppLanguage.bengali:
        return 'বাংলা';
      case AppLanguage.assamese:
        return 'অসমীয়া';
    }
  }

  static AppLanguage fromCode(String code) {
    switch (code) {
      case 'hi':
        return AppLanguage.hindi;
      case 'mr':
        return AppLanguage.marathi;
      case 'bn':
        return AppLanguage.bengali;
      case 'as':
        return AppLanguage.assamese;
      case 'en':
      default:
        return AppLanguage.english;
    }
  }
}