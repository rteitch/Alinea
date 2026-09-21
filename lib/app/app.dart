import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers.dart';
import 'theme/app_theme.dart';
import '../features/splash/presentation/splash_screen.dart';
import '../l10n/app_localizations.dart';

class AlineaApp extends ConsumerWidget {
  const AlineaApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(readingThemeModeProvider);

    ThemeData theme;
    switch (themeMode) {
      case ReadingThemeMode.sepia:
        theme = AppTheme.sepiaTheme;
        break;
      case ReadingThemeMode.dark:
        theme = AppTheme.darkTheme;
        break;
      case ReadingThemeMode.amoled:
        theme = AppTheme.amoledTheme;
        break;
      case ReadingThemeMode.light:
        theme = AppTheme.lightTheme;
        break;
      case ReadingThemeMode.system:
        theme = MediaQuery.platformBrightnessOf(context) == Brightness.dark
            ? AppTheme.darkTheme
            : AppTheme.lightTheme;
        break;
    }

    return MaterialApp(
      title: 'Alinea',
      debugShowCheckedModeBanner: false,
      theme: theme,
      locale: ref.watch(localeProvider),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('en'),
        Locale('id'),
      ],
      home: const SplashScreen(),
    );
  }
}
