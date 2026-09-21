// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Alinea';

  @override
  String get appTagline => 'READER';

  @override
  String get library => 'Library';

  @override
  String get settings => 'Settings';

  @override
  String get searchHint => 'Search title or author...';

  @override
  String get filterAll => 'All';

  @override
  String get filterReading => 'Reading';

  @override
  String get filterFinished => 'Finished';

  @override
  String get filterFavorite => 'Favorite';

  @override
  String get emptyLibrary => 'No books yet';

  @override
  String get importEpub => 'Import EPUB';

  @override
  String get importing => 'Processing EPUB file...';

  @override
  String get sortDateAdded => 'Date Added';

  @override
  String get sortTitle => 'Title (A-Z)';

  @override
  String get sortAuthor => 'Author (A-Z)';

  @override
  String get sortLastOpened => 'Last Opened';

  @override
  String get gatewaySettings => 'Gateway Base URL';

  @override
  String get translationProvider => 'Translation Engine';

  @override
  String get fossCloud => 'Alinea FOSS Cloud';

  @override
  String get selfHosted => 'Self-Hosted';

  @override
  String get byok => 'BYOK (Bring Your Own Key)';

  @override
  String get targetLanguage => 'Target Language';

  @override
  String get autoDetect => 'Auto-Detect';

  @override
  String languagePicker(Object count) {
    return '$count languages selected';
  }

  @override
  String get translationStyle => 'Translation Style';

  @override
  String get natural => 'Natural';

  @override
  String get literal => 'Literal';

  @override
  String get academic => 'Academic';

  @override
  String get themeAndComfort => 'Theme & Eye Comfort';

  @override
  String get themeDesc =>
      'Choose the most comfortable theme for long reading sessions.';

  @override
  String get system => 'System';

  @override
  String get light => 'Light';

  @override
  String get sepia => 'Sepia';

  @override
  String get dark => 'Dark';

  @override
  String get amoled => 'AMOLED';

  @override
  String get readingSettings => 'Reading Settings';

  @override
  String get fontFamily => 'Font Family';

  @override
  String get defaultFont => 'Default';

  @override
  String get sansSerif => 'Sans-Serif';

  @override
  String get monospace => 'Monospace';

  @override
  String get dataManagement => 'Data Management';

  @override
  String get exportData => 'Export Library';

  @override
  String get importData => 'Import Library';

  @override
  String get backupDatabase => 'Backup Database';

  @override
  String get restoreDatabase => 'Restore Database';

  @override
  String get aboutAlinea => 'About Alinea';

  @override
  String version(Object version) {
    return 'Version $version (FOSS Edition)';
  }

  @override
  String bookmarks(Object count) {
    return 'Bookmarks ($count)';
  }

  @override
  String get addBookmark => 'Add Bookmark';

  @override
  String get bookmarkNote => 'Note (optional)';

  @override
  String get bookmarkNoteHint => 'Write a note for this bookmark...';

  @override
  String savedOn(Object date) {
    return 'Saved on $date';
  }

  @override
  String get searchInBook => 'Search in Book';

  @override
  String get searchPlaceholder => 'Enter keyword...';

  @override
  String resultsFound(Object count) {
    return '$count results found';
  }

  @override
  String get typeToSearch => 'Type a keyword to search';

  @override
  String get statistics => 'Reading Statistics';

  @override
  String get totalTime => 'Total Time';

  @override
  String get chaptersRead => 'Chapters Read';

  @override
  String get wordsTranslated => 'Words Translated';

  @override
  String get totalSessions => 'Reading Sessions';

  @override
  String get avgPerSession => 'Average per Session';

  @override
  String get exportStats => 'Export Statistics';

  @override
  String get exportCSV => 'CSV';

  @override
  String get exportJSON => 'JSON';

  @override
  String get restoreConfirm => 'All current data will be replaced. Continue?';

  @override
  String get restoring => 'Restoring database...';

  @override
  String get restoreSuccess => 'Database restored successfully!';

  @override
  String get restartApp => 'Please restart the app manually.';

  @override
  String get backToHome => 'Back to Home';
}
