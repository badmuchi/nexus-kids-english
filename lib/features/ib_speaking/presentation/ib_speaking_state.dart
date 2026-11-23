import 'package:equatable/equatable.dart';
import '../domain/entities/ib_speaking_entity.dart';

sealed class IbSpeakingState extends Equatable {
  const IbSpeakingState();

  @override
  List<Object?> get props => [];
}

final class IbSpeakingInitial extends IbSpeakingState {
  const IbSpeakingInitial();
}

final class IbSpeakingLoading extends IbSpeakingState {
  const IbSpeakingLoading();
}

final class IbSpeakingLoaded extends IbSpeakingState {
  final List<IbSpeakingTaskEntity> tasks;
  final String? selectedTaskId;

  const IbSpeakingLoaded({
    required this.tasks,
    this.selectedTaskId,
  });

  IbSpeakingTaskEntity? get currentTask {
    if (selectedTaskId == null) return tasks.firstOrNull;
    return tasks.where((t) => t.id == selectedTaskId).firstOrNull ?? tasks.firstOrNull;
  }

  IbSpeakingLoaded copyWith({
    List<IbSpeakingTaskEntity>? tasks,
    String? selectedTaskId,
  }) {
    return IbSpeakingLoaded(
      tasks: tasks ?? this.tasks,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
    );
  }

  @override
  List<Object?> get props => [tasks, selectedTaskId];
}

final class IbSpeakingErrorState extends IbSpeakingState {
  final String message;
  const IbSpeakingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
