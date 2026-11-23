import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/srs/domain/entities/srs_card_entity.dart';
import 'package:english_for_children/features/srs/domain/repositories/srs_repository.dart';
import 'package:english_for_children/features/srs/domain/services/english_answer_evaluator.dart';
import 'package:english_for_children/features/srs/presentation/srs_bloc.dart';
import 'package:english_for_children/features/srs/presentation/srs_event.dart';
import 'package:english_for_children/features/srs/presentation/srs_state.dart';

class MockSrsRepository extends Mock implements SrsRepository {}

void main() {
  late MockSrsRepository mockRepository;

  final sampleCard = SrsCardEntity(
    id: 'srs_001',
    frontEnglish: 'environment',
    backRussian: 'окружающая среда',
    level: 'B1',
    category: 'OGE',
    dueAt: DateTime(2026, 1, 1),
  );

  setUp(() {
    mockRepository = MockSrsRepository();
  });

  group('SrsBloc Tests', () {
    test('initial state is SrsInitial', () {
      final bloc = SrsBloc(repository: mockRepository);
      expect(bloc.state, const SrsInitial());
    });

    blocTest<SrsBloc, SrsState>(
      'emits [SrsLoading, SrsActive] when LoadDueCardsEvent succeeds',
      build: () {
        when(() => mockRepository.getDueCards())
            .thenAnswer((_) async => Result.success([sampleCard]));
        return SrsBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadDueCardsEvent()),
      expect: () => [
        const SrsLoading(),
        SrsActive(cards: [sampleCard], currentIndex: 0),
      ],
    );

    blocTest<SrsBloc, SrsState>(
      'evaluates answer correctly when CheckAnswerEvent is fired',
      build: () {
        return SrsBloc(repository: mockRepository);
      },
      seed: () => SrsActive(cards: [sampleCard], currentIndex: 0),
      act: (bloc) => bloc.add(CheckAnswerEvent(
        cardId: sampleCard.id,
        typedAnswer: 'environment',
      )),
      expect: () => [
        SrsActive(
          cards: [sampleCard],
          currentIndex: 0,
          isAnswerRevealed: true,
          lastEvaluation: const EnglishAnswerEvaluator().evaluate(
            typed: 'environment',
            expected: 'environment',
          ),
        ),
      ],
    );
  });
}
