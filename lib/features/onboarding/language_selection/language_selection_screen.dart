import '../../patient/profile/patient_profile_screen.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/speaker_button.dart';

class AppLanguage {
  final String code;
  final String nativeName;
  final String englishLabel;
  final Color color;

  const AppLanguage({
    required this.code,
    required this.nativeName,
    required this.englishLabel,
    required this.color,
  });
}

class LanguageSelectionScreen extends StatefulWidget {
  const LanguageSelectionScreen({super.key});

  @override
  State<LanguageSelectionScreen> createState() =>
      _LanguageSelectionScreenState();
}

class _LanguageSelectionScreenState extends State<LanguageSelectionScreen> {
  static const List<AppLanguage> _languages = [
    AppLanguage(code: 'EN', nativeName: 'English', englishLabel: 'English', color: Color(0xFF4A90D9)),
    AppLanguage(code: 'हि', nativeName: 'हिंदी', englishLabel: 'Hindi', color: Color(0xFFE9A63C)),
    AppLanguage(code: 'मरा', nativeName: 'मराठी', englishLabel: 'Marathi', color: Color(0xFF9B6FD1)),
    AppLanguage(code: 'বাং', nativeName: 'বাংলা', englishLabel: 'Bengali', color: Color(0xFF3FAFA3)),
    AppLanguage(code: 'অস', nativeName: 'অসমীয়া', englishLabel: 'Assamese', color: AppColors.primaryGreen),
  ];

  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  const Icon(Icons.language, color: AppColors.primaryGreen),
                  const Spacer(),
                  const SpeakerButton(text: 'Choose your language.', size: 44),
                ],
              ),
              const SizedBox(height: 8),
              Text('Choose Your Language',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 4),
              Text('Tap to select', style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: _languages.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final lang = _languages[index];
                    final selected = index == _selectedIndex;
                    return AppCard(
                      color: selected
                          ? AppColors.primaryGreenLight
                          : AppColors.surfaceCard,
                      onTap: () => setState(() => _selectedIndex = index),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 22,
                            backgroundColor: lang.color,
                            child: Text(
                              lang.code,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(lang.nativeName,
                                    style: Theme.of(context).textTheme.titleLarge),
                                if (lang.nativeName != lang.englishLabel)
                                  Text(
                                    lang.englishLabel,
                                    style: const TextStyle(
                                        color: AppColors.textMedium, fontSize: 14),
                                  ),
                              ],
                            ),
                          ),
                          Icon(
                            selected ? Icons.check_circle : Icons.chevron_right,
                            color: selected
                                ? AppColors.primaryGreen
                                : AppColors.textLight,
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 12),
              AppButton(
                label: 'Confirm Language',
                onPressed: () {
                 Navigator.of(context).pushAndRemoveUntil(
                 MaterialPageRoute(builder: (_) => const PatientProfileScreen()),
                 (route) => false,
                 );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}