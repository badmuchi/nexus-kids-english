import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/irregular_verb_entity.dart';
import '../../domain/repositories/verbs_repository.dart';

class LocalVerbsRepository implements VerbsRepository {
  List<IrregularVerbEntity>? _cached;

  @override
  Future<Result<List<IrregularVerbEntity>>> getAllVerbs() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/irregular_verbs_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          return IrregularVerbEntity(
            id: item['id'] as String,
            v1: item['v1'] as String,
            v2: item['v2'] as String,
            v3: item['v3'] as String,
            translation: item['translation'] as String,
            rhymeGroup: item['rhymeGroup'] as String,
            exampleSentence: item['exampleSentence'] as String,
          );
        }).toList();
      }
      return Result.success(_cached!);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить неправильные глаголы: $e', st));
    }
  }

  @override
  Future<Result<List<IrregularVerbEntity>>> getVerbsByRhyme(String rhymeGroup) async {
    final all = await getAllVerbs();
    return switch (all) {
      Success(value: final list) => Result.success(list.where((v) => v.rhymeGroup == rhymeGroup).toList()),
      Failure(error: final err, stackTrace: final st) => Result.failure(err, st),
    };
  }
}
