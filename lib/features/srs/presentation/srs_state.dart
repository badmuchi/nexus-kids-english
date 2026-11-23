import 'package:equatable/equatable.dart';
import '../domain/entities/srs_card_entity.dart';
import '../domain/services/english_answer_evaluator.dart';

sealed class SrsState extends Equatable {
  const SrsState();

  @override
  List<Object?> get props => [];
}

class SrsInitial extends SrsState {
  const SrsInitial();
}

class SrsLoading extends SrsState {
  const SrsLoading();
}

class SrsEmpty extends SrsState {
  const SrsEmpty();
}

class SrsActive extends SrsState {
  final List<SrsCardEntity> cards;
  final int currentIndex;
  final bool isAnswerRevealed;
  final EvaluationResult? lastEvaluation;

  const SrsActive({
    required this.cards,
    required this.currentIndex,
    this.isAnswerRevealed = false,
    this.lastEvaluation,
  });

  SrsCardEntity get currentCard => cards[currentIndex];
  bool get isLastCard => currentIndex >= cards.length - 1;

  SrsActive copyWith({
    List<SrsCardEntity>? cards,
    int? currentIndex,
    bool? isAnswerRevealed,
    EvaluationResult? lastEvaluation,
    bool clearEvaluation = false,
  }) {
    return SrsActive(
      cards: cards ?? this.cards,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerRevealed: isAnswerRevealed ?? this.isAnswerRevealed,
      lastEvaluation: clearEvaluation ? null : (lastEvaluation ?? this.lastEvaluation),
    );
  }

  @override
  List<Object?> get props => [cards, currentIndex, isAnswerRevealed, lastEvaluation];
}

class SrsCompleted extends SrsState {
  final int totalReviewed;

  const SrsCompleted(this.totalReviewed);

  @override
  List<Object?> get props => [totalReviewed];
}

class SrsErrorState extends SrsState {
  final String message;

  const SrsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
