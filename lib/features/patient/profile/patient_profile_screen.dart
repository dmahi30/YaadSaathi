import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/constants/app_colors.dart';
import '../../caregiver/auth/caregiver_registration_data.dart';
import '../../caregiver/auth/caregiver_auth_service.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/state/patient_name_controller.dart';
import '../../../core/state/patient_profile_controller.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/speaker_button.dart';
import '../home/patient_home_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  final CaregiverRegistrationData? registrationData;
  final bool termsAccepted;
  final bool dataUseAccepted;

  const PatientProfileScreen({
    super.key,
    this.registrationData,
    this.termsAccepted = false,
    this.dataUseAccepted = false,
  });

  @override
  State<PatientProfileScreen> createState() =>
      _PatientProfileScreenState();
}

class _PatientProfileScreenState
    extends State<PatientProfileScreen> {
  late final TextEditingController _nameController;

  DateTime? _dob;

  late AppLanguage _language;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController();

    /*
     * IMPORTANT:
     *
     * If this screen is opened during NEW patient setup,
     * the form must start blank.
     *
     * If this screen is opened later from Settings,
     * load the already saved patient information.
     */
    final existingProfile =
        patientProfileController;

    final hasExistingProfile =
        existingProfile.fullName.trim().isNotEmpty &&
        existingProfile.dateOfBirth != null;

    if (widget.registrationData == null &&
        hasExistingProfile) {
      _nameController.text =
          existingProfile.fullName;

      _dob =
          existingProfile.dateOfBirth;

      _language =
          existingProfile.preferredLanguage;
    } else {
      _dob = null;

      _language =
          AppLanguageController.instance.language;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date) {
    final Map<AppLanguage, List<String>> months = {
      AppLanguage.english: [
        'Jan',
        'Feb',
        'Mar',
        'Apr',
        'May',
        'Jun',
        'Jul',
        'Aug',
        'Sep',
        'Oct',
        'Nov',
        'Dec',
      ],
      AppLanguage.hindi: [
        'जन',
        'फ़र',
        'मार्च',
        'अप्रैल',
        'मई',
        'जून',
        'जुल',
        'अग',
        'सित',
        'अक्टू',
        'नव',
        'दिस',
      ],
      AppLanguage.marathi: [
        'जाने',
        'फेब्रु',
        'मार्च',
        'एप्रि',
        'मे',
        'जून',
        'जुलै',
        'ऑग',
        'सप्टें',
        'ऑक्टो',
        'नोव्हें',
        'डिसें',
      ],
      AppLanguage.bengali: [
        'জানু',
        'ফেব্রু',
        'মার্চ',
        'এপ্রিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগস্ট',
        'সেপ্টে',
        'অক্টো',
        'নভে',
        'ডিসে',
      ],
      AppLanguage.assamese: [
        'জানু',
        'ফেব্ৰু',
        'মাৰ্চ',
        'এপ্ৰিল',
        'মে',
        'জুন',
        'জুলাই',
        'আগ',
        'ছেপ্টে',
        'অক্টো',
        'নৱে',
        'ডিচে',
      ],
    };

    final month =
        months[_language]![date.month - 1];

    return '${date.day} $month ${date.year}';
  }

  Future<void> _pickDate() async {
    final now = DateTime.now();

    final picked = await showDatePicker(
      context: context,
      initialDate: _dob ?? now,
      firstDate: DateTime(1920),
      lastDate: now,
    );

    if (!mounted) {
      return;
    }

    if (picked != null) {
      setState(() {
        _dob = picked;
      });
    }
  }

  void _pickLanguage() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.background,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(sheetContext).size.height *
                      0.75,
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: AppLanguage.values.map(
                  (lang) {
                    final selected =
                        lang == _language;

                    return ListTile(
                      title: Text(
                        lang.nativeName,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: selected
                              ? AppColors.primaryGreen
                              : AppColors.textDark,
                        ),
                      ),
                      trailing: selected
                          ? const Icon(
                              Icons.check_circle,
                              color:
                                  AppColors.primaryGreen,
                            )
                          : null,
                      onTap: () {
                        setState(() {
                          _language = lang;
                        });

                        AppLanguageController
                            .instance
                            .setLanguage(lang);

                        Navigator.of(sheetContext).pop();
                      },
                    );
                  },
                ).toList(),
              ),
            ),
          ),
        );
      },
    );
  }

  void _onPhotoTap() {
    final l10n =
        AppLocalizations.of(_language);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          l10n.photoUploadComingSoon,
        ),
      ),
    );
  }

  Future<void> _onContinue() async {
    final name =
        _nameController.text.trim();

    if (name.isEmpty || _dob == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '${AppLocalizations.of(_language).name} '
            '& ${AppLocalizations.of(_language).dateOfBirth}',
          ),
        ),
      );

      return;
    }

    try {
      /*
       * Keep the patient name available to the
       * rest of the patient-facing application.
       */
      PatientNameController.instance
          .setName(name);

      final registrationData =
          widget.registrationData;

      /*
       * Registration flow:
       *
       * Save caregiver + patient together.
       */
      if (registrationData != null) {
        final pin =
            registrationData.pin;

        if (pin == null || pin.length != 4) {
          if (!mounted) {
            return;
          }

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(_language)
                    .caregiverPinMissing,
              ),
            ),
          );

          return;
        }

        final patientId =
            patientProfileController
                .createPatientId();

        await CaregiverAuthService
            .instance
            .saveCaregiverAndPatient(
          fullName:
              registrationData.fullName,
          phoneNumber:
              registrationData.phoneNumber,
          relationshipKey:
              registrationData.relationshipKey,
          preferredLanguage:
              registrationData
                  .preferredLanguage
                  .name,
          pin: pin,
          termsAccepted:
              widget.termsAccepted,
          dataUseAccepted:
              widget.dataUseAccepted,
          patientName: name,
          patientDob: _dob!,
          patientLanguage:
              _language.name,
          patientId: patientId,
        );
      } else {
        /*
         * Existing patient profile:
         *
         * Update the already existing local
         * profile controller instead of creating
         * another patient.
         */
        patientProfileController.saveProfile(
          fullName: name,
          dateOfBirth: _dob!,
          preferredLanguage: _language,
        );
      }

      if (!mounted) {
        return;
      }

      /*
       * When editing from Settings, simply go back.
       *
       * During first-time setup, continue to
       * Patient Home.
       */
      if (registrationData == null) {
        Navigator.of(context).pop();
        return;
      }

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (_) =>
              const PatientHomeScreen(),
        ),
        (route) => false,
      );
    } on FirebaseException catch (e) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.message ??
                AppLocalizations.of(_language)
                    .profileSaveFailed,
          ),
        ),
      );
    } catch (_) {
      if (!mounted) {
        return;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            AppLocalizations.of(_language)
                .profileSaveFailed,
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable:
          AppLanguageController.instance,
      builder: (context, _) {
        _language =
            AppLanguageController
                .instance
                .language;

        final l10n =
            AppLocalizations.of(_language);

        final speechText =
            '${l10n.setupProfileTitle}. '
            '${l10n.setupProfileDescription}';

        return Scaffold(
          backgroundColor:
              AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 12,
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context)
                              .maybePop();
                        },
                        icon: const Icon(
                          Icons.arrow_back,
                          color:
                              AppColors.textDark,
                        ),
                      ),
                      const Spacer(),
                      SpeakerButton(
                        text: speechText,
                        size: 44,
                      ),
                    ],
                  ),

                  const SizedBox(height: 4),

                  Text(
                    l10n.setupProfileTitle,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(height: 10),

                  Text(
                    l10n.setupProfileDescription,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge,
                    textAlign:
                        TextAlign.center,
                  ),

                  const SizedBox(height: 28),

                  _buildAvatar(),

                  const SizedBox(height: 28),

                  _buildNameField(l10n),

                  const SizedBox(height: 16),

                  _buildDateField(l10n),

                  const SizedBox(height: 16),

                  _buildLanguageField(l10n),

                  const SizedBox(height: 28),

                  AppButton(
                    label:
                        l10n.continueText,
                    onPressed:
                        _onContinue,
                  ),

                  const SizedBox(height: 12),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAvatar() {
    return SizedBox(
      width: 140,
      height: 140,
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          Container(
            width: 140,
            height: 140,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color:
                  AppColors.primaryGreenLight,
              border: Border.all(
                color:
                    AppColors.primaryGreen,
                width: 2,
              ),
            ),
            child: const Center(
              child: Icon(
                Icons.person_rounded,
                size: 76,
                color:
                    AppColors.primaryGreen,
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            right: 4,
            child: GestureDetector(
              onTap: _onPhotoTap,
              child: Container(
                width: 40,
                height: 40,
                decoration:
                    BoxDecoration(
                  shape: BoxShape.circle,
                  color:
                      AppColors.primaryGreen,
                  border: Border.all(
                    color:
                        AppColors.background,
                    width: 3,
                  ),
                ),
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(
    AppLocalizations l10n,
  ) {
    return AppCard(
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            l10n.name,
            style: const TextStyle(
              color:
                  AppColors.textMedium,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller:
                _nameController,
            style: const TextStyle(
              fontSize: 20,
              fontWeight:
                  FontWeight.w600,
              color:
                  AppColors.textDark,
            ),
            decoration:
                const InputDecoration(
              border:
                  InputBorder.none,
              isDense: true,
              contentPadding:
                  EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(
    AppLocalizations l10n,
  ) {
    return AppCard(
      onTap: _pickDate,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            l10n.dateOfBirth,
            style: const TextStyle(
              color:
                  AppColors.textMedium,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  _dob == null
                      ? ''
                      : _formatDate(_dob!),
                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons.calendar_today_rounded,
                color:
                    AppColors.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageField(
    AppLocalizations l10n,
  ) {
    return AppCard(
      onTap: _pickLanguage,
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            l10n.preferredLanguage,
            style: const TextStyle(
              color:
                  AppColors.textMedium,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  _language.nativeName,
                  style:
                      const TextStyle(
                    fontSize: 20,
                    fontWeight:
                        FontWeight.w600,
                    color:
                        AppColors.textDark,
                  ),
                ),
              ),
              const Icon(
                Icons
                    .keyboard_arrow_down_rounded,
                color:
                    AppColors.primaryGreen,
              ),
            ],
          ),
        ],
      ),
    );
  }
}