import 'package:json_annotation/json_annotation.dart';

abstract class BaseEntity {
  @JsonKey(includeToJson: false)
  int? id;

  @JsonKey()
  DateTime createdAt = DateTime.now();
}
