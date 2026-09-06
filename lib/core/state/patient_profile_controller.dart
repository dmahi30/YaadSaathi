import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

import '../localization/app_language.dart';

class PatientProfileController extends ChangeNotifier {
  String _patientId = '';
  String _fullName = '';
  DateTime? _dateOfBirth;
  AppLanguage _preferredLanguage = AppLanguage.english;

  String get patientId => _patientId;
  String get fullName => _fullName;
  DateTime? get dateOfBirth => _dateOfBirth;
  AppLanguage get preferredLanguage => _preferredLanguage;
  String get languageName => _preferredLanguage.nativeName;

  int? get age {
    if (_dateOfBirth == null) {
      return null;
    }

    final today = DateTime.now();

    int calculatedAge = today.year - _dateOfBirth!.year;

    if (today.month < _dateOfBirth!.month ||
        (today.month == _dateOfBirth!.month &&
            today.day < _dateOfBirth!.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }

  /// Creates a unique Firestore ID for the patient.
  /// No patient ID is hardcoded.
  String createPatientId() {
    if (_patientId.isNotEmpty) {
      return _patientId;
    }

    _patientId =
        FirebaseFirestore.instance.collection('patients').doc().id;

    notifyListeners();

    return _patientId;
  }

  void saveProfile({
    required String fullName,
    required DateTime dateOfBirth,
    required AppLanguage preferredLanguage,
    String? patientId,
  }) {
    final existingOrNewId = patientId?.trim();

    if (existingOrNewId != null && existingOrNewId.isNotEmpty) {
      _patientId = existingOrNewId;
    } else if (_patientId.isEmpty) {
      _patientId =
          FirebaseFirestore.instance.collection('patients').doc().id;
    }

    _fullName = fullName.trim();
    _dateOfBirth = dateOfBirth;
    _preferredLanguage = preferredLanguage;

    notifyListeners();
  }

  void clearProfile() {
    _patientId = '';
    _fullName = '';
    _dateOfBirth = null;
    _preferredLanguage = AppLanguage.english;

    notifyListeners();
  }
}

final patientProfileController = PatientProfileController();