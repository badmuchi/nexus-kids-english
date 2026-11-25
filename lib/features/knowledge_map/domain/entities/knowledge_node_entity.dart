import 'package:equatable/equatable.dart';

enum NodeMasteryLevel {
  mastered, // Green
  inProgress, // Amber
  needsReview, // Red
}

class KnowledgeNodeEntity extends Equatable {
  final String id;
  final String title;
  final String category; // TENSES, PASSIVE, CONDITIONALS, WORD_FORMATION, LEXIS
  final String cefrLevel; // A2, B1
  final NodeMasteryLevel masteryLevel;
  final int masteryPercent; // 0..100
  final String ruleSummary;
  final List<String> examples;
  final String targetScreenRoute; // GRAMMAR, WORD_FORMATION, SRS
  final List<String> connectedNodeIds;

  const KnowledgeNodeEntity({
    required this.id,
    required this.title,
    required this.category,
    required this.cefrLevel,
    required this.masteryLevel,
    required this.masteryPercent,
    required this.ruleSummary,
    required this.examples,
    required this.targetScreenRoute,
    this.connectedNodeIds = const [],
  });

  KnowledgeNodeEntity copyWith({
    String? id,
    String? title,
    String? category,
    String? cefrLevel,
    NodeMasteryLevel? masteryLevel,
    int? masteryPercent,
    String? ruleSummary,
    List<String>? examples,
    String? targetScreenRoute,
    List<String>? connectedNodeIds,
  }) {
    return KnowledgeNodeEntity(
      id: id ?? this.id,
      title: title ?? this.title,
      category: category ?? this.category,
      cefrLevel: cefrLevel ?? this.cefrLevel,
      masteryLevel: masteryLevel ?? this.masteryLevel,
      masteryPercent: masteryPercent ?? this.masteryPercent,
      ruleSummary: ruleSummary ?? this.ruleSummary,
      examples: examples ?? this.examples,
      targetScreenRoute: targetScreenRoute ?? this.targetScreenRoute,
      connectedNodeIds: connectedNodeIds ?? this.connectedNodeIds,
    );
  }

  @override
  List<Object?> get props => [
        id,
        title,
        category,
        cefrLevel,
        masteryLevel,
        masteryPercent,
        ruleSummary,
        examples,
        targetScreenRoute,
        connectedNodeIds,
      ];
}
