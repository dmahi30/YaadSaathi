import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/widgets/speaker_button.dart';

class PatientProfileDetailsScreen extends StatefulWidget {
  const PatientProfileDetailsScreen({
    super.key,
  });

  @override
  State<PatientProfileDetailsScreen> createState() =>
      _PatientProfileDetailsScreenState();
}

class _PatientProfileDetailsScreenState
    extends State<PatientProfileDetailsScreen> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadPatientProfile();
  }

  Future<Map<String, dynamic>?> _loadPatientProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final caregiverDocument = await FirebaseFirestore.instance
        .collection('caregivers')
        .doc(user.uid)
        .get();

    if (!caregiverDocument.exists) {
      return null;
    }

    final caregiverData = caregiverDocument.data();

    if (caregiverData == null) {
      return null;
    }

    final patientId =
        (caregiverData['patientId'] as String?)?.trim() ?? '';

    if (patientId.isEmpty) {
      return null;
    }

    final patientDocument = await FirebaseFirestore.instance
        .collection('patients')
        .doc(patientId)
        .get();

    if (!patientDocument.exists) {
      return null;
    }

    final patientData = patientDocument.data();

    if (patientData == null) {
      return null;
    }

    return {
      ...patientData,
      'patientId': patientId,
    };
  }

  AppLanguage? _languageFromValue(Object? value) {
    if (value is! String) {
      return null;
    }

    for (final language in AppLanguage.values) {
      if (language.name == value) {
        return language;
      }
    }

    return null;
  }

  DateTime? _dateFromValue(Object? value) {
    if (value is Timestamp) {
      return value.toDate();
    }

    if (value is DateTime) {
      return value;
    }

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  int? _calculateAge(DateTime? dateOfBirth) {
    if (dateOfBirth == null) {
      return null;
    }

    final today = DateTime.now();

    int age =
        today.year - dateOfBirth.year;

    if (today.month < dateOfBirth.month ||
        (today.month == dateOfBirth.month &&
            today.day < dateOfBirth.day)) {
      age--;
    }

    return age;
  }

  String _formatDate(DateTime date) {
    final day =
        date.day.toString().padLeft(2, '0');

    final month =
        date.month.toString().padLeft(2, '0');

    return '$day/$month/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: FutureBuilder<Map<String, dynamic>?>(
          future: _profileFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState ==
                ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(
                  color: AppColors.primaryGreen,
                ),
              );
            }

            if (snapshot.hasError) {
              return _buildMessage(
                title: 'Unable to load profile',
                message:
                    'The patient profile could not be loaded right now.',
              );
            }

            final data = snapshot.data;

            if (data == null) {
              return _buildMessage(
                title: 'Patient profile not available',
                message:
                    'No patient profile is linked to the current caregiver account.',
              );
            }

            final name =
                (data['name'] as String?)?.trim() ?? '';

            final dateOfBirth =
                _dateFromValue(
              data['dateOfBirth'],
            );

            final language =
                _languageFromValue(
              data['preferredLanguage'],
            );

            final patientId =
                (data['patientId'] as String?)?.trim() ?? '';

            final age =
                _calculateAge(dateOfBirth);

            return SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                18,
                12,
                18,
                28,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      _circleButton(
                        icon:
                            Icons.arrow_back_ios_new_rounded,
                        onTap: () {
                          Navigator.of(context).maybePop();
                        },
                      ),
                      const SizedBox(width: 14),
                      const Expanded(
                        child: Text(
                          'Patient Profile',
                          maxLines: 1,
                          overflow:
                              TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight:
                                FontWeight.w800,
                            color:
                                AppColors.textDark,
                          ),
                        ),
                      ),
                      SpeakerButton(
                        text: name.isNotEmpty
                            ? name
                            : 'Patient Profile',
                        size: 48,
                      ),
                    ],
                  ),

                  const SizedBox(height: 28),

                  Container(
                    width: 118,
                    height: 118,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.primaryGreen
                          .withValues(alpha: 0.10),
                      border: Border.all(
                        color:
                            AppColors.primaryGreen,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 62,
                      color:
                          AppColors.primaryGreen,
                    ),
                  ),

                  const SizedBox(height: 16),

                  if (name.isNotEmpty)
                    Text(
                      name,
                      textAlign: TextAlign.center,
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.w800,
                        color:
                            AppColors.textDark,
                      ),
                    ),

                  const SizedBox(height: 26),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.border
                            .withValues(alpha: 0.65),
                      ),
                    ),
                    child: Column(
                      children: [
                        _ProfileDetailRow(
                          icon:
                              Icons.person_outline_rounded,
                          label: 'Name',
                          value: name,
                        ),
                        _divider(),
                        _ProfileDetailRow(
                          icon:
                              Icons.cake_outlined,
                          label: 'Date of Birth',
                          value: dateOfBirth == null
                              ? ''
                              : _formatDate(
                                  dateOfBirth,
                                ),
                        ),
                        if (age != null) ...[
                          _divider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.calendar_today_outlined,
                            label: 'Age',
                            value: '$age',
                          ),
                        ],
                        if (language != null) ...[
                          _divider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.language_rounded,
                            label:
                                'Preferred Language',
                            value:
                                language.nativeName,
                          ),
                        ],
                        if (patientId.isNotEmpty) ...[
                          _divider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.badge_outlined,
                            label: 'Patient ID',
                            value: patientId,
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildMessage({
    required String title,
    required String message,
  }) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              _circleButton(
                icon:
                    Icons.arrow_back_ios_new_rounded,
                onTap: () {
                  Navigator.of(context).maybePop();
                },
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),
          const Icon(
            Icons.person_off_outlined,
            size: 64,
            color: AppColors.textMedium,
          ),
          const SizedBox(height: 18),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 15,
              height: 1.5,
              color: AppColors.textMedium,
            ),
          ),
        ],
      ),
    );
  }

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

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 64,
      endIndent: 18,
      color: AppColors.border.withValues(
        alpha: 0.55,
      ),
    );
  }
}

class _ProfileDetailRow extends StatelessWidget {
  const _ProfileDetailRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 18,
        vertical: 16,
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.primaryGreen
                  .withValues(alpha: 0.10),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: AppColors.primaryGreen,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty
                      ? 'Not provided'
                      : value,
                  maxLines: 3,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: value.isEmpty
                        ? AppColors.textMedium
                        : AppColors.textDark,
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