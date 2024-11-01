// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'todo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TodoEntity _$TodoEntityFromJson(Map<String, dynamic> json) => TodoEntity(
      title: json['title'] as String? ?? '',
      isComplete: json['isComplete'] == null
          ? false
          : TodoEntity._boolFromInt((json['isComplete'] as num).toInt()),
      todoType: $enumDecodeNullable(_$ETodoTypeEnumMap, json['todoType']) ??
          ETodoType.day,
    )
      ..id = (json['id'] as num?)?.toInt()
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..forDate = DateTime.parse(json['forDate'] as String);

Map<String, dynamic> _$TodoEntityToJson(TodoEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'title': instance.title,
      'forDate': instance.forDate.toIso8601String(),
      'isComplete': TodoEntity._boolToInt(instance.isComplete),
      'todoType': _$ETodoTypeEnumMap[instance.todoType]!,
    };

const _$ETodoTypeEnumMap = {
  ETodoType.day: 'day',
  ETodoType.week: 'week',
  ETodoType.month: 'month',
};
