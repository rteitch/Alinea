import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_id.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('id'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Alinea'**
  String get appTitle;

  /// No description provided for @appTagline.
  ///
  /// In en, this message translates to:
  /// **'READER'**
  String get appTagline;

  /// No description provided for @library.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get library;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @searchHint.
  ///
  /// In en, this message translates to:
  /// **'Search title or author...'**
  String get searchHint;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get filterAll;

  /// No description provided for @filterReading.
  ///
  /// In en, this message translates to:
  /// **'Reading'**
  String get filterReading;

  /// No description provided for @filterFinished.
  ///
  /// In en, this message translates to:
  /// **'Finished'**
  String get filterFinished;

  /// No description provided for @filterFavorite.
  ///
  /// In en, this message translates to:
  /// **'Favorite'**
  String get filterFavorite;

  /// No description provided for @emptyLibrary.
  ///
  /// In en, this message translates to:
  /// **'No books yet'**
  String get emptyLibrary;

  /// No description provided for @importEpub.
  ///
  /// In en, this message translates to:
  /// **'Import EPUB'**
  String get importEpub;

  /// No description provided for @importing.
  ///
  /// In en, this message translates to:
  /// **'Processing EPUB file...'**
  String get importing;

  /// No description provided for @sortDateAdded.
  ///
  /// In en, this message translates to:
  /// **'Date Added'**
  String get sortDateAdded;

  /// No description provided for @sortTitle.
  ///
  /// In en, this message translates to:
  /// **'Title (A-Z)'**
  String get sortTitle;

  /// No description provided for @sortAuthor.
  ///
  /// In en, this message translates to:
  /// **'Author (A-Z)'**
  String get sortAuthor;

  /// No description provided for @sortLastOpened.
  ///
  /// In en, this message translates to:
  /// **'Last Opened'**
  String get sortLastOpened;

  /// No description provided for @gatewaySettings.
  ///
  /// In en, this message translates to:
  /// **'Gateway Base URL'**
  String get gatewaySettings;

  /// No description provided for @translationProvider.
  ///
  /// In en, this message translates to:
  /// **'Translation Engine'**
  String get translationProvider;

  /// No description provided for @fossCloud.
  ///
  /// In en, this message translates to:
  /// **'Alinea FOSS Cloud'**
  String get fossCloud;

  /// No description provided for @selfHosted.
  ///
  /// In en, this message translates to:
  /// **'Self-Hosted'**
  String get selfHosted;

  /// No description provided for @byok.
  ///
  /// In en, this message translates to:
  /// **'BYOK (Bring Your Own Key)'**
  String get byok;

  /// No description provided for @targetLanguage.
  ///
  /// In en, this message translates to:
  /// **'Target Language'**
  String get targetLanguage;

  /// No description provided for @autoDetect.
  ///
  /// In en, this message translates to:
  /// **'Auto-Detect'**
  String get autoDetect;

  /// No description provided for @languagePicker.
  ///
  /// In en, this message translates to:
  /// **'{count} languages selected'**
  String languagePicker(Object count);

  /// No description provided for @translationStyle.
  ///
  /// In en, this message translates to:
  /// **'Translation Style'**
  String get translationStyle;

  /// No description provided for @natural.
  ///
  /// In en, this message translates to:
  /// **'Natural'**
  String get natural;

  /// No description provided for @literal.
  ///
  /// In en, this message translates to:
  /// **'Literal'**
  String get literal;

  /// No description provided for @academic.
  ///
  /// In en, this message translates to:
  /// **'Academic'**
  String get academic;

  /// No description provided for @themeAndComfort.
  ///
  /// In en, this message translates to:
  /// **'Theme & Eye Comfort'**
  String get themeAndComfort;

  /// No description provided for @themeDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose the most comfortable theme for long reading sessions.'**
  String get themeDesc;

  /// No description provided for @system.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get system;

  /// No description provided for @light.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get light;

  /// No description provided for @sepia.
  ///
  /// In en, this message translates to:
  /// **'Sepia'**
  String get sepia;

  /// No description provided for @dark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get dark;

  /// No description provided for @amoled.
  ///
  /// In en, this message translates to:
  /// **'AMOLED'**
  String get amoled;

  /// No description provided for @readingSettings.
  ///
  /// In en, this message translates to:
  /// **'Reading Settings'**
  String get readingSettings;

  /// No description provided for @fontFamily.
  ///
  /// In en, this message translates to:
  /// **'Font Family'**
  String get fontFamily;

  /// No description provided for @defaultFont.
  ///
  /// In en, this message translates to:
  /// **'Default'**
  String get defaultFont;

  /// No description provided for @sansSerif.
  ///
  /// In en, this message translates to:
  /// **'Sans-Serif'**
  String get sansSerif;

  /// No description provided for @monospace.
  ///
  /// In en, this message translates to:
  /// **'Monospace'**
  String get monospace;

  /// No description provided for @dataManagement.
  ///
  /// In en, this message translates to:
  /// **'Data Management'**
  String get dataManagement;

  /// No description provided for @exportData.
  ///
  /// In en, this message translates to:
  /// **'Export Library'**
  String get exportData;

  /// No description provided for @importData.
  ///
  /// In en, this message translates to:
  /// **'Import Library'**
  String get importData;

  /// No description provided for @backupDatabase.
  ///
  /// In en, this message translates to:
  /// **'Backup Database'**
  String get backupDatabase;

  /// No description provided for @restoreDatabase.
  ///
  /// In en, this message translates to:
  /// **'Restore Database'**
  String get restoreDatabase;

  /// No description provided for @aboutAlinea.
  ///
  /// In en, this message translates to:
  /// **'About Alinea'**
  String get aboutAlinea;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version {version} (FOSS Edition)'**
  String version(Object version);

  /// No description provided for @bookmarks.
  ///
  /// In en, this message translates to:
  /// **'Bookmarks ({count})'**
  String bookmarks(Object count);

  /// No description provided for @addBookmark.
  ///
  /// In en, this message translates to:
  /// **'Add Bookmark'**
  String get addBookmark;

  /// No description provided for @bookmarkNote.
  ///
  /// In en, this message translates to:
  /// **'Note (optional)'**
  String get bookmarkNote;

  /// No description provided for @bookmarkNoteHint.
  ///
  /// In en, this message translates to:
  /// **'Write a note for this bookmark...'**
  String get bookmarkNoteHint;

  /// No description provided for @savedOn.
  ///
  /// In en, this message translates to:
  /// **'Saved on {date}'**
  String savedOn(Object date);

  /// No description provided for @searchInBook.
  ///
  /// In en, this message translates to:
  /// **'Search in Book'**
  String get searchInBook;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter keyword...'**
  String get searchPlaceholder;

  /// No description provided for @resultsFound.
  ///
  /// In en, this message translates to:
  /// **'{count} results found'**
  String resultsFound(Object count);

  /// No description provided for @typeToSearch.
  ///
  /// In en, this message translates to:
  /// **'Type a keyword to search'**
  String get typeToSearch;

  /// No description provided for @statistics.
  ///
  /// In en, this message translates to:
  /// **'Reading Statistics'**
  String get statistics;

  /// No description provided for @totalTime.
  ///
  /// In en, this message translates to:
  /// **'Total Time'**
  String get totalTime;

  /// No description provided for @chaptersRead.
  ///
  /// In en, this message translates to:
  /// **'Chapters Read'**
  String get chaptersRead;

  /// No description provided for @wordsTranslated.
  ///
  /// In en, this message translates to:
  /// **'Words Translated'**
  String get wordsTranslated;

  /// No description provided for @totalSessions.
  ///
  /// In en, this message translates to:
  /// **'Reading Sessions'**
  String get totalSessions;

  /// No description provided for @avgPerSession.
  ///
  /// In en, this message translates to:
  /// **'Average per Session'**
  String get avgPerSession;

  /// No description provided for @exportStats.
  ///
  /// In en, this message translates to:
  /// **'Export Statistics'**
  String get exportStats;

  /// No description provided for @exportCSV.
  ///
  /// In en, this message translates to:
  /// **'CSV'**
  String get exportCSV;

  /// No description provided for @exportJSON.
  ///
  /// In en, this message translates to:
  /// **'JSON'**
  String get exportJSON;

  /// No description provided for @restoreConfirm.
  ///
  /// In en, this message translates to:
  /// **'All current data will be replaced. Continue?'**
  String get restoreConfirm;

  /// No description provided for @restoring.
  ///
  /// In en, this message translates to:
  /// **'Restoring database...'**
  String get restoring;

  /// No description provided for @restoreSuccess.
  ///
  /// In en, this message translates to:
  /// **'Database restored successfully!'**
  String get restoreSuccess;

  /// No description provided for @restartApp.
  ///
  /// In en, this message translates to:
  /// **'Please restart the app manually.'**
  String get restartApp;

  /// No description provided for @backToHome.
  ///
  /// In en, this message translates to:
  /// **'Back to Home'**
  String get backToHome;

  /// No description provided for @dailyReadingGoal.
  ///
  /// In en, this message translates to:
  /// **'Daily Reading Goal'**
  String get dailyReadingGoal;

  /// No description provided for @goalLabel.
  ///
  /// In en, this message translates to:
  /// **'Goal:'**
  String get goalLabel;

  /// No description provided for @minutes.
  ///
  /// In en, this message translates to:
  /// **'min'**
  String get minutes;

  /// No description provided for @minutesPerDay.
  ///
  /// In en, this message translates to:
  /// **'min/day'**
  String get minutesPerDay;

  /// No description provided for @goalComplete.
  ///
  /// In en, this message translates to:
  /// **'Done!'**
  String get goalComplete;

  /// No description provided for @backupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Save all data to backup file'**
  String get backupSubtitle;

  /// No description provided for @restoreSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Restore data from backup file'**
  String get restoreSubtitle;

  /// No description provided for @noChaptersFound.
  ///
  /// In en, this message translates to:
  /// **'No chapters found in this book.'**
  String get noChaptersFound;

  /// No description provided for @bookArchived.
  ///
  /// In en, this message translates to:
  /// **'Book has been archived.'**
  String get bookArchived;
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
      <String>['en', 'id'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'id':
      return AppLocalizationsId();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
