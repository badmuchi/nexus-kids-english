import '../../../../core/result/result.dart';
import '../entities/oge_exam_entity.dart';

abstract interface class OgeExamRepository {
  Future<Result<List<ListeningQuestionItem>>> getListeningTasks1_4();
  Future<Result<List<ListeningTableField>>> getListeningTableTasks6_11();
  Future<Result<List<ReadingHeadingParagraph>>> getReadingHeadingsParagraphs();
  Future<Result<List<Map<String, String>>>> getReadingHeadingsOptions();
  Future<Result<List<ReadingTrueFalseItem>>> getReadingTrueFalseItems();
  Future<Result<void>> saveExamResult(ExamResultSummary summary);
  Future<Result<List<ExamResultSummary>>> getRecentExamResults();
}
