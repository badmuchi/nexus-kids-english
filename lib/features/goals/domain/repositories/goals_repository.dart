import '../../../../core/result/result.dart';
import '../entities/study_goal_entity.dart';

abstract interface class GoalsRepository {
  Future<Result<List<StudyGoalEntity>>> getGoals();
  Future<Result<void>> updateProgress({required String goalId, required int newValue});
}
