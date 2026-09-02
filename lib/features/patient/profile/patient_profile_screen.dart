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
  static const String _speech =
      "Let's set up Leima's profile. This helps make the app personal and easy.";

  static const List<String> _monthAbbr = [
    'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
    'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec',
  ];

  static const List<String> _languageOptions = [
    'English',
    'हिंदी (Hindi)',
    'मराठी (Marathi)',
    'বাংলা (Bengali)',
    'অসমীয়া (Assamese)',
  ];

  late final TextEditingController _nameController;
  DateTime _dob = DateTime(1952, 8, 15);
  String _language = 'অসমীয়া (Assamese)';

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: 'Leima Devi');
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
              children: _languageOptions.map((lang) {
                final selected = lang == _language;
                return ListTile(
                  title: Text(
                    lang,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: selected ? FontWeight.bold : FontWeight.normal,
                      color: selected ? AppColors.primaryGreen : AppColors.textDark,
                    ),
                  ),
                  trailing: selected
                      ? const Icon(Icons.check_circle, color: AppColors.primaryGreen)
                      : null,
                  onTap: () {
                    setState(() => _language = lang);
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
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Photo upload coming soon')),
    );
  }

  @override
  Widget build(BuildContext context) {
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
                  const SpeakerButton(text: _speech, size: 44),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                "Let's set up\nLeima's profile",
                style: Theme.of(context).textTheme.headlineMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                'This helps make the app\npersonal and easy.',
                style: Theme.of(context).textTheme.bodyLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 28),
              _buildAvatar(),
              const SizedBox(height: 28),
              _buildNameField(),
              const SizedBox(height: 16),
              _buildDateField(),
              const SizedBox(height: 16),
              _buildLanguageField(),
              const SizedBox(height: 28),
              AppButton(
                label: 'Continue',
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

  Widget _buildNameField() {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Name', style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
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

  Widget _buildDateField() {
    return AppCard(
      onTap: _pickDate,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Date of Birth',
              style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
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

  Widget _buildLanguageField() {
    return AppCard(
      onTap: _pickLanguage,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Preferred Language',
              style: TextStyle(color: AppColors.textMedium, fontSize: 14)),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: Text(
                  _language,
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