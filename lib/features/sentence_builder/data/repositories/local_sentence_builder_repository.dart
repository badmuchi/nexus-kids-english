import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/sentence_puzzle_entity.dart';
import '../../domain/repositories/sentence_builder_repository.dart';

class LocalSentenceBuilderRepository implements SentenceBuilderRepository {
  List<SentencePuzzleEntity>? _cached;

  @override
  Future<Result<List<SentencePuzzleEntity>>> getAllPuzzles() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/sentence_puzzles_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          final wordsList = (item['words'] as List).map((w) => w.toString()).toList();
          return SentencePuzzleEntity(
            id: item['id'] as String,
            grade: item['grade'] as int,
            grammarTopic: item['grammarTopic'] as String,
            translation: item['translation'] as String,
            words: wordsList,
            correctSentence: item['correctSentence'] as String,
            explanation: item['explanation'] as String,
          );
        }).toList();
      }
      return Result.success(_cached!);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить пазлы предложений: $e', st));
    }
  }

  @override
  Future<Result<List<SentencePuzzleEntity>>> getPuzzlesByGrade(int grade) async {
    final all = await getAllPuzzles();
    return switch (all) {
      Success(value: final list) => Result.success(list.where((p) => p.grade == grade).toList()),
      Failure(error: final err, stackTrace: final st) => Result.failure(err, st),
    };
  }
}
