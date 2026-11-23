import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/ib_speaking_entity.dart';
import '../../domain/repositories/ib_speaking_repository.dart';

class LocalIbSpeakingRepository implements IbSpeakingRepository {
  List<IbSpeakingTaskEntity>? _cached;
  final Map<String, int> _scores = {};

  @override
  Future<Result<List<IbSpeakingTaskEntity>>> getAllTasks() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/ib_speaking_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          final questions = (item['guidingQuestions'] as List).map((q) => q.toString()).toList();
          final phrases = (item['phraseBank'] as List).map((p) => p.toString()).toList();
          final id = item['id'] as String;

          return IbSpeakingTaskEntity(
            id: id,
            title: item['title'] as String,
            globalContext: item['globalContext'] as String,
            topic: item['topic'] as String,
            imageEmoji: item['imageEmoji'] as String,
            description: item['description'] as String,
            prepTimeSeconds: item['prepTimeSeconds'] as int? ?? 60,
            speakTimeSeconds: item['speakTimeSeconds'] as int? ?? 90,
            guidingQuestions: questions,
            phraseBank: phrases,
            sampleAnswer: item['sampleAnswer'] as String,
            isCompleted: _scores.containsKey(id),
            scoreOutOf8: _scores[id],
          );
        }).toList();
      }

      final result = _cached!.map((t) {
        return t.copyWith(
          isCompleted: _scores.containsKey(t.id),
          scoreOutOf8: _scores[t.id],
        );
      }).toList();

      return Result.success(result);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить задания IB Speaking: $e', st));
    }
  }

  @override
  Future<Result<void>> saveSpeakingResult(String taskId, int scoreOutOf8) async {
    _scores[taskId] = scoreOutOf8;
    return const Result.success(null);
  }
}
