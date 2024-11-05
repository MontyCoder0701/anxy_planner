import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../../model/entity/todo.dart';
import 'todo_list.dart';

class TodoListView extends StatelessWidget {
  final List<TodoEntity> dayTodos;
  final List<TodoEntity> weekTodos;
  final List<TodoEntity> monthTodos;

  const TodoListView({
    super.key,
    required this.dayTodos,
    required this.weekTodos,
    required this.monthTodos,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Column(
      children: [
        TodoListWidget(
          title: '${tr.thisDay} ${tr.todo}',
          items: dayTodos,
        ),
        TodoListWidget(
          title: '${tr.thisWeek} ${tr.todo}',
          items: weekTodos,
        ),
        TodoListWidget(
          title: '${tr.thisMonth} ${tr.todo}',
          items: monthTodos,
        ),
      ],
    );
  }
}
