import '../model/entity/todo.dart';
import '../model/enum/todo_type.dart';
import '../model/repository/todo.dart';
import 'base.dart';

class TodoProvider extends CrudProvider<TodoEntity> {
  @override
  get repository => TodoRepository();

  bool get isExpiredTodosExists => _expiredTodos.isNotEmpty;

  Map<DateTime, List<TodoEntity>> get events {
    Map<DateTime, List<TodoEntity>> events = {};
    List<TodoEntity> dayTodos =
        _allValidTodos.where((e) => e.todoType == ETodoType.day).toList();

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
    return _allValidTodos
        .where(
          (e) => e.forDate.day == dateTime.day && e.todoType == ETodoType.day,
        )
        .toList();
  }

  List<TodoEntity> getTodosByWeek(DateTime dateTime) {
    final startOfToday = DateTime(dateTime.year, dateTime.month, dateTime.day);
    final startOfWeek =
        startOfToday.subtract(Duration(days: startOfToday.weekday - 1));
    final endOfWeek = startOfToday.add(const Duration(days: 6));

    return _allValidTodos
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
    return _allValidTodos.where((e) => e.todoType == ETodoType.month).toList();
  }

  Future<void> deleteExpiredTodos() async {
    await deleteMany(_expiredTodos);
  }

  List<TodoEntity> get _allValidTodos {
    return resources
        .where(
          (e) =>
              e.forDate.year == DateTime.now().year &&
              e.forDate.month == DateTime.now().month,
        )
        .toSet()
        .toList();
  }

  List<TodoEntity> get _expiredTodos {
    final firstOfCurrentMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    return resources
        .where((e) => e.forDate.isBefore(firstOfCurrentMonth))
        .toList();
  }
}
