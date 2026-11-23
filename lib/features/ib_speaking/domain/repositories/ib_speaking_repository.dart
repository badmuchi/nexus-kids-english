import '../../../../core/result/result.dart';
import '../entities/ib_speaking_entity.dart';

abstract class IbSpeakingRepository {
  Future<Result<List<IbSpeakingTaskEntity>>> getAllTasks();
  Future<Result<void>> saveSpeakingResult(String taskId, int scoreOutOf8);
}
