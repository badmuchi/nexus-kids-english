import '../../../../core/result/result.dart';
import '../entities/vpr_task_entity.dart';

abstract class VprRepository {
  Future<Result<List<VprTaskEntity>>> getTasksByGrade(int grade);
  Future<Result<void>> markTaskCompleted(String taskId);
}
