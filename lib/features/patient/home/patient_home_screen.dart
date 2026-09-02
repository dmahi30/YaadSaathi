import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
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
    final language = AppLanguageController.instance.language;
    final l10n = AppLocalizations.of(language);

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
              // --------------------------------------------------
              // GREETING
              // --------------------------------------------------
              Text(
                '${l10n.goodMorning}, Leima! 🌸',
                style: Theme.of(context).textTheme.headlineMedium,
              ),

              const SizedBox(height: 20),

              // --------------------------------------------------
              // MEMORY ACTIVITY TITLE
              // --------------------------------------------------
              Text(
                l10n.memoryActivity,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              // --------------------------------------------------
              // MEMORY ACTIVITY CARD
              // --------------------------------------------------
              AppCard(
                color: AppColors.primaryGreenLight,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FAMILY PHOTOS + PLAY BUTTON
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                            children: [
                              _FamilyPhoto(
                                imagePath:
                                    'assets/images/characters/meera.jpeg',
                              ),
                              _FamilyPhoto(
                                imagePath:
                                    'assets/images/characters/rahul.jpeg',
                              ),
                              _FamilyPhoto(
                                imagePath:
                                    'assets/images/characters/asha.jpeg',
                              ),
                              _FamilyPhoto(
                                imagePath:
                                    'assets/images/characters/arun.jpeg',
                              ),
                              _FamilyPhoto(
                                imagePath:
                                    'assets/images/characters/dadi.jpeg',
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(width: 4),

                        // PLAY BUTTON
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints(
                            minWidth: 42,
                            minHeight: 42,
                          ),
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (_) =>
                                    const FaceNameMatchScreen(),
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

                    const SizedBox(height: 14),

                    Text(
                      l10n.memoryActivity,
                      style: Theme.of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      l10n.matchFamiliarFaces,
                      style: const TextStyle(
                        color: AppColors.textMedium,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // --------------------------------------------------
              // MEMORY CIRCLE
              // --------------------------------------------------
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
                        crossAxisAlignment:
                            CrossAxisAlignment.start,
                        children: [
                          Text(
                            l10n.memoryCircle,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium,
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n.peopleVoicesMemories,
                            style: const TextStyle(
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
                            builder: (_) =>
                                const MemoryCircleScreen(),
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

              // --------------------------------------------------
              // REMINDERS
              // --------------------------------------------------
              Text(
                l10n.reminders,
                style: Theme.of(context).textTheme.titleLarge,
              ),

              const SizedBox(height: 12),

              ...FakeReminderData.reminders.map(
                (r) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _ReminderCard(
                    reminder: r,
                  ),
                ),
              ),

              const SizedBox(height: 12),
            ],
          ),
        ),
      ),

      // --------------------------------------------------
      // BOTTOM NAVIGATION
      // --------------------------------------------------
      bottomNavigationBar: _buildBottomNav(
        context,
        l10n,
      ),
    );
  }

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNav(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            _NavItem(
              icon: Icons.home,
              label: l10n.home,
              active: true,
              onTap: () {},
            ),

            _NavItem(
              icon: Icons.mic,
              label: l10n.voice,
              active: false,
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.voiceAssistantComingSoon,
                    ),
                  ),
                );
              },
            ),

            _NavItem(
              icon: Icons.settings,
              label: l10n.settings,
              active: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const PatientSettingsScreen(),
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

// ============================================================
// FAMILY PHOTO
// ============================================================

class _FamilyPhoto extends StatelessWidget {
  final String imagePath;

  const _FamilyPhoto({
    required this.imagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      child: ClipOval(
        child: Image.asset(
          imagePath,
          fit: BoxFit.cover,
          errorBuilder: (
            context,
            error,
            stackTrace,
          ) {
            return Container(
              color: AppColors.border,
              child: const Icon(
                Icons.person,
                color: Colors.white,
                size: 22,
              ),
            );
          },
        ),
      ),
    );
  }
}

// ============================================================
// REMINDER CARD
// ============================================================

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

// ============================================================
// BOTTOM NAV ITEM
// ============================================================

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