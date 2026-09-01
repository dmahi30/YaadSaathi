import 'package:flutter/material.dart';

import 'features/caregiver/memory_circle/memory_circle_screen.dart';

void main() {
  runApp(const YaadSaathiApp());
}

class YaadSaathiApp extends StatelessWidget {
  const YaadSaathiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Yaad Saathi',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'Roboto',
        colorSchemeSeed: const Color(0xFF3FA34D),
        scaffoldBackgroundColor: Colors.white,
      ),
      // Jumping straight to the Memory Circle screen for now so you
      // can preview it without wiring up routes/onboarding yet.
      // Swap this for your real routes.dart / initial route later.
      home: MemoryCircleScreen(patientName: 'Leima'),
    );
  }
}