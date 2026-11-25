import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/result/result.dart';
import '../domain/entities/knowledge_node_entity.dart';
import '../domain/repositories/knowledge_map_repository.dart';
import 'knowledge_map_event.dart';
import 'knowledge_map_state.dart';

class KnowledgeMapBloc extends Bloc<KnowledgeMapEvent, KnowledgeMapState> {
  final KnowledgeMapRepository _repository;

  KnowledgeMapBloc({required KnowledgeMapRepository repository})
      : _repository = repository,
        super(const KnowledgeMapInitial()) {
    on<LoadKnowledgeMapEvent>(_onLoadKnowledgeMap);
    on<FilterKnowledgeMapCategoryEvent>(_onFilterCategory);
  }

  Future<void> _onLoadKnowledgeMap(
    LoadKnowledgeMapEvent event,
    Emitter<KnowledgeMapState> emit,
  ) async {
    emit(const KnowledgeMapLoading());
    final result = event.activeMistakes != null
        ? await _repository.syncWithMistakes(event.activeMistakes!)
        : await _repository.getKnowledgeNodes();

    switch (result) {
      case Success<List<KnowledgeNodeEntity>>(value: final nodes):
        emit(KnowledgeMapLoaded(allNodes: nodes));
      case Failure<List<KnowledgeNodeEntity>>(error: final err):
        emit(KnowledgeMapError(err.toString()));
    }
  }

  void _onFilterCategory(
    FilterKnowledgeMapCategoryEvent event,
    Emitter<KnowledgeMapState> emit,
  ) {
    if (state is KnowledgeMapLoaded) {
      final current = state as KnowledgeMapLoaded;
      emit(KnowledgeMapLoaded(
        allNodes: current.allNodes,
        activeCategory: event.category,
      ));
    }
  }
}
