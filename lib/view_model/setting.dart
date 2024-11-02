import 'package:flutter/material.dart';

import '../model/repository/shared.dart';

class SettingProvider extends ChangeNotifier {
  bool _isLight;

  bool get isLight => _isLight;

  ThemeMode get themeMode => _isLight ? ThemeMode.light : ThemeMode.dark;

  SettingProvider({bool? isLight}) : _isLight = isLight ?? true;

  void toggleThemeMode() {
    _isLight = !_isLight;
    SharedPreferencesRepository.setBool('isLight', _isLight);
    notifyListeners();
  }
}
