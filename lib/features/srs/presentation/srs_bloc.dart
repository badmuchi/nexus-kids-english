import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/srs_repository.dart';
import '../domain/services/english_answer_evaluator.dart';
import 'srs_event.dart';
import 'srs_state.dart';

class SrsBloc extends Bloc<SrsEvent, SrsState> {
  final SrsRepository _repository;
  final EnglishAnswerEvaluator _evaluator;

  SrsBloc({
    required SrsRepository repository,
    EnglishAnswerEvaluator evaluator = const EnglishAnswerEvaluator(),
  })  : _repository = repository,
        _evaluator = evaluator,
        super(const SrsInitial()) {
    on<LoadDueCardsEvent>(_onLoadDueCards);
    on<CheckAnswerEvent>(_onCheckAnswer);
    on<RateCurrentCardEvent>(_onRateCurrentCard);
  }

  Future<void> _onLoadDueCards(LoadDueCardsEvent event, Emitter<SrsState> emit) async {
    emit(const SrsLoading());
    final result = await _repository.getDueCards();
    switch (result) {
      case Success(value: final cards):
        if (cards.isEmpty) {
          // If no cards are strictly due, load all cards for practice
          final allResult = await _repository.getAllCards();
          if (allResult is Success && (allResult as Success).value.isNotEmpty) {
            emit(SrsActive(cards: (allResult as Success).value, currentIndex: 0));
          } else {
            emit(const SrsEmpty());
          }
        } else {
          emit(SrsActive(cards: cards, currentIndex: 0));
        }
      case Failure(error: final err):
        emit(SrsErrorState(err.toString()));
    }
  }

  void _onCheckAnswer(CheckAnswerEvent event, Emitter<SrsState> emit) {
    if (state is! SrsActive) return;
    final currentState = state as SrsActive;

    final eval = _evaluator.evaluate(
      typed: event.typedAnswer,
      expected: currentState.currentCard.frontEnglish,
    );

    emit(currentState.copyWith(
      isAnswerRevealed: true,
      lastEvaluation: eval,
    ));
  }

  Future<void> _onRateCurrentCard(RateCurrentCardEvent event, Emitter<SrsState> emit) async {
    if (state is! SrsActive) return;
    final currentState = state as SrsActive;

    await _repository.rateCard(cardId: event.cardId, rating: event.rating);

    if (currentState.isLastCard) {
      emit(SrsCompleted(currentState.cards.length));
    } else {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
        isAnswerRevealed: false,
        clearEvaluation: true,
      ));
    }
  }
}
