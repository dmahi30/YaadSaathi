import 'package:flutter/material.dart';
import '../core/constants/app_constants.dart';
import '../features/onboarding/welcome/welcome_screen.dart';
import 'theme.dart';

class SmritiCircleApp extends StatelessWidget {
  const SmritiCircleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const WelcomeScreen(),
    );
  }
}