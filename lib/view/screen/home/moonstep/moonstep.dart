import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../model/entity/todo.dart';
import '../../../../view_model/todo.dart';
import '../../../theme.dart';
import 'moonstep_day.dart';
import 'moonstep_month.dart';

class MoonstepScreen extends StatefulWidget {
  const MoonstepScreen({super.key});

  @override
  State<MoonstepScreen> createState() => _MoonstepScreenState();
}

class _MoonstepScreenState extends State<MoonstepScreen> {
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
              child: TabBarView(
                children: [MoonstepMonthScreen(), MoonstepDayScreen()],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
