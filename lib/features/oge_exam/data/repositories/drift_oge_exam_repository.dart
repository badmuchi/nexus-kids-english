import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/oge_exam_entity.dart';
import '../../domain/repositories/oge_exam_repository.dart';

class DriftOgeExamRepository implements OgeExamRepository {
  final AppDatabase _db;

  DriftOgeExamRepository(this._db);

  @override
  Future<Result<List<ListeningQuestionItem>>> getListeningTasks1_4() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/oge_listening_seed.json');
      final list = jsonDecode(raw) as List;
      final part1 = list.firstWhere((e) => e['part'] == 'tasks_1_4');
      final items = (part1['items'] as List).map((i) {
        return ListeningQuestionItem(
          id: i['id'] as String,
          question: i['question'] as String,
          options: (i['options'] as List).cast<String>(),
          correctIndex: i['correctIndex'] as int,
          explanation: i['explanation'] as String,
        );
      }).toList();
      return Result.success(items);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load listening tasks 1-4: $e', st));
    }
  }

  @override
  Future<Result<List<ListeningTableField>>> getListeningTableTasks6_11() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/oge_listening_seed.json');
      final list = jsonDecode(raw) as List;
      final part6 = list.firstWhere((e) => e['part'] == 'tasks_6_11');
      final items = (part6['tableFields'] as List).map((i) {
        return ListeningTableField(
          id: i['id'] as String,
          field: i['field'] as String,
          correct: i['correct'] as String,
          acceptable: (i['acceptable'] as List).cast<String>(),
        );
      }).toList();
      return Result.success(items);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load listening table tasks 6-11: $e', st));
    }
  }

  @override
  Future<Result<List<ReadingHeadingParagraph>>> getReadingHeadingsParagraphs() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/oge_reading_seed.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final task12 = json['task12Headings'] as Map<String, dynamic>;
      final paragraphs = (task12['paragraphs'] as List).map((p) {
        return ReadingHeadingParagraph(
          letter: p['letter'] as String,
          text: p['text'] as String,
          correctHeadingId: p['correctHeadingId'] as String,
        );
      }).toList();
      return Result.success(paragraphs);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load reading headings paragraphs: $e', st));
    }
  }

  @override
  Future<Result<List<Map<String, String>>>> getReadingHeadingsOptions() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/oge_reading_seed.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final task12 = json['task12Headings'] as Map<String, dynamic>;
      final headings = (task12['headings'] as List).map((h) {
        return {
          'id': h['id'] as String,
          'text': h['text'] as String,
        };
      }).toList();
      return Result.success(headings);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load reading headings options: $e', st));
    }
  }

  @override
  Future<Result<List<ReadingTrueFalseItem>>> getReadingTrueFalseItems() async {
    try {
      final raw = await rootBundle.loadString('assets/seed/oge_reading_seed.json');
      final json = jsonDecode(raw) as Map<String, dynamic>;
      final tfSection = json['tasks13_19TrueFalse'] as Map<String, dynamic>;
      final questions = (tfSection['questions'] as List).map((q) {
        return ReadingTrueFalseItem(
          id: q['id'] as String,
          statement: q['statement'] as String,
          correct: q['correct'] as String,
          proofSentence: q['proofSentence'] as String,
          explanation: q['explanation'] as String,
        );
      }).toList();
      return Result.success(questions);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load reading True/False items: $e', st));
    }
  }

  @override
  Future<Result<void>> saveExamResult(ExamResultSummary summary) async {
    try {
      await _db.recordExamAttempt(
        ExamAttemptsCompanion.insert(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          scoreOutOf68: summary.totalScore,
          gradeMark: summary.gradeMark,
          durationSeconds: summary.durationSeconds,
          completedAt: DateTime.now(),
        ),
      );
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to save exam attempt: $e', st));
    }
  }

  @override
  Future<Result<List<ExamResultSummary>>> getRecentExamResults() async {
    try {
      final rows = await _db.getRecentExamAttempts();
      final list = rows.map((r) => ExamResultSummary(
            listeningScore: 12,
            readingScore: 11,
            grammarScore: 14,
            emailScore: 10,
            speakingScore: 13,
            totalScore: r.scoreOutOf68,
            gradeMark: r.gradeMark,
            durationSeconds: r.durationSeconds,
          )).toList();
      return Result.success(list);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to get recent exam results: $e', st));
    }
  }
}
