import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const int score = 80;
    const int correctAnswers = 4;
    const int totalQuestions = 5;

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Caregiver Dashboard',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hello, Caregiver 👋',
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              const Text(
                'Here is Leima\'s latest activity.',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textMedium,
                ),
              ),

              const SizedBox(height: 24),

              AppCard(
                color: AppColors.primaryGreenLight,
                child: Row(
                  children: [
                    Container(
                      width: 64,
                      height: 64,
                      decoration: const BoxDecoration(
                        color: AppColors.primaryGreen,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.psychology,
                        color: Colors.white,
                        size: 34,
                      ),
                    ),

                    const SizedBox(width: 16),

                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Latest Cognitive Activity',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            'Face & Name Match',
                            style: TextStyle(
                              fontSize: 15,
                              color: AppColors.textMedium,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              Row(
                children: [
                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.star,
                            size: 32,
                            color: AppColors.primaryGreen,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Score',
                            style: TextStyle(
                              color: AppColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$score%',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(width: 14),

                  Expanded(
                    child: AppCard(
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            size: 32,
                            color: AppColors.success,
                          ),
                          const SizedBox(height: 8),
                          const Text(
                            'Correct',
                            style: TextStyle(
                              color: AppColors.textMedium,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '$correctAnswers/$totalQuestions',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(
                          Icons.auto_awesome,
                          color: AppColors.primaryGreen,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'AI Insight',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textDark,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      'Leima performed well in today\'s memory activity. '
                      'The system can gradually increase the difficulty '
                      'when accuracy remains high.',
                      style: TextStyle(
                        fontSize: 16,
                        height: 1.5,
                        color: AppColors.textMedium,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              AppCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Activity Summary',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 16),

                    _summaryRow(
                      Icons.games,
                      'Activities Completed',
                      '1',
                    ),

                    const SizedBox(height: 12),

                    _summaryRow(
                      Icons.memory,
                      'Memory Score',
                      '$score%',
                    ),

                    const SizedBox(height: 12),

                    _summaryRow(
                      Icons.notifications_active,
                      'Alerts',
                      'No new alerts',
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _summaryRow(
    IconData icon,
    String title,
    String value,
  ) {
    return Row(
      children: [
        Icon(
          icon,
          color: AppColors.primaryGreen,
          size: 24,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              color: AppColors.textMedium,
            ),
          ),
        ),
        Text(
          value,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }
}