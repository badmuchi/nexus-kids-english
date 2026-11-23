import 'dart:convert';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/oge_task_entity.dart';
import '../../domain/repositories/oge_repository.dart';

class DriftOgeRepository implements OgeRepository {
  final AppDatabase _db;

  DriftOgeRepository(this._db);

  @override
  Future<Result<List<OgeGrammarTaskEntity>>> getGrammarTasks() async {
    try {
      final rows = await _db.getAllGrammarTasks();
      final entities = rows.map((r) {
        final answers = (jsonDecode(r.acceptableAnswersJson) as List).cast<String>();
        return OgeGrammarTaskEntity(
          id: r.id,
          baseWord: r.baseWord,
          sentenceBefore: r.sentenceBefore,
          sentenceAfter: r.sentenceAfter,
          correctAnswer: r.correctAnswer,
          acceptableAnswers: answers,
          ruleCategory: r.ruleCategory,
          ruleExplanation: r.ruleExplanation,
          cefrLevel: r.cefrLevel,
          isCompleted: r.isCompleted,
        );
      }).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load OGE Grammar tasks: $e', st));
    }
  }

  @override
  Future<Result<void>> markGrammarTaskCompleted(String id) async {
    try {
      await _db.markGrammarTaskCompleted(id);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to mark grammar task completed: $e', st));
    }
  }

  @override
  Future<Result<List<OgeWordFormationTaskEntity>>> getWordFormationTasks() async {
    try {
      final rows = await _db.getAllWordFormationTasks();
      final entities = rows.map((r) {
        final answers = (jsonDecode(r.acceptableAnswersJson) as List).cast<String>();
        return OgeWordFormationTaskEntity(
          id: r.id,
          baseWord: r.baseWord,
          sentenceBefore: r.sentenceBefore,
          sentenceAfter: r.sentenceAfter,
          correctAnswer: r.correctAnswer,
          acceptableAnswers: answers,
          partOfSpeech: r.partOfSpeech,
          affix: r.affix,
          explanation: r.explanation,
          cefrLevel: r.cefrLevel,
          isCompleted: r.isCompleted,
        );
      }).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load OGE Word Formation tasks: $e', st));
    }
  }

  @override
  Future<Result<void>> markWordFormationTaskCompleted(String id) async {
    try {
      await _db.markWordFormationTaskCompleted(id);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to mark word formation task completed: $e', st));
    }
  }
}
