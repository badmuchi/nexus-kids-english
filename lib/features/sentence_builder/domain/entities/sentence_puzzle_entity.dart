import 'package:equatable/equatable.dart';

class SentencePuzzleEntity extends Equatable {
  final String id;
  final int grade;
  final String grammarTopic;
  final String translation;
  final List<String> words;
  final String correctSentence;
  final String explanation;

  const SentencePuzzleEntity({
    required this.id,
    required this.grade,
    required this.grammarTopic,
    required this.translation,
    required this.words,
    required this.correctSentence,
    required this.explanation,
  });

  @override
  List<Object?> get props => [
        id,
        grade,
        grammarTopic,
        translation,
        words,
        correctSentence,
        explanation,
      ];
}
