import '../../../../core/result/result.dart';
import '../entities/mistake_entity.dart';

abstract interface class MistakesRepository {
  Future<Result<List<MistakeEntity>>> getAllMistakes();
  Future<Result<List<MistakeEntity>>> getUnresolvedMistakes();
  Future<Result<void>> logMistake({
    required String id,
    required String taskType,
    required String prompt,
    required String wrongAnswer,
    required String correctAnswer,
    required String explanation,
  });
  Future<Result<void>> recordPracticeAttempt({
    required String id,
    required bool isCorrect,
  });
}
