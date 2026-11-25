import '../../../../core/result/result.dart';
import '../../../mistakes/domain/entities/mistake_entity.dart';
import '../entities/knowledge_node_entity.dart';

abstract interface class KnowledgeMapRepository {
  Future<Result<List<KnowledgeNodeEntity>>> getKnowledgeNodes();
  Future<Result<List<KnowledgeNodeEntity>>> syncWithMistakes(List<MistakeEntity> mistakes);
}
