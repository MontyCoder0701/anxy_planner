import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../model/entity/todo.dart';
import 'todo_list.dart';

class TodoListView extends StatelessWidget {
  final List<TodoEntity> dayTodos;
  final List<TodoEntity> weekTodos;
  final List<TodoEntity> monthTodos;
  final Function(TodoEntity) onDelete;
  final Function(TodoEntity) onEdit;
  final Function(TodoEntity) onTap;

  const TodoListView({
    super.key,
    required this.dayTodos,
    required this.weekTodos,
    required this.monthTodos,
    required this.onDelete,
    required this.onEdit,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final tr = AppLocalizations.of(context);

    return Column(
      children: [
        TodoListWidget(
          title: tr.thisDayTodoLabel,
          items: dayTodos,
          onDelete: onDelete,
          onEdit: onEdit,
          onTap: onTap,
        ),
        TodoListWidget(
          title: tr.thisWeekTodoLabel,
          items: weekTodos,
          onDelete: onDelete,
          onEdit: onEdit,
          onTap: onTap,
        ),
        TodoListWidget(
          title: tr.thisMonthTodoLabel,
          items: monthTodos,
          onDelete: onDelete,
          onEdit: onEdit,
          onTap: onTap,
        ),
      ],
    );
  }
}
