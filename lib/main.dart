import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';
import 'model/manager/data_persistence.dart';
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
          create: (_) => SettingProvider(
            version: version,
            isLight: SharedPreferencesRepository.getBool('isLight'),
            isTourComplete:
                SharedPreferencesRepository.getBool('isTourComplete'),
          ),
        ),
        ChangeNotifierProvider(create: (_) => TodoProvider()),
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
      home: const HomeScreen(),
    );
  }
}
