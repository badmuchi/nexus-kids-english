import 'package:equatable/equatable.dart';

sealed class OgeEvent extends Equatable {
  const OgeEvent();

  @override
  List<Object?> get props => [];
}

class LoadOgeGrammarTasksEvent extends OgeEvent {
  const LoadOgeGrammarTasksEvent();
}

class SubmitGrammarAnswerEvent extends OgeEvent {
  final String taskId;
  final String typedAnswer;

  const SubmitGrammarAnswerEvent({
    required this.taskId,
    required this.typedAnswer,
  });

  @override
  List<Object?> get props => [taskId, typedAnswer];
}

class NextGrammarTaskEvent extends OgeEvent {
  const NextGrammarTaskEvent();
}

class LoadOgeWordFormationTasksEvent extends OgeEvent {
  const LoadOgeWordFormationTasksEvent();
}

class SubmitWordFormationAnswerEvent extends OgeEvent {
  final String taskId;
  final String typedAnswer;

  const SubmitWordFormationAnswerEvent({
    required this.taskId,
    required this.typedAnswer,
  });

  @override
  List<Object?> get props => [taskId, typedAnswer];
}

class NextWordFormationTaskEvent extends OgeEvent {
  const NextWordFormationTaskEvent();
}
