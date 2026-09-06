import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_button.dart';
import '../../../data/models/game_session.dart';
import '../../caregiver/pin_access/caregiver_pin_screen.dart';
import '../games/face_name_match/face_name_match_screen.dart';
import '../home/patient_home_screen.dart';

class ActivityResultScreen extends StatelessWidget {
  final GameSession session;

  const ActivityResultScreen({
    super.key,
    required this.session,
  });

  @override
  Widget build(BuildContext context) {
    final language = AppLanguageController.instance.language;
    final l10n = AppLocalizations.of(language);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 28,
            vertical: 20,
          ),
          child: Column(
            children: [
              const Spacer(),

              Text(
                '${l10n.greatEffort} 🌟',
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 10),

              Text(
                '${l10n.remembered} ${session.correctAnswers}',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 32),

              Container(
                width: 140,
                height: 140,
                decoration: const BoxDecoration(
                  color: AppColors.primaryGreenLight,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text(
                    '⭐',
                    style: TextStyle(fontSize: 64),
                  ),
                ),
              ),

              const SizedBox(height: 32),

              _StatRow(
                label: l10n.score,
                value: '${session.scorePercent}%',
              ),

              const SizedBox(height: 12),

              _StatRow(
                label: l10n.correctAnswers,
                value:
                    '${session.correctAnswers} / ${session.totalQuestions}',
              ),

              const Spacer(),

              AppButton(
                label: l10n.playAgain,
                icon: Icons.refresh,
                onPressed: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(
                      builder: (_) => const FaceNameMatchScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 14),

              AppButton(
                label: l10n.backHome,
                icon: Icons.home_rounded,
                style: AppButtonStyle.outlined,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(
                      builder: (_) => const PatientHomeScreen(),
                    ),
                    (route) => false,
                  );
                },
              ),

              const SizedBox(height: 14),

              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => CaregiverPinScreen(
                        session: session,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Caregiver Access →',
                  style: TextStyle(
                    color: AppColors.textMedium,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatRow extends StatelessWidget {
  final String label;
  final String value;

  const _StatRow({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          '$label: ',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        Text(
          value,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.primaryGreen,
                fontWeight: FontWeight.bold,
              ),
        ),
      ],
    );
  }
}