import 'package:flutter/material.dart';
import 'package:one_moon/view/theme.dart';
import 'package:provider/provider.dart';

import 'model/repository/local.dart';
import 'view/screen/home.dart';
import 'view_model/todo.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await LocalRepository.initialize();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => TodoProvider()),
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
      theme: CustomThemeData.lightTheme,
      darkTheme: CustomThemeData.darkTheme,
      home: const HomeScreen(),
    );
  }
}
