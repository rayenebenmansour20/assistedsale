import 'package:flutter/material.dart';

class ToggleProvider with ChangeNotifier {
  bool _toggleValue = true;

  bool get toggleValue => _toggleValue;

  void toggle() {
    _toggleValue = !_toggleValue;
    notifyListeners();
  }
}
