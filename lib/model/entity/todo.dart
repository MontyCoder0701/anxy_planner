import 'package:json_annotation/json_annotation.dart';

import '../enum/todo_type.dart';
import 'base.dart';

part 'todo.g.dart';

@JsonSerializable()
class TodoEntity extends BaseEntity {
  @JsonKey()
  String title;

  @JsonKey()
  DateTime forDate = DateTime.now();

  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isComplete;

  @JsonKey()
  ETodoType todoType;

  TodoEntity({
    this.title = '',
    this.isComplete = false,
    this.todoType = ETodoType.day,
  });

  factory TodoEntity.fromJson(Map<String, dynamic> json) =>
      _$TodoEntityFromJson(json);

  Map<String, dynamic> toJson() => _$TodoEntityToJson(this);

  void setForDate(DateTime dateTime) {
    forDate = dateTime;
  }
}
