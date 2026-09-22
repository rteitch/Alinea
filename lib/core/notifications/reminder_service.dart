import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:timezone/data/latest_all.dart' as tz_data;
import 'package:timezone/timezone.dart' as tz;

/// Schedules the daily reading reminder notification.
///
/// Settings UI already persists [AppSettings.reminderEnabled] /
/// [reminderHour] / [reminderMinute]; this service is the delivery layer.
class ReminderService {
  ReminderService._();

  static const int _notificationId = 6001;
  static const String _channelId = 'reading_reminder';
  static const String _channelName = 'Pengingat Membaca';
  static const String _channelDescription =
      'Pengingat harian untuk melanjutkan membaca';

  static final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  static bool _initialized = false;

  static const NotificationDetails _details = NotificationDetails(
    android: AndroidNotificationDetails(
      _channelId,
      _channelName,
      channelDescription: _channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: '@mipmap/ic_launcher',
    ),
  );

  /// Initialize plugin + timezone database. Safe to call multiple times.
  static Future<void> init() async {
    if (_initialized) return;

    const androidInit = AndroidInitializationSettings('@mipmap/ic_launcher');
    const initSettings = InitializationSettings(android: androidInit);

    tz_data.initializeTimeZones();
    try {
      final tzName = await FlutterTimezone.getLocalTimezone();
      tz.setLocalLocation(tz.getLocation(tzName));
    } catch (e) {
      debugPrint('[ReminderService] Timezone lookup failed, using UTC: $e');
    }

    try {
      await _plugin.initialize(initSettings);
      _initialized = true;
    } catch (e) {
      debugPrint('[ReminderService] Init failed: $e');
    }
  }

  /// Request POST_NOTIFICATIONS permission (Android 13+). Returns true if granted.
  static Future<bool> requestPermission() async {
    final android = _plugin.resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return true;
    try {
      return await android.requestNotificationsPermission() ?? false;
    } catch (e) {
      debugPrint('[ReminderService] Permission request failed: $e');
      return false;
    }
  }

  /// Schedule a daily reminder at [hour]:[minute] (device-local time).
  static Future<void> scheduleDaily({
    required int hour,
    required int minute,
  }) async {
    if (!_initialized) await init();
    try {
      await _plugin.zonedSchedule(
        _notificationId,
        'Waktunya membaca 📚',
        'Lanjutkan bacaanmu hari ini — jangan lewatkan targetmu!',
        _nextInstanceOf(hour, minute),
        _details,
        androidScheduleMode: AndroidScheduleMode.inexactAllowWhileIdle,
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        matchDateTimeComponents: DateTimeComponents.time,
      );
    } catch (e) {
      debugPrint('[ReminderService] Schedule failed: $e');
    }
  }

  /// Cancel the pending daily reminder.
  static Future<void> cancel() async {
    try {
      await _plugin.cancel(_notificationId);
    } catch (e) {
      debugPrint('[ReminderService] Cancel failed: $e');
    }
  }

  static tz.TZDateTime _nextInstanceOf(int hour, int minute) {
    final now = tz.TZDateTime.now(tz.local);
    var scheduled =
        tz.TZDateTime(tz.local, now.year, now.month, now.day, hour, minute);
    if (scheduled.isBefore(now)) {
      scheduled = scheduled.add(const Duration(days: 1));
    }
    return scheduled;
  }
}
