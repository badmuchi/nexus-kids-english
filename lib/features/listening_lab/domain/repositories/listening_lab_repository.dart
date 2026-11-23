import '../../../../core/result/result.dart';
import '../entities/minimal_pair_entity.dart';

abstract class ListeningLabRepository {
  Future<Result<List<MinimalPairEntity>>> getAllPairs();
}
