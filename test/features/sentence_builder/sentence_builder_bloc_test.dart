import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/features/sentence_builder/domain/entities/sentence_puzzle_entity.dart';
import 'package:english_for_children/features/sentence_builder/domain/repositories/sentence_builder_repository.dart';
import 'package:english_for_children/features/sentence_builder/presentation/sentence_builder_bloc.dart';
import 'package:english_for_children/features/sentence_builder/presentation/sentence_builder_event.dart';
import 'package:english_for_children/features/sentence_builder/presentation/sentence_builder_state.dart';

class MockSentenceBuilderRepository extends Mock implements SentenceBuilderRepository {}

void main() {
  late MockSentenceBuilderRepository mockRepo;

  setUp(() {
    mockRepo = MockSentenceBuilderRepository();
  });

  const testPuzzle = SentencePuzzleEntity(
    id: 'p1',
    grade: 5,
    grammarTopic: 'Present Simple',
    translation: 'Ты играешь?',
    words: ['Do', 'you', 'play?'],
    correctSentence: 'Do you play?',
    explanation: 'Do comes first',
  );

  group('SentenceBuilderBloc Tests', () {
    test('initial state is SentenceBuilderInitial', () {
      final bloc = SentenceBuilderBloc(repository: mockRepo);
      expect(bloc.state, const SentenceBuilderInitial());
      bloc.close();
    });

    blocTest<SentenceBuilderBloc, SentenceBuilderState>(
      'selects and deselects words properly',
      build: () => SentenceBuilderBloc(repository: mockRepo),
      seed: () => const SentenceBuilderActive(
        puzzles: [testPuzzle],
        currentIndex: 0,
        availableWords: ['Do', 'you', 'play?'],
        selectedWords: [],
      ),
      act: (bloc) {
        bloc.add(const SelectWordEvent('Do'));
        bloc.add(const SelectWordEvent('you'));
        bloc.add(const DeselectWordEvent(1)); // removes 'you'
      },
      expect: () => [
        const SentenceBuilderActive(
          puzzles: [testPuzzle],
          currentIndex: 0,
          availableWords: ['you', 'play?'],
          selectedWords: ['Do'],
        ),
        const SentenceBuilderActive(
          puzzles: [testPuzzle],
          currentIndex: 0,
          availableWords: ['play?'],
          selectedWords: ['Do', 'you'],
        ),
        const SentenceBuilderActive(
          puzzles: [testPuzzle],
          currentIndex: 0,
          availableWords: ['play?', 'you'],
          selectedWords: ['Do'],
        ),
      ],
    );

    blocTest<SentenceBuilderBloc, SentenceBuilderState>(
      'evaluates correct sentence assembly',
      build: () => SentenceBuilderBloc(repository: mockRepo),
      seed: () => const SentenceBuilderActive(
        puzzles: [testPuzzle],
        currentIndex: 0,
        availableWords: [],
        selectedWords: ['Do', 'you', 'play?'],
      ),
      act: (bloc) => bloc.add(const CheckSentenceEvent()),
      expect: () => [
        const SentenceBuilderActive(
          puzzles: [testPuzzle],
          currentIndex: 0,
          availableWords: [],
          selectedWords: ['Do', 'you', 'play?'],
          isCorrect: true,
          feedbackMessage: 'Блестяще! Порядок слов идеален! ⭐',
        ),
      ],
    );
  });
}
