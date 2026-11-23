import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/mistakes/domain/entities/mistake_entity.dart';
import 'package:english_for_children/features/mistakes/domain/repositories/mistakes_repository.dart';
import 'package:english_for_children/features/mistakes/presentation/mistakes_bloc.dart';
import 'package:english_for_children/features/mistakes/presentation/mistakes_event.dart';
import 'package:english_for_children/features/mistakes/presentation/mistakes_state.dart';

class MockMistakesRepository extends Mock implements MistakesRepository {}

void main() {
  late MockMistakesRepository mockRepository;

  final sampleMistake = MistakeEntity(
    id: 'mst_01',
    taskType: 'GRAMMAR',
    prompt: 'Last year, she [ GO ] to London.',
    wrongAnswer: 'gone',
    correctAnswer: 'went',
    explanation: 'Past Simple marker.',
    masteryStreak: 1,
    isResolved: false,
    lastAttemptAt: DateTime(2026, 11, 23),
  );

  setUp(() {
    mockRepository = MockMistakesRepository();
  });

  group('MistakesBloc Tests', () {
    test('initial state is MistakesInitial', () {
      final bloc = MistakesBloc(repository: mockRepository);
      expect(bloc.state, const MistakesInitial());
    });

    blocTest<MistakesBloc, MistakesState>(
      'emits [MistakesLoading, MistakesLoaded] when LoadMistakes succeeds',
      build: () {
        when(() => mockRepository.getAllMistakes())
            .thenAnswer((_) async => Result.success([sampleMistake]));
        return MistakesBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadMistakes()),
      expect: () => [
        const MistakesLoading(),
        MistakesLoaded(
          allMistakes: [sampleMistake],
          unresolvedMistakes: [sampleMistake],
        ),
      ],
    );

    blocTest<MistakesBloc, MistakesState>(
      'records attempt and reloads mistakes',
      build: () {
        when(() => mockRepository.recordPracticeAttempt(id: 'mst_01', isCorrect: true))
            .thenAnswer((_) async => const Result.success(null));
        when(() => mockRepository.getAllMistakes())
            .thenAnswer((_) async => Result.success([sampleMistake]));
        return MistakesBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const RecordMistakeAttempt(id: 'mst_01', isCorrect: true)),
      verify: (_) {
        verify(() => mockRepository.recordPracticeAttempt(id: 'mst_01', isCorrect: true)).called(1);
      },
      expect: () => [
        MistakesLoaded(
          allMistakes: [sampleMistake],
          unresolvedMistakes: [sampleMistake],
        ),
      ],
    );
  });
}
