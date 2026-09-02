import 'dart:math';
import '../../../../data/fake_data/family_members.dart';
import '../../../../data/models/family_member.dart';

class FaceNameQuestion {
  final FamilyMember correctMember;
  final List<FamilyMember> options;

  const FaceNameQuestion({required this.correctMember, required this.options});
}

class FaceNameData {
  FaceNameData._();

  static final Random _random = Random();

  static List<FaceNameQuestion> generateQuestions({
    int count = 5,
    int optionCount = 3,
  }) {
    final all = List<FamilyMember>.from(FakeFamilyData.members);
    final questions = <FaceNameQuestion>[];

    for (int i = 0; i < count; i++) {
      final correct = all[_random.nextInt(all.length)];
      final distractors = all.where((m) => m.id != correct.id).toList()
        ..shuffle(_random);

      final chosenDistractors = distractors
          .take((optionCount - 1).clamp(0, distractors.length))
          .toList();

      final options = [correct, ...chosenDistractors]..shuffle(_random);

      questions.add(FaceNameQuestion(correctMember: correct, options: options));
    }

    return questions;
  }
}