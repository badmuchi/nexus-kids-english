import 'package:equatable/equatable.dart';

sealed class SrsEvent extends Equatable {
  const SrsEvent();

  @override
  List<Object?> get props => [];
}

class LoadDueCardsEvent extends SrsEvent {
  const LoadDueCardsEvent();
}

class CheckAnswerEvent extends SrsEvent {
  final String cardId;
  final String typedAnswer;

  const CheckAnswerEvent({
    required this.cardId,
    required this.typedAnswer,
  });

  @override
  List<Object?> get props => [cardId, typedAnswer];
}

class RateCurrentCardEvent extends SrsEvent {
  final String cardId;
  final int rating;

  const RateCurrentCardEvent({
    required this.cardId,
    required this.rating,
  });

  @override
  List<Object?> get props => [cardId, rating];
}
