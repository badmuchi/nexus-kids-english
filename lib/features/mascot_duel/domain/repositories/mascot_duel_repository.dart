import '../../../../core/result/result.dart';
import '../entities/duel_question_entity.dart';

abstract class MascotDuelRepository {
  Future<Result<List<DuelQuestionEntity>>> getDuelQuestions();
}
