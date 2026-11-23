import 'package:equatable/equatable.dart';

sealed class GoalsEvent extends Equatable {
  const GoalsEvent();

  @override
  List<Object?> get props => [];
}

class LoadGoalsEvent extends GoalsEvent {
  const LoadGoalsEvent();
}

class UpdateGoalProgressEvent extends GoalsEvent {
  final String goalId;
  final int newValue;

  const UpdateGoalProgressEvent({
    required this.goalId,
    required this.newValue,
  });

  @override
  List<Object?> get props => [goalId, newValue];
}
