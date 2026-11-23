import 'package:equatable/equatable.dart';

sealed class IbWritingEvent extends Equatable {
  const IbWritingEvent();

  @override
  List<Object?> get props => [];
}

final class LoadIbWritingTasksEvent extends IbWritingEvent {
  const LoadIbWritingTasksEvent();
}

final class SelectIbWritingTaskEvent extends IbWritingEvent {
  final String taskId;
  const SelectIbWritingTaskEvent(this.taskId);

  @override
  List<Object?> get props => [taskId];
}

final class AnalyzeTextEvent extends IbWritingEvent {
  final String taskId;
  final String text;

  const AnalyzeTextEvent({
    required this.taskId,
    required this.text,
  });

  @override
  List<Object?> get props => [taskId, text];
}

final class SaveWritingDraftEvent extends IbWritingEvent {
  final String taskId;
  final String text;
  final double score;

  const SaveWritingDraftEvent({
    required this.taskId,
    required this.text,
    required this.score,
  });

  @override
  List<Object?> get props => [taskId, text, score];
}
