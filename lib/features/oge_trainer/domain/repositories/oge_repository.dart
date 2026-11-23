import '../../../../core/result/result.dart';
import '../entities/oge_task_entity.dart';

abstract interface class OgeRepository {
  Future<Result<List<OgeGrammarTaskEntity>>> getGrammarTasks();
  Future<Result<void>> markGrammarTaskCompleted(String id);

  Future<Result<List<OgeWordFormationTaskEntity>>> getWordFormationTasks();
  Future<Result<void>> markWordFormationTaskCompleted(String id);
}
