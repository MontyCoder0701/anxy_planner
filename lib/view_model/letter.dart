import '../model/entity/letter.dart';
import '../model/repository/letter.dart';
import 'base.dart';

class LetterProvider extends CrudProvider<LetterEntity> {
  @override
  get repository => LetterRepository();

  List<LetterEntity> get receivedLetters {
    return resources
        .where(
          (e) => e.forDate.isBefore(DateTime.now().add(Duration(days: 30))),
        )
        .toList();
  }

  int get sendLettersCount => resources.length - receivedLetters.length;

  bool get isUnopenedLettersExists => receivedLetters.any((e) => !e.isOpened);
}
