import '../model/entity/todo.dart';
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
}
