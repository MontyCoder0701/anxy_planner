import '../model/entity/todo.dart';
import '../model/enum/todo_type.dart';
import '../model/repository/todo.dart';
import 'base.dart';

class TodoProvider extends CrudProvider<TodoEntity> {
  @override
  get repository => TodoRepository();

  Map<DateTime, List<TodoEntity>> get events {
    Map<DateTime, List<TodoEntity>> events = {};
    List<TodoEntity> dayTodos =
        _getAllValidTodos().where((e) => e.todoType == ETodoType.day).toList();

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
    return _getAllValidTodos()
        .where(
          (e) => e.forDate.day == dateTime.day && e.todoType == ETodoType.day,
        )
        .toList();
  }

  List<TodoEntity> getTodosByWeek(DateTime dateTime) {
    final startOfWeek = dateTime.subtract(Duration(days: dateTime.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return _getAllValidTodos()
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
    return _getAllValidTodos()
        .where((e) => e.todoType == ETodoType.month)
        .toList();
  }

  List<TodoEntity> _getAllValidTodos() {
    return resources
        .where(
          (e) =>
              e.forDate.year == DateTime.now().year &&
              e.forDate.month == DateTime.now().month,
        )
        .toSet()
        .toList();
  }

  Future<void> deleteExpiredData() async {
    final firstOfCurrentMonth =
        DateTime(DateTime.now().year, DateTime.now().month, 1);

    // TODO: 별도 쿼리 빌더 추가
    await repository.deleteMany(
      where: 'forDate < ?',
      whereArgs: [firstOfCurrentMonth.toIso8601String()],
    );
    notifyListeners();
  }
}
