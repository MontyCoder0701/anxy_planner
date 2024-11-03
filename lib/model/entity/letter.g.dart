// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterEntity _$LetterEntityFromJson(Map<String, dynamic> json) => LetterEntity(
      subject: json['subject'] as String? ?? '',
      content: json['content'] as String? ?? '',
      isOpened: json['isOpened'] == null
          ? false
          : boolFromInt((json['isOpened'] as num).toInt()),
    )
      ..id = (json['id'] as num?)?.toInt()
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..forDate = DateTime.parse(json['forDate'] as String);

Map<String, dynamic> _$LetterEntityToJson(LetterEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'subject': instance.subject,
      'content': instance.content,
      'isOpened': boolToInt(instance.isOpened),
      'forDate': instance.forDate.toIso8601String(),
    };
