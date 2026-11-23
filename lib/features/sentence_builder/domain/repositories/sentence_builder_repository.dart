import '../../../../core/result/result.dart';
import '../entities/sentence_puzzle_entity.dart';

abstract class SentenceBuilderRepository {
  Future<Result<List<SentencePuzzleEntity>>> getAllPuzzles();
  Future<Result<List<SentencePuzzleEntity>>> getPuzzlesByGrade(int grade);
}
