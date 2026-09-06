import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/state/patient_name_controller.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/speaker_button.dart';
import '../../../data/fake_data/reminders.dart';
import '../../../data/models/reminder.dart';
import '../../caregiver/memory_circle/memory_circle_screen.dart';
import '../games/face_name_match/face_name_match_screen.dart';
import '../settings/patient_settings_screen.dart';

class PatientHomeScreen extends StatelessWidget {
  const PatientHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppLanguageController.instance,
        PatientNameController.instance,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.current();

        final patientName =
            PatientNameController.instance.firstName;

        return Scaffold(
          extendBody: true,
          backgroundColor: Colors.transparent,

          body: Stack(
            children: [
              // =====================================================
              // FULL SCREEN BACKGROUND
              // =====================================================
              Positioned.fill(
                child: Image.asset(
                  'assets/images/welcome_landscape.png',
                  fit: BoxFit.cover,
                  alignment: Alignment.center,
                ),
              ),

              // =====================================================
              // LIGHT OVERLAY
              // =====================================================
              Positioned.fill(
                child: Container(
                  color: Colors.white.withValues(alpha: 0.18),
                ),
              ),

              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(
                    24,
                    18,
                    24,
                    120,
                  ),
                  child: Column(
                    children: [
                      // =====================================================
                      // TOP BAR
                      // =====================================================
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 9,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8F5E9),
                              borderRadius:
                                  BorderRadius.circular(24),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Container(
                                  width: 12,
                                  height: 12,
                                  decoration:
                                      const BoxDecoration(
                                    color:
                                        AppColors.primaryGreen,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  l10n.online,
                                  style: const TextStyle(
                                    color:
                                        AppColors.primaryGreen,
                                    fontSize: 16,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // =================================================
                          // TOP SPEAKER
                          // This one speaks ONLY the greeting.
                          // =================================================
                          SpeakerButton(
                            text: patientName.isEmpty
                                ? l10n.goodMorning
                                : '${l10n.goodMorning} $patientName',
                            size: 58,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // =====================================================
                      // GREETING
                      // =====================================================
                      Text(
                        '${l10n.goodMorning},\n$patientName! 🌸',
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textDark,
                          height: 1.15,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // =====================================================
                      // TODAY'S MEMORY ACTIVITY
                      // =====================================================
                      AppCard(
                        color:
                            Colors.white.withValues(alpha: 0.95),
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment:
                                  CrossAxisAlignment.start,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    color: AppColors
                                        .primaryGreenLight,
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                  ),
                                  child: const Icon(
                                    Icons.groups_rounded,
                                    color:
                                        AppColors.primaryGreen,
                                    size: 36,
                                  ),
                                ),

                                const SizedBox(width: 16),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        l10n
                                            .todaysMemoryActivity,
                                        style:
                                            Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(
                                                  fontWeight:
                                                      FontWeight
                                                          .w800,
                                                ),
                                      ),
                                      const SizedBox(height: 6),
                                      Text(
                                        l10n
                                            .peopleVoicesMemories,
                                        style: const TextStyle(
                                          color:
                                              AppColors.textMedium,
                                          fontSize: 17,
                                          height: 1.35,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 18),

                            SizedBox(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.of(context).push(
                                    MaterialPageRoute(
                                      builder: (_) =>
                                          const FaceNameMatchScreen(),
                                    ),
                                  );
                                },
                                style:
                                    ElevatedButton.styleFrom(
                                  backgroundColor:
                                      AppColors.primaryGreen,
                                  foregroundColor:
                                      Colors.white,
                                  minimumSize:
                                      const Size(
                                    double.infinity,
                                    58,
                                  ),
                                  shape:
                                      RoundedRectangleBorder(
                                    borderRadius:
                                        BorderRadius.circular(
                                            18),
                                  ),
                                ),
                                child: Text(
                                  l10n.startActivity,
                                  style: const TextStyle(
                                    fontSize: 19,
                                    fontWeight:
                                        FontWeight.w700,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // =====================================================
                      // QUICK CARDS
                      // =====================================================
                      Row(
                        children: [
                          Expanded(
                            child: _QuickReminderCard(
                              icon:
                                  Icons.medication_rounded,
                              iconColor:
                                  const Color(0xFFF3B6C4),
                              title: l10n.medicine,
                              subtitle: '8:00 AM',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _QuickReminderCard(
                              icon:
                                  Icons.water_drop_rounded,
                              iconColor:
                                  const Color(0xFFA8D0E6),
                              title: l10n.water,
                              subtitle: '10:00 AM',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      Row(
                        children: [
                          Expanded(
                            child: _QuickReminderCard(
                              icon: Icons
                                  .directions_walk_rounded,
                              iconColor:
                                  const Color(0xFFB9DEBE),
                              title: l10n.activity,
                              subtitle: '5:00 PM',
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: _QuickReminderCard(
                              icon: Icons
                                  .calendar_month_rounded,
                              iconColor:
                                  const Color(0xFFE8B0B7),
                              title: l10n.appointment,
                              subtitle: l10n.tomorrow,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // =====================================================
                      // MEMORY CIRCLE
                      // =====================================================
                      AppCard(
                        color:
                            Colors.white.withValues(alpha: 0.95),
                        padding: const EdgeInsets.all(20),
                        onTap: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (_) =>
                                  const MemoryCircleScreen(),
                            ),
                          );
                        },
                        child: Row(
                          children: [
                            Container(
                              width: 64,
                              height: 64,
                              decoration: BoxDecoration(
                                color:
                                    const Color(0xFFF3B6C4),
                                borderRadius:
                                    BorderRadius.circular(18),
                              ),
                              child: const Icon(
                                Icons.people_alt_rounded,
                                color: Colors.white,
                                size: 34,
                              ),
                            ),

                            const SizedBox(width: 16),

                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    l10n.memoryCircle,
                                    style:
                                        Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(
                                              fontWeight:
                                                  FontWeight
                                                      .w800,
                                            ),
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    l10n
                                        .peopleVoicesMemories,
                                    style: const TextStyle(
                                      color:
                                          AppColors.textMedium,
                                      fontSize: 16,
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const Icon(
                              Icons
                                  .arrow_forward_ios_rounded,
                              color:
                                  AppColors.primaryGreen,
                              size: 26,
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // =====================================================
                      // REMINDERS
                      // =====================================================
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          l10n.reminders,
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight:
                                    FontWeight.w800,
                                color:
                                    AppColors.textDark,
                              ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      ...FakeReminderData.reminders.map(
                        (reminder) => Padding(
                          padding:
                              const EdgeInsets.only(bottom: 12),
                          child: _ReminderCard(
                            reminder: reminder,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // ================================================================
          // BOTTOM NAVIGATION
          // ================================================================
          bottomNavigationBar: _buildBottomNav(
            context,
            l10n,
          ),
        );
      },
    );
  }

  // ==========================================================================
  // BOTTOM NAVIGATION
  // ==========================================================================

  Widget _buildBottomNav(
    BuildContext context,
    AppLocalizations l10n,
  ) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.96),
          border: const Border(
            top: BorderSide(
              color: AppColors.border,
            ),
          ),
        ),
        padding:
            const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceEvenly,
          children: [
            // ==============================================================
            // HOME
            // ==============================================================
            _NavItem(
              icon: Icons.home_rounded,
              label: l10n.home,
              active: true,
              onTap: () {},
            ),

            // ==============================================================
            // VOICE
            // IMPORTANT:
            // This does NOT speak the greeting.
            // It only shows the Voice Assistant message.
            // ==============================================================
            _NavItem(
              icon: Icons.mic_rounded,
              label: l10n.voice,
              active: false,
              onTap: () {
                ScaffoldMessenger.of(context)
                    .showSnackBar(
                  SnackBar(
                    content: Text(
                      l10n.voiceAssistantComingSoon,
                    ),
                  ),
                );
              },
            ),

            // ==============================================================
            // SETTINGS
            // ==============================================================
            _NavItem(
              icon: Icons.settings_rounded,
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

// ============================================================================
// QUICK REMINDER CARD
// ============================================================================

class _QuickReminderCard extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  const _QuickReminderCard({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 112,
      ),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.border,
          width: 1.3,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: iconColor,
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              mainAxisAlignment:
                  MainAxisAlignment.center,
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppColors.textMedium,
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

// ============================================================================
// REMINDER CARD
// ============================================================================

class _ReminderCard extends StatelessWidget {
  final Reminder reminder;

  const _ReminderCard({
    required this.reminder,
  });

  @override
  Widget build(BuildContext context) {
    return AppCard(
      color: Colors.white.withValues(alpha: 0.95),
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
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),

          const SizedBox(width: 10),

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

// ============================================================================
// BOTTOM NAV ITEM
// ============================================================================

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
      borderRadius: BorderRadius.circular(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 22,
          vertical: 4,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: color,
              size: 30,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 14,
                fontWeight: active
                    ? FontWeight.w600
                    : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}