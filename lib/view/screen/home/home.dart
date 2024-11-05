import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../view_model/letter.dart';
import '../../../view_model/setting.dart';
import 'drawer.dart';
import 'letter/letter.dart';
import 'todo/todo.dart';
import 'tour_dialog.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final settingProvider = context.read<SettingProvider>();
  late final letterProvider = context.watch<LetterProvider>();
  late final scaffoldMessenger = ScaffoldMessenger.of(context);

  int currentScreenIndex = 0;

  bool get isTourComplete => settingProvider.isTourComplete;

  bool get isUnopenedLettersExists => letterProvider.isUnopenedLettersExists;

  @override
  void initState() {
    super.initState();
    Future.microtask(() async {
      if (!settingProvider.isTourComplete && mounted) {
        await showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return PopScope(
              canPop: false,
              child: const TourDialog(),
            );
          },
        );
      }
    });

    Future.microtask(() async {
      await letterProvider.getMany();

      if (isUnopenedLettersExists) {
        scaffoldMessenger.hideCurrentSnackBar();
        scaffoldMessenger.showSnackBar(
          const SnackBar(content: Text('아직 읽지 않은 편지가 있네요.')),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(forceMaterialTransparency: true),
      body: IndexedStack(
        index: currentScreenIndex,
        children: const [
          TodoScreen(),
          LetterScreen(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentScreenIndex,
        onTap: (index) {
          setState(() => currentScreenIndex = index);
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: '달력',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isUnopenedLettersExists
                  ? Icons.mark_email_unread_sharp
                  : Icons.email,
            ),
            label: '편지',
          ),
        ],
      ),
    );
  }
}
