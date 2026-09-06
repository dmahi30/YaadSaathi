import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/state/patient_name_controller.dart';
import '../../../core/state/patient_profile_controller.dart';
import '../progress/progress_screen.dart';

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

  // ------------------------------------------------------------
  // DASHBOARD BODY
  // ------------------------------------------------------------

  Widget _buildBody(BuildContext context) {
    final selectedPatientId =
        patientId?.trim().isNotEmpty == true
            ? patientId!.trim()
            : patientProfileController.patientId.trim();

    final stream = selectedPatientId.isEmpty
        ? null
        : SyncService.gameSessionsStream(
            patientId: selectedPatientId,
          );

    if (stream == null) {
      return _buildDashboardContent(
        context,
        const [],
      );
    }

    return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
      stream: stream,
      builder: (context, snapshot) {
        final sessions = snapshot.data?.docs ?? [];

        return _buildDashboardContent(
          context,
          sessions,
        );
      },
    );
  }

  // ------------------------------------------------------------
  // DASHBOARD CONTENT
  // ------------------------------------------------------------

  Widget _buildDashboardContent(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final patientName =
        PatientNameController.instance.name.trim().isNotEmpty
            ? PatientNameController.instance.name.trim()
            : patientProfileController.fullName.trim();

    final displayName =
        patientName.isEmpty ? 'Patient' : patientName;

    final age = patientProfileController.age;
    final language = patientProfileController.languageName;

    final faceScore =
        _getScore(sessions, 'face_name_match');

    final faceTotal =
        _getTotal(sessions, 'face_name_match');

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
          // ------------------------------------------------------
          // HEADER
          // ------------------------------------------------------

          Row(
            children: [
              _roundButton(
                icon: Icons.arrow_back_ios_new,
                onTap: () {
                  Navigator.of(context).maybePop();
                },
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Caregiver Dashboard',
                  style: TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              _roundButton(
                icon: Icons.volume_up_outlined,
                onTap: () {
                  // Speaker action can be connected to TTS later.
                },
              ),
            ],
          ),

          const SizedBox(height: 22),

          // ------------------------------------------------------
          // PATIENT CARD
          // ------------------------------------------------------

          Container(
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
                    Icons.person,
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
                        spacing: 8,
                        runSpacing: 6,
                        children: [
                          if (age != null)
                            _infoChip(
                              Icons.cake_outlined,
                              'Age: $age',
                            ),
                          if (language.isNotEmpty)
                            _infoChip(
                              Icons.language,
                              'Lang: $language',
                            ),
                        ],
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: () {
                    // Patient profile navigation
                    // can be connected here.
                  },
                  child: const Text(
                    'View Profile',
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 26),

          // ------------------------------------------------------
          // TODAY'S ACTIVITY HEADER
          // ------------------------------------------------------

          Row(
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
                onPressed: () {},
                child: const Text(
                  'See All',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // ------------------------------------------------------
          // ACTIVITY CARD
          // ------------------------------------------------------

          Container(
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
                            mainAxisSize:
                                MainAxisSize.min,
                            children: [
                              Text(
                                '$completedActivities',
                                style: const TextStyle(
                                  fontSize: 25,
                                  fontWeight:
                                      FontWeight.w800,
                                  color:
                                      AppColors.textDark,
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
                            icon: Icons.mic_none,
                            title: 'Voices',
                            score: voiceScore,
                            total: voiceTotal,
                          ),
                          const SizedBox(height: 14),
                          _activityRow(
                            icon: Icons.schedule,
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
          ),

          const SizedBox(height: 26),

          // ------------------------------------------------------
          // AI SUMMARY
          // ------------------------------------------------------

          const Text(
            'AI Summary',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),

          const SizedBox(height: 12),

          Container(
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
                    color:
                        AppColors.primaryGreen.withValues(
                      alpha: 0.14,
                    ),
                  ),
                  child: const Icon(
                    Icons.auto_awesome,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(
                    _buildAiSummary(
                      displayName,
                      faceScore,
                      faceTotal,
                      completedActivities,
                    ),
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.5,
                      color: AppColors.textDark,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // ACTIVITY ROW
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // INFO CHIP
  // ------------------------------------------------------------

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

  // ------------------------------------------------------------
  // ROUND BUTTON
  // ------------------------------------------------------------

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      elevation: 2,
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          12,
          8,
          12,
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
            _navItem(
              icon: Icons.home_outlined,
              label: 'Home',
              selected: true,
              onTap: () {},
            ),

            // --------------------------------------------------
            // PROGRESS
            // --------------------------------------------------

            _navItem(
              icon: Icons.bar_chart_outlined,
              label: 'Progress',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProgressScreen(
                      patientId: patientId,
                    ),
                  ),
                );
              },
            ),

            // --------------------------------------------------
            // REMINDER
            // --------------------------------------------------

            _navItem(
              icon: Icons.notifications_none,
              label: 'Reminder',
              selected: false,
              onTap: () {},
            ),

            // --------------------------------------------------
            // SETTINGS
            // --------------------------------------------------

            _navItem(
              icon: Icons.settings_outlined,
              label: 'Settings',
              selected: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem({
    required IconData icon,
    required String label,
    required bool selected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
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
                fontSize: 11,
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

  // ------------------------------------------------------------
  // FIRESTORE SCORE HELPERS
  // ------------------------------------------------------------

  int _getScore(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
    String gameType,
  ) {
    int correct = 0;

    for (final doc in sessions) {
      final data = doc.data();

      if (data['gameType'] == gameType) {
        correct +=
            (data['correctAnswers'] as num?)?.toInt() ?? 0;
      }
    }

    return correct;
  }

  int _getTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
    String gameType,
  ) {
    int total = 0;

    for (final doc in sessions) {
      final data = doc.data();

      if (data['gameType'] == gameType) {
        total +=
            (data['totalQuestions'] as num?)?.toInt() ?? 0;
      }
    }

    return total;
  }

  int _getCategoryScore(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
    List<String> gameTypes,
  ) {
    int score = 0;

    for (final doc in sessions) {
      final data = doc.data();
      final type = data['gameType'];

      if (type is String && gameTypes.contains(type)) {
        score +=
            (data['correctAnswers'] as num?)?.toInt() ?? 0;
      }
    }

    return score;
  }

  int _getCategoryTotal(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
    List<String> gameTypes,
  ) {
    int total = 0;

    for (final doc in sessions) {
      final data = doc.data();
      final type = data['gameType'];

      if (type is String && gameTypes.contains(type)) {
        total +=
            (data['totalQuestions'] as num?)?.toInt() ?? 0;
      }
    }

    return total;
  }

  // ------------------------------------------------------------
  // AI SUMMARY
  // ------------------------------------------------------------

  String _buildAiSummary(
    String patientName,
    int faceScore,
    int faceTotal,
    int completedActivities,
  ) {
    if (completedActivities == 0) {
      return '$patientName has not completed any activities yet. '
          'Once activities are completed, the dashboard will show '
          'their progress and helpful insights here.';
    }

    if (faceTotal == 0) {
      return '$patientName has completed '
          '$completedActivities activity${completedActivities == 1 ? '' : 'ies'}. '
          'More activities will help build a clearer picture of progress.';
    }

    final percentage =
        (faceScore / faceTotal) * 100;

    if (percentage >= 80) {
      return '$patientName is doing well with memory activities. '
          'Face and name recognition is showing strong performance.';
    }

    if (percentage >= 50) {
      return '$patientName is making steady progress. '
          'Regular short practice sessions may help strengthen memory.';
    }

    return '$patientName may benefit from gentle, repeated practice. '
        'Keep activities short, positive, and comfortable.';
  }
}

// --------------------------------------------------------------
// PROGRESS PAINTER
// --------------------------------------------------------------

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