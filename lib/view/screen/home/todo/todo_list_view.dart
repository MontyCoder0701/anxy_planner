import 'package:flutter/material.dart';

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
    return Column(
      children: [
        TodoListWidget(
          title: '이 날 할 일',
          items: dayTodos,
        ),
        TodoListWidget(
          title: '이번 주 할 일',
          items: weekTodos,
        ),
        TodoListWidget(
          title: '이번 달 할 일',
          items: monthTodos,
        ),
      ],
    );
  }
}
