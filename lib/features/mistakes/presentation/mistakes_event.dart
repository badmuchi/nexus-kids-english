import 'package:equatable/equatable.dart';

abstract class MistakesEvent extends Equatable {
  const MistakesEvent();

  @override
  List<Object?> get props => [];
}

class LoadMistakes extends MistakesEvent {
  const LoadMistakes();
}

class RecordMistakeAttempt extends MistakesEvent {
  final String id;
  final bool isCorrect;

  const RecordMistakeAttempt({required this.id, required this.isCorrect});

  @override
  List<Object?> get props => [id, isCorrect];
}

class AddManualMistake extends MistakesEvent {
  final String id;
  final String taskType;
  final String prompt;
  final String wrongAnswer;
  final String correctAnswer;
  final String explanation;

  const AddManualMistake({
    required this.id,
    required this.taskType,
    required this.prompt,
    required this.wrongAnswer,
    required this.correctAnswer,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
        id,
        taskType,
        prompt,
        wrongAnswer,
        correctAnswer,
        explanation,
      ];
}
