import 'package:equatable/equatable.dart';
import '../domain/entities/sentence_puzzle_entity.dart';

sealed class SentenceBuilderState extends Equatable {
  const SentenceBuilderState();

  @override
  List<Object?> get props => [];
}

final class SentenceBuilderInitial extends SentenceBuilderState {
  const SentenceBuilderInitial();
}

final class SentenceBuilderLoading extends SentenceBuilderState {
  const SentenceBuilderLoading();
}

final class SentenceBuilderActive extends SentenceBuilderState {
  final List<SentencePuzzleEntity> puzzles;
  final int currentIndex;
  final List<String> availableWords;
  final List<String> selectedWords;
  final bool? isCorrect;
  final String? feedbackMessage;

  const SentenceBuilderActive({
    required this.puzzles,
    required this.currentIndex,
    required this.availableWords,
    required this.selectedWords,
    this.isCorrect,
    this.feedbackMessage,
  });

  SentencePuzzleEntity get currentPuzzle => puzzles[currentIndex];

  SentenceBuilderActive copyWith({
    List<SentencePuzzleEntity>? puzzles,
    int? currentIndex,
    List<String>? availableWords,
    List<String>? selectedWords,
    bool? isCorrect,
    String? feedbackMessage,
  }) {
    return SentenceBuilderActive(
      puzzles: puzzles ?? this.puzzles,
      currentIndex: currentIndex ?? this.currentIndex,
      availableWords: availableWords ?? this.availableWords,
      selectedWords: selectedWords ?? this.selectedWords,
      isCorrect: isCorrect,
      feedbackMessage: feedbackMessage,
    );
  }

  @override
  List<Object?> get props => [
        puzzles,
        currentIndex,
        availableWords,
        selectedWords,
        isCorrect,
        feedbackMessage,
      ];
}

final class SentenceBuilderErrorState extends SentenceBuilderState {
  final String message;
  const SentenceBuilderErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
