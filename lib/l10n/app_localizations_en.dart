// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get confirmDelete => 'Delete this?';

  @override
  String get noNetworkConnection => 'There seems to be a problem with the network. Please check your connection.';

  @override
  String get unknownError => 'An unknown issue has occurred. Please contact the developer.';

  @override
  String get tourDialogSlide1Text1 => 'If you think too far into the future, it can feel overwhelming.';

  @override
  String get tourDialogSlide1Text2 => 'How about focusing only on this month?';

  @override
  String get tourDialogSlide2Text1 => 'Try writing your to-dos based on this month.';

  @override
  String get tourDialogSlide2Text2 => 'You might find life becomes simpler.';

  @override
  String get tourDialogSlide3Text1 => 'With a slow letterbox, ';

  @override
  String get tourDialogSlide3Text2 => 'write a letter to your future self for the next month.';

  @override
  String get tourDialogSlide4Text1 => 'When the month is over,';

  @override
  String get tourDialogSlide4Text2 => 'all to-dos will be reset.';

  @override
  String get tourDialogSlide4Text3 => 'Shall we start One Moon now?';

  @override
  String get unopenedLettersSnackBar => 'You have unopened letters.';

  @override
  String get todos => 'Todos';

  @override
  String get letters => 'Letters';

  @override
  String get moonSteps => 'Moon Steps';

  @override
  String get moonStepsTitle => 'Memories of Each Month';

  @override
  String get moonStepsSubtitle => 'Each \'Month\' Todo becomes a moonstep.';

  @override
  String get noMoonStepsTitle => 'No Moonsteps Yet.';

  @override
  String get noMoonStepsSubtitle => 'Add a new month todo.';

  @override
  String get appInfo => 'App Info';

  @override
  String get toggleTheme => 'Change Theme';

  @override
  String get toggleFirstDaySunday => 'Set First Day as Sunday';

  @override
  String get cleanupData => 'Clean Up Hidden Data';

  @override
  String get cleanupDataDescription => 'Deleting hidden data will make the app lighter.';

  @override
  String get confirmCleanup => 'Do you want to clean up the data?';

  @override
  String get dataCleaned => 'Data has been cleaned.';

  @override
  String get contactDeveloper => 'Contact the Developer';

  @override
  String get emailToDeveloperSubject => 'One Moon - Feedback';

  @override
  String get viewLicense => 'View License';

  @override
  String get experimental => 'Experimental';

  @override
  String get experimentalSubtitle => 'These features are still in testing.';

  @override
  String get backupDataToDrive => 'Backup To Google Drive';

  @override
  String get backupDataDescription1 => 'This will encrypt and backup your data to Google Drive.';

  @override
  String get backupDataDescription2 => 'Now you can recover your data with when switching devices.';

  @override
  String get backupDataComplete => 'Data has been exported. You can recover your data with Google Drive.';

  @override
  String get restoreDataFromDrive => 'Restore From Google Drive';

  @override
  String get restoreDataDescription1 => 'Import your previously backed-up data.';

  @override
  String get restoreDataDescription2 => 'Your current data will be overwritten.';

  @override
  String get restartApp => 'Please restart the app.';

  @override
  String get restartAppDescription => 'Your old data will be applied.';

  @override
  String get noBackupFile => 'No backup file exists. Make sure to backup a file with Google Drive first.';

  @override
  String get sendLetterboxTitle => 'Slow Letterbox';

  @override
  String get sendLetterboxSubtitle => 'Send a letter to yourself.';

  @override
  String preparedLettersCount(int letterCount) {
    return '$letterCount letter(s) ready to be sent.';
  }

  @override
  String get awaitingLettersMessage => 'You\'ll see this in a month!';

  @override
  String get receivedLetterboxTitle => 'Received Inbox';

  @override
  String get noReceivedLetters => 'No received letters yet.';

  @override
  String get fromLastMonth => 'From last month\'s me.';

  @override
  String get writeToMyself => 'To next month\'s me.';

  @override
  String get subjectRequired => 'Please enter a subject.';

  @override
  String get contentRequired => 'Please enter the content.';

  @override
  String get fromCurrentSelf => 'From current me.';

  @override
  String get letterSent => 'The letter has been placed in the mailbox.';

  @override
  String get todo => 'Todo';

  @override
  String get noTodos => 'No todos.';

  @override
  String get createTodo => 'Create A Todo';

  @override
  String get editTodo => 'Edit This Todo';

  @override
  String get todoRequired => 'Please enter a todo.';

  @override
  String get thisDay => 'This Day';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get thisDayTodoLabel => 'For This Day';

  @override
  String get thisWeekTodoLabel => 'For This Week';

  @override
  String get thisMonthTodoLabel => 'For This Month';
}
