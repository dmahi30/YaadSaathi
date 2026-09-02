import 'package:flutter/material.dart';
import 'package:flutter_tts/flutter_tts.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/state/app_settings_controller.dart';
import '../../caregiver/pin_access/caregiver_pin_screen.dart';

class PatientSettingsScreen extends StatelessWidget {
  const PatientSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: ListenableBuilder(
          listenable: appSettings,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back, color: AppColors.primaryGreen),
                      ),
                      const Text(
                        'YaadSaathi Voice Mode',
                        style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
        'Welcome to YaadSaathi settings. '
        'You can change text size, display, and voice speed here.',
      );
    },
  ),
),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text('Settings', style: Theme.of(context).textTheme.headlineMedium),
                  const SizedBox(height: 20),

                  _SettingsRow(
                    icon: Icons.text_fields_rounded,
                    iconBg: const Color(0xFFD7EFC6),
                    iconColor: AppColors.primaryGreen,
                    label: 'Text Size',
                    value: appSettings.textSizeLabel,
                    onTap: () => _showPicker(
                      context,
                      title: 'Text Size',
                      options: const ['Small', 'Medium', 'Large', 'Extra Large'],
                      current: appSettings.textSizeLabel,
                      onSelected: appSettings.setTextSize,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.contrast_rounded,
                    iconBg: const Color(0xFFD6E8F7),
                    iconColor: const Color(0xFF2B6CB0),
                    label: 'Display',
                    value: appSettings.displayLabel,
                    onTap: () => _showPicker(
                      context,
                      title: 'Display',
                      options: const ['Normal', 'High Contrast'],
                      current: appSettings.displayLabel,
                      onSelected: appSettings.setDisplay,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.volume_up_rounded,
                    iconBg: const Color(0xFFE3D9F7),
                    iconColor: const Color(0xFF6B46C1),
                    label: 'Voice',
                    value: appSettings.voiceSpeedLabel,
                    onTap: () => _showPicker(
                      context,
                      title: 'Voice Speed',
                      options: const ['Slow', 'Normal Speed', 'Fast'],
                      current: appSettings.voiceSpeedLabel,
                      onSelected: appSettings.setVoiceSpeed,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.language_rounded,
                    iconBg: const Color(0xFFD7EFC6),
                    iconColor: AppColors.primaryGreen,
                    label: 'Language',
                    value: appSettings.languageLabel,
                    onTap: () => _showPicker(
                      context,
                      title: 'Language',
                      options: const [
                        'English (Automatic)',
                        'Hindi',
                        'Assamese',
                        'Bodo',
                        'Khasi',
                        'Mizo',
                        'Nagamese',
                        'Manipuri / Meitei',
                      ],
                      current: appSettings.languageLabel,
                      onSelected: appSettings.setLanguage,
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.lock_open_rounded,
                    iconBg: const Color(0xFFFCEBBF),
                    iconColor: const Color(0xFFB7791F),
                    label: 'Caregiver Access',
                    value: 'Front-Pin',
                    onTap: () {
                      // Opens the existing PIN-gated Caregiver Mode flow.
                      Navigator.of(context).push(
                        MaterialPageRoute(builder: (_) => const CaregiverPinScreen()),
                      ); // works once `session` is made optional below
                    },
                  ),
                  _SettingsRow(
                    icon: Icons.call_rounded,
                    iconBg: const Color(0xFFF7D9DC),
                    iconColor: const Color(0xFFC53030),
                    label: 'Call Caregiver',
                    value: 'Mohan',
                    onTap: () => _showCallDialog(context, 'Mohan'),
                  ),
                  _SettingsRow(
                    icon: Icons.help_outline_rounded,
                    iconBg: const Color(0xFFE3D9F7),
                    iconColor: const Color(0xFF6B46C1),
                    label: 'Privacy & Help',
                    value: '',
                    onTap: () => _showInfoDialog(
                      context,
                      title: 'Privacy & Help',
                      body: 'Your activity and health data is stored securely and only '
                          'shared with your registered caregiver. Contact your caregiver '
                          'if you need help using the app.',
                    ),
                  ),
                  _SettingsRow(
                    icon: Icons.info_outline_rounded,
                    iconBg: const Color(0xFFD6E8F7),
                    iconColor: const Color(0xFF2B6CB0),
                    label: 'About YaadSaathi',
                    value: '',
                    onTap: () => _showInfoDialog(
                      context,
                      title: 'About YaadSaathi',
                      body: 'YaadSaathi helps you stay connected to the people and '
                          'routines you love, with simple daily memory activities.',
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

  void _showPicker(
    BuildContext context, {
    required String title,
    required List<String> options,
    required String current,
    required void Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      isScrollControlled: true, // required so the sheet can grow and scroll
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (sheetContext) {
        return SafeArea(
          child: ConstrainedBox(
            // Caps sheet height so long lists (e.g. 8 languages) scroll
            // instead of overflowing past the bottom of the screen.
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(sheetContext).size.height * 0.7,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                Flexible(
                  child: ListView(
                    shrinkWrap: true,
                    children: options.map(
                      (option) => ListTile(
                        title: Text(option),
                        trailing: option == current
                            ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
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

  void _showCallDialog(BuildContext context, String name) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text('Call $name?'),
        content: const Text('This will start a phone call to your caregiver.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primaryGreen),
            onPressed: () {
              // Wire url_launcher's tel: scheme here once the package is added.
              Navigator.of(dialogContext).pop();
            },
            child: const Text('Call', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showInfoDialog(BuildContext context, {required String title, required String body}) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(title),
        content: Text(body),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

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
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                ),
                if (value.isNotEmpty)
                  Text(value, style: const TextStyle(color: AppColors.textMedium, fontSize: 14)),
                const SizedBox(width: 4),
                const Icon(Icons.chevron_right, color: AppColors.textLight),
              ],
            ),
          ),
        ),
      ),
    );
  }
}