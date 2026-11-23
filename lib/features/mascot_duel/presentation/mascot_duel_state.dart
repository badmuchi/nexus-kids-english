import 'package:equatable/equatable.dart';
import '../domain/entities/duel_question_entity.dart';

sealed class MascotDuelState extends Equatable {
  const MascotDuelState();

  @override
  List<Object?> get props => [];
}

final class MascotDuelInitial extends MascotDuelState {
  const MascotDuelInitial();
}

final class MascotDuelLoading extends MascotDuelState {
  const MascotDuelLoading();
}

final class MascotDuelInProgress extends MascotDuelState {
  final List<DuelQuestionEntity> questions;
  final int currentQuestionIndex;
  final int userScore;
  final int sparkyScore;
  final int secondsRemaining;
  final int? lastChosenIndex;
  final bool? lastIsCorrect;

  const MascotDuelInProgress({
    required this.questions,
    required this.currentQuestionIndex,
    required this.userScore,
    required this.sparkyScore,
    required this.secondsRemaining,
    this.lastChosenIndex,
    this.lastIsCorrect,
  });

  DuelQuestionEntity get currentQuestion => questions[currentQuestionIndex % questions.length];

  MascotDuelInProgress copyWith({
    List<DuelQuestionEntity>? questions,
    int? currentQuestionIndex,
    int? userScore,
    int? sparkyScore,
    int? secondsRemaining,
    int? lastChosenIndex,
    bool? lastIsCorrect,
    bool clearChoice = false,
  }) {
    return MascotDuelInProgress(
      questions: questions ?? this.questions,
      currentQuestionIndex: currentQuestionIndex ?? this.currentQuestionIndex,
      userScore: userScore ?? this.userScore,
      sparkyScore: sparkyScore ?? this.sparkyScore,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      lastChosenIndex: clearChoice ? null : (lastChosenIndex ?? this.lastChosenIndex),
      lastIsCorrect: clearChoice ? null : (lastIsCorrect ?? this.lastIsCorrect),
    );
  }

  @override
  List<Object?> get props => [
        questions,
        currentQuestionIndex,
        userScore,
        sparkyScore,
        secondsRemaining,
        lastChosenIndex,
        lastIsCorrect,
      ];
}

final class MascotDuelFinished extends MascotDuelState {
  final int userScore;
  final int sparkyScore;
  final bool isUserWinner;
  final bool isDraw;
  final int xpEarned;

  const MascotDuelFinished({
    required this.userScore,
    required this.sparkyScore,
    required this.isUserWinner,
    this.isDraw = false,
    required this.xpEarned,
  });

  @override
  List<Object?> get props => [userScore, sparkyScore, isUserWinner, isDraw, xpEarned];
}

final class MascotDuelErrorState extends MascotDuelState {
  final String message;
  const MascotDuelErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
