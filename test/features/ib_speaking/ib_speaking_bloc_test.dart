import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/ib_speaking/domain/entities/ib_speaking_entity.dart';
import 'package:english_for_children/features/ib_speaking/domain/repositories/ib_speaking_repository.dart';
import 'package:english_for_children/features/ib_speaking/presentation/ib_speaking_bloc.dart';
import 'package:english_for_children/features/ib_speaking/presentation/ib_speaking_event.dart';
import 'package:english_for_children/features/ib_speaking/presentation/ib_speaking_state.dart';

class MockIbSpeakingRepository extends Mock implements IbSpeakingRepository {}

void main() {
  late MockIbSpeakingRepository mockRepo;

  setUp(() {
    mockRepo = MockIbSpeakingRepository();
  });

  const testTask = IbSpeakingTaskEntity(
    id: 'speak_01',
    title: 'School Garden',
    globalContext: 'Sustainability',
    topic: 'Environment',
    imageEmoji: '🌱',
    description: 'Planting trees',
    guidingQuestions: ['What can you see?'],
    phraseBank: ['In the foreground...'],
    sampleAnswer: 'I can see students...',
  );

  group('IbSpeakingBloc Tests', () {
    test('initial state is IbSpeakingInitial', () {
      final bloc = IbSpeakingBloc(repository: mockRepo);
      expect(bloc.state, const IbSpeakingInitial());
      bloc.close();
    });

    blocTest<IbSpeakingBloc, IbSpeakingState>(
      'emits [IbSpeakingLoading, IbSpeakingLoaded] on LoadIbSpeakingTasksEvent',
      build: () {
        when(() => mockRepo.getAllTasks())
            .thenAnswer((_) async => const Result.success([testTask]));
        return IbSpeakingBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadIbSpeakingTasksEvent()),
      expect: () => [
        const IbSpeakingLoading(),
        const IbSpeakingLoaded(
          tasks: [testTask],
          selectedTaskId: 'speak_01',
        ),
      ],
    );

    blocTest<IbSpeakingBloc, IbSpeakingState>(
      'updates task score and marks completed on SubmitSpeakingScoreEvent',
      build: () {
        when(() => mockRepo.saveSpeakingResult('speak_01', 8))
            .thenAnswer((_) async => const Result.success(null));
        return IbSpeakingBloc(repository: mockRepo);
      },
      seed: () => const IbSpeakingLoaded(tasks: [testTask], selectedTaskId: 'speak_01'),
      act: (bloc) => bloc.add(const SubmitSpeakingScoreEvent(taskId: 'speak_01', scoreOutOf8: 8)),
      verify: (_) {
        verify(() => mockRepo.saveSpeakingResult('speak_01', 8)).called(1);
      },
      expect: () => [
        isA<IbSpeakingLoaded>()
            .having((s) => s.tasks.first.isCompleted, 'isCompleted', true)
            .having((s) => s.tasks.first.scoreOutOf8, 'scoreOutOf8', 8),
      ],
    );
  });
}
