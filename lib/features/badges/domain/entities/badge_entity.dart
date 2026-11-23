import 'package:equatable/equatable.dart';

class BadgeEntity extends Equatable {
  final String id;
  final String title;
  final String description;
  final String icon;
  final String category;
  final bool isUnlocked;
  final DateTime? unlockedAt;

  const BadgeEntity({
    required this.id,
    required this.title,
    required this.description,
    required this.icon,
    required this.category,
    this.isUnlocked = false,
    this.unlockedAt,
  });

  @override
  List<Object?> get props => [id, title, description, icon, category, isUnlocked, unlockedAt];
}
