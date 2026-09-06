import 'package:flutter/foundation.dart';

class CaregiverController extends ChangeNotifier {
  CaregiverController._internal();

  static final CaregiverController instance =
      CaregiverController._internal();

  String _fullName = '';
  String _phoneNumber = '';
  String _relationship = '';
  String _preferredLanguage = '';
  String _pin = '';
  bool _consentAccepted = false;

  String get fullName => _fullName;
  String get phoneNumber => _phoneNumber;
  String get relationship => _relationship;
  String get preferredLanguage => _preferredLanguage;
  String get pin => _pin;
  bool get consentAccepted => _consentAccepted;

  String get firstName {
    final name = _fullName.trim();

    if (name.isEmpty) {
      return '';
    }

    return name.split(RegExp(r'\s+')).first;
  }

  void setFullName(String value) {
    _fullName = value.trim();
    notifyListeners();
  }

  void setPhoneNumber(String value) {
    _phoneNumber = value.trim();
    notifyListeners();
  }

  void setRelationship(String value) {
    _relationship = value;
    notifyListeners();
  }

  void setPreferredLanguage(String value) {
    _preferredLanguage = value;
    notifyListeners();
  }

  void setPin(String value) {
    _pin = value;
    notifyListeners();
  }

  void setConsentAccepted(bool value) {
    _consentAccepted = value;
    notifyListeners();
  }

  void clear() {
    _fullName = '';
    _phoneNumber = '';
    _relationship = '';
    _preferredLanguage = '';
    _pin = '';
    _consentAccepted = false;

    notifyListeners();
  }
}