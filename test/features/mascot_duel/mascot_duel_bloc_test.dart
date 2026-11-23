import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:english_for_children/core/result/result.dart';
import 'package:english_for_children/features/mascot_duel/domain/entities/duel_question_entity.dart';
import 'package:english_for_children/features/mascot_duel/domain/repositories/mascot_duel_repository.dart';
import 'package:english_for_children/features/mascot_duel/presentation/mascot_duel_bloc.dart';
import 'package:english_for_children/features/mascot_duel/presentation/mascot_duel_event.dart';
import 'package:english_for_children/features/mascot_duel/presentation/mascot_duel_state.dart';

class MockMascotDuelRepository extends Mock implements MascotDuelRepository {}

void main() {
  late MockMascotDuelRepository mockRepo;

  setUp(() {
    mockRepo = MockMascotDuelRepository();
  });

  const testQuestion = DuelQuestionEntity(
    id: 'q01',
    prompt: 'V2 of buy',
    options: ['bought', 'buyed', 'brought', 'bout'],
    correctIndex: 0,
    type: 'irregular_verb',
  );

  group('MascotDuelBloc Tests', () {
    test('initial state is MascotDuelInitial', () {
      final bloc = MascotDuelBloc(repository: mockRepo);
      expect(bloc.state, const MascotDuelInitial());
      bloc.close();
    });

    blocTest<MascotDuelBloc, MascotDuelState>(
      'emits [MascotDuelLoading, MascotDuelInProgress] on StartDuelEvent',
      build: () {
        when(() => mockRepo.getDuelQuestions())
            .thenAnswer((_) async => const Result.success([testQuestion]));
        return MascotDuelBloc(repository: mockRepo);
      },
      act: (bloc) => bloc.add(const StartDuelEvent()),
      expect: () => [
        const MascotDuelLoading(),
        isA<MascotDuelInProgress>()
            .having((s) => s.questions.length, 'questions length', 1)
            .having((s) => s.secondsRemaining, 'secondsRemaining', 60),
      ],
    );

    blocTest<MascotDuelBloc, MascotDuelState>(
      'increases user score on correct answer',
      build: () => MascotDuelBloc(repository: mockRepo),
      seed: () => const MascotDuelInProgress(
        questions: [testQuestion],
        currentQuestionIndex: 0,
        userScore: 0,
        sparkyScore: 0,
        secondsRemaining: 55,
      ),
      act: (bloc) => bloc.add(const AnswerDuelQuestionEvent(0)),
      expect: () => [
        const MascotDuelInProgress(
          questions: [testQuestion],
          currentQuestionIndex: 0,
          userScore: 1,
          sparkyScore: 0,
          secondsRemaining: 55,
          lastChosenIndex: 0,
          lastIsCorrect: true,
        ),
      ],
    );

    blocTest<MascotDuelBloc, MascotDuelState>(
      'finishes duel when timer reaches 1',
      build: () => MascotDuelBloc(repository: mockRepo),
      seed: () => const MascotDuelInProgress(
        questions: [testQuestion],
        currentQuestionIndex: 0,
        userScore: 5,
        sparkyScore: 3,
        secondsRemaining: 1,
      ),
      act: (bloc) => bloc.add(const TickDuelTimerEvent()),
      expect: () => [
        const MascotDuelFinished(
          userScore: 5,
          sparkyScore: 3,
          isUserWinner: true,
          xpEarned: 100,
        ),
      ],
    );
  });
}
