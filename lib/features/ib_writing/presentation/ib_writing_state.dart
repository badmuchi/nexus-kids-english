import 'package:equatable/equatable.dart';
import '../../ib_myp/domain/services/cohesive_devices_analyzer.dart';
import '../domain/entities/ib_writing_entity.dart';

sealed class IbWritingState extends Equatable {
  const IbWritingState();

  @override
  List<Object?> get props => [];
}

final class IbWritingInitial extends IbWritingState {
  const IbWritingInitial();
}

final class IbWritingLoading extends IbWritingState {
  const IbWritingLoading();
}

final class IbWritingLoaded extends IbWritingState {
  final List<IbWritingTaskEntity> tasks;
  final String? selectedTaskId;
  final WritingAnalysisResult? analysis;
  final String currentText;

  const IbWritingLoaded({
    required this.tasks,
    this.selectedTaskId,
    this.analysis,
    this.currentText = '',
  });

  IbWritingTaskEntity? get currentTask {
    if (selectedTaskId == null) return tasks.firstOrNull;
    return tasks.where((t) => t.id == selectedTaskId).firstOrNull ?? tasks.firstOrNull;
  }

  IbWritingLoaded copyWith({
    List<IbWritingTaskEntity>? tasks,
    String? selectedTaskId,
    WritingAnalysisResult? analysis,
    String? currentText,
  }) {
    return IbWritingLoaded(
      tasks: tasks ?? this.tasks,
      selectedTaskId: selectedTaskId ?? this.selectedTaskId,
      analysis: analysis ?? this.analysis,
      currentText: currentText ?? this.currentText,
    );
  }

  @override
  List<Object?> get props => [tasks, selectedTaskId, analysis, currentText];
}

final class IbWritingErrorState extends IbWritingState {
  final String message;
  const IbWritingErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
