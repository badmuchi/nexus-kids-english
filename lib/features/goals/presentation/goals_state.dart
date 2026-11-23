import 'package:equatable/equatable.dart';
import '../domain/entities/study_goal_entity.dart';

sealed class GoalsState extends Equatable {
  const GoalsState();

  @override
  List<Object?> get props => [];
}

class GoalsInitial extends GoalsState {
  const GoalsInitial();
}

class GoalsLoading extends GoalsState {
  const GoalsLoading();
}

class GoalsLoaded extends GoalsState {
  final List<StudyGoalEntity> goals;

  const GoalsLoaded(this.goals);

  StudyGoalEntity? get primaryGoal => goals.where((g) => g.isPrimary).firstOrNull;

  @override
  List<Object?> get props => [goals];
}

class GoalsErrorState extends GoalsState {
  final String message;

  const GoalsErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
