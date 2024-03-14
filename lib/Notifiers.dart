import 'package:flutter/cupertino.dart';
import 'PreferenceActivity.dart';
class SingleNotifier extends ChangeNotifier{

  String _currentMode = modes[0];
  SingleNotifier();

  String get currentMode => _currentMode;
  updateMode(String value)
  {
    if(value != _currentMode)
    {
      _currentMode = value;
      notifyListeners();
    }
  }
}