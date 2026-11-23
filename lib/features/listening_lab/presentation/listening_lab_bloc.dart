import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/listening_lab_repository.dart';
import 'listening_lab_event.dart';
import 'listening_lab_state.dart';

class ListeningLabBloc extends Bloc<ListeningLabEvent, ListeningLabState> {
  final ListeningLabRepository _repository;

  ListeningLabBloc({required ListeningLabRepository repository})
      : _repository = repository,
        super(const ListeningLabInitial()) {
    on<LoadMinimalPairsEvent>(_onLoadPairs);
    on<SelectPairChoiceEvent>(_onSelectChoice);
    on<NextPairEvent>(_onNextPair);
  }

  Future<void> _onLoadPairs(LoadMinimalPairsEvent event, Emitter<ListeningLabState> emit) async {
    emit(const ListeningLabLoading());
    final result = await _repository.getAllPairs();
    switch (result) {
      case Success(value: final list):
        if (list.isEmpty) {
          emit(const ListeningLabErrorState('Пары звуков не найдены'));
          return;
        }
        final initialPair = list[0];
        final pickA = Random().nextBool();
        emit(ListeningLabActive(
          pairs: list,
          currentIndex: 0,
          targetWord: pickA ? initialPair.wordA : initialPair.wordB,
          score: 0,
        ));
      case Failure(error: final err):
        emit(ListeningLabErrorState(err.toString()));
    }
  }

  void _onSelectChoice(SelectPairChoiceEvent event, Emitter<ListeningLabState> emit) {
    final current = state;
    if (current is! ListeningLabActive || current.selectedChoice != null) return;

    final isCorrect = event.chosenWord == current.targetWord;
    emit(current.copyWith(
      selectedChoice: event.chosenWord,
      isCorrect: isCorrect,
      score: isCorrect ? current.score + 1 : current.score,
    ));
  }

  void _onNextPair(NextPairEvent event, Emitter<ListeningLabState> emit) {
    final current = state;
    if (current is! ListeningLabActive) return;

    final nextIndex = (current.currentIndex + 1) % current.pairs.length;
    final nextPair = current.pairs[nextIndex];
    final pickA = Random().nextBool();

    emit(ListeningLabActive(
      pairs: current.pairs,
      currentIndex: nextIndex,
      targetWord: pickA ? nextPair.wordA : nextPair.wordB,
      score: current.score,
    ));
  }
}
