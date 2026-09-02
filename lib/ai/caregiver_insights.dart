class CaregiverInsights {
  CaregiverInsights._();

  static String generate({required int scorePercent, required String patientName}) {
    if (scorePercent > 80) {
      return '$patientName performed well in today\'s memory activity. '
          'Difficulty can be increased slightly for the next activity.';
    } else if (scorePercent >= 50) {
      return '$patientName completed today\'s activity steadily. '
          'Keep the difficulty the same for the next session.';
    } else {
      return '$patientName found today\'s activity a bit challenging. '
          'Consider an easier activity next time.';
    }
  }
}