import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/reading_story_entity.dart';
import '../../domain/repositories/reading_lab_repository.dart';

class LocalReadingLabRepository implements ReadingLabRepository {
  List<ReadingStoryEntity>? _cached;
  final Map<String, int> _scores = {};

  @override
  Future<Result<List<ReadingStoryEntity>>> getAllStories() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/reading_lab_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          final id = item['id'] as String;
          final paragraphs = (item['paragraphs'] as List).map((p) => p.toString()).toList();
          final glossary = (item['glossary'] as List).map((g) {
            return GlossaryItem(
              word: g['word'] as String,
              ipa: g['ipa'] as String,
              meaning: g['meaning'] as String,
            );
          }).toList();

          final questions = (item['questions'] as List).map((q) {
            final opts = (q['options'] as List).map((o) => o.toString()).toList();
            return ComprehensionQuestion(
              question: q['question'] as String,
              options: opts,
              correctIndex: q['correctIndex'] as int,
              explanation: q['explanation'] as String,
            );
          }).toList();

          return ReadingStoryEntity(
            id: id,
            title: item['title'] as String,
            grade: item['grade'] as int,
            theme: item['theme'] as String,
            coverEmoji: item['coverEmoji'] as String,
            summary: item['summary'] as String,
            paragraphs: paragraphs,
            glossary: glossary,
            questions: questions,
            isCompleted: _scores.containsKey(id),
            quizScore: _scores[id],
          );
        }).toList();
      }

      final result = _cached!.map((s) {
        return s.copyWith(
          isCompleted: _scores.containsKey(s.id),
          quizScore: _scores[s.id],
        );
      }).toList();

      return Result.success(result);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить истории для чтения: $e', st));
    }
  }

  @override
  Future<Result<void>> saveQuizResult(String storyId, int score) async {
    _scores[storyId] = score;
    return const Result.success(null);
  }
}
