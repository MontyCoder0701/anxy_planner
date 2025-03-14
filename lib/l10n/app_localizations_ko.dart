// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get confirmDelete => '삭제할까요?';

  @override
  String get noNetworkConnection => '네트워크 연결에 문제가 있어요. 인터넷 연결을 확인해주세요.';

  @override
  String get unknownError => '알 수 없는 문제가 발생했어요. 개발자에게 문의해주세요.';

  @override
  String get tourDialogSlide1Text1 => '너무 먼 미래를 생각하다보면 막막합니다.';

  @override
  String get tourDialogSlide1Text2 => '한달 기준으로만 생각해보면 어떨까요?';

  @override
  String get tourDialogSlide2Text1 => '한달 기준으로만 투두를 작성해보세요.';

  @override
  String get tourDialogSlide2Text2 => '의외로 삶이 간단해질 수 있습니다.';

  @override
  String get tourDialogSlide3Text1 => '느린 우체통처럼, ';

  @override
  String get tourDialogSlide3Text2 => '다음달 나를 위해 편지도 써보세요.';

  @override
  String get tourDialogSlide4Text1 => '한달이 지나면';

  @override
  String get tourDialogSlide4Text2 => '모든 투두는 초기화됩니다.';

  @override
  String get tourDialogSlide4Text3 => '이제 One Moon을 시작해볼까요?';

  @override
  String get unopenedLettersSnackBar => '아직 읽지 않은 편지가 있네요.';

  @override
  String get todos => '할 일';

  @override
  String get letters => '편지';

  @override
  String get moonSteps => '달자취';

  @override
  String get moonStepsTitle => '그 달의 기억들';

  @override
  String get moonStepsSubtitle => '이번 달 할일은 달자취가 되어요.';

  @override
  String get noMoonStepsTitle => '달자취가 아직 없어요.';

  @override
  String get noMoonStepsSubtitle => '이번 달 할 일을 추가해보세요.';

  @override
  String get appInfo => '앱 정보';

  @override
  String get toggleTheme => '테마 바꾸기';

  @override
  String get toggleFirstDaySunday => '한주의 시작으로 일요일로';

  @override
  String get cleanupData => '숨어있는 데이터 정리하기';

  @override
  String get cleanupDataDescription => '숨어있는 데이터를 삭제해 앱이 가벼워질거에요.';

  @override
  String get confirmCleanup => '데이터를 정리할까요?';

  @override
  String get dataCleaned => '데이터가 정리되었습니다.';

  @override
  String get contactDeveloper => '개발자에게 문의하기';

  @override
  String get emailToDeveloperSubject => 'One Moon - 피드백';

  @override
  String get viewLicense => '라이센스 보기';

  @override
  String get experimental => '실험실';

  @override
  String get experimentalSubtitle => '아직 실험중인 기능이에요.';

  @override
  String get backupDataToDrive => '구글 드라이브에 백업하기';

  @override
  String get backupDataDescription1 => '내 데이터를 암호화해서 구글 드라이브에 백업해요.';

  @override
  String get backupDataDescription2 => '한번 백업하면 기기를 바꿔도 복구할 수 있어요.';

  @override
  String get backupDataComplete => '데이터를 저장했어요. 이제 구글 드라이브로 복구가 가능해요.';

  @override
  String get restoreDataFromDrive => '구글 드라이브에서 복구하기';

  @override
  String get restoreDataDescription1 => '백업했던 데이터를 다시 받아와요.';

  @override
  String get restoreDataDescription2 => '내 데이터는 덮어씌워져요.';

  @override
  String get restartApp => '앱을 재시작 해주세요.';

  @override
  String get restartAppDescription => '내 예전 데이터가 적용됩니다.';

  @override
  String get noBackupFile => '백업 파일이 없어요. 우선 구글 드라이브로 데이터 백업을 진행하세요.';

  @override
  String get sendLetterboxTitle => '한달 후 보낼 우편함';

  @override
  String get sendLetterboxSubtitle => '나에게 편지를 보내보세요.';

  @override
  String preparedLettersCount(int letterCount) {
    return '$letterCount통이 준비되었습니다.';
  }

  @override
  String get awaitingLettersMessage => '조금만 기다려요. 곧 만날거에요!';

  @override
  String get receivedLetterboxTitle => '나에게 받은 편지함';

  @override
  String get noReceivedLetters => '받은 편지가 아직 없어요.';

  @override
  String get fromLastMonth => 'From: 지난 달의 나.';

  @override
  String get writeToMyself => '한달 후 나에게.';

  @override
  String get subjectRequired => '제목을 적어주세요.';

  @override
  String get contentRequired => '내용을 적어주세요.';

  @override
  String get fromCurrentSelf => 'From: 지금의 나.';

  @override
  String get letterSent => '편지를 우편함에 넣었어요.';

  @override
  String get todo => '할 일';

  @override
  String get noTodos => '할 일이 없어요.';

  @override
  String get createTodo => '할 일 만들기';

  @override
  String get editTodo => '할 일 수정하기';

  @override
  String get todoRequired => '할 일을 적어주세요';

  @override
  String get thisDay => '이 날';

  @override
  String get thisWeek => '이번 주';

  @override
  String get thisMonth => '이번 달';

  @override
  String get thisDayTodoLabel => '이 날 할 일';

  @override
  String get thisWeekTodoLabel => '이번 주 할 일';

  @override
  String get thisMonthTodoLabel => '이번 달 할 일';
}
