import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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

  int currentScreenIndex = 0;

  bool get isTourComplete => settingProvider.isTourComplete;

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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const DrawerWidget(),
      appBar: AppBar(),
      body: _buildScreen(),
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
            icon: Icon(Icons.email),
            label: '편지',
          ),
        ],
      ),
    );
  }

  Widget _buildScreen() {
    switch (currentScreenIndex) {
      case 1:
        return const LetterScreen();
      default:
        return const TodoScreen();
    }
  }
}
