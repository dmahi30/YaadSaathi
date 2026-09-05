import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_settings_controller.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../caregiver/pin_access/caregiver_pin_screen.dart';

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: Listenable.merge([
            appSettings,
            AppLanguageController.instance,
          ]),
          builder: (context, _) {
            final l = AppLocalizations.current();
            final language = AppLanguageController.instance.language;

            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ---------------------------------------------------------
                  // TOP BAR
                  // ---------------------------------------------------------
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.primaryGreen,
                        ),
                      ),

                      Text(
                        'YaadSaathi Voice Mode',
                        style: const TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor: AppColors.background,
                        child: IconButton(
                          icon: const Icon(
                            Icons.volume_up_rounded,
                            color: AppColors.primaryGreen,
                          ),
                          onPressed: () async {
                            final tts = FlutterTts();

                            await tts.setSpeechRate(
                              appSettings.speechRate,
                            );

                            await tts.speak(
                              '${l.settings}. '
                              '${l.textSize}. '
                              '${l.display}. '
                              '${l.voice}. '
                              '${l.language}.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // ---------------------------------------------------------
                  // TITLE
                  // ---------------------------------------------------------
                  Text(
                    l.settings,
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),

                  const SizedBox(height: 20),

                  // ---------------------------------------------------------
                  // TEXT SIZE
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.text_fields_rounded,
                    iconBg: const Color(0xFFD7EFC6),
                    iconColor: AppColors.primaryGreen,
                    label: l.textSize,
                    value: _localizedTextSize(
                      appSettings.textSizeLabel,
                      language,
                    ),
                    onTap: () => _showPicker(
                      context,
                      title: l.textSize,
                      options: const [
                        'Small',
                        'Medium',
                        'Large',
                        'Extra Large',
                      ],
                      current: appSettings.textSizeLabel,
                      displayOption: (option) =>
                          _localizedTextSize(option, language),
                      onSelected: appSettings.setTextSize,
                    ),
                  ),

                  // ---------------------------------------------------------
                  // DISPLAY
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.contrast_rounded,
                    iconBg: const Color(0xFFD6E8F7),
                    iconColor: const Color(0xFF2B6CB0),
                    label: l.display,
                    value: _localizedDisplay(
                      appSettings.displayLabel,
                      language,
                    ),
                    onTap: () => _showPicker(
                      context,
                      title: l.display,
                      options: const [
                        'Normal',
                        'High Contrast',
                      ],
                      current: appSettings.displayLabel,
                      displayOption: (option) =>
                          _localizedDisplay(option, language),
                      onSelected: appSettings.setDisplay,
                    ),
                  ),

                  // ---------------------------------------------------------
                  // VOICE
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.volume_up_rounded,
                    iconBg: const Color(0xFFE3D9F7),
                    iconColor: const Color(0xFF6B46C1),
                    label: l.voice,
                    value: _localizedVoiceSpeed(
                      appSettings.voiceSpeedLabel,
                      language,
                    ),
                    onTap: () => _showPicker(
                      context,
                      title: l.voice,
                      options: const [
                        'Slow',
                        'Normal Speed',
                        'Fast',
                      ],
                      current: appSettings.voiceSpeedLabel,
                      displayOption: (option) =>
                          _localizedVoiceSpeed(option, language),
                      onSelected: appSettings.setVoiceSpeed,
                    ),
                  ),

                  // ---------------------------------------------------------
                  // LANGUAGE
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    iconBg: const Color(0xFFD7EFC6),
                    iconColor: AppColors.primaryGreen,
                    label: l.language,
                    value: language.nativeName,
                    onTap: () => _showLanguagePicker(
                      context,
                      currentLanguage: language,
                    ),
                  ),

                  // ---------------------------------------------------------
                  // CAREGIVER ACCESS
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.lock_open_rounded,
                    iconBg: const Color(0xFFFCEBBF),
                    iconColor: const Color(0xFFB7791F),
                    label: l.caregiverAccess,
                    value: 'Front-Pin',
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => const CaregiverPinScreen(),
                        ),
                      );
                    },
                  ),

                  // ---------------------------------------------------------
                  // CALL CAREGIVER
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.call_rounded,
                    iconBg: const Color(0xFFF7D9DC),
                    iconColor: const Color(0xFFC53030),
                    label: l.callCaregiver,
                    value: 'Mohan',
                    onTap: () => _showCallDialog(
                      context,
                      'Mohan',
                      language,
                    ),
                  ),

                  // ---------------------------------------------------------
                  // PRIVACY & HELP
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.help_outline_rounded,
                    iconBg: const Color(0xFFE3D9F7),
                    iconColor: const Color(0xFF6B46C1),
                    label: l.privacyHelp,
                    value: '',
                    onTap: () => _showInfoDialog(
                      context,
                      title: l.privacyHelp,
                      body: _privacyText(language),
                    ),
                  ),

                  // ---------------------------------------------------------
                  // ABOUT
                  // ---------------------------------------------------------
                  _SettingsRow(
                    icon: Icons.info_outline_rounded,
                    iconBg: const Color(0xFFD6E8F7),
                    iconColor: const Color(0xFF2B6CB0),
                    label: l.aboutYaadSaathi,
                    value: '',
                    onTap: () => _showInfoDialog(
                      context,
                      title: l.aboutYaadSaathi,
                      body: _aboutText(language),
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

  // =========================================================================
  // LANGUAGE PICKER
  // =========================================================================

  void _showLanguagePicker(
    BuildContext context, {
    required AppLanguage currentLanguage,
  }) {
    final l = AppLocalizations.current();

    final languages = AppLanguage.values;

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(
              top: 12,
              bottom: 12,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l.language,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                ...languages.map(
                  (language) => ListTile(
                    leading: const Icon(
                      Icons.language_rounded,
                      color: AppColors.primaryGreen,
                    ),
                    title: Text(
                      language.nativeName,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    trailing: language == currentLanguage
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors.primaryGreen,
                          )
                        : null,
                    onTap: () {
                      // Update the REAL global language.
                      AppLanguageController.instance.setLanguage(
                        language,
                      );

                      // Keep the old settings controller in sync.
                      appSettings.setLanguage(
                        language.nativeName,
                      );

                      Navigator.of(sheetContext).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // NORMAL PICKER
  // =========================================================================

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String current,
    required void Function(String) onSelected,
    required String Function(String) displayOption,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(sheetContext).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),

                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map(
                      (option) => ListTile(
                        title: Text(
                          displayOption(option),
                          style: const TextStyle(
                            fontSize: 17,
                          ),
                        ),
                        trailing: option == current
                            ? const Icon(
                                Icons.check_circle,
                                color: AppColors.primaryGreen,
                              )
                            : null,
                        onTap: () {
                          onSelected(option);
                          Navigator.of(sheetContext).pop();
                        },
                      ),
                    ).toList(),
                  ),
                ),

                const SizedBox(height: 8),
              ],
            ),
          ),
        );
      },
    );
  }

  // =========================================================================
  // CALL DIALOG
  // =========================================================================

  void _showCallDialog(
    BuildContext context,
    String name,
    AppLanguage language,
  ) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(
          _callTitle(name, language),
        ),
        content: Text(
          _callBody(language),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              _cancelText(language),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryGreen,
            ),
            onPressed: () {
              // Wire url_launcher tel: here later.
              Navigator.of(dialogContext).pop();
            },
            child: Text(
              _callText(language),
              style: const TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // INFO DIALOG
  // =========================================================================

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              AppLocalizations.current().cancel,
            ),
          ),
        ],
      ),
    );
  }

  // =========================================================================
  // LOCALIZED SETTINGS VALUES
  // =========================================================================

  String _localizedTextSize(
    String value,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.hindi:
        switch (value) {
          case 'Small':
            return 'छोटा';
          case 'Large':
            return 'बड़ा';
          case 'Extra Large':
            return 'बहुत बड़ा';
          default:
            return 'मध्यम';
        }

      case AppLanguage.marathi:
        switch (value) {
          case 'Small':
            return 'लहान';
          case 'Large':
            return 'मोठा';
          case 'Extra Large':
            return 'खूप मोठा';
          default:
            return 'मध्यम';
        }

      case AppLanguage.bengali:
        switch (value) {
          case 'Small':
            return 'ছোট';
          case 'Large':
            return 'বড়';
          case 'Extra Large':
            return 'খুব বড়';
          default:
            return 'মাঝারি';
        }

      case AppLanguage.assamese:
        switch (value) {
          case 'Small':
            return 'সৰু';
          case 'Large':
            return 'ডাঙৰ';
          case 'Extra Large':
            return 'অতি ডাঙৰ';
          default:
            return 'মধ্যম';
        }

      case AppLanguage.english:
        return value;
    }
  }

  String _localizedDisplay(
    String value,
    AppLanguage language,
  ) {
    if (language == AppLanguage.hindi) {
      return value == 'High Contrast' ? 'उच्च कंट्रास्ट' : 'सामान्य';
    }

    if (language == AppLanguage.marathi) {
      return value == 'High Contrast' ? 'उच्च कॉन्ट्रास्ट' : 'सामान्य';
    }

    if (language == AppLanguage.bengali) {
      return value == 'High Contrast' ? 'উচ্চ কনট্রাস্ট' : 'সাধারণ';
    }

    if (language == AppLanguage.assamese) {
      return value == 'High Contrast' ? 'উচ্চ কনট্ৰাষ্ট' : 'সাধাৰণ';
    }

    return value;
  }

  String _localizedVoiceSpeed(
    String value,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.hindi:
        if (value == 'Slow') return 'धीमी';
        if (value == 'Fast') return 'तेज़';
        return 'सामान्य गति';

      case AppLanguage.marathi:
        if (value == 'Slow') return 'हळू';
        if (value == 'Fast') return 'जलद';
        return 'सामान्य वेग';

      case AppLanguage.bengali:
        if (value == 'Slow') return 'ধীর';
        if (value == 'Fast') return 'দ্রুত';
        return 'স্বাভাবিক গতি';

      case AppLanguage.assamese:
        if (value == 'Slow') return 'লাহে';
        if (value == 'Fast') return 'দ্ৰুত';
        return 'স্বাভাৱিক গতি';

      case AppLanguage.english:
        return value;
    }
  }

  // =========================================================================
  // DIALOG TRANSLATIONS
  // =========================================================================

  String _callTitle(
    String name,
    AppLanguage language,
  ) {
    switch (language) {
      case AppLanguage.hindi:
        return '$name को कॉल करें?';
      case AppLanguage.marathi:
        return '$name ला कॉल करायचा का?';
      case AppLanguage.bengali:
        return '$name-কে কল করবেন?';
      case AppLanguage.assamese:
        return '$name-ক ফোন কৰিবনে?';
      case AppLanguage.english:
        return 'Call $name?';
    }
  }

  String _callBody(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return 'इससे आपके केयरगिवर को फोन कॉल शुरू होगी।';
      case AppLanguage.marathi:
        return 'यामुळे तुमच्या केअरगिव्हरला फोन केला जाईल.';
      case AppLanguage.bengali:
        return 'এটি আপনার কেয়ারগিভারকে একটি ফোন কল শুরু করবে।';
      case AppLanguage.assamese:
        return 'ইয়াৰ জৰিয়তে আপোনাৰ কেয়াৰগিভাৰলৈ ফোন কৰা হ’ব।';
      case AppLanguage.english:
        return 'This will start a phone call to your caregiver.';
    }
  }

  String _cancelText(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return 'रद्द करें';
      case AppLanguage.marathi:
        return 'रद्द करा';
      case AppLanguage.bengali:
        return 'বাতিল';
      case AppLanguage.assamese:
        return 'বাতিল কৰক';
      case AppLanguage.english:
        return 'Cancel';
    }
  }

  String _callText(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return 'कॉल करें';
      case AppLanguage.marathi:
        return 'कॉल करा';
      case AppLanguage.bengali:
        return 'কল করুন';
      case AppLanguage.assamese:
        return 'ফোন কৰক';
      case AppLanguage.english:
        return 'Call';
    }
  }

  String _privacyText(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return 'आपकी गतिविधि और स्वास्थ्य संबंधी जानकारी सुरक्षित रखी जाती है और केवल आपके पंजीकृत केयरगिवर के साथ साझा की जाती है। ऐप का उपयोग करने में सहायता चाहिए तो अपने केयरगिवर से संपर्क करें।';

      case AppLanguage.marathi:
        return 'तुमची क्रिया आणि आरोग्याशी संबंधित माहिती सुरक्षित ठेवली जाते आणि फक्त तुमच्या नोंदणीकृत केअरगिव्हरसह शेअर केली जाते. अॅप वापरण्यास मदत हवी असल्यास तुमच्या केअरगिव्हरशी संपर्क साधा.';

      case AppLanguage.bengali:
        return 'আপনার কার্যকলাপ এবং স্বাস্থ্য সংক্রান্ত তথ্য নিরাপদে সংরক্ষণ করা হয় এবং শুধুমাত্র আপনার নিবন্ধিত কেয়ারগিভারের সঙ্গে শেয়ার করা হয়। অ্যাপ ব্যবহার করতে সাহায্যের প্রয়োজন হলে আপনার কেয়ারগিভারের সঙ্গে যোগাযোগ করুন।';

      case AppLanguage.assamese:
        return 'আপোনাৰ কাৰ্যকলাপ আৰু স্বাস্থ্য সম্পৰ্কীয় তথ্য সুৰক্ষিতভাৱে সংৰক্ষণ কৰা হয় আৰু কেৱল আপোনাৰ পঞ্জীয়নভুক্ত কেয়াৰগিভাৰৰ সৈতে ভাগ কৰা হয়। এপটো ব্যৱহাৰ কৰাত সহায়ৰ প্ৰয়োজন হ’লে আপোনাৰ কেয়াৰগিভাৰৰ সৈতে যোগাযোগ কৰক।';

      case AppLanguage.english:
        return 'Your activity and health data is stored securely and only shared with your registered caregiver. Contact your caregiver if you need help using the app.';
    }
  }

  String _aboutText(AppLanguage language) {
    switch (language) {
      case AppLanguage.hindi:
        return 'YaadSaathi आपको अपने प्रिय लोगों और रोज़मर्रा की दिनचर्या से जुड़े रहने में मदद करता है, साथ ही सरल दैनिक स्मृति गतिविधियाँ प्रदान करता है।';

      case AppLanguage.marathi:
        return 'YaadSaathi तुम्हाला तुमच्या प्रिय व्यक्ती आणि दैनंदिन दिनचर्येशी जोडलेले राहण्यास मदत करते आणि सोप्या दैनंदिन स्मरणशक्तीच्या क्रिया देते.';

      case AppLanguage.bengali:
        return 'YaadSaathi আপনাকে আপনার প্রিয় মানুষ এবং দৈনন্দিন রুটিনের সঙ্গে যুক্ত থাকতে সাহায্য করে এবং সহজ দৈনিক স্মৃতি কার্যকলাপ প্রদান করে।';

      case AppLanguage.assamese:
        return 'YaadSaathi-য়ে আপোনাক আপোনাৰ প্ৰিয় মানুহ আৰু দৈনন্দিন কাম-কাজৰ সৈতে সংযুক্ত হৈ থাকিবলৈ সহায় কৰে আৰু সহজ দৈনিক স্মৃতি কাৰ্যকলাপ প্ৰদান কৰে।';

      case AppLanguage.english:
        return 'YaadSaathi helps you stay connected to the people and routines you love, with simple daily memory activities.';
    }
  }
}

// =============================================================================
// SETTINGS ROW
// =============================================================================

class _SettingsRow extends StatelessWidget {
  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final String value;
  final VoidCallback onTap;

  const _SettingsRow({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor: iconBg,
                  child: Icon(
                    icon,
                    color: iconColor,
                    size: 20,
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Text(
                    label,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),

                if (value.isNotEmpty)
                  Flexible(
                    child: Text(
                      value,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.end,
                      style: const TextStyle(
                        color: AppColors.textMedium,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right,
                  color: AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}