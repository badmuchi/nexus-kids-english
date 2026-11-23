import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../../srs/domain/services/english_answer_evaluator.dart';
import '../domain/repositories/oge_repository.dart';
import 'oge_event.dart';
import 'oge_state.dart';

class OgeBloc extends Bloc<OgeEvent, OgeState> {
  final OgeRepository _repository;
  final EnglishAnswerEvaluator _evaluator;

  OgeBloc({
    required OgeRepository repository,
    EnglishAnswerEvaluator evaluator = const EnglishAnswerEvaluator(),
  })  : _repository = repository,
        _evaluator = evaluator,
        super(const OgeInitial()) {
    on<LoadOgeGrammarTasksEvent>(_onLoadGrammarTasks);
    on<SubmitGrammarAnswerEvent>(_onSubmitGrammarAnswer);
    on<NextGrammarTaskEvent>(_onNextGrammarTask);
    on<LoadOgeWordFormationTasksEvent>(_onLoadWordFormationTasks);
    on<SubmitWordFormationAnswerEvent>(_onSubmitWordFormationAnswer);
    on<NextWordFormationTaskEvent>(_onNextWordFormationTask);
  }

  Future<void> _onLoadGrammarTasks(LoadOgeGrammarTasksEvent event, Emitter<OgeState> emit) async {
    emit(const OgeLoading());
    final result = await _repository.getGrammarTasks();
    switch (result) {
      case Success(value: final tasks):
        if (tasks.isEmpty) {
          emit(const OgeErrorState('Задания по грамматике не найдены'));
        } else {
          emit(OgeGrammarActive(tasks: tasks, currentIndex: 0));
        }
      case Failure(error: final err):
        emit(OgeErrorState(err.toString()));
    }
  }

  Future<void> _onSubmitGrammarAnswer(SubmitGrammarAnswerEvent event, Emitter<OgeState> emit) async {
    if (state is! OgeGrammarActive) return;
    final currentState = state as OgeGrammarActive;
    final task = currentState.currentTask;

    final normTyped = _evaluator.normalize(event.typedAnswer);
    bool matched = false;

    for (final acceptable in task.acceptableAnswers) {
      final normAcceptable = _evaluator.normalize(acceptable);
      if (normTyped == normAcceptable) {
        matched = true;
        break;
      }
    }

    if (matched) {
      await _repository.markGrammarTaskCompleted(task.id);
    }

    emit(currentState.copyWith(
      isAnswerChecked: true,
      isCorrect: matched,
      feedback: matched ? 'Верно! Отличная трансформация.' : 'Неверно. Правильный ответ: ${task.correctAnswer}',
    ));
  }

  void _onNextGrammarTask(NextGrammarTaskEvent event, Emitter<OgeState> emit) {
    if (state is! OgeGrammarActive) return;
    final currentState = state as OgeGrammarActive;

    if (currentState.isLastTask) {
      emit(OgeCompleted(title: 'Грамматика ОГЭ (20-28)', totalCount: currentState.tasks.length));
    } else {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
        isAnswerChecked: false,
        isCorrect: false,
        clearFeedback: true,
      ));
    }
  }

  Future<void> _onLoadWordFormationTasks(LoadOgeWordFormationTasksEvent event, Emitter<OgeState> emit) async {
    emit(const OgeLoading());
    final result = await _repository.getWordFormationTasks();
    switch (result) {
      case Success(value: final tasks):
        if (tasks.isEmpty) {
          emit(const OgeErrorState('Задания по словообразованию не найдены'));
        } else {
          emit(OgeWordFormationActive(tasks: tasks, currentIndex: 0));
        }
      case Failure(error: final err):
        emit(OgeErrorState(err.toString()));
    }
  }

  Future<void> _onSubmitWordFormationAnswer(SubmitWordFormationAnswerEvent event, Emitter<OgeState> emit) async {
    if (state is! OgeWordFormationActive) return;
    final currentState = state as OgeWordFormationActive;
    final task = currentState.currentTask;

    final normTyped = _evaluator.normalize(event.typedAnswer);
    bool matched = false;

    for (final acceptable in task.acceptableAnswers) {
      final normAcceptable = _evaluator.normalize(acceptable);
      if (normTyped == normAcceptable) {
        matched = true;
        break;
      }
    }

    if (matched) {
      await _repository.markWordFormationTaskCompleted(task.id);
    }

    emit(currentState.copyWith(
      isAnswerChecked: true,
      isCorrect: matched,
      feedback: matched ? 'Точно! Суффикс/приставка подобраны верно.' : 'Неверно. Правильный ответ: ${task.correctAnswer}',
    ));
  }

  void _onNextWordFormationTask(NextWordFormationTaskEvent event, Emitter<OgeState> emit) {
    if (state is! OgeWordFormationActive) return;
    final currentState = state as OgeWordFormationActive;

    if (currentState.isLastTask) {
      emit(OgeCompleted(title: 'Словообразование ОГЭ (29-34)', totalCount: currentState.tasks.length));
    } else {
      emit(currentState.copyWith(
        currentIndex: currentState.currentIndex + 1,
        isAnswerChecked: false,
        isCorrect: false,
        clearFeedback: true,
      ));
    }
  }
}
