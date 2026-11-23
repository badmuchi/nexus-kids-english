import 'package:drift/drift.dart';
import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/srs_card_entity.dart';
import '../../domain/repositories/srs_repository.dart';

class DriftSrsRepository implements SrsRepository {
  final AppDatabase _db;

  DriftSrsRepository(this._db);

  @override
  Future<Result<List<SrsCardEntity>>> getAllCards() async {
    try {
      final rows = await _db.getAllSrsCards();
      final entities = rows.map(_mapRowToEntity).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load all SRS cards: $e', st));
    }
  }

  @override
  Future<Result<List<SrsCardEntity>>> getDueCards() async {
    try {
      final rows = await _db.getDueSrsCards();
      final entities = rows.map(_mapRowToEntity).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load due SRS cards: $e', st));
    }
  }

  @override
  Future<Result<void>> rateCard({
    required String cardId,
    required int rating,
  }) async {
    try {
      final all = await _db.getAllSrsCards();
      final target = all.firstWhere((c) => c.id == cardId);

      int newReps = target.reps + 1;
      int newLapses = target.lapses;
      int nextDays = 1;

      if (rating == 1) {
        newLapses += 1;
        newReps = 0;
        nextDays = 1;
      } else if (rating == 2) {
        nextDays = (newReps * 1).clamp(1, 4);
      } else if (rating == 3) {
        nextDays = (newReps * 3).clamp(2, 14);
      } else {
        nextDays = (newReps * 6).clamp(4, 30);
      }

      final nextDue = DateTime.now().add(Duration(days: nextDays));

      await _db.updateSrsCard(
        SrsCardsCompanion(
          id: Value(target.id),
          frontEnglish: Value(target.frontEnglish),
          backRussian: Value(target.backRussian),
          transcriptionIpa: Value(target.transcriptionIpa),
          level: Value(target.level),
          category: Value(target.category),
          exampleSentence: Value(target.exampleSentence),
          exampleTranslation: Value(target.exampleTranslation),
          fsrsState: Value(rating == 1 ? 'learning' : 'review'),
          reps: Value(newReps),
          lapses: Value(newLapses),
          dueAt: Value(nextDue),
          lastReviewedAt: Value(DateTime.now()),
        ),
      );

      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to rate card $cardId: $e', st));
    }
  }

  SrsCardEntity _mapRowToEntity(SrsCardRow row) {
    return SrsCardEntity(
      id: row.id,
      frontEnglish: row.frontEnglish,
      backRussian: row.backRussian,
      transcriptionIpa: row.transcriptionIpa,
      level: row.level,
      category: row.category,
      exampleSentence: row.exampleSentence,
      exampleTranslation: row.exampleTranslation,
      fsrsState: row.fsrsState,
      stability: row.stability,
      difficulty: row.difficulty,
      reps: row.reps,
      lapses: row.lapses,
      dueAt: row.dueAt,
      lastReviewedAt: row.lastReviewedAt,
    );
  }
}
