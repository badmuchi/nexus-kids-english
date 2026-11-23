import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/verbs_arena/domain/entities/irregular_verb_entity.dart';
import 'package:english_for_children/features/verbs_arena/domain/repositories/verbs_repository.dart';
import 'package:english_for_children/features/verbs_arena/presentation/verbs_bloc.dart';
import 'package:english_for_children/features/verbs_arena/presentation/verbs_event.dart';
import 'package:english_for_children/features/verbs_arena/presentation/verbs_state.dart';

class MockVerbsRepository extends Mock implements VerbsRepository {}

void main() {
  late MockVerbsRepository mockRepo;

  setUp(() {
    mockRepo = MockVerbsRepository();
  });

  const testVerb = IrregularVerbEntity(
    id: 'v_buy',
    v1: 'buy',
    v2: 'bought',
    v3: 'bought',
    translation: 'покупать',
    rhymeGroup: 'Ought-Family',
    exampleSentence: 'I bought a book.',
  );

  group('VerbsBloc Tests', () {
    test('initial state is VerbsInitial', () {
      final bloc = VerbsBloc(repository: mockRepo);
      expect(bloc.state, const VerbsInitial());
      bloc.close();
    });

    blocTest<VerbsBloc, VerbsState>(
      'emits [VerbsLoading, VerbsLoaded] on LoadAllVerbsEvent',
      build: () {
        when(() => mockRepo.getAllVerbs()).thenAnswer((_) async => const Result.success([testVerb]));
        return VerbsBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadAllVerbsEvent()),
      expect: () => [
        const VerbsLoading(),
        const VerbsLoaded(
          allVerbs: [testVerb],
          displayedVerbs: [testVerb],
          rhymeGroups: ['Все', 'Ought-Family'],
          selectedGroup: 'Все',
        ),
      ],
    );

    blocTest<VerbsBloc, VerbsState>(
      'filters verbs correctly by rhyme group',
      build: () => VerbsBloc(repository: mockRepo),
      seed: () => const VerbsLoaded(
        allVerbs: [testVerb],
        displayedVerbs: [testVerb],
        rhymeGroups: ['Все', 'Ought-Family'],
        selectedGroup: 'Все',
      ),
      act: (bloc) => bloc.add(const FilterVerbsByRhymeEvent('Ought-Family')),
      expect: () => [
        const VerbsLoaded(
          allVerbs: [testVerb],
          displayedVerbs: [testVerb],
          rhymeGroups: ['Все', 'Ought-Family'],
          selectedGroup: 'Ought-Family',
        ),
      ],
    );
  });
}
