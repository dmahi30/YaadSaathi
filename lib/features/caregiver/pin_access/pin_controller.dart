import 'package:flutter/foundation.dart';

class PinController extends ChangeNotifier {
  String _entered = '';
  bool _hasError = false;

  String get entered => _entered;
  bool get hasError => _hasError;
  int get length => _entered.length;

  void addDigit(String digit) {
    if (_entered.length >= 4) return;

    _hasError = false;
    _entered += digit;
    notifyListeners();
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

  void setError() {
    _hasError = true;
    notifyListeners();
  }
}