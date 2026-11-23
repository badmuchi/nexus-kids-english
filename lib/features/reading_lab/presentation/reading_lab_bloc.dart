import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/repositories/reading_lab_repository.dart';
import 'reading_lab_event.dart';
import 'reading_lab_state.dart';

class ReadingLabBloc extends Bloc<ReadingLabEvent, ReadingLabState> {
  final ReadingLabRepository _repository;

  ReadingLabBloc({required ReadingLabRepository repository})
      : _repository = repository,
        super(const ReadingLabInitial()) {
    on<LoadReadingStoriesEvent>(_onLoadStories);
    on<FilterStoriesByGradeEvent>(_onFilterByGrade);
    on<SubmitStoryQuizScoreEvent>(_onSubmitScore);
  }

  Future<void> _onLoadStories(
    LoadReadingStoriesEvent event,
    Emitter<ReadingLabState> emit,
  ) async {
    emit(const ReadingLabLoading());
    final result = await _repository.getAllStories();
    switch (result) {
      case Success(value: final stories):
        emit(ReadingLabLoaded(
          allStories: stories,
          displayedStories: stories,
          selectedGrade: null,
        ));
      case Failure(error: final err):
        emit(ReadingLabErrorState(err.toString()));
    }
  }

  void _onFilterByGrade(
    FilterStoriesByGradeEvent event,
    Emitter<ReadingLabState> emit,
  ) {
    final current = state;
    if (current is! ReadingLabLoaded) return;

    if (event.grade == null) {
      emit(current.copyWith(
        displayedStories: current.allStories,
        clearGrade: true,
      ));
    } else {
      final filtered = current.allStories.where((s) => s.grade == event.grade).toList();
      emit(current.copyWith(
        displayedStories: filtered,
        selectedGrade: event.grade,
      ));
    }
  }

  Future<void> _onSubmitScore(
    SubmitStoryQuizScoreEvent event,
    Emitter<ReadingLabState> emit,
  ) async {
    final current = state;
    if (current is! ReadingLabLoaded) return;

    await _repository.saveQuizResult(event.storyId, event.score);
    final updatedAll = current.allStories.map((s) {
      if (s.id == event.storyId) {
        return s.copyWith(isCompleted: true, quizScore: event.score);
      }
      return s;
    }).toList();

    final updatedDisp = current.displayedStories.map((s) {
      if (s.id == event.storyId) {
        return s.copyWith(isCompleted: true, quizScore: event.score);
      }
      return s;
    }).toList();

    emit(current.copyWith(allStories: updatedAll, displayedStories: updatedDisp));
  }
}
