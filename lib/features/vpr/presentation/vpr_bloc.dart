import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../../srs/domain/services/english_answer_evaluator.dart';
import '../domain/repositories/vpr_repository.dart';
import 'vpr_event.dart';
import 'vpr_state.dart';

class VprBloc extends Bloc<VprEvent, VprState> {
  final VprRepository _repository;
  final EnglishAnswerEvaluator _evaluator;

  VprBloc({
    required VprRepository repository,
    EnglishAnswerEvaluator evaluator = const EnglishAnswerEvaluator(),
  })  : _repository = repository,
        _evaluator = evaluator,
        super(const VprInitial()) {
    on<LoadVprTasksEvent>(_onLoadTasks);
    on<CheckVprAnswerEvent>(_onCheckAnswer);
  }

  Future<void> _onLoadTasks(LoadVprTasksEvent event, Emitter<VprState> emit) async {
    emit(const VprLoading());
    final result = await _repository.getTasksByGrade(event.grade);
    switch (result) {
      case Success(value: final list):
        emit(VprLoaded(grade: event.grade, tasks: list));
      case Failure(error: final err):
        emit(VprErrorState(err.toString()));
    }
  }

  Future<void> _onCheckAnswer(CheckVprAnswerEvent event, Emitter<VprState> emit) async {
    final currentState = state;
    if (currentState is! VprLoaded) return;

    final feedback = _evaluator.evaluate(
      typed: event.userAnswer,
      expected: event.expectedAnswer,
    );

    if (feedback.isAccepted) {
      await _repository.markTaskCompleted(event.taskId);
    }

    final newFeedbacks = Map<String, EvaluationResult>.from(currentState.feedbacks);
    newFeedbacks[event.taskId] = feedback;

    final updatedTasks = currentState.tasks.map((t) {
      if (t.id == event.taskId && feedback.isAccepted) {
        return t.copyWith(isCompleted: true);
      }
      return t;
    }).toList();

    emit(currentState.copyWith(
      tasks: updatedTasks,
      feedbacks: newFeedbacks,
    ));
  }
}
