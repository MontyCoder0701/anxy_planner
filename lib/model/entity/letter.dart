import 'package:json_annotation/json_annotation.dart';

import 'base.dart';

part 'letter.g.dart';

@JsonSerializable()
class LetterEntity extends BaseEntity {
  @JsonKey()
  String subject;

  @JsonKey()
  String content;

  @JsonKey(fromJson: boolFromInt, toJson: boolToInt)
  bool isOpened;

  @JsonKey()
  DateTime forDate = DateTime.now().copyWith(month: DateTime.now().month + 1);

  LetterEntity({
    this.subject = '',
    this.content = '',
    this.isOpened = false,
  });

  factory LetterEntity.fromJson(Map<String, dynamic> json) =>
      _$LetterEntityFromJson(json);

  Map<String, dynamic> toJson() => _$LetterEntityToJson(this);
}
