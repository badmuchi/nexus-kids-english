import 'package:equatable/equatable.dart';

sealed class SentenceBuilderEvent extends Equatable {
  const SentenceBuilderEvent();

  @override
  List<Object?> get props => [];
}

final class LoadSentencePuzzlesEvent extends SentenceBuilderEvent {
  final int? grade;
  const LoadSentencePuzzlesEvent({this.grade});

  @override
  List<Object?> get props => [grade];
}

final class SelectWordEvent extends SentenceBuilderEvent {
  final String word;
  const SelectWordEvent(this.word);

  @override
  List<Object?> get props => [word];
}

final class DeselectWordEvent extends SentenceBuilderEvent {
  final int index;
  const DeselectWordEvent(this.index);

  @override
  List<Object?> get props => [index];
}

final class CheckSentenceEvent extends SentenceBuilderEvent {
  const CheckSentenceEvent();
}

final class NextPuzzleEvent extends SentenceBuilderEvent {
  const NextPuzzleEvent();
}
