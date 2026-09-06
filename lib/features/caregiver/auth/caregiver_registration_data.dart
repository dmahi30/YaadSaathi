import 'dart:io';
import '../../../core/localization/app_language.dart';

/// Plain data holder carrying the information entered during
/// caregiver registration (Page 4) forward through OTP verification
/// (Page 5), PIN creation (Page 6), and consent (Page 7).
///
/// This is a simple data class, not a new state-management system —
/// it travels via constructor parameters / navigation arguments only.
class CaregiverRegistrationData {
  final String fullName;
  final String phoneNumber;
  final String relationshipKey;
  final AppLanguage preferredLanguage;
  final File? profileImage;

  // Set on Page 6, carried into Page 7.
  final String? pin;

  const CaregiverRegistrationData({
    required this.fullName,
    required this.phoneNumber,
    required this.relationshipKey,
    required this.preferredLanguage,
    this.profileImage,
    this.pin,
  });

  CaregiverRegistrationData copyWith({String? pin}) {
    return CaregiverRegistrationData(
      fullName: fullName,
      phoneNumber: phoneNumber,
      relationshipKey: relationshipKey,
      preferredLanguage: preferredLanguage,
      profileImage: profileImage,
      pin: pin ?? this.pin,
    );
  }
}