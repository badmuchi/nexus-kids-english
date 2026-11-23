import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/ib_writing_entity.dart';
import '../../domain/repositories/ib_writing_repository.dart';

class LocalIbWritingRepository implements IbWritingRepository {
  List<IbWritingTaskEntity>? _cached;
  final Map<String, (String text, double score)> _savedDrafts = {};

  @override
  Future<Result<List<IbWritingTaskEntity>>> getAllTasks() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/ib_writing_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          final prompts = (item['requiredPrompts'] as List).map((p) => p.toString()).toList();
          final id = item['id'] as String;

          return IbWritingTaskEntity(
            id: id,
            format: item['format'] as String,
            title: item['title'] as String,
            globalContext: item['globalContext'] as String,
            instructions: item['instructions'] as String,
            minWords: item['minWords'] as int,
            maxWords: item['maxWords'] as int,
            requiredPrompts: prompts,
            sampleTemplate: item['sampleTemplate'] as String,
            savedText: _savedDrafts[id]?.$1,
            scoreOutOf8: _savedDrafts[id]?.$2,
            isCompleted: _savedDrafts.containsKey(id),
          );
        }).toList();
      }

      final result = _cached!.map((t) {
        final saved = _savedDrafts[t.id];
        return t.copyWith(
          savedText: saved?.$1,
          scoreOutOf8: saved?.$2,
          isCompleted: saved != null,
        );
      }).toList();

      return Result.success(result);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить задания IB Writing: $e', st));
    }
  }

  @override
  Future<Result<void>> saveWritingDraft(String taskId, String text, double scoreOutOf8) async {
    _savedDrafts[taskId] = (text, scoreOutOf8);
    return const Result.success(null);
  }
}
