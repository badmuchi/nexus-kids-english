import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/vpr_task_entity.dart';
import '../../domain/repositories/vpr_repository.dart';

class LocalVprRepository implements VprRepository {
  List<VprTaskEntity>? _cachedTasks;
  final Set<String> _completedIds = {};

  @override
  Future<Result<List<VprTaskEntity>>> getTasksByGrade(int grade) async {
    try {
      if (_cachedTasks == null) {
        final raw = await rootBundle.loadString('assets/seed/vpr_seed.json');
        final list = jsonDecode(raw) as List;
        _cachedTasks = list.map((item) {
          List<String> options = [];
          if (item['optionsJson'] != null) {
            try {
              final rawOpts = jsonDecode(item['optionsJson']);
              if (rawOpts is List) {
                options = rawOpts.map((e) => e.toString()).toList();
              }
            } catch (_) {}
          }

          return VprTaskEntity(
            id: item['id'] as String,
            grade: item['grade'] as int,
            taskNumber: item['taskNumber'] as int,
            taskType: VprTaskType.fromString(item['taskType'] as String),
            title: item['title'] as String,
            instructions: item['instructions'] as String,
            textPassage: item['textPassage'] as String?,
            options: options,
            correctAnswer: item['correctAnswer'] as String,
            explanation: item['explanation'] as String?,
            isCompleted: _completedIds.contains(item['id']),
          );
        }).toList();
      }

      final filtered = _cachedTasks!
          .where((t) => t.grade == grade)
          .map((t) => t.copyWith(isCompleted: _completedIds.contains(t.id)))
          .toList();

      return Result.success(filtered);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить задания ВПР: $e', st));
    }
  }

  @override
  Future<Result<void>> markTaskCompleted(String taskId) async {
    _completedIds.add(taskId);
    return const Result.success(null);
  }
}
