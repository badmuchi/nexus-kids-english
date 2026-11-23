import 'package:equatable/equatable.dart';

class MascotAccessoryEntity extends Equatable {
  final String id;
  final String name;
  final String emoji;
  final String slot; // 'hat', 'glasses'
  final int costXp;
  final String description;
  final bool isUnlocked;
  final bool isEquipped;

  const MascotAccessoryEntity({
    required this.id,
    required this.name,
    required this.emoji,
    required this.slot,
    required this.costXp,
    required this.description,
    this.isUnlocked = false,
    this.isEquipped = false,
  });

  MascotAccessoryEntity copyWith({
    String? id,
    String? name,
    String? emoji,
    String? slot,
    int? costXp,
    String? description,
    bool? isUnlocked,
    bool? isEquipped,
  }) {
    return MascotAccessoryEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      emoji: emoji ?? this.emoji,
      slot: slot ?? this.slot,
      costXp: costXp ?? this.costXp,
      description: description ?? this.description,
      isUnlocked: isUnlocked ?? this.isUnlocked,
      isEquipped: isEquipped ?? this.isEquipped,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        emoji,
        slot,
        costXp,
        description,
        isUnlocked,
        isEquipped,
      ];
}

class BadgeEntity extends Equatable {
  final String id;
  final String title;
  final String emoji;
  final String description;
  final bool isUnlocked;

  const BadgeEntity({
    required this.id,
    required this.title,
    required this.emoji,
    required this.description,
    this.isUnlocked = false,
  });

  @override
  List<Object?> get props => [id, title, emoji, description, isUnlocked];
}
