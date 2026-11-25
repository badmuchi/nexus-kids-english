import 'package:equatable/equatable.dart';
import '../domain/entities/knowledge_node_entity.dart';

abstract class KnowledgeMapState extends Equatable {
  const KnowledgeMapState();

  @override
  List<Object?> get props => [];
}

class KnowledgeMapInitial extends KnowledgeMapState {
  const KnowledgeMapInitial();
}

class KnowledgeMapLoading extends KnowledgeMapState {
  const KnowledgeMapLoading();
}

class KnowledgeMapLoaded extends KnowledgeMapState {
  final List<KnowledgeNodeEntity> allNodes;
  final String activeCategory;

  const KnowledgeMapLoaded({
    required this.allNodes,
    this.activeCategory = 'ALL',
  });

  List<KnowledgeNodeEntity> get filteredNodes {
    if (activeCategory == 'ALL') return allNodes;
    return allNodes.where((n) => n.category == activeCategory).toList();
  }

  int get masteredCount => allNodes.where((n) => n.masteryLevel == NodeMasteryLevel.mastered).length;
  int get inProgressCount => allNodes.where((n) => n.masteryLevel == NodeMasteryLevel.inProgress).length;
  int get needsReviewCount => allNodes.where((n) => n.masteryLevel == NodeMasteryLevel.needsReview).length;

  int get overallMasteryPercent {
    if (allNodes.isEmpty) return 0;
    final total = allNodes.map((n) => n.masteryPercent).reduce((a, b) => a + b);
    return (total / allNodes.length).round();
  }

  @override
  List<Object?> get props => [allNodes, activeCategory];
}

class KnowledgeMapError extends KnowledgeMapState {
  final String message;

  const KnowledgeMapError(this.message);

  @override
  List<Object?> get props => [message];
}
