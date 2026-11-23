import 'package:equatable/equatable.dart';

class OgeGrammarTaskEntity extends Equatable {
  final String id;
  final String baseWord;
  final String sentenceBefore;
  final String sentenceAfter;
  final String correctAnswer;
  final List<String> acceptableAnswers;
  final String ruleCategory;
  final String ruleExplanation;
  final String cefrLevel;
  final bool isCompleted;

  const OgeGrammarTaskEntity({
    required this.id,
    required this.baseWord,
    required this.sentenceBefore,
    required this.sentenceAfter,
    required this.correctAnswer,
    required this.acceptableAnswers,
    required this.ruleCategory,
    required this.ruleExplanation,
    required this.cefrLevel,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        baseWord,
        sentenceBefore,
        sentenceAfter,
        correctAnswer,
        acceptableAnswers,
        ruleCategory,
        ruleExplanation,
        cefrLevel,
        isCompleted,
      ];
}

class OgeWordFormationTaskEntity extends Equatable {
  final String id;
  final String baseWord;
  final String sentenceBefore;
  final String sentenceAfter;
  final String correctAnswer;
  final List<String> acceptableAnswers;
  final String partOfSpeech;
  final String affix;
  final String explanation;
  final String cefrLevel;
  final bool isCompleted;

  const OgeWordFormationTaskEntity({
    required this.id,
    required this.baseWord,
    required this.sentenceBefore,
    required this.sentenceAfter,
    required this.correctAnswer,
    required this.acceptableAnswers,
    required this.partOfSpeech,
    required this.affix,
    required this.explanation,
    required this.cefrLevel,
    this.isCompleted = false,
  });

  @override
  List<Object?> get props => [
        id,
        baseWord,
        sentenceBefore,
        sentenceAfter,
        correctAnswer,
        acceptableAnswers,
        partOfSpeech,
        affix,
        explanation,
        cefrLevel,
        isCompleted,
      ];
}
