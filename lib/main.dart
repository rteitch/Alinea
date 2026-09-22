import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app/app.dart';
import 'core/notifications/reminder_service.dart';
import 'core/storage/settings_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await _restoreReminder();
  runApp(
    const ProviderScope(
      child: AlineaApp(),
    ),
  );
}

/// Re-schedule the daily reading reminder after app restart / update.
Future<void> _restoreReminder() async {
  try {
    await ReminderService.init();
    final settings = await SettingsRepository().loadSettings();
    if (settings.reminderEnabled) {
      await ReminderService.scheduleDaily(
        hour: settings.reminderHour,
        minute: settings.reminderMinute,
      );
    }
  } catch (_) {
    // Never block app startup on notification failures.
  }
}
