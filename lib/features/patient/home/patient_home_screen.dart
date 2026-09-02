import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_card.dart';
import '../../../data/fake_data/reminders.dart';
import '../../../data/models/reminder.dart';
import '../../caregiver/memory_circle/memory_circle_screen.dart';
import '../games/face_name_match/face_name_match_screen.dart';
import '../settings/patient_settings_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
            horizontal: 24,
            vertical: 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Good Morning, Leima! 🌸',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 20),

              Text(
                "Today's Memory Activities",
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              // MEMORY ACTIVITY
              AppCard(
                color: AppColors.primaryGreenLight,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: AppColors.primaryGreen,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.psychology_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Memory Activity',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Match familiar faces and names',
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const FaceNameMatchScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.play_circle_fill_rounded,
                        color: AppColors.primaryGreen,
                        size: 42,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // MEMORY CIRCLE
              AppCard(
                color: Colors.white,
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 58,
                      height: 58,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3B6C4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(
                        Icons.people_alt_rounded,
                        color: Colors.white,
                        size: 30,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Memory Circle',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'People, voices and memories',
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 8),

                    IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) => const MemoryCircleScreen(),
                          ),
                        );
                      },
                      icon: const Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppColors.primaryGreen,
                        size: 28,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              // REMINDERS
              Text(
                'Reminders',
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              ...FakeReminderData.reminders.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ReminderCard(reminder: r),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),

      bottomNavigationBar: _buildBottomNav(context),
    );
  }

  Widget _buildBottomNav(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.home,
              label: 'Home',
              active: true,
              onTap: () {},
            ),

            _NavItem(
              icon: Icons.mic,
              label: 'Voice',
              active: false,
              onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Voice Assistant — coming soon'),
                ),
              ),
            ),

            _NavItem(
              icon: Icons.settings,
              label: 'Settings',
              active: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PatientSettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const _ReminderCard({
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: reminder.color,
            child: Icon(
              reminder.icon,
              color: Colors.white,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Text(
              reminder.title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          Text(
            reminder.time,
            style: const TextStyle(
              color: AppColors.textMedium,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.active,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = active
        ? AppColors.primaryGreen
        : AppColors.textLight;

    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: color,
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
            ),
          ),
        ],
      ),
    );
  }
}