import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../../ib_myp/domain/services/cohesive_devices_analyzer.dart';
import '../domain/repositories/ib_writing_repository.dart';
import 'ib_writing_event.dart';
import 'ib_writing_state.dart';

class IbWritingBloc extends Bloc<IbWritingEvent, IbWritingState> {
  final IbWritingRepository _repository;
  final CohesiveDevicesAnalyzer _analyzer;

  IbWritingBloc({
    required IbWritingRepository repository,
    CohesiveDevicesAnalyzer analyzer = const CohesiveDevicesAnalyzer(),
  })  : _repository = repository,
        _analyzer = analyzer,
        super(const IbWritingInitial()) {
    on<LoadIbWritingTasksEvent>(_onLoadTasks);
    on<SelectIbWritingTaskEvent>(_onSelectTask);
    on<AnalyzeTextEvent>(_onAnalyzeText);
    on<SaveWritingDraftEvent>(_onSaveDraft);
  }

  Future<void> _onLoadTasks(
    LoadIbWritingTasksEvent event,
    Emitter<IbWritingState> emit,
  ) async {
    emit(const IbWritingLoading());
    final result = await _repository.getAllTasks();
    switch (result) {
      case Success(value: final tasks):
        final initialTask = tasks.firstOrNull;
        final initialText = initialTask?.savedText ?? '';
        final initialAnalysis = initialText.isNotEmpty ? _analyzer.analyze(initialText) : null;

        emit(IbWritingLoaded(
          tasks: tasks,
          selectedTaskId: initialTask?.id,
          analysis: initialAnalysis,
          currentText: initialText,
        ));
      case Failure(error: final err):
        emit(IbWritingErrorState(err.toString()));
    }
  }

  void _onSelectTask(
    SelectIbWritingTaskEvent event,
    Emitter<IbWritingState> emit,
  ) {
    final current = state;
    if (current is! IbWritingLoaded) return;

    final target = current.tasks.where((t) => t.id == event.taskId).firstOrNull;
    final text = target?.savedText ?? '';
    final analysis = text.isNotEmpty ? _analyzer.analyze(text) : null;

    emit(current.copyWith(
      selectedTaskId: event.taskId,
      currentText: text,
      analysis: analysis,
    ));
  }

  void _onAnalyzeText(
    AnalyzeTextEvent event,
    Emitter<IbWritingState> emit,
  ) {
    final current = state;
    if (current is! IbWritingLoaded) return;

    final analysis = _analyzer.analyze(event.text);
    emit(current.copyWith(
      currentText: event.text,
      analysis: analysis,
    ));
  }

  Future<void> _onSaveDraft(
    SaveWritingDraftEvent event,
    Emitter<IbWritingState> emit,
  ) async {
    final current = state;
    if (current is! IbWritingLoaded) return;

    await _repository.saveWritingDraft(event.taskId, event.text, event.score);
    final updatedTasks = current.tasks.map((t) {
      if (t.id == event.taskId) {
        return t.copyWith(
          savedText: event.text,
          scoreOutOf8: event.score,
          isCompleted: true,
        );
      }
      return t;
    }).toList();

    emit(current.copyWith(tasks: updatedTasks));
  }
}
