import 'package:equatable/equatable.dart';

sealed class IbSpeakingEvent extends Equatable {
  const IbSpeakingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadIbSpeakingTasksEvent extends IbSpeakingEvent {
  const LoadIbSpeakingTasksEvent();
}

final class SelectIbSpeakingTaskEvent extends IbSpeakingEvent {
  final String taskId;
  const SelectIbSpeakingTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

final class SubmitSpeakingScoreEvent extends IbSpeakingEvent {
  final String taskId;
  final int scoreOutOf8;

  const SubmitSpeakingScoreEvent({
    required this.taskId,
    required this.scoreOutOf8,
  });

  @override
  List<Object?> get props => [taskId, scoreOutOf8];
}
