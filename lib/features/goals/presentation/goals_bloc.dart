import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/goals_repository.dart';
import 'goals_event.dart';
import 'goals_state.dart';

class GoalsBloc extends Bloc<GoalsEvent, GoalsState> {
  final GoalsRepository _repository;

  GoalsBloc({required GoalsRepository repository})
      : _repository = repository,
        super(const GoalsInitial()) {
    on<LoadGoalsEvent>(_onLoadGoals);
    on<UpdateGoalProgressEvent>(_onUpdateProgress);
  }

  Future<void> _onLoadGoals(LoadGoalsEvent event, Emitter<GoalsState> emit) async {
    emit(const GoalsLoading());
    final result = await _repository.getGoals();
    switch (result) {
      case Success(value: final goals):
        emit(GoalsLoaded(goals));
      case Failure(error: final err):
        emit(GoalsErrorState(err.toString()));
    }
  }

  Future<void> _onUpdateProgress(UpdateGoalProgressEvent event, Emitter<GoalsState> emit) async {
    await _repository.updateProgress(goalId: event.goalId, newValue: event.newValue);
    add(const LoadGoalsEvent());
  }
}
