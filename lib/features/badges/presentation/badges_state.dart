import 'package:equatable/equatable.dart';
import '../domain/entities/badge_entity.dart';

sealed class BadgesState extends Equatable {
  const BadgesState();

  @override
  List<Object?> get props => [];
}

class BadgesInitial extends BadgesState {
  const BadgesInitial();
}

class BadgesLoading extends BadgesState {
  const BadgesLoading();
}

class BadgesLoaded extends BadgesState {
  final List<BadgeEntity> badges;

  const BadgesLoaded(this.badges);

  int get unlockedCount => badges.where((b) => b.isUnlocked).length;

  @override
  List<Object?> get props => [badges];
}

class BadgesErrorState extends BadgesState {
  final String message;

  const BadgesErrorState(this.message);

  @override
  List<Object?> get props => [message];
}
