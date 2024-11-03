import 'package:flutter/material.dart';

import '../model/repository/shared.dart';

class SettingProvider extends ChangeNotifier {
  final String _version;
  final bool _isTourComplete;
  bool _isLight;

  String get version => _version;

  bool get isTourComplete => _isTourComplete;

  bool get isLight => _isLight;

  ThemeMode get themeMode => _isLight ? ThemeMode.light : ThemeMode.dark;

  SettingProvider({
    required String version,
    bool? isLight,
    bool? isTourComplete,
  })  : _version = version,
        _isLight = isLight ?? true,
        _isTourComplete = isTourComplete ?? false;

  void toggleThemeMode() {
    _isLight = !_isLight;
    SharedPreferencesRepository.setBool('isLight', _isLight);
    notifyListeners();
  }

  void completeTour() {
    SharedPreferencesRepository.setBool('isTourComplete', true);
  }
}
