import 'package:equatable/equatable.dart';

sealed class BadgesEvent extends Equatable {
  const BadgesEvent();

  @override
  List<Object?> get props => [];
}

class LoadBadgesEvent extends BadgesEvent {
  const LoadBadgesEvent();
}

class UnlockBadgeEvent extends BadgesEvent {
  final String badgeId;

  const UnlockBadgeEvent(this.badgeId);

  @override
  List<Object?> get props => [badgeId];
}
