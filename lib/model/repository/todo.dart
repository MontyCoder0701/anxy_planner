import '../entity/todo.dart';
import 'local.dart';

class TodoRepository extends LocalRepository<TodoEntity> {
  @override
  get key => 'todo';

  @override
  toJson(item) => item.toJson();

  @override
  fromJson(Map<String, dynamic> json) => TodoEntity.fromJson(json);
}
