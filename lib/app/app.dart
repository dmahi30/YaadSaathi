import 'package:flutter/material.dart';

import '../core/constants/app_constants.dart';
import '../core/localization/app_language_controller.dart';
import '../features/onboarding/welcome/welcome_screen.dart';
import 'theme.dart';

class SmritiCircleApp extends StatelessWidget {
  const SmritiCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppLanguageController.instance,
      builder: (context, child) {
        return MaterialApp(
          title: AppConstants.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          home: const WelcomeScreen(),
        );
      },
    );
  }
}