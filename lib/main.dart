import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:upgrader/upgrader.dart';

import 'firebase_options.dart';
import 'l10n/app_localizations.dart';
import 'model/repository/local.dart';
import 'model/repository/shared.dart';
import 'view/screen/home/home.dart';
import 'view/theme.dart';
import 'view_model/home_widget_sync.dart';
import 'view_model/letter.dart';
import 'view_model/setting.dart';
import 'view_model/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Future.wait([
    HomeWidget.setAppGroupId('group.onemoonwidgets'),
    Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform),
    LocalRepository.initialize(),
    SharedPreferencesRepository.initialize(),
  ]);

  final version = (await PackageInfo.fromPlatform()).version;

  final settingProvider = SettingProvider(
    version: version,
    isLight: SharedPreferencesRepository.getBool('isLight'),
    isFirstDaySunday: SharedPreferencesRepository.getBool('isFirstDaySunday'),
    isTourComplete: SharedPreferencesRepository.getBool('isTourComplete'),
  );

  final todoProvider = TodoProvider(settingProvider);
  final homeWidgetSyncProvider = HomeWidgetSyncProvider(todoProvider);

  todoProvider.addListener(homeWidgetSyncProvider.syncHomeWidgetTodos);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => settingProvider),
        ChangeNotifierProvider(create: (_) => todoProvider),
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
