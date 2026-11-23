import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/result/result.dart';
import '../domain/repositories/verbs_repository.dart';
import 'verbs_event.dart';
import 'verbs_state.dart';

class VerbsBloc extends Bloc<VerbsEvent, VerbsState> {
  final VerbsRepository _repository;

  VerbsBloc({required VerbsRepository repository})
      : _repository = repository,
        super(const VerbsInitial()) {
    on<LoadAllVerbsEvent>(_onLoadAllVerbs);
    on<FilterVerbsByRhymeEvent>(_onFilterByRhyme);
  }

  Future<void> _onLoadAllVerbs(LoadAllVerbsEvent event, Emitter<VerbsState> emit) async {
    emit(const VerbsLoading());
    final result = await _repository.getAllVerbs();
    switch (result) {
      case Success(value: final list):
        final groups = ['Все', ...list.map((v) => v.rhymeGroup).toSet()];
        emit(VerbsLoaded(
          allVerbs: list,
          displayedVerbs: list,
          rhymeGroups: groups,
          selectedGroup: 'Все',
        ));
      case Failure(error: final err):
        emit(VerbsErrorState(err.toString()));
    }
  }

  void _onFilterByRhyme(FilterVerbsByRhymeEvent event, Emitter<VerbsState> emit) {
    final current = state;
    if (current is! VerbsLoaded) return;

    if (event.rhymeGroup == 'Все') {
      emit(current.copyWith(
        displayedVerbs: current.allVerbs,
        selectedGroup: 'Все',
      ));
    } else {
      final filtered = current.allVerbs.where((v) => v.rhymeGroup == event.rhymeGroup).toList();
      emit(current.copyWith(
        displayedVerbs: filtered,
        selectedGroup: event.rhymeGroup,
      ));
    }
  }
}
