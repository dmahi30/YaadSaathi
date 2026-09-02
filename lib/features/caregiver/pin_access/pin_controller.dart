import 'package:flutter/foundation.dart';
import '../../../core/constants/app_constants.dart';

class PinController extends ChangeNotifier {
  String _entered = '';
  bool _hasError = false;

  String get entered => _entered;
  bool get hasError => _hasError;
  int get length => _entered.length;
  bool get isCorrect => _entered == AppConstants.caregiverPin;

  void addDigit(String digit) {
    if (_entered.length >= 4) return;
    _hasError = false;
    _entered += digit;
    notifyListeners();

    if (_entered.length == 4) {
      _hasError = _entered != AppConstants.caregiverPin;
      notifyListeners();
    }
  }

  void removeDigit() {
    if (_entered.isEmpty) return;
    _hasError = false;
    _entered = _entered.substring(0, _entered.length - 1);
    notifyListeners();
  }

  void reset() {
    _entered = '';
    _hasError = false;
    notifyListeners();
  }
}