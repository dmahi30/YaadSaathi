class GameSession {
  final int totalQuestions;
  final int correctAnswers;
  final DateTime timestamp;

  const GameSession({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.timestamp,
  });

  double get accuracy =>
      totalQuestions == 0 ? 0 : correctAnswers / totalQuestions;

  int get accuracyPercent => (accuracy * 100).round();
}