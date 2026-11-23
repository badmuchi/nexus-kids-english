import '../../../../core/result/result.dart';
import '../../domain/entities/mistake_entity.dart';
import '../../domain/repositories/mistakes_repository.dart';

class DriftMistakesRepository implements MistakesRepository {
  final List<MistakeEntity> _mistakes = [
    MistakeEntity(
      id: 'mst_001',
      taskType: 'GRAMMAR',
      prompt: 'Last summer, our class [ TAKE ] a fascinating trip.',
      wrongAnswer: 'taken',
      correctAnswer: 'took',
      explanation: 'Маркер "last summer" требует Past Simple (V2), а не Past Participle (V3).',
      masteryStreak: 1,
      isResolved: false,
      lastAttemptAt: DateTime.now(),
    ),
    MistakeEntity(
      id: 'mst_002',
      taskType: 'WORD_FORMATION',
      prompt: 'Exploring deep underwater caves is almost [ POSSIBLE ] for divers.',
      wrongAnswer: 'unpossible',
      correctAnswer: 'impossible',
      explanation: 'Слова, начинающиеся на "p", образуют отрицание с приставкой im- (impossible), а не un-.',
      masteryStreak: 0,
      isResolved: false,
      lastAttemptAt: DateTime.now(),
    ),
    MistakeEntity(
      id: 'mst_003',
      taskType: 'GRAMMAR',
      prompt: 'If I [ HAVE ] more spare time, I would definitely learn how to play guitar.',
      wrongAnswer: 'will have',
      correctAnswer: 'had',
      explanation: 'В Conditionals Type 2 в придаточном предложении с if используется Past Simple (had).',
      masteryStreak: 2,
      isResolved: false,
      lastAttemptAt: DateTime.now(),
    ),
  ];

  DriftMistakesRepository([dynamic _]);

  @override
  Future<Result<List<MistakeEntity>>> getAllMistakes() async {
    return Result.success(List.unmodifiable(_mistakes));
  }

  @override
  Future<Result<List<MistakeEntity>>> getUnresolvedMistakes() async {
    final unresolved = _mistakes.where((m) => !m.isResolved).toList();
    return Result.success(unresolved);
  }

  @override
  Future<Result<void>> logMistake({
    required String id,
    required String taskType,
    required String prompt,
    required String wrongAnswer,
    required String correctAnswer,
    required String explanation,
  }) async {
    final idx = _mistakes.indexWhere((m) => m.id == id);
    final entity = MistakeEntity(
      id: id,
      taskType: taskType,
      prompt: prompt,
      wrongAnswer: wrongAnswer,
      correctAnswer: correctAnswer,
      explanation: explanation,
      masteryStreak: 0,
      isResolved: false,
      lastAttemptAt: DateTime.now(),
    );

    if (idx >= 0) {
      _mistakes[idx] = entity;
    } else {
      _mistakes.add(entity);
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> recordPracticeAttempt({
    required String id,
    required bool isCorrect,
  }) async {
    final idx = _mistakes.indexWhere((m) => m.id == id);
    if (idx >= 0) {
      final current = _mistakes[idx];
      final newStreak = isCorrect ? current.masteryStreak + 1 : 0;
      _mistakes[idx] = current.copyWith(
        masteryStreak: newStreak,
        isResolved: newStreak >= 3,
        lastAttemptAt: DateTime.now(),
      );
    }
    return const Result.success(null);
  }
}
