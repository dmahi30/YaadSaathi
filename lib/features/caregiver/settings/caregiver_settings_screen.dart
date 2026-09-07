import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/state/patient_profile_controller.dart';
import '../../../core/widgets/speaker_button.dart';
import '../../patient/profile/patient_profile_screen.dart';
import '../family/family_data_screen.dart';
import '../progress/progress_screen.dart';
import '../reminders/reminders_screen.dart';

class CaregiverSettingsScreen extends StatefulWidget {
  const CaregiverSettingsScreen({
    super.key,
  });

  @override
  State<CaregiverSettingsScreen> createState() =>
      _CaregiverSettingsScreenState();
}

class _CaregiverSettingsScreenState
    extends State<CaregiverSettingsScreen> {
  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        AppLanguageController.instance,
        patientProfileController,
      ]),
      builder: (context, _) {
        final l10n = AppLocalizations.current();

        return Scaffold(
          backgroundColor: const Color(0xFFF4F1E8),
          body: SafeArea(
            bottom: false,
            child: Column(
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      12,
                      10,
                      12,
                      20,
                    ),
                    child: Column(
                      children: [
                        _buildTopDecoration(),
                        const SizedBox(height: 4),
                        _buildHeader(l10n),
                        const SizedBox(height: 8),
                        _buildSettingsCard(l10n),
                        const SizedBox(height: 12),
                        _buildSignOutButton(l10n),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          bottomNavigationBar: _buildBottomNavigation(l10n),
        );
      },
    );
  }

  // ===========================================================================
  // TOP DECORATION
  // ===========================================================================

  Widget _buildTopDecoration() {
    return SizedBox(
      height: 30,
      child: Align(
        alignment: Alignment.topRight,
        child: CustomPaint(
          size: const Size(110, 55),
          painter: _LeafDecorationPainter(),
        ),
      ),
    );
  }

  // ===========================================================================
  // HEADER
  // ===========================================================================

  Widget _buildHeader(
    AppLocalizations l10n,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _circleButton(
            icon: Icons.arrow_back_ios_new_rounded,
            onTap: () {
              Navigator.of(context).maybePop();
            },
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.settings,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Manage your account and app preferences',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMedium,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          SpeakerButton(
            text: l10n.settings,
            size: 48,
          ),
        ],
      ),
    );
  }

  // ===========================================================================
  // SETTINGS CARD
  // ===========================================================================

  Widget _buildSettingsCard(
    AppLocalizations l10n,
  ) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: AppColors.border.withValues(
            alpha: 0.65,
          ),
        ),
      ),
      child: Column(
        children: [
          _SettingsRow(
            icon: Icons.person_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Caregiver Profile',
            subtitle: 'View and edit your details',
            onTap: _openCaregiverProfile,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.person_outline_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Patient Profile',
            subtitle: 'Manage your loved one\'s information',
            onTap: _openPatientProfile,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.groups_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Family Data',
            subtitle:
                'Manage family members, memories and important dates',
            onTap: _openFamilyData,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.notifications_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Notification Settings',
            subtitle: 'Set reminder preferences',
            onTap: _showNotificationSettings,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.language_rounded,
            iconBackground: AppColors.primaryGreen,
            title: l10n.language,
            subtitle: 'Choose your preferred language',
            onTap: _showLanguagePicker,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.lock_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Privacy & Security',
            subtitle: 'Manage your data and security',
            onTap: _showPrivacySecurity,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.help_rounded,
            iconBackground: AppColors.primaryGreen,
            title: 'Help & Support',
            subtitle: 'Get help or contact us',
            onTap: _showHelpSupport,
          ),
          _divider(),

          _SettingsRow(
            icon: Icons.info_rounded,
            iconBackground: AppColors.primaryGreen,
            title: l10n.aboutYaadSaathi,
            subtitle: 'App version, our mission',
            onTap: _showAbout,
          ),
        ],
      ),
    );
  }

  Widget _divider() {
    return Divider(
      height: 1,
      indent: 66,
      endIndent: 12,
      color: AppColors.border.withValues(
        alpha: 0.55,
      ),
    );
  }

  // ===========================================================================
  // NAVIGATION
  // ===========================================================================

  void _openCaregiverProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const CaregiverProfileScreen(),
      ),
    );
  }

  void _openPatientProfile() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const PatientProfileDetailsScreen(),
      ),
    );
  }

  void _openFamilyData() {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => const FamilyDataScreen(),
      ),
    );
  }

  // ===========================================================================
  // SIGN OUT
  // ===========================================================================

  Widget _buildSignOutButton(
    AppLocalizations l10n,
  ) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: _confirmSignOut,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 14,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: AppColors.error.withValues(
                alpha: 0.20,
              ),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.error.withValues(
                    alpha: 0.10,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.logout_rounded,
                  color: AppColors.error,
                  size: 23,
                ),
              ),
              const SizedBox(width: 14),
              const Expanded(
                child: Text(
                  'Sign Out',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: AppColors.error,
                  ),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios_rounded,
                size: 15,
                color: AppColors.error,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _confirmSignOut() async {
    final shouldSignOut = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Sign Out',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Are you sure you want to sign out?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: Text(
                AppLocalizations.current().cancel,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.error,
                foregroundColor: Colors.white,
              ),
              child: const Text(
                'Sign Out',
              ),
            ),
          ],
        );
      },
    );

    if (!mounted || shouldSignOut != true) {
      return;
    }

    await FirebaseAuth.instance.signOut();

    if (!mounted) {
      return;
    }

    Navigator.of(context).pop();
  }

  // ===========================================================================
  // NOTIFICATION SETTINGS
  // ===========================================================================

  void _showNotificationSettings() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        bool reminderNotifications = true;
        bool soundNotifications = true;

        return StatefulBuilder(
          builder: (
            context,
            setSheetState,
          ) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(
                  20,
                  18,
                  20,
                  20,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 42,
                      height: 5,
                      decoration: BoxDecoration(
                        color: AppColors.border,
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Notification Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 14),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primaryGreen,
                      title: const Text(
                        'Reminder notifications',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Receive alerts for scheduled reminders',
                      ),
                      value: reminderNotifications,
                      onChanged: (value) {
                        setSheetState(() {
                          reminderNotifications = value;
                        });
                      },
                    ),
                    SwitchListTile(
                      contentPadding: EdgeInsets.zero,
                      activeThumbColor: AppColors.primaryGreen,
                      title: const Text(
                        'Notification sound',
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      subtitle: const Text(
                        'Play a sound when a reminder arrives',
                      ),
                      value: soundNotifications,
                      onChanged: (value) {
                        setSheetState(() {
                          soundNotifications = value;
                        });
                      },
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.of(sheetContext).pop();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryGreen,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                        ),
                        child: Text(
                          AppLocalizations.current().save,
                          style: const TextStyle(
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  // ===========================================================================
  // LANGUAGE
  // ===========================================================================

  Future<void> _showLanguagePicker() async {
    final currentLanguage =
        AppLanguageController.instance.language;

    final selectedLanguage =
        await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: AppColors.border,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                const SizedBox(height: 10),
                ...AppLanguage.values.map(
                  (language) {
                    final selected =
                        language == currentLanguage;

                    return ListTile(
                      contentPadding:
                          const EdgeInsets.symmetric(
                        horizontal: 22,
                      ),
                      leading: Icon(
                        Icons.language_rounded,
                        color: selected
                            ? AppColors.primaryGreen
                            : AppColors.textMedium,
                      ),
                      title: Text(
                        language.nativeName,
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: selected
                              ? FontWeight.w800
                              : FontWeight.w500,
                          color: selected
                              ? AppColors.primaryGreen
                              : AppColors.textDark,
                        ),
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle_rounded,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                      onTap: () {
                        Navigator.of(sheetContext)
                            .pop(language);
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );

    if (!mounted || selectedLanguage == null) {
      return;
    }

    AppLanguageController.instance
        .setLanguage(selectedLanguage);
  }

  // ===========================================================================
  // PRIVACY
  // ===========================================================================

  void _showPrivacySecurity() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Privacy & Security',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const SingleChildScrollView(
            child: Text(
              'Your account and patient information should be handled through the connected application services. Avoid entering or storing sensitive information in demo data.',
              style: TextStyle(
                height: 1.45,
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.current().back,
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // HELP
  // ===========================================================================

  void _showHelpSupport() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Help & Support',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'Use the app navigation to manage patient information, memory activities and reminders. Support contact details can be connected later without hardcoding personal contact information.',
            style: TextStyle(
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.current().back,
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // ABOUT
  // ===========================================================================

  void _showAbout() {
    showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'About YaadSaathi',
            style: TextStyle(
              fontWeight: FontWeight.w800,
            ),
          ),
          content: const Text(
            'YaadSaathi is designed to support older adults through simple memory activities, familiar people, routines and caregiver support.',
            style: TextStyle(
              height: 1.45,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
              },
              child: Text(
                AppLocalizations.current().back,
              ),
            ),
          ],
        );
      },
    );
  }

  // ===========================================================================
  // FIVE-ITEM BOTTOM NAVIGATION
  // ===========================================================================

  Widget _buildBottomNavigation(
    AppLocalizations l10n,
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
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _BottomNavItem(
              icon: Icons.home_rounded,
              label: 'Home',
              selected: false,
              onTap: () {
                Navigator.of(context).popUntil(
                  (route) => route.isFirst,
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.bar_chart_rounded,
              label: 'Progress',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => ProgressScreen(
                      patientId:
                          patientProfileController.patientId,
                    ),
                  ),
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.notifications_rounded,
              label: 'Reminders',
              selected: false,
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) =>
                        const CaregiverRemindersScreen(),
                  ),
                );
              },
            ),
            _BottomNavItem(
              icon: Icons.groups_rounded,
              label: 'Family',
              selected: false,
              onTap: _openFamilyData,
            ),
            _BottomNavItem(
              icon: Icons.settings_rounded,
              label: l10n.settings,
              selected: true,
              onTap: () {},
            ),
          ],
        ),
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
}

// =============================================================================
// CAREGIVER PROFILE
// =============================================================================

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
  late Future<DocumentSnapshot<Map<String, dynamic>>?>
      _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadProfile();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>?> _loadProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    return FirebaseFirestore.instance
        .collection('caregivers')
        .doc(user.uid)
        .get();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: FutureBuilder<
            DocumentSnapshot<Map<String, dynamic>>?>(
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
              return _ProfileMessage(
                title: 'Caregiver Profile',
                message:
                    'Unable to load your caregiver information.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              );
            }

            final data = snapshot.data?.data();

            if (data == null) {
              return _ProfileMessage(
                title: 'Caregiver Profile',
                message:
                    'No caregiver profile information is available for this account.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              );
            }

            final fullName =
                _stringValue(data['fullName']);

            final phoneNumber =
                _stringValue(data['phoneNumber']);

            final relationshipKey =
                _stringValue(data['relationshipKey']);

            final languageValue =
                _stringValue(data['preferredLanguage']);

            final language =
                _languageFromStoredValue(languageValue);

            final email =
                FirebaseAuth.instance.currentUser?.email?.trim() ?? '';

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
                      _detailsCircleButton(
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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
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
                        color: AppColors.primaryGreen,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 62,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (fullName.isNotEmpty)
                    Text(
                      fullName,
                      textAlign: TextAlign.center,
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
                          label: 'Name',
                          value: fullName,
                        ),
                        _profileDivider(),
                        _ProfileDetailRow(
                          icon: Icons.phone_outlined,
                          label: 'Phone Number',
                          value: phoneNumber,
                        ),
                        _profileDivider(),
                        _ProfileDetailRow(
                          icon:
                              Icons.family_restroom_rounded,
                          label: 'Relationship',
                          value: relationshipKey,
                        ),
                        _profileDivider(),
                        _ProfileDetailRow(
                          icon: Icons.language_rounded,
                          label: 'Preferred Language',
                          value: language?.nativeName ??
                              languageValue,
                        ),
                        if (email.isNotEmpty) ...[
                          _profileDivider(),
                          _ProfileDetailRow(
                            icon: Icons.email_outlined,
                            label: 'Email',
                            value: email,
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
}

// =============================================================================
// PATIENT PROFILE DETAILS
// =============================================================================

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
  late Future<_PatientProfileData?> _profileFuture;

  @override
  void initState() {
    super.initState();
    _profileFuture = _loadPatientProfile();
  }

  Future<_PatientProfileData?> _loadPatientProfile() async {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      return null;
    }

    final caregiverSnapshot =
        await FirebaseFirestore.instance
            .collection('caregivers')
            .doc(user.uid)
            .get();

    final caregiverData = caregiverSnapshot.data();

    if (caregiverData == null) {
      return null;
    }

    final patientId =
        _stringValue(caregiverData['patientId']);

    if (patientId.isEmpty) {
      return null;
    }

    final patientSnapshot =
        await FirebaseFirestore.instance
            .collection('patients')
            .doc(patientId)
            .get();

    final patientData = patientSnapshot.data();

    if (patientData == null) {
      return null;
    }

    return _PatientProfileData(
      name: _stringValue(patientData['name']),
      dateOfBirth:
          _parseDate(patientData['dateOfBirth']),
      language: _languageFromStoredValue(
        _stringValue(
          patientData['preferredLanguage'],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F1E8),
      body: SafeArea(
        child: FutureBuilder<_PatientProfileData?>(
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
              return _ProfileMessage(
                title: 'Patient Profile',
                message:
                    'Unable to load the patient information.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              );
            }

            final profile = snapshot.data;

            if (profile == null) {
              return _ProfileMessage(
                title: 'Patient Profile',
                message:
                    'No patient profile is linked to this caregiver account yet.',
                onBack: () {
                  Navigator.of(context).maybePop();
                },
              );
            }

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
                      _detailsCircleButton(
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
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textDark,
                          ),
                        ),
                      ),
                      SpeakerButton(
                        text: profile.name.isNotEmpty
                            ? profile.name
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
                        color: AppColors.primaryGreen,
                        width: 3,
                      ),
                    ),
                    child: const Icon(
                      Icons.person_rounded,
                      size: 62,
                      color: AppColors.primaryGreen,
                    ),
                  ),
                  const SizedBox(height: 16),
                  if (profile.name.isNotEmpty)
                    Text(
                      profile.name,
                      textAlign: TextAlign.center,
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
                          label: 'Name',
                          value: profile.name,
                        ),
                        _profileDivider(),
                        _ProfileDetailRow(
                          icon: Icons.cake_outlined,
                          label: 'Date of Birth',
                          value: profile.dateOfBirth == null
                              ? ''
                              : _formatDate(
                                  profile.dateOfBirth!,
                                ),
                        ),
                        _profileDivider(),
                        _ProfileDetailRow(
                          icon: Icons.language_rounded,
                          label: 'Preferred Language',
                          value: profile.language
                                  ?.nativeName ??
                              '',
                        ),
                        if (profile.age != null) ...[
                          _profileDivider(),
                          _ProfileDetailRow(
                            icon:
                                Icons.calendar_today_outlined,
                            label: 'Age',
                            value:
                                '${profile.age}',
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (_) =>
                                const PatientProfileScreen(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryGreen,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(16),
                        ),
                      ),
                      child: const Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
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
}

// =============================================================================
// PROFILE DATA
// =============================================================================

class _PatientProfileData {
  const _PatientProfileData({
    required this.name,
    required this.dateOfBirth,
    required this.language,
  });

  final String name;
  final DateTime? dateOfBirth;
  final AppLanguage? language;

  int? get age {
    if (dateOfBirth == null) {
      return null;
    }

    final today = DateTime.now();

    int calculatedAge =
        today.year - dateOfBirth!.year;

    if (today.month < dateOfBirth!.month ||
        (today.month == dateOfBirth!.month &&
            today.day < dateOfBirth!.day)) {
      calculatedAge--;
    }

    return calculatedAge;
  }
}

// =============================================================================
// SMALL WIDGETS
// =============================================================================

class _SettingsRow extends StatelessWidget {
  const _SettingsRow({
    required this.icon,
    required this.iconBackground,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final Color iconBackground;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(18),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 11,
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: Colors.white,
                size: 21,
              ),
            ),
            const SizedBox(width: 13),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    maxLines: 1,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 11,
                      height: 1.25,
                      color: AppColors.textMedium,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right_rounded,
              size: 22,
              color: AppColors.textMedium,
            ),
          ],
        ),
      ),
    );
  }
}

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
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 2,
            vertical: 4,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 22,
                color: selected
                    ? AppColors.primaryGreen
                    : AppColors.textMedium,
              ),
              const SizedBox(height: 3),
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: selected
                      ? FontWeight.w800
                      : FontWeight.w500,
                  color: selected
                      ? AppColors.primaryGreen
                      : AppColors.textMedium,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileMessage extends StatelessWidget {
  const _ProfileMessage({
    required this.title,
    required this.message,
    required this.onBack,
  });

  final String title;
  final String message;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _detailsCircleButton(
              icon: Icons.arrow_back_ios_new_rounded,
              onTap: onBack,
            ),
            const SizedBox(height: 22),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                height: 1.45,
                color: AppColors.textMedium,
              ),
            ),
          ],
        ),
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
    final hasValue = value.trim().isNotEmpty;

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
                  hasValue ? value : 'Not provided',
                  maxLines: 3,
                  overflow:
                      TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                    color: hasValue
                        ? AppColors.textDark
                        : AppColors.textMedium,
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

// =============================================================================
// HELPERS
// =============================================================================

Widget _detailsCircleButton({
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

Widget _profileDivider() {
  return Divider(
    height: 1,
    indent: 64,
    endIndent: 18,
    color: AppColors.border.withValues(
      alpha: 0.55,
    ),
  );
}

String _stringValue(dynamic value) {
  if (value == null) {
    return '';
  }

  return value.toString().trim();
}

DateTime? _parseDate(dynamic value) {
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

AppLanguage? _languageFromStoredValue(
  String value,
) {
  final normalized =
      value.trim().toLowerCase();

  for (final language in AppLanguage.values) {
    if (language.name.toLowerCase() ==
        normalized) {
      return language;
    }

    if (language.code.toLowerCase() ==
        normalized) {
      return language;
    }
  }

  return null;
}

String _formatDate(DateTime date) {
  const months = [
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  final day =
      date.day.toString().padLeft(2, '0');

  return '$day ${months[date.month - 1]} ${date.year}';
}

// =============================================================================
// LEAF DECORATION
// =============================================================================

class _LeafDecorationPainter
    extends CustomPainter {
  @override
  void paint(
    Canvas canvas,
    Size size,
  ) {
    final paint = Paint()
      ..color = const Color(0xFFDCEAD5)
      ..style = PaintingStyle.fill;

    final darkPaint = Paint()
      ..color = const Color(0xFFC8DDC1)
      ..style = PaintingStyle.fill;

    final stemPaint = Paint()
      ..color = const Color(0xFFA8C49F)
      ..strokeWidth = 1.4
      ..style = PaintingStyle.stroke;

    final path = Path();

    path.moveTo(size.width, 0);
    path.quadraticBezierTo(
      size.width - 30,
      12,
      size.width - 34,
      32,
    );
    path.quadraticBezierTo(
      size.width - 10,
      25,
      size.width,
      12,
    );
    path.close();

    canvas.drawPath(path, paint);

    final secondLeaf = Path();

    secondLeaf.moveTo(
      size.width - 38,
      4,
    );
    secondLeaf.quadraticBezierTo(
      size.width - 70,
      13,
      size.width - 78,
      32,
    );
    secondLeaf.quadraticBezierTo(
      size.width - 52,
      28,
      size.width - 38,
      4,
    );
    secondLeaf.close();

    canvas.drawPath(
      secondLeaf,
      darkPaint,
    );

    canvas.drawLine(
      Offset(size.width - 40, 3),
      Offset(size.width - 72, 32),
      stemPaint,
    );
  }

  @override
  bool shouldRepaint(
    covariant CustomPainter oldDelegate,
  ) {
    return false;
  }
}