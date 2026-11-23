import 'package:equatable/equatable.dart';

class SrsCardEntity extends Equatable {
  final String id;
  final String frontEnglish;
  final String backRussian;
  final String? transcriptionIpa;
  final String level;
  final String category;
  final String? exampleSentence;
  final String? exampleTranslation;
  final String fsrsState;
  final double stability;
  final double difficulty;
  final int reps;
  final int lapses;
  final DateTime dueAt;
  final DateTime? lastReviewedAt;

  const SrsCardEntity({
    required this.id,
    required this.frontEnglish,
    required this.backRussian,
    this.transcriptionIpa,
    required this.level,
    required this.category,
    this.exampleSentence,
    this.exampleTranslation,
    this.fsrsState = 'newCard',
    this.stability = 0.0,
    this.difficulty = 0.0,
    this.reps = 0,
    this.lapses = 0,
    required this.dueAt,
    this.lastReviewedAt,
  });

  SrsCardEntity copyWith({
    String? fsrsState,
    double? stability,
    double? difficulty,
    int? reps,
    int? lapses,
    DateTime? dueAt,
    DateTime? lastReviewedAt,
  }) {
    return SrsCardEntity(
      id: id,
      frontEnglish: frontEnglish,
      backRussian: backRussian,
      transcriptionIpa: transcriptionIpa,
      level: level,
      category: category,
      exampleSentence: exampleSentence,
      exampleTranslation: exampleTranslation,
      fsrsState: fsrsState ?? this.fsrsState,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      dueAt: dueAt ?? this.dueAt,
      lastReviewedAt: lastReviewedAt ?? this.lastReviewedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        frontEnglish,
        backRussian,
        transcriptionIpa,
        level,
        category,
        exampleSentence,
        exampleTranslation,
        fsrsState,
        stability,
        difficulty,
        reps,
        lapses,
        dueAt,
        lastReviewedAt,
      ];
}
