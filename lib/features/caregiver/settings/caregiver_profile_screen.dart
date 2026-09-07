import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/widgets/speaker_button.dart';

class CaregiverProfileScreen extends StatefulWidget {
  const CaregiverProfileScreen({
    super.key,
  });

  @override
  State<CaregiverProfileScreen> createState() =>
      _CaregiverProfileScreenState();
}

class _CaregiverProfileScreenState
    extends State<CaregiverProfileScreen> {
  late Future<Map<String, dynamic>?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadCaregiverProfile();
  }

  Future<Map<String, dynamic>?> _loadCaregiverProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final document = await FirebaseFirestore.instance
        .collection('caregivers')
        .doc(user.uid)
        .get();

    if (!document.exists) {
      return null;
    }

    return document.data();
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
                    'The caregiver profile could not be loaded right now.',
              );
            }

            final data = snapshot.data;

            if (data == null) {
              return _buildMessage(
                title: 'Profile not available',
                message:
                    'No caregiver profile is connected to the current account.',
              );
            }

            final fullName =
                (data['fullName'] as String?)?.trim() ?? '';

            final phoneNumber =
                (data['phoneNumber'] as String?)?.trim() ?? '';

            final relationshipKey =
                (data['relationshipKey'] as String?)?.trim() ?? '';

            final language =
                _languageFromValue(data['preferredLanguage']);

            final authUser =
                FirebaseAuth.instance.currentUser;

            final email =
                authUser?.email?.trim() ?? '';

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
                          'Caregiver Profile',
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
                        text: fullName.isNotEmpty
                            ? fullName
                            : 'Caregiver Profile',
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

                  Text(
                    fullName.isNotEmpty
                        ? fullName
                        : 'Caregiver',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
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
                          label: 'Full Name',
                          value: fullName,
                        ),
                        _divider(),
                        _ProfileDetailRow(
                          icon:
                              Icons.phone_outlined,
                          label: 'Phone Number',
                          value: phoneNumber,
                        ),
                        if (relationshipKey.isNotEmpty) ...[
                          _divider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.people_outline_rounded,
                            label: 'Relationship',
                            value: relationshipKey,
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
                        if (email.isNotEmpty) ...[
                          _divider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.email_outlined,
                            label: 'Email',
                            value: email,
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryGreen
                          .withValues(alpha: 0.08),
                      borderRadius:
                          BorderRadius.circular(16),
                    ),
                    child: const Row(
                      crossAxisAlignment:
                          CrossAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.lock_outline_rounded,
                          color:
                              AppColors.primaryGreen,
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Your PIN is kept private and is not displayed in your profile.',
                            style: TextStyle(
                              fontSize: 13,
                              height: 1.4,
                              color:
                                  AppColors.textDark,
                            ),
                          ),
                        ),
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