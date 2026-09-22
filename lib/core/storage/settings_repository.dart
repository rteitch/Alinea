import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class AppSettings {
  final String gatewayUrl;
  final String activeProviderId;
  final String byokKey;
  final String byokEndpoint;
  final String targetLanguage;
  final bool autoDetectLanguage;
  final List<String> detectionLanguages;
  final String readingTheme;
  final double fontSize;
  final String translationStyle;
  final int dailyGoalMinutes;
  final bool reminderEnabled;
  final int reminderHour;
  final int reminderMinute;
  final int gridColumns;

  const AppSettings({
    this.gatewayUrl = 'http://10.0.2.2:8000/v1',
    this.activeProviderId = 'foss_cloud',
    this.byokKey = '',
    this.byokEndpoint = 'https://api-free.deepl.com/v2/translate',
    this.targetLanguage = 'id',
    this.autoDetectLanguage = true,
    this.detectionLanguages = const ['en', 'id'],
    this.readingTheme = 'light',
    this.fontSize = 16.0,
    this.translationStyle = 'natural',
    this.dailyGoalMinutes = 30,
    this.reminderEnabled = false,
    this.reminderHour = 20,
    this.reminderMinute = 0,
    this.gridColumns = 2,
  });

  Map<String, dynamic> toJson() => {
        'gatewayUrl': gatewayUrl,
        'activeProviderId': activeProviderId,
        'byokKey': byokKey,
        'byokEndpoint': byokEndpoint,
        'targetLanguage': targetLanguage,
        'autoDetectLanguage': autoDetectLanguage,
        'detectionLanguages': detectionLanguages,
        'readingTheme': readingTheme,
        'fontSize': fontSize,
        'translationStyle': translationStyle,
        'dailyGoalMinutes': dailyGoalMinutes,
        'reminderEnabled': reminderEnabled,
        'reminderHour': reminderHour,
        'reminderMinute': reminderMinute,
        'gridColumns': gridColumns,
      };

  factory AppSettings.fromJson(Map<String, dynamic> json) {
    return AppSettings(
      gatewayUrl: json['gatewayUrl'] as String? ?? 'http://10.0.2.2:8000/v1',
      activeProviderId: json['activeProviderId'] as String? ?? 'foss_cloud',
      byokKey: json['byokKey'] as String? ?? '',
      byokEndpoint: json['byokEndpoint'] as String? ?? 'https://api-free.deepl.com/v2/translate',
      targetLanguage: json['targetLanguage'] as String? ?? 'id',
      autoDetectLanguage: json['autoDetectLanguage'] as bool? ?? true,
      detectionLanguages: (json['detectionLanguages'] as List<dynamic>?)?.map((e) => e as String).toList() ?? ['en', 'id'],
      readingTheme: json['readingTheme'] as String? ?? 'light',
      fontSize: (json['fontSize'] as num?)?.toDouble() ?? 16.0,
      translationStyle: json['translationStyle'] as String? ?? 'natural',
      dailyGoalMinutes: (json['dailyGoalMinutes'] as num?)?.toInt() ?? 30,
      reminderEnabled: json['reminderEnabled'] as bool? ?? false,
      reminderHour: (json['reminderHour'] as num?)?.toInt() ?? 20,
      reminderMinute: (json['reminderMinute'] as num?)?.toInt() ?? 0,
      gridColumns: (json['gridColumns'] as num?)?.toInt() ?? 2,
    );
  }

  AppSettings copyWith({
    String? gatewayUrl,
    String? activeProviderId,
    String? byokKey,
    String? byokEndpoint,
    String? targetLanguage,
    bool? autoDetectLanguage,
    List<String>? detectionLanguages,
    String? readingTheme,
    double? fontSize,
    String? translationStyle,
    int? dailyGoalMinutes,
    bool? reminderEnabled,
    int? reminderHour,
    int? reminderMinute,
    int? gridColumns,
  }) {
    return AppSettings(
      gatewayUrl: gatewayUrl ?? this.gatewayUrl,
      activeProviderId: activeProviderId ?? this.activeProviderId,
      byokKey: byokKey ?? this.byokKey,
      byokEndpoint: byokEndpoint ?? this.byokEndpoint,
      targetLanguage: targetLanguage ?? this.targetLanguage,
      autoDetectLanguage: autoDetectLanguage ?? this.autoDetectLanguage,
      detectionLanguages: detectionLanguages ?? this.detectionLanguages,
      readingTheme: readingTheme ?? this.readingTheme,
      fontSize: fontSize ?? this.fontSize,
      translationStyle: translationStyle ?? this.translationStyle,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderHour: reminderHour ?? this.reminderHour,
      reminderMinute: reminderMinute ?? this.reminderMinute,
      gridColumns: gridColumns ?? this.gridColumns,
    );
  }
}

class SettingsRepository {
  static const String _fileName = 'settings.json';
  final Dio _dio = Dio(
    BaseOptions(
      connectTimeout: const Duration(seconds: 4),
      receiveTimeout: const Duration(seconds: 4),
    ),
  );

  Future<File> _getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/$_fileName');
  }

  Future<AppSettings> loadSettings() async {
    try {
      final file = await _getFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        if (content.trim().isNotEmpty) {
          final json = jsonDecode(content) as Map<String, dynamic>;
          return AppSettings.fromJson(json);
        }
      }
    } catch (e) {
      debugPrint('[SettingsRepository] Failed to load settings: $e');
      // Fallback to default on error
    }
    return const AppSettings();
  }

  Future<void> saveSettings(AppSettings settings) async {
    try {
      final file = await _getFile();
      await file.writeAsString(jsonEncode(settings.toJson()), flush: true);
    } catch (e) {
      debugPrint('[SettingsRepository] Failed to save settings: $e');
    }
  }

  /// Pings the specified gateway URL to test connectivity
  Future<({bool success, String message, int? latencyMs})> testConnection(String rawUrl) async {
    var url = rawUrl.trim();
    if (url.endsWith('/')) url = url.substring(0, url.length - 1);
    if (url.endsWith('/translate')) url = url.substring(0, url.length - '/translate'.length);
    if (url.endsWith('/v1')) url = url.substring(0, url.length - '/v1'.length);
    final healthUrl = '$url/health';

    final stopwatch = Stopwatch()..start();
    try {
      final response = await _dio.get(healthUrl);
      stopwatch.stop();
      if (response.statusCode == 200) {
        return (
          success: true,
          message: 'Koneksi Berhasil! Server Gateway aktif.',
          latencyMs: stopwatch.elapsedMilliseconds,
        );
      } else {
        return (
          success: false,
          message: 'Server merespons kode status: ${response.statusCode}',
          latencyMs: stopwatch.elapsedMilliseconds,
        );
      }
    } on DioException catch (e) {
      stopwatch.stop();
      if (e.type == DioExceptionType.connectionTimeout) {
        return (
          success: false,
          message: 'Timeout: Tidak dapat terhubung ke $healthUrl. Periksa apakah IP sudah benar dan di jaringan yang sama.',
          latencyMs: null,
        );
      } else if (e.type == DioExceptionType.connectionError) {
        return (
          success: false,
          message: 'Koneksi ditolak: Pastikan server backend berjalan dengan --host 0.0.0.0.',
          latencyMs: null,
        );
      }
      return (
        success: false,
        message: 'Gagal terhubung: ${e.message}',
        latencyMs: null,
      );
    } catch (e) {
      stopwatch.stop();
      return (
        success: false,
        message: 'Error: $e',
        latencyMs: null,
      );
    }
  }
}
