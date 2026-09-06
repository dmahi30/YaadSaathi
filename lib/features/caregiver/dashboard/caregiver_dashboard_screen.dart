import 'dart:math' as math;

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/sync_service.dart';

class CaregiverDashboardScreen extends StatelessWidget {
  const CaregiverDashboardScreen({super.key});

  static const String patientId = 'patient_001';
  static const String patientName = 'Leima Devi';
  static const String patientAge = 'Age 72';
  static const String patientLanguage = 'Assamese';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
          stream: SyncService.gameSessionsStream(
            patientId: patientId,
          ),
          builder: (context, snapshot) {
            final sessions = snapshot.data?.docs ?? [];

            final faceSession = sessions.cast<
                QueryDocumentSnapshot<Map<String, dynamic>>>()
              .where(
                (doc) => doc.data()['gameType'] == 'face_name_match',
              )
              .toList();

            final faceScore = faceSession.isNotEmpty
                ? _score(faceSession.first.data())
                : 0;

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(),

                  const SizedBox(height: 14),

                  _buildPatientCard(context),

                  const SizedBox(height: 16),

                  _buildActivityHeader(),

                  const SizedBox(height: 8),

                  _buildActivityCard(
                    faceScore: faceScore,
                  ),

                  const SizedBox(height: 16),

                  _buildAiSummary(
                    faceScore: faceScore,
                  ),

                  const SizedBox(height: 20),

                  _buildBottomNavigation(),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  // ============================================================
  // HEADER
  // ============================================================

  Widget _buildHeader() {
    return Row(
      children: [
        _roundButton(
          icon: Icons.arrow_back_ios_new,
          onTap: () {},
        ),

        const Expanded(
          child: Center(
            child: Text(
              'Caregiver Dashboard',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: AppColors.textDark,
              ),
            ),
          ),
        ),

        _roundButton(
          icon: Icons.volume_up_outlined,
          onTap: () {},
        ),
      ],
    );
  }

  Widget _roundButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 46,
          height: 46,
          child: Icon(
            icon,
            size: 22,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }

  // ============================================================
  // PATIENT CARD
  // ============================================================

  Widget _buildPatientCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 58,
            height: 58,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Color(0xFFEAF3DE),
            ),
            child: const Icon(
              Icons.person,
              size: 34,
              color: AppColors.primaryGreen,
            ),
          ),

          const SizedBox(width: 12),

          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patientName,
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
                SizedBox(height: 3),
                Text(
                  patientAge,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  patientLanguage,
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),

          
            SizedBox(
  width: 100,
  child: OutlinedButton(
    onPressed: () {},
    style: OutlinedButton.styleFrom(
      backgroundColor: const Color(0xFFEAF3DE),
      foregroundColor: AppColors.textDark,
      side: BorderSide.none,
      minimumSize: const Size(0, 44),
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 10,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
                child: const Text(
              'View Profile',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
            ),
        ],
      ),
    );
  }

  
  // ============================================================
  // TODAY'S ACTIVITY HEADER
  // ============================================================

  Widget _buildActivityHeader() {
    return const Row(
      children: [
        Text(
          "Today's Activity",
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),

        Spacer(),

        Text(
          'See All',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: AppColors.primaryGreen,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // ACTIVITY CARD
  // ============================================================

  Widget _buildActivityCard({
    required int faceScore,
  }) {
    // Voice and routine are not connected to Firebase yet.
    // Keeping these as placeholders matches the prototype.
    const int voiceScore = 3;
    const int routineScore = 4;

    final completed =
        faceScore > 0 ? faceScore : 0;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 18,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppColors.border,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: _buildCircularScore(
              score: completed,
              total: 5,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            flex: 6,
            child: Column(
              children: [
                _activityRow(
                  icon: Icons.face_outlined,
                  title: 'Faces',
                  score: '$completed/5',
                ),

                const SizedBox(height: 16),

                _activityRow(
                  icon: Icons.mic_none,
                  title: 'Voices',
                  score: '$voiceScore/5',
                ),

                const SizedBox(height: 16),

                _activityRow(
                  icon: Icons.access_time,
                  title: 'Routines',
                  score: '$routineScore/5',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularScore({
    required int score,
    required int total,
  }) {
    return SizedBox(
      width: 120,
      height: 120,
      child: CustomPaint(
        painter: _ProgressPainter(
          progress: total == 0 ? 0 : score / total,
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '$score/$total',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 2),
              const Text(
                'Completed',
                style: TextStyle(
                  fontSize: 11,
                  color: AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _activityRow({
    required IconData icon,
    required String title,
    required String score,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 25,
          color: AppColors.primaryGreen,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textDark,
            ),
          ),
        ),

        Text(
          score,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: AppColors.textDark,
          ),
        ),
      ],
    );
  }

  // ============================================================
  // AI SUMMARY
  // ============================================================

  Widget _buildAiSummary({
  required int faceScore,
}) {
  final String summary;

  if (faceScore >= 4) {
    summary =
        'Leima did well in today\'s activity! '
        'She remembered most of the people correctly. '
        'Keep encouraging her!';
  } else if (faceScore >= 2) {
    summary =
        'Leima completed today\'s activity steadily. '
        'Continue practicing familiar people and memories '
        'at a comfortable pace.';
  } else {
    summary =
        'Leima may benefit from a little more support '
        'with today\'s memory activity. Keep the activity '
        'gentle and encouraging.';
  }

  return Container(
    width: double.infinity,
    padding: const EdgeInsets.all(14),
    decoration: BoxDecoration(
      color: const Color(0xFFFFEDED),
      borderRadius: BorderRadius.circular(12),
      border: Border.all(
        color: const Color(0xFFF3D5D5),
      ),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          '💡',
          style: TextStyle(fontSize: 28),
        ),

        const SizedBox(width: 12),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'AI Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 6),

              Text(
                summary,
                style: const TextStyle(
                  fontSize: 13,
                  height: 1.45,
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

  // ============================================================
  // BOTTOM NAVIGATION
  // ============================================================

  Widget _buildBottomNavigation() {
    return Container(
      padding: const EdgeInsets.only(
        top: 10,
        bottom: 4,
      ),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _NavItem(
            icon: Icons.home,
            label: 'Home',
            active: true,
          ),
          _NavItem(
            icon: Icons.insights,
            label: 'Progress',
          ),
          _NavItem(
            icon: Icons.notifications_none,
            label: 'Reminders',
          ),
          _NavItem(
            icon: Icons.more_horiz,
            label: 'More',
          ),
        ],
      ),
    );
  }

  int _score(Map<String, dynamic> data) {
    return (data['correctAnswers'] as num?)?.toInt() ?? 0;
  }
}

// ============================================================
// NAV ITEM
// ============================================================

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool active;

  const _NavItem({
    required this.icon,
    required this.label,
    this.active = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 25,
          color: active
              ? AppColors.primaryGreen
              : AppColors.textMedium,
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight:
                active ? FontWeight.w600 : FontWeight.normal,
            color: active
                ? AppColors.primaryGreen
                : AppColors.textMedium,
          ),
        ),
      ],
    );
  }
}

// ============================================================
// CIRCULAR PROGRESS PAINTER
// ============================================================

class _ProgressPainter extends CustomPainter {
  final double progress;

  _ProgressPainter({
    required this.progress,
  });

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
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = AppColors.border;

    final progressPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 7
      ..strokeCap = StrokeCap.round
      ..color = AppColors.primaryGreen;

    canvas.drawCircle(
      center,
      radius,
      backgroundPaint,
    );

    final rect = Rect.fromCircle(
      center: center,
      radius: radius,
    );

    canvas.drawArc(
      rect,
      -math.pi / 2,
      2 * math.pi * progress.clamp(0.0, 1.0),
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant _ProgressPainter oldDelegate,
  ) {
    return oldDelegate.progress != progress;
  }
}