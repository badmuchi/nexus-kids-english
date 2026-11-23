import '../../../../core/result/result.dart';
import '../../domain/entities/ib_portfolio_entity.dart';
import '../../domain/repositories/ib_portfolio_repository.dart';

class DriftIbPortfolioRepository implements IbPortfolioRepository {
  final List<IbPortfolioEntity> _items = [
    IbPortfolioEntity(
      id: 'port_001',
      unitId: 'ib_unit_001',
      unitTitle: 'Digital Footprint: Who Are We Online?',
      criterion: 'Criterion D',
      taskTitle: 'A Teen Guide to Mindful Tech Use',
      content:
          'To begin with, smartphones are an inseparable part of modern adolescent life. Furthermore, they allow teenagers to collaborate across global contexts. However, continuous exposure to notifications can generate digital anxiety. Consequently, students must cultivate intentional digital balance. In conclusion, maintaining offline hobbies strengthens real-world relationships.',
      scoreOutOf8: 7,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    IbPortfolioEntity(
      id: 'port_002',
      unitId: 'ib_unit_002',
      unitTitle: 'AI & The Future: Creativity or Code?',
      criterion: 'Criterion B',
      taskTitle: 'Editorial: The Robot Novelist',
      content:
          'The author effectively contrasts computational neural networks with Shakespearean metaphorical ambiguity. Through vivid imagery, the text demonstrates that human emotional vulnerability remains unique.',
      scoreOutOf8: 6,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  ];

  DriftIbPortfolioRepository([dynamic _]);

  @override
  Future<Result<List<IbPortfolioEntity>>> getAllPortfolioItems() async {
    return Result.success(List.unmodifiable(_items));
  }

  @override
  Future<Result<void>> addPortfolioItem({
    required String id,
    required String unitId,
    required String unitTitle,
    required String criterion,
    required String taskTitle,
    required String content,
    required int scoreOutOf8,
  }) async {
    _items.insert(
      0,
      IbPortfolioEntity(
        id: id,
        unitId: unitId,
        unitTitle: unitTitle,
        criterion: criterion,
        taskTitle: taskTitle,
        content: content,
        scoreOutOf8: scoreOutOf8,
        createdAt: DateTime.now(),
      ),
    );
    return const Result.success(null);
  }

  @override
  Future<Result<IbScoreSummary>> getScoreSummary() async {
    int a = 7, b = 6, c = 7, d = 7;
    for (final item in _items) {
      if (item.criterion == 'Criterion A') a = item.scoreOutOf8;
      if (item.criterion == 'Criterion B') b = item.scoreOutOf8;
      if (item.criterion == 'Criterion C') c = item.scoreOutOf8;
      if (item.criterion == 'Criterion D') d = item.scoreOutOf8;
    }

    return Result.success(IbScoreSummary(
      criterionA: a,
      criterionB: b,
      criterionC: c,
      criterionD: d,
    ));
  }
}
