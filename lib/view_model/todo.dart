import 'dart:convert';

import 'package:collection/collection.dart';

import '../model/entity/todo.dart';
import '../model/enum/todo_type.dart';
import '../model/repository/todo.dart';
import 'base.dart';
import 'setting.dart';

class TodoProvider extends CrudProvider<TodoEntity> {
  @override
  get repository => TodoRepository();

  SettingProvider settingProvider;

  TodoProvider(this.settingProvider);

  Map<DateTime, List<TodoEntity>> get events {
    Map<DateTime, List<TodoEntity>> events = {};
    List<TodoEntity> dayTodos =
        _allValidCalendarTodos
            .where((e) => e.todoType == ETodoType.day)
            .toList();

    for (TodoEntity todo in dayTodos) {
      DateTime dayKey = DateTime.utc(
        todo.forDate.year,
        todo.forDate.month,
        todo.forDate.day,
      );

      if (events.containsKey(dayKey)) {
        events[dayKey]!.add(todo);
      } else {
        events[dayKey] = [todo];
      }
    }

    return events;
  }

  List<TodoEntity> getTodosByDay(DateTime dateTime) {
    return _allValidCalendarTodos
        .where(
          (e) => e.forDate.day == dateTime.day && e.todoType == ETodoType.day,
        )
        .toList();
  }

  String getTodayTodos() {
    final todayTodos = getTodosByDay(DateTime.now());
    return jsonEncode(todayTodos.map((e) => e.toJson()).toList());
  }

  List<TodoEntity> getTodosByWeek(DateTime dateTime) {
    final startOfToday = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final startOfWeek = startOfToday.subtract(
      Duration(
        days:
            settingProvider.isFirstDaySunday
                ? startOfToday.weekday % 7
                : startOfToday.weekday - 1,
      ),
    );

    final endOfWeek = startOfWeek.add(const Duration(days: 7));

    return _allValidCalendarTodos
        .where(
          (e) =>
              (e.forDate.isAtSameMomentAs(startOfWeek) ||
                  e.forDate.isAfter(startOfWeek)) &&
              (e.forDate.isAtSameMomentAs(endOfWeek) ||
                  e.forDate.isBefore(endOfWeek)) &&
              e.todoType == ETodoType.week,
        )
        .toList();
  }

  List<TodoEntity> get calendarTodosByMonth {
    return _allValidCalendarTodos
        .where((e) => e.todoType == ETodoType.month)
        .toList();
  }

  Map<DateTime, List<TodoEntity>> get moonStepTodosByMonth {
    final monthTodos =
        resources.where((e) => e.todoType == ETodoType.month).toSet().toList()
          ..sort((a, b) => b.forDate.compareTo(a.forDate));

    return monthTodos.groupListsBy(
      (e) => DateTime(e.forDate.year, e.forDate.month),
    );
  }

  List<TodoEntity> get _allValidCalendarTodos {
    return resources
        .where(
          (e) =>
              e.forDate.year == DateTime.now().year &&
              e.forDate.month == DateTime.now().month,
        )
        .toSet()
        .toList();
  }
}
