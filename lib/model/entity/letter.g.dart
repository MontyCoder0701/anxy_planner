// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'letter.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

LetterEntity _$LetterEntityFromJson(Map<String, dynamic> json) => LetterEntity(
      subject: json['subject'] as String? ?? '',
      content: json['content'] as String? ?? '',
    )
      ..id = (json['id'] as num?)?.toInt()
      ..createdAt = DateTime.parse(json['createdAt'] as String)
      ..forDate = DateTime.parse(json['forDate'] as String);

Map<String, dynamic> _$LetterEntityToJson(LetterEntity instance) =>
    <String, dynamic>{
      'createdAt': instance.createdAt.toIso8601String(),
      'subject': instance.subject,
      'content': instance.content,
      'forDate': instance.forDate.toIso8601String(),
    };
