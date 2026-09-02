import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/state/app_settings_controller.dart';
import '../core/localization/app_language_controller.dart';
import '../features/onboarding/welcome/welcome_screen.dart';
import 'theme.dart';
import 'high_contrast_theme.dart';

class SmritiCircleApp extends StatelessWidget {
  const SmritiCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        appSettings,
        AppLanguageController.instance,
      ]),
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,

          // Switches the ENTIRE app between normal
          // and high-contrast display.
          theme: appSettings.isHighContrast
              ? AppHighContrastTheme.theme
              : AppTheme.lightTheme,

          // Applies text size to the ENTIRE app.
          builder: (context, child) {
            final mediaQuery = MediaQuery.of(context);

            return MediaQuery(
              data: mediaQuery.copyWith(
                textScaler: TextScaler.linear(
                  appSettings.textScaleFactor,
                ),
              ),
              child: child ?? const SizedBox.shrink(),
            );
          },

          home: const WelcomeScreen(),
        );
      },
    );
  }
}