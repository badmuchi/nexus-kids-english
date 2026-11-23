import 'package:equatable/equatable.dart';
import '../domain/entities/oge_task_entity.dart';

sealed class OgeState extends Equatable {
  const OgeState();

  @override
  List<Object?> get props => [];
}

class OgeInitial extends OgeState {
  const OgeInitial();
}

class OgeLoading extends OgeState {
  const OgeLoading();
}

class OgeGrammarActive extends OgeState {
  final List<OgeGrammarTaskEntity> tasks;
  final int currentIndex;
  final bool isAnswerChecked;
  final bool isCorrect;
  final String? feedback;

  const OgeGrammarActive({
    required this.tasks,
    required this.currentIndex,
    this.isAnswerChecked = false,
    this.isCorrect = false,
    this.feedback,
  });

  OgeGrammarTaskEntity get currentTask => tasks[currentIndex];
  bool get isLastTask => currentIndex >= tasks.length - 1;

  OgeGrammarActive copyWith({
    List<OgeGrammarTaskEntity>? tasks,
    int? currentIndex,
    bool? isAnswerChecked,
    bool? isCorrect,
    String? feedback,
    bool clearFeedback = false,
  }) {
    return OgeGrammarActive(
      tasks: tasks ?? this.tasks,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerChecked: isAnswerChecked ?? this.isAnswerChecked,
      isCorrect: isCorrect ?? this.isCorrect,
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
    );
  }

  @override
  List<Object?> get props => [tasks, currentIndex, isAnswerChecked, isCorrect, feedback];
}

class OgeWordFormationActive extends OgeState {
  final List<OgeWordFormationTaskEntity> tasks;
  final int currentIndex;
  final bool isAnswerChecked;
  final bool isCorrect;
  final String? feedback;

  const OgeWordFormationActive({
    required this.tasks,
    required this.currentIndex,
    this.isAnswerChecked = false,
    this.isCorrect = false,
    this.feedback,
  });

  OgeWordFormationTaskEntity get currentTask => tasks[currentIndex];
  bool get isLastTask => currentIndex >= tasks.length - 1;

  OgeWordFormationActive copyWith({
    List<OgeWordFormationTaskEntity>? tasks,
    int? currentIndex,
    bool? isAnswerChecked,
    bool? isCorrect,
    String? feedback,
    bool clearFeedback = false,
  }) {
    return OgeWordFormationActive(
      tasks: tasks ?? this.tasks,
      currentIndex: currentIndex ?? this.currentIndex,
      isAnswerChecked: isAnswerChecked ?? this.isAnswerChecked,
      isCorrect: isCorrect ?? this.isCorrect,
      feedback: clearFeedback ? null : (feedback ?? this.feedback),
    );
  }

  @override
  List<Object?> get props => [tasks, currentIndex, isAnswerChecked, isCorrect, feedback];
}

class OgeCompleted extends OgeState {
  final String title;
  final int totalCount;

  const OgeCompleted({
    required this.title,
    required this.totalCount,
  });

  @override
  List<Object?> get props => [title, totalCount];
}

class OgeErrorState extends OgeState {
  final String message;

  const OgeErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
