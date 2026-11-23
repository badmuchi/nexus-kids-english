import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/ib_portfolio/domain/entities/ib_portfolio_entity.dart';
import 'package:english_for_children/features/ib_portfolio/domain/repositories/ib_portfolio_repository.dart';
import 'package:english_for_children/features/ib_portfolio/presentation/ib_portfolio_bloc.dart';
import 'package:english_for_children/features/ib_portfolio/presentation/ib_portfolio_event.dart';
import 'package:english_for_children/features/ib_portfolio/presentation/ib_portfolio_state.dart';

class MockIbPortfolioRepository extends Mock implements IbPortfolioRepository {}

void main() {
  late MockIbPortfolioRepository mockRepository;

  final sampleItem = IbPortfolioEntity(
    id: 'port_01',
    unitId: 'unit_01',
    unitTitle: 'Digital Footprint',
    criterion: 'Criterion D',
    taskTitle: 'Teen Guide',
    content: 'Furthermore, mindful usage is key.',
    scoreOutOf8: 7,
    createdAt: DateTime(2026, 11, 23),
  );

  const sampleSummary = IbScoreSummary(
    criterionA: 6,
    criterionB: 7,
    criterionC: 6,
    criterionD: 7,
  );

  setUp(() {
    mockRepository = MockIbPortfolioRepository();
  });

  group('IbPortfolioBloc Tests', () {
    test('initial state is IbPortfolioInitial', () {
      final bloc = IbPortfolioBloc(repository: mockRepository);
      expect(bloc.state, const IbPortfolioInitial());
    });

    test('IbScoreSummary grade calculations', () {
      expect(sampleSummary.totalOutOf32, 26);
      expect(sampleSummary.ibFinalGrade, 6);
      expect(sampleSummary.ibGradeDescriptor, contains('Grade 6'));
    });

    blocTest<IbPortfolioBloc, IbPortfolioState>(
      'emits [IbPortfolioLoading, IbPortfolioLoaded] when LoadIbPortfolio succeeds',
      build: () {
        when(() => mockRepository.getAllPortfolioItems())
            .thenAnswer((_) async => Result.success([sampleItem]));
        when(() => mockRepository.getScoreSummary())
            .thenAnswer((_) async => const Result.success(sampleSummary));
        return IbPortfolioBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadIbPortfolio()),
      expect: () => [
        const IbPortfolioLoading(),
        IbPortfolioLoaded(
          items: [sampleItem],
          summary: sampleSummary,
        ),
      ],
    );
  });
}
