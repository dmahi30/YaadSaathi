enum DifficultyLevel { easy, hard }

class DifficultyAdapter {
  DifficultyAdapter._();

  /// Performance-based adaptive difficulty engine.
  /// Rule-based only — NOT a trained ML model.
  static DifficultyLevel decide(double accuracyPercent) {
    if (accuracyPercent > 80) return DifficultyLevel.hard;
    return DifficultyLevel.easy;
  }

  static int optionCountFor(DifficultyLevel level) {
    return level == DifficultyLevel.hard ? 4 : 3;
  }
}