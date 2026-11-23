import '../../../../core/result/result.dart';
import '../entities/mascot_accessory_entity.dart';

abstract class MascotWardrobeRepository {
  Future<Result<List<MascotAccessoryEntity>>> getAccessories();
  Future<Result<List<BadgeEntity>>> getBadges();
  Future<Result<void>> equipAccessory(String id);
  Future<Result<void>> unlockAccessory(String id);
}
