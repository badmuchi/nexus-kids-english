import 'package:equatable/equatable.dart';

sealed class MascotDuelEvent extends Equatable {
  const MascotDuelEvent();

  @override
  List<Object?> get props => [];
}

final class StartDuelEvent extends MascotDuelEvent {
  const StartDuelEvent();
}

final class AnswerDuelQuestionEvent extends MascotDuelEvent {
  final int chosenIndex;
  const AnswerDuelQuestionEvent(this.chosenIndex);

  @override
  List<Object?> get props => [chosenIndex];
}

final class TickDuelTimerEvent extends MascotDuelEvent {
  const TickDuelTimerEvent();
}

final class SparkyAnswerEvent extends MascotDuelEvent {
  final bool isCorrect;
  const SparkyAnswerEvent(this.isCorrect);

  @override
  List<Object?> get props => [isCorrect];
}
