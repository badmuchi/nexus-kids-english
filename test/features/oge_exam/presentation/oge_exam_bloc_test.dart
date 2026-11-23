import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/oge_exam/domain/entities/oge_exam_entity.dart';
import 'package:english_for_children/features/oge_exam/domain/repositories/oge_exam_repository.dart';
import 'package:english_for_children/features/oge_exam/presentation/oge_exam_bloc.dart';
import 'package:english_for_children/features/oge_exam/presentation/oge_exam_event.dart';
import 'package:english_for_children/features/oge_exam/presentation/oge_exam_state.dart';

class MockOgeExamRepository extends Mock implements OgeExamRepository {}

void main() {
  late MockOgeExamRepository mockRepository;

  setUpAll(() {
    registerFallbackValue(const ExamResultSummary(
      listeningScore: 10,
      readingScore: 10,
      grammarScore: 14,
      emailScore: 10,
      speakingScore: 14,
      totalScore: 58,
      gradeMark: 4,
      durationSeconds: 100,
    ));
  });

  const sampleListening = ListeningQuestionItem(
    id: 'l1',
    question: 'Where is Dialogue A?',
    options: ['Airport', 'Cinema', 'Shop'],
    correctIndex: 0,
    explanation: 'Boarding pass',
  );

  const sampleTf = ReadingTrueFalseItem(
    id: 'q13',
    statement: 'Bioluminescence is cold light.',
    correct: 'TRUE',
    proofSentence: 'It is cold light with 100% efficiency.',
    explanation: 'Text says cold light',
  );

  setUp(() {
    mockRepository = MockOgeExamRepository();
  });

  group('OgeExamBloc Tests', () {
    test('initial state is OgeExamInitial', () {
      final bloc = OgeExamBloc(repository: mockRepository);
      expect(bloc.state, const OgeExamInitial());
    });

    blocTest<OgeExamBloc, OgeExamState>(
      'loads full exam materials on StartFullExamEvent',
      build: () {
        when(() => mockRepository.getListeningTasks1_4())
            .thenAnswer((_) async => const Result.success([sampleListening]));
        when(() => mockRepository.getListeningTableTasks6_11())
            .thenAnswer((_) async => const Result.success([]));
        when(() => mockRepository.getReadingHeadingsParagraphs())
            .thenAnswer((_) async => const Result.success([]));
        when(() => mockRepository.getReadingHeadingsOptions())
            .thenAnswer((_) async => const Result.success([]));
        when(() => mockRepository.getReadingTrueFalseItems())
            .thenAnswer((_) async => const Result.success([sampleTf]));
        return OgeExamBloc(repository: mockRepository);
      },
      act: (bloc) => bloc.add(const StartFullExamEvent()),
      expect: () => [
        const OgeExamLoading(),
        const OgeExamInProgress(
          listeningTasks1_4: [sampleListening],
          listeningTable6_11: [],
          readingParagraphs: [],
          readingHeadings: [],
          readingTrueFalse: [sampleTf],
        ),
      ],
    );

    blocTest<OgeExamBloc, OgeExamState>(
      'completes exam, calculates mark 5 (59+ pts) and saves result',
      build: () {
        when(() => mockRepository.saveExamResult(any()))
            .thenAnswer((_) async => const Result.success(null));
        return OgeExamBloc(repository: mockRepository);
      },
      seed: () => const OgeExamInProgress(
        listeningTasks1_4: [sampleListening],
        listeningTable6_11: [],
        readingParagraphs: [],
        readingHeadings: [],
        readingTrueFalse: [sampleTf],
        selectedListeningAnswers: {'l1': 0},
        selectedTrueFalse: {'q13': 'TRUE'},
      ),
      act: (bloc) => bloc.add(const CompleteExamEvent()),
      expect: () => [
        isA<OgeExamFinished>().having(
          (s) => s.summary.gradeMark,
          'gradeMark',
          4, // 11 listening + 1 reading + 14 grammar + 10 email + 14 speaking = 50 (>=46 is 4)
        ),
      ],
      verify: (_) {
        verify(() => mockRepository.saveExamResult(any())).called(1);
      },
    );
  });
}
