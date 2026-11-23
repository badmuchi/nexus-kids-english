import 'package:equatable/equatable.dart';

sealed class OgeExamEvent extends Equatable {
  const OgeExamEvent();

  @override
  List<Object?> get props => [];
}

class StartFullExamEvent extends OgeExamEvent {
  const StartFullExamEvent();
}

class SelectListeningOptionEvent extends OgeExamEvent {
  final String questionId;
  final int selectedIndex;

  const SelectListeningOptionEvent({
    required this.questionId,
    required this.selectedIndex,
  });

  @override
  List<Object?> get props => [questionId, selectedIndex];
}

class SelectReadingHeadingEvent extends OgeExamEvent {
  final String paragraphLetter;
  final String headingId;

  const SelectReadingHeadingEvent({
    required this.paragraphLetter,
    required this.headingId,
  });

  @override
  List<Object?> get props => [paragraphLetter, headingId];
}

class SelectTrueFalseEvent extends OgeExamEvent {
  final String questionId;
  final String choice; // TRUE, FALSE, NOT_STATED

  const SelectTrueFalseEvent({
    required this.questionId,
    required this.choice,
  });

  @override
  List<Object?> get props => [questionId, choice];
}

class CompleteExamEvent extends OgeExamEvent {
  const CompleteExamEvent();
}
