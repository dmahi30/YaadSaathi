import 'package:flutter/foundation.dart';
import '../../../../ai/difficulty_adapter.dart';
import '../../../../data/models/family_member.dart';
import 'face_name_data.dart';

class FaceNameController extends ChangeNotifier {
  static const int totalQuestions = 5;

  List<FaceNameQuestion> _questions = [];
  int _currentIndex = 0;
  int _correctCount = 0;
  DifficultyLevel _difficulty = DifficultyLevel.easy;
  String? _selectedOptionId;

  FaceNameController() {
    _questions = FaceNameData.generateQuestions(
      count: totalQuestions,
      optionCount: DifficultyAdapter.optionCountFor(_difficulty),
    );
  }

  FaceNameQuestion get currentQuestion => _questions[_currentIndex];
  int get currentIndex => _currentIndex;
  int get correctCount => _correctCount;
  int get totalCount => totalQuestions;
  String? get selectedOptionId => _selectedOptionId;
  bool get isLastQuestion => _currentIndex == totalQuestions - 1;
  double get accuracySoFar =>
      _currentIndex == 0 ? 0 : (_correctCount / _currentIndex) * 100;

  bool submitAnswer(FamilyMember tapped) {
    _selectedOptionId = tapped.id;
    final correct = tapped.id == currentQuestion.correctMember.id;
    if (correct) _correctCount++;
    notifyListeners();
    return correct;
  }

  void resetSelection() {
    _selectedOptionId = null;
    notifyListeners();
  }

  /// Returns false when there are no more questions (game finished).
  bool nextQuestion() {
    if (isLastQuestion) return false;

    _difficulty = DifficultyAdapter.decide(accuracySoFar);
    final remaining = totalQuestions - (_currentIndex + 1);
    final upcoming = FaceNameData.generateQuestions(
      count: remaining,
      optionCount: DifficultyAdapter.optionCountFor(_difficulty),
    );

    _questions = [..._questions.sublist(0, _currentIndex + 1), ...upcoming];
    _currentIndex++;
    resetSelection();
    return true;
  }
}