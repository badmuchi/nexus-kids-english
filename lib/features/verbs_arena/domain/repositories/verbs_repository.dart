import '../../../../core/result/result.dart';
import '../entities/irregular_verb_entity.dart';

abstract class VerbsRepository {
  Future<Result<List<IrregularVerbEntity>>> getAllVerbs();
  Future<Result<List<IrregularVerbEntity>>> getVerbsByRhyme(String rhymeGroup);
}
