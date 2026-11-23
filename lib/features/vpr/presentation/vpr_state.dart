import 'package:equatable/equatable.dart';
import '../../srs/domain/services/english_answer_evaluator.dart';
import '../domain/entities/vpr_task_entity.dart';

sealed class VprState extends Equatable {
  const VprState();

  @override
  List<Object?> get props => [];
}

final class VprInitial extends VprState {
  const VprInitial();
}

final class VprLoading extends VprState {
  const VprLoading();
}

final class VprLoaded extends VprState {
  final int grade;
  final List<VprTaskEntity> tasks;
  final Map<String, EvaluationResult> feedbacks;

  const VprLoaded({
    required this.grade,
    required this.tasks,
    this.feedbacks = const {},
  });

  VprLoaded copyWith({
    int? grade,
    List<VprTaskEntity>? tasks,
    Map<String, EvaluationResult>? feedbacks,
  }) {
    return VprLoaded(
      grade: grade ?? this.grade,
      tasks: tasks ?? this.tasks,
      feedbacks: feedbacks ?? this.feedbacks,
    );
  }

  @override
  List<Object?> get props => [grade, tasks, feedbacks];
}

final class VprErrorState extends VprState {
  final String message;
  const VprErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
