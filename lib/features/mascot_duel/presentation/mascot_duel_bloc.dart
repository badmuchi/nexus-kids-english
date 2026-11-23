import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/repositories/mascot_duel_repository.dart';
import 'mascot_duel_event.dart';
import 'mascot_duel_state.dart';

class MascotDuelBloc extends Bloc<MascotDuelEvent, MascotDuelState> {
  final MascotDuelRepository _repository;

  MascotDuelBloc({required MascotDuelRepository repository})
      : _repository = repository,
        super(const MascotDuelInitial()) {
    on<StartDuelEvent>(_onStartDuel);
    on<AnswerDuelQuestionEvent>(_onAnswerQuestion);
    on<TickDuelTimerEvent>(_onTickTimer);
    on<SparkyAnswerEvent>(_onSparkyAnswer);
  }

  Future<void> _onStartDuel(
    StartDuelEvent event,
    Emitter<MascotDuelState> emit,
  ) async {
    emit(const MascotDuelLoading());
    final result = await _repository.getDuelQuestions();
    switch (result) {
      case Success(value: final questions):
        final shuffled = List.of(questions)..shuffle();
        emit(MascotDuelInProgress(
          questions: shuffled,
          currentQuestionIndex: 0,
          userScore: 0,
          sparkyScore: 0,
          secondsRemaining: 60,
        ));
      case Failure(error: final err):
        emit(MascotDuelErrorState(err.toString()));
    }
  }

  void _onAnswerQuestion(
    AnswerDuelQuestionEvent event,
    Emitter<MascotDuelState> emit,
  ) {
    final current = state;
    if (current is! MascotDuelInProgress || current.lastChosenIndex != null) return;

    final q = current.currentQuestion;
    final isCorrect = event.chosenIndex == q.correctIndex;
    final newScore = isCorrect ? current.userScore + 1 : current.userScore;

    emit(current.copyWith(
      userScore: newScore,
      lastChosenIndex: event.chosenIndex,
      lastIsCorrect: isCorrect,
    ));
  }

  void _onTickTimer(
    TickDuelTimerEvent event,
    Emitter<MascotDuelState> emit,
  ) {
    final current = state;
    if (current is! MascotDuelInProgress) return;

    if (current.secondsRemaining <= 1) {
      final userWins = current.userScore > current.sparkyScore;
      final isDraw = current.userScore == current.sparkyScore;
      final xp = userWins ? 100 : (isDraw ? 50 : 25);

      emit(MascotDuelFinished(
        userScore: current.userScore,
        sparkyScore: current.sparkyScore,
        isUserWinner: userWins,
        isDraw: isDraw,
        xpEarned: xp,
      ));
    } else {
      // If user had answered, advance to next question
      if (current.lastChosenIndex != null) {
        emit(current.copyWith(
          secondsRemaining: current.secondsRemaining - 1,
          currentQuestionIndex: current.currentQuestionIndex + 1,
          clearChoice: true,
        ));
      } else {
        emit(current.copyWith(
          secondsRemaining: current.secondsRemaining - 1,
        ));
      }
    }
  }

  void _onSparkyAnswer(
    SparkyAnswerEvent event,
    Emitter<MascotDuelState> emit,
  ) {
    final current = state;
    if (current is! MascotDuelInProgress) return;

    if (event.isCorrect) {
      emit(current.copyWith(sparkyScore: current.sparkyScore + 1));
    }
  }
}
