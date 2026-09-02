import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/speaker_button.dart';
import '../language_selection/language_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String _welcomeSpeech =
      'Welcome to YaadSaathi. A little memory, a lot of love.';

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageController.instance.language;
    final l10n = AppLocalizations.of(language);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // --------------------------------------------------
          // FULL SCREEN LANDSCAPE
          // --------------------------------------------------
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_landscape.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  color: AppColors.primaryGreenLight,
                );
              },
            ),
          ),

          // --------------------------------------------------
          // FOREGROUND CONTENT
          // --------------------------------------------------
          SafeArea(
            child: Column(
              children: [
                // Speaker button
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Align(
                    alignment: Alignment.topRight,
                    child: SpeakerButton(
                      text: _welcomeSpeech,
                      size: 48,
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                // --------------------------------------------------
                // YAADSAATHI LOGO
                // --------------------------------------------------
                Image.asset(
                  'assets/images/yaadsaathi_logo.png',
                  width: 270,
                  height: 235,
                  fit: BoxFit.contain,
                  errorBuilder: (context, error, stackTrace) {
                    return const SizedBox(
                      width: 270,
                      height: 235,
                    );
                  },
                ),

                // Give the landscape some breathing room
                const Spacer(),

                // --------------------------------------------------
                // GET STARTED BUTTON
                // --------------------------------------------------
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(
                    28,
                    24,
                    28,
                    20,
                  ),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: AppButton(
                    label: l10n.getStarted,
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const LanguageSelectionScreen(),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}