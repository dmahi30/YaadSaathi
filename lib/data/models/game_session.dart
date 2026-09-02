class GameSession {
  final int totalQuestions;
  final int correctAnswers;
  final DateTime completedAt;

  const GameSession({
    required this.totalQuestions,
    required this.correctAnswers,
    required this.completedAt,
  });

  int get scorePercent =>
      totalQuestions == 0 ? 0 : ((correctAnswers / totalQuestions) * 100).round();
}