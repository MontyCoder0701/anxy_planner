import 'package:flutter/material.dart';

import '../model/repository/shared.dart';

class SettingProvider extends ChangeNotifier {
  final String _version;

  bool _isLight;

  String get version => _version;

  bool get isLight => _isLight;

  ThemeMode get themeMode => _isLight ? ThemeMode.light : ThemeMode.dark;

  SettingProvider({required String version, bool? isLight})
      : _version = version,
        _isLight = isLight ?? true;

  void toggleThemeMode() {
    _isLight = !_isLight;
    SharedPreferencesRepository.setBool('isLight', _isLight);
    notifyListeners();
  }
}
