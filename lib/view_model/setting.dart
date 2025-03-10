import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../model/repository/shared.dart';

class SettingProvider extends ChangeNotifier {
  final String _version;
  final bool _isTourComplete;
  bool _isLight;
  bool _isFirstDaySunday;

  String get version => _version;

  bool get isTourComplete => _isTourComplete;

  bool get isLight => _isLight;

  bool get isFirstDaySunday => _isFirstDaySunday;

  ThemeMode get themeMode => _isLight ? ThemeMode.light : ThemeMode.dark;

  SettingProvider({
    required String version,
    bool? isLight,
    bool? isFirstDaySunday,
    bool? isTourComplete,
  }) : _version = version,
       _isLight = isLight ?? true,
       _isFirstDaySunday = isFirstDaySunday ?? false,
       _isTourComplete = isTourComplete ?? false;

  void toggleThemeMode() {
    _isLight = !_isLight;
    SharedPreferencesRepository.setBool('isLight', _isLight);
    notifyListeners();
  }

  void toggleFirstDaySunday() {
    _isFirstDaySunday = !_isFirstDaySunday;
    SharedPreferencesRepository.setBool('isFirstDaySunday', _isFirstDaySunday);
    notifyListeners();
  }

  void completeTour() {
    SharedPreferencesRepository.setBool('isTourComplete', true);
  }

  Future<void> sendMailToDeveloper({required String subject}) async {
    final emailUri = Uri(
      scheme: 'mailto',
      path: 'soojlee0106@naver.com',
      query: 'subject=$subject',
    );

    await launchUrl(emailUri);
  }
}
