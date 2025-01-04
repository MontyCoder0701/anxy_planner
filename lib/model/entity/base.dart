import 'package:json_annotation/json_annotation.dart';

abstract class BaseEntity {
  @JsonKey(includeToJson: false)
  int? id;

  @JsonKey()
  DateTime createdAt = DateTime.now();
}

bool boolFromInt(int intInput) => intInput == 1;

int boolToInt(bool boolInput) => boolInput ? 1 : 0;
