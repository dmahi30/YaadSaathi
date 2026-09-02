import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/app_card.dart';
import '../../../../core/widgets/speaker_button.dart';
import '../../../../data/models/family_member.dart';
import '../../../../data/models/game_session.dart';
import '../../result/activity_result_screen.dart';
import 'face_name_controller.dart';

class FaceNameMatchScreen extends StatefulWidget {
  const FaceNameMatchScreen({super.key});

  @override
  State<FaceNameMatchScreen> createState() => _FaceNameMatchScreenState();
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
    if (mounted) setState(() {});
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
      setState(() => _showFeedback = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Not quite — let's try again 💚"),
          backgroundColor: AppColors.warning,
          duration: Duration(seconds: 2),
        ),
      );
      _controller.resetSelection();
    }
  }

  void _onNext() {
    final hasMore = _controller.nextQuestion();
    setState(() => _showFeedback = false);

    if (!hasMore) {
      final session = GameSession(
        totalQuestions: _controller.totalCount,
        correctAnswers: _controller.correctCount,
        completedAt: DateTime.now(),
      );
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => ActivityResultScreen(session: session)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              _buildTopBar(),
              const SizedBox(height: 24),
              Expanded(
                child: _showFeedback ? _buildCorrectFeedback() : _buildQuestion(),
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
          onPressed: () => Navigator.of(context).maybePop(),
          icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
        ),
        Expanded(
          child: Row(
            children: List.generate(_controller.totalCount, (i) {
              final active = i <= _controller.currentIndex;
              return Expanded(
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  decoration: BoxDecoration(
                    color: active ? AppColors.primaryGreen : AppColors.border,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              );
            }),
          ),
        ),
        const SizedBox(width: 8),
        const Icon(Icons.pause_circle_outline, color: AppColors.textMedium),
      ],
    );
  }

  Widget _buildQuestion() {
    final question = _controller.currentQuestion;

    return SingleChildScrollView(
      child: Column(
        children: [
          Text('Who is this?',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 28),
          CircleAvatar(
            radius: 80,
            backgroundColor: question.correctMember.avatarColor,
            child: Text(
              question.correctMember.name[0],
              style: const TextStyle(
                  fontSize: 56, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 20),
          Text('Tap the correct name.',
              style: Theme.of(context).textTheme.bodyLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 24),
          ...question.options.map((member) {
            final selected = _controller.selectedOptionId == member.id;
            return Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: AppCard(
                color: selected ? AppColors.primaryGreenLight : AppColors.surfaceCard,
                onTap: () => _onOptionTap(member),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundColor: member.avatarColor,
                      child: Text(member.name[0],
                          style: const TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(member.name,
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    if (selected)
                      const Icon(Icons.check_circle, color: AppColors.success),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCorrectFeedback() {
    final member = _controller.currentQuestion.correctMember;

    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: 12),
          const Text('🎉', style: TextStyle(fontSize: 56)),
          const SizedBox(height: 12),
          Text('Great Job!',
              style: Theme.of(context).textTheme.headlineMedium,
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          CircleAvatar(
            radius: 70,
            backgroundColor: member.avatarColor,
            child: Text(
              member.name[0],
              style: const TextStyle(
                  fontSize: 48, fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text("Yes! That's ${member.name}.",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center),
          const SizedBox(height: 20),
          SpeakerButton(text: member.voiceText),
          const SizedBox(height: 32),
          AppButton(
            label: _controller.isLastQuestion ? 'See Result' : 'Next',
            onPressed: _onNext,
          ),
        ],
      ),
    );
  }
}