import '../entity/letter.dart';
import 'local.dart';

class LetterRepository extends LocalRepository<LetterEntity> {
  @override
  get key => 'letter';

  @override
  toJson(item) => item.toJson();

  @override
  fromJson(Map<String, dynamic> json) => LetterEntity.fromJson(json);
}
