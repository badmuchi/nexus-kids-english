import 'package:equatable/equatable.dart';
import '../../mistakes/domain/entities/mistake_entity.dart';

abstract class KnowledgeMapEvent extends Equatable {
  const KnowledgeMapEvent();

  @override
  List<Object?> get props => [];
}

class LoadKnowledgeMapEvent extends KnowledgeMapEvent {
  final List<MistakeEntity>? activeMistakes;

  const LoadKnowledgeMapEvent({this.activeMistakes});

  @override
  List<Object?> get props => [activeMistakes];
}

class FilterKnowledgeMapCategoryEvent extends KnowledgeMapEvent {
  final String category; // 'ALL', 'TENSES', 'WORD_FORMATION', 'CONDITIONALS', 'PASSIVE', 'LEXIS'

  const FilterKnowledgeMapCategoryEvent(this.category);

  @override
  List<Object?> get props => [category];
}
