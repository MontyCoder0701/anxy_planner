import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'model/repository/local.dart';
import 'model/repository/shared.dart';
import 'view/screen/home/home.dart';
import 'view/theme.dart';
import 'view_model/letter.dart';
import 'view_model/setting.dart';
import 'view_model/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    LocalRepository.initialize(),
    SharedPreferencesRepository.initialize(),
  ]);

  final version = (await PackageInfo.fromPlatform()).version;

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create:
              (_) => SettingProvider(
                version: version,
                isLight: SharedPreferencesRepository.getBool('isLight'),
                isFirstDaySunday: SharedPreferencesRepository.getBool(
                  'isFirstDaySunday',
                ),
                isTourComplete: SharedPreferencesRepository.getBool(
                  'isTourComplete',
                ),
              ),
        ),
        ChangeNotifierProxyProvider(
          create: (BuildContext context) {
            return TodoProvider(context.read<SettingProvider>());
          },
          update: (
            BuildContext context,
            SettingProvider setting,
            TodoProvider? todo,
          ) {
            return todo ?? TodoProvider(setting);
          },
        ),
        ChangeNotifierProvider(create: (_) => LetterProvider()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'One Moon',
      debugShowCheckedModeBanner: false,
      themeMode: context.watch<SettingProvider>().themeMode,
      theme: CustomThemeData.lightTheme,
      darkTheme: CustomThemeData.darkTheme,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: UpgradeAlert(child: const HomeScreen()),
    );
  }
}
