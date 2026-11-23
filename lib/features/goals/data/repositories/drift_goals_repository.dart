import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/study_goal_entity.dart';
import '../../domain/repositories/goals_repository.dart';

class DriftGoalsRepository implements GoalsRepository {
  final AppDatabase _db;

  DriftGoalsRepository(this._db);

  @override
  Future<Result<List<StudyGoalEntity>>> getGoals() async {
    try {
      final rows = await _db.getAllGoals();
      final entities = rows.map((r) => StudyGoalEntity(
            id: r.id,
            title: r.title,
            description: r.description,
            category: r.category,
            targetValue: r.targetValue,
            currentValue: r.currentValue,
            unit: r.unit,
            deadlineDays: r.deadlineDays,
            isPrimary: r.isPrimary,
          )).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load study goals: $e', st));
    }
  }

  @override
  Future<Result<void>> updateProgress({
    required String goalId,
    required int newValue,
  }) async {
    try {
      await _db.updateGoalProgress(goalId, newValue);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to update goal progress: $e', st));
    }
  }
}
