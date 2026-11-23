import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/oge_trainer/domain/entities/oge_task_entity.dart';
import 'package:english_for_children/features/oge_trainer/domain/repositories/oge_repository.dart';
import 'package:english_for_children/features/oge_trainer/presentation/oge_bloc.dart';
import 'package:english_for_children/features/oge_trainer/presentation/oge_event.dart';
import 'package:english_for_children/features/oge_trainer/presentation/oge_state.dart';

class MockOgeRepository extends Mock implements OgeRepository {}

void main() {
  late MockOgeRepository mockRepository;

  const sampleGrammarTask = OgeGrammarTaskEntity(
    id: 'og_001',
    baseWord: 'TAKE',
    sentenceBefore: 'Yesterday we',
    sentenceAfter: 'a trip.',
    correctAnswer: 'took',
    acceptableAnswers: ['took'],
    ruleCategory: 'Past Simple',
    ruleExplanation: 'Past Simple of irregular verb take is took',
    cefrLevel: 'A2',
  );

  setUp(() {
    mockRepository = MockOgeRepository();
  });

  group('OgeBloc Tests', () {
    test('initial state is OgeInitial', () {
      final bloc = OgeBloc(repository: mockRepository);
      expect(bloc.state, const OgeInitial());
    });

    blocTest<OgeBloc, OgeState>(
      'emits [OgeLoading, OgeGrammarActive] when LoadOgeGrammarTasksEvent succeeds',
      build: () {
        when(() => mockRepository.getGrammarTasks())
            .thenAnswer((_) async => const Result.success([sampleGrammarTask]));
        return OgeBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadOgeGrammarTasksEvent()),
      expect: () => [
        const OgeLoading(),
        const OgeGrammarActive(tasks: [sampleGrammarTask], currentIndex: 0),
      ],
    );

    blocTest<OgeBloc, OgeState>(
      'marks task completed and gives positive feedback on correct answer',
      build: () {
        when(() => mockRepository.markGrammarTaskCompleted(sampleGrammarTask.id))
            .thenAnswer((_) async => const Result.success(null));
        return OgeBloc(repository: mockRepository);
      },
      seed: () => const OgeGrammarActive(tasks: [sampleGrammarTask], currentIndex: 0),
      act: (bloc) => bloc.add(SubmitGrammarAnswerEvent(
        taskId: sampleGrammarTask.id,
        typedAnswer: 'took',
      )),
      expect: () => [
        const OgeGrammarActive(
          tasks: [sampleGrammarTask],
          currentIndex: 0,
          isAnswerChecked: true,
          isCorrect: true,
          feedback: 'Верно! Отличная трансформация.',
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.markGrammarTaskCompleted(sampleGrammarTask.id)).called(1);
      },
    );
  });
}
