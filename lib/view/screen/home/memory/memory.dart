import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../model/entity/todo.dart';
import '../../../../view_model/todo.dart';
import '../../../theme.dart';
import 'daystep.dart';
import 'moonstep.dart';

class MemoryScreen extends StatefulWidget {
  const MemoryScreen({super.key});

  @override
  State<MemoryScreen> createState() => _MemoryScreenState();
}

class _MemoryScreenState extends State<MemoryScreen> {
  ColorScheme get colorScheme => Theme.of(context).colorScheme;
  late final tr = AppLocalizations.of(context);
  late final todoProvider = context.watch<TodoProvider>();

  Map<DateTime, List<TodoEntity>> get moonstepTodos =>
      todoProvider.moonStepTodosByMonth;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        body: Column(
          children: [
            TabBar(
              labelColor: CustomColor.primary,
              indicatorColor: CustomColor.primary,
              tabs: [Tab(text: tr.moonSteps), Tab(text: tr.daySteps)],
            ),
            Expanded(
              child: TabBarView(children: [MoonstepScreen(), DaystepScreen()]),
            ),
          ],
        ),
      ),
    );
  }
}
