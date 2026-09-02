import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../core/state/app_settings_controller.dart';
import '../features/onboarding/welcome/welcome_screen.dart';
import 'high_contrast_theme.dart';
import 'theme.dart';

class SmritiCircleApp extends StatelessWidget {
  const SmritiCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Wraps the whole MaterialApp (not just its child) so both the theme
    // (Display: High Contrast) and text scaling (Text Size) can change
    // live, app-wide, whenever appSettings updates.
    return ListenableBuilder(
      listenable: appSettings,
      builder: (context, _) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: appSettings.isHighContrast
              ? AppHighContrastTheme.theme
              : AppTheme.lightTheme,
          home: const WelcomeScreen(),
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: TextScaler.linear(appSettings.textScaleFactor),
              ),
              child: child!,
            );
          },
        );
      },
    );
  }
}