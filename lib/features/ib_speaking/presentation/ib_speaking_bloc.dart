import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/repositories/ib_speaking_repository.dart';
import 'ib_speaking_event.dart';
import 'ib_speaking_state.dart';

class IbSpeakingBloc extends Bloc<IbSpeakingEvent, IbSpeakingState> {
  final IbSpeakingRepository _repository;

  IbSpeakingBloc({required IbSpeakingRepository repository})
      : _repository = repository,
        super(const IbSpeakingInitial()) {
    on<LoadIbSpeakingTasksEvent>(_onLoadTasks);
    on<SelectIbSpeakingTaskEvent>(_onSelectTask);
    on<SubmitSpeakingScoreEvent>(_onSubmitScore);
  }

  Future<void> _onLoadTasks(
    LoadIbSpeakingTasksEvent event,
    Emitter<IbSpeakingState> emit,
  ) async {
    emit(const IbSpeakingLoading());
    final result = await _repository.getAllTasks();
    switch (result) {
      case Success(value: final tasks):
        emit(IbSpeakingLoaded(
          tasks: tasks,
          selectedTaskId: tasks.firstOrNull?.id,
        ));
      case Failure(error: final err):
        emit(IbSpeakingErrorState(err.toString()));
    }
  }

  void _onSelectTask(
    SelectIbSpeakingTaskEvent event,
    Emitter<IbSpeakingState> emit,
  ) {
    final current = state;
    if (current is! IbSpeakingLoaded) return;
    emit(current.copyWith(selectedTaskId: event.taskId));
  }

  Future<void> _onSubmitScore(
    SubmitSpeakingScoreEvent event,
    Emitter<IbSpeakingState> emit,
  ) async {
    final current = state;
    if (current is! IbSpeakingLoaded) return;

    await _repository.saveSpeakingResult(event.taskId, event.scoreOutOf8);
    final updatedTasks = current.tasks.map((t) {
      if (t.id == event.taskId) {
        return t.copyWith(isCompleted: true, scoreOutOf8: event.scoreOutOf8);
      }
      return t;
    }).toList();

    emit(current.copyWith(tasks: updatedTasks));
  }
}
