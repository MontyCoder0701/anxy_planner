import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ko.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ko'),
  ];

  /// No description provided for @confirmDelete.
  ///
  /// In en, this message translates to:
  /// **'Delete this?'**
  String get confirmDelete;

  /// No description provided for @noNetworkConnection.
  ///
  /// In en, this message translates to:
  /// **'There seems to be a problem with the network. Please check your connection.'**
  String get noNetworkConnection;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'An unknown issue has occurred. Please contact the developer.'**
  String get unknownError;

  /// No description provided for @tourDialogSlide1Text1.
  ///
  /// In en, this message translates to:
  /// **'If you think too far into the future, it can feel overwhelming.'**
  String get tourDialogSlide1Text1;

  /// No description provided for @tourDialogSlide1Text2.
  ///
  /// In en, this message translates to:
  /// **'How about focusing only on this month?'**
  String get tourDialogSlide1Text2;

  /// No description provided for @tourDialogSlide2Text1.
  ///
  /// In en, this message translates to:
  /// **'Try writing your to-dos based on this month.'**
  String get tourDialogSlide2Text1;

  /// No description provided for @tourDialogSlide2Text2.
  ///
  /// In en, this message translates to:
  /// **'You might find life becomes simpler.'**
  String get tourDialogSlide2Text2;

  /// No description provided for @tourDialogSlide3Text1.
  ///
  /// In en, this message translates to:
  /// **'With a slow letterbox, '**
  String get tourDialogSlide3Text1;

  /// No description provided for @tourDialogSlide3Text2.
  ///
  /// In en, this message translates to:
  /// **'write a letter to your future self for the next month.'**
  String get tourDialogSlide3Text2;

  /// No description provided for @tourDialogSlide4Text1.
  ///
  /// In en, this message translates to:
  /// **'When the month is over,'**
  String get tourDialogSlide4Text1;

  /// No description provided for @tourDialogSlide4Text2.
  ///
  /// In en, this message translates to:
  /// **'all to-dos will be reset.'**
  String get tourDialogSlide4Text2;

  /// No description provided for @tourDialogSlide4Text3.
  ///
  /// In en, this message translates to:
  /// **'Shall we start One Moon now?'**
  String get tourDialogSlide4Text3;

  /// No description provided for @unopenedLettersSnackBar.
  ///
  /// In en, this message translates to:
  /// **'You have unopened letters.'**
  String get unopenedLettersSnackBar;

  /// No description provided for @todos.
  ///
  /// In en, this message translates to:
  /// **'Todos'**
  String get todos;

  /// No description provided for @letters.
  ///
  /// In en, this message translates to:
  /// **'Letters'**
  String get letters;

  /// No description provided for @moonSteps.
  ///
  /// In en, this message translates to:
  /// **'Moon Steps'**
  String get moonSteps;

  /// No description provided for @moonStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Memories of Each Month'**
  String get moonStepsTitle;

  /// No description provided for @moonStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each \'Month\' Todo becomes a moonstep.'**
  String get moonStepsSubtitle;

  /// No description provided for @noMoonStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Moonsteps Yet.'**
  String get noMoonStepsTitle;

  /// No description provided for @noMoonStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new month todo.'**
  String get noMoonStepsSubtitle;

  /// No description provided for @daySteps.
  ///
  /// In en, this message translates to:
  /// **'Day Steps'**
  String get daySteps;

  /// No description provided for @dayStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'Memories of Each Day'**
  String get dayStepsTitle;

  /// No description provided for @dayStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Each \'Day\' Todo becomes a daystep.'**
  String get dayStepsSubtitle;

  /// No description provided for @noDayStepsTitle.
  ///
  /// In en, this message translates to:
  /// **'No Daysteps Yet.'**
  String get noDayStepsTitle;

  /// No description provided for @noDayStepsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Add a new todo for the day.'**
  String get noDayStepsSubtitle;

  /// No description provided for @appInfo.
  ///
  /// In en, this message translates to:
  /// **'App Info'**
  String get appInfo;

  /// No description provided for @toggleTheme.
  ///
  /// In en, this message translates to:
  /// **'Change Theme'**
  String get toggleTheme;

  /// No description provided for @toggleFirstDaySunday.
  ///
  /// In en, this message translates to:
  /// **'Set First Day as Sunday'**
  String get toggleFirstDaySunday;

  /// No description provided for @cleanupData.
  ///
  /// In en, this message translates to:
  /// **'Clean Up Hidden Data'**
  String get cleanupData;

  /// No description provided for @cleanupDataDescription.
  ///
  /// In en, this message translates to:
  /// **'Deleting hidden data will make the app lighter.'**
  String get cleanupDataDescription;

  /// No description provided for @confirmCleanup.
  ///
  /// In en, this message translates to:
  /// **'Do you want to clean up the data?'**
  String get confirmCleanup;

  /// No description provided for @dataCleaned.
  ///
  /// In en, this message translates to:
  /// **'Data has been cleaned.'**
  String get dataCleaned;

  /// No description provided for @contactDeveloper.
  ///
  /// In en, this message translates to:
  /// **'Contact the Developer'**
  String get contactDeveloper;

  /// No description provided for @emailToDeveloperSubject.
  ///
  /// In en, this message translates to:
  /// **'One Moon - Feedback'**
  String get emailToDeveloperSubject;

  /// No description provided for @viewLicense.
  ///
  /// In en, this message translates to:
  /// **'View License'**
  String get viewLicense;

  /// No description provided for @experimental.
  ///
  /// In en, this message translates to:
  /// **'Experimental'**
  String get experimental;

  /// No description provided for @experimentalSubtitle.
  ///
  /// In en, this message translates to:
  /// **'These features are still in testing.'**
  String get experimentalSubtitle;

  /// No description provided for @backupDataToDrive.
  ///
  /// In en, this message translates to:
  /// **'Backup To Google Drive'**
  String get backupDataToDrive;

  /// No description provided for @backupDataDescription1.
  ///
  /// In en, this message translates to:
  /// **'This will encrypt and backup your data to Google Drive.'**
  String get backupDataDescription1;

  /// No description provided for @backupDataDescription2.
  ///
  /// In en, this message translates to:
  /// **'Now you can recover your data with when switching devices.'**
  String get backupDataDescription2;

  /// No description provided for @backupDataComplete.
  ///
  /// In en, this message translates to:
  /// **'Data has been exported. You can recover your data with Google Drive.'**
  String get backupDataComplete;

  /// No description provided for @restoreDataFromDrive.
  ///
  /// In en, this message translates to:
  /// **'Restore From Google Drive'**
  String get restoreDataFromDrive;

  /// No description provided for @restoreDataDescription1.
  ///
  /// In en, this message translates to:
  /// **'Import your previously backed-up data.'**
  String get restoreDataDescription1;

  /// No description provided for @restoreDataDescription2.
  ///
  /// In en, this message translates to:
  /// **'Your current data will be overwritten.'**
  String get restoreDataDescription2;

  /// No description provided for @restartApp.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app.'**
  String get restartApp;

  /// No description provided for @restartAppDescription.
  ///
  /// In en, this message translates to:
  /// **'Your old data will be applied.'**
  String get restartAppDescription;

  /// No description provided for @noBackupFile.
  ///
  /// In en, this message translates to:
  /// **'No backup file exists. Make sure to backup a file with Google Drive first.'**
  String get noBackupFile;

  /// No description provided for @sendLetterboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Slow Letterbox'**
  String get sendLetterboxTitle;

  /// No description provided for @sendLetterboxSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Send a letter to yourself.'**
  String get sendLetterboxSubtitle;

  /// No description provided for @preparedLettersCount.
  ///
  /// In en, this message translates to:
  /// **'{letterCount} letter(s) ready to be sent.'**
  String preparedLettersCount(int letterCount);

  /// No description provided for @awaitingLettersMessage.
  ///
  /// In en, this message translates to:
  /// **'You\'ll see this in a month!'**
  String get awaitingLettersMessage;

  /// No description provided for @receivedLetterboxTitle.
  ///
  /// In en, this message translates to:
  /// **'Received Inbox'**
  String get receivedLetterboxTitle;

  /// No description provided for @noReceivedLetters.
  ///
  /// In en, this message translates to:
  /// **'No received letters yet.'**
  String get noReceivedLetters;

  /// No description provided for @fromLastMonth.
  ///
  /// In en, this message translates to:
  /// **'From last month\'s me.'**
  String get fromLastMonth;

  /// No description provided for @writeToMyself.
  ///
  /// In en, this message translates to:
  /// **'To next month\'s me.'**
  String get writeToMyself;

  /// No description provided for @subjectRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a subject.'**
  String get subjectRequired;

  /// No description provided for @contentRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the content.'**
  String get contentRequired;

  /// No description provided for @fromCurrentSelf.
  ///
  /// In en, this message translates to:
  /// **'From current me.'**
  String get fromCurrentSelf;

  /// No description provided for @letterSent.
  ///
  /// In en, this message translates to:
  /// **'The letter has been placed in the mailbox.'**
  String get letterSent;

  /// No description provided for @todo.
  ///
  /// In en, this message translates to:
  /// **'Todo'**
  String get todo;

  /// No description provided for @noTodos.
  ///
  /// In en, this message translates to:
  /// **'No todos.'**
  String get noTodos;

  /// No description provided for @createTodo.
  ///
  /// In en, this message translates to:
  /// **'Create A Todo'**
  String get createTodo;

  /// No description provided for @editTodo.
  ///
  /// In en, this message translates to:
  /// **'Edit This Todo'**
  String get editTodo;

  /// No description provided for @todoRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a todo.'**
  String get todoRequired;

  /// No description provided for @thisDay.
  ///
  /// In en, this message translates to:
  /// **'This Day'**
  String get thisDay;

  /// No description provided for @thisWeek.
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// No description provided for @thisMonth.
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// No description provided for @thisDayTodoLabel.
  ///
  /// In en, this message translates to:
  /// **'For This Day'**
  String get thisDayTodoLabel;

  /// No description provided for @thisWeekTodoLabel.
  ///
  /// In en, this message translates to:
  /// **'For This Week'**
  String get thisWeekTodoLabel;

  /// No description provided for @thisMonthTodoLabel.
  ///
  /// In en, this message translates to:
  /// **'For This Month'**
  String get thisMonthTodoLabel;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ko'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ko':
      return AppLocalizationsKo();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
