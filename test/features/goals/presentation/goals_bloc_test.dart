import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/goals/domain/entities/study_goal_entity.dart';
import 'package:english_for_children/features/goals/domain/repositories/goals_repository.dart';
import 'package:english_for_children/features/goals/presentation/goals_bloc.dart';
import 'package:english_for_children/features/goals/presentation/goals_event.dart';
import 'package:english_for_children/features/goals/presentation/goals_state.dart';

class MockGoalsRepository extends Mock implements GoalsRepository {}

void main() {
  late MockGoalsRepository mockRepository;

  const sampleGoal = StudyGoalEntity(
    id: 'goal_001',
    title: 'ОГЭ: 68 баллов',
    description: 'Пройти все разделы',
    category: 'OGE',
    targetValue: 68,
    currentValue: 45,
    unit: 'баллов',
    deadlineDays: 180,
    isPrimary: true,
  );

  setUp(() {
    mockRepository = MockGoalsRepository();
  });

  group('GoalsBloc Tests', () {
    test('initial state is GoalsInitial', () {
      final bloc = GoalsBloc(repository: mockRepository);
      expect(bloc.state, const GoalsInitial());
    });

    blocTest<GoalsBloc, GoalsState>(
      'emits [GoalsLoading, GoalsLoaded] when LoadGoalsEvent succeeds',
      build: () {
        when(() => mockRepository.getGoals())
            .thenAnswer((_) async => const Result.success([sampleGoal]));
        return GoalsBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const LoadGoalsEvent()),
      expect: () => [
        const GoalsLoading(),
        const GoalsLoaded([sampleGoal]),
      ],
    );
  });
}
