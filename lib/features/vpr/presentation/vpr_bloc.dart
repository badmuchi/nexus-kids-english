import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
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

  Future<void> _onLoadTasks(
    LoadVprTasksEvent event,
    Emitter<VprState> emit,
  ) async {
    emit(const VprLoading());
    final result = await _repository.getTasksByGrade(event.grade);
    switch (result) {
      case Success(value: final tasks):
        emit(VprLoaded(grade: event.grade, tasks: tasks));
      case Failure(error: final err):
        emit(VprErrorState(err.toString()));
    }
  }

  Future<void> _onCheckAnswer(
    CheckVprAnswerEvent event,
    Emitter<VprState> emit,
  ) async {
    final current = state;
    if (current is! VprLoaded) return;

    final evalResult = _evaluator.evaluate(
      typed: event.userAnswer,
      expected: event.expectedAnswer,
    );

    final updatedFeedbacks = Map<String, EvaluationResult>.from(current.feedbacks);
    updatedFeedbacks[event.taskId] = evalResult;

    if (evalResult.isAccepted) {
      await _repository.markTaskCompleted(event.taskId);
      final updatedTasks = current.tasks.map((task) {
        if (task.id == event.taskId) {
          return task.copyWith(isCompleted: true);
        }
        return task;
      }).toList();
      emit(current.copyWith(tasks: updatedTasks, feedbacks: updatedFeedbacks));
    } else {
      emit(current.copyWith(feedbacks: updatedFeedbacks));
    }
  }
}
