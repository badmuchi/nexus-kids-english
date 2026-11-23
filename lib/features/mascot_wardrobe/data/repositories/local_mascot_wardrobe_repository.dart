import 'dart:convert';
import 'package:flutter/services.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/result/result.dart';
import '../../domain/entities/mascot_accessory_entity.dart';
import '../../domain/repositories/mascot_wardrobe_repository.dart';

class LocalMascotWardrobeRepository implements MascotWardrobeRepository {
  List<MascotAccessoryEntity>? _accessories;
  List<BadgeEntity>? _badges;
  String? _equippedHatId = 'acc_headphones';

  @override
  Future<Result<List<MascotAccessoryEntity>>> getAccessories() async {
    try {
      if (_accessories == null) {
        final raw = await rootBundle.loadString('assets/seed/mascot_rewards_seed.json');
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final accList = data['accessories'] as List;
        _accessories = accList.map((item) {
          final id = item['id'] as String;
          return MascotAccessoryEntity(
            id: id,
            name: item['name'] as String,
            emoji: item['emoji'] as String,
            slot: item['slot'] as String,
            costXp: item['costXp'] as int,
            description: item['description'] as String,
            isUnlocked: item['isUnlocked'] as bool? ?? false,
            isEquipped: id == _equippedHatId,
          );
        }).toList();
      }
      final result = _accessories!.map((a) {
        return a.copyWith(isEquipped: a.id == _equippedHatId);
      }).toList();
      return Result.success(result);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить гардероб Спарки: $e', st));
    }
  }

  @override
  Future<Result<List<BadgeEntity>>> getBadges() async {
    try {
      if (_badges == null) {
        final raw = await rootBundle.loadString('assets/seed/mascot_rewards_seed.json');
        final data = jsonDecode(raw) as Map<String, dynamic>;
        final badgeList = data['badges'] as List;
        _badges = badgeList.map((item) {
          return BadgeEntity(
            id: item['id'] as String,
            title: item['title'] as String,
            emoji: item['emoji'] as String,
            description: item['description'] as String,
            isUnlocked: item['isUnlocked'] as bool? ?? false,
          );
        }).toList();
      }
      return Result.success(_badges!);
    } catch (e, st) {
      return Result.failure(DatabaseFailure('Не удалось загрузить бейджи: $e', st));
    }
  }

  @override
  Future<Result<void>> equipAccessory(String id) async {
    if (_equippedHatId == id) {
      _equippedHatId = null; // unequip
    } else {
      _equippedHatId = id;
    }
    return const Result.success(null);
  }

  @override
  Future<Result<void>> unlockAccessory(String id) async {
    if (_accessories != null) {
      final index = _accessories!.indexWhere((a) => a.id == id);
      if (index != -1) {
        _accessories![index] = _accessories![index].copyWith(isUnlocked: true);
      }
    }
    return const Result.success(null);
  }
}
