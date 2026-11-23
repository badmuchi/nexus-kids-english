import '../../../../core/result/result.dart';
import '../entities/reading_story_entity.dart';

abstract class ReadingLabRepository {
  Future<Result<List<ReadingStoryEntity>>> getAllStories();
  Future<Result<void>> saveQuizResult(String storyId, int score);
}
