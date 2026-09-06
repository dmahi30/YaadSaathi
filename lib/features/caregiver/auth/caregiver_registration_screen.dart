import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/speaker_button.dart';
import 'caregiver_auth_service.dart';
import 'caregiver_registration_data.dart';
import 'otp_verification_screen.dart';

class CaregiverRegistrationScreen extends StatefulWidget {
  const CaregiverRegistrationScreen({super.key});

  @override
  State<CaregiverRegistrationScreen> createState() =>
      _CaregiverRegistrationScreenState();
}

class _CaregiverRegistrationScreenState
    extends State<CaregiverRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  String? _selectedRelationship;
  AppLanguage? _selectedLanguage;

  File? _profileImage;

  bool get _canContinue {
    return _nameController.text.trim().isNotEmpty &&
        _phoneController.text.trim().isNotEmpty &&
        _selectedRelationship != null &&
        _selectedLanguage != null;
  }

  @override
  void initState() {
    super.initState();

    _nameController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _pickProfilePhoto() async {
    final ImagePicker picker = ImagePicker();

    final XFile? image = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 85,
    );

    if (image == null) return;

    setState(() {
      _profileImage = File(image.path);
    });
  }

  Future<void> _continue() async {
  if (!_canContinue) return;

  FocusScope.of(context).unfocus();

  final data = CaregiverRegistrationData(
    fullName: _nameController.text.trim(),
    phoneNumber: _phoneController.text.trim(),
    relationshipKey: _selectedRelationship!,
    preferredLanguage: _selectedLanguage!,
    profileImage: _profileImage,
  );

  try {
    await CaregiverAuthService.instance.sendOtp(
      phoneNumber: data.phoneNumber,
      onCodeSent: (verificationId, resendToken) {
        if (!mounted) return;

        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (_) => OtpVerificationScreen(
              registrationData: data,
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          ),
        );
      },
      onVerificationCompleted: (credential) async {
        try {
          await CaregiverAuthService.instance.auth
              .signInWithCredential(credential);

          if (!mounted) return;

          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (_) => OtpVerificationScreen(
                registrationData: data,
                verificationId: null,
                resendToken: null,
                alreadyVerified: true,
              ),
            ),
          );
        } catch (e) {
          if (!mounted) return;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Phone verification failed: $e'),
            ),
          );
        }
      },
      onVerificationFailed: (FirebaseAuthException error) {
        if (!mounted) return;

        String message = 'Could not send OTP.';

        if (error.code == 'invalid-phone-number') {
          message = 'Please enter a valid phone number.';
        } else if (error.code == 'too-many-requests') {
          message = 'Too many attempts. Please try again later.';
        } else if (error.message != null &&
            error.message!.trim().isNotEmpty) {
          message = error.message!;
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      },
    );
  } catch (e) {
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Could not start phone verification: $e'),
      ),
    );
  }
}

  Future<void> _showRelationshipPicker(
    AppLocalizations l10n,
  ) async {
    final Map<String, String> relationships = {
      'spouse': l10n.spouse,
      'son': l10n.son,
      'daughter': l10n.daughter,
      'grandson': l10n.grandson,
      'granddaughter': l10n.granddaughter,
      'sibling': l10n.sibling,
      'other': l10n.other,
    };

    final String? selected =
        await showModalBottomSheet<String>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    l10n.relationshipToPatient,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...relationships.entries.map((entry) {
                    final bool isSelected =
                        _selectedRelationship == entry.key;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.favorite_outline,
                        color: AppColors.primaryGreen,
                      ),
                      title: Text(
                        entry.value,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          entry.key,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedRelationship = selected;
    });
  }

  Future<void> _showLanguagePicker() async {
    final AppLanguage? selected =
        await showModalBottomSheet<AppLanguage>(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      builder: (context) {
        // EXACTLY the five supported languages.
        final List<AppLanguage> languages =
            AppLanguage.values;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(context).size.height * 0.85,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                18,
                20,
                20,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    AppLocalizations.current()
                        .preferredLanguage,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...languages.map((language) {
                    final bool isSelected =
                        _selectedLanguage == language;

                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: const Icon(
                        Icons.language,
                        color: AppColors.primaryGreen,
                      ),
                      title: Text(
                        language.nativeName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark,
                        ),
                      ),
                      trailing: isSelected
                          ? const Icon(
                              Icons.check_circle,
                              color: AppColors.primaryGreen,
                            )
                          : null,
                      onTap: () {
                        Navigator.pop(
                          context,
                          language,
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
          ),
        );
      },
    );

    if (selected == null) return;

    setState(() {
      _selectedLanguage = selected;
    });

    // IMPORTANT:
    // This was missing before.
    // Now the selected language becomes the app-wide language.
    AppLanguageController.instance.setLanguage(selected);
  }

  String? _relationshipText(
    AppLocalizations l10n,
  ) {
    switch (_selectedRelationship) {
      case 'spouse':
        return l10n.spouse;
      case 'son':
        return l10n.son;
      case 'daughter':
        return l10n.daughter;
      case 'grandson':
        return l10n.grandson;
      case 'granddaughter':
        return l10n.granddaughter;
      case 'sibling':
        return l10n.sibling;
      case 'other':
        return l10n.other;
      default:
        return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: AppLanguageController.instance,
      builder: (context, _) {
        final AppLocalizations currentL10n =
            AppLocalizations.current();

        final String? relationshipText =
            _relationshipText(currentL10n);

        final String? languageText =
            _selectedLanguage?.nativeName;

        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                12,
                20,
                24,
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      _CircleButton(
                        icon: Icons.arrow_back_ios_new,
                        onTap: () =>
                            Navigator.pop(context),
                      ),
                      SpeakerButton(
                        text:
                            '${currentL10n.createCaregiverAccount}. '
                            '${currentL10n.letsGetStartedWithDetails}',
                        size: 48,
                      ),
                    ],
                  ),

                  const SizedBox(height: 18),

                  Text(
                    currentL10n.createCaregiverAccount,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textDark,
                      height: 1.15,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    currentL10n.letsGetStartedWithDetails,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 22),

                  GestureDetector(
                    onTap: _pickProfilePhoto,
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 108,
                              height: 108,
                              decoration: BoxDecoration(
                                color: AppColors
                                    .primaryGreenLight,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color:
                                      AppColors.primaryGreen,
                                  width: 1.5,
                                ),
                              ),
                              child: ClipOval(
                                child: _profileImage == null
                                    ? const Icon(
                                        Icons.person,
                                        color: AppColors
                                            .primaryGreen,
                                        size: 58,
                                      )
                                    : Image.file(
                                        _profileImage!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                            ),
                            Positioned(
                              right: 0,
                              bottom: 2,
                              child: Container(
                                width: 38,
                                height: 38,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt_outlined,
                                  color: AppColors.textDark,
                                  size: 21,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${currentL10n.addProfilePhoto} '
                          '(${currentL10n.optional})',
                          style: const TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 22),

                  _TextInputField(
                    icon: Icons.person_outline,
                    label: currentL10n.fullName,
                    hint: currentL10n.enterFullName,
                    controller: _nameController,
                    keyboardType: TextInputType.name,
                    textCapitalization:
                        TextCapitalization.words,
                  ),

                  const SizedBox(height: 12),

                  _TextInputField(
                    icon: Icons.phone_outlined,
                    label: currentL10n.phoneNumber,
                    hint: currentL10n.enterPhoneNumber,
                    controller: _phoneController,
                    keyboardType: TextInputType.phone,
                  ),

                  const SizedBox(height: 12),

                  _DropdownField(
                    icon: Icons.favorite_outline,
                    label:
                        currentL10n.relationshipToPatient,
                    value: relationshipText,
                    hint: currentL10n.selectRelationship,
                    onTap: () =>
                        _showRelationshipPicker(
                      currentL10n,
                    ),
                  ),

                  const SizedBox(height: 12),

                  _DropdownField(
                    icon: Icons.language,
                    label: currentL10n.preferredLanguage,
                    value: languageText,
                    hint: currentL10n.preferredLanguage,
                    onTap: _showLanguagePicker,
                  ),

                  const SizedBox(height: 22),

                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          _canContinue ? _continue : null,
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                            AppColors.primaryGreen,
                        disabledBackgroundColor:
                            AppColors.primaryGreen
                                .withValues(alpha: 0.35),
                        foregroundColor: Colors.white,
                        disabledForegroundColor:
                            Colors.white70,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.circular(15),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment.center,
                        children: [
                          Text(
                            currentL10n.continueText,
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Icon(
                            Icons.arrow_forward,
                            size: 21,
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _TextInputField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;

  const _TextInputField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    this.textCapitalization =
        TextCapitalization.none,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFFE6E6E6),
        ),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        style: const TextStyle(
          fontSize: 15,
          color: AppColors.textDark,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          prefixIcon: Icon(
            icon,
            color: AppColors.primaryGreen,
          ),
          labelText: label,
          hintText: hint,
          labelStyle: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: AppColors.textDark,
          ),
          hintStyle: const TextStyle(
            fontSize: 14,
            color: Colors.grey,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 13,
          ),
        ),
      ),
    );
  }
}

class _DropdownField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String? value;
  final String hint;
  final VoidCallback onTap;

  const _DropdownField({
    required this.icon,
    required this.label,
    required this.value,
    required this.hint,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding:
              const EdgeInsets.fromLTRB(
            12,
            9,
            12,
            9,
          ),
          decoration: BoxDecoration(
            borderRadius:
                BorderRadius.circular(14),
            border: Border.all(
              color: const Color(0xFFE6E6E6),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: AppColors.primaryGreen,
                size: 23,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: AppColors.textDark,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      value ?? hint,
                      style: TextStyle(
                        fontSize: 14,
                        color: value == null
                            ? Colors.grey
                            : AppColors.textDark,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.keyboard_arrow_down,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CircleButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;

  const _CircleButton({
    required this.icon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.white,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: Container(
          width: 46,
          height: 46,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: const Color(0xFFE5E5E5),
            ),
          ),
          child: Icon(
            icon,
            size: 20,
            color: AppColors.textDark,
          ),
        ),
      ),
    );
  }
}