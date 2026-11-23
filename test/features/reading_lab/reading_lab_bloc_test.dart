import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/reading_lab/domain/entities/reading_story_entity.dart';
import 'package:english_for_children/features/reading_lab/domain/repositories/reading_lab_repository.dart';
import 'package:english_for_children/features/reading_lab/presentation/reading_lab_bloc.dart';
import 'package:english_for_children/features/reading_lab/presentation/reading_lab_event.dart';
import 'package:english_for_children/features/reading_lab/presentation/reading_lab_state.dart';

class MockReadingLabRepository extends Mock implements ReadingLabRepository {}

void main() {
  late MockReadingLabRepository mockRepo;

  setUp(() {
    mockRepo = MockReadingLabRepository();
  });

  const testStory = ReadingStoryEntity(
    id: 'story_01',
    title: 'The Clock Tower',
    grade: 5,
    theme: 'Adventure',
    coverEmoji: '🕰️',
    summary: 'A secret key',
    paragraphs: ['Paragraph one.', 'Paragraph two.'],
    glossary: [GlossaryItem(word: 'key', ipa: '[kiː]', meaning: 'ключ')],
    questions: [
      ComprehensionQuestion(
        question: 'What is this?',
        options: ['A key', 'A door'],
        correctIndex: 0,
        explanation: 'It is a key.',
      ),
    ],
  );

  group('ReadingLabBloc Tests', () {
    test('initial state is ReadingLabInitial', () {
      final bloc = ReadingLabBloc(repository: mockRepo);
      expect(bloc.state, const ReadingLabInitial());
      bloc.close();
    });

    blocTest<ReadingLabBloc, ReadingLabState>(
      'emits [ReadingLabLoading, ReadingLabLoaded] on LoadReadingStoriesEvent',
      build: () {
        when(() => mockRepo.getAllStories())
            .thenAnswer((_) async => const Result.success([testStory]));
        return ReadingLabBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const LoadReadingStoriesEvent()),
      expect: () => [
        const ReadingLabLoading(),
        const ReadingLabLoaded(
          allStories: [testStory],
          displayedStories: [testStory],
        ),
      ],
    );

    blocTest<ReadingLabBloc, ReadingLabState>(
      'filters stories by grade properly',
      build: () => ReadingLabBloc(repository: mockRepo),
      seed: () => const ReadingLabLoaded(
        allStories: [testStory],
        displayedStories: [testStory],
      ),
      act: (bloc) => bloc.add(const FilterStoriesByGradeEvent(6)),
      expect: () => [
        const ReadingLabLoaded(
          allStories: [testStory],
          displayedStories: [],
          selectedGrade: 6,
        ),
      ],
    );
  });
}
