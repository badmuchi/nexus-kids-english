import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/vpr/domain/entities/vpr_task_entity.dart';
import 'package:english_for_children/features/vpr/domain/repositories/vpr_repository.dart';
import 'package:english_for_children/features/vpr/presentation/vpr_bloc.dart';
import 'package:english_for_children/features/vpr/presentation/vpr_event.dart';
import 'package:english_for_children/features/vpr/presentation/vpr_state.dart';

class MockVprRepository extends Mock implements VprRepository {}

void main() {
  late MockVprRepository mockRepo;

  setUp(() {
    mockRepo = MockVprRepository();
  });

  const testTask = VprTaskEntity(
    id: 'vpr_1',
    grade: 5,
    taskNumber: 4,
    taskType: VprTaskType.grammarVocab,
    title: 'Test Grammar',
    instructions: 'Test instructions',
    correctAnswer: 'went',
  );

  group('VprBloc Tests', () {
    test('initial state is VprInitial', () {
      final bloc = VprBloc(repository: mockRepo);
      expect(bloc.state, const VprInitial());
      bloc.close();
    });

    blocTest<VprBloc, VprState>(
      'emits [VprLoading, VprLoaded] when LoadVprTasksEvent succeeds',
      build: () {
        when(() => mockRepo.getTasksByGrade(5))
            .thenAnswer((_) async => const Result.success([testTask]));
        return VprBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadVprTasksEvent(grade: 5)),
      expect: () => [
        const VprLoading(),
        const VprLoaded(grade: 5, tasks: [testTask]),
      ],
    );

    blocTest<VprBloc, VprState>(
      'evaluates correct answer and marks task completed',
      build: () {
        when(() => mockRepo.markTaskCompleted('vpr_1'))
            .thenAnswer((_) async => const Result.success(null));
        return VprBloc(repository: mockRepo);
      },
      seed: () => const VprLoaded(grade: 5, tasks: [testTask]),
      act: (bloc) => bloc.add(
        const CheckVprAnswerEvent(
          taskId: 'vpr_1',
          userAnswer: 'went',
          expectedAnswer: 'went',
        ),
      ),
      verify: (bloc) {
        final state = bloc.state as VprLoaded;
        expect(state.feedbacks['vpr_1']?.isAccepted, isTrue);
        expect(state.tasks.first.isCompleted, isTrue);
        verify(() => mockRepo.markTaskCompleted('vpr_1')).called(1);
      },
    );
  });
}
