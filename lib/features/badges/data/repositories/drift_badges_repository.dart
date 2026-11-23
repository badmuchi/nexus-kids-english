import '../../../../core/database/app_database.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/badge_entity.dart';
import '../../domain/repositories/badges_repository.dart';

class DriftBadgesRepository implements BadgesRepository {
  final AppDatabase _db;

  DriftBadgesRepository(this._db);

  @override
  Future<Result<List<BadgeEntity>>> getAllBadges() async {
    try {
      final rows = await _db.getAllBadges();
      final entities = rows.map((r) => BadgeEntity(
            id: r.id,
            title: r.title,
            description: r.description,
            icon: r.icon,
            category: r.category,
            isUnlocked: r.isUnlocked,
            unlockedAt: r.unlockedAt,
          )).toList();
      return Result.success(entities);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to load badges: $e', st));
    }
  }

  @override
  Future<Result<void>> unlockBadge(String badgeId) async {
    try {
      await _db.unlockBadge(badgeId);
      return const Result.success(null);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Failed to unlock badge $badgeId: $e', st));
    }
  }
}
