import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../view_model/letter.dart';
import '../../../view_model/setting.dart';
import 'drawer.dart';
import 'letter/letter.dart';
import 'moonstep/moonstep.dart';
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
  late final tr = AppLocalizations.of(context);

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
          SnackBar(
            content: Text(tr.unopenedLettersSnackBar),
          ),
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
          MoonstepScreen(),
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
            icon: const Icon(Icons.calendar_month),
            label: tr.calendar,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.brightness_2_rounded),
            label: tr.moonSteps,
          ),
          BottomNavigationBarItem(
            icon: Icon(
              isUnopenedLettersExists
                  ? Icons.mark_email_unread_sharp
                  : Icons.email,
            ),
            label: tr.letters,
          ),
        ],
      ),
    );
  }
}
