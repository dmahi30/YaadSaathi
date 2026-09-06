import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/services/sync_service.dart';
import '../../../core/state/patient_name_controller.dart';
import '../../../core/state/patient_profile_controller.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({
    super.key,
    this.patientId,
  });

  final String? patientId;

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> {
  int _selectedPeriod = 0;

  final List<String> _periods = const [
    'Weekly',
    'Monthly',
    'All Time',
  ];

  @override
  Widget build(BuildContext context) {
    final selectedPatientId =
        widget.patientId?.trim().isNotEmpty == true
            ? widget.patientId!.trim()
            : patientProfileController.patientId.trim();

    if (selectedPatientId.isEmpty) {
      return _buildScaffold(
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

        return _buildScaffold(
          context,
          sessions,
        );
      },
    );
  }

  // ------------------------------------------------------------
  // MAIN SCAFFOLD
  // ------------------------------------------------------------

  Widget _buildScaffold(
    BuildContext context,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final filteredSessions = _filterSessions(sessions);

    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        bottom: false,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(
            18,
            18,
            18,
            24,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildHeader(context),

              const SizedBox(height: 18),

              _buildPeriodSelector(),

              const SizedBox(height: 14),

              _buildOverallPerformance(
                filteredSessions,
                sessions,
              ),

              const SizedBox(height: 18),

              _buildGamePerformance(
                filteredSessions,
              ),

              const SizedBox(height: 18),

              _buildAiAssessment(
                filteredSessions,
              ),

              const SizedBox(height: 18),

              _buildActivityCompletion(
                filteredSessions,
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  // ------------------------------------------------------------
  // HEADER
  // ------------------------------------------------------------

  Widget _buildHeader(BuildContext context) {
    final patientName =
        PatientNameController.instance.name.trim().isNotEmpty
            ? PatientNameController.instance.name.trim()
            : patientProfileController.fullName.trim();

    return Row(
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
            'Progress',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
        ),
        if (patientName.isNotEmpty)
          Flexible(
            child: Text(
              patientName,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textMedium,
              ),
            ),
          ),
      ],
    );
  }

  // ------------------------------------------------------------
  // PERIOD SELECTOR
  // ------------------------------------------------------------

  Widget _buildPeriodSelector() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.primaryGreen.withValues(
          alpha: 0.06,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: List.generate(
          _periods.length,
          (index) {
            final selected = _selectedPeriod == index;

            return Expanded(
              child: GestureDetector(
                onTap: () {
                  setState(() {
                    _selectedPeriod = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(
                    milliseconds: 180,
                  ),
                  padding: const EdgeInsets.symmetric(
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: selected
                        ? Colors.white
                        : Colors.transparent,
                    borderRadius:
                        BorderRadius.circular(12),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              blurRadius: 5,
                              offset: const Offset(0, 2),
                              color: Colors.black.withValues(
                                alpha: 0.05,
                              ),
                            ),
                          ]
                        : null,
                  ),
                  child: Text(
                    _periods[index],
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: selected
                          ? FontWeight.w700
                          : FontWeight.w500,
                      color: selected
                          ? AppColors.primaryGreen
                          : AppColors.textDark,
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // OVERALL PERFORMANCE
  // ------------------------------------------------------------

  Widget _buildOverallPerformance(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> currentSessions,
    List<QueryDocumentSnapshot<Map<String, dynamic>>> allSessions,
  ) {
    final currentAccuracy =
        _calculateAccuracy(currentSessions);

    final previousSessions =
        _getPreviousPeriodSessions(allSessions);

    final previousAccuracy =
        _calculateAccuracy(previousSessions);

    final difference =
        currentSessions.isEmpty || previousSessions.isEmpty
            ? null
            : currentAccuracy - previousAccuracy;

    final hasData = currentSessions.isNotEmpty;

    return _sectionCard(
      title: 'Overall Cognitive Performance',
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  hasData
                      ? '${currentAccuracy.round()}%'
                      : '—',
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.primaryGreen,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  difference == null
                      ? hasData
                          ? 'Based on completed activities'
                          : 'No activities completed yet'
                      : '${difference >= 0 ? '+' : ''}${difference.round()}% from previous period',
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          _buildPerformanceBars(
            currentSessions,
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PERFORMANCE BARS
  // ------------------------------------------------------------

  Widget _buildPerformanceBars(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final accuracy = _calculateAccuracy(sessions);

    final heights = [
      accuracy * 0.35,
      accuracy * 0.50,
      accuracy * 0.65,
      accuracy * 0.80,
      accuracy,
    ];

    return SizedBox(
      width: 82,
      height: 58,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: heights.map(
          (value) {
            final height =
                value.clamp(4.0, 48.0);

            return Container(
              width: 10,
              height: height,
              decoration: BoxDecoration(
                color: AppColors.primaryGreen,
                borderRadius:
                    BorderRadius.circular(6),
              ),
            );
          },
        ).toList(),
      ),
    );
  }

  // ------------------------------------------------------------
  // GAME PERFORMANCE
  // ------------------------------------------------------------

  Widget _buildGamePerformance(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final categories =
        _buildCategories(sessions);

    return _sectionCard(
      title: 'Game Performance',
      child: categories.isEmpty
          ? _emptyState(
              'No game activities completed yet.',
            )
          : Column(
              children: categories
                  .map(
                    (category) => Padding(
                      padding:
                          const EdgeInsets.only(
                        bottom: 13,
                      ),
                      child: _performanceRow(
                        icon: category.icon,
                        iconColor:
                            category.iconColor,
                        title: category.title,
                        percentage:
                            category.percentage,
                      ),
                    ),
                  )
                  .toList(),
            ),
    );
  }

  // ------------------------------------------------------------
  // AI ASSESSMENT
  // ------------------------------------------------------------

  Widget _buildAiAssessment(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final accuracy =
        _calculateAccuracy(sessions);

    final completed =
        sessions.length;

    final assessment =
        _getAssessment(accuracy, completed);

    return _sectionCard(
      title: 'AI Assessment',
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primaryGreen.withValues(
                alpha: 0.10,
              ),
            ),
            child: const Icon(
              Icons.smart_toy_outlined,
              color: AppColors.primaryGreen,
              size: 27,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  assessment.title,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  assessment.description,
                  style: const TextStyle(
                    fontSize: 11,
                    height: 1.35,
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

  // ------------------------------------------------------------
  // ACTIVITY COMPLETION
  // ------------------------------------------------------------

  Widget _buildActivityCompletion(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final completed = sessions.length;

    return _sectionCard(
      title: 'Activity Completion',
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            completed == 0
                ? 'No activities completed'
                : '$completed ${completed == 1 ? 'activity' : 'activities'} completed',
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: completed > 0 ? 1.0 : 0.0,
              minHeight: 9,
              backgroundColor:
                  AppColors.primaryGreen.withValues(
                alpha: 0.10,
              ),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(
                AppColors.primaryGreen,
              ),
            ),
          ),
          const SizedBox(height: 7),
          Text(
            'Completion is based on recorded activities.',
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // SECTION CARD
  // ------------------------------------------------------------

  Widget _sectionCard({
    required String title,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            blurRadius: 10,
            offset: const Offset(0, 4),
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textDark,
            ),
          ),
          const SizedBox(height: 13),
          child,
        ],
      ),
    );
  }

  // ------------------------------------------------------------
  // PERFORMANCE ROW
  // ------------------------------------------------------------

  Widget _performanceRow({
    required IconData icon,
    required Color iconColor,
    required String title,
    required double percentage,
  }) {
    return Row(
      children: [
        Container(
          width: 34,
          height: 34,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: iconColor.withValues(
              alpha: 0.10,
            ),
          ),
          child: Icon(
            icon,
            size: 19,
            color: iconColor,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
          ),
        ),
        Text(
          '${percentage.round()}%',
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w800,
            color: AppColors.textDark,
          ),
        ),
        const SizedBox(width: 7),
        Icon(
          percentage >= 70
              ? Icons.trending_up
              : percentage >= 50
                  ? Icons.trending_flat
                  : Icons.trending_down,
          size: 17,
          color: percentage >= 70
              ? AppColors.primaryGreen
              : AppColors.textMedium,
        ),
      ],
    );
  }

  // ------------------------------------------------------------
  // EMPTY STATE
  // ------------------------------------------------------------

  Widget _emptyState(String message) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        vertical: 8,
      ),
      child: Text(
        message,
        style: const TextStyle(
          fontSize: 12,
          color: AppColors.textMedium,
        ),
      ),
    );
  }

  // ------------------------------------------------------------
  // BOTTOM NAVIGATION
  // ------------------------------------------------------------

  Widget _buildBottomNavigation() {
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
              selected: false,
              onTap: () {
                Navigator.of(context).maybePop();
              },
            ),
            _navItem(
              icon: Icons.bar_chart_outlined,
              label: 'Progress',
              selected: true,
              onTap: () {},
            ),
            _navItem(
              icon: Icons.notifications_none,
              label: 'Reminder',
              selected: false,
              onTap: () {},
            ),
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
  // FILTER SESSIONS
  // ------------------------------------------------------------

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
      _filterSessions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    if (_selectedPeriod == 2) {
      return sessions;
    }

    final now = DateTime.now();

    final startDate = _selectedPeriod == 0
        ? now.subtract(const Duration(days: 7))
        : DateTime(
            now.year,
            now.month - 1,
            now.day,
          );

    return sessions.where((doc) {
      final date = _sessionDate(doc);

      if (date == null) {
        return false;
      }

      return !date.isBefore(startDate);
    }).toList();
  }

  // ------------------------------------------------------------
  // PREVIOUS PERIOD
  // ------------------------------------------------------------

  List<QueryDocumentSnapshot<Map<String, dynamic>>>
      _getPreviousPeriodSessions(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    if (_selectedPeriod == 2) {
      return const [];
    }

    final now = DateTime.now();

    late DateTime currentStart;
    late DateTime previousStart;

    if (_selectedPeriod == 0) {
      currentStart =
          now.subtract(const Duration(days: 7));
      previousStart =
          now.subtract(const Duration(days: 14));
    } else {
      currentStart = DateTime(
        now.year,
        now.month - 1,
        now.day,
      );

      previousStart = DateTime(
        now.year,
        now.month - 2,
        now.day,
      );
    }

    return sessions.where((doc) {
      final date = _sessionDate(doc);

      if (date == null) {
        return false;
      }

      return !date.isBefore(previousStart) &&
          date.isBefore(currentStart);
    }).toList();
  }

  // ------------------------------------------------------------
  // SESSION DATE
  // ------------------------------------------------------------

  DateTime? _sessionDate(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final value = doc.data()['completedAt'];

    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    return null;
  }

  // ------------------------------------------------------------
  // ACCURACY
  // ------------------------------------------------------------

  double _calculateAccuracy(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    int correct = 0;
    int total = 0;

    for (final doc in sessions) {
      final data = doc.data();

      correct +=
          (data['correctAnswers'] as num?)?.toInt() ?? 0;

      total +=
          (data['totalQuestions'] as num?)?.toInt() ?? 0;
    }

    if (total == 0) {
      return 0;
    }

    return (correct / total) * 100;
  }

  // ------------------------------------------------------------
  // GAME CATEGORIES
  // ------------------------------------------------------------

  List<_GameCategory> _buildCategories(
    List<QueryDocumentSnapshot<Map<String, dynamic>>> sessions,
  ) {
    final Map<String, _GameCategoryData> grouped =
        {};

    for (final doc in sessions) {
      final data = doc.data();

      final type = data['gameType'];

      if (type is! String || type.trim().isEmpty) {
        continue;
      }

      final correct =
          (data['correctAnswers'] as num?)?.toInt() ?? 0;

      final total =
          (data['totalQuestions'] as num?)?.toInt() ?? 0;

      if (!grouped.containsKey(type)) {
        grouped[type] = _GameCategoryData();
      }

      grouped[type]!.correct += correct;
      grouped[type]!.total += total;
    }

    return grouped.entries.map((entry) {
      final type = entry.key;
      final data = entry.value;

      return _GameCategory(
        title: _gameTypeTitle(type),
        icon: _gameTypeIcon(type),
        iconColor: _gameTypeColor(type),
        percentage: data.total == 0
            ? 0
            : (data.correct / data.total) * 100,
      );
    }).toList();
  }

  // ------------------------------------------------------------
  // GAME TYPE DISPLAY
  // ------------------------------------------------------------

  String _gameTypeTitle(String type) {
    switch (type) {
      case 'face_name_match':
        return 'Face Recognition';

      case 'memory_game':
        return 'Memory Game';

      case 'voice':
      case 'voice_match':
      case 'voice_memory':
        return 'Voice Recognition';

      case 'attention_game':
        return 'Attention Game';

      case 'routine':
      case 'routine_match':
      case 'routine_memory':
        return 'Routine Memory';

      default:
        return type
            .replaceAll('_', ' ')
            .split(' ')
            .map(
              (word) => word.isEmpty
                  ? word
                  : '${word[0].toUpperCase()}${word.substring(1)}',
            )
            .join(' ');
    }
  }

  IconData _gameTypeIcon(String type) {
    switch (type) {
      case 'face_name_match':
        return Icons.face_retouching_natural;

      case 'memory_game':
        return Icons.psychology_outlined;

      case 'voice':
      case 'voice_match':
      case 'voice_memory':
        return Icons.mic_none;

      case 'attention_game':
        return Icons.track_changes;

      case 'routine':
      case 'routine_match':
      case 'routine_memory':
        return Icons.schedule;

      default:
        return Icons.extension_outlined;
    }
  }

  Color _gameTypeColor(String type) {
    switch (type) {
      case 'face_name_match':
        return Colors.blue;

      case 'memory_game':
        return Colors.redAccent;

      case 'voice':
      case 'voice_match':
      case 'voice_memory':
        return AppColors.primaryGreen;

      case 'attention_game':
        return Colors.orange;

      case 'routine':
      case 'routine_match':
      case 'routine_memory':
        return Colors.purple;

      default:
        return AppColors.primaryGreen;
    }
  }

  // ------------------------------------------------------------
  // AI ASSESSMENT LOGIC
  // ------------------------------------------------------------

  _Assessment _getAssessment(
    double accuracy,
    int completedActivities,
  ) {
    if (completedActivities == 0) {
      return const _Assessment(
        title: 'Waiting for activity data',
        description:
            'Complete a few activities to generate a meaningful progress assessment.',
      );
    }

    if (accuracy >= 80) {
      return const _Assessment(
        title: 'Strong',
        description:
            'Consistent performance is being observed across completed activities.',
      );
    }

    if (accuracy >= 60) {
      return const _Assessment(
        title: 'Stable',
        description:
            'Performance is showing a steady pattern. Keep practicing regularly.',
      );
    }

    return const _Assessment(
      title: 'Needs gentle support',
      description:
          'Short, positive and repeated activities may help support continued practice.',
    );
  }
}

// --------------------------------------------------------------
// DATA CLASSES
// --------------------------------------------------------------

class _GameCategoryData {
  int correct = 0;
  int total = 0;
}

class _GameCategory {
  const _GameCategory({
    required this.title,
    required this.icon,
    required this.iconColor,
    required this.percentage,
  });

  final String title;
  final IconData icon;
  final Color iconColor;
  final double percentage;
}

class _Assessment {
  const _Assessment({
    required this.title,
    required this.description,
  });

  final String title;
  final String description;
}