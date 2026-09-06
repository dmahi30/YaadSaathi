import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/speaker_button.dart';
import 'caregiver_registration_screen.dart';
import 'caregiver_sign_in_screen.dart';

class CaregiverAuthScreen extends StatelessWidget {
  const CaregiverAuthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageController.instance.language;
    final l10n = AppLocalizations.of(language);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _BackButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  SpeakerButton(
                    text:
                        '${l10n.welcomeCaregiver}. '
                        '${l10n.togetherLetsMakeEveryDayBrighter}',
                    size: 50,
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    Text(
                      l10n.welcomeCaregiver,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      l10n.togetherLetsMakeEveryDayBrighter,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 1.4,
                        color: AppColors.textMedium,
                      ),
                    ),

                    const SizedBox(height: 22),

                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: Container(
                        width: double.infinity,
                        height: 245,
                        decoration: BoxDecoration(
                          color: AppColors.primaryGreenLight,
                          border: Border.all(
                            color: AppColors.border,
                          ),
                        ),
                        child: Image.asset(
                          'assets/images/sign_in_bg.png',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.favorite_rounded,
                                size: 48,
                                color: Color(0xFFE85D75),
                              ),
                            );
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // SIGN IN
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CaregiverSignInScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.login_rounded,
                          size: 23,
                        ),
                        label: Text(
                          l10n.signIn,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      l10n.alreadyHaveAnAccount,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),

                    const SizedBox(height: 16),

                    // REGISTER
                    SizedBox(
                      width: double.infinity,
                      height: 58,
                      child: OutlinedButton.icon(
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const CaregiverRegistrationScreen(),
                            ),
                          );
                        },
                        icon: const Icon(
                          Icons.person_add_alt_1_rounded,
                          size: 23,
                        ),
                        label: Text(
                          l10n.registerAsCaregiver,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primaryGreen,
                          side: const BorderSide(
                            color: AppColors.primaryGreen,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 7),

                    Text(
                      l10n.newToSmritiCircle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _BackButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onPressed,
        customBorder: const CircleBorder(),
        child: const SizedBox(
          width: 50,
          height: 50,
          child: Icon(
            Icons.arrow_back_ios_new_rounded,
            size: 20,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}