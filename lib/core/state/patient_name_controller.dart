import 'package:flutter/foundation.dart';

class PatientNameController extends ChangeNotifier {
  PatientNameController._internal();

  static final PatientNameController instance =
      PatientNameController._internal();

  String _name = 'Leima Devi';

  String get name => _name;

  String get firstName {
    if (_name.trim().isEmpty) return 'Leima';

    return _name.trim().split(' ').first;
  }

  void setName(String name) {
    final trimmedName = name.trim();

    if (trimmedName.isEmpty || trimmedName == _name) {
      return;
    }

    _name = trimmedName;
    notifyListeners();
  }
}