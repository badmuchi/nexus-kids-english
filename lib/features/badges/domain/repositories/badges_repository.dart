import '../../../../core/result/result.dart';
import '../entities/badge_entity.dart';

abstract interface class BadgesRepository {
  Future<Result<List<BadgeEntity>>> getAllBadges();
  Future<Result<void>> unlockBadge(String badgeId);
}
