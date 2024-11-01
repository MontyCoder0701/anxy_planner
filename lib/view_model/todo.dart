import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

import '../model/entity/todo.dart';
import 'base.dart';

class TodoProvider with ChangeNotifier, CrudMixin<TodoEntity> {
  Map<DateTime, List<TodoEntity>> get events {
    Map<DateTime, List<TodoEntity>> events = {};

    for (TodoEntity todo in resources) {
      DateTime dayKey = DateTime.utc(
        todo.createdAt.year,
        todo.createdAt.month,
        todo.createdAt.day,
      );

      if (events.containsKey(dayKey)) {
        events[dayKey]!.add(todo);
      } else {
        events[dayKey] = [todo];
      }
    }

    return events;
  }

  List<TodoEntity> getTodosByMonth(DateTime dateTime) {
    return resources
        .where(
          (e) =>
              e.createdAt.year == dateTime.year &&
              e.createdAt.month == dateTime.month,
        )
        .toList();
  }

  TodoEntity? getTodosByDay(DateTime dateTime) {
    return resources.firstWhereOrNull(
      (e) =>
          e.createdAt.year == dateTime.year &&
          e.createdAt.month == dateTime.month &&
          e.createdAt.day == dateTime.day,
    );
  }
}
