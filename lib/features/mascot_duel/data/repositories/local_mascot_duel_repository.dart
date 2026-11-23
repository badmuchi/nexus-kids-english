import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/duel_question_entity.dart';
import '../../domain/repositories/mascot_duel_repository.dart';

class LocalMascotDuelRepository implements MascotDuelRepository {
  List<DuelQuestionEntity>? _cached;

  @override
  Future<Result<List<DuelQuestionEntity>>> getDuelQuestions() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/mascot_duel_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          final options = (item['options'] as List).map((o) => o.toString()).toList();
          return DuelQuestionEntity(
            id: item['id'] as String,
            prompt: item['prompt'] as String,
            options: options,
            correctIndex: item['correctIndex'] as int,
            type: item['type'] as String,
          );
        }).toList();
      }
      return Result.success(List.from(_cached!));
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить вопросы дуэли: $e', st));
    }
  }
}
