import '../../../../core/result/result.dart';
import '../entities/ib_portfolio_entity.dart';

abstract interface class IbPortfolioRepository {
  Future<Result<List<IbPortfolioEntity>>> getAllPortfolioItems();
  Future<Result<void>> addPortfolioItem({
    required String id,
    required String unitId,
    required String unitTitle,
    required String criterion,
    required String taskTitle,
    required String content,
    required int scoreOutOf8,
  });
  Future<Result<IbScoreSummary>> getScoreSummary();
}
