import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/sentence_builder_repository.dart';
import 'sentence_builder_event.dart';
import 'sentence_builder_state.dart';

class SentenceBuilderBloc extends Bloc<SentenceBuilderEvent, SentenceBuilderState> {
  final SentenceBuilderRepository _repository;

  SentenceBuilderBloc({required SentenceBuilderRepository repository})
      : _repository = repository,
        super(const SentenceBuilderInitial()) {
    on<LoadSentencePuzzlesEvent>(_onLoadPuzzles);
    on<SelectWordEvent>(_onSelectWord);
    on<DeselectWordEvent>(_onDeselectWord);
    on<CheckSentenceEvent>(_onCheckSentence);
    on<NextPuzzleEvent>(_onNextPuzzle);
  }

  Future<void> _onLoadPuzzles(LoadSentencePuzzlesEvent event, Emitter<SentenceBuilderState> emit) async {
    emit(const SentenceBuilderLoading());
    final result = event.grade != null
        ? await _repository.getPuzzlesByGrade(event.grade!)
        : await _repository.getAllPuzzles();

    switch (result) {
      case Success(value: final list):
        if (list.isEmpty) {
          emit(const SentenceBuilderErrorState('Пазлы предложений не найдены'));
          return;
        }
        final initialPuzzle = list[0];
        final shuffled = List<String>.from(initialPuzzle.words)..shuffle(Random());
        emit(SentenceBuilderActive(
          puzzles: list,
          currentIndex: 0,
          availableWords: shuffled,
          selectedWords: const [],
        ));
      case Failure(error: final err):
        emit(SentenceBuilderErrorState(err.toString()));
    }
  }

  void _onSelectWord(SelectWordEvent event, Emitter<SentenceBuilderState> emit) {
    final current = state;
    if (current is! SentenceBuilderActive) return;

    final updatedAvailable = List<String>.from(current.availableWords)..remove(event.word);
    final updatedSelected = List<String>.from(current.selectedWords)..add(event.word);

    emit(current.copyWith(
      availableWords: updatedAvailable,
      selectedWords: updatedSelected,
      isCorrect: null,
      feedbackMessage: null,
    ));
  }

  void _onDeselectWord(DeselectWordEvent event, Emitter<SentenceBuilderState> emit) {
    final current = state;
    if (current is! SentenceBuilderActive) return;

    if (event.index < 0 || event.index >= current.selectedWords.length) return;
    final word = current.selectedWords[event.index];

    final updatedSelected = List<String>.from(current.selectedWords)..removeAt(event.index);
    final updatedAvailable = List<String>.from(current.availableWords)..add(word);

    emit(current.copyWith(
      availableWords: updatedAvailable,
      selectedWords: updatedSelected,
      isCorrect: null,
      feedbackMessage: null,
    ));
  }

  void _onCheckSentence(CheckSentenceEvent event, Emitter<SentenceBuilderState> emit) {
    final current = state;
    if (current is! SentenceBuilderActive) return;

    final assembled = current.selectedWords.join(' ');
    final expected = current.currentPuzzle.correctSentence;

    final isCorrect = assembled == expected;
    emit(current.copyWith(
      isCorrect: isCorrect,
      feedbackMessage: isCorrect
          ? 'Блестяще! Порядок слов идеален! ⭐'
          : 'Порядок слов не совсем верный. Попробуй переставить!',
    ));
  }

  void _onNextPuzzle(NextPuzzleEvent event, Emitter<SentenceBuilderState> emit) {
    final current = state;
    if (current is! SentenceBuilderActive) return;

    final nextIndex = (current.currentIndex + 1) % current.puzzles.length;
    final nextPuzzle = current.puzzles[nextIndex];
    final shuffled = List<String>.from(nextPuzzle.words)..shuffle(Random());

    emit(SentenceBuilderActive(
      puzzles: current.puzzles,
      currentIndex: nextIndex,
      availableWords: shuffled,
      selectedWords: const [],
    ));
  }
}
