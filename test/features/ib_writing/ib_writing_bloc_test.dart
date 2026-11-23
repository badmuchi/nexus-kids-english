import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/ib_writing/domain/entities/ib_writing_entity.dart';
import 'package:english_for_children/features/ib_writing/domain/repositories/ib_writing_repository.dart';
import 'package:english_for_children/features/ib_writing/presentation/ib_writing_bloc.dart';
import 'package:english_for_children/features/ib_writing/presentation/ib_writing_event.dart';
import 'package:english_for_children/features/ib_writing/presentation/ib_writing_state.dart';

class MockIbWritingRepository extends Mock implements IbWritingRepository {}

void main() {
  late MockIbWritingRepository mockRepo;

  setUp(() {
    mockRepo = MockIbWritingRepository();
  });

  const testTask = IbWritingTaskEntity(
    id: 'write_01',
    format: 'Informal Email',
    title: 'Email to Alex',
    globalContext: 'Sustainability',
    instructions: 'Write an email',
    minWords: 80,
    maxWords: 120,
    requiredPrompts: ['Greeting'],
    sampleTemplate: 'Dear Alex,\n\nI hope you are well.',
  );

  group('IbWritingBloc Tests', () {
    test('initial state is IbWritingInitial', () {
      final bloc = IbWritingBloc(repository: mockRepo);
      expect(bloc.state, const IbWritingInitial());
      bloc.close();
    });

    blocTest<IbWritingBloc, IbWritingState>(
      'emits [IbWritingLoading, IbWritingLoaded] on LoadIbWritingTasksEvent',
      build: () {
        when(() => mockRepo.getAllTasks())
            .thenAnswer((_) async => const Result.success([testTask]));
        return IbWritingBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadIbWritingTasksEvent()),
      expect: () => [
        const IbWritingLoading(),
        const IbWritingLoaded(
          tasks: [testTask],
          selectedTaskId: 'write_01',
          currentText: '',
        ),
      ],
    );

    blocTest<IbWritingBloc, IbWritingState>(
      'analyzes text in real-time and detects cohesive devices',
      build: () => IbWritingBloc(repository: mockRepo),
      seed: () => const IbWritingLoaded(tasks: [testTask], selectedTaskId: 'write_01'),
      act: (bloc) => bloc.add(const AnalyzeTextEvent(
        taskId: 'write_01',
        text: 'Furthermore, we must protect nature. However, plastic waste is growing fast.',
      )),
      expect: () => [
        isA<IbWritingLoaded>()
            .having((s) => s.analysis?.wordCount, 'wordCount', 11)
            .having((s) => s.analysis?.uniqueCategoriesCount, 'uniqueCategoriesCount', 2),
      ],
    );
  });
}
