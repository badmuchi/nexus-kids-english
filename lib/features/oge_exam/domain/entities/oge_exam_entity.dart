import 'package:equatable/equatable.dart';

class ListeningQuestionItem extends Equatable {
  final String id;
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ListeningQuestionItem({
    required this.id,
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [id, question, options, correctIndex, explanation];
}

class ListeningTableField extends Equatable {
  final String id;
  final String field;
  final String correct;
  final List<String> acceptable;

  const ListeningTableField({
    required this.id,
    required this.field,
    required this.correct,
    required this.acceptable,
  });

  @override
  List<Object?> get props => [id, field, correct, acceptable];
}

class ReadingHeadingParagraph extends Equatable {
  final String letter;
  final String text;
  final String correctHeadingId;

  const ReadingHeadingParagraph({
    required this.letter,
    required this.text,
    required this.correctHeadingId,
  });

  @override
  List<Object?> get props => [letter, text, correctHeadingId];
}

class ReadingTrueFalseItem extends Equatable {
  final String id;
  final String statement;
  final String correct; // TRUE, FALSE, NOT_STATED
  final String proofSentence;
  final String explanation;

  const ReadingTrueFalseItem({
    required this.id,
    required this.statement,
    required this.correct,
    required this.proofSentence,
    required this.explanation,
  });

  @override
  List<Object?> get props => [id, statement, correct, proofSentence, explanation];
}

class ExamResultSummary extends Equatable {
  final int listeningScore; // max 15
  final int readingScore; // max 13
  final int grammarScore; // max 15
  final int emailScore; // max 10
  final int speakingScore; // max 15
  final int totalScore; // max 68
  final int gradeMark; // 2, 3, 4, 5
  final int durationSeconds;

  const ExamResultSummary({
    required this.listeningScore,
    required this.readingScore,
    required this.grammarScore,
    required this.emailScore,
    required this.speakingScore,
    required this.totalScore,
    required this.gradeMark,
    required this.durationSeconds,
  });

  static int calculateGrade(int total) {
    if (total >= 59) return 5;
    if (total >= 46) return 4;
    if (total >= 29) return 3;
    return 2;
  }

  @override
  List<Object?> get props => [
        listeningScore,
        readingScore,
        grammarScore,
        emailScore,
        speakingScore,
        totalScore,
        gradeMark,
        durationSeconds,
      ];
}
