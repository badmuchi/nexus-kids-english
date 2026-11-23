import 'package:equatable/equatable.dart';

class GlossaryItem extends Equatable {
  final String word;
  final String ipa;
  final String meaning;

  const GlossaryItem({
    required this.word,
    required this.ipa,
    required this.meaning,
  });

  @override
  List<Object?> get props => [word, ipa, meaning];
}

class ComprehensionQuestion extends Equatable {
  final String question;
  final List<String> options;
  final int correctIndex;
  final String explanation;

  const ComprehensionQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  @override
  List<Object?> get props => [question, options, correctIndex, explanation];
}

class ReadingStoryEntity extends Equatable {
  final String id;
  final String title;
  final int grade;
  final String theme;
  final String coverEmoji;
  final String summary;
  final List<String> paragraphs;
  final List<GlossaryItem> glossary;
  final List<ComprehensionQuestion> questions;
  final bool isCompleted;
  final int? quizScore;

  const ReadingStoryEntity({
    required this.id,
    required this.title,
    required this.grade,
    required this.theme,
    required this.coverEmoji,
    required this.summary,
    required this.paragraphs,
    required this.glossary,
    required this.questions,
    this.isCompleted = false,
    this.quizScore,
  });

  ReadingStoryEntity copyWith({
    String? id,
    String? title,
    int? grade,
    String? theme,
    String? coverEmoji,
    String? summary,
    List<String>? paragraphs,
    List<GlossaryItem>? glossary,
    List<ComprehensionQuestion>? questions,
    bool? isCompleted,
    int? quizScore,
  }) {
    return ReadingStoryEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      grade: grade ?? this.grade,
      theme: theme ?? this.theme,
      coverEmoji: coverEmoji ?? this.coverEmoji,
      summary: summary ?? this.summary,
      paragraphs: paragraphs ?? this.paragraphs,
      glossary: glossary ?? this.glossary,
      questions: questions ?? this.questions,
      isCompleted: isCompleted ?? this.isCompleted,
      quizScore: quizScore ?? this.quizScore,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        grade,
        theme,
        coverEmoji,
        summary,
        paragraphs,
        glossary,
        questions,
        isCompleted,
        quizScore,
      ];
}
