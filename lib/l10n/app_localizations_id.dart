// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Indonesian (`id`).
class AppLocalizationsId extends AppLocalizations {
  AppLocalizationsId([String locale = 'id']) : super(locale);

  @override
  String get appTitle => 'Alinea';

  @override
  String get appTagline => 'READER';

  @override
  String get library => 'Perpustakaan';

  @override
  String get settings => 'Pengaturan';

  @override
  String get searchHint => 'Cari judul atau penulis...';

  @override
  String get filterAll => 'Semua';

  @override
  String get filterReading => 'Sedang Dibaca';

  @override
  String get filterFinished => 'Selesai';

  @override
  String get filterFavorite => 'Favorit';

  @override
  String get emptyLibrary => 'Belum ada buku';

  @override
  String get importEpub => 'Import EPUB';

  @override
  String get importing => 'Sedang memproses file EPUB...';

  @override
  String get sortDateAdded => 'Tanggal Ditambahkan';

  @override
  String get sortTitle => 'Judul (A-Z)';

  @override
  String get sortAuthor => 'Penulis (A-Z)';

  @override
  String get sortLastOpened => 'Terakhir Dibuka';

  @override
  String get gatewaySettings => 'URL Gateway';

  @override
  String get translationProvider => 'Mesin Translasi';

  @override
  String get fossCloud => 'Alinea FOSS Cloud';

  @override
  String get selfHosted => 'Self-Hosted';

  @override
  String get byok => 'BYOK (Bring Your Own Key)';

  @override
  String get targetLanguage => 'Bahasa Target';

  @override
  String get autoDetect => 'Otomatis';

  @override
  String languagePicker(Object count) {
    return '$count bahasa dipilih';
  }

  @override
  String get translationStyle => 'Gaya Terjemahan';

  @override
  String get natural => 'Natural';

  @override
  String get literal => 'Literal';

  @override
  String get academic => 'Akademis';

  @override
  String get themeAndComfort => 'Tema & Kenyamanan Mata';

  @override
  String get themeDesc =>
      'Pilih tema yang paling nyaman untuk sesi membaca panjang.';

  @override
  String get system => 'Sistem';

  @override
  String get light => 'Terang';

  @override
  String get sepia => 'Sepia';

  @override
  String get dark => 'Gelap';

  @override
  String get amoled => 'AMOLED';

  @override
  String get readingSettings => 'Pengaturan Membaca';

  @override
  String get fontFamily => 'Jenis Huruf';

  @override
  String get defaultFont => 'Default';

  @override
  String get sansSerif => 'Sans-Serif';

  @override
  String get monospace => 'Monospace';

  @override
  String get dataManagement => 'Manajemen Data';

  @override
  String get exportData => 'Ekspor Perpustakaan';

  @override
  String get importData => 'Impor Perpustakaan';

  @override
  String get backupDatabase => 'Backup Database';

  @override
  String get restoreDatabase => 'Restore Database';

  @override
  String get aboutAlinea => 'Tentang Alinea';

  @override
  String version(Object version) {
    return 'Versi $version (FOSS Edition)';
  }

  @override
  String bookmarks(Object count) {
    return 'Penanda ($count)';
  }

  @override
  String get addBookmark => 'Tambah Penanda';

  @override
  String get bookmarkNote => 'Catatan (opsional)';

  @override
  String get bookmarkNoteHint => 'Tulis catatan untuk bookmark ini...';

  @override
  String savedOn(Object date) {
    return 'Disimpan pada $date';
  }

  @override
  String get searchInBook => 'Cari dalam Buku';

  @override
  String get searchPlaceholder => 'Masukkan kata kunci...';

  @override
  String resultsFound(Object count) {
    return '$count hasil ditemukan';
  }

  @override
  String get typeToSearch => 'Ketik kata kunci untuk mencari';

  @override
  String get statistics => 'Statistik Membaca';

  @override
  String get totalTime => 'Waktu Total';

  @override
  String get chaptersRead => 'Bab Dibaca';

  @override
  String get wordsTranslated => 'Kata Diterjemahkan';

  @override
  String get totalSessions => 'Sesi Membaca';

  @override
  String get avgPerSession => 'Rata-rata per Sesi';

  @override
  String get exportStats => 'Ekspor Statistik';

  @override
  String get exportCSV => 'CSV';

  @override
  String get exportJSON => 'JSON';

  @override
  String get restoreConfirm => 'Semua data saat ini akan diganti. Lanjutkan?';

  @override
  String get restoring => 'Memulihkan database...';

  @override
  String get restoreSuccess => 'Database berhasil dipulihkan!';

  @override
  String get restartApp => 'Silakan restart app secara manual.';

  @override
  String get backToHome => 'Kembali ke Beranda';

  @override
  String get dailyReadingGoal => 'Target Membaca Harian';

  @override
  String get goalLabel => 'Target:';

  @override
  String get minutes => 'menit';

  @override
  String get minutesPerDay => 'menit/hari';

  @override
  String get goalComplete => 'Selesai!';

  @override
  String get backupSubtitle => 'Simpan semua data ke file backup';

  @override
  String get restoreSubtitle => 'Pulihkan data dari file backup';

  @override
  String get noChaptersFound => 'Tidak ada bab yang ditemukan dalam buku ini.';

  @override
  String get bookArchived => 'Buku telah diarsipkan.';
}
