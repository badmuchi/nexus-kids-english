import 'package:equatable/equatable.dart';
import '../domain/entities/oge_exam_entity.dart';

sealed class OgeExamState extends Equatable {
  const OgeExamState();

  @override
  List<Object?> get props => [];
}

class OgeExamInitial extends OgeExamState {
  const OgeExamInitial();
}

class OgeExamLoading extends OgeExamState {
  const OgeExamLoading();
}

class OgeExamInProgress extends OgeExamState {
  final List<ListeningQuestionItem> listeningTasks1_4;
  final List<ListeningTableField> listeningTable6_11;
  final List<ReadingHeadingParagraph> readingParagraphs;
  final List<Map<String, String>> readingHeadings;
  final List<ReadingTrueFalseItem> readingTrueFalse;

  final Map<String, int> selectedListeningAnswers; // questionId -> optionIndex
  final Map<String, String> selectedHeadings; // paragraphLetter -> headingId
  final Map<String, String> selectedTrueFalse; // questionId -> TRUE/FALSE/NOT_STATED

  final int secondsRemaining;

  const OgeExamInProgress({
    required this.listeningTasks1_4,
    required this.listeningTable6_11,
    required this.readingParagraphs,
    required this.readingHeadings,
    required this.readingTrueFalse,
    this.selectedListeningAnswers = const {},
    this.selectedHeadings = const {},
    this.selectedTrueFalse = const {},
    this.secondsRemaining = 7200, // 120 minutes in seconds
  });

  OgeExamInProgress copyWith({
    Map<String, int>? selectedListeningAnswers,
    Map<String, String>? selectedHeadings,
    Map<String, String>? selectedTrueFalse,
    int? secondsRemaining,
  }) {
    return OgeExamInProgress(
      listeningTasks1_4: listeningTasks1_4,
      listeningTable6_11: listeningTable6_11,
      readingParagraphs: readingParagraphs,
      readingHeadings: readingHeadings,
      readingTrueFalse: readingTrueFalse,
      selectedListeningAnswers: selectedListeningAnswers ?? this.selectedListeningAnswers,
      selectedHeadings: selectedHeadings ?? this.selectedHeadings,
      selectedTrueFalse: selectedTrueFalse ?? this.selectedTrueFalse,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
    );
  }

  @override
  List<Object?> get props => [
        listeningTasks1_4,
        listeningTable6_11,
        readingParagraphs,
        readingHeadings,
        readingTrueFalse,
        selectedListeningAnswers,
        selectedHeadings,
        selectedTrueFalse,
        secondsRemaining,
      ];
}

class OgeExamFinished extends OgeExamState {
  final ExamResultSummary summary;

  const OgeExamFinished(this.summary);

  @override
  List<Object?> get props => [summary];
}

class OgeExamErrorState extends OgeExamState {
  final String message;

  const OgeExamErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
