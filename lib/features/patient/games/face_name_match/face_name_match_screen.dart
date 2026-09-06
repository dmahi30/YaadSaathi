import 'package:flutter/material.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/localization/app_language_controller.dart';
import '../../../../core/localization/app_localizations.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/speaker_button.dart';
import '../../../../core/services/sync_service.dart';
import '../../../../core/state/patient_profile_controller.dart';
import '../../../../data/models/family_member.dart';
import '../../../../data/models/game_session.dart';
import '../../result/activity_result_screen.dart';
import 'face_name_controller.dart';

class FaceNameMatchScreen extends StatefulWidget {
  const FaceNameMatchScreen({super.key});

  @override
  State<FaceNameMatchScreen> createState() =>
      _FaceNameMatchScreenState();
}

class _FaceNameMatchScreenState extends State<FaceNameMatchScreen> {
  late final FaceNameController _controller;

  bool _showFeedback = false;

  @override
  void initState() {
    super.initState();

    _controller = FaceNameController();
    _controller.addListener(_onControllerChanged);
  }

  void _onControllerChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onControllerChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onOptionTap(FamilyMember tapped) {
    if (_showFeedback) return;

    final correct = _controller.submitAnswer(tapped);

    if (correct) {
      setState(() {
        _showFeedback = true;
      });
    } else {
      _onNext();
    }
  }

  Future<void> _onNext() async {
    final hasMore = _controller.nextQuestion();

    setState(() {
      _showFeedback = false;
    });

    if (!hasMore) {
      final session = GameSession(
        totalQuestions: _controller.totalCount,
        correctAnswers: _controller.correctCount,
        completedAt: DateTime.now(),
      );

      // Use the real patient ID created by Patient Profile.
      final patientId =
          patientProfileController.patientId.trim();

      // Save the game only when a valid patient ID exists.
      if (patientId.isNotEmpty) {
        await SyncService.saveGameSession(
          patientId: patientId,
          gameType: 'face_name_match',
          session: session,
        );
      }

      if (!mounted) return;

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (_) => ActivityResultScreen(
            session: session,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final language =
        AppLanguageController.instance.language;

    final l10n = AppLocalizations.of(language);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 12,
          ),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              Expanded(
                child: _showFeedback
                    ? _buildCorrectFeedback(l10n)
                    : _buildQuestion(l10n),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      children: [
        IconButton(
          onPressed: () {
            Navigator.of(context).maybePop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: AppColors.textDark,
            size: 34,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Row(
            children: List.generate(
              _controller.totalCount,
              (i) {
                final active =
                    i <= _controller.currentIndex;

                return Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 3,
                    ),
                    height: 6,
                    decoration: BoxDecoration(
                      color: active
                          ? AppColors.primaryGreen
                          : AppColors.border,
                      borderRadius:
                          BorderRadius.circular(4),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(
          Icons.pause_circle_outline,
          color: AppColors.textMedium,
          size: 36,
        ),
      ],
    );
  }

  Widget _buildQuestion(
    AppLocalizations l10n,
  ) {
    final question = _controller.currentQuestion;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text(
            l10n.whoIsThis,
            style:
                Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 28),
          Container(
            width: 230,
            height: 230,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                question.correctMember.imagePath,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color:
                        question.correctMember.avatarColor,
                    alignment: Alignment.center,
                    child: Text(
                      question.correctMember.name[0],
                      style: const TextStyle(
                        fontSize: 70,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 24),
          Text(
            l10n.tapCorrectName,
            style:
                Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 20,
                    ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ...question.options.map(
            (member) {
              final selected =
                  _controller.selectedOptionId ==
                      member.id;

              final translatedName =
                  l10n.familyMemberName(member.id);

              return Padding(
                padding:
                    const EdgeInsets.only(bottom: 14),
                child: AppCard(
                  color: selected
                      ? AppColors.primaryGreenLight
                      : AppColors.surfaceCard,
                  onTap: () => _onOptionTap(member),
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 52,
                        height: 52,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: member.avatarColor,
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          translatedName[0],
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Text(
                          translatedName,
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(
                                fontSize: 22,
                                fontWeight:
                                    FontWeight.w500,
                              ),
                        ),
                      ),
                      if (selected)
                        const Icon(
                          Icons.check_circle,
                          color: AppColors.success,
                          size: 30,
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildCorrectFeedback(
    AppLocalizations l10n,
  ) {
    final member =
        _controller.currentQuestion.correctMember;

    final translatedName =
        l10n.familyMemberName(member.id);

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text(
            '🎉',
            style: TextStyle(fontSize: 56),
          ),
          const SizedBox(height: 12),
          Text(
            l10n.greatJob,
            style:
                Theme.of(context).textTheme.headlineMedium,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          Container(
            width: 190,
            height: 190,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: Colors.white,
                width: 8,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.10,
                  ),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ClipOval(
              child: Image.asset(
                member.imagePath,
                fit: BoxFit.cover,
                errorBuilder:
                    (context, error, stackTrace) {
                  return Container(
                    color: member.avatarColor,
                    alignment: Alignment.center,
                    child: Text(
                      translatedName[0],
                      style: const TextStyle(
                        fontSize: 60,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 18),
          Text(
            '${l10n.yes}! $translatedName.',
            style:
                Theme.of(context).textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 20),
          SpeakerButton(
            text: '${l10n.yes}! $translatedName.',
          ),
          const SizedBox(height: 32),
          AppButton(
            label: _controller.isLastQuestion
                ? l10n.seeResult
                : l10n.next,
            onPressed: _onNext,
          ),
        ],
      ),
    );
  }
}