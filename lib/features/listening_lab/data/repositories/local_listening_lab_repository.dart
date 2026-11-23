import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/minimal_pair_entity.dart';
import '../../domain/repositories/listening_lab_repository.dart';

class LocalListeningLabRepository implements ListeningLabRepository {
  List<MinimalPairEntity>? _cached;

  @override
  Future<Result<List<MinimalPairEntity>>> getAllPairs() async {
    try {
      if (_cached == null) {
        final raw = await rootBundle.loadString('assets/seed/minimal_pairs_seed.json');
        final list = jsonDecode(raw) as List;
        _cached = list.map((item) {
          return MinimalPairEntity(
            id: item['id'] as String,
            wordA: item['wordA'] as String,
            wordB: item['wordB'] as String,
            ipaA: item['ipaA'] as String,
            ipaB: item['ipaB'] as String,
            meaningA: item['meaningA'] as String,
            meaningB: item['meaningB'] as String,
            soundFocus: item['soundFocus'] as String,
            tip: item['tip'] as String,
          );
        }).toList();
      }
      return Result.success(_cached!);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить минимальные пары: $e', st));
    }
  }
}
