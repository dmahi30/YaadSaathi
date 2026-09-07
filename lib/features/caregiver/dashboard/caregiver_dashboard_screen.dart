import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/state/patient_name_controller.dart';
import '../../../core/state/patient_profile_controller.dart';
import '../family/family_data_screen.dart' as family;
import '../progress/progress_screen.dart';
import '../reminders/reminders_screen.dart';
import '../settings/caregiver_settings_screen.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({
    super.key,
    this.patientId,
  });

  final String? patientId;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        PatientNameController.instance,
        patientProfileController,
        AppLanguageController.instance,
      ]),
      builder: (context, _) {
        return Scaffold(
          backgroundColor: const Color(0xFFF4F1E8),
          body: SafeArea(
            bottom: false,
            child: _buildBody(context),
          ),
          bottomNavigationBar: _buildBottomNavigation(context),
        );
      },
    );
  }

  // ===========================================================================
  // DASHBOARD BODY
  // ===========================================================================

  Widget _buildBody(BuildContext context) {
    final selectedPatientId = _getPatientId();

    if (selectedPatientId.isEmpty) {
      return _buildDashboardContent(
        context,
        const [],
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: SyncService.gameSessionsStream(
        patientId: selectedPatientId,
      ),
      builder: (context, snapshot) {
        final sessions = snapshot.data?.docs ?? [];

        return _buildDashboardContent(
          context,
          sessions,
        );
      },
    );
  }

  String _getPatientId() {
    final passedId = patientId?.trim();

    if (passedId != null && passedId.isNotEmpty) {
      return passedId;
    }

    return patientProfileController.patientId.trim();
  }

  // ===========================================================================
  // DASHBOARD CONTENT
  // ===========================================================================

  Widget _buildDashboardContent(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final patientName = _getPatientName();

    final displayName =
        patientName.isEmpty ? 'Patient' : patientName;

    final age = patientProfileController.age;
    final language = patientProfileController.languageName;

    final faceScore = _getScore(
      sessions,
      'face_name_match',
    );

    final faceTotal = _getTotal(
      sessions,
      'face_name_match',
    );

    final voiceScore = _getCategoryScore(
      sessions,
      const [
        'voice',
        'voice_match',
        'voice_memory',
      ],
    );

    final voiceTotal = _getCategoryTotal(
      sessions,
      const [
        'voice',
        'voice_match',
        'voice_memory',
      ],
    );

    final routineScore = _getCategoryScore(
      sessions,
      const [
        'routine',
        'routine_match',
        'routine_memory',
      ],
    );

    final routineTotal = _getCategoryTotal(
      sessions,
      const [
        'routine',
        'routine_match',
        'routine_memory',
      ],
    );

    final completedActivities = sessions.length;

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        18,
        14,
        18,
        24,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),

          const SizedBox(height: 22),

          _buildPatientCard(
            context,
            displayName: displayName,
            age: age,
            language: language,
          ),

          const SizedBox(height: 26),

          _buildActivityHeader(context),

          const SizedBox(height: 12),

          _buildActivityCard(
            faceScore: faceScore,
            faceTotal: faceTotal,
            voiceScore: voiceScore,
            voiceTotal: voiceTotal,
            routineScore: routineScore,
            routineTotal: routineTotal,
            completedActivities: completedActivities,
          ),

          const SizedBox(height: 26),

          const Text(
            'AI Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          _buildAiSummary(
            displayName: displayName,
            faceScore: faceScore,
            faceTotal: faceTotal,
            completedActivities: completedActivities,
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  String _getPatientName() {
    final nameFromController =
        PatientNameController.instance.name.trim();

    if (nameFromController.isNotEmpty) {
      return nameFromController;
    }

    return patientProfileController.fullName.trim();
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        _circleButton(
          icon: Icons.arrow_back_ios_new_rounded,
          onTap: () {
            Navigator.of(context).maybePop();
          },
        ),

        const SizedBox(width: 14),

        const Expanded(
          child: Text(
            'Caregiver Dashboard',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ),

        _circleButton(
          icon: Icons.volume_up_outlined,
          onTap: () {
            // Speaker action can be connected to TTS.
          },
        ),
      ],
    );
  }

  // ===========================================================================
  // PATIENT CARD
  // ===========================================================================

  Widget _buildPatientCard(
    BuildContext context, {
    required String displayName,
    required int? age,
    required String language,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 62,
            height: 62,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withValues(
                alpha: 0.12,
              ),
            ),
            child: const Icon(
              Icons.person_rounded,
              size: 34,
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  displayName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),

                const SizedBox(height: 4),

                const Text(
                  'Patient',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textMedium,
                  ),
                ),

                const SizedBox(height: 8),

                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (age != null)
                      _infoChip(
                        Icons.cake_outlined,
                        'Age: $age',
                      ),

                    if (language.isNotEmpty)
                      _infoChip(
                        Icons.language_rounded,
                        'Lang: $language',
                      ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          SizedBox(
            width: 82,
            child: TextButton(
              onPressed: () {
                _openPatientProfile(context);
              },
              style: TextButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 2,
                  vertical: 8,
                ),
                minimumSize: Size.zero,
                tapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
              ),
              child: const Text(
                'View Profile',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // TODAY'S ACTIVITY
  // ===========================================================================

  Widget _buildActivityHeader(
    BuildContext context,
  ) {
    return Row(
      children: [
        const Expanded(
          child: Text(
            "Today's Activity",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ),

        TextButton(
          onPressed: () {
            _openProgress(context);
          },
          child: const Text(
            'See All',
            style: TextStyle(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // ACTIVITY CARD
  // ===========================================================================

  Widget _buildActivityCard({
    required int faceScore,
    required int faceTotal,
    required int voiceScore,
    required int voiceTotal,
    required int routineScore,
    required int routineTotal,
    required int completedActivities,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 22,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            blurRadius: 12,
            offset: const Offset(0, 5),
            color: Colors.black.withValues(
              alpha: 0.06,
            ),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 108,
                height: 108,
                child: CustomPaint(
                  painter: _ProgressPainter(
                    completed: completedActivities,
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$completedActivities',
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight:
                                FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                        const Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 11,
                            color:
                                AppColors.textMedium,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(width: 22),

              Expanded(
                child: Column(
                  children: [
                    _activityRow(
                      icon:
                          Icons.face_retouching_natural,
                      title: 'Faces',
                      score: faceScore,
                      total: faceTotal,
                    ),

                    const SizedBox(height: 14),

                    _activityRow(
                      icon: Icons.mic_none_rounded,
                      title: 'Voices',
                      score: voiceScore,
                      total: voiceTotal,
                    ),

                    const SizedBox(height: 14),

                    _activityRow(
                      icon: Icons.schedule_rounded,
                      title: 'Routines',
                      score: routineScore,
                      total: routineTotal,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _activityRow({
    required IconData icon,
    required String title,
    required int score,
    required int total,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 22,
          color: AppColors.primaryGreen,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.textDark,
            ),
          ),
        ),

        Text(
          '$score/$total',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  // ===========================================================================
  // AI SUMMARY
  // ===========================================================================

  Widget _buildAiSummary({
    required String displayName,
    required int faceScore,
    required int faceTotal,
    required int completedActivities,
  }) {
    final summary =
        _createAiSummary(
      displayName: displayName,
      faceScore: faceScore,
      faceTotal: faceTotal,
      completedActivities: completedActivities,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: AppColors.primaryGreen.withValues(
            alpha: 0.12,
          ),
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen
                  .withValues(alpha: 0.14),
            ),
            child: const Icon(
              Icons.auto_awesome_rounded,
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 14),

          Expanded(
            child: Text(
              summary,
              style: const TextStyle(
                fontSize: 15,
                height: 1.5,
                color: AppColors.textDark,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _createAiSummary({
    required String displayName,
    required int faceScore,
    required int faceTotal,
    required int completedActivities,
  }) {
    if (completedActivities == 0) {
      return '$displayName has not completed any '
          'activities yet. Once activities are completed, '
          'the dashboard will show progress and helpful '
          'insights here.';
    }

    if (faceTotal == 0) {
      return '$displayName has completed '
          '$completedActivities '
          '${completedActivities == 1 ? 'activity' : 'activities'}. '
          'More activities will help build a clearer '
          'picture of progress.';
    }

    final percentage =
        (faceScore / faceTotal) * 100;

    if (percentage >= 80) {
      return '$displayName is doing well with memory '
          'activities. Face and name recognition is '
          'showing strong performance.';
    }

    if (percentage >= 50) {
      return '$displayName is making steady progress. '
          'Regular short practice sessions may help '
          'strengthen memory.';
    }

    return '$displayName may benefit from gentle, '
        'repeated practice. Keep activities short, '
        'positive, and comfortable.';
  }

  // ===========================================================================
  // INFO CHIP
  // ===========================================================================

  Widget _infoChip(
    IconData icon,
    String text,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 9,
        vertical: 5,
      ),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: AppColors.primaryGreen,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  Widget _buildBottomNavigation(
    BuildContext context,
  ) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          4,
          8,
          4,
          8,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              blurRadius: 12,
              offset: const Offset(0, -3),
              color: Colors.black.withValues(
                alpha: 0.07,
              ),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceAround,
          children: [
            // HOME
            _BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: true,
              onTap: () {
                // Already on the caregiver dashboard.
              },
            ),

            // PROGRESS
            _BottomNavItem(
              icon: Icons.bar_chart_rounded,
              label: 'Progress',
              selected: false,
              onTap: () {
                _openProgress(context);
              },
            ),

            // REMINDERS
            _BottomNavItem(
              icon: Icons.notifications_rounded,
              label: 'Reminders',
              selected: false,
              onTap: () {
                _openReminders(context);
              },
            ),

            // FAMILY
            _BottomNavItem(
              icon: Icons.groups_rounded,
              label: 'Family',
              selected: false,
              onTap: () {
                _openFamily(context);
              },
            ),

            // SETTINGS
            _BottomNavItem(
              icon: Icons.settings_rounded,
              label: 'Settings',
              selected: false,
              onTap: () {
                _openSettings(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _openProgress(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => ProgressScreen(
          patientId: _getPatientId(),
        ),
      ),
    );
  }

  void _openReminders(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const CaregiverRemindersScreen(),
      ),
    );
  }

  void _openFamily(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const family.FamilyDataScreen(),
      ),
    );
  }

  void _openSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const CaregiverSettingsScreen(),
      ),
    );
  }

  void _openPatientProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) =>
            const PatientProfileDetailsScreen(),
      ),
    );
  }

  // ===========================================================================
  // CIRCLE BUTTON
  // ===========================================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 1.5,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 48,
          height: 48,
          child: Center(
            child: Icon(
              icon,
              size: 19,
              color: AppColors.textDark,
            ),
          ),
        ),
      ),
    );
  }

  // ===========================================================================
  // FIRESTORE SCORE HELPERS
  // ===========================================================================

  int _getScore(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        sessions,
    String gameType,
  ) {
    int correct = 0;

    for (final doc in sessions) {
      final data = doc.data();

      if (data['gameType'] == gameType) {
        correct +=
            (data['correctAnswers'] as num?)
                    ?.toInt() ??
                0;
      }
    }

    return correct;
  }

  int _getTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        sessions,
    String gameType,
  ) {
    int total = 0;

    for (final doc in sessions) {
      final data = doc.data();

      if (data['gameType'] == gameType) {
        total +=
            (data['totalQuestions'] as num?)
                    ?.toInt() ??
                0;
      }
    }

    return total;
  }

  int _getCategoryScore(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        sessions,
    List<String> gameTypes,
  ) {
    int score = 0;

    for (final doc in sessions) {
      final data = doc.data();
      final type = data['gameType'];

      if (type is String &&
          gameTypes.contains(type)) {
        score +=
            (data['correctAnswers'] as num?)
                    ?.toInt() ??
                0;
      }
    }

    return score;
  }

  int _getCategoryTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>>
        sessions,
    List<String> gameTypes,
  ) {
    int total = 0;

    for (final doc in sessions) {
      final data = doc.data();
      final type = data['gameType'];

      if (type is String &&
          gameTypes.contains(type)) {
        total +=
            (data['totalQuestions'] as num?)
                    ?.toInt() ??
                0;
      }
    }

    return total;
  }
}

// =============================================================================
// BOTTOM NAVIGATION ITEM
// =============================================================================

class _BottomNavItem extends StatelessWidget {
  const _BottomNavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 7,
          vertical: 5,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 23,
              color: selected
                  ? AppColors.primaryGreen
                  : AppColors.textMedium,
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                fontSize: 10.5,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w500,
                color: selected
                    ? AppColors.primaryGreen
                    : AppColors.textMedium,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =============================================================================
// PROGRESS PAINTER
// =============================================================================

class _ProgressPainter extends CustomPainter {
  _ProgressPainter({
    required this.completed,
  });

  final int completed;

  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final center = Offset(
      size.width / 2,
      size.height / 2,
    );

    final radius =
        math.min(size.width, size.height) / 2 - 7;

    final backgroundPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryGreen.withValues(
        alpha: 0.12,
      );

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 9
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryGreen;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final progress =
        completed > 0 ? 1.0 : 0.0;

    canvas.drawArc(
      Rect.fromCircle(
        center: center,
        radius: radius,
      ),
      -math.pi / 2,
      math.pi * 2 * progress,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ProgressPainter oldDelegate,
  ) {
    return oldDelegate.completed != completed;
  }
}