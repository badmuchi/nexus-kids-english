import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/features/listening_lab/domain/entities/minimal_pair_entity.dart';
import 'package:english_for_children/features/listening_lab/domain/repositories/listening_lab_repository.dart';
import 'package:english_for_children/features/listening_lab/presentation/listening_lab_bloc.dart';
import 'package:english_for_children/features/listening_lab/presentation/listening_lab_event.dart';
import 'package:english_for_children/features/listening_lab/presentation/listening_lab_state.dart';

class MockListeningLabRepository extends Mock implements ListeningLabRepository {}

void main() {
  late MockListeningLabRepository mockRepo;

  setUp(() {
    mockRepo = MockListeningLabRepository();
  });

  const testPair = MinimalPairEntity(
    id: 'pair_1',
    wordA: 'ship',
    wordB: 'sheep',
    ipaA: '[ʃɪp]',
    ipaB: '[ʃiːp]',
    meaningA: 'корабль',
    meaningB: 'овечка',
    soundFocus: '[ɪ] vs [iː]',
    tip: 'Long sound in sheep',
  );

  group('ListeningLabBloc Tests', () {
    test('initial state is ListeningLabInitial', () {
      final bloc = ListeningLabBloc(repository: mockRepo);
      expect(bloc.state, const ListeningLabInitial());
      bloc.close();
    });

    blocTest<ListeningLabBloc, ListeningLabState>(
      'evaluates correct choice and increases score',
      build: () => ListeningLabBloc(repository: mockRepo),
      seed: () => const ListeningLabActive(
        pairs: [testPair],
        currentIndex: 0,
        targetWord: 'sheep',
        score: 0,
      ),
      act: (bloc) => bloc.add(const SelectPairChoiceEvent('sheep')),
      expect: () => [
        const ListeningLabActive(
          pairs: [testPair],
          currentIndex: 0,
          targetWord: 'sheep',
          selectedChoice: 'sheep',
          isCorrect: true,
          score: 1,
        ),
      ],
    );
  });
}
