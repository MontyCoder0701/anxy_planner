import '../model/entity/todo.dart';
import '../model/enum/todo_type.dart';
import '../model/repository/todo.dart';
import 'base.dart';

class TodoProvider extends CrudProvider<TodoEntity> {
  @override
  get repository => TodoRepository();

  Map<DateTime, List<TodoEntity>> get events {
    Map<DateTime, List<TodoEntity>> events = {};

    for (TodoEntity todo in resources) {
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
    return _getAllTodosByMonth(dateTime)
        .where(
          (e) => e.forDate.day == dateTime.day && e.todoType == ETodoType.day,
        )
        .toList();
  }

  List<TodoEntity> getTodosByWeek(DateTime dateTime) {
    final startOfWeek = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _getAllTodosByMonth(dateTime)
        .where(
          (e) =>
              e.forDate
                  .isAfter(startOfWeek.subtract(const Duration(seconds: 1))) &&
              e.forDate.isBefore(endOfWeek.add(const Duration(seconds: 1))) &&
              e.todoType == ETodoType.week,
        )
        .toList();
  }

  List<TodoEntity> getTodosByMonth(DateTime dateTime) {
    return _getAllTodosByMonth(dateTime)
        .where(
          (e) =>
              e.forDate.month == dateTime.month &&
              e.todoType == ETodoType.month,
        )
        .toList();
  }

  List<TodoEntity> _getAllTodosByMonth(DateTime dateTime) {
    return resources
        .where((e) => e.forDate.month == dateTime.month)
        .toSet()
        .toList();
  }
}
