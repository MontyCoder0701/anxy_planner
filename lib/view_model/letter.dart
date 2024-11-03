import '../model/entity/letter.dart';
import '../model/repository/letter.dart';
import 'base.dart';

class LetterProvider extends CrudProvider<LetterEntity> {
  @override
  get repository => LetterRepository();

  List<LetterEntity> get receivedLetters {
    return resources
        .where(
          (e) => e.forDate.isAfter(
            DateTime.now().copyWith(month: DateTime.now().month + 1),
          ),
        )
        .toList();
  }

  int get sendLettersCount => resources.length - receivedLetters.length;
}
