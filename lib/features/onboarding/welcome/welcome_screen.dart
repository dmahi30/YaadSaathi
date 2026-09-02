import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/speaker_button.dart';
import '../language_selection/language_selection_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  static const String _welcomeSpeech =
      'Welcome to YaadSaathi. A little memory, a lot of love.';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          // Full-screen background — the landscape image itself is
          // completely untouched, just displayed edge-to-edge.
          Positioned.fill(
            child: Image.asset(
              'assets/images/welcome_landscape.png',
              fit: BoxFit.cover,
              alignment: Alignment.center,
              errorBuilder: (context, error, stackTrace) {
                // Safety net only — asset is confirmed present and
                // declared in pubspec.yaml.
                return Container(color: AppColors.primaryGreenLight);
              },
            ),
          ),

          // Foreground UI, layered on top of the background image.
          SafeArea(
            child: Column(
              children: [
                // Top content sits on a translucent white panel so
                // the text stays readable over the image behind it.
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
                    decoration: BoxDecoration(
                      color: AppColors.background.withValues(alpha: 0.92),
                      borderRadius: BorderRadius.circular(28),
                    ),
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.topRight,
                          child: SpeakerButton(text: _welcomeSpeech, size: 44),
                        ),
                        const SizedBox(height: 4),
                        _buildLogo(),
                        const SizedBox(height: 18),
                        Text(
                          'YaadSaathi',
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 14),
                        Text(
                          'A little memory,\na lot of love.',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                color: AppColors.primaryGreen,
                                fontWeight: FontWeight.w600,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          'AI-powered activities and\nreminders for happier days.',
                          style: Theme.of(context).textTheme.bodyLarge,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Landscape shows through freely here — nothing
                // covers it in the middle of the screen.
                const Spacer(),

                // Bottom rounded white panel holding the button.
                // The landscape image continues behind and around
                // it — this container only claims the space it
                // visually needs, not the full remaining height.
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(28, 24, 28, 20),
                  decoration: const BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(32),
                      topRight: Radius.circular(32),
                    ),
                  ),
                  child: AppButton(
                    label: 'Get Started',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const LanguageSelectionScreen(),
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

  static Widget _buildLogo() {
    // No confirmed logo asset in the project yet — built from
    // existing Flutter/Material resources only, no new image file.
    // Swap for Image.asset('assets/images/<real_logo_filename>')
    // the moment the actual filename is confirmed.
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: AppColors.primaryGreenLight,
        border: Border.all(color: AppColors.primaryGreen, width: 2),
      ),
      child: const Center(
        child: Icon(Icons.park_rounded, size: 46, color: AppColors.primaryGreen),
      ),
    );
  }
}