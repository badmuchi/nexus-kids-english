import '../../../../core/result/result.dart';
import '../entities/ib_writing_entity.dart';

abstract class IbWritingRepository {
  Future<Result<List<IbWritingTaskEntity>>> getAllTasks();
  Future<Result<void>> saveWritingDraft(String taskId, String text, double scoreOutOf8);
}
