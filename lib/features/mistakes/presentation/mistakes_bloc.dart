import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/entities/mistake_entity.dart';
import '../domain/repositories/mistakes_repository.dart';
import 'mistakes_event.dart';
import 'mistakes_state.dart';

class MistakesBloc extends Bloc<MistakesEvent, MistakesState> {
  final MistakesRepository _repository;

  MistakesBloc({required MistakesRepository repository})
      : _repository = repository,
        super(const MistakesInitial()) {
    on<LoadMistakes>(_onLoadMistakes);
    on<RecordMistakeAttempt>(_onRecordMistakeAttempt);
    on<AddManualMistake>(_onAddManualMistake);
  }

  Future<void> _onLoadMistakes(
    LoadMistakes event,
    Emitter<MistakesState> emit,
  ) async {
    emit(const MistakesLoading());
    final result = await _repository.getAllMistakes();
    switch (result) {
      case Success<List<MistakeEntity>>(value: final mistakes):
        final unresolved = mistakes.where((m) => !m.isResolved).toList();
        emit(MistakesLoaded(
          allMistakes: mistakes,
          unresolvedMistakes: unresolved,
        ));
      case Failure<List<MistakeEntity>>(error: final err):
        emit(MistakesError(err.toString()));
    }
  }

  Future<void> _onRecordMistakeAttempt(
    RecordMistakeAttempt event,
    Emitter<MistakesState> emit,
  ) async {
    final result = await _repository.recordPracticeAttempt(
      id: event.id,
      isCorrect: event.isCorrect,
    );
    switch (result) {
      case Success():
        final reload = await _repository.getAllMistakes();
        switch (reload) {
          case Success<List<MistakeEntity>>(value: final mistakes):
            final unresolved = mistakes.where((m) => !m.isResolved).toList();
            emit(MistakesLoaded(
              allMistakes: mistakes,
              unresolvedMistakes: unresolved,
            ));
          case Failure<List<MistakeEntity>>(error: final err):
            emit(MistakesError(err.toString()));
        }
      case Failure(error: final err):
        emit(MistakesError(err.toString()));
    }
  }

  Future<void> _onAddManualMistake(
    AddManualMistake event,
    Emitter<MistakesState> emit,
  ) async {
    final result = await _repository.logMistake(
      id: event.id,
      taskType: event.taskType,
      prompt: event.prompt,
      wrongAnswer: event.wrongAnswer,
      correctAnswer: event.correctAnswer,
      explanation: event.explanation,
    );
    switch (result) {
      case Success():
        final reload = await _repository.getAllMistakes();
        switch (reload) {
          case Success<List<MistakeEntity>>(value: final mistakes):
            final unresolved = mistakes.where((m) => !m.isResolved).toList();
            emit(MistakesLoaded(
              allMistakes: mistakes,
              unresolvedMistakes: unresolved,
            ));
          case Failure<List<MistakeEntity>>(error: final err):
            emit(MistakesError(err.toString()));
        }
      case Failure(error: final err):
        emit(MistakesError(err.toString()));
    }
  }
}
