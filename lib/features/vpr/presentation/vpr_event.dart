import 'package:equatable/equatable.dart';

sealed class VprEvent extends Equatable {
  const VprEvent();

  @override
  List<Object?> get props => [];
}

final class LoadVprTasksEvent extends VprEvent {
  final int grade;
  const LoadVprTasksEvent({this.grade = 5});

  @override
  List<Object?> get props => [grade];
}

final class CheckVprAnswerEvent extends VprEvent {
  final String taskId;
  final String userAnswer;
  final String expectedAnswer;

  const CheckVprAnswerEvent({
    required this.taskId,
    required this.userAnswer,
    required this.expectedAnswer,
  });

  @override
  List<Object?> get props => [taskId, userAnswer, expectedAnswer];
}
