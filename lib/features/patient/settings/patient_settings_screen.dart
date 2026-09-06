import 'package:flutter/material.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/services/audio_service.dart';
import '../../../core/state/app_settings_controller.dart';
import '../../caregiver/auth/caregiver_auth_screen.dart';

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  String _textSizeLabel(
    AppLanguage language,
    String key,
  ) {
    final labels = {
      AppLanguage.english: {
        'small': 'Small',
        'medium': 'Medium',
        'large': 'Large',
        'extraLarge': 'Extra Large',
      },
      AppLanguage.hindi: {
        'small': 'छोटा',
        'medium': 'मध्यम',
        'large': 'बड़ा',
        'extraLarge': 'बहुत बड़ा',
      },
      AppLanguage.marathi: {
        'small': 'लहान',
        'medium': 'मध्यम',
        'large': 'मोठा',
        'extraLarge': 'खूप मोठा',
      },
      AppLanguage.bengali: {
        'small': 'ছোট',
        'medium': 'মাঝারি',
        'large': 'বড়',
        'extraLarge': 'খুব বড়',
      },
      AppLanguage.assamese: {
        'small': 'সৰু',
        'medium': 'মধ্যম',
        'large': 'ডাঙৰ',
        'extraLarge': 'অতি ডাঙৰ',
      },
    };

    return labels[language]![key]!;
  }

  String _displayLabel(
    AppLanguage language,
    String key,
  ) {
    final labels = {
      AppLanguage.english: {
        'normal': 'Normal',
        'high': 'High Contrast',
      },
      AppLanguage.hindi: {
        'normal': 'सामान्य',
        'high': 'उच्च कंट्रास्ट',
      },
      AppLanguage.marathi: {
        'normal': 'सामान्य',
        'high': 'उच्च कॉन्ट्रास्ट',
      },
      AppLanguage.bengali: {
        'normal': 'স্বাভাবিক',
        'high': 'উচ্চ কনট্রাস্ট',
      },
      AppLanguage.assamese: {
        'normal': 'সাধাৰণ',
        'high': 'উচ্চ কনট্ৰাষ্ট',
      },
    };

    return labels[language]![key]!;
  }

  String _voiceLabel(
    AppLanguage language,
    String key,
  ) {
    final labels = {
      AppLanguage.english: {
        'slow': 'Slow',
        'normal': 'Normal Speed',
        'fast': 'Fast',
      },
      AppLanguage.hindi: {
        'slow': 'धीमी',
        'normal': 'सामान्य गति',
        'fast': 'तेज़',
      },
      AppLanguage.marathi: {
        'slow': 'हळू',
        'normal': 'सामान्य वेग',
        'fast': 'जलद',
      },
      AppLanguage.bengali: {
        'slow': 'ধীর',
        'normal': 'স্বাভাবিক গতি',
        'fast': 'দ্রুত',
      },
      AppLanguage.assamese: {
        'slow': 'লাহে লাহে',
        'normal': 'সাধাৰণ গতি',
        'fast': 'দ্ৰুত',
      },
    };

    return labels[language]![key]!;
  }

  String _canonicalTextSize(
    String selected,
    AppLanguage language,
  ) {
    final Map<String, String> values = {
      _textSizeLabel(language, 'small'): 'Small',
      _textSizeLabel(language, 'medium'): 'Medium',
      _textSizeLabel(language, 'large'): 'Large',
      _textSizeLabel(language, 'extraLarge'):
          'Extra Large',
    };

    return values[selected] ?? selected;
  }

  String _localizedTextSizeValue(
    String canonical,
    AppLanguage language,
  ) {
    switch (canonical) {
      case 'Small':
        return _textSizeLabel(
          language,
          'small',
        );

      case 'Large':
        return _textSizeLabel(
          language,
          'large',
        );

      case 'Extra Large':
        return _textSizeLabel(
          language,
          'extraLarge',
        );

      case 'Medium':
      default:
        return _textSizeLabel(
          language,
          'medium',
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: Listenable.merge([
        appSettings,
        AppLanguageController.instance,
      ]),
      builder: (context, _) {
        final language =
            AppLanguageController.instance.language;

        final l10n =
            AppLocalizations.of(language);

        final textSizeValue =
            _localizedTextSizeValue(
          appSettings.textSizeLabel,
          language,
        );

        return Scaffold(
          backgroundColor:
              AppColors.background,
          body: SafeArea(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
                vertical: 16,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () =>
                            Navigator.of(context)
                                .maybePop(),
                        icon: const Icon(
                          Icons.arrow_back,
                          color:
                              AppColors.primaryGreen,
                        ),
                      ),

                      Text(
                        l10n.appName,
                        style:
                            const TextStyle(
                          fontWeight:
                              FontWeight.w600,
                          fontSize: 16,
                          color:
                              AppColors.textDark,
                        ),
                      ),

                      CircleAvatar(
                        backgroundColor:
                            AppColors.background,
                        child: IconButton(
                          icon: const Icon(
                            Icons.volume_up_rounded,
                            color: AppColors
                                .primaryGreen,
                          ),
                          onPressed: () {
                            AudioService().speak(
                              '${l10n.textSize}, '
                              '${l10n.display}, '
                              '${l10n.language}.',
                            );
                          },
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  Text(
                    l10n.settings,
                    style: Theme.of(context)
                        .textTheme
                        .headlineMedium,
                  ),

                  const SizedBox(height: 20),

                  // TEXT SIZE
                  _SettingsRow(
                    icon:
                        Icons.text_fields_rounded,
                    iconBg:
                        const Color(0xFFD7EFC6),
                    iconColor:
                        AppColors.primaryGreen,
                    label: l10n.textSize,
                    value: textSizeValue,
                    onTap: () {
                      final options = [
                        _textSizeLabel(
                          language,
                          'small',
                        ),
                        _textSizeLabel(
                          language,
                          'medium',
                        ),
                        _textSizeLabel(
                          language,
                          'large',
                        ),
                        _textSizeLabel(
                          language,
                          'extraLarge',
                        ),
                      ];

                      _showPicker(
                        context,
                        title: l10n.textSize,
                        options: options,
                        current: textSizeValue,
                        onSelected: (selected) {
                          final canonical =
                              _canonicalTextSize(
                            selected,
                            language,
                          );

                          // This changes the actual
                          // global text scale because
                          // app.dart listens to appSettings.
                          appSettings.setTextSize(
                            canonical,
                          );
                        },
                      );
                    },
                  ),

                  // DISPLAY
                  _SettingsRow(
                    icon:
                        Icons.contrast_rounded,
                    iconBg:
                        const Color(0xFFD6E8F7),
                    iconColor:
                        const Color(0xFF2B6CB0),
                    label: l10n.display,
                    value: appSettings
                                .displayLabel ==
                            'High Contrast'
                        ? _displayLabel(
                            language,
                            'high',
                          )
                        : _displayLabel(
                            language,
                            'normal',
                          ),
                    onTap: () {
                      final normal =
                          _displayLabel(
                        language,
                        'normal',
                      );

                      final high =
                          _displayLabel(
                        language,
                        'high',
                      );

                      _showPicker(
                        context,
                        title: l10n.display,
                        options: [
                          normal,
                          high,
                        ],
                        current:
                            appSettings.displayLabel ==
                                    'High Contrast'
                                ? high
                                : normal,
                        onSelected: (selected) {
                          appSettings.setDisplay(
                            selected == high
                                ? 'High Contrast'
                                : 'Normal',
                          );
                        },
                      );
                    },
                  ),

                  // VOICE SPEED
                  _SettingsRow(
                    icon:
                        Icons.volume_up_rounded,
                    iconBg:
                        const Color(0xFFE3D9F7),
                    iconColor:
                        const Color(0xFF6B46C1),
                    label: l10n.voice,
                    value: _localizedVoiceValue(
                      appSettings.voiceSpeedLabel,
                      language,
                    ),
                    onTap: () {
                      final slow =
                          _voiceLabel(
                        language,
                        'slow',
                      );

                      final normal =
                          _voiceLabel(
                        language,
                        'normal',
                      );

                      final fast =
                          _voiceLabel(
                        language,
                        'fast',
                      );

                      _showPicker(
                        context,
                        title: l10n.voice,
                        options: [
                          slow,
                          normal,
                          fast,
                        ],
                        current:
                            _localizedVoiceValue(
                          appSettings
                              .voiceSpeedLabel,
                          language,
                        ),
                        onSelected: (selected) {
                          if (selected == slow) {
                            appSettings
                                .setVoiceSpeed(
                              'Slow',
                            );
                          } else if (selected ==
                              fast) {
                            appSettings
                                .setVoiceSpeed(
                              'Fast',
                            );
                          } else {
                            appSettings
                                .setVoiceSpeed(
                              'Normal Speed',
                            );
                          }
                        },
                      );
                    },
                  ),

                  // LANGUAGE — EXACTLY 5
                  _SettingsRow(
                    icon:
                        Icons.language_rounded,
                    iconBg:
                        const Color(0xFFD7EFC6),
                    iconColor:
                        AppColors.primaryGreen,
                    label: l10n.language,
                    value: language.nativeName,
                    onTap: () {
                      _showLanguagePicker(
                        context,
                        language,
                      );
                    },
                  ),

                  // CAREGIVER ACCESS
                  _SettingsRow(
                    icon:
                        Icons.lock_open_rounded,
                    iconBg:
                        const Color(0xFFFCEBBF),
                    iconColor:
                        const Color(0xFFB7791F),
                    label:
                        l10n.caregiverAccess,
                    value: '',
                    onTap: () {
                      Navigator.of(context)
                          .push(
                        MaterialPageRoute(
                          builder: (_) =>
                              const CaregiverAuthScreen(),
                        ),
                      );
                    },
                  ),

                  // CALL CAREGIVER
                  _SettingsRow(
                    icon: Icons.call_rounded,
                    iconBg:
                        const Color(0xFFF7D9DC),
                    iconColor:
                        const Color(0xFFC53030),
                    label:
                        l10n.callCaregiver,
                    value: '',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title:
                            l10n.callCaregiver,
                        body:
                            l10n.callCaregiver,
                      );
                    },
                  ),

                  // PRIVACY & HELP
                  _SettingsRow(
                    icon:
                        Icons.help_outline_rounded,
                    iconBg:
                        const Color(0xFFE3D9F7),
                    iconColor:
                        const Color(0xFF6B46C1),
                    label:
                        l10n.privacyHelp,
                    value: '',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title:
                            l10n.privacyHelp,
                        body:
                            l10n.privacyHelp,
                      );
                    },
                  ),

                  // ABOUT
                  _SettingsRow(
                    icon:
                        Icons.info_outline_rounded,
                    iconBg:
                        const Color(0xFFD6E8F7),
                    iconColor:
                        const Color(0xFF2B6CB0),
                    label:
                        l10n.aboutYaadSaathi,
                    value: '',
                    onTap: () {
                      _showInfoDialog(
                        context,
                        title:
                            l10n.aboutYaadSaathi,
                        body:
                            l10n.aboutYaadSaathi,
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _localizedVoiceValue(
    String canonical,
    AppLanguage language,
  ) {
    switch (canonical) {
      case 'Slow':
        return _voiceLabel(
          language,
          'slow',
        );

      case 'Fast':
        return _voiceLabel(
          language,
          'fast',
        );

      case 'Normal Speed':
      default:
        return _voiceLabel(
          language,
          'normal',
        );
    }
  }

  void _showLanguagePicker(
    BuildContext context,
    AppLanguage current,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        // EXACTLY FIVE.
        final languages =
            AppLanguage.values;

        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(sheetContext)
                      .size
                      .height *
                      0.7,
            ),
            child: ListView(
              shrinkWrap: true,
              children: languages.map(
                (language) {
                  final selected =
                      language == current;

                  return ListTile(
                    title: Text(
                      language.nativeName,
                      style:
                          const TextStyle(
                        fontSize: 17,
                        fontWeight:
                            FontWeight.w600,
                      ),
                    ),
                    trailing: selected
                        ? const Icon(
                            Icons.check_circle,
                            color: AppColors
                                .primaryGreen,
                          )
                        : null,
                    onTap: () {
                      AppLanguageController
                          .instance
                          .setLanguage(
                        language,
                      );

                      Navigator.of(
                        sheetContext,
                      ).pop();
                    },
                  );
                },
              ).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String current,
    required void Function(String)
        onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true,
      shape:
          const RoundedRectangleBorder(
        borderRadius:
            BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight:
                  MediaQuery.of(sheetContext)
                      .size
                      .height *
                      0.7,
            ),
            child: Column(
              mainAxisSize:
                  MainAxisSize.min,
              children: [
                Padding(
                  padding:
                      const EdgeInsets.all(16),
                  child: Text(
                    title,
                    style:
                        const TextStyle(
                      fontSize: 18,
                      fontWeight:
                          FontWeight.w700,
                    ),
                  ),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map(
                      (option) {
                        return ListTile(
                          title:
                              Text(option),
                          trailing:
                              option == current
                                  ? const Icon(
                                      Icons
                                          .check_circle,
                                      color: AppColors
                                          .primaryGreen,
                                    )
                                  : null,
                          onTap: () {
                            onSelected(
                              option,
                            );
                            Navigator.of(
                              sheetContext,
                            ).pop();
                          },
                        );
                      },
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

  void _showInfoDialog(
    BuildContext context, {
    required String title,
    required String body,
  }) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(title),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () =>
                  Navigator.of(
                dialogContext,
              ).pop(),
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }
}

class _SettingsRow
    extends StatelessWidget {
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
      padding:
          const EdgeInsets.only(
        bottom: 12,
      ),
      child: Material(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
        child: InkWell(
          borderRadius:
              BorderRadius.circular(16),
          onTap: onTap,
          child: Padding(
            padding:
                const EdgeInsets.all(14),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundColor:
                      iconBg,
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
                    style:
                        const TextStyle(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w600,
                      color:
                          AppColors.textDark,
                    ),
                  ),
                ),

                if (value.isNotEmpty)
                  Flexible(
                    child: Text(
                      value,
                      overflow:
                          TextOverflow.ellipsis,
                      style:
                          const TextStyle(
                        color: AppColors
                            .textMedium,
                        fontSize: 14,
                      ),
                    ),
                  ),

                const SizedBox(width: 4),

                const Icon(
                  Icons.chevron_right,
                  color:
                      AppColors.textLight,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}