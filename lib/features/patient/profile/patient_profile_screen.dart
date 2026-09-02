import '../../../core/localization/app_language.dart';
import '../../../core/localization/app_language_controller.dart';
import '../../../core/localization/app_localizations.dart';
import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_card.dart';
import '../../../core/widgets/speaker_button.dart';
import '../home/patient_home_screen.dart';

class PatientProfileScreen extends StatefulWidget {
  const PatientProfileScreen({super.key});

  @override
  State<PatientProfileScreen> createState() => _PatientProfileScreenState();
}

class _PatientProfileScreenState extends State<PatientProfileScreen> {
   

  static const List<String> _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  

  late final TextEditingController _nameController;
  DateTime _dob = DateTime(1952, 8, 15);
 late AppLanguage _language;

  @override
void initState() {
  super.initState();
  _nameController = TextEditingController(text: 'Leima Devi');
  _language = AppLanguageController.instance.language;
}

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime d) => '${d.day} ${_monthAbbr[d.month - 1]} ${d.year}';

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _dob,
      firstDate: DateTime(1920),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() => _dob = picked);
    }
  }

   
                
 void _pickLanguage() {
  showModalBottomSheet(
    context: context,
    backgroundColor: AppColors.background,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: AppLanguage.values.map((lang) {
              final selected = lang == _language;

              return ListTile(
                title: Text(
                  lang.nativeName,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight:
                        selected ? FontWeight.bold : FontWeight.normal,
                    color: selected
                        ? AppColors.primaryGreen
                        : AppColors.textDark,
                  ),
                ),
                trailing: selected
                    ? const Icon(
                        Icons.check_circle,
                        color: AppColors.primaryGreen,
                      )
                    : null,
                onTap: () {
                  setState(() => _language = lang);
                  AppLanguageController.instance.setLanguage(lang);
                  Navigator.of(context).pop();
                },
              );
            }).toList(),
          ),
        ),
      );
    },
  );
}

  void _onPhotoTap() {
    final l10n = AppLocalizations.of(_language);

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(l10n.photoUploadComingSoon)
     ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(_language);
final speechText =
    '${l10n.setupProfileTitle}. ${l10n.setupProfileDescription}';
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: AppColors.textDark),
                  ),
                  const Spacer(),
                  SpeakerButton(text: speechText,size: 44,),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                 l10n.setupProfileTitle,
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
               l10n.setupProfileDescription,
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
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
                label:  l10n.continueText,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const PatientHomeScreen()),
                    (route) => false,
                  );
                },
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
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
              color: AppColors.primaryGreenLight,
              border: Border.all(color: AppColors.primaryGreen, width: 2),
            ),
            child: const Center(
              child: Icon(Icons.person_rounded, size: 76, color: AppColors.primaryGreen),
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
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primaryGreen,
                  border: Border.all(color: AppColors.background, width: 3),
                ),
                child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameField(AppLocalizations l10n) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  l10n.name,
  style: const TextStyle(
    color: AppColors.textMedium,
    fontSize: 14,
  ),
),
          const SizedBox(height: 6),
          TextField(
            controller: _nameController,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateField(AppLocalizations l10n) {
    return AppCard(
      onTap: _pickDate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  l10n.dateOfBirth,
  style: const TextStyle(
    color: AppColors.textMedium,
    fontSize: 14,
  ),
),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  _formatDate(_dob),
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(Icons.calendar_today_rounded, color: AppColors.primaryGreen),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLanguageField(AppLocalizations l10n) {
    return AppCard(
      onTap: _pickLanguage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
         Text(
  l10n.preferredLanguage,
  style: const TextStyle(
    color: AppColors.textMedium,
    fontSize: 14,
  ),
),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  _language.nativeName,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textDark,
                  ),
                ),
              ),
              const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primaryGreen),
            ],
          ),
        ],
      ),
    );
  }
}